package org.mypsycho.emf.modit.sirius.ui.internal.navigator;

import java.util.List;

import org.eclipse.core.resources.IFile;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.jface.action.IMenuManager;
import org.eclipse.jface.viewers.ISelection;
import org.eclipse.jface.viewers.IStructuredSelection;
import org.eclipse.sirius.business.api.session.Session;
import org.eclipse.sirius.business.api.session.SessionManager;
import org.eclipse.ui.navigator.CommonActionProvider;
import org.mypsycho.emf.modit.sirius.ui.navigator.ModellingActionProvider;

/**
 * Add editing actions in "Model Explorer" view.
 * <p>
 * 
 * </p>
 *
 * @author nperansin
 */
public class EditingActionProvider extends CommonActionProvider {

    private static final String AIRD_EXTENSION = "aird";
	
    @Override
    public void fillContextMenu(final IMenuManager menu) {
        ISelection ctxtSel = getContext().getSelection();
        if (ctxtSel.isEmpty() && !(ctxtSel instanceof IStructuredSelection)) {
            return;
        }
        IStructuredSelection selection = (IStructuredSelection) ctxtSel;
        
        List<?> selecteds = selection.toList();
        
        if (!fillEObjectContextMenu(menu, selecteds, selection)) {
        	fillSessionContextMenu(menu, selecteds, selection);
        }
    }

    public boolean fillEObjectContextMenu(IMenuManager menu, List<?> selectedObjects, IStructuredSelection selection) {
        // action can only happen on 1 session.
        Session foundSession = null;
        // ensure only 1 session and only EObjects.
        for (Object selected : selectedObjects) {
        	if (!(selected instanceof EObject)) {
        		return false; // abort
        	}
        	Session currentSession = Session.of((EObject) selected).orElse(null);
        	if (currentSession == null) {
        		return false;
        	} else if (foundSession == null) { // 1srt element
        		foundSession = currentSession;
        	} else if (foundSession != currentSession) {
        		return false; // only 1 editing domain
        	}        	
        }
        
        if (foundSession == null) {
        	return false;
        }
        
        @SuppressWarnings("unchecked")
		List<? extends EObject> safeList = ((List<EObject>) selectedObjects);
        
        ModellingActionProvider provider = MenuActionRegistry.getProvider(foundSession);
        
        if (provider != null) {
        	provider.fillEObjectsMenu(menu, foundSession, safeList, selection);
        }
        return true;
        
    }
    
    public boolean fillSessionContextMenu(IMenuManager menu, List<?> selecteds, IStructuredSelection selection) {
        
        if (selecteds.size() != 1 
        		|| !(selecteds.get(0) instanceof IFile)) { // or adaptable ?
        	return false;
        }
        
        IFile selected = (IFile) selecteds.get(0);
        if (!AIRD_EXTENSION.equals(selected.getFileExtension())) {
        	return false;
        }
        URI uri = URI.createPlatformResourceURI(selected.getFullPath().toString(), true);
        Session session = SessionManager.INSTANCE.getExistingSession(uri);
        if (session == null) {
        	return true;
        }
        ModellingActionProvider provider = MenuActionRegistry.getProvider(session);
        if (provider != null) {
        	provider.fillSessionMenu(menu, session, selection);
        }
        return true;
    }
    

    // Contribute in CNF with 
    // ISaveablePart, ISaveablesSource, IShowInTarget
    // See org.eclipse.ui.navigator.CommonNavigator class
    // abstraction of org.eclipse.sirius.ui.tools.internal.views.modelexplorer.ModelExplorerView
    
    
}