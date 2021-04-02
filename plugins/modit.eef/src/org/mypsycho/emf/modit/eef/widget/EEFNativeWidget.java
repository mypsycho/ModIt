package org.mypsycho.emf.modit.eef.widget;

import java.util.Map;
import java.util.function.Supplier;

import org.eclipse.eef.common.ui.api.IEEFFormContainer;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Control;

/**
 * Interface of the widget builder for the EEF description.
 *
 * @author nperansin
 */
public interface EEFNativeWidget {
    
    /** Class parameter: used in description to target class to implement */
    String CLASS_PARAM = "native.class";

    /** Plug-in parameter: used in description to target bundle containing native class */
    String BUNDLE_PARAM = "native.bundle";

    /**
     * Provide access to EEF context.
     * <p>
     * This interface is implemented in EEFNativeWidgetLifecycleManager instance.
     * </p>
     */
    interface Access {
        
        /**
         * Return element
         *
         * @return the element
         */
        EObject getTarget();

        /**
         * Return the value by computing a value for parameter with specified id
         *
         * @param id Id of parameter
         * @return the value for the parameter
         */
        Object getValue(String id);

        /**
         * Return the parameter for the specified id
         *
         * @param id ID of the parameter
         * @return the parameter
         */
        String getParam(String id);

        /**
         * Execute the runnable in a transaction
         *
         * @param it runnable to execute
         */
        void perform(Runnable it);

        /**
         * Execute the supplier in a transaction and return the value
         *
         * @param <R> Expected return type
         * @param it Supplier to execute
         * @return the result returned by the supplier
         */
        <R> R perform(Supplier<R> it);

        /**
         * Execute the expression with specified id in a context filled with variables
         *
         * @param id Id of the expression to execute
         * @param vars Variables to put into execution context
         */
        void execute(String id, Map<? extends String, ?> vars);

        /**
         * Check if the widget is being refreshed by changes on the model
         *
         * @return true if widget is refreshed by model changes, false otherwise
         */
        boolean isInRefresh();
    }

    /**
     * The number of pixels of the additional gap necessary to draw the validation
     * marker.
     */
    int VALIDATION_MARKER_OFFSET = EEFNativeWidgetLifecycleManager.VALIDATION_HORIZONTAL_INDENT;

    /**
     * Refresh the widget given an access to EEF context
     *
     * @param it Access to EEF context
     */
    void refresh(Access it);

    /**
     * Create the widget
     *
     * @param parent Parent composite
     * @param formContainer EEF container
     * @return the widget
     */
    Control createControl(Composite parent, IEEFFormContainer formContainer);

    /**
     * Activates the widget: when the model has been changed.
     *
     * @param it Access to EEF context
     */
    void activate(Access it);

    /**
     * Deactivates the widget: when hidden.
     */
    void desactivate();

    /**
     * Enable/disable the widget.
     *
     * @param isEnabled value
     */
    void setEnabled(boolean isEnabled);

    /**
     * Returns true if the control will spawn on several lines.
     * <p>
     * This informations is only used for title alignment: False by default.
     * </p>
     *
     * @return true if multi lines.
     */
    default boolean isMultiLines() {
        return false;
    }

}

