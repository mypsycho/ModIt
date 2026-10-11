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
package org.mypsycho.modit.emf

import java.io.IOException
import java.lang.reflect.InvocationTargetException
import java.util.Map
import org.eclipse.emf.common.CommonPlugin
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.Resource.Diagnostic
import org.eclipse.emf.ecore.resource.impl.ResourceFactoryImpl
import org.eclipse.emf.ecore.resource.impl.ResourceImpl
import java.util.Objects

/**
 * EMF Factory to load model created from ModitModel instance into a resource.
 * <p>
 * It can only be using with resources identified by plugin URI. 
 * </p>
 */
class ModitResourceFactory extends ResourceFactoryImpl {
	
	static val PLUGIN_PATH = "plugin/" // used in URI, but not public.
	
	/** Default Extension used to identify model class */
	public static val DEFAULT_EXTENSION = "modit"
	
	/** Extension used by EMF parser to find this Factory */
	val String fileExtension

	/**
	 * Default constructor used by EMF loader.
	 */
	new() {
		this(DEFAULT_EXTENSION)
	} 

	/**
	 * Generic constructor to use specific extension.
	 * 
	 * @param ext extension to use
	 */
	new(String ext) {
		fileExtension = Objects.requireNonNull(ext)
	}
	
	override createResource(URI uri) { 
		new ClassResource(this, uri)
	}

	/** Diagnostic of model creation failures.  */
	static class ClassDiagnostic extends Exception implements Diagnostic {
	// No basic Resource.Diagnostic

		final String location

		new(URI uri, String text, Throwable cause) {
			super(text, cause)
			cause.printStackTrace()
			location = uri.toString()
		}

		new(URI uri, String text) { this(uri, text, null) }

		override String getLocation() { location }

		override int getLine() { 0 }

		override int getColumn() { 0 } 
	}

	/** 
	 * Creates an instance of model class from URI.
	 * 
	 * @param uri identifying a class
	 * @return new instance
	 */
	def createModelProviderFactory(URI uri) {
		var String spec = uri.path().trim()
		if (spec.startsWith("/")) {
			spec = spec.substring(1)
		}
		if (!spec.startsWith(PLUGIN_PATH)) {
			throw new ClassDiagnostic(uri, "Invalid plugin URI")
		}
		if (!fileExtension.equalsIgnoreCase(uri.fileExtension)) {
			throw new ClassDiagnostic(uri, "Invalid extension")
		}
		var int classPathIx = spec.indexOf("/", PLUGIN_PATH.length())
		
		if (classPathIx === -1) {
			throw new ClassDiagnostic(uri, "Missing class")
		}
		
		var String pluginName = spec.substring(PLUGIN_PATH.length(), classPathIx)
		
		var String className = spec.substring(
			classPathIx + 1, 
			spec.length() - fileExtension.length() - 1 /* dot */
		)
		try {
			CommonPlugin.loadClass(pluginName, className).constructor.newInstance
		} catch (ClassNotFoundException e) {
			throw new ClassDiagnostic(uri, "Missing class " + className, e)
		}
	}

	def toContent(Object it, ClassResource res) throws Exception {
		res.contents += (it as ModitModel).loadContent(res)
	}

	/** Wrapping of Model-class instance. */
	static class ClassResource extends ResourceImpl {
		
		val ModitResourceFactory context
		
		var Object instance

		new(ModitResourceFactory factory, URI uri) {
			super(uri)
			context = factory
			instance = try {
				context.createModelProviderFactory(uri)
			} catch (ClassDiagnostic dg) {
				getErrors() += dg
				null
			}
		}

		override getURIFragment(EObject it) {
			super.getURIFragment(it) // ???
		}

		override load(Map<?, ?> options) throws IOException {
			if (loaded) return // conform to super

			// code inspire from load(InputStream, option)
			val notification = setLoaded(true);
			isLoading = true;
			try { //
				if (instance !== null) {
					errors?.clear
					warnings?.clear
					context.toContent(instance, this)
				}	
			} catch (InvocationTargetException e) {
				getErrors() += new ClassDiagnostic(uri, "Illegal instantiation", e.getCause())
			} catch (Exception e) {
				getErrors() += new ClassDiagnostic(uri, "Illegal instantiation", e)
			} finally {
				isLoading = false;
				notification?.eNotify
				modified = false
			}
		}
		
		override protected doUnload() { getContents().clear }
	}


	/**
	 * Provides Modit URI for class in a plugin.
	 * 
	 * @param pluginId containing class
	 * @param clazz to identify
	 * @return EMF URI
	 */
	static def toUri(String pluginId, Class<? extends ModitModel> clazz) {
		pluginId.toUri(clazz.name)
	}

	/**
	 * Provides URI for class in a plugin using custom extension.
	 * 
	 * @param pluginId containing class
	 * @param clazz to identify
	 * @param ext extension to use
	 * @return EMF URI
	 */
	static def toUri(String pluginId, Class<?> clazz, String ext) {
		pluginId.toUri(clazz.name, ext)
	}
	
	/**
	 * Provides path segment for URI of class in a plugin with modit extension.
	 * 
	 * @param pluginId containing class
	 * @param clazz to identify
	 * @return EMF URI path
	 */
	static def toPluginPath(String pluginId, Class<? extends ModitModel> clazz) {
		pluginId.toPluginPath(clazz.name)
	}

	/**
	 * Provides path segment for URI of class in a plugin with custom extension.
	 * 
	 * @param pluginId containing class
	 * @param clazz to identify
	 * @param ext extension to use
	 * @return EMF URI path
	 */
	static def toPluginPath(String pluginId, Class<?> clazz, String ext) {
		pluginId.toPluginPath(clazz.name, ext)
	}
	
	//
	//
	
	/**
	 * Provides Modit URI for class in a plugin.
	 * 
	 * @param pluginId containing class
	 * @param clazz to identify
	 * @return EMF URI
	 */
	static def toUri(String pluginId, String classname) {
		pluginId.toUri(classname, DEFAULT_EXTENSION)
	}
	
	/**
	 * Provides URI for class in a plugin using custom extension.
	 * 
	 * @param pluginId containing class
	 * @param clazz to identify
	 * @param ext extension to use
	 * @return EMF URI
	 */
	static def toUri(String pluginId, String classname, String ext) {
		URI.createPlatformPluginURI(pluginId.toPluginPath(classname, ext), true)
	}
	
	/**
	 * Provides path segment for URI of class in a plugin with modit extension.
	 * 
	 * @param pluginId containing class
	 * @param clazz to identify
	 * @return EMF URI path
	 */
	static def toPluginPath(String pluginId, String classname) {
		pluginId.toPluginPath(classname, DEFAULT_EXTENSION)
	}

	/**
	 * Provides path segment for URI of class in a plugin with custom extension.
	 * 
	 * @param pluginId containing class
	 * @param clazz to identify
	 * @param ext extension to use
	 * @return EMF URI path
	 */
	static def toPluginPath(String pluginId, String classname, String ext) {
		pluginId + "/" + classname + "." + ext
	}
	
	
}
