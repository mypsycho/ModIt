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
package org.mypsycho.modit.emf.stretch

import java.util.HashMap
import java.util.Map
import java.util.function.Function
import org.eclipse.emf.ecore.ENamedElement
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EPackage

abstract class EmfAspect<E extends ENamedElement> {
	
	public val E source

	new(E source) { this.source = source }

	// Basic Operation
	def ENamedElement add(ENamedElement it, Object key, Object value)

	def Object get(ENamedElement it, Object option)

	def add(ENamedElement target, Iterable<? extends Pair<?, ?>> options) {
		options.forEach[option| target.add(option.key, option.value) ]		
	}
	def operator_add(ENamedElement target, Pair<?, ?> option) {
		target.add(option.key, option.value)
	}
	def operator_add(ENamedElement target, Iterable<? extends Pair<?, ?>> options) {
		target.add(options)
	}





	def static boolean isContaining(EObject it, EObject value) {
		value !== null && (it == value || isContaining(value.eContainer))
	}

	/**
	 * Assert the value is an ancestor of it.
	 * <p>
	 * @param it should be the ancestor
	 * @param value to test
	 * @return value when ok
	 * @throws IllegalArgumentException when KO
	 */
	def static <E extends ENamedElement> assertContaining(ENamedElement it, E value) {
		if (isContaining(value)) value
		else throw new IllegalArgumentException(name + " do not belong to " + value.name)
	}

	static val Function<ENamedElement, Map<Object, Object>> MAP_PROVIDER = [ new HashMap ]
	static class Default<E extends ENamedElement> extends EmfAspect<E> {

		val properties = new HashMap<ENamedElement, Map<Object, Object>>
		val boolean writeOnce

		new(E value, boolean cached) {
			super(value)
			writeOnce = cached
		}
		
		// TODO : adapt Feature

		protected def doAdd(ENamedElement target, Object key, Object value) {
			val values = properties.computeIfAbsent(target, MAP_PROVIDER)
			if (writeOnce && values.containsKey(key)) {
				throw new IllegalStateException("Duplicated assignment of " + key + " on " + target)
			}
			values.put(key, value)
		}

		override add(ENamedElement it, Object key, Object value) {
			doAdd(source.assertContaining(it), key, value)
			it
		}

		override get(ENamedElement it, Object option) {
			properties.get(it)?.get(option)
		}



	}

	static class Specific<E extends ENamedElement> extends EmfAspect<E> {

		val EmfAspect<?> container

		new(E value, EmfAspect<?> parent) {
			super(parent.source.assertContaining(value))
			this.container = parent
		}

		override add(ENamedElement it, Object key, Object value) {
			container.add(source.assertContaining(it), key, value)
		}

		override get(ENamedElement it, Object option) {
			container.get(source.assertContaining(it), option)
		}

	}

	static class Package extends Default<EPackage> {

		new(EPackage value, boolean cached) { super(value, cached) }

		def toEClass(Class<? extends EObject> it) { // Can work only if value is a package
			val target = source.EClassifiers.findFirst[c| c.instanceClass == it]
			if (target === null) {
				throw new IllegalArgumentException(name + " do not belong to " + source.name)
			}
			target
		}

		// Reflective API
		def ENamedElement add(Class<? extends EObject> it, Object key, Object value) {
			toEClass.add(key, value)
		}
	
	
		// Reflective:Operator API
		def operator_add(Class<? extends EObject> it, Pair<?, ?> option) {
			add(option.key, option.value)
		}
	
		def operator_add(Class<? extends EObject> it, Iterable<?extends Pair<?, ?>> options) {
			val eClass = toEClass
			options.forEach[option| eClass.add(option.key, option.value) ]
		}
	

	}

}
