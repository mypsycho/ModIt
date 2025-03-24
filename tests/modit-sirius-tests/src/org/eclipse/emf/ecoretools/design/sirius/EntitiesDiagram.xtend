// Testing
package org.eclipse.emf.ecoretools.design.sirius

import org.eclipse.emf.codegen.ecore.genmodel.GenModelPackage
import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.EcorePackage
import org.eclipse.sirius.diagram.BackgroundStyle
import org.eclipse.sirius.diagram.ContainerLayout
import org.eclipse.sirius.diagram.EdgeArrows
import org.eclipse.sirius.diagram.EdgeRouting
import org.eclipse.sirius.diagram.LabelPosition
import org.eclipse.sirius.diagram.LineStyle
import org.eclipse.sirius.diagram.ResizeKind
import org.eclipse.sirius.diagram.description.AdditionalLayer
import org.eclipse.sirius.diagram.description.CenteringStyle
import org.eclipse.sirius.diagram.description.ContainerMapping
import org.eclipse.sirius.diagram.description.DiagramDescription
import org.eclipse.sirius.diagram.description.EdgeMapping
import org.eclipse.sirius.diagram.description.Layer
import org.eclipse.sirius.diagram.description.NodeMapping
import org.eclipse.sirius.diagram.description.style.BeginLabelStyleDescription
import org.eclipse.sirius.diagram.description.style.BundledImageDescription
import org.eclipse.sirius.diagram.description.style.CenterLabelStyleDescription
import org.eclipse.sirius.diagram.description.style.EdgeStyleDescription
import org.eclipse.sirius.diagram.description.style.EndLabelStyleDescription
import org.eclipse.sirius.diagram.description.style.FlatContainerStyleDescription
import org.eclipse.sirius.diagram.description.style.SquareDescription
import org.eclipse.sirius.diagram.description.style.WorkspaceImageDescription
import org.eclipse.sirius.diagram.description.tool.ContainerCreationDescription
import org.eclipse.sirius.diagram.description.tool.ContainerDropDescription
import org.eclipse.sirius.diagram.description.tool.CreateView
import org.eclipse.sirius.diagram.description.tool.DeleteElementDescription
import org.eclipse.sirius.diagram.description.tool.DiagramCreationDescription
import org.eclipse.sirius.diagram.description.tool.DirectEditLabel
import org.eclipse.sirius.diagram.description.tool.DoubleClickDescription
import org.eclipse.sirius.diagram.description.tool.EdgeCreationDescription
import org.eclipse.sirius.diagram.description.tool.ElementDoubleClickVariable
import org.eclipse.sirius.diagram.description.tool.NodeCreationDescription
import org.eclipse.sirius.diagram.description.tool.ReconnectEdgeDescription
import org.eclipse.sirius.diagram.description.tool.ReconnectionKind
import org.eclipse.sirius.diagram.description.tool.ToolGroup
import org.eclipse.sirius.diagram.description.tool.ToolSection
import org.eclipse.sirius.properties.DialogButton
import org.eclipse.sirius.properties.DialogModelOperation
import org.eclipse.sirius.properties.PageDescription
import org.eclipse.sirius.viewpoint.FontFormat
import org.eclipse.sirius.viewpoint.LabelAlignment
import org.eclipse.sirius.viewpoint.description.DecorationDescriptionsSet
import org.eclipse.sirius.viewpoint.description.Position
import org.eclipse.sirius.viewpoint.description.SemanticBasedDecoration
import org.eclipse.sirius.viewpoint.description.SystemColor
import org.eclipse.sirius.viewpoint.description.UserFixedColor
import org.eclipse.sirius.viewpoint.description.style.LabelBorderStyleDescription
import org.eclipse.sirius.viewpoint.description.tool.AcceleoVariable
import org.eclipse.sirius.viewpoint.description.tool.ContainerViewVariable
import org.eclipse.sirius.viewpoint.description.tool.DeleteView
import org.eclipse.sirius.viewpoint.description.tool.DragSource
import org.eclipse.sirius.viewpoint.description.tool.MoveElement
import org.eclipse.sirius.viewpoint.description.tool.OperationAction
import org.eclipse.sirius.viewpoint.description.tool.PasteDescription
import org.eclipse.sirius.viewpoint.description.tool.PopupMenu
import org.eclipse.sirius.viewpoint.description.tool.RemoveElement
import org.eclipse.sirius.viewpoint.description.tool.SelectModelElementVariable
import org.eclipse.sirius.viewpoint.description.tool.SelectionWizardDescription
import org.eclipse.sirius.viewpoint.description.tool.ToolDescription
import org.eclipse.sirius.viewpoint.description.validation.ERROR_LEVEL
import org.eclipse.sirius.viewpoint.description.validation.RuleAudit
import org.eclipse.sirius.viewpoint.description.validation.ValidationFix
import org.eclipse.sirius.viewpoint.description.validation.ValidationSet
import org.eclipse.sirius.viewpoint.description.validation.ViewValidationRule
import org.mypsycho.modit.emf.sirius.api.SiriusDiagram

import static extension org.mypsycho.modit.emf.sirius.api.SiriusDesigns.*

/**
 * Diagram 'Entities'.
 * 
 * @generated
 */
class EntitiesDiagram extends SiriusDiagram {

	new(EcoretoolsDesign parent) {
		super(parent, "Entities", "Entities in a Class Diagram", EPackage)
	}

	override initContent(DiagramDescription it) {
		super.initContent(it)
		metamodel.clear // Disable implicit metamodel import
		documentation = "<html>\n<head>\n</head>\n<body>\n<p>Provides a class diagram to represent EClasses, EDatatypes, EAttributes and their relationships.</p>\n<br>\n<img src=\"/icons/full/wizban/entities.png\"/>\n</body>\n</html>\n\n\n"
		endUserDocumentation = "A class diagram to represent EClasses, EDatatypes, EAttributes and their relationships."
		titleExpression = ''' self.name + ' class diagram' '''.trimAql
		enablePopupBars = true
		dropDescriptions += ContainerDropDescription.localRef(Ns.drop, "External EClass from treeview")
		dropDescriptions += ContainerDropDescription.localRef(Ns.drop, "Drop EClassifier into EPackage")
		metamodel += EcorePackage.eINSTANCE
		metamodel += GenModelPackage.eINSTANCE
		pasteDescriptions += PasteDescription.localRef(Ns.operation, "Paste Anything")
		filtering("Hide class content") [
			allHide(
				NodeMapping.localRef(Ns.node, "EC EAttribute"),
				NodeMapping.localRef(Ns.node, "Operation")
			)
		]
		filtering("Hide generalizations") [
			allHide(
				EdgeMapping.localRef(Ns.edge, "EC ESupertypes")
			)
		]
		filtering("Hide indirect generalizations") [
			viewHide('''not self.oclAsType(diagram::DEdge).sourceNode.oclAsType(viewpoint::DSemanticDecorator).target.oclAsType(ecore::EClass).eSuperTypes->includes(self.oclAsType(diagram::DEdge).targetNode.oclAsType(viewpoint::DSemanticDecorator).target)'''.trimAql,
				EdgeMapping.localRef(Ns.edge, "EC ESupertypes")
			)
		]
		filtering("Hide references (edges)") [
			allHide(
				EdgeMapping.localRef(Ns.edge, "EC_EReference"),
				EdgeMapping.localRef(Ns.edge, "Bi-directional EC_EReference ")
			)
		]
		filtering("Hide references (nodes)") [
			allHide(
				NodeMapping.localRef(Ns.node, "EC EReferenceNode")
			)
		]
		filtering("Hide inherited references (nodes)") [
			viewHide('''self.eContainer().oclAsType(viewpoint::DSemanticDecorator).target = self.oclAsType(viewpoint::DSemanticDecorator).target.eContainer()'''.trimAql,
				NodeMapping.localRef(Ns.node, "EC EReferenceNode")
			)
		]
		filtering("Hide derived features") [
			elementHide('''not self.derived'''.trimAql,
				EdgeMapping.localRef(Ns.edge, "EC_EReference"),
				NodeMapping.localRef(Ns.node, "EC EAttribute"),
				EdgeMapping.localRef(Ns.edge, "Bi-directional EC_EReference "),
				NodeMapping.localRef(Ns.node, "EC EReferenceNode")
			)
		]
		filtering("Hide operations") [
			allHide(
				NodeMapping.localRef(Ns.node, "Operation")
			)
		]
		validationSet = ValidationSet.create [
			ownedRules += ViewValidationRule.create("Unused EClass") [
				message = ''' 'The ' + self.target.oclAsType(ecore::EClass).name +' class is never used' '''.trimAql
				targets += ContainerMapping.localRef(Ns.node, "EC EClass")
				audits += RuleAudit.create [
					auditExpression = '''not self.target.oclAsType(ecore::EClass).eAllSuperTypes->including(self.target)->asSet().eInverse('eType')->isEmpty()'''.trimAql
				]
				fixes += ValidationFix.create [
					name = "Remove Element"
					operation = "feature:target".toContext(
						RemoveElement.create
					)
				]
			]
			ownedRules += ViewValidationRule.create("Too many superclasses") [
				level = ERROR_LEVEL.ERROR_LITERAL
				message = ''' 'The ' + self.target.oclAsType(ecore::EClass).name +' class has more than 10 super types' '''.trimAql
				targets += ContainerMapping.localRef(Ns.node, "EC EClass")
				audits += RuleAudit.create [
					auditExpression = '''self.target.oclAsType(ecore::EClass).eAllSuperTypes->size() < 10'''.trimAql
				]
			]
		]
		initialisation = "service:openClassDiagramContextHelp".toOperation
		additionalLayers += createPackageLayer
		additionalLayers += createDocumentationLayer
		additionalLayers += createValidationLayer
		additionalLayers += createConstraintLayer
		additionalLayers += createRelatedEClassesLayer
		additionalLayers += createIconsPreviewLayer
	}

	override initContent(Layer it) {
		nodeMappings += NodeMapping.createAs(Ns.node, "Empty Diagram") [
			preconditionExpression = '''containerView.oclAsType(diagram::DDiagram).ownedDiagramElements.target->excluding(containerView.oclAsType(diagram::DSemanticDiagram).target)->size() = 0 and container.eClassifiers->size() > 0'''.trimAql
			semanticCandidatesExpression = "var:self"
			domainClass = "ecore.EPackage"
			deletionDescription = DeleteElementDescription.localRef(Ns.del, "NoOp")
			style(WorkspaceImageDescription) [
				labelSize = 8
				labelExpression = ""
				sizeComputationExpression = "-1"
				labelPosition = LabelPosition.NODE_LITERAL
				arcWidth = 1
				arcHeight = 1
				workspacePath = "/org.eclipse.emf.ecoretools.design/icons/full/back/empty.svg"
			]
		]
		containerMappings += ContainerMapping.createAs(Ns.node, "EC EClass") [
			createElements = false
			domainClass = "ecore.EClass"
			childrenPresentation = ContainerLayout.LIST
			deletionDescription = DeleteElementDescription.localRef(Ns.del, "Delete EClass")
			labelDirectEdit = DirectEditLabel.localRef(Ns.operation, "Edit Name with CamelCase")
			dropDescriptions += ContainerDropDescription.localRef(Ns.drop, "Drop attribute")
			dropDescriptions += ContainerDropDescription.localRef(Ns.drop, "Drop operation")
			style(FlatContainerStyleDescription) [
				arcWidth = 8
				arcHeight = 8
				labelSize = 8
				tooltipExpression = "service:renderTooltip"
				roundedCorner = true
				widthComputationExpression = "12"
				heightComputationExpression = "10"
				backgroundStyle = BackgroundStyle.LIQUID_LITERAL
				foregroundColor = UserFixedColor.ref("color:EClass")
			]
			styleIf(FlatContainerStyleDescription, "feature:interface") [
				arcWidth = 8
				arcHeight = 8
				labelSize = 8
				labelFormat += FontFormat.ITALIC_LITERAL
				iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/EClass_interface.gif"
				tooltipExpression = "service:renderTooltip"
				roundedCorner = true
				widthComputationExpression = "12"
				heightComputationExpression = "10"
				backgroundStyle = BackgroundStyle.LIQUID_LITERAL
				borderColor = UserFixedColor.ref("color:Dark EClass")
				foregroundColor = UserFixedColor.ref("color:Abstract EClass")
			]
			styleIf(FlatContainerStyleDescription, "feature:abstract") [
				arcWidth = 8
				arcHeight = 8
				labelSize = 8
				labelFormat += FontFormat.ITALIC_LITERAL
				iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/EClass_abstract.gif"
				tooltipExpression = "service:renderTooltip"
				roundedCorner = true
				widthComputationExpression = "12"
				heightComputationExpression = "10"
				backgroundStyle = BackgroundStyle.LIQUID_LITERAL
				borderColor = UserFixedColor.ref("color:Dark EClass")
				foregroundColor = UserFixedColor.ref("color:Abstract EClass")
			]
			borderedNodeMappings += NodeMapping.createAs(Ns.node, "EC ETypeParameter") [
				semanticCandidatesExpression = "feature:eTypeParameters"
				domainClass = "ecore.ETypeParameter"
				labelDirectEdit = DirectEditLabel.localRef(Ns.operation, "Edit Name with CamelCase")
				style(WorkspaceImageDescription) [
					labelSize = 8
					sizeComputationExpression = "3"
					labelPosition = LabelPosition.NODE_LITERAL
					resizeKind = ResizeKind.NSEW_LITERAL
					arcWidth = 1
					arcHeight = 1
					workspacePath = "/org.eclipse.emf.ecoretools.design/icons/full/back/generic.svg"
				]
			]
			subNodeMappings += NodeMapping.createAs(Ns.node, "EC EAttribute") [
				semanticCandidatesExpression = "feature:eAttributes"
				domainClass = "ecore.EAttribute"
				labelDirectEdit = DirectEditLabel.localRef(Ns.operation, "Edit EStructuralFeature Name")
				dropDescriptions += ContainerDropDescription.localRef(Ns.drop, "Drop EStructuralFeature into EClass")
				style(BundledImageDescription) [
					borderSizeComputationExpression = "0"
					labelSize = 8
					labelExpression = "service:render"
					labelAlignment = LabelAlignment.LEFT
					tooltipExpression = "service:renderTooltip"
					sizeComputationExpression = "1"
				]
			]
			subNodeMappings += NodeMapping.createAs(Ns.node, "Operation") [
				semanticCandidatesExpression = "feature:eOperations"
				semanticElements = "service:eOperationSemanticElements"
				domainClass = "ecore.EOperation"
				labelDirectEdit = DirectEditLabel.localRef(Ns.operation, "Operation Name")
				dropDescriptions += ContainerDropDescription.localRef(Ns.drop, "Drop EStructuralFeature into EClass")
				style(BundledImageDescription) [
					borderSizeComputationExpression = "0"
					labelSize = 8
					labelExpression = "service:render"
					labelAlignment = LabelAlignment.LEFT
					tooltipExpression = "service:renderEOperationTooltip"
				]
			]
			subNodeMappings += NodeMapping.createAs(Ns.node, "EC EReferenceNode") [
				semanticCandidatesExpression = "service:getNonDisplayedEReferences(diagram)"
				domainClass = "ecore.EReference"
				labelDirectEdit = DirectEditLabel.localRef(Ns.operation, "Edit EStructuralFeature Name")
				dropDescriptions += ContainerDropDescription.localRef(Ns.drop, "Drop EStructuralFeature into EClass")
				style(BundledImageDescription) [
					borderSizeComputationExpression = "0"
					labelSize = 8
					labelExpression = "service:renderAsNode"
					labelAlignment = LabelAlignment.LEFT
					tooltipExpression = "service:renderTooltip"
					sizeComputationExpression = "1"
					color = SystemColor.extraRef("color:blue")
				]
				styleIf(BundledImageDescription, '''container <> self.eContainer()'''.trimAql) [
					borderSizeComputationExpression = "0"
					labelSize = 8
					labelFormat += FontFormat.ITALIC_LITERAL
					labelExpression = "service:renderAsNode"
					labelAlignment = LabelAlignment.LEFT
					tooltipExpression = "service:renderTooltip"
					sizeComputationExpression = "1"
					labelColor = UserFixedColor.ref("color:Inherited")
				]
			]
		]
		containerMappings += ContainerMapping.createAs(Ns.node, "EC EEnum") [
			createElements = false
			domainClass = "ecore.EEnum"
			childrenPresentation = ContainerLayout.LIST
			labelDirectEdit = DirectEditLabel.localRef(Ns.operation, "Edit Name with CamelCase")
			style(FlatContainerStyleDescription) [
				arcWidth = 1
				arcHeight = 1
				labelSize = 8
				tooltipExpression = "service:renderTooltip"
				widthComputationExpression = "12"
				heightComputationExpression = "10"
				backgroundStyle = BackgroundStyle.LIQUID_LITERAL
				borderColor = UserFixedColor.ref("color:Dark EEnum")
				foregroundColor = UserFixedColor.ref("color:EEnum")
			]
			subNodeMappings += NodeMapping.createAs(Ns.node, "EC EEnumLiteral") [
				semanticCandidatesExpression = "feature:eLiterals"
				domainClass = "ecore.EEnumLiteral"
				labelDirectEdit = DirectEditLabel.localRef(Ns.operation, "Edit Name no CamelCase")
				style(BundledImageDescription) [
					borderSizeComputationExpression = "0"
					labelSize = 8
					labelAlignment = LabelAlignment.LEFT
					tooltipExpression = "service:renderTooltip"
					sizeComputationExpression = "1"
				]
			]
		]
		containerMappings += ContainerMapping.createAs(Ns.node, "EC EDataType") [
			preconditionExpression = "service:isEDataType"
			createElements = false
			domainClass = "ecore.EDataType"
			childrenPresentation = ContainerLayout.LIST
			labelDirectEdit = DirectEditLabel.localRef(Ns.operation, "Edit Name with CamelCase")
			style(FlatContainerStyleDescription) [
				arcWidth = 1
				arcHeight = 1
				labelSize = 8
				tooltipExpression = "service:renderTooltip"
				widthComputationExpression = "14"
				heightComputationExpression = "5"
				backgroundStyle = BackgroundStyle.LIQUID_LITERAL
				borderColor = UserFixedColor.ref("color:Dark EDataType")
				foregroundColor = UserFixedColor.ref("color:EDataType")
			]
			subNodeMappings += NodeMapping.createAs(Ns.node, "EC_DataType_InstanceClassName") [
				semanticCandidatesExpression = "var:self"
				domainClass = "ecore.EDataType"
				labelDirectEdit = DirectEditLabel.localRef(Ns.operation, "InstanceClassName")
				style(BundledImageDescription) [
					borderSizeComputationExpression = "0"
					labelSize = 8
					labelFormat += FontFormat.ITALIC_LITERAL
					showIcon = false
					labelExpression = "feature:instanceClassName"
					tooltipExpression = "service:renderTooltip"
					sizeComputationExpression = "1"
				]
			]
		]
		edgeMappings += EdgeMapping.createAs(Ns.edge, "EC_EReference") [
			preconditionExpression = "service:noEOpposite"
			semanticCandidatesExpression = "service:getEReferencesToDisplay(diagram)"
			semanticElements = "var:self"
			synchronizationLock = true
			targetFinderExpression = "service:getEReferenceTarget"
			sourceFinderExpression = "feature:eContainer"
			domainClass = "ecore.EReference"
			useDomainElement = true
			labelDirectEdit = DirectEditLabel.localRef(Ns.operation, "EReference Name")
			sourceMapping += ContainerMapping.localRef(Ns.node, "EC EClass")
			sourceMapping += ContainerMapping.localRef(Ns.node, "EC External EClasses")
			targetMapping += ContainerMapping.localRef(Ns.node, "EC EClass")
			targetMapping += NodeMapping.localRef(Ns.node, "EC ETypeParameter")
			targetMapping += ContainerMapping.localRef(Ns.node, "EC External EClasses")
			reconnections += ReconnectEdgeDescription.localRef(Ns.reconnect, "ReconnectEReference Source")
			reconnections += ReconnectEdgeDescription.localRef(Ns.reconnect, "ReconnectEReference Target")
			style [
				targetArrow = EdgeArrows.INPUT_ARROW_LITERAL
				endsCentering = CenteringStyle.NONE
				centerLabel = [
					labelSize = 8
					labelExpression = "service:render"
				]
				targetLabel = [
					labelSize = 6
					labelExpression = "service:eKeysLabel"
					labelColor = SystemColor.extraRef("color:dark_blue")
				]
			]
		]
		edgeMappings += EdgeMapping.createAs(Ns.edge, "EC ESupertypes") [
			semanticCandidatesExpression = ""
			semanticElements = "var:self"
			synchronizationLock = true
			targetFinderExpression = "service:getDirectSuperTypesOrMostSpecificVisibleOnes(diagram)"
			deletionDescription = DeleteElementDescription.localRef(Ns.del, "Delete ESuperType")
			sourceMapping += ContainerMapping.localRef(Ns.node, "EC EClass")
			sourceMapping += ContainerMapping.localRef(Ns.node, "EC External EClasses")
			targetMapping += ContainerMapping.localRef(Ns.node, "EC EClass")
			targetMapping += ContainerMapping.localRef(Ns.node, "EC External EClasses")
			reconnections += ReconnectEdgeDescription.localRef(Ns.reconnect, "ReconnectESupertypeSource")
			reconnections += ReconnectEdgeDescription.localRef(Ns.reconnect, "ReconnectESupertypeTarget")
			style [
				targetArrow = EdgeArrows.INPUT_CLOSED_ARROW_LITERAL
				routingStyle = EdgeRouting.TREE_LITERAL
				endsCentering = CenteringStyle.NONE
				strokeColor = SystemColor.extraRef("color:gray")
				sourceLabel = [
					labelSize = 8
					labelFormat += FontFormat.ITALIC_LITERAL
					labelExpression = "service:superTypesLabel"
				]
				centerLabel = [
					labelSize = 8
					labelExpression = ""
				]
			]
			styleIf("service:targetIsInterface(view)") [
				lineStyle = LineStyle.DASH_LITERAL
				targetArrow = EdgeArrows.INPUT_CLOSED_ARROW_LITERAL
				routingStyle = EdgeRouting.TREE_LITERAL
				endsCentering = CenteringStyle.NONE
				strokeColor = SystemColor.extraRef("color:gray")
				sourceLabel = [
					labelSize = 8
					labelFormat += FontFormat.ITALIC_LITERAL
					labelExpression = "service:superTypesLabel"
				]
				centerLabel = [
					labelSize = 8
					labelExpression = ""
				]
			]
			styleIf('''not self.eSuperTypes->includes(view.oclAsType(diagram::DEdge).targetNode.oclAsType(viewpoint::DSemanticDecorator).target)'''.trimAql) [
				lineStyle = LineStyle.DOT_LITERAL
				targetArrow = EdgeArrows.INPUT_CLOSED_ARROW_LITERAL
				routingStyle = EdgeRouting.TREE_LITERAL
				endsCentering = CenteringStyle.NONE
				strokeColor = UserFixedColor.ref("color:Inherited")
				sourceLabel = [
					labelSize = 8
					labelFormat += FontFormat.ITALIC_LITERAL
					labelExpression = "service:superTypesLabel"
				]
				centerLabel = [
					labelSize = 8
					labelExpression = ""
				]
			]
		]
		edgeMappings += EdgeMapping.createAs(Ns.edge, "Bi-directional EC_EReference ") [
			semanticCandidatesExpression = "service:getEOppositeEReferences(diagram)"
			semanticElements = "service:getEOppositeSemanticElements"
			synchronizationLock = true
			targetFinderExpression = "feature:eType"
			sourceFinderExpression = "feature:eContainer"
			targetExpression = ""
			domainClass = "ecore.EReference"
			useDomainElement = true
			labelDirectEdit = DirectEditLabel.localRef(Ns.operation, "Direct Edit EOpposite")
			sourceMapping += ContainerMapping.localRef(Ns.node, "EC EClass")
			sourceMapping += ContainerMapping.localRef(Ns.node, "EC External EClasses")
			targetMapping += ContainerMapping.localRef(Ns.node, "EC EClass")
			targetMapping += ContainerMapping.localRef(Ns.node, "EC External EClasses")
			reconnections += ReconnectEdgeDescription.localRef(Ns.reconnect, "ReconnectBiDirectionnalEReference Target")
			reconnections += ReconnectEdgeDescription.localRef(Ns.reconnect, "ReconnectBiDirectionnalEReference Source")
			style [
				sourceArrow = EdgeArrows.INPUT_ARROW_LITERAL
				targetArrow = EdgeArrows.INPUT_ARROW_LITERAL
				endsCentering = CenteringStyle.NONE
				sourceLabel = [
					labelSize = 8
					labelExpression = "service:renderEOpposite"
				]
				targetLabel = [
					labelSize = 8
					labelExpression = "service:render"
				]
			]
		]
		styleCustomisations += "feature:required".thenStyle(
			"labelFormat".attCustomization("service:fontFormatBold",
				CenterLabelStyleDescription.localRef(Ns.edge, "EC_EReference") [ (it as EdgeMapping).style.centerLabelStyleDescription ],
				BundledImageDescription.localRef(Ns.node, "EC EAttribute") [ (it as NodeMapping).style as BundledImageDescription ],
				BeginLabelStyleDescription.localRef(Ns.edge, "Bi-directional EC_EReference ") [ (it as EdgeMapping).style.beginLabelStyleDescription ],
				EndLabelStyleDescription.localRef(Ns.edge, "Bi-directional EC_EReference ") [ (it as EdgeMapping).style.endLabelStyleDescription ],
				BundledImageDescription.localRef(Ns.node, "EC EReferenceNode") [ (it as NodeMapping).style as BundledImageDescription ],
				BundledImageDescription.localRef(Ns.node, "EC EReferenceNode") [ (it as NodeMapping).conditionnalStyles.head.style as BundledImageDescription ]
			),
			"strokeColor".refCustomization(SystemColor.extraRef("color:black"),
				EdgeStyleDescription.localRef(Ns.edge, "Bi-directional EC_EReference ") [ (it as EdgeMapping).style ],
				EdgeStyleDescription.localRef(Ns.edge, "EC_EReference") [ (it as EdgeMapping).style ]
			)
		)
		styleCustomisations += "feature:containment".thenStyle(
			"sourceArrow".attCustomization("service:arrowsFillDiamond",
				EdgeStyleDescription.localRef(Ns.edge, "EC_EReference") [ (it as EdgeMapping).style ],
				EdgeStyleDescription.localRef(Ns.edge, "Bi-directional EC_EReference ") [ (it as EdgeMapping).style ]
			),
			"sizeComputationExpression".attCustomization("1",
				EdgeStyleDescription.localRef(Ns.edge, "EC_EReference") [ (it as EdgeMapping).style ],
				EdgeStyleDescription.localRef(Ns.edge, "Bi-directional EC_EReference ") [ (it as EdgeMapping).style ]
			)
		)
		styleCustomisations += "feature:container".thenStyle(
			"targetArrow".attCustomization("service:arrowsFillDiamond",
				EdgeStyleDescription.localRef(Ns.edge, "EC_EReference") [ (it as EdgeMapping).style ],
				EdgeStyleDescription.localRef(Ns.edge, "Bi-directional EC_EReference ") [ (it as EdgeMapping).style ]
			),
			"sizeComputationExpression".attCustomization("1",
				EdgeStyleDescription.localRef(Ns.edge, "EC_EReference") [ (it as EdgeMapping).style ],
				EdgeStyleDescription.localRef(Ns.edge, "Bi-directional EC_EReference ") [ (it as EdgeMapping).style ]
			)
		)
		styleCustomisations += "feature:derived".thenStyle(
			"strokeColor".refCustomization(SystemColor.extraRef("color:blue"),
				EdgeStyleDescription.localRef(Ns.edge, "EC_EReference") [ (it as EdgeMapping).style ],
				EdgeStyleDescription.localRef(Ns.edge, "Bi-directional EC_EReference ") [ (it as EdgeMapping).style ]
			),
			"labelColor".refCustomization(SystemColor.extraRef("color:dark_blue"),
				BeginLabelStyleDescription.localRef(Ns.edge, "Bi-directional EC_EReference ") [ (it as EdgeMapping).style.beginLabelStyleDescription ],
				EndLabelStyleDescription.localRef(Ns.edge, "Bi-directional EC_EReference ") [ (it as EdgeMapping).style.endLabelStyleDescription ],
				CenterLabelStyleDescription.localRef(Ns.edge, "EC_EReference") [ (it as EdgeMapping).style.centerLabelStyleDescription ],
				BundledImageDescription.localRef(Ns.node, "EC EAttribute") [ (it as NodeMapping).style as BundledImageDescription ],
				BundledImageDescription.localRef(Ns.node, "EC EReferenceNode") [ (it as NodeMapping).style as BundledImageDescription ],
				BundledImageDescription.localRef(Ns.node, "EC EReferenceNode") [ (it as NodeMapping).conditionnalStyles.head.style as BundledImageDescription ]
			)
		)
		toolSections += createExistingElementsTools
		toolSections += createClassifierTools
		toolSections += createFeatureTools
		toolSections += createRelationTools
		toolSections += createReconnectTools
		toolSections += createDirectEditTools
		toolSections += createHelpTools
		toolSections += createDynamicTools
		decorationDescriptionsSet = DecorationDescriptionsSet.create [
			decorationDescriptions += SemanticBasedDecoration.create [
				name = "External"
				position = Position.NORTH_EAST_LITERAL
				preconditionExpression = "service:viewContainerNotSemanticContainer(diagram,containerView)"
				imageExpression = "/org.eclipse.emf.ecoretools.design/icons/full/ovr16/shortcut.gif"
				domainClass = "ecore.EClassifier"
			]
		]
	}

	def createExistingElementsTools() {
		ToolSection.create("Existing Elements") [
			ownedTools += PopupMenu.createAs(Ns.menu, "Generate") [
				menuItemDescription += OperationAction.createAs(Ns.operation, " All") [
					initVariables
					precondition = '''OrderedSet{views.target}.eInverse().eContainerOrSelf(genmodel::GenModel)->asSet()->size() > 0'''.trimAql
					icon = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/GenModel.gif"
					operation = "org.eclipse.emf.ecoretools.design.action.generateAllID".javaDo("Generate All", 
						"genmodels" -> '''OrderedSet{views.target}.eInverse().eContainerOrSelf(genmodel::GenModel)->asSet()'''.trimAql,
						"scope" -> "model, edit, editor, tests"
					)
				]
				menuItemDescription += OperationAction.createAs(Ns.operation, "Model Code") [
					initVariables
					precondition = '''OrderedSet{views.target}.eInverse().eContainerOrSelf(genmodel::GenModel)->asSet()->select(m | m.modelDirectory.size() > 0)->size() > 0'''.trimAql
					icon = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/GenModel.gif"
					operation = "org.eclipse.emf.ecoretools.design.action.generateAllID".javaDo("Generate All", 
						"genmodels" -> '''OrderedSet{views.target}.eInverse().eContainerOrSelf(genmodel::GenModel)->asSet()'''.trimAql,
						"scope" -> "model"
					)
				]
				menuItemDescription += OperationAction.createAs(Ns.operation, "Edit Code") [
					initVariables
					precondition = '''OrderedSet{views.target}.eInverse().eContainerOrSelf(genmodel::GenModel)->asSet()->select(m | m.editDirectory.size() > 0)->size() > 0'''.trimAql
					icon = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/GenModel.gif"
					operation = "org.eclipse.emf.ecoretools.design.action.generateAllID".javaDo("Generate All", 
						"genmodels" -> '''OrderedSet{views.target}.eInverse().eContainerOrSelf(genmodel::GenModel)->asSet()'''.trimAql,
						"scope" -> "edit"
					)
				]
				menuItemDescription += OperationAction.createAs(Ns.operation, "Editor Code") [
					initVariables
					precondition = '''OrderedSet{views.target}.eInverse().eContainerOrSelf(genmodel::GenModel)->asSet()->select(m | m.editorDirectory.size() > 0)->size() > 0'''.trimAql
					icon = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/GenModel.gif"
					operation = "org.eclipse.emf.ecoretools.design.action.generateAllID".javaDo("Generate All", 
						"genmodels" -> '''OrderedSet{views.target}.eInverse().eContainerOrSelf(genmodel::GenModel)->asSet()'''.trimAql,
						"scope" -> "editor"
					)
				]
				menuItemDescription += OperationAction.createAs(Ns.operation, "Tests Code") [
					initVariables
					precondition = '''OrderedSet{views.target}.eInverse().eContainerOrSelf(genmodel::GenModel)->asSet()->select(m | m.testsDirectory.size() > 0)->size() > 0'''.trimAql
					icon = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/GenModel.gif"
					operation = "org.eclipse.emf.ecoretools.design.action.generateAllID".javaDo("Generate All", 
						"genmodels" -> '''OrderedSet{views.target}.eInverse().eContainerOrSelf(genmodel::GenModel)->asSet()'''.trimAql,
						"scope" -> "tests"
					)
				]
			]
			ownedTools += PopupMenu.createAs(Ns.menu, "CDO Native") [
				precondition = '''self.hasCDOBundle()'''.trimAql
				menuItemDescription += OperationAction.createAs(Ns.operation, "Enable support") [
					initVariables
					precondition = '''OrderedSet{views.target}.eInverse().eContainerOrSelf(genmodel::GenModel)->asSet()->size() > 0'''.trimAql
					operation = "org.eclipse.emf.ecoretools.design.action.openConfirmationDialogID".javaDo("OpenConfirmationDialog", 
						"message" -> "The selected generator model will be updated:\n\nSet Feature Delegation = Reflective\nSet Root Extends Class = org.eclipse.emf.internal.cdo.CDOObjectImpl\nSet Root Extends Interface = org.eclipse.emf.cdo.CDOObject\nAdded Model Plugin Variables = CDO=org.eclipse.emf.cdo \nCreated CDO.MF marker file\n\nYou need to regenerate the code to make these changes effective. \n",
						"title" -> "The selected generator model will be updated:\n\nSet Feature Delegation = Reflective\nSet Root Extends Class = org.eclipse.emf.internal.cdo.CDOObjectImpl\nSet Root Extends Interface = org.eclipse.emf.cdo.CDOObject\nAdd Model Plugin Variables = CDO=org.eclipse.emf.cdo \nCreate CDO.MF marker file\n\nYou need to regenerate the code to make these changes effective. "
					).chain(
						'''self.enableCDOGen(OrderedSet{views->filter(viewpoint::DSemanticDecorator).target}.eInverse().eContainerOrSelf(genmodel::GenModel)->asSet())'''.trimAql.toOperation
					)
				]
				menuItemDescription += OperationAction.createAs(Ns.operation, "Disable support") [
					initVariables
					precondition = '''OrderedSet{views.target}.eInverse().eContainerOrSelf(genmodel::GenModel)->asSet()->size() > 0'''.trimAql
					operation = "org.eclipse.emf.ecoretools.design.action.openConfirmationDialogID".javaDo("OpenConfirmationDialog", 
						"message" -> "The selected generator model will be updated:...",
						"title" -> "Disable CDO Native support in .genmodel ?"
					).chain(
						'''self.disableCDOGen(OrderedSet{views->filter(viewpoint::DSemanticDecorator).target}.eInverse().eContainerOrSelf(genmodel::GenModel)->asSet())'''.trimAql.toOperation
					)
				]
			]
			ownedTools += SelectionWizardDescription.createAs(Ns.operation, "Add") [
				initVariables
				precondition = '''container.oclIsKindOf(ecore::EPackage)'''.trimAql
				forceRefresh = true
				candidatesExpression = '''self.getValidsForDiagram(containerView)->asSet() - diagram.getDisplayedEClassifiers()'''.trimAql
				multiple = true
				tree = true
				rootExpression = "service:rootEPackages"
				childrenExpression = "feature:eContents"
				iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/etools16/search.gif"
				windowTitle = "Select element to add in diagram"
				operation = "var:element".forDo("i", 
					"service:markForAutosize".toContext(
						"service:isEClass".ifThenDo(
							CreateView.create [
								containerViewExpression = "var:containerView"
								mapping = ContainerMapping.localRef(Ns.node, "EC EClass")
							]
						),
						"service:isEDataType".ifThenDo(
							CreateView.create [
								containerViewExpression = "var:containerView"
								mapping = ContainerMapping.localRef(Ns.node, "EC EDataType")
							]
						),
						"service:isEEnum".ifThenDo(
							CreateView.create [
								containerViewExpression = "var:containerView"
								mapping = ContainerMapping.localRef(Ns.node, "EC EEnum")
							]
						)
					)
				)
			]
			ownedTools += ToolDescription.createAs(Ns.operation, "RemoveExistingElements") [
				initVariables
				label = "Remove"
				forceRefresh = true
				iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/etools16/search.gif"
				operation = "var:elementView".toContext(
					DeleteView.create
				)
			]
			ownedTools += ContainerDropDescription.createAs(Ns.drop, "External EClass from treeview") [
				initVariables
				forceRefresh = true
				dragSource = DragSource.PROJECT_EXPLORER_LITERAL
				operation = "var:element".toContext(
					"service:markForAutosize".toContext(
						"service:isEClass".ifThenDo(
							CreateView.create [
								containerViewExpression = "var:newContainerView"
								mapping = ContainerMapping.localRef(Ns.node, "EC EClass")
							]
						),
						"service:isEDataType".ifThenDo(
							CreateView.create [
								containerViewExpression = "var:newContainerView"
								mapping = ContainerMapping.localRef(Ns.node, "EC EDataType")
							]
						),
						"service:isEEnum".ifThenDo(
							CreateView.create [
								containerViewExpression = "var:newContainerView"
								mapping = ContainerMapping.localRef(Ns.node, "EC EEnum")
							]
						),
						"service:isEPackage".ifThenDo(
							CreateView.create [
								containerViewExpression = "var:newContainerView"
								mapping = ContainerMapping.localRef(Ns.node, "Dropped Package")
							]
						)
					)
				)
			]
			ownedTools += OperationAction.createAs(Ns.operation, "Add Related Elements") [
				forceRefresh = true
				icon = "/org.eclipse.emf.ecoretools.design/icons/full/etools16/search.gif"
				view = ContainerViewVariable.create("views") [
					subVariables += SelectModelElementVariable.create("selected") [
						candidatesExpression = "service:getRelated(views,diagram)"
						multiple = true
						message = "Pick the Element you want to add to the diagram."
					]
				]
				operation = "var:selected".forDo("i", 
					"service:markForAutosize".toContext(
						"service:isEClass".ifThenDo(
							CreateView.create [
								containerViewExpression = "var:diagram"
								mapping = ContainerMapping.localRef(Ns.node, "EC EClass")
							]
						),
						"service:isEDataType".ifThenDo(
							CreateView.create [
								containerViewExpression = "var:diagram"
								mapping = ContainerMapping.localRef(Ns.node, "EC EDataType")
							]
						),
						"service:isEEnum".ifThenDo(
							CreateView.create [
								containerViewExpression = "var:diagram"
								mapping = ContainerMapping.localRef(Ns.node, "EC EEnum")
							]
						)
					)
				)
			]
			ownedTools += ContainerDropDescription.createAs(Ns.drop, "Drop EStructuralFeature into EClass") [
				initVariables
				mappings += ContainerMapping.localRef(Ns.node, "Dropped Package")
				operation = "var:newSemanticContainer".toContext(
					"service:isEOperation".ifThenDo(
						"eOperations".setter("var:element")
					),
					"service:isEStructuralFeature".ifThenDo(
						"eStructuralFeatures".setter("var:element")
					)
				)
			]
			ownedTools += PasteDescription.createAs(Ns.operation, "Paste Anything") [
				initVariables
				forceRefresh = true
				operation = "service:container.paste(copiedElement, copiedView, containerView)".toOperation
			]
			ownedTools += DoubleClickDescription.createAs(Ns.operation, "Import Current EClasses") [
				forceRefresh = true
				mappings += NodeMapping.localRef(Ns.node, "Empty Diagram")
				element = ElementDoubleClickVariable.create("element")
				elementView = ElementDoubleClickVariable.create("elementView") [
					subVariables += AcceleoVariable.create("diagram") [
						computationExpression = "feature:eContainer"
					]
				]
				operation = "var:element".toContext(
					"service:getRelated(elementView,diagram)".forDo("i", 
						"service:markForAutosize".toContext(
							"service:isEClass".ifThenDo(
								CreateView.create [
									containerViewExpression = "var:diagram"
									mapping = ContainerMapping.localRef(Ns.node, "EC EClass")
								]
							),
							"service:isEDataType".ifThenDo(
								CreateView.create [
									containerViewExpression = "var:diagram"
									mapping = ContainerMapping.localRef(Ns.node, "EC EDataType")
								]
							),
							"service:isEEnum".ifThenDo(
								CreateView.create [
									containerViewExpression = "var:diagram"
									mapping = ContainerMapping.localRef(Ns.node, "EC EEnum")
								]
							)
						)
					)
				)
			]
		]
	}


	def createClassifierTools() {
		ToolSection.create("Classifier") [
			ownedTools += ToolGroup.create("Classifier") [
				tools += ContainerCreationDescription.createAs(Ns.operation, "Class") [
					initVariables
					documentation = "M1+Y"
					precondition = '''(not container.oclIsKindOf(ecore::EClass)) or (container.abstract) or (container.interface)'''.trimAql
					containerMappings += ContainerMapping.localRef(Ns.node, "EC EClass")
					extraMappings += ContainerMapping.localRef(Ns.node, "EC EClass")
					operation = "var:container".toContext(
						"service:isEPackage".ifThenDo(
							"eClassifiers".creator("ecore.EClass").chain(
								"name".setter(''' 'NewEClass'  + self.eContainer().eContents(ecore::EClass)->size() '''.trimAql)
							)
						),
						"service:isEClass".ifThenDo(
							"abstract".setter("false"),
							"interface".setter("false")
						)
					)
				]
				tools += ContainerCreationDescription.createAs(Ns.operation, "Abstract Class") [
					initVariables
					precondition = '''(not container.oclIsKindOf(ecore::EClass)) or (not container.abstract)'''.trimAql
					iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/EClass_abstract.gif"
					containerMappings += ContainerMapping.localRef(Ns.node, "EC EClass")
					extraMappings += ContainerMapping.localRef(Ns.node, "EC EClass")
					operation = "var:container".toContext(
						"service:isEPackage".ifThenDo(
							"eClassifiers".creator("ecore.EClass").chain(
								"name".setter(''' 'NewAbstractClass' + self.eContainer().eContents(ecore::EClass)->size() '''.trimAql),
								"abstract".setter("true")
							)
						),
						"service:isEClass".ifThenDo(
							"abstract".setter("true"),
							"interface".setter("false")
						)
					)
				]
				tools += ContainerCreationDescription.createAs(Ns.operation, "Interface") [
					initVariables
					precondition = '''(not container.oclIsKindOf(ecore::EClass)) or (not container.interface)'''.trimAql
					iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/EClass_interface.gif"
					containerMappings += ContainerMapping.localRef(Ns.node, "EC EClass")
					extraMappings += ContainerMapping.localRef(Ns.node, "EC EClass")
					operation = "var:container".toContext(
						"service:isEPackage".ifThenDo(
							"eClassifiers".creator("ecore.EClass").chain(
								"name".setter(''' 'NewInterface' + self.eContainer().eContents(ecore::EClass)->size() '''.trimAql),
								"interface".setter("true"),
								"abstract".setter("true")
							)
						),
						"service:isEClass".ifThenDo(
							"abstract".setter("true"),
							"interface".setter("true")
						)
					)
				]
			]
			ownedTools += ContainerCreationDescription.createAs(Ns.operation, "Datatype") [
				initVariables
				containerMappings += ContainerMapping.localRef(Ns.node, "EC EDataType")
				operation = "eClassifiers".creator("ecore.EDataType").chain(
					"name".setter(''' 'NewDataType' + self.eContainer().eContents(ecore::EDataType)->size() '''.trimAql),
					"instanceTypeName".setter(''' 'newDataType' + self.eContainer().eContents(ecore::EDataType)->size() '''.trimAql)
				)
			]
			ownedTools += ContainerCreationDescription.createAs(Ns.operation, "Enumeration") [
				initVariables
				containerMappings += ContainerMapping.localRef(Ns.node, "EC EEnum")
				operation = "eClassifiers".creator("ecore.EEnum").chain(
					"name".setter(''' 'NewEnum' + self.eContainer().eContents(ecore::EEnum)->size() '''.trimAql)
				)
			]
			ownedTools += DeleteElementDescription.createAs(Ns.del, "Delete EClass") [
				initVariables
				operation = "var:self".toContext(
					"service:getInverseEReferences".forDo("i", 
						RemoveElement.create
					),
					RemoveElement.create
				)
			]
			ownedTools += NodeCreationDescription.createAs(Ns.creation, "ETypeParameter") [
				initVariables
				nodeMappings += NodeMapping.localRef(Ns.node, "EC ETypeParameter")
				operation = "var:container".toContext(
					"eTypeParameters".creator("ecore.ETypeParameter").chain(
						"name".setter("T")
					)
				)
			]
			ownedTools += DeleteElementDescription.createAs(Ns.del, "NoOp") [
				initVariables
				precondition = '''false'''.trimAql
				operation = "var:self".toOperation
			]
		]
	}


	def createFeatureTools() {
		ToolSection.create("Feature") [
			ownedTools += NodeCreationDescription.createAs(Ns.creation, "Literal") [
				initVariables
				nodeMappings += NodeMapping.localRef(Ns.node, "EC EEnumLiteral")
				operation = "eLiterals".creator("ecore.EEnumLiteral").chain(
					"name".setter('''('literal' +( self.eContainer().eContents(ecore::EEnumLiteral)->size() -1)).toUpper()'''.trimAql),
					"value".setter('''self.eContainer().eContents(ecore::EEnumLiteral)->size()-1'''.trimAql)
				)
			]
			ownedTools += NodeCreationDescription.createAs(Ns.creation, "Operation") [
				initVariables
				nodeMappings += NodeMapping.localRef(Ns.node, "Operation")
				operation = "eOperations".creator("ecore.EOperation").chain(
					"name".setter(''' 'newOperation' + self.eContainer().eContents(ecore::EOperation)->size() '''.trimAql)
				)
			]
			ownedTools += NodeCreationDescription.createAs(Ns.creation, "Attribute") [
				initVariables
				nodeMappings += NodeMapping.localRef(Ns.node, "EC EAttribute")
				operation = "eStructuralFeatures".creator("ecore.EAttribute").chain(
					"name".setter("newAttribute")
				)
			]
			ownedTools += ContainerDropDescription.createAs(Ns.drop, "Drop attribute") [
				initVariables
				mappings += NodeMapping.localRef(Ns.node, "EC EAttribute")
				mappings += NodeMapping.localRef(Ns.node, "EC EReferenceNode")
				operation = "var:newSemanticContainer".toContext(
					"eStructuralFeatures".setter("var:element")
				)
			]
			ownedTools += ContainerDropDescription.createAs(Ns.drop, "Drop operation") [
				initVariables
				mappings += NodeMapping.localRef(Ns.node, "Operation")
				operation = "var:newSemanticContainer".toContext(
					"eOperations".setter("var:element")
				)
			]
		]
	}


	def createRelationTools() {
		ToolSection.create("Relation") [
			ownedTools += DiagramCreationDescription.createAs(Ns.operation, "New Package Entities") [
				initVariables
				titleExpression = ''' self.name + ' package entities' '''.trimAql
				diagramDescription = DiagramDescription.ref("EntitiesDiagram")
				operation = "var:self".toOperation
			]
			ownedTools += EdgeCreationDescription.createAs(Ns.connect, "SuperType") [
				initVariables
				iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/Inheritance.gif"
				edgeMappings += EdgeMapping.localRef(Ns.edge, "EC ESupertypes")
				operation = "var:source".toContext(
					"eSuperTypes".setter("var:target").chain(
						"service:createTypeArgumentsIfNeeded(target)".toOperation
					)
				)
			]
			ownedTools += EdgeCreationDescription.createAs(Ns.connect, "Reference") [
				initVariables
				edgeMappings += EdgeMapping.localRef(Ns.edge, "EC_EReference")
				operation = "var:source".toContext(
					"eStructuralFeatures".creator("ecore.EReference").chain(
						"name".setter('''target.name.toLower()'''.trimAql),
						"service:setEType(target)".toOperation
					)
				)
			]
			ownedTools += EdgeCreationDescription.createAs(Ns.connect, "Bi-directional Reference") [
				initVariables
				edgeMappings += EdgeMapping.localRef(Ns.edge, "Bi-directional EC_EReference ")
				operation = "var:target".toContext(
					"eStructuralFeatures".creator("instanceTarget", "ecore.EReference").chain(
						"eType".setter('''source'''.trimAql),
						"name".setter('''source.name.toLower()'''.trimAql)
					),
					"var:source".toContext(
						"eStructuralFeatures".creator("instanceSource", "ecore.EReference").chain(
							"eType".setter("var:target"),
							"name".setter('''target.name.toLower()'''.trimAql),
							"eOpposite".setter("var:instanceTarget"),
							'''source = target'''.trimAql.ifThenDo(
								"name".setter(''' target.name.toLower() + 'eOpposite' '''.trimAql)
							)
						),
						"var:instanceTarget".toContext(
							"eOpposite".setter("var:instanceSource")
						)
					)
				)
			]
			ownedTools += EdgeCreationDescription.createAs(Ns.connect, "Composition") [
				initVariables
				edgeMappings += EdgeMapping.localRef(Ns.edge, "EC_EReference")
				operation = "var:source".toContext(
					"eStructuralFeatures".creator("ecore.EReference").chain(
						"name".setter('''target.name.toLower()'''.trimAql),
						"containment".setter("true"),
						"upperBound".setter("-1"),
						"service:setEType(target)".toOperation
					)
				)
			]
			ownedTools += DeleteElementDescription.createAs(Ns.del, "Delete ESuperType") [
				initVariables
				operation = "service:getEdgeSourceSemantic(elementView)".toContext(
					"eSuperTypes".unsetter("service:getEdgeTargetSemantic(elementView)")
				)
			]
		]
	}


	def createReconnectTools() {
		ToolSection.create("Reconnect") [
			ownedTools += ReconnectEdgeDescription.createAs(Ns.reconnect, "ReconnectEReference Source") [
				initVariables
				reconnectionKind = ReconnectionKind.RECONNECT_SOURCE_LITERAL
				operation = "var:element".toContext(
					"service:reconnectEReferenceSource(target)".toOperation
				)
			]
			ownedTools += ReconnectEdgeDescription.createAs(Ns.reconnect, "ReconnectEReference Target") [
				initVariables
				operation = "var:element".toContext(
					"service:reconnectEReferenceTarget(target)".toOperation
				)
			]
			ownedTools += ReconnectEdgeDescription.createAs(Ns.reconnect, "ReconnectESupertypeSource") [
				initVariables
				reconnectionKind = ReconnectionKind.RECONNECT_SOURCE_LITERAL
				operation = "var:element".toContext(
					'''self.reconnectESuperTypeSource(target,source,otherEnd,edgeView,sourceView)'''.trimAql.toOperation
				)
			]
			ownedTools += ReconnectEdgeDescription.createAs(Ns.reconnect, "ReconnectESupertypeTarget") [
				initVariables
				operation = "var:element".toContext(
					'''self.reconnectESuperTypeTarget(target,source,otherEnd,edgeView,sourceView)'''.trimAql.toOperation
				)
			]
			ownedTools += ReconnectEdgeDescription.createAs(Ns.reconnect, "ReconnectBiDirectionnalEReference Source") [
				initVariables
				reconnectionKind = ReconnectionKind.RECONNECT_SOURCE_LITERAL
				operation = "var:target".toContext(
					"eStructuralFeatures".creator("newSource", "ecore.EReference").chain(
						"name".setter('''element.name'''.trimAql),
						"eType".setter('''element.eType'''.trimAql),
						"eOpposite".setter('''element.eOpposite'''.trimAql)
					),
					'''element.eOpposite'''.trimAql.toContext(
						"eType".setter("var:target"),
						"eOpposite".setter('''newSource'''.trimAql)
					),
					"var:element".toContext(
						RemoveElement.create
					)
				)
			]
			ownedTools += ReconnectEdgeDescription.createAs(Ns.reconnect, "ReconnectBiDirectionnalEReference Target") [
				initVariables
				operation = "var:target".toContext(
					"eStructuralFeatures".creator("newTarget", "ecore.EReference").chain(
						"name".setter('''element.eOpposite.name'''.trimAql),
						"eType".setter('''element.eOpposite.eType'''.trimAql),
						"eOpposite".setter("var:element")
					),
					'''element.eOpposite'''.trimAql.toContext(
						RemoveElement.create
					),
					"var:element".toContext(
						"eType".setter("var:target"),
						"eOpposite".setter("var:newTarget")
					)
				)
			]
		]
	}


	def createDirectEditTools() {
		ToolSection.create("Direct Edit") [
			ownedTools += DirectEditLabel.createAs(Ns.operation, "Edit Name with CamelCase") [
				mask = "{0}"
				operation = "name".setter("service:toCamelCase(arg0)")
			]
			ownedTools += DirectEditLabel.createAs(Ns.operation, "Edit EStructuralFeature Name") [
				mask = "{0}"
				operation = "service:performEditAsAttribute(arg0)".toOperation
			]
			ownedTools += DirectEditLabel.createAs(Ns.operation, "EReference Name") [
				mask = "{0}"
				operation = "service:performEdit(arg0)".toOperation
			]
			ownedTools += DirectEditLabel.createAs(Ns.operation, "Operation Name") [
				documentation = "- \"name\" : change the name of the operation"
				forceRefresh = true
				mask = "{0}"
				operation = "service:performEdit(arg0)".toOperation
			]
			ownedTools += DoubleClickDescription.createAs(Ns.operation, "ShowPropertiesView") [
				initVariables
				mappings += ContainerMapping.localRef(Ns.node, "EC EClass")
				mappings += NodeMapping.localRef(Ns.node, "EC EAttribute")
				mappings += NodeMapping.localRef(Ns.node, "Operation")
				mappings += ContainerMapping.localRef(Ns.node, "EC EDataType")
				mappings += ContainerMapping.localRef(Ns.node, "EC EEnum")
				mappings += NodeMapping.localRef(Ns.node, "EC EEnumLiteral")
				mappings += NodeMapping.localRef(Ns.node, "EC EReferenceNode")
				mappings += ContainerMapping.localRef(Ns.node, "Dropped Package")
				operation = "var:element".toContext(
					DialogModelOperation.create [
						titleExpression = ''' 'Properties for '  + input.emfEditServices(self).getText() '''.trimAql
						buttons += DialogButton.create [
							labelExpression = "Cancel"
							closeDialogOnClick = true
							rollbackChangesOnClose = true
							operation = "var:self".toOperation
						]
						buttons += DialogButton.create [
							labelExpression = "OK"
							^default = true
							closeDialogOnClick = true
							operation = "var:self".toOperation
						]
						page = PageDescription.create("Default Page") [
							labelExpression = '''input.emfEditServices(self).getText()'''.trimAql
							semanticCandidateExpression = "var:self"
							extends = PageDescription.ref("page:DefaultViewExtension.ecore_page")
						]
					]
				)
			]
			ownedTools += DirectEditLabel.createAs(Ns.operation, "InstanceClassName") [
				documentation = "- \"name\" : change the name of the operation"
				forceRefresh = true
				mask = "{0}"
				operation = "instanceClassName".setter("var:arg0")
			]
			ownedTools += DirectEditLabel.createAs(Ns.operation, "Edit Name no CamelCase") [
				mask = "{0}"
				operation = "name".setter("var:arg0")
			]
			ownedTools += DirectEditLabel.createAs(Ns.operation, "Direct Edit EOpposite") [
				mask = "{0}"
				operation = "var:self".toOperation
			]
		]
	}


	def createHelpTools() {
		ToolSection.create("Help") [
			label = "Help"
			ownedTools += OperationAction.createAs(Ns.operation, "Open Entities User Guide") [
				initVariables
				label = "Open User Guide"
				operation = "org.eclipse.sirius.ui.business.api.action.openHelpSection".javaDo("Open Entities User Guide Action", 
					"href" -> "/org.eclipse.emf.ecoretools.doc/doc/EcoreTools User Manual.html#EntitiesDiagramEditor"
				)
			]
		]
	}


	def createDynamicTools() {
		ToolSection.create("Dynamic") [
			ownedTools += ToolDescription.createAs(Ns.operation, "Dynamic instance") [
				initVariables
				precondition = "service:isEClass"
				iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/DynamicInstance.gif"
				operation = "org.eclipse.emf.ecoretools.design.action.createDynamicInstanceActionID".javaDo("Create dynamic instance of a specified EClass", 
					"eClass" -> "var:element"
				)
			]
		]
	}

	def createPackageLayer() {
		AdditionalLayer.create("Package") [
			endUserDocumentation = "Add support for sub-packages."
			activeByDefault = true
			containerMappings += ContainerMapping.createAs(Ns.node, "Dropped Package") [
				createElements = false
				domainClass = "ecore.EPackage"
				detailDescriptions += DiagramCreationDescription.localRef(Ns.operation, "New Package Entities")
				pasteDescriptions += PasteDescription.localRef(Ns.operation, "Paste Anything")
				labelDirectEdit = DirectEditLabel.localRef(Ns.operation, "Edit Name no CamelCase")
				dropDescriptions += ContainerDropDescription.localRef(Ns.drop, "Drop EClassifier into EPackage")
				dropDescriptions += ContainerDropDescription.localRef(Ns.drop, "Drop EPackage into EPackage")
				reusedContainerMappings += ContainerMapping.localRef(Ns.node, "EC EClass")
				reusedContainerMappings += ContainerMapping.localRef(Ns.node, "EC EDataType")
				reusedContainerMappings += ContainerMapping.localRef(Ns.node, "EC EEnum")
				style(FlatContainerStyleDescription) [
					arcWidth = 1
					arcHeight = 1
					labelSize = 8
					labelExpression = '''self.name'''.trimAql
					labelAlignment = LabelAlignment.LEFT
					widthComputationExpression = "24"
					heightComputationExpression = "16"
					backgroundStyle = BackgroundStyle.LIQUID_LITERAL
					borderColor = UserFixedColor.ref("color:Dark EPackage")
					foregroundColor = UserFixedColor.ref("color:EPackage")
					labelBorderStyle = LabelBorderStyleDescription.extraRef("LabelBorder:Label Border Style With Beveled Corner")
				]
			]
			toolSections += createPackageTools
		]
	}

	def createPackageTools() {
		ToolSection.create("Package") [
			ownedTools += ContainerCreationDescription.createAs(Ns.operation, "Package") [
				initVariables
				containerMappings += ContainerMapping.localRef(Ns.node, "Dropped Package")
				operation = "eSubpackages".creator("newPackage", "ecore.EPackage").chain(
					"var:newPackage".toContext(
						"name".setter(''' 'newPackage' + self.eContainer().eContents(ecore::EPackage)->size() '''.trimAql)
					)
				)
			]
			ownedTools += ContainerDropDescription.createAs(Ns.drop, "Drop EClassifier into EPackage") [
				initVariables
				mappings += ContainerMapping.localRef(Ns.node, "EC EClass")
				mappings += ContainerMapping.localRef(Ns.node, "EC EDataType")
				mappings += ContainerMapping.localRef(Ns.node, "EC EEnum")
				mappings += ContainerMapping.localRef(Ns.node, "EC External EClasses")
				operation = "var:newSemanticContainer".toContext(
					"eClassifiers".setter("var:element")
				)
			]
			ownedTools += ContainerDropDescription.createAs(Ns.drop, "Drop EPackage into EPackage") [
				initVariables
				dragSource = DragSource.BOTH_LITERAL
				mappings += ContainerMapping.localRef(Ns.node, "Dropped Package")
				operation = "var:newSemanticContainer".toContext(
					"eSubpackages".setter("var:element").chain(
						CreateView.create [
							containerViewExpression = "var:newContainerView"
							mapping = ContainerMapping.localRef(Ns.node, "Dropped Package")
						]
					)
				)
			]
		]
	}


	def createDocumentationLayer() {
		AdditionalLayer.create("Documentation") [
			nodeMappings += NodeMapping.createAs(Ns.node, "EC Doc Annotation") [
				semanticCandidatesExpression = "service:getVisibleDocAnnotations(diagram)"
				domainClass = "ecore.EStringToStringMapEntry"
				labelDirectEdit = DirectEditLabel.localRef(Ns.operation, "Edit Detail")
				style(SquareDescription) [
					labelSize = 8
					showIcon = false
					labelExpression = "feature:value"
					labelAlignment = LabelAlignment.LEFT
					sizeComputationExpression = "1"
					labelPosition = LabelPosition.NODE_LITERAL
					resizeKind = ResizeKind.NSEW_LITERAL
					width = 12
					height = 10
					borderColor = SystemColor.extraRef("color:gray")
					color = UserFixedColor.ref("color:Doc Annotation")
				]
			]
			edgeMappings += EdgeMapping.createAs(Ns.edge, "EC Doc Assignment") [
				semanticCandidatesExpression = '''self.eAllContents()'''.trimAql
				targetFinderExpression = "service:eContainerEContainer"
				sourceMapping += NodeMapping.localRef(Ns.node, "EC Doc Annotation")
				targetMapping += EdgeMapping.localRef(Ns.edge, "EC_EReference")
				targetMapping += EdgeMapping.localRef(Ns.edge, "Bi-directional EC_EReference ")
				targetMapping += ContainerMapping.localRef(Ns.node, "EC EClass")
				targetMapping += ContainerMapping.localRef(Ns.node, "Dropped Package")
				targetMapping += ContainerMapping.localRef(Ns.node, "EC EDataType")
				targetMapping += ContainerMapping.localRef(Ns.node, "EC EEnum")
				style [
					lineStyle = LineStyle.DOT_LITERAL
					targetArrow = EdgeArrows.INPUT_ARROW_LITERAL
					routingStyle = EdgeRouting.STRAIGHT_LITERAL
					endsCentering = CenteringStyle.NONE
					centerLabel = [
						labelSize = 8
						labelExpression = ""
					]
				]
			]
			styleCustomisations += "service:hasNoDocAnnotation".thenStyle(
				"labelColor".refCustomization(SystemColor.extraRef("color:red"),
					FlatContainerStyleDescription.localRef(Ns.node, "EC EClass") [ (it as ContainerMapping).style as FlatContainerStyleDescription ],
					FlatContainerStyleDescription.localRef(Ns.node, "EC EClass") [ (it as ContainerMapping).conditionnalStyles.get(1).style as FlatContainerStyleDescription ],
					FlatContainerStyleDescription.localRef(Ns.node, "EC EClass") [ (it as ContainerMapping).conditionnalStyles.get(0).style as FlatContainerStyleDescription ],
					CenterLabelStyleDescription.localRef(Ns.edge, "EC_EReference") [ (it as EdgeMapping).style.centerLabelStyleDescription ],
					FlatContainerStyleDescription.localRef(Ns.node, "EC EDataType") [ (it as ContainerMapping).style as FlatContainerStyleDescription ]
				),
				"borderColor".refCustomization(SystemColor.extraRef("color:red"),
					FlatContainerStyleDescription.localRef(Ns.node, "EC EClass") [ (it as ContainerMapping).style as FlatContainerStyleDescription ],
					FlatContainerStyleDescription.localRef(Ns.node, "EC EClass") [ (it as ContainerMapping).conditionnalStyles.get(1).style as FlatContainerStyleDescription ],
					FlatContainerStyleDescription.localRef(Ns.node, "EC EClass") [ (it as ContainerMapping).conditionnalStyles.get(0).style as FlatContainerStyleDescription ],
					FlatContainerStyleDescription.localRef(Ns.node, "EC EDataType") [ (it as ContainerMapping).style as FlatContainerStyleDescription ]
				),
				"strokeColor".refCustomization(SystemColor.extraRef("color:red"),
					EdgeStyleDescription.localRef(Ns.edge, "Bi-directional EC_EReference ") [ (it as EdgeMapping).style ],
					EdgeStyleDescription.localRef(Ns.edge, "EC_EReference") [ (it as EdgeMapping).style ]
				)
			)
			toolSections += createDocumentationTools
		]
	}

	def createDocumentationTools() {
		ToolSection.create("Documentation") [
			ownedTools += NodeCreationDescription.createAs(Ns.creation, "Doc Annotation") [
				initVariables
				iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/EAnnotation_24.gif"
				nodeMappings += NodeMapping.localRef(Ns.node, "EC Doc Annotation")
				extraMappings += ContainerMapping.localRef(Ns.node, "EC EClass")
				extraMappings += ContainerMapping.localRef(Ns.node, "EC EDataType")
				extraMappings += ContainerMapping.localRef(Ns.node, "EC EEnum")
				extraMappings += ContainerMapping.localRef(Ns.node, "Dropped Package")
				operation = "var:container".toContext(
					'''self.eAnnotations->select(a | a.source = 'http://www.eclipse.org/emf/2002/GenModel')->size() = 0'''.trimAql.ifThenDo(
						"eAnnotations".creator("ecore.EAnnotation").chain(
							"source".setter(''' 'http://www.eclipse.org/emf/2002/GenModel' '''.trimAql)
						)
					),
					'''self.eAnnotations->select(a | a.source = 'http://www.eclipse.org/emf/2002/GenModel')->asSequence()->first()'''.trimAql.toContext(
						'''self.details->select(a | a.key = 'documentation')->size() = 0'''.trimAql.ifThenDo(
							"details".creator("ecore.EStringToStringMapEntry").chain(
								"key".setter(''' 'documentation' '''.trimAql)
							)
						),
						'''self.details->select(a | a.key = 'documentation')->asSequence()->first()'''.trimAql.toContext(
							"value".setter(''' 'New documentation note' '''.trimAql)
						)
					)
				)
			]
			ownedTools += DirectEditLabel.createAs(Ns.operation, "Edit Detail") [
				mask = "{0}"
				operation = "value".setter("var:arg0")
			]
			ownedTools += EdgeCreationDescription.createAs(Ns.connect, "Doc Assignment") [
				initVariables
				forceRefresh = true
				iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/AnnotationLink.gif"
				edgeMappings += EdgeMapping.localRef(Ns.edge, "EC Doc Assignment")
				operation = '''source.eContainer(ecore::EAnnotation)'''.trimAql.toContext(
					MoveElement.create [
						newContainerExpression = "var:target"
						featureName = "eAnnotations"
					]
				)
			]
		]
	}


	def createValidationLayer() {
		AdditionalLayer.create("Validation") [
			activeByDefault = true
			styleCustomisations += "service:hasError".thenStyle(
				"labelColor".refCustomization(SystemColor.extraRef("color:red"),
					BundledImageDescription.localRef(Ns.node, "EC EAttribute") [ (it as NodeMapping).style as BundledImageDescription ],
					BundledImageDescription.localRef(Ns.node, "Operation") [ (it as NodeMapping).style as BundledImageDescription ],
					CenterLabelStyleDescription.localRef(Ns.edge, "EC_EReference") [ (it as EdgeMapping).style.centerLabelStyleDescription ],
					CenterLabelStyleDescription.localRef(Ns.edge, "EC ESupertypes") [ (it as EdgeMapping).style.centerLabelStyleDescription ],
					CenterLabelStyleDescription.localRef(Ns.edge, "EC ESupertypes") [ (it as EdgeMapping).conditionnalStyles.get(0).style.centerLabelStyleDescription ],
					FlatContainerStyleDescription.localRef(Ns.node, "EC EClass") [ (it as ContainerMapping).conditionnalStyles.get(1).style as FlatContainerStyleDescription ],
					FlatContainerStyleDescription.localRef(Ns.node, "EC EClass") [ (it as ContainerMapping).conditionnalStyles.get(0).style as FlatContainerStyleDescription ],
					FlatContainerStyleDescription.localRef(Ns.node, "EC EClass") [ (it as ContainerMapping).style as FlatContainerStyleDescription ],
					FlatContainerStyleDescription.localRef(Ns.node, "EC EDataType") [ (it as ContainerMapping).style as FlatContainerStyleDescription ]
				),
				"borderColor".refCustomization(SystemColor.extraRef("color:red"),
					BundledImageDescription.localRef(Ns.node, "EC EAttribute") [ (it as NodeMapping).style as BundledImageDescription ],
					FlatContainerStyleDescription.localRef(Ns.node, "EC EClass") [ (it as ContainerMapping).style as FlatContainerStyleDescription ],
					BundledImageDescription.localRef(Ns.node, "Operation") [ (it as NodeMapping).style as BundledImageDescription ],
					FlatContainerStyleDescription.localRef(Ns.node, "EC EClass") [ (it as ContainerMapping).conditionnalStyles.get(1).style as FlatContainerStyleDescription ],
					FlatContainerStyleDescription.localRef(Ns.node, "EC EClass") [ (it as ContainerMapping).conditionnalStyles.get(0).style as FlatContainerStyleDescription ],
					FlatContainerStyleDescription.localRef(Ns.node, "EC EDataType") [ (it as ContainerMapping).style as FlatContainerStyleDescription ]
				),
				"strokeColor".refCustomization(SystemColor.extraRef("color:red"),
					EdgeStyleDescription.localRef(Ns.edge, "Bi-directional EC_EReference ") [ (it as EdgeMapping).style ],
					EdgeStyleDescription.localRef(Ns.edge, "EC_EReference") [ (it as EdgeMapping).style ]
				)
			)
		]
	}


	def createConstraintLayer() {
		AdditionalLayer.create("Constraint") [
			nodeMappings += NodeMapping.createAs(Ns.node, "EC Constraint Annotation") [
				semanticCandidatesExpression = "service:getVisibleConstraintsAnnotations(diagram)"
				domainClass = "ecore.EStringToStringMapEntry"
				labelDirectEdit = DirectEditLabel.localRef(Ns.operation, "Edit Detail")
				style(SquareDescription) [
					labelSize = 8
					showIcon = false
					labelExpression = "feature:value"
					sizeComputationExpression = "1"
					labelPosition = LabelPosition.NODE_LITERAL
					resizeKind = ResizeKind.NSEW_LITERAL
					width = 12
					height = 5
					borderColor = SystemColor.extraRef("color:dark_blue")
					labelColor = SystemColor.extraRef("color:white")
					color = SystemColor.extraRef("color:blue")
				]
			]
			edgeMappings += EdgeMapping.createAs(Ns.edge, "EC Constraint Assignment") [
				semanticCandidatesExpression = '''self.eAllContents()'''.trimAql
				targetFinderExpression = "service:eContainerEContainer"
				sourceMapping += NodeMapping.localRef(Ns.node, "EC Constraint Annotation")
				targetMapping += ContainerMapping.localRef(Ns.node, "EC EClass")
				targetMapping += ContainerMapping.localRef(Ns.node, "EC EDataType")
				targetMapping += ContainerMapping.localRef(Ns.node, "EC EEnum")
				style [
					lineStyle = LineStyle.DOT_LITERAL
					targetArrow = EdgeArrows.INPUT_ARROW_LITERAL
					routingStyle = EdgeRouting.STRAIGHT_LITERAL
					endsCentering = CenteringStyle.NONE
					strokeColor = SystemColor.extraRef("color:dark_blue")
					centerLabel = [
						labelSize = 8
						labelExpression = ""
					]
				]
			]
			toolSections += createConstraintsTools
		]
	}

	def createConstraintsTools() {
		ToolSection.create("Constraints") [
			ownedTools += NodeCreationDescription.createAs(Ns.creation, "Constraint") [
				initVariables
				iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/EAnnotation_24.gif"
				nodeMappings += NodeMapping.localRef(Ns.node, "EC Constraint Annotation")
				extraMappings += ContainerMapping.localRef(Ns.node, "EC EClass")
				extraMappings += ContainerMapping.localRef(Ns.node, "EC EDataType")
				extraMappings += ContainerMapping.localRef(Ns.node, "EC EEnum")
				extraMappings += ContainerMapping.localRef(Ns.node, "Dropped Package")
				operation = "var:container".toContext(
					'''self.eAnnotations->select(a | a.source = 'http://www.eclipse.org/emf/2002/Ecore')->size() = 0'''.trimAql.ifThenDo(
						"eAnnotations".creator("ecore.EAnnotation").chain(
							"source".setter(''' 'http://www.eclipse.org/emf/2002/Ecore' '''.trimAql)
						)
					),
					'''self.eAnnotations->select(a | a.source = 'http://www.eclipse.org/emf/2002/Ecore')->asSequence()->first()'''.trimAql.toContext(
						'''self.details->select(a | a.key = 'constraints')->size() = 0'''.trimAql.ifThenDo(
							"details".creator("ecore.EStringToStringMapEntry").chain(
								"key".setter(''' 'constraints' '''.trimAql)
							)
						),
						'''self.details->select(a | a.key = 'constraints')->asSequence()->first()'''.trimAql.toContext(
							"value".setter(''' 'Constraint1 Constraint2' '''.trimAql)
						)
					)
				)
			]
			ownedTools += EdgeCreationDescription.createAs(Ns.connect, "Constraint Assignment") [
				initVariables
				forceRefresh = true
				iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/AnnotationLink.gif"
				edgeMappings += EdgeMapping.localRef(Ns.edge, "EC Constraint Assignment")
				operation = '''source.eContainer(ecore::EAnnotation)'''.trimAql.toContext(
					MoveElement.create [
						newContainerExpression = "var:target"
						featureName = "eAnnotations"
					]
				)
			]
		]
	}


	def createRelatedEClassesLayer() {
		AdditionalLayer.create("Related EClasses") [
			containerMappings += ContainerMapping.createAs(Ns.node, "EC External EClasses") [
				semanticCandidatesExpression = "service:getExternalEClasses(diagram)"
				domainClass = "ecore.EClass"
				childrenPresentation = ContainerLayout.LIST
				deletionDescription = DeleteElementDescription.localRef(Ns.del, "NoOp")
				labelDirectEdit = DirectEditLabel.localRef(Ns.operation, "Edit Name with CamelCase")
				reusedBorderedNodeMappings += NodeMapping.localRef(Ns.node, "EC ETypeParameter")
				dropDescriptions += ContainerDropDescription.localRef(Ns.drop, "Drop attribute")
				dropDescriptions += ContainerDropDescription.localRef(Ns.drop, "Drop operation")
				reusedNodeMappings += NodeMapping.localRef(Ns.node, "EC EAttribute")
				reusedNodeMappings += NodeMapping.localRef(Ns.node, "Operation")
				style(FlatContainerStyleDescription) [
					arcWidth = 8
					arcHeight = 8
					labelSize = 8
					tooltipExpression = "service:renderTooltip"
					roundedCorner = true
					backgroundStyle = BackgroundStyle.LIQUID_LITERAL
					foregroundColor = UserFixedColor.ref("color:EClass")
				]
				styleIf(FlatContainerStyleDescription, "feature:interface") [
					arcWidth = 8
					arcHeight = 8
					labelSize = 8
					labelFormat += FontFormat.ITALIC_LITERAL
					iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/EClass_interface.gif"
					tooltipExpression = "service:renderTooltip"
					roundedCorner = true
					backgroundStyle = BackgroundStyle.LIQUID_LITERAL
					borderColor = UserFixedColor.ref("color:Dark EClass")
					foregroundColor = UserFixedColor.ref("color:Abstract EClass")
				]
				styleIf(FlatContainerStyleDescription, "feature:abstract") [
					arcWidth = 8
					arcHeight = 8
					labelSize = 8
					labelFormat += FontFormat.ITALIC_LITERAL
					iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/EClass_abstract.gif"
					tooltipExpression = "service:renderTooltip"
					roundedCorner = true
					backgroundStyle = BackgroundStyle.LIQUID_LITERAL
					borderColor = UserFixedColor.ref("color:Dark EClass")
					foregroundColor = UserFixedColor.ref("color:Abstract EClass")
				]
			]
		]
	}


	def createIconsPreviewLayer() {
		AdditionalLayer.create("Icons Preview") [
			icon = "/org.eclipse.emf.ecoretools.design/icons/full/etools16/image.gif"
			styleCustomisations += '''self.oclIsKindOf(ecore::EClass) and self.eInverse(genmodel::GenClass) <> null'''.trimAql.thenStyle(
				"iconPath".attCustomization('''self.eInverse(genmodel::GenClass).getEClassItemIconPath()->first()'''.trimAql,
					FlatContainerStyleDescription.localRef(Ns.node, "EC EClass") [ (it as ContainerMapping).conditionnalStyles.get(1).style as FlatContainerStyleDescription ],
					FlatContainerStyleDescription.localRef(Ns.node, "EC EClass") [ (it as ContainerMapping).conditionnalStyles.get(0).style as FlatContainerStyleDescription ],
					FlatContainerStyleDescription.localRef(Ns.node, "EC EClass") [ (it as ContainerMapping).style as FlatContainerStyleDescription ],
					FlatContainerStyleDescription.localRef(Ns.node, "EC External EClasses") [ (it as ContainerMapping).conditionnalStyles.get(1).style as FlatContainerStyleDescription ],
					FlatContainerStyleDescription.localRef(Ns.node, "EC External EClasses") [ (it as ContainerMapping).conditionnalStyles.get(0).style as FlatContainerStyleDescription ],
					FlatContainerStyleDescription.localRef(Ns.node, "EC External EClasses") [ (it as ContainerMapping).style as FlatContainerStyleDescription ]
				)
			)
		]
	}

}