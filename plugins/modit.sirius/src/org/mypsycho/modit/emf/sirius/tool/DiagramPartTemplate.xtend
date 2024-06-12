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

import org.eclipse.emf.ecore.EAttribute
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.sirius.diagram.description.AbstractNodeMapping
import org.eclipse.sirius.diagram.description.AdditionalLayer
import org.eclipse.sirius.diagram.description.ConditionalContainerStyleDescription
import org.eclipse.sirius.diagram.description.ConditionalEdgeStyleDescription
import org.eclipse.sirius.diagram.description.ConditionalNodeStyleDescription
import org.eclipse.sirius.diagram.description.ContainerMapping
import org.eclipse.sirius.diagram.description.DescriptionPackage
import org.eclipse.sirius.diagram.description.EdgeMapping
import org.eclipse.sirius.diagram.description.Layer
import org.eclipse.sirius.diagram.description.NodeMapping
import org.eclipse.sirius.diagram.description.style.BeginLabelStyleDescription
import org.eclipse.sirius.diagram.description.style.CenterLabelStyleDescription
import org.eclipse.sirius.diagram.description.style.EdgeStyleDescription
import org.eclipse.sirius.diagram.description.style.EndLabelStyleDescription
import org.eclipse.sirius.diagram.description.style.StylePackage
import org.eclipse.sirius.diagram.description.tool.ContainerDropDescription
import org.eclipse.sirius.diagram.description.tool.DeleteElementDescription
import org.eclipse.sirius.diagram.description.tool.EdgeCreationDescription
import org.eclipse.sirius.diagram.description.tool.NodeCreationDescription
import org.eclipse.sirius.diagram.description.tool.ReconnectEdgeDescription
import org.eclipse.sirius.diagram.description.tool.ToolSection
import org.eclipse.sirius.viewpoint.description.ConditionalStyleDescription
import org.eclipse.sirius.viewpoint.description.Customization
import org.eclipse.sirius.viewpoint.description.EAttributeCustomization
import org.eclipse.sirius.viewpoint.description.EReferenceCustomization
import org.eclipse.sirius.viewpoint.description.EStructuralFeatureCustomization
import org.eclipse.sirius.viewpoint.description.IdentifiedElement
import org.eclipse.sirius.viewpoint.description.VSMElementCustomization
import org.eclipse.sirius.viewpoint.description.style.BasicLabelStyleDescription
import org.eclipse.sirius.viewpoint.description.style.LabelStyleDescription
import org.eclipse.sirius.viewpoint.description.style.StyleDescription
import org.eclipse.sirius.viewpoint.description.tool.AbstractToolDescription
import org.eclipse.sirius.viewpoint.description.tool.ContainerModelOperation
import org.eclipse.sirius.viewpoint.description.tool.ExternalJavaAction
import org.eclipse.sirius.viewpoint.description.tool.InitialOperation
import org.eclipse.sirius.viewpoint.description.tool.PopupMenu
import org.mypsycho.modit.emf.sirius.api.AbstractDiagramPart

import static extension org.mypsycho.modit.emf.sirius.api.SiriusDesigns.*

/** 
 * Override of default reverse for SiriusModelProvider class.
 */
abstract class DiagramPartTemplate<R extends EObject> extends RepresentationTemplate<R> {
	
	protected static val SPKG = StylePackage.eINSTANCE
	protected static val DPKG = DescriptionPackage.eINSTANCE
	
	
	static val NS_MAPPING = #[
		AbstractNodeMapping -> AbstractDiagramPart.Ns.node,
		EdgeMapping -> AbstractDiagramPart.Ns.edge,
		DeleteElementDescription -> AbstractDiagramPart.Ns.del,
		EdgeCreationDescription -> AbstractDiagramPart.Ns.connect,
		ReconnectEdgeDescription -> AbstractDiagramPart.Ns.reconnect,
		
		NodeCreationDescription -> AbstractDiagramPart.Ns.creation,
		ContainerDropDescription -> AbstractDiagramPart.Ns.drop,
		
		// representation level
		PopupMenu -> AbstractDiagramPart.Ns.menu,
		AbstractToolDescription -> AbstractDiagramPart.Ns.operation
	]

	protected val static CONTAINMENT_ORDER = #[
		Layer -> #[
			DPKG.layer_NodeMappings,
			DPKG.layer_ContainerMappings,
			DPKG.layer_EdgeMappings,
			DPKG.layer_Customization
		],
		ContainerMapping -> #[
			// Default position
			DPKG.containerMapping_Style,
			DPKG.containerMapping_ConditionnalStyles,
			DPKG.abstractNodeMapping_BorderedNodeMappings,
			DPKG.containerMapping_SubNodeMappings,
			DPKG.containerMapping_SubContainerMappings,
			DPKG.layer_EdgeMappings
		],
		NodeMapping -> #[
			DPKG.nodeMapping_Style,
			DPKG.nodeMapping_ConditionnalStyles,
			DPKG.abstractNodeMapping_BorderedNodeMappings	
		]
	]
	
	
	new(SiriusGroupTemplate container, Class<R> targetClass) {
		super(container, targetClass)
	}
	
	override getNsMapping() { NS_MAPPING }
	
	override getContainmentOrders() { CONTAINMENT_ORDER }
	
	override AbstractDiagramPart<R> getDefaultContent() {
		super.defaultContent
			as AbstractDiagramPart<R>
	}

	def getDefaultStyleValues(StyleDescription src) {
		defaultInits.computeIfAbsent(src.eClass) [
			EcoreUtil.create(it) as StyleDescription => [
				switch(it) {
					// Avoid edge labels
					LabelStyleDescription: defaultContent.initDefaultStyle(it)
					EdgeStyleDescription: defaultContent.initDefaultStyle(it)
				}
			]
		]
	}
	
	override isAttributeReversed(EObject it, EAttribute f) {
		it instanceof StyleDescription
			? isStyleFeatureSet(f)
			: super.isAttributeReversed(it, f)
	}
		
	override isPureReferenceReversed(EObject it, EReference f) {
		it instanceof StyleDescription
			? isStyleFeatureSet(f)
			: super.isPureReferenceReversed(it, f)
	}

	def boolean isStyleFeatureSet(StyleDescription it, EStructuralFeature feat) {
		eGet(feat) != defaultStyleValues.eGet(feat)
	}

	def defaultStyleTemplate() { "" }

	override findNs(IdentifiedElement it) {
		// Some issue with internal operation.
		it instanceof ExternalJavaAction 
				&& (eContainer instanceof InitialOperation 
				|| eContainer instanceof ContainerModelOperation)
			? null
			: super.findNs(it)
	}
		
	//
	// Class templates
	// 
	
	def dispatch smartTemplateCreate(AdditionalLayer it) {
		val label = name.techName
		
		'''create«label»«!label.endsWith("Layer") ? "Layer" : "" »'''
	}

	def dispatch smartTemplateCreate(ToolSection it) {
		val container = eContainer
		if (!(container instanceof Layer)) {
			return super.smartTemplateCreate(it)
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
		val suffix = 
			!techName.toLowerCase.endsWith("tools")
				&& !techName.toLowerCase.endsWith("toolsection")
			? "Tools"
			: ""
		
		'''create«qualif»«techName»«suffix»'''
	}
	
	def dispatch smartTemplateCreate(VSMElementCustomization it) {
'''«predicateExpression.toJava».thenStyle(
	«featureCustomizations.templateContainedValues»
)'''}
	
	def dispatch smartTemplateCreate(EStructuralFeatureCustomization it) {
		val header = switch(it) {
			EReferenceCustomization: '''«referenceName.toJava».refCustomization(«value.templateRef(EObject)»'''
			EAttributeCustomization: '''«attributeName.toJava».attCustomization(«value.toJava»'''
		}
		
'''«header»«
IF !appliedOn.empty
»,
	«appliedOn.map[ templateRef(EObject) ].join(LValueSeparator)»
«
ENDIF
»)«
IF applyOnAll
».andThen[ applyOnAll = true]«
ENDIF
»'''}
	
	//
	// Property templates
	// 
	static val EDGE_LABEL_FEATS = #[
		SPKG.edgeStyleDescription_BeginLabelStyleDescription,
		SPKG.edgeStyleDescription_CenterLabelStyleDescription,
		SPKG.edgeStyleDescription_EndLabelStyleDescription
	]
	static val STYLES_FEATS = #[
		DPKG.nodeMapping_Style,
		DPKG.containerMapping_Style,
		DPKG.edgeMapping_Style
	]
	static val CONDITIONAL_STYLES_FEATS = #[
		DPKG.nodeMapping_ConditionnalStyles,
		DPKG.containerMapping_ConditionnalStyles,
		DPKG.edgeMapping_ConditionnalStyles
	]	
	
	override templatePropertyValue(EStructuralFeature feat, Object value, (Object)=>String encoding) {
		DPKG.layer_Customization == feat 
			? (value as Customization).templateStyleCustomisation
			: EDGE_LABEL_FEATS.contains(feat)
			? (value as BasicLabelStyleDescription).templateEdgeLabel
			: STYLES_FEATS.contains(feat)
			? (value as StyleDescription).templateMappingStyle
			: CONDITIONAL_STYLES_FEATS.contains(feat)
			? (value as ConditionalStyleDescription).templateMappingConditionnalStyle
			: super.templatePropertyValue(feat, value, encoding)
	}
	
	def templateEdgeLabel(BasicLabelStyleDescription it) {
		val pseudoProperty = switch(it) {
			BeginLabelStyleDescription: "sourceLabel"
			CenterLabelStyleDescription: "centerLabel"
			EndLabelStyleDescription: "targetLabel"
		}
		
'''«pseudoProperty» = [
	«templateInnerContent(innerContent) ?: ""»
]'''}	

	def templateMappingStyle(StyleDescription it) {
		val typed = !(it instanceof EdgeStyleDescription)

		// TODO Rework EReversIt#getInnerContent to get default style
'''style«
IF typed »(«eClass.instanceClass.templateClass»)«
ENDIF    » [
	«templateInnerContent(innerContent) ?: ""»
]'''}
	
	
	def templateMappingConditionnalStyle(ConditionalStyleDescription it) {
		val contentStyle = switch(it) {
			ConditionalContainerStyleDescription : style
			ConditionalNodeStyleDescription : style
			ConditionalEdgeStyleDescription : style
		}
		val typed = !(contentStyle instanceof EdgeStyleDescription)

'''styleIf(«
IF typed  »«contentStyle?.eClass?.instanceClass?.templateClass ?: ""», «
ENDIF     »«predicateExpression.toJava») [
	«contentStyle?.templateInnerContent(contentStyle?.innerContent) ?: ""»
]'''}
	
	
	def templateStyleCustomisation(Customization it) {
		if (vsmElementCustomizations.empty) {
			return "styleCustomisations" // simple getter
		}
'''«
FOR custo : vsmElementCustomizations
SEPARATOR statementSeparator
»styleCustomisations += «custo.smartTemplateCreate»«
ENDFOR
»'''}
	
	
}
