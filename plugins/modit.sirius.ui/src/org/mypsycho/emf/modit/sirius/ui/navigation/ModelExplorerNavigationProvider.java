package org.mypsycho.emf.modit.sirius.ui.navigation;

import java.util.NoSuchElementException;
import java.util.Objects;
import java.util.Optional;

import org.eclipse.core.resources.IFile;
import org.eclipse.core.resources.IWorkspace;
import org.eclipse.core.resources.IWorkspaceRoot;
import org.eclipse.core.resources.ResourcesPlugin;
import org.eclipse.core.runtime.ILog;
import org.eclipse.core.runtime.IPath;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.core.runtime.NullProgressMonitor;
import org.eclipse.core.runtime.Path;
import org.eclipse.core.runtime.Platform;
import org.eclipse.emf.common.ui.URIEditorInput;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.util.EcoreUtil;
import org.eclipse.jface.viewers.ISelectionChangedListener;
import org.eclipse.jface.viewers.SelectionChangedEvent;
import org.eclipse.jface.viewers.StructuredSelection;
import org.eclipse.sirius.business.api.session.Session;
import org.eclipse.sirius.business.api.session.SessionManager;
import org.eclipse.sirius.ext.emf.edit.EditingDomainServices;
import org.eclipse.sirius.ui.tools.api.views.modelexplorerview.IModelExplorerView;
import org.eclipse.swt.graphics.Image;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.ui.IEditorInput;
import org.eclipse.ui.IEditorPart;
import org.eclipse.ui.IEditorSite;
import org.eclipse.ui.IMemento;
import org.eclipse.ui.INavigationLocation;
import org.eclipse.ui.INavigationLocationProvider;
import org.eclipse.ui.IPathEditorInput;
import org.eclipse.ui.IPropertyListener;
import org.eclipse.ui.IWorkbenchPartSite;
import org.eclipse.ui.PartInitException;
import org.eclipse.ui.navigator.CommonNavigator;


/**
 * Provide navigation history for .
 * <p>
 * TODO register for 
 * </p>
 *
 * @author nperansin
 */
public class ModelExplorerNavigationProvider
        implements INavigationLocationProvider, ISelectionChangedListener, IEditorPart {
	
	private static final ILog LOG = Platform.getLog(ModelExplorerNavigationProvider.class);
    
	private static final EditingDomainServices EDS = new EditingDomainServices();
	
	/** Input for view */
    public static final IEditorInput DUMMY_INPUT = new URIEditorInput(URI.createURI("view:" + IModelExplorerView.ID));

    /** widget containing selection to navigate through */
    protected CommonNavigator view;

    /** Flag to detect an user selection or change from history */
    protected boolean inHistory = false;

    @Override
    public INavigationLocation createEmptyNavigationLocation() {
        // This is used only be tab navigation which is not enabled.
        return new ExplorerLocation(null);
    }

    /**
     * TODO: 
     * Create a listener in CommonTreeViewer, and call 
     * page.getNavigationHistory().markLocation("this");
     * --
     * only call it for none null selection.
     */
    @Override
    public INavigationLocation createNavigationLocation() {
    	Object selection = view.getCommonViewer().getStructuredSelection().getFirstElement();
    	
        // Fetch Session, 
        return selection instanceof EObject 
        		? new ExplorerLocation((EObject) selection)
        		: new ExplorerLocation(null); // Should not happen
    }


    @Override
    public void selectionChanged(SelectionChangedEvent event) {
        if (inHistory || event.getSelection().isEmpty()) {
            // Selection change when calling #restoreLocation
            return;
        }
        // NavigationHistory will call #createNavigationLocation to store location
        view.getSite().getPage().getNavigationHistory().markLocation(this);
    }

    /**
     * Initialize the navigation provider.
     *
     * @param context of navigation
     */
    public void init(CommonNavigator context) {
        view = context;
        view.getCommonViewer().addSelectionChangedListener(this);
    }

    /**
     * Disconnect the provider from used elements.
     */
    @Override
    public void dispose() {
        view.getCommonViewer().removeSelectionChangedListener(this);
    }

    @Override
    public IWorkbenchPartSite getSite() {
        return view.getSite();
    }

    // IEditorPart contract required by

    @Override
    public void addPropertyListener(IPropertyListener listener) {
        view.addPropertyListener(listener);
    }

    @Override
    public void removePropertyListener(IPropertyListener listener) {
        view.removePropertyListener(listener);
    }

    @Override
    public String getTitle() {
        return view.getTitle();
    }

    @Override
    public Image getTitleImage() {
        return view.getTitleImage();
    }

    @Override
    public String getTitleToolTip() {
        return view.getTitleToolTip();
    }

    @Override
    public void setFocus() {
        view.setFocus();
    }

    @Override
    public <T> T getAdapter(Class<T> type) {
        return view.getAdapter(type);
    }

    @Override
    public void doSave(IProgressMonitor monitor) {
        view.doSave(monitor);
    }

    @Override
    public void doSaveAs() {
        view.doSaveAs();
    }

    @Override
    public boolean isDirty() {
        return view.isDirty();
    }

    @Override
    public boolean isSaveAsAllowed() {
        return view.isSaveAsAllowed();
    }

    @Override
    public boolean isSaveOnCloseNeeded() {
        return view.isSaveAsAllowed();
    }

    @Override
    public IEditorInput getEditorInput() {
    	Object selected = view.getCommonViewer().getStructuredSelection().getFirstElement();
    	
    	if (!(selected instanceof EObject)) {
    		return DUMMY_INPUT;
    	}
    	
    	Session session = Session.of((EObject) selected).get();
    	
        return new PseudoInput(session);
    }

    private static final class PseudoInput extends URIEditorInput implements IPathEditorInput {
        private final IFile aird;

        private PseudoInput(Session session) {
            super(session.getSessionResource().getURI());

            IWorkspaceRoot wsRoot = ResourcesPlugin.getWorkspace().getRoot();
            aird = wsRoot.getFile(new Path(getURI().toPlatformString(true)));
        }

        @Override
        public IPath getPath() {
            return aird.getRawLocation();
        }
    }

    @Override
    public IEditorSite getEditorSite() {
        // only call when markEditor is used.
        return IEditorSite.class.cast(Optional.empty());
    }

    @Override
    public void init(IEditorSite site, IEditorInput input) throws PartInitException {
        throw new UnsupportedOperationException("Should not be call through this reference");
    }

    @Override
    public void createPartControl(Composite parent) {
        throw new UnsupportedOperationException("Should not be call through this reference");
    }

    private static IFile getIFile(URI uri) {
		IWorkspace ws = ResourcesPlugin.getWorkspace();
		return ws.getRoot().getFile(new Path(uri.toPlatformString(true)));
    }
    
    private final class ExplorerLocation implements INavigationLocation {
        // Cannot use NavigationLocation as input is not applicable:
        // View has 1 input per project.
        private static final String PROJECT_MEMENTO = "project";
        private static final String TARGET_MEMENTO = "target";

        private Object input;

        private String projectUri;
        private String target;
        private String text;
        
        public ExplorerLocation(EObject selection) {
        	if (selection != null) {
	        	Session session = Session.of(selection).get();
	        	URI sessionUri = session.getSessionResource().getURI();
	        	String rootText;
	        	if (sessionUri.isPlatformResource()) {
	        		rootText = getIFile(sessionUri).getProject().getName();
	        	} else if (sessionUri.segmentCount() > 0) {
	        		rootText = sessionUri.segment(0);
	        	} else { // specific uri
	        		rootText = sessionUri.scheme();
	        	}
	        	
	
	            target = selection != null
	                ? EcoreUtil.getURI(selection).toString()
	                : null;
	            
	            
	            // Keep only the name
	            text = EDS.getLabelProvider(selection).getText(rootText) + " [Model Explorer]";
        	} else {
        		LOG.warn("Empty location marker", new NoSuchElementException());
        		text = "Model Explorer Selection";
        	}
        }

        @Override
        public void restoreLocation() {
            inHistory = true;
            try {
                if (projectUri == null || target == null) {
                    return;
                }

                Session session = SessionManager.INSTANCE.getSession(URI.createURI(projectUri),
                    new NullProgressMonitor());
                if (session == null) {
                    return;
                }

                ResourceSet resSet = session.getTransactionalEditingDomain().getResourceSet();
                EObject reference = resSet.getEObject(URI.createURI(target), true);
                if (reference != null) {
                    view.selectReveal(new StructuredSelection(reference));
                }
            } finally {
                inHistory = false;
            }
        }

        @Override
        public void saveState(IMemento memento) {
            // Encode Selection + URL
            memento.putString(PROJECT_MEMENTO, projectUri);
            memento.putString(TARGET_MEMENTO, target);
        }

        @Override
        public void restoreState(IMemento memento) {
            projectUri = memento.getString(PROJECT_MEMENTO);
            target = memento.getString(TARGET_MEMENTO);
        }

        @Override
        public boolean mergeInto(INavigationLocation currentLocation) {
            if (!(currentLocation instanceof ExplorerLocation)) {
                return false;
            }
            ExplorerLocation other = (ExplorerLocation) currentLocation;

            return Objects.equals(projectUri, other.projectUri)
                && Objects.equals(target, other.target);
        }

        @Override
        public String getText() {
            return text;
        }

        @Override
        public void dispose() {
        }

        @Override
        public void releaseState() {
        }

        @Override
        public void setInput(Object value) {
            input = value;
        }

        @Override
        public Object getInput() {
            return input;
        }

        @Override
        public void update() {
            // Called when tab loses the focus.
            // Nothing to update
        }
    }

}
