package org.mypsycho.modit.emf.sirius.tool

import org.eclipse.emf.ecore.EObject
import org.eclipse.sirius.diagram.description.AbstractNodeMapping
import org.eclipse.sirius.diagram.description.AdditionalLayer
import org.eclipse.sirius.diagram.description.DiagramDescription
import org.eclipse.sirius.diagram.description.EdgeMapping
import org.eclipse.sirius.diagram.description.Layer
import org.eclipse.sirius.diagram.description.tool.ContainerDropDescription
import org.eclipse.sirius.diagram.description.tool.DeleteElementDescription
import org.eclipse.sirius.diagram.description.tool.EdgeCreationDescription
import org.eclipse.sirius.diagram.description.tool.NodeCreationDescription
import org.eclipse.sirius.diagram.description.tool.ReconnectEdgeDescription
import org.eclipse.sirius.diagram.description.tool.ToolSection
import org.eclipse.sirius.viewpoint.description.IdentifiedElement
import org.eclipse.sirius.viewpoint.description.DescriptionPackage
import org.eclipse.sirius.viewpoint.description.tool.AbstractToolDescription
import org.mypsycho.modit.emf.ClassId
import org.mypsycho.modit.emf.EReversIt
import org.mypsycho.modit.emf.sirius.api.AbstractDiagram

import static extension org.mypsycho.modit.emf.sirius.tool.SiriusReverseIt.*
import org.mypsycho.modit.emf.sirius.api.SiriusDesigns

/** Override of default reverse for SiriusModelProvider class. */
class DiagramTemplate extends EReversIt {
	
	static val SPKG = DescriptionPackage.eINSTANCE
	static val DPKG = org.eclipse.sirius.diagram.description.DescriptionPackage.eINSTANCE

	// XTend does not support statefull inner class
	val extension SiriusReverseIt tool
	
	new(SiriusGroupTemplate container) {
		super(container)
		tool = container.tool
	}
	
	override isPartTemplate(EObject it) {
		if (it instanceof DiagramDescription) 
			defaultLayer !== null
				&& domainClass.classFromDomain !== null
		else 
			false
	}
	
	
	// Xtend
	override performTemplatePart(ClassId it, EObject content) {
		super.performTemplatePart(it, content)
	}
	
	
	static val INIT_TEMPLATED = #{
		DiagramDescription -> #{
			// Diagram
			SPKG.identifiedElement_Name, 
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

	override templatePartBody(ClassId it, EObject content) {
		templateDiagram(content as DiagramDescription)
	}

	
	def templateDiagram(ClassId it, DiagramDescription content) {
		// Parent class cannot use import detection 
		//   as class does not exist (part of generation)
		val parentName = 
			if (pack != context.mainClass.pack) 
				context.mainClass.qName 
			else 
				context.mainClass.name
		
'''package «pack»

«templateImports»

import static extension org.mypsycho.modit.emf.sirius.api.SiriusDesigns.*

class «name» extends AbstractDiagram {

	new(«parentName» parent) {
		super(parent, "«content.name»", «content.domainClass.classFromDomain.templateClass»)
	}

	override initContent(DiagramDescription it) {
		super.initContent(it)
		name = "«content.name»"
		«content.templateFilteredContent(DiagramDescription)»
	}

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
	
	protected def String templateFilteredContent(EObject it, Class<? extends EObject> filter) {
		val filtered = INIT_TEMPLATED.get(filter) ?: {}
		val content = innerContent
			.filter[ !filtered.contains(key) ]
		templateInnerContent(content)
	}
 
	override getInnerContent(EObject it) {
		super.getInnerContent(it)
			.filter[ key !== SPKG.identifiedElement_Name ]
	}
 
	override templateInnerCreate(EObject it) {
		smartTemplateCreate.toString
	}

	def dispatch smartTemplateCreate(AdditionalLayer it) {
		'''create«name.techName»Layer'''
	}

	def dispatch smartTemplateCreate(ToolSection it) {
		val container = eContainer
		if (!(container instanceof Layer)) {
			return super.templateInnerCreate(it)
		}
		val prefix = container instanceof AdditionalLayer
				? container.name.techName
				: "" // default
		val techName = name.techName
		// If section already contain layer name
		val qualif = !techName.toLowerCase.contains(prefix.toLowerCase)
			? prefix
			: ""
		
		// 
		val suffix = !techName.toLowerCase.endsWith("tools")
				&& !techName.toLowerCase.endsWith("toolsection")
				? "Tools"
				: ""
		
		'''create«qualif»«techName»«suffix»'''
	}

	static val NS_MAPPING = #[
		AbstractNodeMapping -> AbstractDiagram.Ns.node,
		EdgeMapping -> AbstractDiagram.Ns.edge,
		DeleteElementDescription -> AbstractDiagram.Ns.del,
		EdgeCreationDescription -> AbstractDiagram.Ns.connect,
		ReconnectEdgeDescription -> AbstractDiagram.Ns.reconnect,
		
		NodeCreationDescription -> AbstractDiagram.Ns.creation,
		ContainerDropDescription -> AbstractDiagram.Ns.drop,
		AbstractToolDescription -> AbstractDiagram.Ns.operation
	]
	
	def findNs(IdentifiedElement it) {
		NS_MAPPING
			.findFirst[ mapping | mapping.key.isInstance(it) ]
			?.value
	}
	
 	def dispatch smartTemplateCreate(IdentifiedElement it) {
 		// TODO 
		//   NodeMapping, ContainerMapping, EdgeMapping
		//  
 		
		templateIdentifiedCreate(it)
	}
	
	def templateIdentifiedCreate(IdentifiedElement it) { // Default
		val ns = findNs

'''«templateClass».create«
IF ns !== null
						»As(Ns.«ns.name», «
ELSE
						»(«
ENDIF
						»"«it.name»") [
	«templateInnerContent(innerContent)»
]'''
	}

 	def dispatch smartTemplateCreate(EObject it) { // Default
		super.templateInnerCreate(it)
	}


	override templateRef(EObject it, Class<?> using) {
		if (it instanceof IdentifiedElement) {
			val ns = findNs
			if (ns !== null) {
				if (currentContent.isContaining(it)) {
					return '''«eClass.templateClass».localRef(Ns.«ns.name», "«name»")'''
				}
				val declaring = context.splits.keySet
					.findFirst[ key | key.isContaining(it) ]
				if (declaring !== null) {
					val declaringId = context.splits.get(declaring)
					// TODO deal with different packages ?
					return '''«eClass.templateClass».ref(«declaringId.name», Ns.«ns.name», "«name»")'''
				}
			}
		}
		
		super.templateRef(it, using)
	}

	dispatch override toJava(String it) {
		if (!startsWith(SiriusDesigns.AQL))
			super._toJava(it)
		else {// «» can be used to escape '
			val expression = substring(SiriusDesigns.AQL.length)
			if (expression.startsWith("'") 
				|| expression.endsWith("'"))
				'''«"'''"» «expression» «"'''"».trimAql'''
			else
				'''«"'''"»«expression»«"'''"».trimAql'''
		}
	}
}
