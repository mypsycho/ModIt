package org.mypsycho.emf.modit.sirius.ui.internal.navigator;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.edit.domain.EditingDomain;
import org.eclipse.emf.edit.ui.action.CommandActionHandler;
import org.eclipse.emf.edit.ui.action.CopyAction;
import org.eclipse.emf.edit.ui.action.CreateChildAction;
import org.eclipse.emf.edit.ui.action.CutAction;
import org.eclipse.emf.edit.ui.action.DeleteAction;
import org.eclipse.emf.edit.ui.action.PasteAction;
import org.eclipse.emf.edit.ui.action.RedoAction;
import org.eclipse.emf.edit.ui.action.UndoAction;
import org.eclipse.jface.action.Action;
import org.eclipse.jface.action.IMenuManager;
import org.eclipse.jface.action.MenuManager;
import org.eclipse.jface.action.Separator;
import org.eclipse.jface.viewers.ISelection;
import org.eclipse.jface.viewers.IStructuredSelection;
import org.eclipse.sirius.business.api.session.Session;
import org.eclipse.sirius.viewpoint.DRepresentationDescriptor;
import org.eclipse.sirius.viewpoint.description.Group;
import org.eclipse.ui.ISharedImages;
import org.eclipse.ui.PlatformUI;
import org.eclipse.ui.navigator.CommonActionProvider;
import org.mypsycho.emf.modit.sirius.ui.siriusuiextension.ExplorerEditionExtension;

/**
 * <p>
 * Reusing org.eclipse.sirius.ui.tools.internal.views.common.navigator.ManageSessionActionProvider
 * to add action of org.eclipse.sirius.ui.editor.internal.graphicalcomponents.GraphicalSemanticModelsHandler
 * </p>
 *
 * @author nperansin
 */
public class EditingActionProvider extends CommonActionProvider {

    // private ContextMenuFiller contextMenuFiller;
	static private Map<Class<?extends Action>, String> ACTION_IMAGES = new HashMap<>();
	
	// Group provided by ManageSessionActionProvider
	private static final String GROUP_EDIT = "group.edit"; //$NON-NLS-1$
    private static final String GROUP_NEW = "group.new"; //$NON-NLS-1$

	
	static {
		ACTION_IMAGES.put(UndoAction.class, ISharedImages.IMG_TOOL_UNDO);
		ACTION_IMAGES.put(RedoAction.class, ISharedImages.IMG_TOOL_REDO);
		
		ACTION_IMAGES.put(CutAction.class, ISharedImages.IMG_TOOL_CUT);
		ACTION_IMAGES.put(CopyAction.class, ISharedImages.IMG_TOOL_COPY);
		ACTION_IMAGES.put(PasteAction.class, ISharedImages.IMG_TOOL_PASTE);
		// TODO move ?
		// TODO rearrange
		// TODO refactor type.
		ACTION_IMAGES.put(DeleteAction.class, ISharedImages.IMG_TOOL_DELETE);
		
		// TODO session: save, close (resource aird ??)
	}

    
    static <T extends Action> T initSharedImage(T action) {
    	// share image access is fast enough
    	ISharedImages sharedImages = PlatformUI.getWorkbench().getSharedImages();
    	action.setImageDescriptor(sharedImages.getImageDescriptor(ACTION_IMAGES.get(action.getClass())));
    	return action;
    }
    
    /**
     * 
     * {@inheritDoc}
     * 
     * @see org.eclipse.ui.actions.ActionGroup#fillContextMenu(org.eclipse.jface.action.IMenuManager)
     */
    @Override
    public void fillContextMenu(final IMenuManager menu) {
        ISelection ctxtSel = getContext().getSelection();
        if (ctxtSel.isEmpty() && !(ctxtSel instanceof IStructuredSelection)) {
            return;
        }
        IStructuredSelection selection = (IStructuredSelection) ctxtSel;
        
        List<?> selectedObjects = selection.toList();
        
        // action can only happen on 1 session.
        Session foundSession = null;
        // ensure only 1 session and only EObjects.
        for (Object selected : selectedObjects) {
        	if (!(selected instanceof EObject) || selected instanceof DRepresentationDescriptor) {
        		return; // abort
        	}
        	Session currentSession = Session.of((EObject) selected).orElse(null);
        	if (currentSession == null) {
        		return;
        	} else if (foundSession == null) { // 1srt element
        		foundSession = currentSession;
        	} else if (foundSession != currentSession) {
        		return; // only 1 editing domain
        	}        	
        }
        // Here session cannot be null (selection is valid)
        // foundSession.getSelectedViewpoints(false)

        // @formatter:off
        if (!foundSession.getSelectedViewpoints(false).stream() // or true ??
                .map(it -> eContainer(it, Group.class))
                .filter(Objects::nonNull)
                .flatMap(it -> it.getExtensions().stream())
                .anyMatch(ExplorerEditionExtension.class::isInstance)) {
        	return;
        }
        
        EditingDomain edtDomain = foundSession.getTransactionalEditingDomain();
      
        UndoAction undo = initSharedImage(new UndoAction(edtDomain));
        RedoAction redo = initSharedImage(new RedoAction(edtDomain));
        
        CutAction cut  = initSharedImage(new CutAction(edtDomain));
        CopyAction copy = initSharedImage(new CopyAction(edtDomain));
        PasteAction paste = initSharedImage(new PasteAction(edtDomain));
        DeleteAction delete = initSharedImage(new DeleteAction(edtDomain));
        
        if (selectedObjects.size() == 1) {
            // // Add the edit menu actions.
            MenuManager childMenu = new MenuManager("&New Child"); //$NON-NLS-1$
            edtDomain.getNewChildDescriptors(selectedObjects.get(0), null) 
            	// no addAll in MenuManager.
    			.forEach(it -> childMenu.add(new CreateChildAction(edtDomain, selection, it)));
            // Before new representation.
            menu.prependToGroup(GROUP_NEW, childMenu);
        }
        
        Arrays.asList(// Add to edit group 
        		undo, redo, // 
        		null, // separator is not an action
        		cut, copy, paste, //
        		null, 
        		delete, //
        		null).forEach(it -> {
        	if (it instanceof CommandActionHandler) {
        		((CommandActionHandler) it).updateSelection(selection);
        	}
        	if (it == null) {
        		menu.appendToGroup(GROUP_EDIT, new Separator());
        	} else {
        		menu.appendToGroup(GROUP_EDIT, it);
        	}
        	
        });

        // no need to clean the menu: menu closing is before action call anyway.
    }

    
	/**
	 * Returns the ancestor matching provided type.
	 * 
	 * @param it to look into
	 * @param type of expected ancestor
	 * @return first matching ancestor or null
	 */
    // Why is it not in EcoreUtil already ?: every projects use it.
	@SuppressWarnings("unchecked")
	static <T> T eContainer(EObject it, Class<T> type) {
		EObject result = it.eContainer();
		return (result == null || type.isInstance(result)) ? 
				(T) result : eContainer(result, type);
	}
}