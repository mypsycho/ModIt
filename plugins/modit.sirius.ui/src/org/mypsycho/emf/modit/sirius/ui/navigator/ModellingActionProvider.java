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
package org.mypsycho.emf.modit.sirius.ui.navigator;

import java.util.List;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.jface.action.IMenuManager;
import org.eclipse.jface.viewers.IStructuredSelection;
import org.eclipse.sirius.business.api.query.ViewpointURIQuery;
import org.eclipse.sirius.business.api.session.Session;

/**
 *
 * @author nperansin
 */
public interface ModellingActionProvider {
	
	/**
	 * Creates a URI for Viewpoint provided by a plugin.
	 *
	 * @param pluginId providing plugin
	 * @param vpName name of viewpoint
	 * @return text of uri
	 */
	static String getPluginVpUri(String pluginId, String vpName) {
		return ViewpointURIQuery.VIEWPOINT_URI_SCHEME + ":/" + pluginId + "/" + vpName;
	}
	
	String VP_ATTRIBUTE = "viewpoint=";
	/** to use: VP_PROPERTY + {pluginId} + '/' + {vpName} */
	String VP_PROPERTY = VP_ATTRIBUTE + ViewpointURIQuery.VIEWPOINT_URI_SCHEME + ":/";

	
	// Group provided by ManageSessionActionProvider
	// See org.eclipse.sirius.ui/plugin.xml

    String GROUP_SESSION = "group.viewpoint.session"; //$NON-NLS-1$
    String GROUP_REPRESENTATION = "group.viewpoint.representation"; //$NON-NLS-1$
    String GROUP_SEMANTIC = "group.viewpoint.semantic"; //$NON-NLS-1$
    String GROUP_VP = "group.viewpoint"; //$NON-NLS-1$
    
    // Other constants are available in ICommonMenuConstants
    
    // String GROUP_NEW = "group.new"; //$NON-NLS-1$
    // String GROUP_OPEN = "group.open"; //$NON-NLS-1$
    // String GROUP_OPENWITH = "group.openWith"; //$NON-NLS-1$
    // String GROUP_EDIT = "group.edit"; //$NON-NLS-1$
    // String GROUP_REORGANIZE = "group.reorganize"; //$NON-NLS-1$
    /** For import/export */
//    String GROUP_PORT = "group.port"; //$NON-NLS-1$  
//    String GROUP_BUILD = "group.build"; //$NON-NLS-1$ 
//    String GROUP_GENERATE = "group.generate"; //$NON-NLS-1$ 
//    String GROUP_SEARCH = "group.search"; //$NON-NLS-1$
//    String GROUP_OTHER = "additions"; //$NON-NLS-1$
//    String GROUP_PROPS = "group.properties"; //$NON-NLS-1$


    /**
     * Fill contextual menu with 
     * <p>
     * 
     * </p>
     *
     * @param menu
     * @param session
     * @param selecteds
     */
    void fillEObjectsMenu(IMenuManager menu, Session session, List<? extends EObject> selecteds, IStructuredSelection context);
    
    void fillSessionMenu(IMenuManager menu, Session session, IStructuredSelection context);
}
