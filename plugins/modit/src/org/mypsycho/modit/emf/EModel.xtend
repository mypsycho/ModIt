/*******************************************************************************
 * Copyright (c) 2023 Nicolas PERANSIN.
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
package org.mypsycho.modit.emf;

import java.util.HashMap
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.xtend.lib.annotations.Accessors

/** 
 * Common abstraction for element managed by ModitResourceFactory.
 * 
 * @author nperansin
 */
abstract class EModel<T extends EObject> implements ModitModel {

	@Accessors
	val extras = new HashMap<String, EObject> 

	@Accessors
	protected val extension EModIt factory
	
	protected val Class<T> modelType
	
	new(Class<T> mType, EPackage... packages) {
		modelType = mType
		factory = EModIt.using(packages)
	}
	
	override loadContent(Resource it) {
		val values = resourceSet.buildModel.roots
		contents += values
		values
	}

	def buildModel() {
		buildModel(new ResourceSetImpl())
	}

	def buildModel(ResourceSet rs) {
		rs.initExtras()
		createContent
	}

	protected def createContent() {
		modelType.createAs(class.simpleName) [
			initContent
		].assemble
	}

	abstract protected def void initContent(T it)

	protected def void initExtras(ResourceSet it) {
	}

	def <T> T extraRef(Class<T> type, String key) {
		extras.get(key) as T
	}
	
	
	/** 
	 * Common abstraction for part of EModitModel.
	 */
	static abstract class Part<T extends EObject> {
	
		public val Class<T> modelType
		protected val EModel<?> context
		protected val extension EModIt factory
		protected val String alias
	
		new(Class<T> mType, EModel<?> parent) {
			this(mType, parent, null)
		}
		
		new(Class<T> mType, EModel<?> parent, String id) {
			modelType = mType
			context = parent
			factory = parent.factory
			alias = id?:class.simpleName
		}
		
		def T createContent() {
			modelType.createAs(alias) [
				initContent
			]	
		}
		abstract protected def void initContent(T it)
		
		def <T> T extraRef(Class<T> type, String key) {
			context.extraRef(type, key)
		}
		
	}
}
