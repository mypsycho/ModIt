/*******************************************************************************
 * Copyright (c) 2020 Nicolas PERANSIN.
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
package org.mypsycho.modit.emf.sirius;

import java.util.ArrayList;
import java.util.Collection;

import org.eclipse.core.runtime.Plugin;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.sirius.business.api.componentization.ViewpointFileCollector;
import org.eclipse.sirius.business.api.componentization.ViewpointRegistry;
import org.eclipse.sirius.common.tools.api.interpreter.IConverter;
import org.eclipse.sirius.viewpoint.description.Group;
import org.eclipse.sirius.viewpoint.description.Viewpoint;
import org.mypsycho.modit.emf.sirius.internal.DesignFactory;
import org.mypsycho.modit.emf.sirius.internal.ProviderExtensionRegistry;
import org.osgi.framework.BundleContext;


/**
 * Activator of plugin.
 * <p>
 * It provides in memory of Sirius Model registering.
 * </p>
 * 
 * @author nperansin
 */
public class ModitSiriusPlugin extends Plugin {

	@SuppressWarnings("restriction") // discourage with Sirius
	static final IConverter DEFAULT_CONVERTER = 
			new org.eclipse.sirius.common.tools.internal.interpreter.DefaultConverter();

			
	/** The plug-in ID */
	public static final String PLUGIN_ID = "org.mypsycho.emf.modit.sirius";

	/** The shared instance */
	private static ModitSiriusPlugin instance;

	private ProviderExtensionRegistry registry;
	
	/**
	 * Returns loaded instance.
	 * 
	 * @return instance
	 */
	public static ModitSiriusPlugin getInstance() {
		return instance;
	}
	
	/** Provide to Sirius viewpoint from dynamic models */
	private static final ViewpointFileCollector MODEL_PROVIDER_COLLECTOR = 
			new ViewpointFileCollector() {

		@Override
		public boolean isValid(EObject root) {
			return root instanceof Group;
		}

		@Override
		public Collection<Viewpoint> collect(EObject root) {
			return new ArrayList<>(((Group) root).getOwnedViewpoints());
		}
	};


	@SuppressWarnings("restriction")
	@Override
	public void start(BundleContext context) throws Exception {
		super.start(context);
		
		instance = this;
		
		// This collector must be provider before registry start-up.
		((org.eclipse.sirius.business.internal.componentization.ViewpointRegistryImpl) 
				ViewpointRegistry.getInstance())
			// Seriously, internal ??? Refactor issue, was public.
			.addViewpointFileCollector(DesignFactory.EXTENSION, 
					MODEL_PROVIDER_COLLECTOR);
		
		registry = new ProviderExtensionRegistry();
		
		// registry must be navigable before initialization.
		// Initialized model need registry to bind service provider.
		
		registry.init();
	}

	@Override
	public void stop(BundleContext context) throws Exception {
		instance = null;
		try {
			registry.dispose();
		} finally {
			registry = null;
			super.stop(context);
		}
	}

	
	/**
	 * Returns registry.
	 * <p>
	 * Only for service.
	 * </p>
	 * 
	 * @return the registry
	 */
	ProviderExtensionRegistry getRegistry() {
		return registry;
	}

}
