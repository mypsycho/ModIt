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

import java.util.ArrayList
import java.util.Collection
import java.util.LinkedList
import java.util.NoSuchElementException

/**
 * This class wraps the construction of elements together.
 * 
 * @param <T> Common abstraction for all model elements: match ModIt constraint
 * @param <F> type for property descriptors.
 */
class ModItAssembler<T, F> {

	/**  */
	protected static val ThreadLocal<ModItAssembler<?, ?>> CURRENT_RUN = new ThreadLocal()

	extension val ModItImplementation<T, F> implementation

	protected val ModItRegistry<T> registry
	
	protected val onFlies = new LinkedList<T>

	new(ModItImplementation<T, F> impl, ModItRegistry<T> reg) {
		implementation = impl
		registry = reg
	}

	/**
	 * Implementation of buildTree.
	 * <p>
	 * Walk all objects to identify them. Then, update all references.
	 * </p>
	 * @throw NoSuchElementException if a reference cannot be found
	 * @throw ClassCastException if a reference target an incompatible type
	 * @throw IllegalStateException if a id defined used more than once
	 */
	def perform(Iterable<? extends T> values) {
		if (CURRENT_RUN.get !== null) throw new IllegalStateException("No inception supported, sorry")

		try {
			CURRENT_RUN.set(this)

			doPerform(values)

			while (!onFlies.empty) {
				val incompletes = new ArrayList(onFlies)
				onFlies.clear
				doPerform(incompletes)
			}
			
		} finally {
			CURRENT_RUN.remove
		}
		
		this
	}
	
	def void doPerform(Iterable<? extends T> values) {
		val builtValues = <T>newArrayList(values)
		
		// Builds all contents
		val stack = <T>newLinkedList(builtValues)
		while (!stack.empty || !onFlies.empty) {
			if (!stack.empty) {
				stack.applyPopAll[ 
					val content = unbindContent
					if (content !== null) {
						context.description.contentProvider.accept(content, it)	
					}
					unbindInit?.apply(it)
					onFlies.remove(it) // if already attached
				]
			} else {
				onFlies.forEach[
					if (containedBy(builtValues)) {
						stack += it
						unbindReference
					} else if (reference.containedBy(builtValues)) {
						builtValues += it
						stack += it
						unbindReference
					}
				]

				onFlies.clear
			}
		}

		// Builds all IDs
		val applyOnAllBuilt = [ (T)=>void action |	
			stack += builtValues
			while (!stack.empty) {
				stack.applyPopAll(action)
			}
		]
		
		applyOnAllBuilt.apply[ registerOnAlias ]
		// ?? Maybe substitution should happen when onAssembly is done. 
		applyOnAllBuilt.apply[ susbtituteAliases ]
		
		// For post-action, we want deeper first and last (attached) first
		val onAssemblies = new LinkedList<Pair<T, (T)=>void>>
		
		applyOnAllBuilt.apply[ 
			// Store execution order to reverse it.
			val onAssembly = unbindAssemble
			if (onAssembly !== null) {
				onAssemblies.add(0, it->onAssembly)
			}
		]
		
		// At the end, perform assembly tasks
		onAssemblies.forEach[ value.apply(key) ]

	}
	
	
	
	private def registerOnAlias(T it) {
		if (registry.isRegistered(it)) {
			return // already done
		}
		var String id = unbindAlias ?: context.description.idProvider?.apply(it)
		if (id === null) {
			return
		}
		val registered = registry.get(id)
		if ((registered !== null) && (registered !== it)) {
			throw new IllegalStateException("Duplicated id '" + id + "'")
		}
		registry.put(id, it)
	}
	
	private def susbtituteAliases(T it) {
		allReferences(it).forEach[ ref | updateRef(ref) ]
	}
	
	
	private def void applyPopAll(LinkedList<T> it, (T)=>void action) {
		val head = pop
		if (!contains(head)) { // Ensure uniqueness of work
			action.apply(head)
			addAll(0, implementation.contentOf(head))
		}
	}

	
	private def boolean containedBy(T it, Collection<?> pool) {
		(it !== null) // null must be handled when testing reference
			&& (pool.contains(it) || containedBy(implementation.containerOf(it), pool))
	}
	
	package static def <T> void candidate(T element) {
		(ModItAssembler.CURRENT_RUN.get as ModItAssembler<T, ?>)
			?.onFlies
			?.add(element)
	}

	def updateRef(T container, F prop) {
		// As this method is called is called A LOT. We avoid nice xtend functional syntax.
		val values = getValues(container, prop)
		if (values === null) return;

		values.filter[ proxy ].forEach [

			var targetValue = registry.get(proxyId);
			if (targetValue === null) { // assert found
				registry.debug
				throw new NoSuchElementException(
'''Unknown «proxyId» for «prop.propName» of «registry.getQName(container)»'''
 				)
			}
			val path = getProxyPath 
			// Warning: if path is return null (illegal), 
			// Elvis (?:) provide the wrong value
			if (path !== null) {
				targetValue = path.apply(targetValue)
			}

			if (targetValue !== null && !targetValue.assignableTo(prop)) {
				throw new ClassCastException(
'''At «registry.getQName(container)».«prop.propName», «««
«proxyId» targets a «targetValue.typeName» incompatible with «prop.refTypeName»'''
				)
			}

			val fail = container.replaceResolved(prop, it, targetValue)
			if (fail !== null) {
				throw new IllegalStateException(
'''At «registry.getQName(container)».«prop.propName», «proxyId» value fails because «fail»'''
				)
			}
		]

	}

}
