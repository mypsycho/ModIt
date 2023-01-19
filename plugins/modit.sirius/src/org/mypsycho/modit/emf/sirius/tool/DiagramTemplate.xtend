package org.mypsycho.modit.emf.sirius.tool

import org.eclipse.emf.ecore.EObject
import org.eclipse.sirius.diagram.description.AdditionalLayer
import org.eclipse.sirius.diagram.description.DescriptionPackage
import org.eclipse.sirius.diagram.description.DiagramDescription
import org.eclipse.sirius.diagram.description.Layer
import org.mypsycho.modit.emf.ClassId
import org.mypsycho.modit.emf.sirius.api.AbstractDiagram

/** Override of default reverse for SiriusModelProvider class. */
class DiagramTemplate extends DiagramPartTemplate<DiagramDescription> {
	
	static val DPKG = DescriptionPackage.eINSTANCE

	new(SiriusGroupTemplate container) {
		super(container, DiagramDescription)
	}
	
	override isApplicableTemplate(DiagramDescription it) {
		defaultLayer !== null
			&& domainClass.classFromDomain !== null
	}
	
	static val INIT_TEMPLATED = #{
		DiagramDescription -> #{
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
	}
	
	/** Set of classes used in sub parts by the default implementation  */
	protected static val PART_IMPORTS = (
			#{ 
				AbstractDiagram
			} 
			+ INIT_TEMPLATED.keySet
		).toList
	
	override getPartStaticImports(EObject it) {
		// no super: EModit and EObject are not used directly
		PART_IMPORTS
			// + !!! requires metamodel !!!
	}
	
	override getInitTemplateds() {
		INIT_TEMPLATED
	}
	
	override templateRepresentation(ClassId it, DiagramDescription content) {
		
		val explicitInitContent = content.templateFilteredContent(DiagramDescription)
		
'''package «pack»

«templateImports»

import static extension org.mypsycho.modit.emf.sirius.api.SiriusDesigns.*

class «name» extends «AbstractDiagram.templateClass» {

	new(«parentClassName» parent) {
		super(parent, «content.name.toJava», «content.label.toJava», «content.domainClass.classFromDomain.templateClass»)
	}

«
IF !explicitInitContent.empty 
»	override initContent(DiagramDescription it) {
		super.initContent(it)
		«explicitInitContent»
	}

«
ENDIF
»	override initContent(Layer it) {
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
	
}
