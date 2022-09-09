/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2012-2020. All rights reserved.
 */

package com.huawei.sirius.autosar.ui.handlers;

import java.util.HashMap;
import java.util.Map;

import org.eclipse.core.commands.operations.IUndoContext;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.transaction.TransactionalEditingDomain;
import org.eclipse.emf.workspace.IWorkspaceCommandStack;
import org.eclipse.jface.viewers.ISelection;
import org.eclipse.jface.viewers.ISelectionChangedListener;
import org.eclipse.jface.viewers.IStructuredSelection;
import org.eclipse.jface.viewers.StructuredSelection;
import org.eclipse.sirius.business.api.session.Session;
import org.eclipse.sirius.business.api.session.SessionManager;
import org.eclipse.sirius.ui.business.api.dialect.DialectEditor;
import org.eclipse.ui.IActionBars;
import org.eclipse.ui.IPartListener;
import org.eclipse.ui.IWorkbenchPart;
import org.eclipse.ui.actions.ActionContext;
import org.eclipse.ui.actions.ActionFactory;
import org.eclipse.ui.actions.ActionGroup;
import org.eclipse.ui.operations.OperationHistoryActionHandler;
import org.eclipse.ui.operations.RedoActionHandler;
import org.eclipse.ui.operations.UndoActionHandler;
import org.eclipse.ui.views.properties.PropertySheet;
import org.eclipse.ui.views.properties.PropertyShowInContext;

import com.huawei.sirius.autosar.core.tree.node.TreeNode;
import com.huawei.sirius.autosar.ui.views.AbstractExplorerView;
import com.huawei.sirius.common.EcoreUtil2;

/**
 * Connect undo/redo of session with Eclipse UI menus.
 *
 * @author nperansin
 * @since 2020-07-06
 */
public class UndoRedoActionProvider extends ActionGroup {
    private static final IUndoContext NO_SELECTION_CONTEXT = new IUndoContext() {
        @Override
        public String getLabel() {
            return "Empty Selection Context";
        }

        @Override
        public boolean matches(IUndoContext context) {
            return context == NO_SELECTION_CONTEXT;
        }
    };

    private final Map<ActionFactory, OperationHistoryActionHandler> actions = new HashMap<>();

    private AbstractExplorerView view = null;

    private final ISelectionChangedListener selectionManager = event -> {
        setContext(new ActionContext(event.getSelection()));
        updateActionBars();
    };

    /**
     * This listens for when the properties view becomes active and updates the
     * context of the {@link UndoRedoActionProvider}. This allows the user to have
     * access to the undo/redo in the properties view.
     */
    protected IPartListener propertyViewHandler = new IPartListener() {
        @Override
        public void partActivated(IWorkbenchPart p) {
            if (p instanceof PropertySheet) {
                activatePropertiesView((PropertySheet) p);
            }
        }

        @Override
        public void partBroughtToTop(IWorkbenchPart p) {
            // Ignore.
        }

        @Override
        public void partClosed(IWorkbenchPart p) {
            // Ignore.
        }

        @Override
        public void partDeactivated(IWorkbenchPart p) {
            // Ignore.
        }

        @Override
        public void partOpened(IWorkbenchPart p) {
            // Ignore.
        }
    };

    /**
     * Initialize the action provider with this view.
     *
     * @param view to bind to
     */
    public void init(AbstractExplorerView view) {
        this.view = view;
        setContext(new ActionContext(view.getTree().getSelection()));

        IUndoContext operationContext = getSelectedOperationContext();
        actions.put(ActionFactory.UNDO, new UndoActionHandler(view.getSite(), operationContext));
        actions.put(ActionFactory.REDO, new RedoActionHandler(view.getSite(), operationContext));

        view.getTree().addSelectionChangedListener(selectionManager);
        view.getSite().getPage().addPartListener(propertyViewHandler);

        fillActionBars(view.getViewSite().getActionBars());
    }

    private void activatePropertiesView(PropertySheet sheet) {
        PropertyShowInContext context = (PropertyShowInContext) sheet.getShowInContext();
        IWorkbenchPart selectionOwner = context.getPart();
        ISelection selected = context.getSelection();

        if (selected == null
            || selected.isEmpty()
            || !(selected instanceof IStructuredSelection)) {
            // Avoid text selection for example
            return;
        }

        IStructuredSelection selection = (IStructuredSelection) selected;

        IActionBars actionBars = sheet.getViewSite().getActionBars();
        if (selectionOwner == view) {
            updateActionsContext(selection, actionBars);
        }
        if (selectionOwner instanceof DialectEditor) {
            //if the current selection is defined by a diagram or a table
            //we do not directly have access to the EObjects
            EObject[] eobjectSelection = EcoreUtil2
                .getEObjectsFromSelection(selection);
            selection = new StructuredSelection(eobjectSelection);
            updateActionsContext(selection, actionBars);
        }

    }

    @Override
    public void dispose() {
        actions.clear();
        if (view != null) {
            if (view.getTree() != null) {
                view.getTree().removeSelectionChangedListener(selectionManager);
            }
            if (view.getSite() != null) {
                view.getSite().getPage().removePartListener(propertyViewHandler);
            }
        }
        super.dispose();
    }

    @Override
    public void fillActionBars(IActionBars actionBars) {
        actions.forEach((id, action) -> actionBars.setGlobalActionHandler(id.getId(), action));
    }

    @Override
    public void updateActionBars() {
        IUndoContext operationContext = getSelectedOperationContext();
        actions.forEach((id, action) -> action.setContext(operationContext));
    }

    private IUndoContext getSelectedOperationContext() {
        IStructuredSelection selection = (IStructuredSelection) getContext().getSelection();
        if (selection.isEmpty() || selection.size() > 1) {
            return NO_SELECTION_CONTEXT;
        }
        Object selected = selection.getFirstElement();
        Session session;
        if (selected instanceof TreeNode<?>) {
            session = ((TreeNode<?>) selected).getSession();
        } else if (selected instanceof EObject) {
            session = SessionManager.INSTANCE.getSession((EObject) selected);
        } else {
            return NO_SELECTION_CONTEXT;
        }

        if (session == null) {
            return NO_SELECTION_CONTEXT;
        }

        TransactionalEditingDomain edtDomain = session.getTransactionalEditingDomain();
        if (edtDomain != null && edtDomain.getCommandStack() instanceof IWorkspaceCommandStack) {
            return ((IWorkspaceCommandStack) edtDomain.getCommandStack()).getDefaultUndoContext();
        } else {
            return NO_SELECTION_CONTEXT;
        }
    }

    /**
     * Update the context of the actions.
     *
     * @param selection the current selection
     * @param actionBars the action bars to fill
     */
    public void updateActionsContext(IStructuredSelection selection, IActionBars actionBars) {
        setContext(new ActionContext(selection));
        updateActionBars();
        fillActionBars(actionBars);
    }
}
