package org.mypsycho.emf.modit.sirius.ui.action;

import java.util.Collection;
import java.util.function.Consumer;

import org.eclipse.emf.common.command.Command;
import org.eclipse.emf.common.command.CommandWrapper;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.edit.command.CommandActionDelegate;
import org.eclipse.emf.edit.command.CreateChildCommand;
import org.eclipse.emf.edit.domain.EditingDomain;
import org.eclipse.emf.edit.ui.action.CreateChildAction;
import org.eclipse.jface.viewers.ISelection;

/**
 * Action to create child action ensuring created child is fully initialized.
 *
 * @author nperansin
 * @since 2020-09-11
 */
public class ExtCreateChildAction extends CreateChildAction {

    private Consumer<EObject> afterCreated;
    private Consumer<EObject> onPerformed;
    private EObject created = null;

    /**
     * Default constructor.
     *
     * @param editingDomain of creation.
     * @param selection of creation.
     * @param descriptor of creation.
     * @param afterCreated task executed in command with freshly created element.
     * @param onPerformed task executed once command is performed.
     */
    public ExtCreateChildAction(EditingDomain editingDomain, ISelection selection,
            Object descriptor, Consumer<EObject> afterCreated, Consumer<EObject> onPerformed) {
        super(editingDomain, selection, descriptor);
        this.afterCreated = afterCreated;
        this.onPerformed = onPerformed;
    }
    

    /**
     * Default constructor.
     *
     * @param editingDomain of creation.
     * @param selection of creation.
     * @param descriptor of creation.
     * @param afterCreated task executed in command with freshly created element.
     * @param onPerformed task executed once command is performed.
     */
    public ExtCreateChildAction(EditingDomain editingDomain, ISelection selection,
            Object descriptor, Consumer<EObject> onPerformed) {
        this(editingDomain, selection, descriptor, null, onPerformed);
    }

    @Override
    protected Command createActionCommand(EditingDomain editingDomain,
            Collection<?> collection) {
        return new ExtendingWrapper(super.createActionCommand(editingDomain, collection));
    }

    @Override
    public void run() {
        super.run();

        if (created != null) {
            onPerformed.accept(created);
        }
    }

    /**
     * Wrapper with CommandActionDelegate implementation.
     * <p>
     * CommandActionDelegate is required by ChildCreationAction.
     * </p>
     */
    protected class ExtendingWrapper extends CommandWrapper implements CommandActionDelegate {

        /**
         * Default constructor.
         *
         * @param command to perform
         * @throws UnsupportedOperationException When command is not a
         *     CommandActionDelegate
         */
        public ExtendingWrapper(Command command) {
            super(command);
            if (!(command instanceof CommandActionDelegate)) {
                throw new UnsupportedOperationException();
            }
        }

        @Override
        public void execute() {
            if (command == null) {
                return;
            }
            command.execute();

            if (!(command instanceof CreateChildCommand)) {
                return;
            }

            Collection<?> createds = ((CreateChildCommand) command).getResult();
            if (createds.isEmpty() || afterCreated == null) {
                return;
            }

            Object value = createds.iterator().next();
            if (value instanceof EObject) {
                created = (EObject) value;
                afterCreated.accept(created);
            }

        }

        /**
         * Returns the command for which this is a proxy or decorator.
         * This may be <code>null</code> before {@link #createCommand} is called.
         *
         * @return the command for which this is a proxy or decorator.
         */
        protected CommandActionDelegate getDelegated() {
            return (CommandActionDelegate) getCommand();
        }

        @Override
        public Object getImage() {
            return getDelegated().getImage();
        }

        @Override
        public String getText() {
            return getDelegated().getText();
        }

        @Override
        public String getToolTipText() {
            return getDelegated().getToolTipText();
        }

    }
}
