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
package org.mypsycho.modit.emf.sirius.api

import java.util.Objects
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.sirius.viewpoint.description.IdentifiedElement
import org.mypsycho.modit.emf.EModIt
import org.mypsycho.modit.emf.sirius.SiriusModelProvider

import static extension org.mypsycho.modit.emf.sirius.api.SiriusDesigns.*

/**
 * Adaptation of Sirius model into Java and EClass reflections API
 * for representation.
 * 
 * @author nicolas.peransin
 */
abstract class AbstractIdentifiableElement {

	/** Main container */
	protected val extension SiriusVpGroup context
	
	/** Factory of Sirius elements */
	protected val extension EModIt factory
	

	/**
	 * Alias root for the identified elements.
	 * <p>
	 * Default implementation is based on class name.
	 * </p>
	 */
	protected var String contentAlias

	/**
	 * Create a factory for a diagram description
	 * 
	 * @param parent of diagram
	 */
	new(SiriusVpGroup parent) {
		this.context = parent
		this.factory = parent.factory
				
		contentAlias = parent.getContentAlias(class)
	}

	/**
	 * Returns a reference from extra elements.
	 * 
	 * @param type of referenced element (strict, no inheritance)
	 * @param key of reference
	 * @return element
	 */
	def <T> T extraRef(Class<T> type, String key) {
		Objects.requireNonNull(context.extraRef(type, key), key)
	}
	
	//
	// Identification
	//
	
	/**
	 * Creates an identification with provided category.
	 * <p>
	 * This method has no side-effect, no id is reserved.
	 * </p>
	 * 
	 * @param cat of identification
	 * @param path 
	 */
	protected def String id(EClass cat, String path) {
		cat.name.id(path)
	}
	
	/**
	 * Creates an identification with provided category.
	 * <p>
	 * This method has no side-effect, no id is reserved.
	 * </p>
	 * 
	 * @param cat of identification
	 * @param path 
	 */
	protected def String id(Enum<?> cat, String path) {
		cat.name.id(path)
	}
	
	/**
	 * Builds an identification with provided category for local element.
	 * <p>
	 * This method has no side-effect, no id is reserved.
	 * </p>
	 * 
	 * @param cat of identification
	 * @param path 
	 */
	protected def String id(String category, String path) {
		category.id(contentAlias, path)
	}
	
	/**
	 * Creates an {@link IdentifiedElement} and initializes it.
	 * 
	 * @param type of IdentifiedElement to instantiate
	 * @param cat category of element
	 * @param eName name of element
	 * @param initializer of the given {@link EObject}
	 */
	protected def <R extends IdentifiedElement> R 
		createAs(
			Class<R> type, Enum<?> cat, String eName, (R)=>void init		
	) {
		type.createAs(cat.id(eName)) [
			name = eName
			init?.apply(it)
		]
	}
	
	/**
	 * Copies an {@link IdentifiedElement} and initializes it.
	 * 
	 * @param type of IdentifiedElement to instantiate
	 * @param cat category of element
	 * @param eName name of element
	 * @param initializer of the given {@link EObject}
	 */
	protected def <R extends IdentifiedElement> R 
		copyAs(
			R original, Enum<?> cat, String eName, (R)=>void init
	) {
		(EcoreUtil.copy(original) as R) => [
			cat.id(eName).alias(it)
			name = eName
			init?.apply(it)
		]
	}

	/**
	 * Builds an identification with provided category for local element.
	 * <p>
	 * This method has no side-effect, no id is reserved.
	 * </p>
	 * <p>
	 * Not deprecated but you should consider 'createAs' or 'ref' method.
	 * </p>
	 * 
	 * @param cat of identification
	 * @param context of element
	 * @param path of element
	 */
	protected def String id(Enum<?> cat, String root, String path) {
		cat.name.id(root, path)
	}
	
	/**
	 * Builds an identification with provided category for local element.
	 * <p>
	 * This method has no side-effect, no id is reserved.
	 * </p>
	 * <p>
	 * Not deprecated by you should consider 'createAs' or 'ref' method.
	 * </p>
	 * 
	 * @param category of identification
	 * @param root of element
	 * @param path of element
	 */
	protected def String id(String category, String root, String path) {
		category.createId(root, path)
	}
		
	/**
	 * Builds a proxy to be resolved on 'loadContent' for a local element.
	 * 
	 * @param <R> Type of created proxy
	 * @param type of created proxy
	 * @param category of identification
	 * @param name of element
	 */
	protected def <R extends IdentifiedElement> R 
		localRef(
			Class<R> type, Enum<?> cat, String name			
	) {
		type.ref(contentAlias, cat, name)
	}
	
	/**
	 * Builds a proxy to be resolved on 'loadContent' for a local element.
	 * 
	 * @param <R> Type of created proxy
	 * @param type of created proxy
	 * @param category of identification
	 * @param name of element
	 */
	protected def <R extends EObject> R 
		localRef(
			Class<R> type, Enum<?> cat, 
			String name, (IdentifiedElement)=>R path
	) {
		type.ref(contentAlias, cat, name, path)
	}
	
	/** Builds a proxy to be resolved on 'loadContent' for a local element. */
	protected def <R extends EObject, S extends IdentifiedElement> R 
		localRef(
			Class<R> type, Enum<?> cat, 
			String name, Class<S> rootType, (S)=>R path
	) {
		type.ref(contentAlias, cat, name, path as (IdentifiedElement)=>R)
	}
			
	/**
	 * Builds an id for proxy for a local element.
	 * 
	 * @param <R> Type of created proxy
	 * @param type of created proxy
	 * @param category of identification
	 * @param name of element
	 */
	protected def localId(Enum<?> cat, String name) {
		cat.id(contentAlias, name)
	}
	
	/**
	 * Builds a proxy to be resolved on 'loadContent' for an element defined in provided container.
	 * 
	 * @param <R> Type of created proxy
	 * @param type of created proxy
	 * @param container of element
	 * @param category of identification
	 * @param name of element
	 */
	protected def <R extends IdentifiedElement> R 
		ref(
			Class<R> type, Class<? extends AbstractIdentifiableElement> container, 
			Enum<?> cat, String name
	) {
		type.ref(container.contentAlias, cat, name)
	}
	
	/**
	 * Builds a proxy to be resolved on 'loadContent' for an element defined in provided container.
	 * 
	 * @param <R> Type of created proxy
	 * @param type of created proxy
	 * @param container of element
	 * @param category of identification
	 * @param name of element
	 */
	protected def <R extends EObject> R 
		ref(
			Class<R> type, Class<? extends AbstractIdentifiableElement> container, 
			Enum<?> cat, String name, (IdentifiedElement)=> R path
	) {
		type.ref(container.contentAlias, cat, name, path)
	}
	
		
	/**
	 * Builds a proxy to be resolved on 'loadContent' for an element defined in provided container.
	 * 
	 * @param container of element
	 * @param category of identification
	 * @param name of element
	 */
	protected def refId(Class<? extends AbstractIdentifiableElement> container, Enum<?> cat, String name) {
		cat.id(container.contentAlias, name)
	}
	
	/**
	 * Builds a proxy to be resolved on 'loadContent' for an element defined in provided container.
	 * 
	 * @param <R> Type of created proxy
	 * @param type of created proxy
	 * @param category of identification
	 * @param containerId of element
	 * @param name of element
	 */
	protected def <R extends IdentifiedElement> R 
		ref(
			Class<R> type, String containerId, 
			Enum<?> cat, String id
	) {
		type.ref(cat.id(containerId, id))
	}
    
	/**
	 * Builds a proxy to be resolved on 'loadContent' for an element defined in provided container.
	 * 
	 * @param <R> Type of created proxy
	 * @param type of created proxy
	 * @param category of identification
	 * @param containerId of element
	 * @param name of element
	 */
	protected def <R extends EObject> R 
		ref(
			Class<R> type, String containerId, Enum<?> cat, 
			String id, (IdentifiedElement)=>R path
	) {
		// type.ref(cat.id(containerId, id)) [ path.apply(it as IdentifiedElement) ]
		type.ref(cat.id(containerId, id), path as (EObject)=>R)
	}
    
	//
	// Expressions
	// 
	
	/**
	 * Create a string from expression from a sequence of parameter names.
	 * 
	 * @param params names
	 * @return string of parameters
	 */
	static def params(String... params) { 
		params.join(SiriusModelProvider.PARAM_SEP)
	}
	
	/**
	 * Create a string from expression from a sequence of parameter names.
	 * 
	 * @param params names
	 * @return string of parameters
	 */
	static def params(Object... params) { 
		params.join(SiriusModelProvider.PARAM_SEP)
	}
	
	//
	// AQL
	// 
	
	/**
	 * Provides AQL expression for a class.
	 * <p>
	 * The must be contain in business Packages of the context.
	 * </p>
	 * 
	 * @param type to convert
	 * @return aql expression
	 */
	def asAql(Class<? extends EObject> type) {
		type.asEClass().asAql
	}
	
	/** Aql shortcut to evaluate a type. */
	def String isInstanceAql(Class<? extends EObject> type) {
		'''.oclIsKindOf(«type.asAql»)'''
	}
	
	/** Aql shortcut to cast a type. */
	def String castAql(Class<? extends EObject> type) {
		'''.oclAsType(«type.asAql»)'''
	}
	
	/** Raises an exception if the condition is not met. */
	static def verify(CharSequence message, boolean condition) {
		if (!condition) {
			throw new UnsupportedOperationException(message.toString)
		}
	}
}
