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
import org.eclipse.sirius.diagram.description.AdditionalLayer
import org.eclipse.sirius.diagram.description.BooleanLayoutOption
import org.eclipse.sirius.diagram.description.CustomLayoutConfiguration
import org.eclipse.sirius.diagram.description.DescriptionPackage
import org.eclipse.sirius.diagram.description.DiagramDescription
import org.eclipse.sirius.diagram.description.DiagramElementMapping
import org.eclipse.sirius.diagram.description.DiagramImportDescription
import org.eclipse.sirius.diagram.description.DoubleLayoutOption
import org.eclipse.sirius.diagram.description.EnumLayoutOption
import org.eclipse.sirius.diagram.description.EnumSetLayoutOption
import org.eclipse.sirius.diagram.description.IntegerLayoutOption
import org.eclipse.sirius.diagram.description.Layer
import org.eclipse.sirius.diagram.description.StringLayoutOption
import org.eclipse.sirius.diagram.description.filter.CompositeFilterDescription
import org.eclipse.sirius.diagram.description.filter.FilterPackage
import org.eclipse.sirius.diagram.description.filter.MappingFilter
import org.eclipse.sirius.diagram.sequence.description.SequenceDiagramDescription
import org.eclipse.sirius.viewpoint.description.tool.ModelOperation
import org.mypsycho.modit.emf.ClassId
import org.mypsycho.modit.emf.sirius.api.SiriusDiagram
import org.mypsycho.modit.emf.sirius.api.SiriusSequenceDiagram

/** Override of default reverse for SiriusModelProvider class. */
class DiagramTemplate extends DiagramPartTemplate<DiagramDescription> {
	
	static val DPKG = DescriptionPackage.eINSTANCE

	val static CONTAINMENT_ORDER = 
		(#[ 
			DiagramDescription -> #[
				DPKG.diagramDescription_Concerns,
				DPKG.diagramDescription_Filters
			]
		] 
		+ DiagramPartTemplate.CONTAINMENT_ORDER).toList
	
	
	static val INIT_TEMPLATED = RepresentationTemplate.INIT_TEMPLATED + #{
		DiagramDescription as Class<? extends EObject> -> #{
			// Diagram
			PKG.identifiedElement_Label, 
			DPKG.diagramDescription_DomainClass,
			DPKG.diagramDescription_DefaultLayer
		},
		Layer -> #{
			PKG.identifiedElement_Name
		},
		AdditionalLayer -> #{} // for imports
	} + RepresentationTemplate.INIT_TEMPLATED
	
	
	new(SiriusGroupTemplate container) {
		super(container, DiagramDescription)
	}

	override getInitTemplateds() { INIT_TEMPLATED }
	
	override getContainmentOrders() { CONTAINMENT_ORDER }
	
	override createDefaultContent() {
		new SiriusDiagram(tool.defaultContent, "", EObject) {
			
			override initContent(Layer it) {
				throw new UnsupportedOperationException("Must not be built")
			}
			
		}
	}
	
	def getBaseApiClass(EObject it) {
		switch(it) {
			SequenceDiagramDescription: SiriusSequenceDiagram
			DiagramImportDescription: null
			DiagramDescription: SiriusDiagram
		}
	}
	
	override isApplicableTemplate(DiagramDescription it) {
		baseApiClass !== null // not applicable
			&& defaultLayer !== null // ill-formed
			&& domainClass.classFromDomain !== null
	}
	
	override templateRepresentation(ClassId it, DiagramDescription content) {
		
'''«context.filerHeader»package «pack»

«templateImports»

import static extension org.mypsycho.modit.emf.sirius.api.SiriusDesigns.*

/**
 * Diagram '«content.name»'.
 * 
 * @generated
 */
class «name» extends «content.baseApiClass.templateClass» {

	new(«parentClassName» parent) {
		super(parent, «
			content.name.toJava», «
			content.label.toJava», «
			content.domainClass.classFromDomain.templateClass»)
	}

	override initContent(«content.templateClass» it) {
		super.initContent(it)
		metamodel.clear // Disable implicit metamodel import
		«content.templateFilteredContent(DiagramDescription)»
	}

	«defaultStyleTemplate»
	override initContent(«Layer.templateClass» it) {
		«
IF content.defaultLayer.name != "Default" /* see AbstractBaseDiagram */
		»name = «content.defaultLayer.name.toJava»
		«
ENDIF	»«content.defaultLayer.templateFilteredContent(Layer)»
	}

«
FOR section : content.defaultLayer.toolSections
SEPARATOR statementSeparator 
»	def «smartTemplateCreate(section)»() {
		«section.templateIdentifiedCreate»
	}

«
ENDFOR // DefaultLayer ToolSections
»«
FOR layer : content.additionalLayers
SEPARATOR statementSeparator 
»	def «smartTemplateCreate(layer)»() {
		«layer.templateIdentifiedCreate»
	}

«
	FOR section : layer.toolSections
	SEPARATOR statementSeparator
»	def «smartTemplateCreate(section)»() {
		«section.templateIdentifiedCreate»
	}

«
	ENDFOR // ToolSections
»«
ENDFOR  // Additional Layers
»
}''' // end-of-class
	}
	
	def expressed(String it) {
		it !== null && !blank
	}
	
	override templateToolOperation(ModelOperation it) {
		// Not a smartTemplateCreate case.
		// Applicable only tool property
		
		// null for InitialOperation.firstModelOperations = null
		val caller = it?.eContainer/* InitialOperation */
			?.eContainer
		
		caller instanceof DiagramDescription
			? '''initialisation = «templateInnerCreate»'''
			: super.templateToolOperation(it)
	}
	
	override templatePropertyValue(EStructuralFeature feat, Object value, (Object)=>String encoding) {
		DPKG.diagramDescription_Layout == feat && isElkLayered(value)
			? (value as CustomLayoutConfiguration).templateElkLayout
 			: DPKG.diagramDescription_Filters == feat && value instanceof CompositeFilterDescription
			? (value as CompositeFilterDescription).templateFiltering
			: FilterPackage.eINSTANCE.compositeFilterDescription_Filters == feat && value instanceof MappingFilter
			? (value as MappingFilter).templateMappingFilter(encoding)
			: super.templatePropertyValue(feat, value, encoding)
	}
	
	def isElkLayered(Object it) {
		it instanceof CustomLayoutConfiguration
			? id == "org.eclipse.elk.layered"
			: false
	}
	
	def templateElkLayout(CustomLayoutConfiguration it) {
		// @see org.mypsycho.modit.emf.sirius.api.SiriusDiagram#elkLayered(DiagramDescription, LayoutOption)
'''elkLayered(
«
FOR option : layoutOptions
SEPARATOR LValueSeparator
»	"«option.id.substring("org.eclipse.elk.".length)»".elk«
	switch(option) {
		BooleanLayoutOption: '''Bool(«option.value»'''
		DoubleLayoutOption: '''Double(«option.value»'''
		EnumLayoutOption: '''Enum("«option.value.name»"'''
		IntegerLayoutOption: '''Int(«option.value»'''
		StringLayoutOption: '''String("«option.value»"'''
		EnumSetLayoutOption: '''Enums("«option.values.map[ name ].join(",")»"'''
	}                                                  », «
	option.targets
		.map[ "LayoutOptionTarget." + name() ]
		.join(", ") »)«
ENDFOR»
)'''
	}
	
	def templateFiltering(CompositeFilterDescription it) {
'''filtering(«name.toJava») [
	«templateInnerContent(innerContent)»
]'''
	}
	
	def templateMappingFilter(MappingFilter it, (Object)=>String encoding) {
		val withView = viewConditionExpression.expressed
		val withElement = semanticConditionExpression.expressed
		
		withView && withElement  // all values, unlikely
 			? super.templatePropertyValue(FilterPackage.eINSTANCE.compositeFilterDescription_Filters, it, encoding)
 			: withElement ? templateMappingFilter("element", semanticConditionExpression)
 			: withView ? templateMappingFilter("view", viewConditionExpression)
 			: templateMappingFilter("all", null)
	}


	def String templateMappingFilter(MappingFilter it, String prefix, String expression) {
'''«prefix»«filterKind.getName().toLowerCase.toFirstUpper»(«
IF expression !== null										»«expression.toJava»,«
ENDIF														»
	«mappings.map[ templateRef(DiagramElementMapping) ].join(LValueSeparator)»
)'''
	}

}
