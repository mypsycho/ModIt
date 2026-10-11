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

import java.util.ArrayDeque
import java.util.ArrayList
import java.util.Collection
import java.util.Collections
import java.util.Deque
import java.util.HashMap
import java.util.List
import java.util.Map
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EClassifier
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.emf.ecore.EcorePackage
import org.eclipse.xtend.lib.annotations.Accessors

/**
 * EMF Stretcher can associate value to item for all EMF meta-element.
 * <p>
 * When queried by item, value are resolved according inheritance relation of EMF classifiers.
 * </p>
 * <p>Items declares @{
 */
class EmfStretcher {

	@Accessors
	val List<? extends EPackage> allSources // Order is fixed

	val Map<? extends EPackage, ? extends EmfAspect.Package> elements

	val List<? extends EmfStretcher> extensions

	var Map<? extends EClass, ? extends EClassStretcher> contents = null

	val extras = new HashMap<EClassifier, EClassStretcher>

	var progressions = new ArrayDeque<EClassifier> // set to null when initialized

	new(EPackage... sources) {
		this(sources, true, Collections.emptyList)
	}

	new(List<? extends EPackage> sources, boolean recursive, List<? extends EmfStretcher> extensions) {
		allSources = new ArrayList(
			if (!recursive) sources
			else sources.map[ #[ it ] + eAllContents.toIterable.filter(EPackage) ].flatten.toList
		)
		this.extensions = extensions
		elements = allSources.toInvertedMap[ new EmfAspect.Package(it, true) ]
		
		// must avoid circular pattern in EmfStretcher
		assertTree(new ArrayDeque, new ArrayList)
		
		// Creating EClassStretcher instance requires elements.
		extras.put(EcorePackage.eINSTANCE.EObject, 
			extensions.empty 
				? new EClassStretcher(this, EcorePackage.eINSTANCE.EObject)
				// We are exposed to inconsistency
	 			: extensions.head.onClass(EcorePackage.eINSTANCE.EObject)
		)
	}

	def getTargets() { allSources }

	protected def assertInit() {
		if (contents === null) throw new IllegalStateException("Not initialized")
	}
	
	def EmfStretcher initialize() {
		if (contents !== null) {
			return this // already done
		}
		extensions.forEach[ initialize ]
		contents = allSources
			.map[ EClassifiers ] // elements, no sub package
			.flatten.filter(EClass) // classes
			.toInvertedMap[ new EClassStretcher(this, it) ]
		
		contents.values.forEach [
			progressions.push(source)
			compute
			progressions.pop
		]
		progressions = null
		this
	}

	def boolean canProvide(EClassifier it) {
		contents.containsKey(it) 
			|| extras.containsKey(it) 
			|| extensions.exists[ ext | ext.canProvide(it) ]
	}

	def toEClass(Class<? extends EObject> it) {
		assertInit
		// We won't reach extensions
		// User is supposed to know the structure
		val eClass = (contents.keySet + extras.keySet)
			.findFirst[ t| t.instanceClass == it ]
		
		if (eClass === null) {
			throw new IllegalArgumentException(name + ' is not defined in this context.')
		} 
		eClass
	}


	def onClass(Class<? extends EObject> it) {
		toEClass.onClass
	}

	def onClass(EClassifier it) {
		val result = tryOnClass
		if (result === null) {
			throw new IllegalArgumentException(name + ' is not defined in this context.')
		}	
		result
	}

	protected def EClassStretcher tryOnClass(EClassifier it) {
		assertInit
		contents.get(it) ?: extras.get(it) ?: extensions.findFirst[ ext|ext.canProvide(it) ]?.onClass(it)
	}

	package def List<?extends EClassStretcher> computeInheritances(EClassifier it) {
		val EClassStretcher content = tryOnClass ?: extras.computeIfAbsent(it)[ new EClassStretcher(this, it) ]
		if (content.computed) {
			return content.inheritances
		}
		if (progressions.contains(it)) {
			throw new IllegalStateException("Circular evaluation of " + name)
		}
		progressions.push(it)
		content.compute
		progressions.pop
		content.inheritances
	}

	def getAspect(EPackage it) { elements.get(it) }


	/**
	 * Add this participation to a classifier.
	 * 
	 * @param it classifier
	 * @param option to add
	 */
	protected def add(EClassifier it, EmfParticipant.Participation<?> option) {
		EPackage.aspect.add(it, option.key, option)
	}

	/**
	 * Add this participation to a feature for a class.
	 * 
	 * @param it class-&gt;feature
	 * @param option to add
	 */
	protected def add(Pair<EClass, EStructuralFeature> it, EmfParticipant.Participation<?> option) {
		key.assertApplicable(value)
		key.EPackage.aspect.add(key, option.key.toFeatID(value), option)
	}


	/**
	 * Returns an implementation binding to this class.
	 * 
	 * @param it class to bind
	 * @param ext extension to assign
	 * @param extension binding
	 */	
	def <T, O extends EObject, V extends O> with(Class<V> it, EmfExtensions.XObject<T, O> ext) {
		ext.bind(this, it)
	}

	/**
	 * Returns an implementation binding to this class.
	 * <p>
	 * For compressed syntax, '<<' can be used with '+=' operator of OBinding
	 * </p>
	 * 
	 * @param it class to bind
	 * @param ext extension to assign
	 * @param extension binding
	 */	
	def <T, O extends EObject, V extends O> operator_doubleLessThan(Class<V> it, EmfExtensions.XObject<T, O> ext) {
		with(ext)
	}

	def <T,V extends EObject> with(Pair<Class<V>, EStructuralFeature> it, EmfExtensions.XValue<T> ext) {
		ext.bind(this, key, value)
	}
	
	// '<<' can be used with '+=' operator of _Binding
	def <T,V extends EObject> operator_doubleLessThan(Pair<Class<V>, EStructuralFeature> it, EmfExtensions.XValue<T> ext) {
		with(ext)
	}

	// API is asymmetric on purpose

	// EmfToolings
	// EmfToolings.XClass

	// '<<' can be used with '+=' operator of _Binding
	def <T> with(EClassifier it, EmfToolings.XClass<T> ext) {
		ext.bind(this, it)
	}
	
	def <T> operator_doubleLessThan(EClassifier it, EmfToolings.XClass<T> ext) {
		with(ext)
	}
	
	def <T> with(Class<? extends EObject> it, EmfToolings.XClass<T> ext) {
		toEClass.with(ext)
	}
	
	def <T> operator_doubleLessThan(Class<? extends EObject> it, EmfToolings.XClass<T> ext) {
		with(ext)
	}
	
	def <T> getValue(EClass it, EmfToolings.XClass<T> part) {
		part.exec(it, onClass.getThis(part) as EmfToolings.CBinding<T>)
	}
	
	// '*' replace '.' syntax
	def <T> operator_multiply(EClass it, EmfToolings.XClass<T> part) {
		getValue(part)
	}

	// EmfToolings.XFeature
	
	// '<<' can be used with '+=' operator of _Binding
	def <T> operator_doubleLessThan(Pair<EClass, EStructuralFeature> it, EmfToolings.XFeature<T> ext) {
		ext.bind(this, key, value)
	}

	// '<<' can be used with '+=' operator of _Binding
	def <T> operator_doubleLessThan(EStructuralFeature it, EmfToolings.XFeature<T> ext) {
		ext.bind(this, it)
	}
	
	def <T> getValue(Pair<EClass, EStructuralFeature> it, EmfToolings.XFeature<T> part) {
		part.exec(key, value, key.onClass.getThis(part.toFeatID(value)) as EmfToolings.FBinding<T>)
	}
	
	// '*' replace '.' syntax
	def <T> operator_multiply(Pair<EClass, EStructuralFeature> it, EmfToolings.XFeature<T> part) {
		getValue(part)
	}

	// '*' replace '.' syntax
	def <T> operator_multiply(EStructuralFeature it, EmfToolings.XFeature<T> part) {
		(eClass->it).getValue(part)
	}


	// EmfExtensions
	// EmfExtensions.XObject
	def <T, O extends EObject, V extends O> getValue(V it, EmfExtensions.XObject<T, O> part) {
		part.exec(it, this, eClass.onClass.getThis(part) as EmfExtensions.OBinding<T, O, ? super V>)
	}

	def <T, O extends EObject, V extends O> operator_multiply(V it, EmfExtensions.XObject<T, O> part) {
		getValue(part)
	}

	def <T, O extends EObject, V extends O, C extends V> T getSuper(C it, Class<V> type, EmfExtensions.XObject<T, O> part) {
		part.exec(it, this, eClass.onClass.getSuper(type, part) as EmfExtensions.OBinding<T, O, ? super V>)
	}
	

	// EmfExtensions.XValue
	def <T, V extends EObject> getValue(V it, EStructuralFeature feat, EmfExtensions.XValue<T> part) {
		part.exec(it, feat, this, eClass.onClass.getThis(part.toFeatID(feat)) as EmfExtensions.VBinding<T, ? super V>)
	}
	
	def <T, V extends EObject> getValue(Pair<V, EStructuralFeature> it, EmfExtensions.XValue<T> part) {
		key.getValue(value, part)
	}

	def <T, V extends EObject> operator_multiply(Pair<V, EStructuralFeature> it, EmfExtensions.XValue<T> part) {
		getValue(part)
	}

	def <T, V extends EObject, C extends V> getSuper(C it, EStructuralFeature feat, Class<V> type, EmfExtensions.XValue<T> part) {
		part.exec(it, feat, this, eClass.onClass.getSuper(type, part.toFeatID(feat)) as EmfExtensions.VBinding<T, ? super V>)
	}

	def <T, V extends EObject, C extends V> T getSuper(Pair<C, EStructuralFeature> it, Class<V> type, EmfExtensions.XValue<T> part) {
		key.getSuper(value, type, part)
	}
	
	
	protected static def toFeatID(EmfParticipant ext, EStructuralFeature feat) {
		ext->feat
	}


	protected static def assertApplicable(EClassifier it, EStructuralFeature feat) {
		if (it instanceof EClass) if (!EAllStructuralFeatures.contains(feat)) {
			throw new IllegalArgumentException(feat.name + ' is not a feature of EClass ' + name)	
		}
	}

	protected static def void assertTree(EmfStretcher it, Deque<EmfStretcher> stack, Collection<EmfStretcher> cumul) {
		if (cumul.contains(it)) { // been there, done that
			return
		}
		if (stack.contains(it)) {
			throw new IllegalArgumentException(
				"Circular analysis " + stack.join(" -> ")[ allSources.join(",", "Pack[ ", " ]")[ name ] ]
			)
		}

		stack.push(it)
		extensions.forEach[ assertTree(stack, cumul) ]
		cumul.add(it)
		stack.pop
	}


}
