package org.mypsycho.modit.emf.sirius.tool

import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.sirius.diagram.description.AbstractNodeMapping
import org.eclipse.sirius.diagram.description.AdditionalLayer
import org.eclipse.sirius.diagram.description.BooleanLayoutOption
import org.eclipse.sirius.diagram.description.ContainerMapping
import org.eclipse.sirius.diagram.description.CustomLayoutConfiguration
import org.eclipse.sirius.diagram.description.DescriptionPackage
import org.eclipse.sirius.diagram.description.DiagramDescription
import org.eclipse.sirius.diagram.description.DoubleLayoutOption
import org.eclipse.sirius.diagram.description.EdgeMapping
import org.eclipse.sirius.diagram.description.EnumLayoutOption
import org.eclipse.sirius.diagram.description.EnumSetLayoutOption
import org.eclipse.sirius.diagram.description.IntegerLayoutOption
import org.eclipse.sirius.diagram.description.Layer
import org.eclipse.sirius.diagram.description.NodeMapping
import org.eclipse.sirius.diagram.description.StringLayoutOption
import org.eclipse.sirius.diagram.description.tool.ContainerCreationDescription
import org.eclipse.sirius.diagram.description.tool.ContainerDropDescription
import org.eclipse.sirius.diagram.description.tool.DeleteElementDescription
import org.eclipse.sirius.diagram.description.tool.DiagramCreationDescription
import org.eclipse.sirius.diagram.description.tool.DoubleClickDescription
import org.eclipse.sirius.diagram.description.tool.EdgeCreationDescription
import org.eclipse.sirius.diagram.description.tool.NodeCreationDescription
import org.eclipse.sirius.diagram.description.tool.ReconnectEdgeDescription
import org.eclipse.sirius.diagram.description.tool.ToolSection
import org.eclipse.sirius.viewpoint.description.tool.AbstractToolDescription
import org.mypsycho.modit.emf.ClassId
import org.mypsycho.modit.emf.sirius.api.AbstractDiagram

import static extension org.mypsycho.modit.emf.sirius.tool.SiriusReverseIt.*

/** Override of default reverse for SiriusModelProvider class. */
class DiagramTemplate extends RepresentationTemplate<DiagramDescription> {
	
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
	
	override getInitTemplateds() {
		INIT_TEMPLATED
	}
	
	override templateRepresentation(ClassId it, DiagramDescription content) {
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
	
	
	val static CONTAINMENT_ORDER = #[
		Layer -> #[ 
			DPKG.layer_ContainerMappings,
			DPKG.layer_EdgeMappings,
			DPKG.layer_ToolSections
		],
		ContainerMapping -> #[
			// Default position
			DPKG.containerMapping_Style,
			DPKG.containerMapping_ConditionnalStyles,
			DPKG.abstractNodeMapping_BorderedNodeMappings,
			DPKG.containerMapping_SubNodeMappings,
			DPKG.containerMapping_SubContainerMappings,
			DPKG.layer_EdgeMappings,
			DPKG.layer_ToolSections
		],
		NodeMapping -> #[
			DPKG.nodeMapping_Style,
			DPKG.nodeMapping_ConditionnalStyles,
			DPKG.abstractNodeMapping_BorderedNodeMappings	
		]
	]
	
	override getContainmentOrders() {
		CONTAINMENT_ORDER
	}
 

	def dispatch smartTemplateCreate(AdditionalLayer it) {
		'''create«name.techName»Layer'''
	}

	def dispatch smartTemplateCreate(ToolSection it) {
		val container = eContainer
		if (!(container instanceof Layer)) {
			return _smartTemplateCreate(it as EObject)
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
	
	override getNsMapping() {
		NS_MAPPING
	}
	

	def dispatch smartTemplateProperty(DiagramDescription element, EStructuralFeature it, (Object, Class<?>)=>String encoding) {
		if (it == DPKG.diagramDescription_Layout
			&& element.layout instanceof CustomLayoutConfiguration
			&& (element.layout as CustomLayoutConfiguration).id == "org.eclipse.elk.layered"
		) {
			return element.templateElkLayout
		}
		
		_smartTemplateProperty(element as EObject, it, encoding)
	}
	
	def templateElkLayout(DiagramDescription it) {
'''elkLayout(
«
FOR option : (layout as CustomLayoutConfiguration).layoutOptions
SEPARATOR "," + statementSeparator
»	"«option.id.substring("org.eclipse.elk.".length)»".elk«
	switch(option) {
		BooleanLayoutOption: '''Bool(«option.value»'''
		DoubleLayoutOption: '''Double(«option.value»'''
		EnumLayoutOption: '''Enum("«option.value.name»"'''
		IntegerLayoutOption: '''Int(«option.value»'''
		StringLayoutOption: '''String("«option.value»"'''
		EnumSetLayoutOption: '''Enums("«option.values.map[ name ].join(",")»"'''
	}
		», «option.targets.map[ "LayoutOptionTarget." + name() ].join(", ")»)«
ENDFOR 																		»
)'''
	}

	
	override getToolModelOperation(AbstractToolDescription it) {
		switch(it) {
			ContainerDropDescription: initialOperation.firstModelOperations
			ReconnectEdgeDescription: initialOperation.firstModelOperations
			NodeCreationDescription: initialOperation.firstModelOperations
			ContainerCreationDescription: initialOperation.firstModelOperations
			EdgeCreationDescription: initialOperation.firstModelOperations
			DeleteElementDescription: initialOperation.firstModelOperations
			DoubleClickDescription: initialOperation.firstModelOperations
			DiagramCreationDescription: initialOperation.firstModelOperations
			default: super.getToolModelOperation(it)
		}
	}
	
}
