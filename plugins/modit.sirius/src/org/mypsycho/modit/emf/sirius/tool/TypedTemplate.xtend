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
package org.mypsycho.modit.emf.sirius.tool

import java.nio.file.Path
import java.util.Collections
import java.util.List
import java.util.Map
import java.util.Objects
import java.util.Set
import org.eclipse.core.runtime.Platform
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.sirius.viewpoint.description.DescriptionPackage
import org.eclipse.sirius.viewpoint.description.IdentifiedElement
import org.mypsycho.modit.emf.ClassId
import org.mypsycho.modit.emf.EReversIt
import org.mypsycho.modit.emf.sirius.api.SiriusDesigns

import static extension org.mypsycho.modit.emf.sirius.tool.SiriusReverseIt.*

/** 
 * Common methods for reverse targeting specific API.
 */
// Target EObject as DiagramExtensionDescription does not extends Representation.
abstract class TypedTemplate<R extends EObject> extends EReversIt {
	
	protected static val PKG = DescriptionPackage.eINSTANCE

	protected static val CONTENT_PROVIDER_FIELDS = #{
		PKG.identifiedElement_Name,
		PKG.abstractVariable_Name
	}	

	// XTend does not support statefull inner class
	protected val extension SiriusReverseIt tool
	protected val Class<R> targetClass
	
	// May an issue with Diagram sub-kind

	protected Map<EClass, EObject> defaultInits = newHashMap
	
	new(TypedTemplate<?> parent, Class<R> target) {
		super(parent)
		tool = parent.tool
		targetClass = Objects.requireNonNull(target)
	}

	new(SiriusReverseIt container, String classname, Path dir, Resource res, Class<R> target) {
		super(classname, dir, res)
		tool = container
		targetClass = Objects.requireNonNull(target)
	}
		
	def List<? extends Pair<
			? extends Class<? extends EObject>, 
			? extends Enum<?>
			>> getNsMapping()

	override isPartTemplate(EObject it) {
		targetClass.isInstance(it) 
			&& isApplicableTemplate(it as R)
	}
	
	def isApplicableTemplate(R it) { true }

	def getParentClassName(ClassId it) {
		// Parent class cannot use import detection 
		//   as class does not exist (part of generation)
		pack != context.mainClass.pack
			? context.mainClass.qName 
			: context.mainClass.name
	}
	
	/** Lists fields where a accelerator replace basic assignment. */
	def Map<? extends Class<? extends EObject>, 
			? extends Set<? extends EStructuralFeature>> 
			getInitTemplateds() {
		Map.of
	}
	
	protected def String templateFilteredContent(EObject it, Class<? extends EObject> filter) {
		val filtered = initTemplateds.get(filter) ?: Collections.emptySet
		val content = innerContent
			.filter[ !filtered.contains(key) ]
			.toList
		templateInnerContent(content)
	}
 
	override getInnerContent(EObject it) {
		super.getInnerContent(it)
			// Following feature are supported by contentProvider
			// See org.mypsycho.modit.emf.sirius.SiriusModelProvider#new(Iterable<? extends EPackage>)
			.filter[ !CONTENT_PROVIDER_FIELDS.contains(key) ]
	}

 	def dispatch smartTemplateCreate(EObject it) {
		super.smartTemplateCreate(it)
	}
	
	def dispatch smartTemplateCreate(IdentifiedElement it) {
		templateIdentifiedCreate(it)
	}

	def findNs(IdentifiedElement it) {
		nsMapping
			.findFirst[ mapping | mapping.key.isInstance(it) ]
			?.value
	}
	
	def String templateIdentifiedCreate(IdentifiedElement it) { // Default
'''«templateIdentifiedCreateHeader» [
	«templateInnerContent(innerContent)»
]'''
	}
	
	def String templateIdentifiedCreateHeader(IdentifiedElement it) { // Default
		// We assume names follows the guidelines.
		// Store aliases to detect conflict.
		val ns = findNs
'''«templateClass».create«
IF ns !== null          »As(Ns.«ns.name», «
ELSE                    »(«
ENDIF                    »«name.toJava»)'''
	}

	override callPath(EObject it, boolean withExtras) {
		if (it instanceof IdentifiedElement) {
			if (withExtras) {
				val ns = findNs
				if (ns !== null) {
					return nsRefCallPath(ns)
				}
			}
		}
		return super.callPath(it, withExtras)
	}
	
	def nsRefCallPath(IdentifiedElement it, Enum<?> ns) {
		currentContent.toString
		
		if (currentContent.isContaining(it)) {
			return new NsRefExpr(it, ns, null)
		}
		val declaring = context.splits.keySet
			.findFirst[ key | key.isContaining(it) ]
		declaring !== null
			? new NsRefExpr(it, ns, context.splits.get(declaring))
			: super.callPath(it, true)
	}
	
	static class NsRefExpr extends Expr {
		
		protected val Enum<?> ns
		protected val ClassId declaring
		
		new (IdentifiedElement src, Enum<?> ns, ClassId declaring) {
			super(src)
			this.ns = ns
			this.declaring = declaring
		}
		
		def isLocal() { declaring === null }
		
		def getSource() { super.src as IdentifiedElement }
	}
	
	protected def dispatch String templateRef(EObject it, NsRefExpr root, Expr path, Class<?> using) {
		val refRoot = root.local
			? "localRef("
			: '''ref(«root.declaring.name», '''

'''«eClass.templateClass».«refRoot»Ns.«root.ns.name», «root.source.aliasPath.toJava»)«templateAliasPath(path)»'''
	}

	protected def aliasPath(IdentifiedElement it) { name }

	dispatch override toJava(String it) {
		if (!startsWith(SiriusDesigns.AQL)) {
			return super._toJava(it)
		} 
		
		var expression = substring(SiriusDesigns.AQL.length)
		// Issue with _'_ in templates
		if (expression.startsWith("'") || expression.endsWith("'")) {
			expression = ''' «expression» ''' // add a safe-space
		}
		// «» can be used to escape '
		'''«"'''"»«expression»«"'''"».trimAql'''
	}


	def isReferencingSubType(EStructuralFeature it, Class<?> type) {
		type.isAssignableFrom(EType.instanceClass)
	}

	def classExits(String classname) {
		try {
			pluginId !== null
				&& Platform?.getBundle(pluginId)
					?.loadClass(classname) !== null
		} catch(ClassNotFoundException cnfe) {
			false
		}
	}

	def templateContainedValues(Iterable<? extends EObject> values) {
		values.map[ templateCreate ].join(LValueSeparator)
	}



}
