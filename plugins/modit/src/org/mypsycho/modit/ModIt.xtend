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

import java.util.Collections
import java.util.List
import java.util.Objects
import org.eclipse.emf.ecore.EObject

/**
 * Abstract class that contains the Mod-it API.
 * <p>
 * This class must be associated to an implementation of model.
 * </p>
 * <p>
 * Mod-it frees developers from sequential description constraints and eases reference 
 * declarations in model-oriented approach.
 * </p>
 */
class ModIt<T> {

	/** How to create element and references */
	protected val ModItImplementation<T, ?> impl // Not an extension: API conflict

	/** Description of the factory */
	protected val ModItDescriptor<T> description


	/**
	 * A factory with immutable strategy.
	 * 
	 * @param descr of the factory
	 * @param delegation implementation of model access
	 */
	new(ModItDescriptor<T> descr, (ModIt<T>)=>ModItImplementation<T, ?> delegation) {
		description = descr.clone // we protect modification after creation
		impl = delegation.apply(this)
		impl.init(descr)
	}

	/**
	 * Creates an {@link EObject}.
	 * 
	 * @param type the type of EObject to build
	 */
	def <R extends T> R create(Class<R> type) {
		create(type, null, null)
	}

	/**
	 * Creates an {@link EObject} and initializes it when assembling.
	 * 
	 * @param type of EObject to build
	 * @param content parsed parsed by content provider
	 */
	def <R extends T> R create(Class<R> type, String content) {
		create(type, content, null)
	}

	/**
	 * Creates an {@link EObject} and initializes it.
	 * 
	 * @param type of EObject to build
	 * @param initializer of the given {@link EObject}
	 */
	def <R extends T> R create(Class<R> type, (R)=>void init) {
		create(type, null, init)
	}

	/**
	 * Creates an {@link EObject} and initializes it when assembling.
	 * 
	 * @param type of EObject to build
	 * @param content parsed by content provider
	 * @param init of the given {@link EObject}
	 * @throw IllegalArgumentException if type is not handled by the factory.
	 */
	def <R extends T> R create(Class<R> type, String content, (R)=>void init) {
		val it = impl.create(type)
		if (content !== null) {
			Objects.requireNonNull(description.contentProvider, "No content provider")
			impl.bindContent(it, content)			
		}
		if (init !== null) {
			impl.bindInit(it, init)
		}
		ModItAssembler.candidate(it)
		
		it
	}
	
	
	
	/**
	 * Attaches more initialization task on element.
	 * <p>
	 * If a task was already attached, provided task is run afterward.
	 * </p>
	 * 
	 * @param <R> type of Object to build
	 * @param it object to complete during assembling
	 * @param task to run once object is assembled
	 */
	def <R extends T> andThen(R it, (R)=>void task) {
		compose[it, previous| 
			previous?.apply(it)
			task.apply(it)
		]
	}

	/**
	 * Composes an new initialization task on element controlling previous task execution.
	 * 
	 * @param <R> type of Object to build
	 * @param it object to complete during assembling
	 * @param task to run once object is assembled
	 */
	def <R extends T> compose(R it, (R, (R)=>void)=>void task) {
		Objects.requireNonNull(task, "Task undefined")
		val previous = impl.unbindInit(it)
		impl.bindInit(it) [ task.apply(it, previous) ]
		it
	}
	
	
	
	/**
	 * Builds a proxy to be resolved when {@link ModIt#assemble(T)} is called.
	 * 
	 * @param <R> type of reference
	 * @param type of proxy to build (the interface of the EClass to build)
	 * @param id of the target object
	 * @throw IllegalArgumentException if type is not handled by the factory.
	 */
	def <R extends T> R ref(Class<R> type, String id) {
		impl.ref(type, id, null)
	}

	/**
	 * Builds a proxy to be resolved when {@link ModIt#assemble(T)} is called.
	 * <p>
	 * Using lambda for the path postpones the resolution after the proxy resolution.
	 * </p>
	 * <p>
	 * <b>Prefer:</b> {@link #refFrom(Class, Class, String, Function1)}.
	 * </p>
	 * 
	 * @param <R> type of reference
	 * @param type of proxy to build (the interface of the EClass to build)
	 * @param id of the source object
	 * @param path from source to target
	 * @throw IllegalArgumentException if type is not handled by the factory.
	 */
	def <R extends T> R ref(Class<R> type, String id, (T)=>R path) {
		impl.ref(type, id, path)
	}

	/**
	 * Builds a proxy to be resolved when {@link ModIt#assemble(T)} is called.
	 * <p>
	 * Using lambda for the path postpones the resolution after the proxy resolution.
	 * </p>
	 * 
	 * @param <R> type of reference
	 * @param <S> type of initial reference
	 * @param type of proxy to build (the interface of the EClass to build)
	 * @param id of the source object
	 * @param path from source to target
	 * @throw IllegalArgumentException if type is not handled by the factory.
	 */
	def <R extends T, S extends T> R refFrom(Class<R> type, String id, Class<S> srcType, (S)=>R path) {
		type.ref(id) [ path.apply(it as S) ]
	}

	/**
	 * Builds a proxy to be resolved when {@link ModIt#assemble(T)} is called.
	 * 
	 * @param type of proxy to build (the interface of the EClass to build)
	 * @param id of the target object
	 * @throw IllegalArgumentException if type is not handled by the factory.
	 */
	def <R extends T> List<R> refs(Class<R> type, String... ids) {
		ids.map[ ref(type, it, null) ].toList
	}

	/**
	 * Attaches an id on the given value.
	 * 
	 * @param it to attach
	 * @param id of alias
	 */
	def <R extends T> alias(String id, R it) {
		impl.bindAlias(it, id)
		it
	}
	
	/**
	 * Creates an {@link EObject} and associate it to id.
	 * 
	 * @param id of created element
	 * @param type the type of EObject to build
	 */
	def <R extends T> R createAs(Class<R> type, String id) {
		createAs(type, id, null, null)
	}

	/**
	 * Creates an {@link EObject} and initializes it.
	 * 
	 * @param type of EObject to build
	 * @param initializer of the given {@link EObject}
	 */
	def <R extends T> R createAs(Class<R> type, String id, String content) {
		createAs(type, id, content, null)
	}
	
	/**
	 * Creates an {@link EObject} and initializes it and associate it to id.
	 * 
	 * @param id of created element
	 * @param type of EObject to build
	 * @param initializer of the given {@link EObject}
	 */
	def <R extends T> R createAs(Class<R> type, String id, (R)=>void initializer) {
		createAs(type, id, null, initializer)
	}
	
	/**
	 * Creates an {@link EObject} and initializes it when assembling and associate it to id.
	 * <p>
	 * Returned object should not be modified directly, as it is not yet initialized.
	 * But it can be used with {@link #andThen()}
	 * </p>
	 * 
	 * @param id of created element
	 * @param type of EObject to build
	 * @param content parsed parsed by content provider
	 * @return created element
	 */
	def <R extends T> R createAs(Class<R> type, String id, String content, (R)=>void init) {
		id.alias(create(type, content, init))
	}

	/**
	 * Attaches an assembly task on element.
	 * <p>
	 * If a task was already attached, provided task is executed afterward.
	 * </p>
	 * <p>
	 * Warning: creating an element or a reference will be ignored in this phase,
	 * use #onAssembledWith() to attach an new element into the assembl phase.
	 * </p>
	 * 
	 * @param <R> type of Object to build
	 * @param it object to complete during assembling
	 * @param task to run once object is assembled
	 * @return it
	 */
	def <R extends T> onAssembled(R it, (R)=>void task) {
		onAssembled[it, previous| 
			previous?.apply(it)
			task.apply(it)
		]
	}

	/**
	 * Attaches an assembly task on element controlling previous task execution.
	 * <p>
	 * Warning: creating an element or a reference will be ignored in this phase,
	 * use #onAssembledWith() to attach an new element at the #assemble() execution.
	 * </p>
	 * 
	 * @param <R> type of Object to build
	 * @param it object to complete during assembling
	 * @param task to run once object is assembled
	 * @return it
	 */
	def <R extends T> onAssembled(R it, (R, (R)=>void)=>void task) {
		Objects.requireNonNull(task, "Task undefined")
		val previous = impl.unbindAssemble(it)
		impl.bindAssemble(it) [ task.apply(it, previous) ]
		it
	}


	/**
	 * Attaches an element not contain in assemble tree without .
	 * 
	 * @param <R> type of Object to build
	 * @param it object to complete during assembling
	 * @param task to run once object is assembled
	 */
	protected def <R extends T> associateWith(R it, T ref) {
		Objects.requireNonNull(ref, "Reference undefined")		
		impl.bindReference(it, ref)
		ModItAssembler.candidate(it)	
		it
	}

	/**
	 * Attaches an assembly task on element and associate to the assembling of 
	 * another element.
	 * <p>
	 * When assembling elements, only sub-elements tree can build.</br>
	 * To create an element that is not sub-elements, it must be associated to built
	 * elements (any ancestor of currently build element).</br>
	 * Provided task must indicated in newly created tree where to add element.
	 * </p>
	 * <p>
	 * If a task was already attached, provided task is run afterward.
	 * </p>
	 * 
	 * 
	 * @param <R> type of Object to build
	 * @param it object to complete during assembling
	 * @param task to run once object is assembled
	 */
	def <R extends T> onAssembledWith(R it, T ref, (R)=>void task) {
		onAssembled(task).associateWith(ref)
	}

	/**
	 * Attaches an assembly task on element controlling previous task execution.
	 * 
	 * @param <R> type of Object to build
	 * @param it object to complete during assembling
	 * @param task to run once object is assembled
	 */
	def <R extends T> onAssembledWith(R it, T ref, (R, (R)=>void)=>void task) {
		onAssembled(task).associateWith(ref)
	}

	/**
	 * Assembles the content tree of the value.
	 * <p>
	 * Shortcut for singleton of {@link #assemble(Collection) }.
	 * </p>
	 * @param value to assemble
	 * @return a new pool of elements
	 * @throw NoSuchElementException if a reference cannot be found
	 * @throw ClassCastException if a reference target an incompatible type
	 * @throw IllegalStateException if a id defined used more than once
	 */
	def <R extends T> assemble(R value) {
		assemble(Collections.singletonList(value))
	}

	/**
	 * Assembles the content tree of provided values.
	 * <p>
	 * The value should have been created with factory:
	 * <ul>
	 *   <li>descriptions are parsed and applied,</li>
	 *   <li>initializations are performed,</li>
	 *   <li>references are resolved</li>
	 * </ul>
	 * </p>
	 * <p>
	 * Do not call this method in a initialization.
	 * </p>
	 * 
	 * @param values to assemble
	 * @return a new pool of elements
	 * @throw NoSuchElementException if a reference cannot be found
	 * @throw ClassCastException if a reference target an incompatible type
	 * @throw IllegalStateException if a id defined used more than once
	 */
	def <R extends T> assemble(Iterable<R> values) {
		val builts = <R>newArrayList(values) /* isolate source and Fix order */
		createPool(builts, createAssembler().perform(builts))
	}

	/**
	 * Creates a basic assembler with handle construction phases.
	 * 
	 * @return new assembler instance
	 */
	protected def <S> createAssembler() {
		new ModItAssembler(impl as ModItImplementation<T, S>, createRegistry)
	}

	/**
	 * Create a pool from assembled elements.
	 * 
	 * @param root elements of pool
	 * @param assembler of root elements
	 * @return new pool instance
	 */
	protected def <R extends T> createPool(List<R> root, ModItAssembler<T, ?> assembler) {
		new ModItPool(root, assembler)
	}

	/**
	 * Creates a basic registry for pool.
	 * 
	 * @return new registry instance
	 */
	protected def createRegistry() {
		new ModItRegistry<T>(impl, description.getter)
	}

// Deprecated notation: 
//   createAs syntax follow create args order.
//   aliasCreate syntax is not convenient.
//

	/**
	 * Creates an {@link EObject} and associate it to id.
	 * 
	 * @param id of created element
	 * @param type the type of EObject to build
	 */
	@Deprecated // use createAs instead
	def <R extends T> R aliasCreate(String id, Class<R> type) {
		type.createAs(id, null, null)
	}

	/**
	 * Creates an {@link EObject} and initializes it and associate it to id.
	 * 
	 * @param type of EObject to build
	 * @param initializer of the given {@link EObject}
	 */
	@Deprecated // use createAs instead
	def <R extends T> R aliasCreate(String id, Class<R> type, String content) {
		type.createAs(id, content, null)
	}
	
	/**
	 * Creates an {@link EObject} and initializes it and associate it to id.
	 * 
	 * @param id of created element
	 * @param type of EObject to build
	 * @param initializer of the given {@link EObject}
	 */
	@Deprecated // use createAs instead
	def <R extends T> R aliasCreate(String id, Class<R> type, (R)=>void initializer) {
		type.createAs(id, null, initializer)
	}
	
	/**
	 * Creates an {@link EObject} and initializes it when assembling and associate it to id.
	 * 
	 * @param id of created element
	 * @param type of EObject to build
	 * @param content parsed parsed by content provider
	 */
	@Deprecated // use createAs instead
	def <R extends T> R aliasCreate(String id, Class<R> type, String content, (R)=>void init) {
		type.createAs(id, content, init)
	}

}
