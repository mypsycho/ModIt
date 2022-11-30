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
import org.eclipse.sirius.properties.DialogButton
import org.eclipse.sirius.properties.TextDescription
import org.eclipse.sirius.viewpoint.description.IdentifiedElement
import org.eclipse.sirius.viewpoint.description.tool.AbstractToolDescription
import org.eclipse.sirius.viewpoint.description.tool.ContainerModelOperation
import org.eclipse.sirius.viewpoint.description.tool.ExternalJavaAction
import org.eclipse.sirius.viewpoint.description.tool.InitialOperation
import org.eclipse.sirius.viewpoint.description.tool.PopupMenu
import org.mypsycho.modit.emf.sirius.api.AbstractDiagram

import static extension org.mypsycho.modit.emf.sirius.api.SiriusDesigns.*

/** 
 * Override of default reverse for SiriusModelProvider class.
 */
abstract class DiagramPartTemplate<R extends EObject> extends RepresentationTemplate<R> {
	
	protected static val DPKG = DescriptionPackage.eINSTANCE
	
	new(SiriusGroupTemplate container, Class<R> targetClass) {
		super(container, targetClass)
	}
	
	val static CONTAINMENT_ORDER = #[
		Layer -> #[ 
			DPKG.layer_NodeMappings,
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
		
		// representation level
		PopupMenu -> AbstractDiagram.Ns.menu,
		AbstractToolDescription -> AbstractDiagram.Ns.operation
	]
	
	override getNsMapping() {
		NS_MAPPING
	}
	
	override findNs(IdentifiedElement it) {
		// Some issue with internal operation.
		if (it instanceof ExternalJavaAction 
			&& (eContainer instanceof InitialOperation 
				|| eContainer instanceof ContainerModelOperation
			)
		)
			null
		else 
			super.findNs(it)
	}

	override templateProperty(EObject element, EStructuralFeature it, (Object, Class<?>)=>String encoding) {
		if (element instanceof DiagramDescription) {
			if (it == DPKG.diagramDescription_Layout
				&& element.layout instanceof CustomLayoutConfiguration
				&& (element.layout as CustomLayoutConfiguration).id == "org.eclipse.elk.layered"
			) {
				return element.templateElkLayout
			}
		}
		
		super.templateProperty(element as EObject, it, encoding)
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

	
	override getToolModelOperation(EObject it) {
		switch(it) {
			ContainerDropDescription: initialOperation.firstModelOperations
			ReconnectEdgeDescription: initialOperation.firstModelOperations
			NodeCreationDescription: initialOperation.firstModelOperations
			ContainerCreationDescription: initialOperation.firstModelOperations
			EdgeCreationDescription: initialOperation.firstModelOperations
			DeleteElementDescription: initialOperation.firstModelOperations
			DoubleClickDescription: initialOperation.firstModelOperations
			DiagramCreationDescription: initialOperation.firstModelOperations
			DialogButton: initialOperation.firstModelOperations
			TextDescription: initialOperation.firstModelOperations
			default: super.getToolModelOperation(it)
		}
	}
	
}
