package org.mypsycho.emf.modit.eef.widget;

import java.lang.reflect.InvocationTargetException;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import java.util.concurrent.atomic.AtomicReference;
import java.util.function.Supplier;

import org.eclipse.core.runtime.Platform;
import org.eclipse.eef.EEFControlDescription;
import org.eclipse.eef.EEFCustomExpression;
import org.eclipse.eef.EEFCustomWidgetDescription;
import org.eclipse.eef.EEFWidgetDescription;
import org.eclipse.eef.common.ui.api.IEEFFormContainer;
import org.eclipse.eef.core.api.EditingContextAdapter;
import org.eclipse.eef.core.api.controllers.AbstractEEFCustomWidgetController;
import org.eclipse.eef.core.api.utils.EvalFactory;
import org.eclipse.eef.ide.ui.api.widgets.AbstractEEFWidgetLifecycleManager;
import org.eclipse.eef.ide.ui.api.widgets.EEFStyleHelper;
import org.eclipse.eef.ide.ui.api.widgets.IEEFLifecycleManager;
import org.eclipse.eef.ide.ui.api.widgets.IEEFLifecycleManagerProvider;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.sirius.common.interpreter.api.IInterpreter;
import org.eclipse.sirius.common.interpreter.api.IVariableManager;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Control;
import org.osgi.framework.Bundle;

/**
 * Lifecycle Manager for EEF custom widget using Eclipse classloader.
 *
 * @author nperansin
 */
public class EEFNativeWidgetLifecycleManager extends AbstractEEFWidgetLifecycleManager {
    

    /**
     * Return the custom expression with specified ID in the description
     *
     * @param descr EEF custom widget description
     * @param id ID of the expression to retrieve
     * @return the custom expression
     */
    protected static String getCustomExpression(EEFCustomWidgetDescription descr, String id) {
        return descr.getCustomExpressions().stream()
            .filter(param -> id.equals(param.getIdentifier()))
            .map(EEFCustomExpression::getCustomExpression).findFirst().orElse(null);
    }

    /**
     * Provider of EEFNativeWidgetLifecycleManager.
     * <p>
     * Detect EEFCustomWidgetDescription with required properties.
     * </p>
     */
    public static class Provider implements IEEFLifecycleManagerProvider {
       
        @Override
        public boolean canHandle(EEFControlDescription it) {
            if (!(it instanceof EEFCustomWidgetDescription)) {
                return false;
            }
            EEFCustomWidgetDescription descr = (EEFCustomWidgetDescription) it;

            return getCustomExpression(descr, EEFNativeWidget.CLASS_PARAM) != null
                && getCustomExpression(descr, EEFNativeWidget.BUNDLE_PARAM) != null;
        }

        @Override
        public IEEFLifecycleManager getLifecycleManager(EEFControlDescription controlDescription,
                IVariableManager variableManager, IInterpreter interpreter,
                EditingContextAdapter editingContextAdapter) {
            /* invocation is protected by #canHandle */
            return new EEFNativeWidgetLifecycleManager(EEFCustomWidgetDescription.class.cast(controlDescription),
                variableManager, interpreter, editingContextAdapter);
        }
    }
    
    /**
     * The number of pixels of the additional gap necessary to draw the validation
     * marker.
     */
    protected static final int VALIDATION_HORIZONTAL_INDENT = VALIDATION_MARKER_OFFSET;

    private EEFCustomWidgetDescription description;

    private Controller controller;

    private Control widget;

    /**
     * Constructor used by EefCustomLifecycleManagerProvider.
     *
     * @param description to instantiate
     * @param variableManager from EEF
     * @param interpreter to evaluate expression
     * @param editingContextAdapter to access editing domain
     */
    public EEFNativeWidgetLifecycleManager(EEFCustomWidgetDescription description,
            IVariableManager variableManager, IInterpreter interpreter,
            EditingContextAdapter editingContextAdapter) {
        super(variableManager, interpreter, editingContextAdapter);
        this.description = description;
    }

    /**
     * Log an error
     *
     * @param message Error message
     * @param cause Original cause
     */
    protected static void logError(String message, Throwable cause) {
        EEFNativeActivator.logError(message, cause);
    }


    @Override
    public void createControl(Composite parent, IEEFFormContainer formContainer) {
        // Implementation is needed to handle title layout.
        //
        // AbstractEEFWidgetController is not connected to life-cycle but with a callback.
        controller = new Controller(createImplementation());
        super.createControl(parent, formContainer);
    }

    @Override
    protected void createMainControl(Composite parent, IEEFFormContainer formContainer) {
        widget = controller.getImplementation().createControl(parent, formContainer);
    }

    private EEFNativeWidget createImplementation() {
        // create a widget using parent + container.getWidgetFactory()
        // To paint the borders, use paintBordersFor(parent) on widgetFactory
        // Finish by creating a controller containing widget reference.

        String bundleName = getCustomExpression(description,
            EEFNativeWidget.BUNDLE_PARAM);
        Bundle bundle = Platform.getBundle(bundleName);
        if (bundle == null) {
            return createFailedImplementation("Bundle " + bundleName + " does not exist", null);
        }
        String classname = getCustomExpression(description,
            EEFNativeWidget.CLASS_PARAM);

        try {
            Class<?> widgetClass = bundle.loadClass(classname);
            return EEFNativeWidget.class.cast(widgetClass.getConstructor().newInstance());

        } catch (ClassNotFoundException e) {
            return createFailedImplementation(classname + " cannot be found", e);
        } catch (InstantiationException 
        		| IllegalAccessException 
        		| NoSuchMethodException
        		| IllegalArgumentException 
        		| InvocationTargetException
        		| SecurityException
        		e) {
            logError(classname + " cannot be instantiated", e);
            return createFailedImplementation(classname + " cannot be instantiated", e);
        } catch (ClassCastException e) {
            return createFailedImplementation(
                classname + " does not implement " + EEFNativeWidget.class.getSimpleName(), e);
		}
    }

    private EEFNativeWidget createFailedImplementation(String message, Throwable detail) {
        logError(message, detail);
        return new EEFNativeFailure(message);
    }

    @Override
    protected int getLabelVerticalAlignment() {
        // Default is not centered.
        return controller.getImplementation().isMultiLines()
            ? GridData.VERTICAL_ALIGN_BEGINNING
            : GridData.VERTICAL_ALIGN_CENTER;
    }


    @Override
    protected Controller getController() {
        return controller;
    }

    @Override
    protected Control getValidationControl() {
        return widget;
    }

    @Override
    protected EEFWidgetDescription getWidgetDescription() {
        return description;
    }

    @Override
    protected EEFStyleHelper getEEFStyleHelper() {
        // This looks like a bug: missing sub-case of CustomWidgetDescription
        return new EEFCustomStyleHelper(interpreter, variableManager);
    }

    @Override
    protected void setEnabled(boolean enable) {
        getController().getImplementation().setEnabled(enable);
    }

    @Override
    public void aboutToBeShown() {
        super.aboutToBeShown();
        getController().getImplementation().activate(controller);
    }

    @Override
    public void aboutToBeHidden() {
        // remove listener
        // remove refreshCallback
        getController().getImplementation().desactivate();

        super.aboutToBeHidden();
    }

    private class Controller extends AbstractEEFCustomWidgetController
            implements EEFNativeWidget.Access {

        /* reflective */
        private EEFNativeWidget implementation;

        /**
         * Default constructor.
         *
         * @param impl to control
         */
        public Controller(EEFNativeWidget impl) {
            super(EEFNativeWidgetLifecycleManager.this.description,
                EEFNativeWidgetLifecycleManager.this.variableManager,
                EEFNativeWidgetLifecycleManager.this.interpreter,
                EEFNativeWidgetLifecycleManager.this.editingContextAdapter);
            implementation = impl;
        }

        /**
         * Returns the implementation.
         *
         * @return the implementation
         */
        private EEFNativeWidget getImplementation() {
            return implementation;
        }

        @Override
        protected EEFCustomWidgetDescription getDescription() {
            return description;
        }

        @Override
        public void refresh() {
            // called by AbstractEEFWidgetLifecycleManager refresh
            super.refresh(); // label

            implementation.refresh(this);
        }

        @Override
        public Object getValue(String id) {
            Optional<String> param = getCustomExpression(id);
            return param.isPresent()
                ? newEval().evaluate(param.get())
                : null;
        }

        @Override
        public EObject getTarget() {
            return EObject.class.cast(getWidgetSemanticElement());
        }

        @Override
        public String getParam(String id) {
            return getCustomExpression(id).orElse(null);
        }

        @Override
        public void perform(Runnable it) {
            editingContextAdapter.performModelChange(it);
        }

        @Override
        public <R> R perform(Supplier<R> it) {
            AtomicReference<R> result = new AtomicReference<>();
            editingContextAdapter.performModelChange(() -> result.set(it.get()));
            return result.get();
        }

        @Override
        public void execute(String id, Map<? extends String, ?> vars) {
            // for value or operation, we only have 1 API.
            String onClickExpression = getCustomExpression(id).get();

            Map<String, Object> context;
            if (vars == null || vars.isEmpty()) {
                context = variableManager.getVariables();
            } else {
                context = new HashMap<>();
                context.putAll(variableManager.getVariables());
                context.putAll(vars);
            }

            EvalFactory.of(interpreter, context).call(onClickExpression);
        }

        @Override
        public boolean isInRefresh() {
            return container.isRenderingInProgress();
        }

    }
}
