package org.mypsycho.emf.modit.sirius.ui.navigator;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import org.eclipse.emf.common.CommonPlugin;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.util.FeatureMap;
import org.eclipse.emf.edit.command.CommandParameter;
import org.eclipse.emf.edit.domain.EditingDomain;
import org.eclipse.emf.edit.ui.action.CommandActionHandler;
import org.eclipse.emf.edit.ui.action.CopyAction;
import org.eclipse.emf.edit.ui.action.CutAction;
import org.eclipse.emf.edit.ui.action.DeleteAction;
import org.eclipse.emf.edit.ui.action.PasteAction;
import org.eclipse.emf.edit.ui.action.RedoAction;
import org.eclipse.emf.edit.ui.action.UndoAction;
import org.eclipse.emf.transaction.TransactionalEditingDomain;
import org.eclipse.jface.action.Action;
import org.eclipse.jface.action.ActionContributionItem;
import org.eclipse.jface.action.IAction;
import org.eclipse.jface.action.IContributionItem;
import org.eclipse.jface.action.IMenuManager;
import org.eclipse.jface.action.MenuManager;
import org.eclipse.jface.viewers.ISelection;
import org.eclipse.jface.viewers.IStructuredSelection;
import org.eclipse.jface.viewers.StructuredSelection;
import org.eclipse.sirius.business.api.session.Session;
import org.eclipse.ui.ISharedImages;
import org.eclipse.ui.PlatformUI;
import org.eclipse.ui.navigator.ICommonMenuConstants;
import org.mypsycho.emf.modit.sirius.ui.action.ExtCreateChildAction;

/**
 * <p>
 * 
 * </p>
 *
 * @author nperansin
 */
public class DefaultModellingActionProvider implements ModellingActionProvider {

    // private ContextMenuFiller contextMenuFiller;
	static private Map<Class<?extends Action>, String> IMAGE_DESCRS = new HashMap<>();
	
	static {
		IMAGE_DESCRS.put(UndoAction.class, ISharedImages.IMG_TOOL_UNDO);
		IMAGE_DESCRS.put(RedoAction.class, ISharedImages.IMG_TOOL_REDO);
		
		IMAGE_DESCRS.put(CutAction.class, ISharedImages.IMG_TOOL_CUT);
		IMAGE_DESCRS.put(CopyAction.class, ISharedImages.IMG_TOOL_COPY);
		IMAGE_DESCRS.put(PasteAction.class, ISharedImages.IMG_TOOL_PASTE);
		// TODO move ?
		// TODO rearrange
		// TODO refactor type.
		IMAGE_DESCRS.put(DeleteAction.class, ISharedImages.IMG_TOOL_DELETE);
		
		// TODO session: save, close (resource aird ??)
	}

    
    protected static <T extends Action> T initSharedImage(Class<? extends Action> category, T action) {
    	// share image access is fast enough
    	ISharedImages sharedImages = PlatformUI.getWorkbench().getSharedImages();
    	action.setImageDescriptor(sharedImages.getImageDescriptor(IMAGE_DESCRS.get(category)));
    	return action;
    }
    
    @Override
    public void fillEObjectsMenu(IMenuManager menu, Session session, List<? extends EObject> selecteds, IStructuredSelection context) {

        if (selecteds.size() == 1) {
        	addNewMenu(menu, session, selecteds.get(0));
        }
        
        addEditActionsMenu(menu, session, selecteds, context);
        // no need to clean the menu: menu closing is before action call anyway.

    }
    
    protected void addEditActionsMenu(IMenuManager menu, Session session, List<? extends EObject> selecteds, IStructuredSelection context) {
    	getEditActions(session, selecteds).forEach(it -> {
        	if (it instanceof CommandActionHandler) {
        		((CommandActionHandler) it).updateSelection(context);
        	}
        	
    		menu.appendToGroup(ICommonMenuConstants.GROUP_EDIT, it);
    	});
    	
    }
    
    
    @SafeVarargs
	protected static List<Action> toEmfInstances(EditingDomain param, Class<? extends Action>... types) {
    	return Stream.of(types)
    		.map(it -> toEmfInstance(param, it))
    		.filter(Objects::nonNull)
    		.collect(Collectors.toList());
    }
    
    protected static <T extends Action> T toEmfInstance(EditingDomain param, Class<T> type) {
    	T result;
		try {
			result = type.getConstructor(EditingDomain.class).newInstance(param);
		} catch (InstantiationException 
				| IllegalAccessException 
				| IllegalArgumentException 
				| InvocationTargetException
				| NoSuchMethodException | SecurityException e) {
			// TODO LOG
			return null;
		}
    	return initSharedImage(type, result);
    }
    
    protected List<Action> getEditActions(Session session, List<? extends EObject> selecteds) {
    	return Stream.of(
    			addUndoRedoActions(session, selecteds),
    			addClipboardActions(session, selecteds),
    			addDeleteActions(session, selecteds)
    			)
    			.flatMap(it -> it.stream())
    			.collect(Collectors.toList());
    }
    
    protected List<Action> addUndoRedoActions(Session session, List<? extends EObject> selecteds) {
    	return toEmfInstances(session.getTransactionalEditingDomain(), UndoAction.class, RedoAction.class);
    }

    protected List<Action> addClipboardActions(Session session, List<? extends EObject> selecteds) {
    	return toEmfInstances(session.getTransactionalEditingDomain(), CutAction.class, CopyAction.class, PasteAction.class);
    }
    
    protected List<Action> addDeleteActions(Session session, List<? extends EObject> selecteds) {
    	return toEmfInstances(session.getTransactionalEditingDomain(), DeleteAction.class);
    }
    
    @Override
    public void fillSessionMenu(IMenuManager menu, Session session, IStructuredSelection context) {
    	// TODO
    	// Add save ...
    	// if (session project != modelling) // close
    }
    

	protected void addNewMenu(IMenuManager menu, Session session, EObject context) {
        MenuManager childMenu = new MenuManager("&New Child"); //$NON-NLS-1$
        // TODO find title label
        
        getCreationItems(session, context)
			.forEach(it -> childMenu.add(it));
        if (!childMenu.isEmpty()) {
            // Before new representation.
        	menu.prependToGroup(ICommonMenuConstants.GROUP_NEW, childMenu);
        }

	}
	
	protected boolean isEditable(Session session, EObject context) {
		return true;
	}
    
	protected void onCreating(Session session, EObject context) {
		
	}

	protected void onCreated(Session session, EObject context) {
		
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
	
	
	
    /**
     * Return default creation actions from EMF item providers
     *
     * @param selection Current object
     * @param onPerformed Code to execute once the creation has been done
     * @return a stream of creation actions
     */
    public Stream<IContributionItem> getCreationItems(Session session, EObject selection) {

    	TransactionalEditingDomain domain = session.getTransactionalEditingDomain();
        Collection<?> newChildDescriptors = domain.getNewChildDescriptors(selection, null);
        if (newChildDescriptors == null || newChildDescriptors.isEmpty()) {
            return Stream.empty();
        }

        // Generate actions for selection; populate and redraw
        // the menus.
        List<IAction> tail = new ArrayList<>();

        ISelection eSelection = new StructuredSelection(selection);
        List<MenuManager> subMenus = new ArrayList<>();
        newChildDescriptors.stream()
            // FeatureMap content is handled by custom Widget.
            // This will prevent random monkey test feedback.
            .filter(it -> !isFeatureMapElementCreation(it))
            // .filter( linked to filtering of view ?? )
            .map(it -> new ExtCreateChildAction(domain, eSelection, it,
            		elem -> onCreating(session, elem),
            		elem -> onCreated(session, elem))) // to action
            // sort by text
            .sorted(Comparator.comparing(it -> it.getText(), CommonPlugin.INSTANCE.getComparator()))
            .reduce(new HashMap<String, MenuManager>(), (result, it) -> {
                // relation is separated from Type by '|'
            	// TODO Verify '|' is standard EMF
                String[] path = it.getText().split("\\|");
                if (path.length == 2) {
                    it.setText(path[1].trim());
                    result.computeIfAbsent(path[0].trim(), title -> {
                        MenuManager sub = new MenuManager(title);
                        subMenus.add(sub);
                        return sub;
                    }).add(it);
                } else {
                    tail.add(it);
                }
                return result;
                // 1 map, no merge, use of 2 letters variables to conform with coding guidelines
            }, (xx, yy) -> xx);

        // For simple case (1 sub-list with sub elements), trim navigation.
        if (subMenus.size() == 1 && tail.isEmpty()) {
            return Stream.of(subMenus.get(0).getItems());
        }

        return Stream.concat(subMenus.stream(),
            tail.stream().map(it -> new ActionContributionItem(it)));
    }

    public static boolean isFeatureMapElementCreation(Object it) {
        if (!(it instanceof CommandParameter)) {
            return false;
        }
        CommandParameter command = (CommandParameter) it;
        return command.getEAttribute() != null
            && command.getEAttribute().getEType().getInstanceClass().equals(FeatureMap.Entry.class);
    }
    

    // Contribute in CNF with 
    // ISaveablePart, ISaveablesSource, IShowInTarget
    // See org.eclipse.ui.navigator.CommonNavigator class
    // abstraction of org.eclipse.sirius.ui.tools.internal.views.modelexplorer.ModelExplorerView
    
    
}