/*******************************************************************************
 * Copyright (c) 2019-2024 OBEO.
 * 
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
package org.mypsycho.modit.emf.sirius.internal;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.function.IntFunction;
import java.util.stream.Stream;

import org.eclipse.core.runtime.IConfigurationElement;
import org.eclipse.core.runtime.IExtension;
import org.eclipse.core.runtime.IExtensionPoint;
import org.eclipse.core.runtime.IExtensionRegistry;
import org.eclipse.core.runtime.IRegistryEventListener;
import org.eclipse.core.runtime.Platform;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.edit.provider.IDisposable;
import org.eclipse.sirius.business.api.componentization.ViewpointRegistry;
import org.eclipse.sirius.viewpoint.description.Viewpoint;
import org.mypsycho.modit.emf.sirius.ModitSiriusPlugin;
import org.mypsycho.modit.emf.sirius.SiriusModelProvider;

/**
 *
 * @author nperansin
 */
public class ProviderExtensionRegistry implements IRegistryEventListener {

	public static final String EXTENSION_POINT = ModitSiriusPlugin.PLUGIN_ID  + ".componentization";

	private static final String CLASS_ATT = "class";

	
	
	private final IExtensionRegistry eclipseRegistry = Platform.getExtensionRegistry();

	
	public void init() {
		eclipseRegistry.addListener(this,
				ProviderExtensionRegistry.EXTENSION_POINT);
		
		added(eclipseRegistry.getExtensionPoint(EXTENSION_POINT).getExtensions());
	}


	// registereds protects itself and serviceProviders content.
	private Map<URI, Registration> registereds = new HashMap<>();
	
	// registereds protects itself and serviceProviders content.
	private Map<String/*classname*/, SiriusModelProvider> implsCache = new HashMap<>();
	
	// Providers are index for a better performance. Otherwise key would be enough.
	private List<? extends SiriusModelProvider> serviceProviders = Collections.emptyList();
	
	@Override
	public synchronized void added(IExtension[] extensions) {
		Stream.of(extensions)
			.flatMap(it -> Stream.of(it.getConfigurationElements()))
			.forEach(it -> registerGroups(toRegistration(it)));
	}
	
	private Registration toRegistration(IConfigurationElement it) {
		String pluginId = it.getContributor().getName();
		String classname = it.getAttribute(CLASS_ATT).trim();
		int index = classname.indexOf('/');
		if (index != -1) {
			pluginId = classname.substring(0, index).trim();
			classname = classname.substring(index + 1).trim();
		}
		return new Registration(pluginId, classname);
	}

	@Override
	public synchronized void removed(IExtension[] extensions) {
		Stream.of(extensions)
			.flatMap(it -> Stream.of(it.getConfigurationElements()))
			.map(it -> {
				synchronized (registereds) {
					return registereds.get(toRegistration(it).getKey());
				}
			})
			.filter(Objects::nonNull)
			.forEach(it -> it.dispose());
	}

	@Override
	public void added(IExtensionPoint[] extensionPoints) {
		// Not listened
	}

	@Override
	public void removed(IExtensionPoint[] extensionPoints) {
		// Not listened
	}

	
	/**
	 * Disposable class registering SiriusModelProvider classes.
	 * <p>
	 * User must dispose them when registered classes are no more needed (bundle stop).
	 * </p>
	 */
	class Registration implements IDisposable {

		static final int UNALLOCATED_INDEX = -1;

		private Set<Viewpoint> viewpoints = new HashSet<>();

		private final String siriusPath;
		private final URI key; 
		
		private final String implClass;

		private int index = UNALLOCATED_INDEX;

		private SiriusModelProvider instance = null;


		public Registration(String pluginId, String classname) {
			implClass = classname;
			key = DesignFactory.toSiriusUri(pluginId, classname);
			siriusPath = DesignFactory.toSiriusPluginPath(pluginId, classname);
		}

		public URI getKey() {
			return key;
		}

		public int getIndex() {
			return index;
		}

		@Override
		public void dispose() {
			synchronized (registereds) {
				if (registereds.get(getKey()) == this) {
					registereds.remove(getKey());
				}
				
				if (implsCache.get(implClass) == instance) {
					implsCache.remove(implClass);
				}
				
				if (index != UNALLOCATED_INDEX
						&& index < serviceProviders.size()  
						&& serviceProviders.get(index) == instance) {
					updateServices(index, null);
				}
			}
			ViewpointRegistry vpReg = ViewpointRegistry.getInstance();
			viewpoints.forEach(it -> vpReg.disposeFromPlugin(it));
		}

		void setIndex(int id) {
			index = id;
		}

		/**
		 * Allocated the provider
		 *
		 * @param it instance of register
		 * @return index
		 */
		int allocated(SiriusModelProvider it) {
			// search free id
			if (index == Registration.UNALLOCATED_INDEX) {
				index = 0;
				while(index < serviceProviders.size() && serviceProviders.get(index) != null) {
					index++;
				}
			} // else in reload.
			
			instance = it;
			updateServices(index, it);
			implsCache.put(implClass, it);
			return getIndex();
		}

		void initViewpoints() {
			viewpoints.addAll(ViewpointRegistry.getInstance().registerFromPlugin(siriusPath));			
		}
	}
	
	

	/**
	 * Update the list of provider.
	 * <p>
	 * The list is modified by copy to ensure a safe fast access.
	 * </p>
	 * 
	 * @param index
	 * @param it
	 */
	private void updateServices(int index, SiriusModelProvider it) {
		
		List<SiriusModelProvider> newList = new ArrayList<>(serviceProviders);
		
		// register
		if (newList.size() == index) { // new index
			newList.add(it);
		} else {
			newList.set(index, it);
		}
		serviceProviders = newList;

	}

	/**
	 * Register this SiriusModelProvider as Sirius model.
	 *
	 * @param pluginId exposing the class
	 * @param mpClass to instantiate
	 * @return anchor to unregister the model
	 */
	private void registerGroups(Registration contrib) {
		synchronized (registereds) {
			
			// do not combine with 'put', cleaning checks 
			Registration old = registereds.get(contrib.getKey());
			if (old != null) {
				old.dispose();
			}
			registereds.put(contrib.getKey(), contrib);
		}
		contrib.initViewpoints();
	}

	public int registerProvider(SiriusModelProvider it, Resource at) {
		Registration reg;
		synchronized (registereds) {
			reg = registereds.get(at.getURI());
			if (reg == null) { // reloading
				throw new IllegalStateException("Unregistered model provider " + at.getURI());
			}
			// inside synch to protect implsCache and serviceProviders
			return reg.allocated(it);
		}
	}

	/**
	 * Returns the model provider registered with specified id.
	 * <p>
	 * Package to limit access to SiriusModelProviderService.
	 * </p>
	 *
	 * @param id of model provider
	 * @return registered provider (may be null)
	 * @throws IndexOutOfBoundsException if id does match any existing id
	 */
	public IntFunction<Object> getProvider(int id) {
		return serviceProviders.get(id).getCallback();
	}
	
	
	/**
	 * Returns the model provider registered with specified class.
	 * <p>
	 * Package to limit access to SiriusModelProviderService.
	 * </p>
	 *
	 * @param classname of model provider
	 * @return registered provider (may be null)
	 * @throws IndexOutOfBoundsException if id does match any existing id
	 */
	public IntFunction<Object> getProvider(String classname) {
		return implsCache.get(classname).getCallback();
	}


	public void dispose() {
		Platform.getExtensionRegistry().removeListener(this);
		
		// Registration.dispose changes registereds
		// A copy is required.
		new ArrayList<>(registereds.values()).forEach(it -> it.dispose());
	}
}
