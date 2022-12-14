package org.eclipse.emf.ecoretools.design.sirius

import org.eclipse.emf.ecore.EPackage
import org.eclipse.sirius.diagram.BackgroundStyle
import org.eclipse.sirius.diagram.BundledImageShape
import org.eclipse.sirius.diagram.ContainerLayout
import org.eclipse.sirius.diagram.EdgeArrows
import org.eclipse.sirius.diagram.EdgeRouting
import org.eclipse.sirius.diagram.LabelPosition
import org.eclipse.sirius.diagram.LineStyle
import org.eclipse.sirius.diagram.ResizeKind
import org.eclipse.sirius.diagram.description.AdditionalLayer
import org.eclipse.sirius.diagram.description.CenteringStyle
import org.eclipse.sirius.diagram.description.ConditionalContainerStyleDescription
import org.eclipse.sirius.diagram.description.ConditionalEdgeStyleDescription
import org.eclipse.sirius.diagram.description.ConditionalNodeStyleDescription
import org.eclipse.sirius.diagram.description.ContainerMapping
import org.eclipse.sirius.diagram.description.DiagramDescription
import org.eclipse.sirius.diagram.description.EdgeMapping
import org.eclipse.sirius.diagram.description.FoldingStyle
import org.eclipse.sirius.diagram.description.Layer
import org.eclipse.sirius.diagram.description.NodeMapping
import org.eclipse.sirius.diagram.description.filter.CompositeFilterDescription
import org.eclipse.sirius.diagram.description.filter.FilterKind
import org.eclipse.sirius.diagram.description.filter.MappingFilter
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
import org.eclipse.sirius.diagram.description.tool.NodeCreationVariable
import org.eclipse.sirius.diagram.description.tool.ReconnectEdgeDescription
import org.eclipse.sirius.diagram.description.tool.ReconnectionKind
import org.eclipse.sirius.diagram.description.tool.SourceEdgeCreationVariable
import org.eclipse.sirius.diagram.description.tool.SourceEdgeViewCreationVariable
import org.eclipse.sirius.diagram.description.tool.TargetEdgeCreationVariable
import org.eclipse.sirius.diagram.description.tool.TargetEdgeViewCreationVariable
import org.eclipse.sirius.diagram.description.tool.ToolGroup
import org.eclipse.sirius.diagram.description.tool.ToolSection
import org.eclipse.sirius.properties.DialogButton
import org.eclipse.sirius.properties.DialogModelOperation
import org.eclipse.sirius.properties.PageDescription
import org.eclipse.sirius.viewpoint.FontFormat
import org.eclipse.sirius.viewpoint.LabelAlignment
import org.eclipse.sirius.viewpoint.description.Customization
import org.eclipse.sirius.viewpoint.description.DecorationDescriptionsSet
import org.eclipse.sirius.viewpoint.description.DecorationDistributionDirection
import org.eclipse.sirius.viewpoint.description.EAttributeCustomization
import org.eclipse.sirius.viewpoint.description.EReferenceCustomization
import org.eclipse.sirius.viewpoint.description.Environment
import org.eclipse.sirius.viewpoint.description.Position
import org.eclipse.sirius.viewpoint.description.SemanticBasedDecoration
import org.eclipse.sirius.viewpoint.description.SystemColor
import org.eclipse.sirius.viewpoint.description.SytemColorsPalette
import org.eclipse.sirius.viewpoint.description.UserFixedColor
import org.eclipse.sirius.viewpoint.description.VSMElementCustomization
import org.eclipse.sirius.viewpoint.description.style.LabelBorderStyleDescription
import org.eclipse.sirius.viewpoint.description.style.LabelBorderStyles
import org.eclipse.sirius.viewpoint.description.tool.AcceleoVariable
import org.eclipse.sirius.viewpoint.description.tool.ChangeContext
import org.eclipse.sirius.viewpoint.description.tool.ContainerViewVariable
import org.eclipse.sirius.viewpoint.description.tool.CreateInstance
import org.eclipse.sirius.viewpoint.description.tool.DeleteView
import org.eclipse.sirius.viewpoint.description.tool.DragSource
import org.eclipse.sirius.viewpoint.description.tool.DropContainerVariable
import org.eclipse.sirius.viewpoint.description.tool.EditMaskVariables
import org.eclipse.sirius.viewpoint.description.tool.ElementDeleteVariable
import org.eclipse.sirius.viewpoint.description.tool.ElementDropVariable
import org.eclipse.sirius.viewpoint.description.tool.ElementSelectVariable
import org.eclipse.sirius.viewpoint.description.tool.ElementVariable
import org.eclipse.sirius.viewpoint.description.tool.ElementViewVariable
import org.eclipse.sirius.viewpoint.description.tool.ExternalJavaAction
import org.eclipse.sirius.viewpoint.description.tool.ExternalJavaActionParameter
import org.eclipse.sirius.viewpoint.description.tool.For
import org.eclipse.sirius.viewpoint.description.tool.If
import org.eclipse.sirius.viewpoint.description.tool.InitEdgeCreationOperation
import org.eclipse.sirius.viewpoint.description.tool.InitialContainerDropOperation
import org.eclipse.sirius.viewpoint.description.tool.InitialNodeCreationOperation
import org.eclipse.sirius.viewpoint.description.tool.InitialOperation
import org.eclipse.sirius.viewpoint.description.tool.MoveElement
import org.eclipse.sirius.viewpoint.description.tool.NameVariable
import org.eclipse.sirius.viewpoint.description.tool.OperationAction
import org.eclipse.sirius.viewpoint.description.tool.PasteDescription
import org.eclipse.sirius.viewpoint.description.tool.PopupMenu
import org.eclipse.sirius.viewpoint.description.tool.RemoveElement
import org.eclipse.sirius.viewpoint.description.tool.SelectContainerVariable
import org.eclipse.sirius.viewpoint.description.tool.SelectModelElementVariable
import org.eclipse.sirius.viewpoint.description.tool.SelectionWizardDescription
import org.eclipse.sirius.viewpoint.description.tool.SetValue
import org.eclipse.sirius.viewpoint.description.tool.ToolDescription
import org.eclipse.sirius.viewpoint.description.tool.Unset
import org.eclipse.sirius.viewpoint.description.validation.ERROR_LEVEL
import org.eclipse.sirius.viewpoint.description.validation.RuleAudit
import org.eclipse.sirius.viewpoint.description.validation.ValidationFix
import org.eclipse.sirius.viewpoint.description.validation.ValidationSet
import org.eclipse.sirius.viewpoint.description.validation.ViewValidationRule
import org.mypsycho.modit.emf.sirius.api.AbstractDiagram

import static extension org.mypsycho.modit.emf.sirius.api.SiriusDesigns.*

class EntitiesDiagram extends AbstractDiagram {

	new(EcoretoolsDesign parent) {
		super(parent, "Entities", "Entities in a Class Diagram", EPackage)
	}

	override initContent(DiagramDescription it) {
		super.initContent(it)
		documentation = "<html>\n<head>\n</head>\n<body>\n<p>Provides a class diagram to represent EClasses, EDatatypes, EAttributes and their relationships.</p>\n<br>\n<img src=\"/icons/full/wizban/entities.png\"/>\n</body>\n</html>\n\n\n"
		endUserDocumentation = "A class diagram to represent EClasses, EDatatypes, EAttributes and their relationships."
		titleExpression = ''' self.name + ' class diagram' '''.trimAql
		enablePopupBars = true
		dropDescriptions += ContainerDropDescription.localRef(Ns.drop, "External EClass from treeview")
		dropDescriptions += ContainerDropDescription.localRef(Ns.drop, "Drop EClassifier into EPackage")
		pasteDescriptions += PasteDescription.localRef(Ns.operation, "Paste Anything")
		filters += CompositeFilterDescription.create("Hide class content") [
			filters += MappingFilter.create [
				mappings += NodeMapping.localRef(Ns.node, "EC EAttribute")
				mappings += NodeMapping.localRef(Ns.node, "Operation")
			]
		]
		filters += CompositeFilterDescription.create("Hide generalizations") [
			filters += MappingFilter.create [
				mappings += EdgeMapping.localRef(Ns.edge, "EC ESupertypes")
			]
		]
		filters += CompositeFilterDescription.create("Hide indirect generalizations") [
			filters += MappingFilter.create [
				viewConditionExpression = '''not self.oclAsType(diagram::DEdge).sourceNode.oclAsType(viewpoint::DSemanticDecorator).target.oclAsType(ecore::EClass).eSuperTypes->includes(self.oclAsType(diagram::DEdge).targetNode.oclAsType(viewpoint::DSemanticDecorator).target)'''.trimAql
				mappings += EdgeMapping.localRef(Ns.edge, "EC ESupertypes")
			]
		]
		filters += CompositeFilterDescription.create("Hide references (edges)") [
			filters += MappingFilter.create [
				mappings += EdgeMapping.localRef(Ns.edge, "EC_EReference")
				mappings += EdgeMapping.localRef(Ns.edge, "Bi-directional EC_EReference ")
			]
		]
		filters += CompositeFilterDescription.create("Hide references (nodes)") [
			filters += MappingFilter.create [
				mappings += NodeMapping.localRef(Ns.node, "EC EReferenceNode")
			]
		]
		filters += CompositeFilterDescription.create("Hide inherited references (nodes)") [
			filters += MappingFilter.create [
				viewConditionExpression = '''self.eContainer().oclAsType(viewpoint::DSemanticDecorator).target = self.oclAsType(viewpoint::DSemanticDecorator).target.eContainer()'''.trimAql
				mappings += NodeMapping.localRef(Ns.node, "EC EReferenceNode")
			]
		]
		filters += CompositeFilterDescription.create("Hide derived features") [
			filters += MappingFilter.create [
				semanticConditionExpression = '''not self.derived'''.trimAql
				mappings += EdgeMapping.localRef(Ns.edge, "EC_EReference")
				mappings += NodeMapping.localRef(Ns.node, "EC EAttribute")
				mappings += EdgeMapping.localRef(Ns.edge, "Bi-directional EC_EReference ")
				mappings += NodeMapping.localRef(Ns.node, "EC EReferenceNode")
			]
		]
		filters += CompositeFilterDescription.create("Hide operations") [
			filters += MappingFilter.create [
				semanticConditionExpression = ""
				mappings += NodeMapping.localRef(Ns.node, "Operation")
			]
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
					initialOperation = InitialOperation.create [
						firstModelOperations = ChangeContext.create [
							browseExpression = "feature:target"
							subModelOperations += RemoveElement.create
						]
					]
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
		diagramInitialisation = InitialOperation.create [
			firstModelOperations = "service:openClassDiagramContextHelp".toOperation
		]
		additionalLayers += createPackageLayer
		additionalLayers += createDocumentationLayer
		additionalLayers += createValidationLayer
		additionalLayers += createConstraintLayer
		additionalLayers += createRelatedEClassesLayer
		additionalLayers += createIconsPreviewLayer
	}

	override initContent(Layer it) {
		decorationDescriptionsSet = DecorationDescriptionsSet.create [
			decorationDescriptions += SemanticBasedDecoration.create [
				name = "External"
				position = Position.NORTH_EAST_LITERAL
				preconditionExpression = "service:viewContainerNotSemanticContainer(diagram,containerView)"
				imageExpression = "/org.eclipse.emf.ecoretools.design/icons/full/ovr16/shortcut.gif"
				domainClass = "ecore.EClassifier"
			]
		]
		customization = Customization.create [
			vsmElementCustomizations += VSMElementCustomization.create [
				predicateExpression = "feature:required"
				featureCustomizations += EAttributeCustomization.create [
					attributeName = "labelFormat"
					value = "service:fontFormatBold"
					appliedOn += CenterLabelStyleDescription.ref("EntitiesDiagram")[ (it as DiagramDescription).defaultLayer.edgeMappings.at("EC_EReference").style.centerLabelStyleDescription ]
					appliedOn += BundledImageDescription.ref("EntitiesDiagram")[ ((it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("EC EAttribute").style as BundledImageDescription) ]
					appliedOn += BeginLabelStyleDescription.ref("EntitiesDiagram")[ (it as DiagramDescription).defaultLayer.edgeMappings.at("Bi-directional EC_EReference ").style.beginLabelStyleDescription ]
					appliedOn += EndLabelStyleDescription.ref("EntitiesDiagram")[ (it as DiagramDescription).defaultLayer.edgeMappings.at("Bi-directional EC_EReference ").style.endLabelStyleDescription ]
					appliedOn += BundledImageDescription.ref("EntitiesDiagram")[ ((it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("EC EReferenceNode").style as BundledImageDescription) ]
					appliedOn += BundledImageDescription.ref("EntitiesDiagram")[ ((it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("EC EReferenceNode").conditionnalStyles.head.style as BundledImageDescription) ]
				]
				featureCustomizations += EReferenceCustomization.create [
					referenceName = "strokeColor"
					appliedOn += EdgeStyleDescription.ref("EntitiesDiagram")[ (it as DiagramDescription).defaultLayer.edgeMappings.at("Bi-directional EC_EReference ").style ]
					appliedOn += EdgeStyleDescription.ref("EntitiesDiagram")[ (it as DiagramDescription).defaultLayer.edgeMappings.at("EC_EReference").style ]
					value = SystemColor.extraRef("color:black")
				]
			]
			vsmElementCustomizations += VSMElementCustomization.create [
				predicateExpression = "feature:containment"
				featureCustomizations += EAttributeCustomization.create [
					attributeName = "sourceArrow"
					value = "service:arrowsFillDiamond"
					appliedOn += EdgeStyleDescription.ref("EntitiesDiagram")[ (it as DiagramDescription).defaultLayer.edgeMappings.at("EC_EReference").style ]
					appliedOn += EdgeStyleDescription.ref("EntitiesDiagram")[ (it as DiagramDescription).defaultLayer.edgeMappings.at("Bi-directional EC_EReference ").style ]
				]
				featureCustomizations += EAttributeCustomization.create [
					attributeName = "sizeComputationExpression"
					value = "1"
					appliedOn += EdgeStyleDescription.ref("EntitiesDiagram")[ (it as DiagramDescription).defaultLayer.edgeMappings.at("EC_EReference").style ]
					appliedOn += EdgeStyleDescription.ref("EntitiesDiagram")[ (it as DiagramDescription).defaultLayer.edgeMappings.at("Bi-directional EC_EReference ").style ]
				]
			]
			vsmElementCustomizations += VSMElementCustomization.create [
				predicateExpression = "feature:container"
				featureCustomizations += EAttributeCustomization.create [
					attributeName = "targetArrow"
					value = "service:arrowsFillDiamond"
					appliedOn += EdgeStyleDescription.ref("EntitiesDiagram")[ (it as DiagramDescription).defaultLayer.edgeMappings.at("EC_EReference").style ]
					appliedOn += EdgeStyleDescription.ref("EntitiesDiagram")[ (it as DiagramDescription).defaultLayer.edgeMappings.at("Bi-directional EC_EReference ").style ]
				]
				featureCustomizations += EAttributeCustomization.create [
					attributeName = "sizeComputationExpression"
					value = "1"
					appliedOn += EdgeStyleDescription.ref("EntitiesDiagram")[ (it as DiagramDescription).defaultLayer.edgeMappings.at("EC_EReference").style ]
					appliedOn += EdgeStyleDescription.ref("EntitiesDiagram")[ (it as DiagramDescription).defaultLayer.edgeMappings.at("Bi-directional EC_EReference ").style ]
				]
			]
			vsmElementCustomizations += VSMElementCustomization.create [
				predicateExpression = "feature:derived"
				featureCustomizations += EReferenceCustomization.create [
					referenceName = "strokeColor"
					appliedOn += EdgeStyleDescription.ref("EntitiesDiagram")[ (it as DiagramDescription).defaultLayer.edgeMappings.at("EC_EReference").style ]
					appliedOn += EdgeStyleDescription.ref("EntitiesDiagram")[ (it as DiagramDescription).defaultLayer.edgeMappings.at("Bi-directional EC_EReference ").style ]
					value = SystemColor.extraRef("color:blue")
				]
				featureCustomizations += EReferenceCustomization.create [
					referenceName = "labelColor"
					appliedOn += BeginLabelStyleDescription.ref("EntitiesDiagram")[ (it as DiagramDescription).defaultLayer.edgeMappings.at("Bi-directional EC_EReference ").style.beginLabelStyleDescription ]
					appliedOn += EndLabelStyleDescription.ref("EntitiesDiagram")[ (it as DiagramDescription).defaultLayer.edgeMappings.at("Bi-directional EC_EReference ").style.endLabelStyleDescription ]
					appliedOn += CenterLabelStyleDescription.ref("EntitiesDiagram")[ (it as DiagramDescription).defaultLayer.edgeMappings.at("EC_EReference").style.centerLabelStyleDescription ]
					appliedOn += BundledImageDescription.ref("EntitiesDiagram")[ ((it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("EC EAttribute").style as BundledImageDescription) ]
					appliedOn += BundledImageDescription.ref("EntitiesDiagram")[ ((it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("EC EReferenceNode").style as BundledImageDescription) ]
					appliedOn += BundledImageDescription.ref("EntitiesDiagram")[ ((it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("EC EReferenceNode").conditionnalStyles.head.style as BundledImageDescription) ]
					value = SystemColor.extraRef("color:dark_blue")
				]
			]
		]
		nodeMappings += NodeMapping.createAs(Ns.node, "Empty Diagram") [
			preconditionExpression = '''containerView.oclAsType(diagram::DDiagram).ownedDiagramElements.target->excluding(containerView.oclAsType(diagram::DSemanticDiagram).target)->size() = 0 and container.eClassifiers->size() > 0'''.trimAql
			semanticCandidatesExpression = "var:self"
			domainClass = "ecore.EPackage"
			deletionDescription = DeleteElementDescription.localRef(Ns.del, "NoOp")
			style = WorkspaceImageDescription.create [
				showIcon = false
				labelExpression = ""
				sizeComputationExpression = "-1"
				labelPosition = LabelPosition.NODE_LITERAL
				arcWidth = 1
				arcHeight = 1
				workspacePath = "/org.eclipse.emf.ecoretools.design/icons/full/back/empty.svg"
				borderColor = SystemColor.extraRef("color:black")
				labelColor = SystemColor.extraRef("color:black")
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
			style = FlatContainerStyleDescription.create [
				arcWidth = 8
				arcHeight = 8
				borderSizeComputationExpression = "1"
				tooltipExpression = "service:renderTooltip"
				roundedCorner = true
				widthComputationExpression = "12"
				heightComputationExpression = "10"
				backgroundStyle = BackgroundStyle.LIQUID_LITERAL
				borderColor = SystemColor.extraRef("color:black")
				labelColor = SystemColor.extraRef("color:black")
				backgroundColor = SystemColor.extraRef("color:white")
				foregroundColor = UserFixedColor.ref("color:EClass")
			]
			conditionnalStyles += ConditionalContainerStyleDescription.create [
				predicateExpression = "feature:interface"
				style = FlatContainerStyleDescription.create [
					arcWidth = 8
					arcHeight = 8
					borderSizeComputationExpression = "1"
					labelFormat += FontFormat.ITALIC_LITERAL
					iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/EClass_interface.gif"
					tooltipExpression = "service:renderTooltip"
					roundedCorner = true
					widthComputationExpression = "12"
					heightComputationExpression = "10"
					backgroundStyle = BackgroundStyle.LIQUID_LITERAL
					borderColor = UserFixedColor.ref("color:Dark EClass")
					labelColor = SystemColor.extraRef("color:black")
					backgroundColor = SystemColor.extraRef("color:white")
					foregroundColor = UserFixedColor.ref("color:Abstract EClass")
				]
			]
			conditionnalStyles += ConditionalContainerStyleDescription.create [
				predicateExpression = "feature:abstract"
				style = FlatContainerStyleDescription.create [
					arcWidth = 8
					arcHeight = 8
					borderSizeComputationExpression = "1"
					labelFormat += FontFormat.ITALIC_LITERAL
					iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/EClass_abstract.gif"
					tooltipExpression = "service:renderTooltip"
					roundedCorner = true
					widthComputationExpression = "12"
					heightComputationExpression = "10"
					backgroundStyle = BackgroundStyle.LIQUID_LITERAL
					borderColor = UserFixedColor.ref("color:Dark EClass")
					labelColor = SystemColor.extraRef("color:black")
					backgroundColor = SystemColor.extraRef("color:white")
					foregroundColor = UserFixedColor.ref("color:Abstract EClass")
				]
			]
			borderedNodeMappings += NodeMapping.createAs(Ns.node, "EC ETypeParameter") [
				semanticCandidatesExpression = "feature:eTypeParameters"
				domainClass = "ecore.ETypeParameter"
				labelDirectEdit = DirectEditLabel.localRef(Ns.operation, "Edit Name with CamelCase")
				style = WorkspaceImageDescription.create [
					showIcon = false
					labelPosition = LabelPosition.NODE_LITERAL
					resizeKind = ResizeKind.NSEW_LITERAL
					arcWidth = 1
					arcHeight = 1
					workspacePath = "/org.eclipse.emf.ecoretools.design/icons/full/back/generic.svg"
					borderColor = SystemColor.extraRef("color:black")
					labelColor = SystemColor.extraRef("color:black")
				]
			]
			subNodeMappings += NodeMapping.createAs(Ns.node, "EC EAttribute") [
				semanticCandidatesExpression = "feature:eAttributes"
				domainClass = "ecore.EAttribute"
				labelDirectEdit = DirectEditLabel.localRef(Ns.operation, "Edit EStructuralFeature Name")
				dropDescriptions += ContainerDropDescription.localRef(Ns.drop, "Drop EStructuralFeature into EClass")
				style = BundledImageDescription.create [
					labelExpression = "service:render"
					labelAlignment = LabelAlignment.LEFT
					tooltipExpression = "service:renderTooltip"
					sizeComputationExpression = "1"
					borderColor = SystemColor.extraRef("color:black")
					labelColor = SystemColor.extraRef("color:black")
					color = SystemColor.extraRef("color:black")
				]
			]
			subNodeMappings += NodeMapping.createAs(Ns.node, "Operation") [
				semanticCandidatesExpression = "feature:eOperations"
				semanticElements = "service:eOperationSemanticElements"
				domainClass = "ecore.EOperation"
				labelDirectEdit = DirectEditLabel.localRef(Ns.operation, "Operation Name")
				dropDescriptions += ContainerDropDescription.localRef(Ns.drop, "Drop EStructuralFeature into EClass")
				style = BundledImageDescription.create [
					labelExpression = "service:render"
					labelAlignment = LabelAlignment.LEFT
					tooltipExpression = "service:renderEOperationTooltip"
					sizeComputationExpression = "2"
					borderColor = SystemColor.extraRef("color:black")
					labelColor = SystemColor.extraRef("color:black")
					color = SystemColor.extraRef("color:black")
				]
			]
			subNodeMappings += NodeMapping.createAs(Ns.node, "EC EReferenceNode") [
				semanticCandidatesExpression = "service:getNonDisplayedEReferences(diagram)"
				domainClass = "ecore.EReference"
				labelDirectEdit = DirectEditLabel.localRef(Ns.operation, "Edit EStructuralFeature Name")
				dropDescriptions += ContainerDropDescription.localRef(Ns.drop, "Drop EStructuralFeature into EClass")
				style = BundledImageDescription.create [
					labelExpression = "service:renderAsNode"
					labelAlignment = LabelAlignment.LEFT
					tooltipExpression = "service:renderTooltip"
					sizeComputationExpression = "1"
					borderColor = SystemColor.extraRef("color:black")
					labelColor = SystemColor.extraRef("color:black")
					color = SystemColor.extraRef("color:blue")
				]
				conditionnalStyles += ConditionalNodeStyleDescription.create [
					predicateExpression = '''container <> self.eContainer()'''.trimAql
					style = BundledImageDescription.create [
						labelFormat += FontFormat.ITALIC_LITERAL
						labelExpression = "service:renderAsNode"
						labelAlignment = LabelAlignment.LEFT
						tooltipExpression = "service:renderTooltip"
						sizeComputationExpression = "1"
						borderColor = SystemColor.extraRef("color:black")
						labelColor = UserFixedColor.ref("color:Inherited")
						color = SystemColor.extraRef("color:black")
					]
				]
			]
		]
		containerMappings += ContainerMapping.createAs(Ns.node, "EC EEnum") [
			createElements = false
			domainClass = "ecore.EEnum"
			childrenPresentation = ContainerLayout.LIST
			labelDirectEdit = DirectEditLabel.localRef(Ns.operation, "Edit Name with CamelCase")
			style = FlatContainerStyleDescription.create [
				arcWidth = 1
				arcHeight = 1
				borderSizeComputationExpression = "1"
				tooltipExpression = "service:renderTooltip"
				widthComputationExpression = "12"
				heightComputationExpression = "10"
				backgroundStyle = BackgroundStyle.LIQUID_LITERAL
				borderColor = UserFixedColor.ref("color:Dark EEnum")
				labelColor = SystemColor.extraRef("color:black")
				backgroundColor = SystemColor.extraRef("color:white")
				foregroundColor = UserFixedColor.ref("color:EEnum")
			]
			subNodeMappings += NodeMapping.createAs(Ns.node, "EC EEnumLiteral") [
				semanticCandidatesExpression = "feature:eLiterals"
				domainClass = "ecore.EEnumLiteral"
				labelDirectEdit = DirectEditLabel.localRef(Ns.operation, "Edit Name no CamelCase")
				style = BundledImageDescription.create [
					labelAlignment = LabelAlignment.LEFT
					tooltipExpression = "service:renderTooltip"
					sizeComputationExpression = "1"
					borderColor = SystemColor.extraRef("color:black")
					labelColor = SystemColor.extraRef("color:black")
					color = SystemColor.extraRef("color:black")
				]
			]
		]
		containerMappings += ContainerMapping.createAs(Ns.node, "EC EDataType") [
			preconditionExpression = "service:isEDataType"
			createElements = false
			domainClass = "ecore.EDataType"
			childrenPresentation = ContainerLayout.LIST
			labelDirectEdit = DirectEditLabel.localRef(Ns.operation, "Edit Name with CamelCase")
			style = FlatContainerStyleDescription.create [
				arcWidth = 1
				arcHeight = 1
				borderSizeComputationExpression = "1"
				tooltipExpression = "service:renderTooltip"
				widthComputationExpression = "14"
				heightComputationExpression = "5"
				backgroundStyle = BackgroundStyle.LIQUID_LITERAL
				borderColor = UserFixedColor.ref("color:Dark EDataType")
				labelColor = SystemColor.extraRef("color:black")
				backgroundColor = SystemColor.extraRef("color:white")
				foregroundColor = UserFixedColor.ref("color:EDataType")
			]
			subNodeMappings += NodeMapping.createAs(Ns.node, "EC_DataType_InstanceClassName") [
				semanticCandidatesExpression = "var:self"
				domainClass = "ecore.EDataType"
				labelDirectEdit = DirectEditLabel.localRef(Ns.operation, "InstanceClassName")
				style = BundledImageDescription.create [
					labelFormat += FontFormat.ITALIC_LITERAL
					showIcon = false
					labelExpression = "feature:instanceClassName"
					tooltipExpression = "service:renderTooltip"
					sizeComputationExpression = "1"
					borderColor = SystemColor.extraRef("color:black")
					labelColor = SystemColor.extraRef("color:black")
					color = SystemColor.extraRef("color:black")
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
			style = EdgeStyleDescription.create [
				routingStyle = EdgeRouting.MANHATTAN_LITERAL
				strokeColor = SystemColor.extraRef("color:black")
				centerLabelStyleDescription = CenterLabelStyleDescription.create [
					showIcon = false
					labelExpression = "service:render"
					labelColor = SystemColor.extraRef("color:black")
				]
				endLabelStyleDescription = EndLabelStyleDescription.create [
					labelSize = 6
					showIcon = false
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
			style = EdgeStyleDescription.create [
				targetArrow = EdgeArrows.INPUT_CLOSED_ARROW_LITERAL
				routingStyle = EdgeRouting.TREE_LITERAL
				strokeColor = SystemColor.extraRef("color:gray")
				beginLabelStyleDescription = BeginLabelStyleDescription.create [
					labelFormat += FontFormat.ITALIC_LITERAL
					showIcon = false
					labelExpression = "service:superTypesLabel"
					labelColor = SystemColor.extraRef("color:black")
				]
				centerLabelStyleDescription = CenterLabelStyleDescription.create [
					showIcon = false
					labelColor = SystemColor.extraRef("color:black")
				]
			]
			conditionnalStyles += ConditionalEdgeStyleDescription.create [
				predicateExpression = "service:targetIsInterface(view)"
				style = EdgeStyleDescription.create [
					lineStyle = LineStyle.DASH_LITERAL
					targetArrow = EdgeArrows.INPUT_CLOSED_ARROW_LITERAL
					routingStyle = EdgeRouting.TREE_LITERAL
					strokeColor = SystemColor.extraRef("color:gray")
					beginLabelStyleDescription = BeginLabelStyleDescription.create [
						labelFormat += FontFormat.ITALIC_LITERAL
						showIcon = false
						labelExpression = "service:superTypesLabel"
						labelColor = SystemColor.extraRef("color:black")
					]
					centerLabelStyleDescription = CenterLabelStyleDescription.create [
						showIcon = false
						labelColor = SystemColor.extraRef("color:black")
					]
				]
			]
			conditionnalStyles += ConditionalEdgeStyleDescription.create [
				predicateExpression = '''not self.eSuperTypes->includes(view.oclAsType(diagram::DEdge).targetNode.oclAsType(viewpoint::DSemanticDecorator).target)'''.trimAql
				style = EdgeStyleDescription.create [
					lineStyle = LineStyle.DOT_LITERAL
					targetArrow = EdgeArrows.INPUT_CLOSED_ARROW_LITERAL
					routingStyle = EdgeRouting.TREE_LITERAL
					strokeColor = UserFixedColor.ref("color:Inherited")
					beginLabelStyleDescription = BeginLabelStyleDescription.create [
						labelFormat += FontFormat.ITALIC_LITERAL
						showIcon = false
						labelExpression = "service:superTypesLabel"
						labelColor = SystemColor.extraRef("color:black")
					]
					centerLabelStyleDescription = CenterLabelStyleDescription.create [
						showIcon = false
						labelColor = SystemColor.extraRef("color:black")
					]
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
			style = EdgeStyleDescription.create [
				sourceArrow = EdgeArrows.INPUT_ARROW_LITERAL
				routingStyle = EdgeRouting.MANHATTAN_LITERAL
				strokeColor = SystemColor.extraRef("color:black")
				beginLabelStyleDescription = BeginLabelStyleDescription.create [
					showIcon = false
					labelExpression = "service:renderEOpposite"
					labelColor = SystemColor.extraRef("color:black")
				]
				endLabelStyleDescription = EndLabelStyleDescription.create [
					showIcon = false
					labelExpression = "service:render"
					labelColor = SystemColor.extraRef("color:black")
				]
			]
		]
		toolSections += createExistingElementsTools
		toolSections += createClassifierTools
		toolSections += createFeatureTools
		toolSections += createRelationTools
		toolSections += createReconnectTools
		toolSections += createDirectEditTools
		toolSections += createHelpTools
		toolSections += createDynamicTools
	}

	def createExistingElementsTools() {
		ToolSection.create("Existing Elements") [
			ownedTools += PopupMenu.createAs(Ns.menu, "Generate") [
				menuItemDescription += OperationAction.createAs(Ns.operation, " All") [
					precondition = '''OrderedSet{views.target}.eInverse().eContainerOrSelf(genmodel::GenModel)->asSet()->size() > 0'''.trimAql
					icon = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/GenModel.gif"
					view = ContainerViewVariable.create("views")
					operation = ExternalJavaAction.create("Generate All") [
						id = "org.eclipse.emf.ecoretools.design.action.generateAllID"
						parameters += ExternalJavaActionParameter.create [
							name = "genmodels"
							value = '''OrderedSet{views.target}.eInverse().eContainerOrSelf(genmodel::GenModel)->asSet()'''.trimAql
						]
						parameters += ExternalJavaActionParameter.create [
							name = "scope"
							value = "model, edit, editor, tests"
						]
					]
				]
				menuItemDescription += OperationAction.createAs(Ns.operation, "Model Code") [
					precondition = '''OrderedSet{views.target}.eInverse().eContainerOrSelf(genmodel::GenModel)->asSet()->select(m | m.modelDirectory.size() > 0)->size() > 0'''.trimAql
					icon = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/GenModel.gif"
					view = ContainerViewVariable.create("views")
					operation = ExternalJavaAction.create("Generate All") [
						id = "org.eclipse.emf.ecoretools.design.action.generateAllID"
						parameters += ExternalJavaActionParameter.create [
							name = "genmodels"
							value = '''OrderedSet{views.target}.eInverse().eContainerOrSelf(genmodel::GenModel)->asSet()'''.trimAql
						]
						parameters += ExternalJavaActionParameter.create [
							name = "scope"
							value = "model"
						]
					]
				]
				menuItemDescription += OperationAction.createAs(Ns.operation, "Edit Code") [
					precondition = '''OrderedSet{views.target}.eInverse().eContainerOrSelf(genmodel::GenModel)->asSet()->select(m | m.editDirectory.size() > 0)->size() > 0'''.trimAql
					icon = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/GenModel.gif"
					view = ContainerViewVariable.create("views")
					operation = ExternalJavaAction.create("Generate All") [
						id = "org.eclipse.emf.ecoretools.design.action.generateAllID"
						parameters += ExternalJavaActionParameter.create [
							name = "genmodels"
							value = '''OrderedSet{views.target}.eInverse().eContainerOrSelf(genmodel::GenModel)->asSet()'''.trimAql
						]
						parameters += ExternalJavaActionParameter.create [
							name = "scope"
							value = "edit"
						]
					]
				]
				menuItemDescription += OperationAction.createAs(Ns.operation, "Editor Code") [
					precondition = '''OrderedSet{views.target}.eInverse().eContainerOrSelf(genmodel::GenModel)->asSet()->select(m | m.editorDirectory.size() > 0)->size() > 0'''.trimAql
					icon = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/GenModel.gif"
					view = ContainerViewVariable.create("views")
					operation = ExternalJavaAction.create("Generate All") [
						id = "org.eclipse.emf.ecoretools.design.action.generateAllID"
						parameters += ExternalJavaActionParameter.create [
							name = "genmodels"
							value = '''OrderedSet{views.target}.eInverse().eContainerOrSelf(genmodel::GenModel)->asSet()'''.trimAql
						]
						parameters += ExternalJavaActionParameter.create [
							name = "scope"
							value = "editor"
						]
					]
				]
				menuItemDescription += OperationAction.createAs(Ns.operation, "Tests Code") [
					precondition = '''OrderedSet{views.target}.eInverse().eContainerOrSelf(genmodel::GenModel)->asSet()->select(m | m.testsDirectory.size() > 0)->size() > 0'''.trimAql
					icon = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/GenModel.gif"
					view = ContainerViewVariable.create("views")
					operation = ExternalJavaAction.create("Generate All") [
						id = "org.eclipse.emf.ecoretools.design.action.generateAllID"
						parameters += ExternalJavaActionParameter.create [
							name = "genmodels"
							value = '''OrderedSet{views.target}.eInverse().eContainerOrSelf(genmodel::GenModel)->asSet()'''.trimAql
						]
						parameters += ExternalJavaActionParameter.create [
							name = "scope"
							value = "tests"
						]
					]
				]
			]
			ownedTools += PopupMenu.createAs(Ns.menu, "CDO Native") [
				precondition = '''self.hasCDOBundle()'''.trimAql
				menuItemDescription += OperationAction.createAs(Ns.operation, "Enable support") [
					precondition = '''OrderedSet{views.target}.eInverse().eContainerOrSelf(genmodel::GenModel)->asSet()->size() > 0'''.trimAql
					view = ContainerViewVariable.create("views")
					operation = ExternalJavaAction.create("OpenConfirmationDialog") [
						id = "org.eclipse.emf.ecoretools.design.action.openConfirmationDialogID"
						subModelOperations += '''self.enableCDOGen(OrderedSet{views->filter(viewpoint::DSemanticDecorator).target}.eInverse().eContainerOrSelf(genmodel::GenModel)->asSet())'''.trimAql.toOperation
						parameters += ExternalJavaActionParameter.create [
							name = "message"
							value = "The selected generator model will be updated:\n\nSet Feature Delegation = Reflective\nSet Root Extends Class = org.eclipse.emf.internal.cdo.CDOObjectImpl\nSet Root Extends Interface = org.eclipse.emf.cdo.CDOObject\nAdded Model Plugin Variables = CDO=org.eclipse.emf.cdo \nCreated CDO.MF marker file\n\nYou need to regenerate the code to make these changes effective. \n"
						]
						parameters += ExternalJavaActionParameter.create [
							name = "title"
							value = "The selected generator model will be updated:\n\nSet Feature Delegation = Reflective\nSet Root Extends Class = org.eclipse.emf.internal.cdo.CDOObjectImpl\nSet Root Extends Interface = org.eclipse.emf.cdo.CDOObject\nAdd Model Plugin Variables = CDO=org.eclipse.emf.cdo \nCreate CDO.MF marker file\n\nYou need to regenerate the code to make these changes effective. "
						]
					]
				]
				menuItemDescription += OperationAction.createAs(Ns.operation, "Disable support") [
					precondition = '''OrderedSet{views.target}.eInverse().eContainerOrSelf(genmodel::GenModel)->asSet()->size() > 0'''.trimAql
					view = ContainerViewVariable.create("views")
					operation = ExternalJavaAction.create("OpenConfirmationDialog") [
						id = "org.eclipse.emf.ecoretools.design.action.openConfirmationDialogID"
						subModelOperations += '''self.disableCDOGen(OrderedSet{views->filter(viewpoint::DSemanticDecorator).target}.eInverse().eContainerOrSelf(genmodel::GenModel)->asSet())'''.trimAql.toOperation
						parameters += ExternalJavaActionParameter.create [
							name = "message"
							value = "The selected generator model will be updated:..."
						]
						parameters += ExternalJavaActionParameter.create [
							name = "title"
							value = "Disable CDO Native support in .genmodel ?"
						]
					]
				]
			]
			ownedTools += SelectionWizardDescription.createAs(Ns.operation, "Add") [
				precondition = '''container.oclIsKindOf(ecore::EPackage)'''.trimAql
				forceRefresh = true
				candidatesExpression = '''self.getValidsForDiagram(containerView)->asSet() - diagram.getDisplayedEClassifiers()'''.trimAql
				multiple = true
				tree = true
				rootExpression = "service:rootEPackages"
				childrenExpression = "feature:eContents"
				iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/etools16/search.gif"
				windowTitle = "Select element to add in diagram"
				element = ElementSelectVariable.create("element")
				containerView = ContainerViewVariable.create("containerView")
				container = SelectContainerVariable.create("container")
				operation = For.create [
					expression = "var:element"
					subModelOperations += ChangeContext.create [
						browseExpression = "service:markForAutosize"
						subModelOperations += If.create [
							conditionExpression = "service:isEClass"
							subModelOperations += CreateView.create [
								containerViewExpression = "var:containerView"
								mapping = ContainerMapping.localRef(Ns.node, "EC EClass")
							]
						]
						subModelOperations += If.create [
							conditionExpression = "service:isEDataType"
							subModelOperations += CreateView.create [
								containerViewExpression = "var:containerView"
								mapping = ContainerMapping.localRef(Ns.node, "EC EDataType")
							]
						]
						subModelOperations += If.create [
							conditionExpression = "service:isEEnum"
							subModelOperations += CreateView.create [
								containerViewExpression = "var:containerView"
								mapping = ContainerMapping.localRef(Ns.node, "EC EEnum")
							]
						]
					]
				]
			]
			ownedTools += ToolDescription.createAs(Ns.operation, "RemoveExistingElements") [
				label = "Remove"
				forceRefresh = true
				iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/etools16/search.gif"
				element = ElementVariable.create("element")
				elementView = ElementViewVariable.create("elementView")
				operation = ChangeContext.create [
					browseExpression = "var:elementView"
					subModelOperations += DeleteView.create
				]
			]
			ownedTools += ContainerDropDescription.createAs(Ns.drop, "External EClass from treeview") [
				forceRefresh = true
				dragSource = DragSource.PROJECT_EXPLORER_LITERAL
				oldContainer = DropContainerVariable.create("oldSemanticContainer")
				newContainer = DropContainerVariable.create("newSemanticContainer")
				element = ElementDropVariable.create("element")
				newViewContainer = ContainerViewVariable.create("newContainerView")
				operation = ChangeContext.create [
					browseExpression = "var:element"
					subModelOperations += ChangeContext.create [
						browseExpression = "service:markForAutosize"
						subModelOperations += If.create [
							conditionExpression = "service:isEClass"
							subModelOperations += CreateView.create [
								containerViewExpression = "var:newContainerView"
								mapping = ContainerMapping.localRef(Ns.node, "EC EClass")
							]
						]
						subModelOperations += If.create [
							conditionExpression = "service:isEDataType"
							subModelOperations += CreateView.create [
								containerViewExpression = "var:newContainerView"
								mapping = ContainerMapping.localRef(Ns.node, "EC EDataType")
							]
						]
						subModelOperations += If.create [
							conditionExpression = "service:isEEnum"
							subModelOperations += CreateView.create [
								containerViewExpression = "var:newContainerView"
								mapping = ContainerMapping.localRef(Ns.node, "EC EEnum")
							]
						]
						subModelOperations += If.create [
							conditionExpression = "service:isEPackage"
							subModelOperations += CreateView.create [
								containerViewExpression = "var:newContainerView"
								mapping = ContainerMapping.localRef(Ns.node, "Dropped Package")
							]
						]
					]
				]
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
				operation = For.create [
					expression = "var:selected"
					subModelOperations += ChangeContext.create [
						browseExpression = "service:markForAutosize"
						subModelOperations += If.create [
							conditionExpression = "service:isEClass"
							subModelOperations += CreateView.create [
								containerViewExpression = "var:diagram"
								mapping = ContainerMapping.localRef(Ns.node, "EC EClass")
							]
						]
						subModelOperations += If.create [
							conditionExpression = "service:isEDataType"
							subModelOperations += CreateView.create [
								containerViewExpression = "var:diagram"
								mapping = ContainerMapping.localRef(Ns.node, "EC EDataType")
							]
						]
						subModelOperations += If.create [
							conditionExpression = "service:isEEnum"
							subModelOperations += CreateView.create [
								containerViewExpression = "var:diagram"
								mapping = ContainerMapping.localRef(Ns.node, "EC EEnum")
							]
						]
					]
				]
			]
			ownedTools += ContainerDropDescription.createAs(Ns.drop, "Drop EStructuralFeature into EClass") [
				mappings += ContainerMapping.localRef(Ns.node, "Dropped Package")
				oldContainer = DropContainerVariable.create("oldSemanticContainer")
				newContainer = DropContainerVariable.create("newSemanticContainer")
				element = ElementDropVariable.create("element")
				newViewContainer = ContainerViewVariable.create("newContainerView")
				operation = ChangeContext.create [
					browseExpression = "var:newSemanticContainer"
					subModelOperations += If.create [
						conditionExpression = "service:isEOperation"
						subModelOperations += SetValue.create [
							featureName = "eOperations"
							valueExpression = "var:element"
						]
					]
					subModelOperations += If.create [
						conditionExpression = "service:isEStructuralFeature"
						subModelOperations += SetValue.create [
							featureName = "eStructuralFeatures"
							valueExpression = "var:element"
						]
					]
				]
			]
			ownedTools += PasteDescription.createAs(Ns.operation, "Paste Anything") [
				forceRefresh = true
				container = DropContainerVariable.create("container")
				containerView = ContainerViewVariable.create("containerView")
				copiedView = ElementViewVariable.create("copiedView")
				copiedElement = ElementVariable.create("copiedElement")
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
				operation = ChangeContext.create [
					browseExpression = "var:element"
					subModelOperations += For.create [
						expression = "service:getRelated(elementView,diagram)"
						subModelOperations += ChangeContext.create [
							browseExpression = "service:markForAutosize"
							subModelOperations += If.create [
								conditionExpression = "service:isEClass"
								subModelOperations += CreateView.create [
									containerViewExpression = "var:diagram"
									mapping = ContainerMapping.localRef(Ns.node, "EC EClass")
								]
							]
							subModelOperations += If.create [
								conditionExpression = "service:isEDataType"
								subModelOperations += CreateView.create [
									containerViewExpression = "var:diagram"
									mapping = ContainerMapping.localRef(Ns.node, "EC EDataType")
								]
							]
							subModelOperations += If.create [
								conditionExpression = "service:isEEnum"
								subModelOperations += CreateView.create [
									containerViewExpression = "var:diagram"
									mapping = ContainerMapping.localRef(Ns.node, "EC EEnum")
								]
							]
						]
					]
				]
			]
		]
	}


	def createClassifierTools() {
		ToolSection.create("Classifier") [
			ownedTools += ToolGroup.create("Classifier") [
				tools += ContainerCreationDescription.createAs(Ns.operation, "Class") [
					documentation = "M1+Y"
					precondition = '''(not container.oclIsKindOf(ecore::EClass)) or (container.abstract) or (container.interface)'''.trimAql
					containerMappings += ContainerMapping.localRef(Ns.node, "EC EClass")
					extraMappings += ContainerMapping.localRef(Ns.node, "EC EClass")
					variable = NodeCreationVariable.create("container")
					viewVariable = ContainerViewVariable.create("containerView")
					operation = ChangeContext.create [
						browseExpression = "var:container"
						subModelOperations += If.create [
							conditionExpression = "service:isEPackage"
							subModelOperations += CreateInstance.create [
								typeName = "ecore.EClass"
								referenceName = "eClassifiers"
								subModelOperations += SetValue.create [
									featureName = "name"
									valueExpression = ''' 'NewEClass'  + self.eContainer().eContents(ecore::EClass)->size() '''.trimAql
								]
							]
						]
						subModelOperations += If.create [
							conditionExpression = "service:isEClass"
							subModelOperations += SetValue.create [
								featureName = "abstract"
								valueExpression = "false"
							]
							subModelOperations += SetValue.create [
								featureName = "interface"
								valueExpression = "false"
							]
						]
					]
				]
				tools += ContainerCreationDescription.createAs(Ns.operation, "Abstract Class") [
					precondition = '''(not container.oclIsKindOf(ecore::EClass)) or (not container.abstract)'''.trimAql
					iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/EClass_abstract.gif"
					containerMappings += ContainerMapping.localRef(Ns.node, "EC EClass")
					extraMappings += ContainerMapping.localRef(Ns.node, "EC EClass")
					variable = NodeCreationVariable.create("container")
					viewVariable = ContainerViewVariable.create("containerView")
					operation = ChangeContext.create [
						browseExpression = "var:container"
						subModelOperations += If.create [
							conditionExpression = "service:isEPackage"
							subModelOperations += CreateInstance.create [
								typeName = "ecore.EClass"
								referenceName = "eClassifiers"
								subModelOperations += SetValue.create [
									featureName = "name"
									valueExpression = ''' 'NewAbstractClass' + self.eContainer().eContents(ecore::EClass)->size() '''.trimAql
								]
								subModelOperations += SetValue.create [
									featureName = "abstract"
									valueExpression = "true"
								]
							]
						]
						subModelOperations += If.create [
							conditionExpression = "service:isEClass"
							subModelOperations += SetValue.create [
								featureName = "abstract"
								valueExpression = "true"
							]
							subModelOperations += SetValue.create [
								featureName = "interface"
								valueExpression = "false"
							]
						]
					]
				]
				tools += ContainerCreationDescription.createAs(Ns.operation, "Interface") [
					precondition = '''(not container.oclIsKindOf(ecore::EClass)) or (not container.interface)'''.trimAql
					iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/EClass_interface.gif"
					containerMappings += ContainerMapping.localRef(Ns.node, "EC EClass")
					extraMappings += ContainerMapping.localRef(Ns.node, "EC EClass")
					variable = NodeCreationVariable.create("container")
					viewVariable = ContainerViewVariable.create("containerView")
					operation = ChangeContext.create [
						browseExpression = "var:container"
						subModelOperations += If.create [
							conditionExpression = "service:isEPackage"
							subModelOperations += CreateInstance.create [
								typeName = "ecore.EClass"
								referenceName = "eClassifiers"
								subModelOperations += SetValue.create [
									featureName = "name"
									valueExpression = ''' 'NewInterface' + self.eContainer().eContents(ecore::EClass)->size() '''.trimAql
								]
								subModelOperations += SetValue.create [
									featureName = "interface"
									valueExpression = "true"
								]
								subModelOperations += SetValue.create [
									featureName = "abstract"
									valueExpression = "true"
								]
							]
						]
						subModelOperations += If.create [
							conditionExpression = "service:isEClass"
							subModelOperations += SetValue.create [
								featureName = "abstract"
								valueExpression = "true"
							]
							subModelOperations += SetValue.create [
								featureName = "interface"
								valueExpression = "true"
							]
						]
					]
				]
			]
			ownedTools += ContainerCreationDescription.createAs(Ns.operation, "Datatype") [
				containerMappings += ContainerMapping.localRef(Ns.node, "EC EDataType")
				variable = NodeCreationVariable.create("container")
				viewVariable = ContainerViewVariable.create("containerView")
				operation = CreateInstance.create [
					typeName = "ecore.EDataType"
					referenceName = "eClassifiers"
					subModelOperations += SetValue.create [
						featureName = "name"
						valueExpression = ''' 'NewDataType' + self.eContainer().eContents(ecore::EDataType)->size() '''.trimAql
					]
					subModelOperations += SetValue.create [
						featureName = "instanceTypeName"
						valueExpression = ''' 'newDataType' + self.eContainer().eContents(ecore::EDataType)->size() '''.trimAql
					]
				]
			]
			ownedTools += ContainerCreationDescription.createAs(Ns.operation, "Enumeration") [
				containerMappings += ContainerMapping.localRef(Ns.node, "EC EEnum")
				variable = NodeCreationVariable.create("container")
				viewVariable = ContainerViewVariable.create("containerView")
				operation = CreateInstance.create [
					typeName = "ecore.EEnum"
					referenceName = "eClassifiers"
					subModelOperations += SetValue.create [
						featureName = "name"
						valueExpression = ''' 'NewEnum' + self.eContainer().eContents(ecore::EEnum)->size() '''.trimAql
					]
				]
			]
			ownedTools += DeleteElementDescription.createAs(Ns.del, "Delete EClass") [
				element = ElementDeleteVariable.create("element")
				elementView = ElementDeleteVariable.create("elementView")
				containerView = ContainerViewVariable.create("containerView")
				operation = ChangeContext.create [
					browseExpression = "var:self"
					subModelOperations += For.create [
						expression = "service:getInverseEReferences"
						subModelOperations += RemoveElement.create
					]
					subModelOperations += RemoveElement.create
				]
			]
			ownedTools += NodeCreationDescription.createAs(Ns.creation, "ETypeParameter") [
				nodeMappings += NodeMapping.localRef(Ns.node, "EC ETypeParameter")
				variable = NodeCreationVariable.create("container")
				viewVariable = ContainerViewVariable.create("containerView")
				operation = ChangeContext.create [
					browseExpression = "var:container"
					subModelOperations += CreateInstance.create [
						typeName = "ecore.ETypeParameter"
						referenceName = "eTypeParameters"
						subModelOperations += SetValue.create [
							featureName = "name"
							valueExpression = "T"
						]
					]
				]
			]
			ownedTools += DeleteElementDescription.createAs(Ns.del, "NoOp") [
				precondition = '''false'''.trimAql
				element = ElementDeleteVariable.create("element")
				elementView = ElementDeleteVariable.create("elementView")
				containerView = ContainerViewVariable.create("containerView")
				operation = "var:self".toOperation
			]
		]
	}


	def createFeatureTools() {
		ToolSection.create("Feature") [
			ownedTools += NodeCreationDescription.createAs(Ns.creation, "Literal") [
				nodeMappings += NodeMapping.localRef(Ns.node, "EC EEnumLiteral")
				variable = NodeCreationVariable.create("container")
				viewVariable = ContainerViewVariable.create("containerView")
				operation = CreateInstance.create [
					typeName = "ecore.EEnumLiteral"
					referenceName = "eLiterals"
					subModelOperations += SetValue.create [
						featureName = "name"
						valueExpression = '''('literal' +( self.eContainer().eContents(ecore::EEnumLiteral)->size() -1)).toUpper()'''.trimAql
					]
					subModelOperations += SetValue.create [
						featureName = "value"
						valueExpression = '''self.eContainer().eContents(ecore::EEnumLiteral)->size()-1'''.trimAql
					]
				]
			]
			ownedTools += NodeCreationDescription.createAs(Ns.creation, "Operation") [
				nodeMappings += NodeMapping.localRef(Ns.node, "Operation")
				variable = NodeCreationVariable.create("container")
				viewVariable = ContainerViewVariable.create("containerView")
				operation = CreateInstance.create [
					typeName = "ecore.EOperation"
					referenceName = "eOperations"
					subModelOperations += SetValue.create [
						featureName = "name"
						valueExpression = ''' 'newOperation' + self.eContainer().eContents(ecore::EOperation)->size() '''.trimAql
					]
				]
			]
			ownedTools += NodeCreationDescription.createAs(Ns.creation, "Attribute") [
				nodeMappings += NodeMapping.localRef(Ns.node, "EC EAttribute")
				variable = NodeCreationVariable.create("container")
				viewVariable = ContainerViewVariable.create("containerView")
				operation = CreateInstance.create [
					typeName = "ecore.EAttribute"
					referenceName = "eStructuralFeatures"
					subModelOperations += SetValue.create [
						featureName = "name"
						valueExpression = "newAttribute"
					]
				]
			]
			ownedTools += ContainerDropDescription.createAs(Ns.drop, "Drop attribute") [
				mappings += NodeMapping.localRef(Ns.node, "EC EAttribute")
				mappings += NodeMapping.localRef(Ns.node, "EC EReferenceNode")
				oldContainer = DropContainerVariable.create("oldSemanticContainer")
				newContainer = DropContainerVariable.create("newSemanticContainer")
				element = ElementDropVariable.create("element")
				newViewContainer = ContainerViewVariable.create("newContainerView")
				operation = ChangeContext.create [
					browseExpression = "var:newSemanticContainer"
					subModelOperations += SetValue.create [
						featureName = "eStructuralFeatures"
						valueExpression = "var:element"
					]
				]
			]
			ownedTools += ContainerDropDescription.createAs(Ns.drop, "Drop operation") [
				mappings += NodeMapping.localRef(Ns.node, "Operation")
				oldContainer = DropContainerVariable.create("oldSemanticContainer")
				newContainer = DropContainerVariable.create("newSemanticContainer")
				element = ElementDropVariable.create("element")
				newViewContainer = ContainerViewVariable.create("newContainerView")
				operation = ChangeContext.create [
					browseExpression = "var:newSemanticContainer"
					subModelOperations += SetValue.create [
						featureName = "eOperations"
						valueExpression = "var:element"
					]
				]
			]
		]
	}


	def createRelationTools() {
		ToolSection.create("Relation") [
			ownedTools += DiagramCreationDescription.createAs(Ns.operation, "New Package Entities") [
				titleExpression = ''' self.name + ' package entities' '''.trimAql
				diagramDescription = DiagramDescription.ref("EntitiesDiagram")
				operation = "var:self".toOperation
				containerViewVariable = ContainerViewVariable.create("containerView")
				representationNameVariable = NameVariable.create("diagramName")
			]
			ownedTools += EdgeCreationDescription.createAs(Ns.connect, "SuperType") [
				iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/Inheritance.gif"
				edgeMappings += EdgeMapping.localRef(Ns.edge, "EC ESupertypes")
				sourceVariable = SourceEdgeCreationVariable.create("source")
				targetVariable = TargetEdgeCreationVariable.create("target")
				sourceViewVariable = SourceEdgeViewCreationVariable.create("sourceView")
				targetViewVariable = TargetEdgeViewCreationVariable.create("targetView")
				operation = ChangeContext.create [
					browseExpression = "var:source"
					subModelOperations += SetValue.create [
						featureName = "eSuperTypes"
						valueExpression = "var:target"
						subModelOperations += "service:createTypeArgumentsIfNeeded(target)".toOperation
					]
				]
			]
			ownedTools += EdgeCreationDescription.createAs(Ns.connect, "Reference") [
				edgeMappings += EdgeMapping.localRef(Ns.edge, "EC_EReference")
				sourceVariable = SourceEdgeCreationVariable.create("source")
				targetVariable = TargetEdgeCreationVariable.create("target")
				sourceViewVariable = SourceEdgeViewCreationVariable.create("sourceView")
				targetViewVariable = TargetEdgeViewCreationVariable.create("targetView")
				operation = ChangeContext.create [
					browseExpression = "var:source"
					subModelOperations += CreateInstance.create [
						typeName = "ecore.EReference"
						referenceName = "eStructuralFeatures"
						subModelOperations += SetValue.create [
							featureName = "name"
							valueExpression = '''target.name.toLower()'''.trimAql
						]
						subModelOperations += "service:setEType(target)".toOperation
					]
				]
			]
			ownedTools += EdgeCreationDescription.createAs(Ns.connect, "Bi-directional Reference") [
				edgeMappings += EdgeMapping.localRef(Ns.edge, "Bi-directional EC_EReference ")
				sourceVariable = SourceEdgeCreationVariable.create("source")
				targetVariable = TargetEdgeCreationVariable.create("target")
				sourceViewVariable = SourceEdgeViewCreationVariable.create("sourceView")
				targetViewVariable = TargetEdgeViewCreationVariable.create("targetView")
				operation = ChangeContext.create [
					browseExpression = "var:target"
					subModelOperations += CreateInstance.create [
						typeName = "ecore.EReference"
						referenceName = "eStructuralFeatures"
						variableName = "instanceTarget"
						subModelOperations += SetValue.create [
							featureName = "eType"
							valueExpression = '''source'''.trimAql
						]
						subModelOperations += SetValue.create [
							featureName = "name"
							valueExpression = '''source.name.toLower()'''.trimAql
						]
					]
					subModelOperations += ChangeContext.create [
						browseExpression = "var:source"
						subModelOperations += CreateInstance.create [
							typeName = "ecore.EReference"
							referenceName = "eStructuralFeatures"
							variableName = "instanceSource"
							subModelOperations += SetValue.create [
								featureName = "eType"
								valueExpression = "var:target"
							]
							subModelOperations += SetValue.create [
								featureName = "name"
								valueExpression = '''target.name.toLower()'''.trimAql
							]
							subModelOperations += SetValue.create [
								featureName = "eOpposite"
								valueExpression = "var:instanceTarget"
							]
							subModelOperations += If.create [
								conditionExpression = '''source = target'''.trimAql
								subModelOperations += SetValue.create [
									featureName = "name"
									valueExpression = ''' target.name.toLower() + 'eOpposite' '''.trimAql
								]
							]
						]
						subModelOperations += ChangeContext.create [
							browseExpression = "var:instanceTarget"
							subModelOperations += SetValue.create [
								featureName = "eOpposite"
								valueExpression = "var:instanceSource"
							]
						]
					]
				]
			]
			ownedTools += EdgeCreationDescription.createAs(Ns.connect, "Composition") [
				edgeMappings += EdgeMapping.localRef(Ns.edge, "EC_EReference")
				sourceVariable = SourceEdgeCreationVariable.create("source")
				targetVariable = TargetEdgeCreationVariable.create("target")
				sourceViewVariable = SourceEdgeViewCreationVariable.create("sourceView")
				targetViewVariable = TargetEdgeViewCreationVariable.create("targetView")
				operation = ChangeContext.create [
					browseExpression = "var:source"
					subModelOperations += CreateInstance.create [
						typeName = "ecore.EReference"
						referenceName = "eStructuralFeatures"
						subModelOperations += SetValue.create [
							featureName = "name"
							valueExpression = '''target.name.toLower()'''.trimAql
						]
						subModelOperations += SetValue.create [
							featureName = "containment"
							valueExpression = "true"
						]
						subModelOperations += SetValue.create [
							featureName = "upperBound"
							valueExpression = "-1"
						]
						subModelOperations += "service:setEType(target)".toOperation
					]
				]
			]
			ownedTools += DeleteElementDescription.createAs(Ns.del, "Delete ESuperType") [
				element = ElementDeleteVariable.create("element")
				elementView = ElementDeleteVariable.create("elementView")
				containerView = ContainerViewVariable.create("containerView")
				operation = ChangeContext.create [
					browseExpression = "service:getEdgeSourceSemantic(elementView)"
					subModelOperations += Unset.create [
						featureName = "eSuperTypes"
						elementExpression = "service:getEdgeTargetSemantic(elementView)"
					]
				]
			]
		]
	}


	def createReconnectTools() {
		ToolSection.create("Reconnect") [
			ownedTools += ReconnectEdgeDescription.createAs(Ns.reconnect, "ReconnectEReference Source") [
				reconnectionKind = ReconnectionKind.RECONNECT_SOURCE_LITERAL
				source = SourceEdgeCreationVariable.create("source")
				target = TargetEdgeCreationVariable.create("target")
				sourceView = SourceEdgeViewCreationVariable.create("sourceView")
				targetView = TargetEdgeViewCreationVariable.create("targetView")
				element = ElementSelectVariable.create("element")
				operation = ChangeContext.create [
					browseExpression = "var:element"
					subModelOperations += "service:reconnectEReferenceSource(target)".toOperation
				]
				edgeView = ElementSelectVariable.create("edgeView")
			]
			ownedTools += ReconnectEdgeDescription.createAs(Ns.reconnect, "ReconnectEReference Target") [
				source = SourceEdgeCreationVariable.create("source")
				target = TargetEdgeCreationVariable.create("target")
				sourceView = SourceEdgeViewCreationVariable.create("sourceView")
				targetView = TargetEdgeViewCreationVariable.create("targetView")
				element = ElementSelectVariable.create("element")
				operation = ChangeContext.create [
					browseExpression = "var:element"
					subModelOperations += "service:reconnectEReferenceTarget(target)".toOperation
				]
				edgeView = ElementSelectVariable.create("edgeView")
			]
			ownedTools += ReconnectEdgeDescription.createAs(Ns.reconnect, "ReconnectESupertypeSource") [
				reconnectionKind = ReconnectionKind.RECONNECT_SOURCE_LITERAL
				source = SourceEdgeCreationVariable.create("source")
				target = TargetEdgeCreationVariable.create("target")
				sourceView = SourceEdgeViewCreationVariable.create("sourceView")
				targetView = TargetEdgeViewCreationVariable.create("targetView")
				element = ElementSelectVariable.create("element")
				operation = ChangeContext.create [
					browseExpression = "var:element"
					subModelOperations += '''self.reconnectESuperTypeSource(target,source,otherEnd,edgeView,sourceView)'''.trimAql.toOperation
				]
				edgeView = ElementSelectVariable.create("edgeView")
			]
			ownedTools += ReconnectEdgeDescription.createAs(Ns.reconnect, "ReconnectESupertypeTarget") [
				source = SourceEdgeCreationVariable.create("source")
				target = TargetEdgeCreationVariable.create("target")
				sourceView = SourceEdgeViewCreationVariable.create("sourceView")
				targetView = TargetEdgeViewCreationVariable.create("targetView")
				element = ElementSelectVariable.create("element")
				operation = ChangeContext.create [
					browseExpression = "var:element"
					subModelOperations += '''self.reconnectESuperTypeTarget(target,source,otherEnd,edgeView,sourceView)'''.trimAql.toOperation
				]
				edgeView = ElementSelectVariable.create("edgeView")
			]
			ownedTools += ReconnectEdgeDescription.createAs(Ns.reconnect, "ReconnectBiDirectionnalEReference Source") [
				reconnectionKind = ReconnectionKind.RECONNECT_SOURCE_LITERAL
				source = SourceEdgeCreationVariable.create("source")
				target = TargetEdgeCreationVariable.create("target")
				sourceView = SourceEdgeViewCreationVariable.create("sourceView")
				targetView = TargetEdgeViewCreationVariable.create("targetView")
				element = ElementSelectVariable.create("element")
				operation = ChangeContext.create [
					browseExpression = "var:target"
					subModelOperations += CreateInstance.create [
						typeName = "ecore.EReference"
						referenceName = "eStructuralFeatures"
						variableName = "newSource"
						subModelOperations += SetValue.create [
							featureName = "name"
							valueExpression = '''element.name'''.trimAql
						]
						subModelOperations += SetValue.create [
							featureName = "eType"
							valueExpression = '''element.eType'''.trimAql
						]
						subModelOperations += SetValue.create [
							featureName = "eOpposite"
							valueExpression = '''element.eOpposite'''.trimAql
						]
					]
					subModelOperations += ChangeContext.create [
						browseExpression = '''element.eOpposite'''.trimAql
						subModelOperations += SetValue.create [
							featureName = "eType"
							valueExpression = "var:target"
						]
						subModelOperations += SetValue.create [
							featureName = "eOpposite"
							valueExpression = '''newSource'''.trimAql
						]
					]
					subModelOperations += ChangeContext.create [
						browseExpression = "var:element"
						subModelOperations += RemoveElement.create
					]
				]
				edgeView = ElementSelectVariable.create("edgeView")
			]
			ownedTools += ReconnectEdgeDescription.createAs(Ns.reconnect, "ReconnectBiDirectionnalEReference Target") [
				source = SourceEdgeCreationVariable.create("source")
				target = TargetEdgeCreationVariable.create("target")
				sourceView = SourceEdgeViewCreationVariable.create("sourceView")
				targetView = TargetEdgeViewCreationVariable.create("targetView")
				element = ElementSelectVariable.create("element")
				operation = ChangeContext.create [
					browseExpression = "var:target"
					subModelOperations += CreateInstance.create [
						typeName = "ecore.EReference"
						referenceName = "eStructuralFeatures"
						variableName = "newTarget"
						subModelOperations += SetValue.create [
							featureName = "name"
							valueExpression = '''element.eOpposite.name'''.trimAql
						]
						subModelOperations += SetValue.create [
							featureName = "eType"
							valueExpression = '''element.eOpposite.eType'''.trimAql
						]
						subModelOperations += SetValue.create [
							featureName = "eOpposite"
							valueExpression = "var:element"
						]
					]
					subModelOperations += ChangeContext.create [
						browseExpression = '''element.eOpposite'''.trimAql
						subModelOperations += RemoveElement.create
					]
					subModelOperations += ChangeContext.create [
						browseExpression = "var:element"
						subModelOperations += SetValue.create [
							featureName = "eType"
							valueExpression = "var:target"
						]
						subModelOperations += SetValue.create [
							featureName = "eOpposite"
							valueExpression = "var:newTarget"
						]
					]
				]
				edgeView = ElementSelectVariable.create("edgeView")
			]
		]
	}


	def createDirectEditTools() {
		ToolSection.create("Direct Edit") [
			ownedTools += DirectEditLabel.createAs(Ns.operation, "Edit Name with CamelCase") [
				mask = "{0}"
				operation = SetValue.create [
					featureName = "name"
					valueExpression = "service:toCamelCase(arg0)"
				]
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
				mappings += ContainerMapping.localRef(Ns.node, "EC EClass")
				mappings += NodeMapping.localRef(Ns.node, "EC EAttribute")
				mappings += NodeMapping.localRef(Ns.node, "Operation")
				mappings += ContainerMapping.localRef(Ns.node, "EC EDataType")
				mappings += ContainerMapping.localRef(Ns.node, "EC EEnum")
				mappings += NodeMapping.localRef(Ns.node, "EC EEnumLiteral")
				mappings += NodeMapping.localRef(Ns.node, "EC EReferenceNode")
				mappings += ContainerMapping.localRef(Ns.node, "Dropped Package")
				element = ElementDoubleClickVariable.create("element")
				elementView = ElementDoubleClickVariable.create("elementView")
				operation = ChangeContext.create [
					browseExpression = "var:element"
					subModelOperations += DialogModelOperation.create [
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
				]
			]
			ownedTools += DirectEditLabel.createAs(Ns.operation, "InstanceClassName") [
				documentation = "- \"name\" : change the name of the operation"
				forceRefresh = true
				mask = "{0}"
				operation = SetValue.create [
					featureName = "instanceClassName"
					valueExpression = "var:arg0"
				]
			]
			ownedTools += DirectEditLabel.createAs(Ns.operation, "Edit Name no CamelCase") [
				mask = "{0}"
				operation = SetValue.create [
					featureName = "name"
					valueExpression = "var:arg0"
				]
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
				label = "Open User Guide"
				view = ContainerViewVariable.create("views")
				operation = ExternalJavaAction.create("Open Entities User Guide Action") [
					id = "org.eclipse.sirius.ui.business.api.action.openHelpSection"
					parameters += ExternalJavaActionParameter.create [
						name = "href"
						value = "/org.eclipse.emf.ecoretools.doc/doc/EcoreTools User Manual.html#EntitiesDiagramEditor"
					]
				]
			]
		]
	}


	def createDynamicTools() {
		ToolSection.create("Dynamic") [
			ownedTools += ToolDescription.createAs(Ns.operation, "Dynamic instance") [
				precondition = "service:isEClass"
				iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/DynamicInstance.gif"
				element = ElementVariable.create("element")
				elementView = ElementViewVariable.create("elementView")
				operation = ExternalJavaAction.create("Create dynamic instance of a specified EClass") [
					id = "org.eclipse.emf.ecoretools.design.action.createDynamicInstanceActionID"
					parameters += ExternalJavaActionParameter.create [
						name = "eClass"
						value = "var:element"
					]
				]
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
				style = FlatContainerStyleDescription.create [
					arcWidth = 1
					arcHeight = 1
					borderSizeComputationExpression = "1"
					labelExpression = '''self.name'''.trimAql
					labelAlignment = LabelAlignment.LEFT
					widthComputationExpression = "24"
					heightComputationExpression = "16"
					backgroundStyle = BackgroundStyle.LIQUID_LITERAL
					borderColor = UserFixedColor.ref("color:Dark EPackage")
					labelColor = SystemColor.extraRef("color:black")
					backgroundColor = SystemColor.extraRef("color:white")
					foregroundColor = UserFixedColor.ref("color:EPackage")
					labelBorderStyle = Environment.extraRef("$0").labelBorderStyles.labelBorderStyleDescriptions.get(0)
				]
			]
			toolSections += createPackageTools
		]
	}

	def createPackageTools() {
		ToolSection.create("Package") [
			ownedTools += ContainerCreationDescription.createAs(Ns.operation, "Package") [
				containerMappings += ContainerMapping.localRef(Ns.node, "Dropped Package")
				variable = NodeCreationVariable.create("container")
				viewVariable = ContainerViewVariable.create("containerView")
				operation = CreateInstance.create [
					typeName = "ecore.EPackage"
					referenceName = "eSubpackages"
					variableName = "newPackage"
					subModelOperations += ChangeContext.create [
						browseExpression = "var:newPackage"
						subModelOperations += SetValue.create [
							featureName = "name"
							valueExpression = ''' 'newPackage' + self.eContainer().eContents(ecore::EPackage)->size() '''.trimAql
						]
					]
				]
			]
			ownedTools += ContainerDropDescription.createAs(Ns.drop, "Drop EClassifier into EPackage") [
				mappings += ContainerMapping.localRef(Ns.node, "EC EClass")
				mappings += ContainerMapping.localRef(Ns.node, "EC EDataType")
				mappings += ContainerMapping.localRef(Ns.node, "EC EEnum")
				mappings += ContainerMapping.localRef(Ns.node, "EC External EClasses")
				oldContainer = DropContainerVariable.create("oldSemanticContainer")
				newContainer = DropContainerVariable.create("newSemanticContainer")
				element = ElementDropVariable.create("element")
				newViewContainer = ContainerViewVariable.create("newContainerView")
				operation = ChangeContext.create [
					browseExpression = "var:newSemanticContainer"
					subModelOperations += SetValue.create [
						featureName = "eClassifiers"
						valueExpression = "var:element"
					]
				]
			]
			ownedTools += ContainerDropDescription.createAs(Ns.drop, "Drop EPackage into EPackage") [
				dragSource = DragSource.BOTH_LITERAL
				mappings += ContainerMapping.localRef(Ns.node, "Dropped Package")
				oldContainer = DropContainerVariable.create("oldSemanticContainer")
				newContainer = DropContainerVariable.create("newSemanticContainer")
				element = ElementDropVariable.create("element")
				newViewContainer = ContainerViewVariable.create("newContainerView")
				operation = ChangeContext.create [
					browseExpression = "var:newSemanticContainer"
					subModelOperations += SetValue.create [
						featureName = "eSubpackages"
						valueExpression = "var:element"
						subModelOperations += CreateView.create [
							containerViewExpression = "var:newContainerView"
							mapping = ContainerMapping.localRef(Ns.node, "Dropped Package")
						]
					]
				]
			]
		]
	}


	def createDocumentationLayer() {
		AdditionalLayer.create("Documentation") [
			customization = Customization.create [
				vsmElementCustomizations += VSMElementCustomization.create [
					predicateExpression = "service:hasNoDocAnnotation"
					featureCustomizations += EReferenceCustomization.create [
						referenceName = "labelColor"
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram")[ ((it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").style as FlatContainerStyleDescription) ]
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram")[ ((it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").conditionnalStyles.get(1).style as FlatContainerStyleDescription) ]
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram")[ ((it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").conditionnalStyles.get(0).style as FlatContainerStyleDescription) ]
						appliedOn += CenterLabelStyleDescription.ref("EntitiesDiagram")[ (it as DiagramDescription).defaultLayer.edgeMappings.at("EC_EReference").style.centerLabelStyleDescription ]
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram")[ ((it as DiagramDescription).defaultLayer.containerMappings.at("EC EDataType").style as FlatContainerStyleDescription) ]
						value = SystemColor.extraRef("color:red")
					]
					featureCustomizations += EReferenceCustomization.create [
						referenceName = "borderColor"
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram")[ ((it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").style as FlatContainerStyleDescription) ]
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram")[ ((it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").conditionnalStyles.get(1).style as FlatContainerStyleDescription) ]
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram")[ ((it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").conditionnalStyles.get(0).style as FlatContainerStyleDescription) ]
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram")[ ((it as DiagramDescription).defaultLayer.containerMappings.at("EC EDataType").style as FlatContainerStyleDescription) ]
						value = SystemColor.extraRef("color:red")
					]
					featureCustomizations += EReferenceCustomization.create [
						referenceName = "strokeColor"
						appliedOn += EdgeStyleDescription.ref("EntitiesDiagram")[ (it as DiagramDescription).defaultLayer.edgeMappings.at("Bi-directional EC_EReference ").style ]
						appliedOn += EdgeStyleDescription.ref("EntitiesDiagram")[ (it as DiagramDescription).defaultLayer.edgeMappings.at("EC_EReference").style ]
						value = SystemColor.extraRef("color:red")
					]
				]
			]
			nodeMappings += NodeMapping.createAs(Ns.node, "EC Doc Annotation") [
				semanticCandidatesExpression = "service:getVisibleDocAnnotations(diagram)"
				domainClass = "ecore.EStringToStringMapEntry"
				labelDirectEdit = DirectEditLabel.localRef(Ns.operation, "Edit Detail")
				style = SquareDescription.create [
					borderSizeComputationExpression = "1"
					showIcon = false
					labelExpression = "feature:value"
					labelAlignment = LabelAlignment.LEFT
					sizeComputationExpression = "1"
					labelPosition = LabelPosition.NODE_LITERAL
					resizeKind = ResizeKind.NSEW_LITERAL
					width = 12
					height = 10
					borderColor = SystemColor.extraRef("color:gray")
					labelColor = SystemColor.extraRef("color:black")
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
				style = EdgeStyleDescription.create [
					lineStyle = LineStyle.DOT_LITERAL
					strokeColor = SystemColor.extraRef("color:black")
					centerLabelStyleDescription = CenterLabelStyleDescription.create [
						showIcon = false
						labelColor = SystemColor.extraRef("color:black")
					]
				]
			]
			toolSections += createDocumentationTools
		]
	}

	def createDocumentationTools() {
		ToolSection.create("Documentation") [
			ownedTools += NodeCreationDescription.createAs(Ns.creation, "Doc Annotation") [
				iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/EAnnotation_24.gif"
				nodeMappings += NodeMapping.localRef(Ns.node, "EC Doc Annotation")
				extraMappings += ContainerMapping.localRef(Ns.node, "EC EClass")
				extraMappings += ContainerMapping.localRef(Ns.node, "EC EDataType")
				extraMappings += ContainerMapping.localRef(Ns.node, "EC EEnum")
				extraMappings += ContainerMapping.localRef(Ns.node, "Dropped Package")
				variable = NodeCreationVariable.create("container")
				viewVariable = ContainerViewVariable.create("containerView")
				operation = ChangeContext.create [
					browseExpression = "var:container"
					subModelOperations += If.create [
						conditionExpression = '''self.eAnnotations->select(a | a.source = 'http://www.eclipse.org/emf/2002/GenModel')->size() = 0'''.trimAql
						subModelOperations += CreateInstance.create [
							typeName = "ecore.EAnnotation"
							referenceName = "eAnnotations"
							subModelOperations += SetValue.create [
								featureName = "source"
								valueExpression = ''' 'http://www.eclipse.org/emf/2002/GenModel' '''.trimAql
							]
						]
					]
					subModelOperations += ChangeContext.create [
						browseExpression = '''self.eAnnotations->select(a | a.source = 'http://www.eclipse.org/emf/2002/GenModel')->asSequence()->first()'''.trimAql
						subModelOperations += If.create [
							conditionExpression = '''self.details->select(a | a.key = 'documentation')->size() = 0'''.trimAql
							subModelOperations += CreateInstance.create [
								typeName = "ecore.EStringToStringMapEntry"
								referenceName = "details"
								subModelOperations += SetValue.create [
									featureName = "key"
									valueExpression = ''' 'documentation' '''.trimAql
								]
							]
						]
						subModelOperations += ChangeContext.create [
							browseExpression = '''self.details->select(a | a.key = 'documentation')->asSequence()->first()'''.trimAql
							subModelOperations += SetValue.create [
								featureName = "value"
								valueExpression = ''' 'New documentation note' '''.trimAql
							]
						]
					]
				]
			]
			ownedTools += DirectEditLabel.createAs(Ns.operation, "Edit Detail") [
				mask = "{0}"
				operation = SetValue.create [
					featureName = "value"
					valueExpression = "var:arg0"
				]
			]
			ownedTools += EdgeCreationDescription.createAs(Ns.connect, "Doc Assignment") [
				forceRefresh = true
				iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/AnnotationLink.gif"
				edgeMappings += EdgeMapping.localRef(Ns.edge, "EC Doc Assignment")
				sourceVariable = SourceEdgeCreationVariable.create("source")
				targetVariable = TargetEdgeCreationVariable.create("target")
				sourceViewVariable = SourceEdgeViewCreationVariable.create("sourceView")
				targetViewVariable = TargetEdgeViewCreationVariable.create("targetView")
				operation = ChangeContext.create [
					browseExpression = '''source.eContainer(ecore::EAnnotation)'''.trimAql
					subModelOperations += MoveElement.create [
						newContainerExpression = "var:target"
						featureName = "eAnnotations"
					]
				]
			]
		]
	}


	def createValidationLayer() {
		AdditionalLayer.create("Validation") [
			activeByDefault = true
			customization = Customization.create [
				vsmElementCustomizations += VSMElementCustomization.create [
					predicateExpression = "service:hasError"
					featureCustomizations += EReferenceCustomization.create [
						referenceName = "labelColor"
						appliedOn += BundledImageDescription.ref("EntitiesDiagram")[ ((it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("EC EAttribute").style as BundledImageDescription) ]
						appliedOn += BundledImageDescription.ref("EntitiesDiagram")[ ((it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("Operation").style as BundledImageDescription) ]
						appliedOn += CenterLabelStyleDescription.ref("EntitiesDiagram")[ (it as DiagramDescription).defaultLayer.edgeMappings.at("EC_EReference").style.centerLabelStyleDescription ]
						appliedOn += CenterLabelStyleDescription.ref("EntitiesDiagram")[ (it as DiagramDescription).defaultLayer.edgeMappings.at("EC ESupertypes").style.centerLabelStyleDescription ]
						appliedOn += CenterLabelStyleDescription.ref("EntitiesDiagram")[ (it as DiagramDescription).defaultLayer.edgeMappings.at("EC ESupertypes").conditionnalStyles.get(0).style.centerLabelStyleDescription ]
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram")[ ((it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").conditionnalStyles.get(1).style as FlatContainerStyleDescription) ]
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram")[ ((it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").conditionnalStyles.get(0).style as FlatContainerStyleDescription) ]
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram")[ ((it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").style as FlatContainerStyleDescription) ]
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram")[ ((it as DiagramDescription).defaultLayer.containerMappings.at("EC EDataType").style as FlatContainerStyleDescription) ]
						value = SystemColor.extraRef("color:red")
					]
					featureCustomizations += EReferenceCustomization.create [
						referenceName = "borderColor"
						appliedOn += BundledImageDescription.ref("EntitiesDiagram")[ ((it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("EC EAttribute").style as BundledImageDescription) ]
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram")[ ((it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").style as FlatContainerStyleDescription) ]
						appliedOn += BundledImageDescription.ref("EntitiesDiagram")[ ((it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("Operation").style as BundledImageDescription) ]
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram")[ ((it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").conditionnalStyles.get(1).style as FlatContainerStyleDescription) ]
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram")[ ((it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").conditionnalStyles.get(0).style as FlatContainerStyleDescription) ]
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram")[ ((it as DiagramDescription).defaultLayer.containerMappings.at("EC EDataType").style as FlatContainerStyleDescription) ]
						value = SystemColor.extraRef("color:red")
					]
					featureCustomizations += EReferenceCustomization.create [
						referenceName = "strokeColor"
						appliedOn += EdgeStyleDescription.ref("EntitiesDiagram")[ (it as DiagramDescription).defaultLayer.edgeMappings.at("Bi-directional EC_EReference ").style ]
						appliedOn += EdgeStyleDescription.ref("EntitiesDiagram")[ (it as DiagramDescription).defaultLayer.edgeMappings.at("EC_EReference").style ]
						value = SystemColor.extraRef("color:red")
					]
				]
			]
		]
	}


	def createConstraintLayer() {
		AdditionalLayer.create("Constraint") [
			nodeMappings += NodeMapping.createAs(Ns.node, "EC Constraint Annotation") [
				semanticCandidatesExpression = "service:getVisibleConstraintsAnnotations(diagram)"
				domainClass = "ecore.EStringToStringMapEntry"
				labelDirectEdit = DirectEditLabel.localRef(Ns.operation, "Edit Detail")
				style = SquareDescription.create [
					borderSizeComputationExpression = "1"
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
				style = EdgeStyleDescription.create [
					lineStyle = LineStyle.DOT_LITERAL
					strokeColor = SystemColor.extraRef("color:dark_blue")
					centerLabelStyleDescription = CenterLabelStyleDescription.create [
						showIcon = false
						labelColor = SystemColor.extraRef("color:black")
					]
				]
			]
			toolSections += createConstraintsTools
		]
	}

	def createConstraintsTools() {
		ToolSection.create("Constraints") [
			ownedTools += NodeCreationDescription.createAs(Ns.creation, "Constraint") [
				iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/EAnnotation_24.gif"
				nodeMappings += NodeMapping.localRef(Ns.node, "EC Constraint Annotation")
				extraMappings += ContainerMapping.localRef(Ns.node, "EC EClass")
				extraMappings += ContainerMapping.localRef(Ns.node, "EC EDataType")
				extraMappings += ContainerMapping.localRef(Ns.node, "EC EEnum")
				extraMappings += ContainerMapping.localRef(Ns.node, "Dropped Package")
				variable = NodeCreationVariable.create("container")
				viewVariable = ContainerViewVariable.create("containerView")
				operation = ChangeContext.create [
					browseExpression = "var:container"
					subModelOperations += If.create [
						conditionExpression = '''self.eAnnotations->select(a | a.source = 'http://www.eclipse.org/emf/2002/Ecore')->size() = 0'''.trimAql
						subModelOperations += CreateInstance.create [
							typeName = "ecore.EAnnotation"
							referenceName = "eAnnotations"
							subModelOperations += SetValue.create [
								featureName = "source"
								valueExpression = ''' 'http://www.eclipse.org/emf/2002/Ecore' '''.trimAql
							]
						]
					]
					subModelOperations += ChangeContext.create [
						browseExpression = '''self.eAnnotations->select(a | a.source = 'http://www.eclipse.org/emf/2002/Ecore')->asSequence()->first()'''.trimAql
						subModelOperations += If.create [
							conditionExpression = '''self.details->select(a | a.key = 'constraints')->size() = 0'''.trimAql
							subModelOperations += CreateInstance.create [
								typeName = "ecore.EStringToStringMapEntry"
								referenceName = "details"
								subModelOperations += SetValue.create [
									featureName = "key"
									valueExpression = ''' 'constraints' '''.trimAql
								]
							]
						]
						subModelOperations += ChangeContext.create [
							browseExpression = '''self.details->select(a | a.key = 'constraints')->asSequence()->first()'''.trimAql
							subModelOperations += SetValue.create [
								featureName = "value"
								valueExpression = ''' 'Constraint1 Constraint2' '''.trimAql
							]
						]
					]
				]
			]
			ownedTools += EdgeCreationDescription.createAs(Ns.connect, "Constraint Assignment") [
				forceRefresh = true
				iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/AnnotationLink.gif"
				edgeMappings += EdgeMapping.localRef(Ns.edge, "EC Constraint Assignment")
				sourceVariable = SourceEdgeCreationVariable.create("source")
				targetVariable = TargetEdgeCreationVariable.create("target")
				sourceViewVariable = SourceEdgeViewCreationVariable.create("sourceView")
				targetViewVariable = TargetEdgeViewCreationVariable.create("targetView")
				operation = ChangeContext.create [
					browseExpression = '''source.eContainer(ecore::EAnnotation)'''.trimAql
					subModelOperations += MoveElement.create [
						newContainerExpression = "var:target"
						featureName = "eAnnotations"
					]
				]
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
				style = FlatContainerStyleDescription.create [
					arcWidth = 8
					arcHeight = 8
					borderSizeComputationExpression = "1"
					tooltipExpression = "service:renderTooltip"
					roundedCorner = true
					backgroundStyle = BackgroundStyle.LIQUID_LITERAL
					borderColor = SystemColor.extraRef("color:black")
					labelColor = SystemColor.extraRef("color:black")
					backgroundColor = SystemColor.extraRef("color:white")
					foregroundColor = UserFixedColor.ref("color:EClass")
				]
				conditionnalStyles += ConditionalContainerStyleDescription.create [
					predicateExpression = "feature:interface"
					style = FlatContainerStyleDescription.create [
						arcWidth = 8
						arcHeight = 8
						borderSizeComputationExpression = "1"
						labelFormat += FontFormat.ITALIC_LITERAL
						iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/EClass_interface.gif"
						tooltipExpression = "service:renderTooltip"
						roundedCorner = true
						backgroundStyle = BackgroundStyle.LIQUID_LITERAL
						borderColor = UserFixedColor.ref("color:Dark EClass")
						labelColor = SystemColor.extraRef("color:black")
						backgroundColor = SystemColor.extraRef("color:white")
						foregroundColor = UserFixedColor.ref("color:Abstract EClass")
					]
				]
				conditionnalStyles += ConditionalContainerStyleDescription.create [
					predicateExpression = "feature:abstract"
					style = FlatContainerStyleDescription.create [
						arcWidth = 8
						arcHeight = 8
						borderSizeComputationExpression = "1"
						labelFormat += FontFormat.ITALIC_LITERAL
						iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/EClass_abstract.gif"
						tooltipExpression = "service:renderTooltip"
						roundedCorner = true
						backgroundStyle = BackgroundStyle.LIQUID_LITERAL
						borderColor = UserFixedColor.ref("color:Dark EClass")
						labelColor = SystemColor.extraRef("color:black")
						backgroundColor = SystemColor.extraRef("color:white")
						foregroundColor = UserFixedColor.ref("color:Abstract EClass")
					]
				]
			]
		]
	}


	def createIconsPreviewLayer() {
		AdditionalLayer.create("Icons Preview") [
			icon = "/org.eclipse.emf.ecoretools.design/icons/full/etools16/image.gif"
			customization = Customization.create [
				vsmElementCustomizations += VSMElementCustomization.create [
					predicateExpression = '''self.oclIsKindOf(ecore::EClass) and self.eInverse(genmodel::GenClass) <> null'''.trimAql
					featureCustomizations += EAttributeCustomization.create [
						attributeName = "iconPath"
						value = '''self.eInverse(genmodel::GenClass).getEClassItemIconPath()->first()'''.trimAql
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram")[ ((it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").conditionnalStyles.get(1).style as FlatContainerStyleDescription) ]
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram")[ ((it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").conditionnalStyles.get(0).style as FlatContainerStyleDescription) ]
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram")[ ((it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").style as FlatContainerStyleDescription) ]
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram")[ ((it as DiagramDescription).additionalLayers.at("Related EClasses").containerMappings.at("EC External EClasses").conditionnalStyles.get(1).style as FlatContainerStyleDescription) ]
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram")[ ((it as DiagramDescription).additionalLayers.at("Related EClasses").containerMappings.at("EC External EClasses").conditionnalStyles.get(0).style as FlatContainerStyleDescription) ]
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram")[ ((it as DiagramDescription).additionalLayers.at("Related EClasses").containerMappings.at("EC External EClasses").style as FlatContainerStyleDescription) ]
					]
				]
			]
		]
	}

}