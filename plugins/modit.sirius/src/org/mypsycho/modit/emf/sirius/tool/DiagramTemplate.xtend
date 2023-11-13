package org.mypsycho.modit.emf.sirius.tool

import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.sirius.diagram.description.AdditionalLayer
import org.eclipse.sirius.diagram.description.DescriptionPackage
import org.eclipse.sirius.diagram.description.DiagramDescription
import org.eclipse.sirius.diagram.description.DiagramElementMapping
import org.eclipse.sirius.diagram.description.DiagramImportDescription
import org.eclipse.sirius.diagram.description.Layer
import org.eclipse.sirius.diagram.description.filter.CompositeFilterDescription
import org.eclipse.sirius.diagram.description.filter.FilterPackage
import org.eclipse.sirius.diagram.description.filter.MappingFilter
import org.eclipse.sirius.diagram.description.style.EdgeStyleDescription
import org.eclipse.sirius.diagram.sequence.description.SequenceDiagramDescription
import org.eclipse.sirius.viewpoint.description.style.BasicLabelStyleDescription
import org.mypsycho.modit.emf.ClassId
import org.mypsycho.modit.emf.sirius.api.SiriusDiagram
import org.mypsycho.modit.emf.sirius.api.SiriusSequenceDiagram

/** Override of default reverse for SiriusModelProvider class. */
class DiagramTemplate extends DiagramPartTemplate<DiagramDescription> {
	
	static val DPKG = DescriptionPackage.eINSTANCE

	new(SiriusGroupTemplate container) {
		super(container, DiagramDescription)
	}

	
	val static CONTAINMENT_ORDER = 
		(#[ 
			DiagramDescription -> #[
				DPKG.diagramDescription_Concerns,
				DPKG.diagramDescription_Filters
			]
		] 
		+ DiagramPartTemplate.CONTAINMENT_ORDER).toList
	
	
	static val INIT_TEMPLATED = #{
		DiagramDescription as Class<? extends EObject> -> #{
			// Diagram
			SPKG.identifiedElement_Label, 
			SPKG.representationDescription_Metamodel,
			DPKG.diagramDescription_DomainClass,
			DPKG.diagramDescription_DefaultLayer
		},
		Layer -> #{
			SPKG.identifiedElement_Name
		},
		AdditionalLayer -> #{}
	} + RepresentationTemplate.INIT_TEMPLATED
	
		
	override getContainmentOrders() {
		CONTAINMENT_ORDER
	}
	
	/** Set of classes used in sub-parts by the default implementation  */
	override getPartStaticImports(EObject it) {
		#{ baseApiClass, BasicLabelStyleDescription, EdgeStyleDescription } + INIT_TEMPLATED.keySet
			// + !!! requires metamodel !!!
	}
	
	def getBaseApiClass(EObject it) {
		switch(it) {
			SequenceDiagramDescription: SiriusSequenceDiagram
			DiagramImportDescription: null
			DiagramDescription: SiriusDiagram
		}
	}
	
	
	override getInitTemplateds() {
		INIT_TEMPLATED
	}

	override isApplicableTemplate(DiagramDescription it) {
		baseApiClass !== null // not applicable
			&& defaultLayer !== null // ill-formed
			&& domainClass.classFromDomain !== null
	}
	
	override templateRepresentation(ClassId it, DiagramDescription content) {
		
		val explicitInitContent = content.templateFilteredContent(DiagramDescription)
		
'''package «pack»

«templateImports»

import static extension org.mypsycho.modit.emf.sirius.api.SiriusDesigns.*

class «name» extends «content.baseApiClass.templateClass» {

	new(«parentClassName» parent) {
		super(parent, «
			content.name.toJava», «
			content.label.toJava», «
			content.domainClass.classFromDomain.templateClass»)
	}

«
IF !explicitInitContent.empty 
»	override initContent(DiagramDescription it) {
		super.initContent(it)
		«explicitInitContent»
	}

«
ENDIF
»	override initDefaultStyle(BasicLabelStyleDescription it) {/* No reverse for Default */}
	override initDefaultEdgeStyle(EdgeStyleDescription it) {/* No reverse for Default */}

	override initContent(Layer it) {
		«content.defaultLayer.templateFilteredContent(Layer)»
	}

«
FOR section : content.defaultLayer.toolSections
SEPARATOR statementSeparator 
»	def «smartTemplateCreate(section)»() {
		«section.templateIdentifiedCreate»
	}

«
ENDFOR
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
	ENDFOR
»«
ENDFOR
»
}''' // end-of-class
	}
	
	def expressed(String it) {
		it !== null && !blank
	}
	
	override templatePropertyValue(EStructuralFeature feat, Object value, (Object)=>String encoding) {
 		DPKG.diagramDescription_Filters == feat && value instanceof CompositeFilterDescription
			? (value as CompositeFilterDescription).templateFiltering
			: FilterPackage.eINSTANCE.compositeFilterDescription_Filters == feat && value instanceof MappingFilter
			? (value as MappingFilter).templateMappingFilter(encoding)
			: super.templatePropertyValue(feat, value, encoding)
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
 			: withElement ? templateElementFilter(it)
 			: withView ? templateViewFilter(it)
 			: templateAllFilter(it)
	}
 			
	def String templateElementFilter(MappingFilter it) {
'''element«filterKind.getName().toLowerCase.toFirstUpper»(«semanticConditionExpression.toJava»,
	«mappings.map[ templateRef(DiagramElementMapping) ].join(LValueSeparator)»
)'''
	} 			
 			
	def String templateViewFilter(MappingFilter it) {
'''view«filterKind.getName().toLowerCase.toFirstUpper»(«viewConditionExpression.toJava»,
	«mappings.map[ templateRef(DiagramElementMapping) ].join(LValueSeparator)»
)'''
	} 			
 			
	def String templateAllFilter(MappingFilter it) {
'''all«filterKind.getName().toLowerCase.toFirstUpper»(
	«mappings.map[ templateRef(DiagramElementMapping) ].join(LValueSeparator)»
)'''
	}
	
}
