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
package org.mypsycho.modit

import java.util.Collection

/**
 * Abstract mapping for Mod-it factory and an model implementation which provides container and 
 * reference.
 * 
 * @param <T> Common abstraction for all model elements: match ModIt constraint
 * @param <F> type for property descriptors.
 */
abstract class ModItImplementation<T, F> {

	/** Context sing the mapping */
	protected val ModIt<T> context

	/**
	 * An implementation for provided factory.
	 * 
	 * @param context of the factory
	 */
	new(ModIt<T> context) {
		this.context = context
	}

	/**
	 * Method called when the factory is described but not used.
	 * 
	 * @param descr of the factory
	 */
	def void init(ModItDescriptor<T> descr) {}

	/**
	 * Instantiate an {@link T} object.
	 * 
	 * @param type of object to create
	 * @throw IllegalArgumentException if type is not handled by the factory.
	 */
	def <R extends T> R create(Class<R> type)

	/**
	 * Builds a proxy to be resolved when construction is performed.
	 * 
	 * @param type of proxy to build
	 * @param id of the target object
	 * @throw IllegalArgumentException if type is not handled by the factory.
	 */
	def <R extends T> R ref(Class<R> type, String id, (T)=>R path) {
		create(type) => [
			initProxyId(id, path)
		]
	}

	/**
	 * Returns true if it is proxy.
	 * 
	 * @return true if proxy.
	 */
	def boolean isProxy(T it)

	/**
	 * Returns the id stored in it.
	 * <p>
	 * It must be a proxy created by this implementation.
	 * </p>
	 * @param it storing an proxy id.
	 * @return id of root target
	 */
	def String getProxyId(T it)

	/**
	 * Returns path to reference from root.
	 * 
	 * @param it storing an proxy id.
	 * @return path from root target
	 */
	def (T)=>T getProxyPath(T it)

    /**
     * Init it as a proxy with provided id.
     * 
     * @param it to initialise
     * @param id of root reference
     * @param path to reference for root
     */
	def <R extends T> void initProxyId(T it, String id, (T)=>R path)

	/**
	 * Returns the container of it.
	 * <p>
	 * It must be consistent with {@link #containerOf(T) }.
	 * </p>
	 * <p>
	 * The method returns null if it has no container.
	 * </p>
	 * 
	 * @param it child element
	 * @return container or null
	 */
	def T containerOf(T it)

	/**
	 * Returns a collection of all elements contained by it.
	 * <p>
	 * It must be consistent with {@link #containerOf(T) }.
	 * </p>
	 * 
	 * @param it containing elements
	 * @return a collection
	 */
	def Collection<T> contentOf(T it)
	
	/**
	 * Returns a printable name of type of it.
	 * 
	 * @param it to name
	 * @return type name
	 */
	def String typeName(T it)

	/**
	 * Returns a printable name of property.
	 * 
	 * @param it property
	 * @return property name
	 */
	def String propName(F it)

	/**
	 * Returns a printable name of type of property.
	 * 
	 * @param it property
	 * @return type name
	 */
	def String refTypeName(F it)


	/**
	 * Returns true if it can be assign using the property.
	 * 
	 * @param it value to assign
	 * @param property to assign with
	 * @return true if its type complies
	 */
	def boolean assignableTo(T it, F property)


	/**
	 * Returns a collection of all features containing references.
	 * 
	 * @param ir to iterate
	 * @return an EObject iterator
	 */
	def Iterable<F> allReferences(T it)

	/**
	 * Returns a collection of elements for property of it.
	 * <p>
	 * Only property from {@link #allReferences(T) } must be used.
	 * </p>
	 * 
	 * @param it containing property
	 * @param property applicable to it
	 * @return an EObject iterator
	 */
	 def Iterable<? extends T> getValues(T it, F property)

	/**
	 * Replaces the old value in the object's feature with the new value.
	 * <p>
	 * This method prevents the resolution of EList when replacing a value.
	 * </p>
	 * 
	 * @param container the object holding the values.
	 * @param feature the feature of the object holding the values.
	 * @param oldValue the value to replace.
	 * @param newValue the replacement value.
	 */
	def String replaceResolved(T container, F feature, T oldValue, T newValue)

	/**
	 * Attaches an id on the given value.
	 * 
	 * @param it to attach
	 * @param id of value
	 */
	def void bindAlias(T it, String id)

	/**
	 * Detaches any id from the object and returns it.
	 * 
	 * @param value the targeted EObject
	 * @return attached id or null
	 */
	def String unbindAlias(T it)

	/**
	 * Attaches an content on the given value.
	 * 
	 * @param it to attach
	 * @param content of value
	 */
	def void bindContent(T it, String content)

	/**
	 * Detaches any id from the object and returns it.
	 * 
	 * @param it the targeted EObject
	 * @return attached value or null
	 */
	def String unbindContent(T it)

	/**
	 * Attaches an initialization task on the given value.
	 * 
	 * @param <R> type of it
	 * @param it to attach
	 * @param task to perform 
	 */
	def <R extends T> void bindInit(R it, (R)=>void task)

	/**
	 * Detaches any initialization from the object and returns it.
	 * 
	 * @param it the targeted EObject
	 * @return initialization
	 */
	def <R extends T> (R)=>void unbindInit(T it)
	
	/**
	 * Attaches an on-assembly task on the given value.
	 * 
	 * @param <R> type of it
	 * @param it to attach
	 * @param task action to perform 
	 */
	def <R extends T> void bindAssemble(R it, (R)=>void task)
    
 	/**
	 * Detaches any on-assembly task from the object.
	 * <p>
	 * To run it or to amend it.
	 * </p>
	 * 
	 * @param it the targeted EObject
	 * @return task or null
	 */
    def <R extends T> (R)=>void unbindAssemble(T it)
    
	/**
	 * Attaches an on-assembly task on the given value.
	 * 
	 * @param <R> type of it
	 * @param it to attach
	 * @param task action to perform 
	 */
	def void bindReference(T it, T ref)
    
    /**
	 * Detaches an on-assembly task on the given value.
	 * 
	 * @param <R> type of it
	 * @param it to attach
	 * @param task action to perform 
	 */
	def T unbindReference(T it)
    
    
    
 	/**
	 * Test an existing reference any on-assembly task from the object.
	 * <p>
	 * To run it or to amend it.
	 * </p>
	 * 
	 * @param it the targeted EObject
	 * @return task or null
	 */
    def T reference(T it)
    
}
