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

import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.sirius.properties.Category
import org.eclipse.sirius.properties.ContainerDescription
import org.eclipse.sirius.properties.GroupConditionalStyle
import org.eclipse.sirius.properties.GroupDescription
import org.eclipse.sirius.properties.GroupStyle
import org.eclipse.sirius.properties.PageDescription
import org.eclipse.sirius.properties.ViewExtensionDescription
import org.eclipse.sirius.properties.WidgetConditionalStyle
import org.eclipse.sirius.properties.WidgetStyle
import org.mypsycho.modit.emf.ClassId
import org.mypsycho.modit.emf.sirius.api.AbstractPropertySet

import static extension org.mypsycho.modit.emf.sirius.api.SiriusDesigns.*

class PropertiesTemplate extends RepresentationTemplate<ViewExtensionDescription> {
	
	/** Set of classes used in sub parts by the default implementation  */
	static val PART_IMPORTS = #{  
		AbstractPropertySet, Category
	}
	
	static val NS_MAPPING = #[
		Category -> AbstractPropertySet.Ns.category,
		PageDescription -> AbstractPropertySet.Ns.page,
		ViewExtensionDescription -> AbstractPropertySet.Ns.view,
		GroupDescription -> AbstractPropertySet.Ns.group
	]
	
	static val CONTAINMENT_ORDER = #[
		ContainerDescription -> #[
			PPKG.abstractContainerDescription_Extends,
			PPKG.abstractContainerDescription_Layout
		],
		GroupDescription -> #[
			PPKG.abstractGroupDescription_Style,
			PPKG.abstractGroupDescription_ConditionalStyles
		]
	]
	
	new(SiriusGroupTemplate container) {
		super(container, ViewExtensionDescription)
	}
	
	override getPartStaticImports(EObject it) {
		// no super: EModit and EObject are not used directly
		val multiCat = (it instanceof ViewExtensionDescription 
			? categories.size != 1 ? #[ ViewExtensionDescription ]) 
			?: #[]
		
		PART_IMPORTS + multiCat
	}
	
	override isPartTemplate(EObject it) { super.isPartTemplate(it) }
	
	protected override getContainmentOrders() { CONTAINMENT_ORDER }
	
	override getNsMapping() { NS_MAPPING }
	
	override templateRepresentation(ClassId it, ViewExtensionDescription content) {
		// Parent class cannot use import detection 
		//   as class does not exist (part of generation)
		val parentName = (pack != context.mainClass.pack) 
			? context.mainClass.qName
			: context.mainClass.name
		
'''package «pack»

«templateImports»

import static extension org.mypsycho.modit.emf.sirius.api.SiriusDesigns.*

class «name» extends «AbstractPropertySet.templateClass» {

	new(«parentName» parent) {
		super(parent« IF content.name != AbstractPropertySet.DEFAULT_NAME
					», «content.name.toJava»«
ENDIF				»)
	}

« 
IF content.categories.size == 1
»	override initDefaultCategory(Category it) {
		«content.categories.head.templateFilteredContent(Category)»
	}
« 
ELSE 
»	override initCategories(ViewExtensionDescription it) {
		«FOR category : content.categories »
		category(«category.name.toJava») [ «category.initMethod» ]
		«ENDFOR»
	}

«
	FOR category : content.categories 
»	protected def void «category.initMethod»(Category it) {
		«category.templateFilteredContent(Category)»
	}
«
	ENDFOR
»«
ENDIF
»
}''' // end-of-class
	}
	
	def initMethod(Category it) {
		val label = name.techName
		label.endsWith("Category")
			? '''init«name.techName»'''
			: '''init«name.techName»Category'''
	}

	override templatePropertyValue(EStructuralFeature feat, Object value, (Object)=>String encoding) {
		feat.name == "style" && value instanceof WidgetStyle
			? (value as WidgetStyle).templateStyle
			: feat.name == "conditionalStyles" && value instanceof WidgetConditionalStyle
			? (value as WidgetConditionalStyle).templateConditionalStyle
			: PPKG.abstractGroupDescription_Style == feat 
			? (value as GroupStyle).templateStyle
			: PPKG.abstractGroupDescription_ConditionalStyles == feat 
			? (value as GroupConditionalStyle).templateConditionalStyle
			: super.templatePropertyValue(feat, value, encoding)
	}
	
	def templateStyle(EObject it) {
'''style = [
	«templateInnerContent(innerContent)»
]'''}
		
	def templateConditionalStyle(WidgetConditionalStyle it) {
		val style = eGet(eClass.getEStructuralFeature("style")) as EObject
'''styleIf(«preconditionExpression.toJava») [
	«style.templateInnerContent(style.innerContent)»
]'''}
		
	
}