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

import java.util.ArrayList
import java.util.Collections
import java.util.HashMap
import java.util.List
import org.eclipse.emf.common.notify.impl.NotificationChainImpl
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.InternalEObject
import org.eclipse.emf.ecore.util.FeatureMapUtil
import org.eclipse.emf.ecore.util.InternalEList
import org.eclipse.xtend.lib.annotations.Accessors
import org.mypsycho.modit.ModIt
import org.mypsycho.modit.ModItDescriptor
import org.mypsycho.modit.ModItImplementation
import org.mypsycho.modit.emf.EModItProcInfo.PiType

import static extension org.mypsycho.modit.emf.EModItProcInfo.*

/**
 * Mod-it implementation for Ecore Modeling Framework.
 * <p>
 * Best way to use is by creating an extension singleton.
 * </p>
 */
class EModIt extends ModIt<EObject> {
	
	// Public for testing purpose
	public static val String PROXY_URI_SCHEME = "modit";
	
	/**
	 * Create a factory instance for provided packages.
	 * 
	 * @param packages containing EClass to create
	 */
	static def using(EPackage...  packages) {
		return using(packages, null)
	}
	
	/**
	 * Create a factory instance for provided package.
	 * 
	 * @param package containing EClass to create
	 * @param initializer define factory context
	 */
	static def using(EPackage  packages, (Descriptor)=>void initializer) {
		return using(#[ packages ], initializer)
	}
	
	/**
	 * Create a factory instance for provided packages.
	 * 
	 * @param packages containing EClass to create
	 * @param initializer define factory context
	 */
	static def using(List<?extends EPackage> packages, (Descriptor)=>void initializer) {
		new EModIt(new Descriptor => [
				ePackages += packages
				initializer?.apply(it)
			], [ new Implementation(it) ])
	}
	
	/**
	 * Descriptor for EMF factory.
	 */
	@Accessors
	static class Descriptor extends ModItDescriptor<EObject> {
		/** Packages containing EClass to instantiate. */
		val List<EPackage> ePackages = new ArrayList
		/** Include inner package */
		var boolean subPackage = true
	}
	
	
	/**
	 * Create a factory with immutable strategy.
	 * <p>
	 * Prefer calling '#using(...)' methods.
	 * </p>
	 * 
	 * @param descr of the factory
	 * @param delegation implementation of EMF access
	 */
	new(Descriptor descr, (ModIt<EObject>)=>ModItImplementation<EObject, ?> delegation) {
		super(descr, delegation)
	}
	
	
	/**
	 * Implementation for EObjects.
	 */
	protected static class Implementation extends ModItImplementation<EObject, EReference> {

		val rules = new HashMap<Class<? extends EObject>, ()=>EObject>()
	
		/**
		 * Provide adapter for EMF.
		 * 
		 * @param context of implementation
		 */
		new(ModIt<EObject> context) {
			super(context)
		}
	
		override init(ModItDescriptor<EObject> descr) {
			val eDescr = descr as EModIt.Descriptor
			eDescr.ePackages // all Packages
				.map[ if (eDescr.subPackage) eAllContents.toIterable else EClassifiers ]
				.flatten // all definitions (even in subpackages)
				.filter(EClass).filter[ !abstract ] // all creatable EClass
				.forEach [
					rules.put(instanceClass as Class<? extends EObject>, // EClass provides EObject
						[ EPackage.EFactoryInstance.create(it) ])
				]
		}
	
		override <T extends EObject> T create(Class<T> type) {
			val rule = rules.get(type);
			if (rule === null) {
				throw new IllegalArgumentException("Unknown factory for type " + type.name)
			}
			type.cast(rule.apply)
		}
	
		override isProxy(EObject it) {
			if (it instanceof InternalEObject) (eProxyURI !== null && PROXY_URI_SCHEME == eProxyURI.scheme)
			else false
		}

		override getProxyId(EObject it) {
			URI.decode((it as InternalEObject).eProxyURI.opaquePart)
		}
		
		override getProxyPath(EObject it) {
			PiType.path.unbind(it)
		}
		
		override <R extends EObject> initProxyId(EObject it, String id, (EObject)=>R path) {
			(it as InternalEObject).eSetProxyURI(URI.createGenericURI(PROXY_URI_SCHEME, URI.encodeOpaquePart(id, false), null))
			if (path !== null) PiType.path.bind(it, path)
		}
	
		override getValues(EObject container, EReference property) {
			val it = container.eGet(property, false)
			if (it === null) null
			else if (property.isMany) (it as InternalEList<InternalEObject>).basicList
			else Collections.singleton(it as InternalEObject)
		}
	 
		override contentOf(EObject value) { value.eContents }
		
		override allReferences(EObject container) {
			container.eClass.EAllReferences.filter[ !isDerived && !containment ]
		}
	
		override containerOf(EObject it) { eContainer }
		
		override typeName(EObject it) { eClass.name }
	
		override propName(EReference it) { name }
		
		override refTypeName(EReference it) { it.EType.name }
	
		override assignableTo(EObject value, EReference prop) { prop.EType.isInstance(value) }
	
		override replaceResolved(EObject container, EReference feature, 
				EObject oldValue, EObject newValue) {
			if (feature.containment) {
				return "Cannot use a reference in a containment"
			}
					
			if (FeatureMapUtil.isMany(container, feature)) {
				if (newValue === null) {
					return "Null value is unsupported on multi references"
				}
				
				// We use internal APIs to avoid resolving any value in the list
				val list = container.eGet(feature, false) as InternalEList<Object>;
				val indexOf = list.basicIndexOf(oldValue)
				list.basicRemove(oldValue, new NotificationChainImpl)
				list.addAllUnique(indexOf, Collections.singleton(newValue))
			} else {
				container.eSet(feature, newValue);
			}
			null // no error
		}
		
		override bindAlias(EObject it, String id) {
			PiType.alias.bind(it, id)
		}
	
		override unbindAlias(EObject it) {
			PiType.alias.unbind(it)
		}
		
		override bindContent(EObject it, String id) {
			PiType.content.bind(it, id)
		}
	
		override unbindContent(EObject it) {
			PiType.content.unbind(it)
		}
				
		override <R extends EObject> bindInit(R it, (R)=>void task) {
			PiType.init.bind(it, task)
		}
	
		override <R extends EObject> unbindInit(EObject it) {
			PiType.init.unbind(it)
		}
		
		override <R extends EObject> bindAssemble(R it, (R)=>void task) {
			PiType.assemble.bind(it, task)
		}
	
		override <R extends EObject> unbindAssemble(EObject it) {
			PiType.assemble.unbind(it)
		}

		override bindReference(EObject it, EObject ref) {
			PiType.reference.bind(it, ref)
		}
	
		override unbindReference(EObject it) {
			PiType.reference.unbind(it)
		}
	
		override reference(EObject it) {
			PiType.reference.test(it)
		}

	}
   
}