/*******************************************************************************
 * Copyright (c) 2022 Nicolas PERANSIN.
 * This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License 2.0
 * which accompanies this distribution, and is available at
 * https://www.eclipse.org/legal/epl-2.0/
 *
 * SPDX-License-Identifier: EPL-2.0
 *
 * Contributors:
 *    Nicolas PERANSIN - initial API and implementation
 *******************************************************************************/
package org.mypsycho.emf.modit.sirius.ui.view;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.stream.Stream;

import org.eclipse.core.commands.operations.IUndoContext;
import org.eclipse.core.runtime.IAdaptable;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.workspace.IWorkspaceCommandStack;
import org.eclipse.jface.viewers.ISelection;
import org.eclipse.jface.viewers.ISelectionChangedListener;
import org.eclipse.jface.viewers.IStructuredSelection;
import org.eclipse.jface.viewers.SelectionChangedEvent;
import org.eclipse.jface.viewers.StructuredSelection;
import org.eclipse.sirius.business.api.session.Session;
import org.eclipse.sirius.ui.business.api.dialect.DialectEditor;
import org.eclipse.sirius.ui.tools.api.views.modelexplorerview.IModelExplorerView;
import org.eclipse.ui.IActionBars;
import org.eclipse.ui.IPartListener;
import org.eclipse.ui.IPartService;
import org.eclipse.ui.IWindowListener;
import org.eclipse.ui.IWorkbench;
import org.eclipse.ui.IWorkbenchPart;
import org.eclipse.ui.IWorkbenchWindow;
import org.eclipse.ui.PlatformUI;
import org.eclipse.ui.actions.ActionContext;
import org.eclipse.ui.actions.ActionFactory;
import org.eclipse.ui.actions.ActionGroup;
import org.eclipse.ui.navigator.CommonNavigator;
import org.eclipse.ui.operations.OperationHistoryActionHandler;
import org.eclipse.ui.operations.RedoActionHandler;
import org.eclipse.ui.operations.UndoActionHandler;
import org.eclipse.ui.services.IDisposable;
import org.eclipse.ui.views.properties.PropertySheet;
import org.eclipse.ui.views.properties.PropertyShowInContext;

/**
 *
 * - Enable undo/redo into Model Explorer: On opened Part {view = ModelExplorer}.
 * - Enable undo/redo into Properties: On Active Part {view = Properties}.
 *
 * @author nperansin
 */
public class PropertiesGlobalActionBinder implements IWindowListener, IDisposable {
	
	public PropertiesGlobalActionBinder() {
    	IWorkbench wb = PlatformUI.getWorkbench();
    	
    	wb.getDisplay().asyncExec(() ->{
    		wb.addWindowListener(this);
    		Stream.of(wb.getWorkbenchWindows()).forEach(it -> windowOpened(it));
    	});
	}
	
	@Override
	public void windowClosed(IWorkbenchWindow window) {
		// PagedActionGroup will disappear with pageservice.
	}

	@Override
	public void windowOpened(IWorkbenchWindow window) {
		new PagedActionGroup(window);
	}
	
	@Override
	public void windowActivated(IWorkbenchWindow window) {
	}

	@Override
	public void windowDeactivated(IWorkbenchWindow window) {
	}

	
	@Override
	public void dispose() {
    	IWorkbench wb = PlatformUI.getWorkbench();
    	
    	if (!wb.isClosing()) {
    	   	wb.getDisplay().asyncExec(() ->{
        		wb.removeWindowListener(this);
        		Stream.of(wb.getWorkbenchWindows()).forEach(it -> windowClosed(it));
        	});
    	}
	}
	
	
	class PagedActionGroup extends ActionGroup implements IPartListener {

	    private final Map<ActionFactory, OperationHistoryActionHandler> actions = new HashMap<>();
	    CommonNavigator view;
	    
	    // 
	    private final ISelectionChangedListener viewSelectionManager = event -> {
	        setContext(new ActionContext(event.getSelection()));
	        updateActionBars();
	    };
	    
	    IWorkbenchWindow parent;
		public PagedActionGroup(IWorkbenchWindow parent) {
			this.parent = parent;
		
			IPartService parts = parent.getPartService();
			parts.addPartListener(this);
			
			// Initialize.
			Stream.of(parent.getPages())
				.flatMap(it -> Stream.of(it.getViewReferences()))
				.map(it -> it.getPart(false))
				.filter(Objects::nonNull)
				.forEach(it -> partOpened(it));
			
			partActivated(parts.getActivePartReference().getPart(false));
		}
		
		@Override
		public void partActivated(IWorkbenchPart part) {
	        if (!(part instanceof PropertySheet)) {
	        	return;
	        }
	        PropertySheet sheet = (PropertySheet) part;
            PropertyShowInContext context = (PropertyShowInContext) sheet.getShowInContext();
            IWorkbenchPart selectionOwner = context.getPart();
            ISelection selected = context.getSelection();

            if (selected == null
                || selected.isEmpty()
                || !(selected instanceof IStructuredSelection)) {
                // Avoid text selection for example
                return;
            }

            IStructuredSelection selection = null;
            
            if (isModelExplorer(selectionOwner)) {
            	selection = (IStructuredSelection) selected;
            } else if (selectionOwner instanceof DialectEditor) {
                //if the current selection is defined by a diagram or a table
                //we do not directly have access to the EObjects
            	selection = new StructuredSelection(getEObjectsFromSelection(selection));
            }
            
            if (selection != null) {
            	IActionBars actionBars = sheet.getViewSite().getActionBars();
            	updateActionsContext(selection, actionBars);
            }
		}
	
		@Override
		public void partOpened(IWorkbenchPart part) {
			if (!isModelExplorer(part)) {
				return;
			}
			view = (CommonNavigator) part;
			view.getCommonViewer().addSelectionChangedListener(viewSelectionManager);
			
	    	setContext(new ActionContext(StructuredSelection.EMPTY));
	        IUndoContext operationContext = getSelectedOperationContext();
	        actions.put(ActionFactory.UNDO, new UndoActionHandler(part.getSite(), operationContext));
	        actions.put(ActionFactory.REDO, new RedoActionHandler(part.getSite(), operationContext));
	        
	        viewSelectionManager.selectionChanged(new SelectionChangedEvent(
	        		view.getCommonViewer(), 
	        		view.getCommonViewer().getSelection()));

	        partActivated(part.getSite().getPage().getActivePart());
		}
	
		
		@Override
		public void partBroughtToTop(IWorkbenchPart part) {
		}
	
		@Override
		public void partClosed(IWorkbenchPart part) {
			if (part == view) {
				actions.clear();
				view.getCommonViewer().removeSelectionChangedListener(viewSelectionManager);
				view = null;
			}
		}
	
		@Override
		public void partDeactivated(IWorkbenchPart part) {
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

	    /**
	     * Update the context of the actions.
	     *
	     * @param selection the current selection
	     * @param actionBars the action bars to fill
	     */
	    public void updateActionsContext(IStructuredSelection selection, IActionBars actionBars) {
	        setContext(new ActionContext(selection));
	        updateActionBars();
	        fillActionBars(actionBars); // Should we at this time ?
	    }
		
	    
	    private IUndoContext getSelectedOperationContext() {
	        IStructuredSelection selection = (IStructuredSelection) getContext().getSelection();
	        if (selection.isEmpty() || selection.size() > 1) {
	            return NO_SELECTION_CONTEXT;
	        }
	        
	        return Optional.of(selection.getFirstElement())
	        	.filter(EObject.class::isInstance)
	        	.flatMap(it -> Session.of((EObject) it))
	        	.map(it -> it.getTransactionalEditingDomain())
	        	.filter(it -> it.getCommandStack() instanceof IWorkspaceCommandStack)
	        	.map(it -> ((IWorkspaceCommandStack) it.getCommandStack()).getDefaultUndoContext())
	        	.orElse(NO_SELECTION_CONTEXT);
	    }
	};
	
	
	static boolean isModelExplorer(IWorkbenchPart part) {
		return IModelExplorerView.ID.equals(part.getSite().getId()) 
				&& part instanceof CommonNavigator;
	}
	
	
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


    public static EObject[] getEObjectsFromSelection(
            IStructuredSelection selection) {
        return ((List<?>) selection.toList()).stream()
                .map(it -> {
                    if (it instanceof EObject) {
                        return it;
                    } else if (it instanceof IAdaptable) {
                        return ((IAdaptable) it).getAdapter(EObject.class);
                    } else {
                    	return null;
                    }
                })
               .filter(EObject.class::isInstance) // <=> non-null
               .map(EObject.class::cast)
	           .filter(Objects::nonNull)
	           .toArray(EObject[]::new);
    }


	
}
