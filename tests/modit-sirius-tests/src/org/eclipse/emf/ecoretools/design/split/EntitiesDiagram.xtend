package org.eclipse.emf.ecoretools.design.split

import org.eclipse.emf.codegen.ecore.genmodel.GenModelPackage
import org.eclipse.emf.ecore.EcorePackage
import org.eclipse.sirius.diagram.BackgroundStyle
import org.eclipse.sirius.diagram.ContainerLayout
import org.eclipse.sirius.diagram.EdgeArrows
import org.eclipse.sirius.diagram.EdgeRouting
import org.eclipse.sirius.diagram.LabelPosition
import org.eclipse.sirius.diagram.LineStyle
import org.eclipse.sirius.diagram.ResizeKind
import org.eclipse.sirius.diagram.description.AdditionalLayer
import org.eclipse.sirius.diagram.description.ConditionalContainerStyleDescription
import org.eclipse.sirius.diagram.description.ConditionalEdgeStyleDescription
import org.eclipse.sirius.diagram.description.ConditionalNodeStyleDescription
import org.eclipse.sirius.diagram.description.ContainerMapping
import org.eclipse.sirius.diagram.description.DiagramDescription
import org.eclipse.sirius.diagram.description.EdgeMapping
import org.eclipse.sirius.diagram.description.Layer
import org.eclipse.sirius.diagram.description.NodeMapping
import org.eclipse.sirius.diagram.description.filter.CompositeFilterDescription
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
import org.eclipse.sirius.properties.ViewExtensionDescription
import org.eclipse.sirius.viewpoint.FontFormat
import org.eclipse.sirius.viewpoint.LabelAlignment
import org.eclipse.sirius.viewpoint.description.Customization
import org.eclipse.sirius.viewpoint.description.DecorationDescriptionsSet
import org.eclipse.sirius.viewpoint.description.EAttributeCustomization
import org.eclipse.sirius.viewpoint.description.EReferenceCustomization
import org.eclipse.sirius.viewpoint.description.Environment
import org.eclipse.sirius.viewpoint.description.Group
import org.eclipse.sirius.viewpoint.description.Position
import org.eclipse.sirius.viewpoint.description.SemanticBasedDecoration
import org.eclipse.sirius.viewpoint.description.UserFixedColor
import org.eclipse.sirius.viewpoint.description.VSMElementCustomization
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
import org.mypsycho.modit.emf.EModel
import static extension org.mypsycho.modit.emf.ModitModel.*

class EntitiesDiagram extends EModel.Part<DiagramDescription> {

	new(ToolDesign parent) {
		super(DiagramDescription, parent)
	}

	protected override initContent(DiagramDescription it) {
		documentation = "<html>\n<head>\n</head>\n<body>\n<p>Provides a class diagram to represent EClasses, EDatatypes, EAttributes and their relationships.</p>\n<br>\n<img src=\"/icons/full/wizban/entities.png\"/>\n</body>\n</html>\n\n\n"
		endUserDocumentation = "A class diagram to represent EClasses, EDatatypes, EAttributes and their relationships."
		name = "Entities"
		label = "Entities in a Class Diagram"
		titleExpression = "aql:self.name + ' class diagram'"
		domainClass = "ecore::EPackage"
		enablePopupBars = true
		dropDescriptions += ContainerDropDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.toolSections.get(0).ownedTools.at(ContainerDropDescription, "External EClass from treeview") ]
		dropDescriptions += ContainerDropDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).additionalLayers.at("Package").toolSections.head.ownedTools.at(ContainerDropDescription, "Drop EClassifier into EPackage") ]
		metamodel += EcorePackage.eINSTANCE
		metamodel += GenModelPackage.eINSTANCE
		pasteDescriptions += PasteDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.toolSections.get(0).ownedTools.at(PasteDescription, "Paste Anything") ]
		filters += CompositeFilterDescription.create [
			name = "Hide class content"
			filters += MappingFilter.create [
				mappings += NodeMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("EC EAttribute") ]
				mappings += NodeMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("Operation") ]
			]
		]
		filters += CompositeFilterDescription.create [
			name = "Hide generalizations"
			filters += MappingFilter.create [
				mappings += EdgeMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.edgeMappings.at("EC ESupertypes") ]
			]
		]
		filters += CompositeFilterDescription.create [
			name = "Hide indirect generalizations"
			filters += MappingFilter.create [
				viewConditionExpression = "aql:not self.oclAsType(diagram::DEdge).sourceNode.oclAsType(viewpoint::DSemanticDecorator).target.oclAsType(ecore::EClass).eSuperTypes->includes(self.oclAsType(diagram::DEdge).targetNode.oclAsType(viewpoint::DSemanticDecorator).target)"
				mappings += EdgeMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.edgeMappings.at("EC ESupertypes") ]
			]
		]
		filters += CompositeFilterDescription.create [
			name = "Hide references (edges)"
			filters += MappingFilter.create [
				mappings += EdgeMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.edgeMappings.at("EC_EReference") ]
				mappings += EdgeMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.edgeMappings.at("Bi-directional EC_EReference ") ]
			]
		]
		filters += CompositeFilterDescription.create [
			name = "Hide references (nodes)"
			filters += MappingFilter.create [
				mappings += NodeMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("EC EReferenceNode") ]
			]
		]
		filters += CompositeFilterDescription.create [
			name = "Hide inherited references (nodes)"
			filters += MappingFilter.create [
				viewConditionExpression = "aql:self.eContainer().oclAsType(viewpoint::DSemanticDecorator).target = self.oclAsType(viewpoint::DSemanticDecorator).target.eContainer()"
				mappings += NodeMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("EC EReferenceNode") ]
			]
		]
		filters += CompositeFilterDescription.create [
			name = "Hide derived features"
			filters += MappingFilter.create [
				semanticConditionExpression = "aql:not self.derived"
				mappings += EdgeMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.edgeMappings.at("EC_EReference") ]
				mappings += NodeMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("EC EAttribute") ]
				mappings += EdgeMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.edgeMappings.at("Bi-directional EC_EReference ") ]
				mappings += NodeMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("EC EReferenceNode") ]
			]
		]
		filters += CompositeFilterDescription.create [
			name = "Hide operations"
			filters += MappingFilter.create [
				semanticConditionExpression = ""
				mappings += NodeMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("Operation") ]
			]
		]
		validationSet = ValidationSet.create [
			ownedRules += ViewValidationRule.create [
				name = "Unused EClass"
				message = "aql:'The ' + self.target.oclAsType(ecore::EClass).name +' class is never used'"
				targets += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass") ]
				audits += RuleAudit.create [
					auditExpression = "aql:not self.target.oclAsType(ecore::EClass).eAllSuperTypes->including(self.target)->asSet().eInverse('eType')->isEmpty()"
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
			ownedRules += ViewValidationRule.create [
				name = "Too many superclasses"
				level = ERROR_LEVEL.ERROR_LITERAL
				message = "aql:'The ' + self.target.oclAsType(ecore::EClass).name +' class has more than 10 super types'"
				targets += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass") ]
				audits += RuleAudit.create [
					auditExpression = "aql:self.target.oclAsType(ecore::EClass).eAllSuperTypes->size() < 10"
				]
			]
		]
		diagramInitialisation = InitialOperation.create [
			firstModelOperations = ChangeContext.create [
				browseExpression = "service:openClassDiagramContextHelp"
			]
		]
		defaultLayer = Layer.create [
			name = "Default"
			nodeMappings += NodeMapping.create [
				name = "Empty Diagram"
				preconditionExpression = "aql:containerView.oclAsType(diagram::DDiagram).ownedDiagramElements.target->excluding(containerView.oclAsType(diagram::DSemanticDiagram).target)->size() = 0 and container.eClassifiers->size() > 0"
				semanticCandidatesExpression = "var:self"
				domainClass = "ecore.EPackage"
				deletionDescription = DeleteElementDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.toolSections.get(1).ownedTools.at(DeleteElementDescription, "NoOp") ]
				style = WorkspaceImageDescription.create [
					showIcon = false
					labelExpression = ""
					sizeComputationExpression = "-1"
					labelPosition = LabelPosition.NODE_LITERAL
					arcWidth = 1
					arcHeight = 1
					workspacePath = "/org.eclipse.emf.ecoretools.design/icons/full/back/empty.svg"
					borderColor = Environment.extraRef("$0").systemColors.entries.at("black")
					labelColor = Environment.extraRef("$0").systemColors.entries.at("black")
				]
			]
			edgeMappings += EdgeMapping.create [
				name = "EC_EReference"
				preconditionExpression = "service:noEOpposite"
				semanticCandidatesExpression = "service:getEReferencesToDisplay(diagram)"
				semanticElements = "var:self"
				synchronizationLock = true
				targetFinderExpression = "service:getEReferenceTarget"
				sourceFinderExpression = "feature:eContainer"
				domainClass = "ecore.EReference"
				useDomainElement = true
				labelDirectEdit = DirectEditLabel.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.toolSections.get(5).ownedTools.at(DirectEditLabel, "EReference Name") ]
				sourceMapping += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass") ]
				sourceMapping += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).additionalLayers.at("Related EClasses").containerMappings.at("EC External EClasses") ]
				targetMapping += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass") ]
				targetMapping += NodeMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").borderedNodeMappings.at("EC ETypeParameter") ]
				targetMapping += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).additionalLayers.at("Related EClasses").containerMappings.at("EC External EClasses") ]
				reconnections += ReconnectEdgeDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.toolSections.get(4).ownedTools.at(ReconnectEdgeDescription, "ReconnectEReference Source") ]
				reconnections += ReconnectEdgeDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.toolSections.get(4).ownedTools.at(ReconnectEdgeDescription, "ReconnectEReference Target") ]
				style = EdgeStyleDescription.create [
					routingStyle = EdgeRouting.MANHATTAN_LITERAL
					strokeColor = Environment.extraRef("$0").systemColors.entries.at("black")
					centerLabelStyleDescription = CenterLabelStyleDescription.create [
						showIcon = false
						labelExpression = "service:render"
						labelColor = Environment.extraRef("$0").systemColors.entries.at("black")
					]
					endLabelStyleDescription = EndLabelStyleDescription.create [
						labelSize = 6
						showIcon = false
						labelExpression = "service:eKeysLabel"
						labelColor = Environment.extraRef("$0").systemColors.entries.at("dark_blue")
					]
				]
			]
			edgeMappings += EdgeMapping.create [
				name = "EC ESupertypes"
				semanticCandidatesExpression = ""
				semanticElements = "var:self"
				synchronizationLock = true
				targetFinderExpression = "service:getDirectSuperTypesOrMostSpecificVisibleOnes(diagram)"
				deletionDescription = DeleteElementDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.toolSections.get(3).ownedTools.at(DeleteElementDescription, "Delete ESuperType") ]
				sourceMapping += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass") ]
				sourceMapping += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).additionalLayers.at("Related EClasses").containerMappings.at("EC External EClasses") ]
				targetMapping += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass") ]
				targetMapping += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).additionalLayers.at("Related EClasses").containerMappings.at("EC External EClasses") ]
				reconnections += ReconnectEdgeDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.toolSections.get(4).ownedTools.at(ReconnectEdgeDescription, "ReconnectESupertypeSource") ]
				reconnections += ReconnectEdgeDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.toolSections.get(4).ownedTools.at(ReconnectEdgeDescription, "ReconnectESupertypeTarget") ]
				style = EdgeStyleDescription.create [
					targetArrow = EdgeArrows.INPUT_CLOSED_ARROW_LITERAL
					routingStyle = EdgeRouting.TREE_LITERAL
					strokeColor = Environment.extraRef("$0").systemColors.entries.at("gray")
					beginLabelStyleDescription = BeginLabelStyleDescription.create [
						labelFormat += FontFormat.ITALIC_LITERAL
						showIcon = false
						labelExpression = "service:superTypesLabel"
						labelColor = Environment.extraRef("$0").systemColors.entries.at("black")
					]
					centerLabelStyleDescription = CenterLabelStyleDescription.create [
						showIcon = false
						labelColor = Environment.extraRef("$0").systemColors.entries.at("black")
					]
				]
				conditionnalStyles += ConditionalEdgeStyleDescription.create [
					predicateExpression = "service:targetIsInterface(view)"
					style = EdgeStyleDescription.create [
						lineStyle = LineStyle.DASH_LITERAL
						targetArrow = EdgeArrows.INPUT_CLOSED_ARROW_LITERAL
						routingStyle = EdgeRouting.TREE_LITERAL
						strokeColor = Environment.extraRef("$0").systemColors.entries.at("gray")
						beginLabelStyleDescription = BeginLabelStyleDescription.create [
							labelFormat += FontFormat.ITALIC_LITERAL
							showIcon = false
							labelExpression = "service:superTypesLabel"
							labelColor = Environment.extraRef("$0").systemColors.entries.at("black")
						]
						centerLabelStyleDescription = CenterLabelStyleDescription.create [
							showIcon = false
							labelColor = Environment.extraRef("$0").systemColors.entries.at("black")
						]
					]
				]
				conditionnalStyles += ConditionalEdgeStyleDescription.create [
					predicateExpression = "aql:not self.eSuperTypes->includes(view.oclAsType(diagram::DEdge).targetNode.oclAsType(viewpoint::DSemanticDecorator).target)"
					style = EdgeStyleDescription.create [
						lineStyle = LineStyle.DOT_LITERAL
						targetArrow = EdgeArrows.INPUT_CLOSED_ARROW_LITERAL
						routingStyle = EdgeRouting.TREE_LITERAL
						strokeColor = UserFixedColor.ref("ToolDesign") [ (it as Group).userColorsPalettes.at("Ecore Palette").entries.at(UserFixedColor, "Inherited") ]
						beginLabelStyleDescription = BeginLabelStyleDescription.create [
							labelFormat += FontFormat.ITALIC_LITERAL
							showIcon = false
							labelExpression = "service:superTypesLabel"
							labelColor = Environment.extraRef("$0").systemColors.entries.at("black")
						]
						centerLabelStyleDescription = CenterLabelStyleDescription.create [
							showIcon = false
							labelColor = Environment.extraRef("$0").systemColors.entries.at("black")
						]
					]
				]
			]
			edgeMappings += EdgeMapping.create [
				name = "Bi-directional EC_EReference "
				semanticCandidatesExpression = "service:getEOppositeEReferences(diagram)"
				semanticElements = "service:getEOppositeSemanticElements"
				synchronizationLock = true
				targetFinderExpression = "feature:eType"
				sourceFinderExpression = "feature:eContainer"
				targetExpression = ""
				domainClass = "ecore.EReference"
				useDomainElement = true
				labelDirectEdit = DirectEditLabel.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.toolSections.get(5).ownedTools.at(DirectEditLabel, "Direct Edit EOpposite") ]
				sourceMapping += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass") ]
				sourceMapping += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).additionalLayers.at("Related EClasses").containerMappings.at("EC External EClasses") ]
				targetMapping += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass") ]
				targetMapping += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).additionalLayers.at("Related EClasses").containerMappings.at("EC External EClasses") ]
				reconnections += ReconnectEdgeDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.toolSections.get(4).ownedTools.at(ReconnectEdgeDescription, "ReconnectBiDirectionnalEReference Target") ]
				reconnections += ReconnectEdgeDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.toolSections.get(4).ownedTools.at(ReconnectEdgeDescription, "ReconnectBiDirectionnalEReference Source") ]
				style = EdgeStyleDescription.create [
					sourceArrow = EdgeArrows.INPUT_ARROW_LITERAL
					routingStyle = EdgeRouting.MANHATTAN_LITERAL
					strokeColor = Environment.extraRef("$0").systemColors.entries.at("black")
					beginLabelStyleDescription = BeginLabelStyleDescription.create [
						showIcon = false
						labelExpression = "service:renderEOpposite"
						labelColor = Environment.extraRef("$0").systemColors.entries.at("black")
					]
					endLabelStyleDescription = EndLabelStyleDescription.create [
						showIcon = false
						labelExpression = "service:render"
						labelColor = Environment.extraRef("$0").systemColors.entries.at("black")
					]
				]
			]
			containerMappings += ContainerMapping.create [
				name = "EC EClass"
				createElements = false
				domainClass = "ecore.EClass"
				childrenPresentation = ContainerLayout.LIST
				deletionDescription = DeleteElementDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.toolSections.get(1).ownedTools.at(DeleteElementDescription, "Delete EClass") ]
				labelDirectEdit = DirectEditLabel.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.toolSections.get(5).ownedTools.at(DirectEditLabel, "Edit Name with CamelCase") ]
				dropDescriptions += ContainerDropDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.toolSections.get(2).ownedTools.at(ContainerDropDescription, "Drop attribute") ]
				dropDescriptions += ContainerDropDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.toolSections.get(2).ownedTools.at(ContainerDropDescription, "Drop operation") ]
				borderedNodeMappings += NodeMapping.create [
					name = "EC ETypeParameter"
					semanticCandidatesExpression = "feature:eTypeParameters"
					domainClass = "ecore.ETypeParameter"
					labelDirectEdit = DirectEditLabel.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.toolSections.get(5).ownedTools.at(DirectEditLabel, "Edit Name with CamelCase") ]
					style = WorkspaceImageDescription.create [
						showIcon = false
						labelPosition = LabelPosition.NODE_LITERAL
						resizeKind = ResizeKind.NSEW_LITERAL
						arcWidth = 1
						arcHeight = 1
						workspacePath = "/org.eclipse.emf.ecoretools.design/icons/full/back/generic.svg"
						borderColor = Environment.extraRef("$0").systemColors.entries.at("black")
						labelColor = Environment.extraRef("$0").systemColors.entries.at("black")
					]
				]
				subNodeMappings += NodeMapping.create [
					name = "EC EAttribute"
					semanticCandidatesExpression = "feature:eAttributes"
					domainClass = "ecore.EAttribute"
					labelDirectEdit = DirectEditLabel.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.toolSections.get(5).ownedTools.at(DirectEditLabel, "Edit EStructuralFeature Name") ]
					dropDescriptions += ContainerDropDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.toolSections.get(0).ownedTools.at(ContainerDropDescription, "Drop EStructuralFeature into EClass") ]
					style = BundledImageDescription.create [
						labelExpression = "service:render"
						labelAlignment = LabelAlignment.LEFT
						tooltipExpression = "service:renderTooltip"
						sizeComputationExpression = "1"
						borderColor = Environment.extraRef("$0").systemColors.entries.at("black")
						labelColor = Environment.extraRef("$0").systemColors.entries.at("black")
						color = Environment.extraRef("$0").systemColors.entries.at("black")
					]
				]
				subNodeMappings += NodeMapping.create [
					name = "Operation"
					semanticCandidatesExpression = "feature:eOperations"
					semanticElements = "service:eOperationSemanticElements"
					domainClass = "ecore.EOperation"
					labelDirectEdit = DirectEditLabel.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.toolSections.get(5).ownedTools.at(DirectEditLabel, "Operation Name") ]
					dropDescriptions += ContainerDropDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.toolSections.get(0).ownedTools.at(ContainerDropDescription, "Drop EStructuralFeature into EClass") ]
					style = BundledImageDescription.create [
						labelExpression = "service:render"
						labelAlignment = LabelAlignment.LEFT
						tooltipExpression = "service:renderEOperationTooltip"
						sizeComputationExpression = "2"
						borderColor = Environment.extraRef("$0").systemColors.entries.at("black")
						labelColor = Environment.extraRef("$0").systemColors.entries.at("black")
						color = Environment.extraRef("$0").systemColors.entries.at("black")
					]
				]
				subNodeMappings += NodeMapping.create [
					name = "EC EReferenceNode"
					semanticCandidatesExpression = "service:getNonDisplayedEReferences(diagram)"
					domainClass = "ecore.EReference"
					labelDirectEdit = DirectEditLabel.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.toolSections.get(5).ownedTools.at(DirectEditLabel, "Edit EStructuralFeature Name") ]
					dropDescriptions += ContainerDropDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.toolSections.get(0).ownedTools.at(ContainerDropDescription, "Drop EStructuralFeature into EClass") ]
					style = BundledImageDescription.create [
						labelExpression = "service:renderAsNode"
						labelAlignment = LabelAlignment.LEFT
						tooltipExpression = "service:renderTooltip"
						sizeComputationExpression = "1"
						borderColor = Environment.extraRef("$0").systemColors.entries.at("black")
						labelColor = Environment.extraRef("$0").systemColors.entries.at("black")
						color = Environment.extraRef("$0").systemColors.entries.at("blue")
					]
					conditionnalStyles += ConditionalNodeStyleDescription.create [
						predicateExpression = "aql:container <> self.eContainer()"
						style = BundledImageDescription.create [
							labelFormat += FontFormat.ITALIC_LITERAL
							labelExpression = "service:renderAsNode"
							labelAlignment = LabelAlignment.LEFT
							tooltipExpression = "service:renderTooltip"
							sizeComputationExpression = "1"
							borderColor = Environment.extraRef("$0").systemColors.entries.at("black")
							labelColor = UserFixedColor.ref("ToolDesign") [ (it as Group).userColorsPalettes.at("Ecore Palette").entries.at(UserFixedColor, "Inherited") ]
							color = Environment.extraRef("$0").systemColors.entries.at("black")
						]
					]
				]
				style = FlatContainerStyleDescription.create [
					arcWidth = 8
					arcHeight = 8
					borderSizeComputationExpression = "1"
					tooltipExpression = "service:renderTooltip"
					roundedCorner = true
					widthComputationExpression = "12"
					heightComputationExpression = "10"
					backgroundStyle = BackgroundStyle.LIQUID_LITERAL
					borderColor = Environment.extraRef("$0").systemColors.entries.at("black")
					labelColor = Environment.extraRef("$0").systemColors.entries.at("black")
					backgroundColor = Environment.extraRef("$0").systemColors.entries.at("white")
					foregroundColor = UserFixedColor.ref("ToolDesign") [ (it as Group).userColorsPalettes.at("Ecore Palette").entries.at(UserFixedColor, "EClass") ]
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
						borderColor = UserFixedColor.ref("ToolDesign") [ (it as Group).userColorsPalettes.at("Ecore Palette").entries.at(UserFixedColor, "Dark EClass") ]
						labelColor = Environment.extraRef("$0").systemColors.entries.at("black")
						backgroundColor = Environment.extraRef("$0").systemColors.entries.at("white")
						foregroundColor = UserFixedColor.ref("ToolDesign") [ (it as Group).userColorsPalettes.at("Ecore Palette").entries.at(UserFixedColor, "Abstract EClass") ]
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
						borderColor = UserFixedColor.ref("ToolDesign") [ (it as Group).userColorsPalettes.at("Ecore Palette").entries.at(UserFixedColor, "Dark EClass") ]
						labelColor = Environment.extraRef("$0").systemColors.entries.at("black")
						backgroundColor = Environment.extraRef("$0").systemColors.entries.at("white")
						foregroundColor = UserFixedColor.ref("ToolDesign") [ (it as Group).userColorsPalettes.at("Ecore Palette").entries.at(UserFixedColor, "Abstract EClass") ]
					]
				]
			]
			containerMappings += ContainerMapping.create [
				name = "EC EEnum"
				createElements = false
				domainClass = "ecore.EEnum"
				childrenPresentation = ContainerLayout.LIST
				labelDirectEdit = DirectEditLabel.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.toolSections.get(5).ownedTools.at(DirectEditLabel, "Edit Name with CamelCase") ]
				subNodeMappings += NodeMapping.create [
					name = "EC EEnumLiteral"
					semanticCandidatesExpression = "feature:eLiterals"
					domainClass = "ecore.EEnumLiteral"
					labelDirectEdit = DirectEditLabel.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.toolSections.get(5).ownedTools.at(DirectEditLabel, "Edit Name no CamelCase") ]
					style = BundledImageDescription.create [
						labelAlignment = LabelAlignment.LEFT
						tooltipExpression = "service:renderTooltip"
						sizeComputationExpression = "1"
						borderColor = Environment.extraRef("$0").systemColors.entries.at("black")
						labelColor = Environment.extraRef("$0").systemColors.entries.at("black")
						color = Environment.extraRef("$0").systemColors.entries.at("black")
					]
				]
				style = FlatContainerStyleDescription.create [
					arcWidth = 1
					arcHeight = 1
					borderSizeComputationExpression = "1"
					tooltipExpression = "service:renderTooltip"
					widthComputationExpression = "12"
					heightComputationExpression = "10"
					backgroundStyle = BackgroundStyle.LIQUID_LITERAL
					borderColor = UserFixedColor.ref("ToolDesign") [ (it as Group).userColorsPalettes.at("Ecore Palette").entries.at(UserFixedColor, "Dark EEnum") ]
					labelColor = Environment.extraRef("$0").systemColors.entries.at("black")
					backgroundColor = Environment.extraRef("$0").systemColors.entries.at("white")
					foregroundColor = UserFixedColor.ref("ToolDesign") [ (it as Group).userColorsPalettes.at("Ecore Palette").entries.at(UserFixedColor, "EEnum") ]
				]
			]
			containerMappings += ContainerMapping.create [
				name = "EC EDataType"
				preconditionExpression = "service:isEDataType"
				createElements = false
				domainClass = "ecore.EDataType"
				childrenPresentation = ContainerLayout.LIST
				labelDirectEdit = DirectEditLabel.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.toolSections.get(5).ownedTools.at(DirectEditLabel, "Edit Name with CamelCase") ]
				subNodeMappings += NodeMapping.create [
					name = "EC_DataType_InstanceClassName"
					semanticCandidatesExpression = "var:self"
					domainClass = "ecore.EDataType"
					labelDirectEdit = DirectEditLabel.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.toolSections.get(5).ownedTools.at(DirectEditLabel, "InstanceClassName") ]
					style = BundledImageDescription.create [
						labelFormat += FontFormat.ITALIC_LITERAL
						showIcon = false
						labelExpression = "feature:instanceClassName"
						tooltipExpression = "service:renderTooltip"
						sizeComputationExpression = "1"
						borderColor = Environment.extraRef("$0").systemColors.entries.at("black")
						labelColor = Environment.extraRef("$0").systemColors.entries.at("black")
						color = Environment.extraRef("$0").systemColors.entries.at("black")
					]
				]
				style = FlatContainerStyleDescription.create [
					arcWidth = 1
					arcHeight = 1
					borderSizeComputationExpression = "1"
					tooltipExpression = "service:renderTooltip"
					widthComputationExpression = "14"
					heightComputationExpression = "5"
					backgroundStyle = BackgroundStyle.LIQUID_LITERAL
					borderColor = UserFixedColor.ref("ToolDesign") [ (it as Group).userColorsPalettes.at("Ecore Palette").entries.at(UserFixedColor, "Dark EDataType") ]
					labelColor = Environment.extraRef("$0").systemColors.entries.at("black")
					backgroundColor = Environment.extraRef("$0").systemColors.entries.at("white")
					foregroundColor = UserFixedColor.ref("ToolDesign") [ (it as Group).userColorsPalettes.at("Ecore Palette").entries.at(UserFixedColor, "EDataType") ]
				]
			]
			toolSections += ToolSection.create [
				name = "Existing Elements"
				ownedTools += PopupMenu.create [
					name = "Generate"
					menuItemDescription += OperationAction.create [
						name = " All"
						precondition = "aql:OrderedSet{views.target}.eInverse().eContainerOrSelf(genmodel::GenModel)->asSet()->size() > 0"
						icon = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/GenModel.gif"
						view = ContainerViewVariable.create [
							name = "views"
						]
						initialOperation = InitialOperation.create [
							firstModelOperations = ExternalJavaAction.create [
								name = "Generate All"
								id = "org.eclipse.emf.ecoretools.design.action.generateAllID"
								parameters += ExternalJavaActionParameter.create [
									name = "genmodels"
									value = "aql:OrderedSet{views.target}.eInverse().eContainerOrSelf(genmodel::GenModel)->asSet()"
								]
								parameters += ExternalJavaActionParameter.create [
									name = "scope"
									value = "model, edit, editor, tests"
								]
							]
						]
					]
					menuItemDescription += OperationAction.create [
						name = "Model Code"
						precondition = "aql:OrderedSet{views.target}.eInverse().eContainerOrSelf(genmodel::GenModel)->asSet()->select(m | m.modelDirectory.size() > 0)->size() > 0"
						icon = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/GenModel.gif"
						view = ContainerViewVariable.create [
							name = "views"
						]
						initialOperation = InitialOperation.create [
							firstModelOperations = ExternalJavaAction.create [
								name = "Generate All"
								id = "org.eclipse.emf.ecoretools.design.action.generateAllID"
								parameters += ExternalJavaActionParameter.create [
									name = "genmodels"
									value = "aql:OrderedSet{views.target}.eInverse().eContainerOrSelf(genmodel::GenModel)->asSet()"
								]
								parameters += ExternalJavaActionParameter.create [
									name = "scope"
									value = "model"
								]
							]
						]
					]
					menuItemDescription += OperationAction.create [
						name = "Edit Code"
						precondition = "aql:OrderedSet{views.target}.eInverse().eContainerOrSelf(genmodel::GenModel)->asSet()->select(m | m.editDirectory.size() > 0)->size() > 0"
						icon = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/GenModel.gif"
						view = ContainerViewVariable.create [
							name = "views"
						]
						initialOperation = InitialOperation.create [
							firstModelOperations = ExternalJavaAction.create [
								name = "Generate All"
								id = "org.eclipse.emf.ecoretools.design.action.generateAllID"
								parameters += ExternalJavaActionParameter.create [
									name = "genmodels"
									value = "aql:OrderedSet{views.target}.eInverse().eContainerOrSelf(genmodel::GenModel)->asSet()"
								]
								parameters += ExternalJavaActionParameter.create [
									name = "scope"
									value = "edit"
								]
							]
						]
					]
					menuItemDescription += OperationAction.create [
						name = "Editor Code"
						precondition = "aql:OrderedSet{views.target}.eInverse().eContainerOrSelf(genmodel::GenModel)->asSet()->select(m | m.editorDirectory.size() > 0)->size() > 0"
						icon = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/GenModel.gif"
						view = ContainerViewVariable.create [
							name = "views"
						]
						initialOperation = InitialOperation.create [
							firstModelOperations = ExternalJavaAction.create [
								name = "Generate All"
								id = "org.eclipse.emf.ecoretools.design.action.generateAllID"
								parameters += ExternalJavaActionParameter.create [
									name = "genmodels"
									value = "aql:OrderedSet{views.target}.eInverse().eContainerOrSelf(genmodel::GenModel)->asSet()"
								]
								parameters += ExternalJavaActionParameter.create [
									name = "scope"
									value = "editor"
								]
							]
						]
					]
					menuItemDescription += OperationAction.create [
						name = "Tests Code"
						precondition = "aql:OrderedSet{views.target}.eInverse().eContainerOrSelf(genmodel::GenModel)->asSet()->select(m | m.testsDirectory.size() > 0)->size() > 0"
						icon = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/GenModel.gif"
						view = ContainerViewVariable.create [
							name = "views"
						]
						initialOperation = InitialOperation.create [
							firstModelOperations = ExternalJavaAction.create [
								name = "Generate All"
								id = "org.eclipse.emf.ecoretools.design.action.generateAllID"
								parameters += ExternalJavaActionParameter.create [
									name = "genmodels"
									value = "aql:OrderedSet{views.target}.eInverse().eContainerOrSelf(genmodel::GenModel)->asSet()"
								]
								parameters += ExternalJavaActionParameter.create [
									name = "scope"
									value = "tests"
								]
							]
						]
					]
				]
				ownedTools += PopupMenu.create [
					name = "CDO Native"
					precondition = "aql:self.hasCDOBundle()"
					menuItemDescription += OperationAction.create [
						name = "Enable support"
						precondition = "aql:OrderedSet{views.target}.eInverse().eContainerOrSelf(genmodel::GenModel)->asSet()->size() > 0"
						view = ContainerViewVariable.create [
							name = "views"
						]
						initialOperation = InitialOperation.create [
							firstModelOperations = ExternalJavaAction.create [
								name = "OpenConfirmationDialog"
								id = "org.eclipse.emf.ecoretools.design.action.openConfirmationDialogID"
								subModelOperations += ChangeContext.create [
									browseExpression = "aql:self.enableCDOGen(OrderedSet{views->filter(viewpoint::DSemanticDecorator).target}.eInverse().eContainerOrSelf(genmodel::GenModel)->asSet())"
								]
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
					]
					menuItemDescription += OperationAction.create [
						name = "Disable support"
						precondition = "aql:OrderedSet{views.target}.eInverse().eContainerOrSelf(genmodel::GenModel)->asSet()->size() > 0"
						view = ContainerViewVariable.create [
							name = "views"
						]
						initialOperation = InitialOperation.create [
							firstModelOperations = ExternalJavaAction.create [
								name = "OpenConfirmationDialog"
								id = "org.eclipse.emf.ecoretools.design.action.openConfirmationDialogID"
								subModelOperations += ChangeContext.create [
									browseExpression = "aql:self.disableCDOGen(OrderedSet{views->filter(viewpoint::DSemanticDecorator).target}.eInverse().eContainerOrSelf(genmodel::GenModel)->asSet())"
								]
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
				]
				ownedTools += SelectionWizardDescription.create [
					name = "Add"
					precondition = "aql:container.oclIsKindOf(ecore::EPackage)"
					forceRefresh = true
					candidatesExpression = "aql:self.getValidsForDiagram(containerView)->asSet() - diagram.getDisplayedEClassifiers()"
					multiple = true
					tree = true
					rootExpression = "service:rootEPackages"
					childrenExpression = "feature:eContents"
					iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/etools16/search.gif"
					windowTitle = "Select element to add in diagram"
					element = ElementSelectVariable.create [
						name = "element"
					]
					containerView = ContainerViewVariable.create [
						name = "containerView"
					]
					container = SelectContainerVariable.create [
						name = "container"
					]
					initialOperation = InitialOperation.create [
						firstModelOperations = For.create [
							expression = "var:element"
							subModelOperations += ChangeContext.create [
								browseExpression = "service:markForAutosize"
								subModelOperations += If.create [
									conditionExpression = "service:isEClass"
									subModelOperations += CreateView.create [
										containerViewExpression = "var:containerView"
										mapping = ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass") ]
									]
								]
								subModelOperations += If.create [
									conditionExpression = "service:isEDataType"
									subModelOperations += CreateView.create [
										containerViewExpression = "var:containerView"
										mapping = ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EDataType") ]
									]
								]
								subModelOperations += If.create [
									conditionExpression = "service:isEEnum"
									subModelOperations += CreateView.create [
										containerViewExpression = "var:containerView"
										mapping = ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EEnum") ]
									]
								]
							]
						]
					]
				]
				ownedTools += ToolDescription.create [
					name = "RemoveExistingElements"
					label = "Remove"
					forceRefresh = true
					iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/etools16/search.gif"
					element = ElementVariable.create [
						name = "element"
					]
					elementView = ElementViewVariable.create [
						name = "elementView"
					]
					initialOperation = InitialOperation.create [
						firstModelOperations = ChangeContext.create [
							browseExpression = "var:elementView"
							subModelOperations += DeleteView.create
						]
					]
				]
				ownedTools += ContainerDropDescription.create [
					name = "External EClass from treeview"
					forceRefresh = true
					dragSource = DragSource.PROJECT_EXPLORER_LITERAL
					oldContainer = DropContainerVariable.create [
						name = "oldSemanticContainer"
					]
					newContainer = DropContainerVariable.create [
						name = "newSemanticContainer"
					]
					element = ElementDropVariable.create [
						name = "element"
					]
					newViewContainer = ContainerViewVariable.create [
						name = "newContainerView"
					]
					initialOperation = InitialContainerDropOperation.create [
						firstModelOperations = ChangeContext.create [
							browseExpression = "var:element"
							subModelOperations += ChangeContext.create [
								browseExpression = "service:markForAutosize"
								subModelOperations += If.create [
									conditionExpression = "service:isEClass"
									subModelOperations += CreateView.create [
										containerViewExpression = "var:newContainerView"
										mapping = ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass") ]
									]
								]
								subModelOperations += If.create [
									conditionExpression = "service:isEDataType"
									subModelOperations += CreateView.create [
										containerViewExpression = "var:newContainerView"
										mapping = ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EDataType") ]
									]
								]
								subModelOperations += If.create [
									conditionExpression = "service:isEEnum"
									subModelOperations += CreateView.create [
										containerViewExpression = "var:newContainerView"
										mapping = ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EEnum") ]
									]
								]
								subModelOperations += If.create [
									conditionExpression = "service:isEPackage"
									subModelOperations += CreateView.create [
										containerViewExpression = "var:newContainerView"
										mapping = ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).additionalLayers.at("Package").containerMappings.at("Dropped Package") ]
									]
								]
							]
						]
					]
				]
				ownedTools += OperationAction.create [
					name = "Add Related Elements"
					forceRefresh = true
					icon = "/org.eclipse.emf.ecoretools.design/icons/full/etools16/search.gif"
					view = ContainerViewVariable.create [
						name = "views"
						subVariables += SelectModelElementVariable.create [
							name = "selected"
							candidatesExpression = "service:getRelated(views,diagram)"
							multiple = true
							message = "Pick the Element you want to add to the diagram."
						]
					]
					initialOperation = InitialOperation.create [
						firstModelOperations = For.create [
							expression = "var:selected"
							subModelOperations += ChangeContext.create [
								browseExpression = "service:markForAutosize"
								subModelOperations += If.create [
									conditionExpression = "service:isEClass"
									subModelOperations += CreateView.create [
										containerViewExpression = "var:diagram"
										mapping = ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass") ]
									]
								]
								subModelOperations += If.create [
									conditionExpression = "service:isEDataType"
									subModelOperations += CreateView.create [
										containerViewExpression = "var:diagram"
										mapping = ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EDataType") ]
									]
								]
								subModelOperations += If.create [
									conditionExpression = "service:isEEnum"
									subModelOperations += CreateView.create [
										containerViewExpression = "var:diagram"
										mapping = ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EEnum") ]
									]
								]
							]
						]
					]
				]
				ownedTools += ContainerDropDescription.create [
					name = "Drop EStructuralFeature into EClass"
					mappings += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).additionalLayers.at("Package").containerMappings.at("Dropped Package") ]
					oldContainer = DropContainerVariable.create [
						name = "oldSemanticContainer"
					]
					newContainer = DropContainerVariable.create [
						name = "newSemanticContainer"
					]
					element = ElementDropVariable.create [
						name = "element"
					]
					newViewContainer = ContainerViewVariable.create [
						name = "newContainerView"
					]
					initialOperation = InitialContainerDropOperation.create [
						firstModelOperations = ChangeContext.create [
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
				]
				ownedTools += PasteDescription.create [
					name = "Paste Anything"
					forceRefresh = true
					container = DropContainerVariable.create [
						name = "container"
					]
					containerView = ContainerViewVariable.create [
						name = "containerView"
					]
					copiedView = ElementViewVariable.create [
						name = "copiedView"
					]
					copiedElement = ElementVariable.create [
						name = "copiedElement"
					]
					initialOperation = InitialOperation.create [
						firstModelOperations = ChangeContext.create [
							browseExpression = "service:container.paste(copiedElement, copiedView, containerView)"
						]
					]
				]
				ownedTools += DoubleClickDescription.create [
					name = "Import Current EClasses"
					forceRefresh = true
					mappings += NodeMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.nodeMappings.at("Empty Diagram") ]
					element = ElementDoubleClickVariable.create [
						name = "element"
					]
					elementView = ElementDoubleClickVariable.create [
						name = "elementView"
						subVariables += AcceleoVariable.create [
							name = "diagram"
							computationExpression = "feature:eContainer"
						]
					]
					initialOperation = InitialOperation.create [
						firstModelOperations = ChangeContext.create [
							browseExpression = "var:element"
							subModelOperations += For.create [
								expression = "service:getRelated(elementView,diagram)"
								subModelOperations += ChangeContext.create [
									browseExpression = "service:markForAutosize"
									subModelOperations += If.create [
										conditionExpression = "service:isEClass"
										subModelOperations += CreateView.create [
											containerViewExpression = "var:diagram"
											mapping = ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass") ]
										]
									]
									subModelOperations += If.create [
										conditionExpression = "service:isEDataType"
										subModelOperations += CreateView.create [
											containerViewExpression = "var:diagram"
											mapping = ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EDataType") ]
										]
									]
									subModelOperations += If.create [
										conditionExpression = "service:isEEnum"
										subModelOperations += CreateView.create [
											containerViewExpression = "var:diagram"
											mapping = ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EEnum") ]
										]
									]
								]
							]
						]
					]
				]
			]
			toolSections += ToolSection.create [
				name = "Classifier"
				ownedTools += ToolGroup.create [
					name = "Classifier"
					tools += ContainerCreationDescription.create [
						documentation = "M1+Y"
						name = "Class"
						precondition = "aql:(not container.oclIsKindOf(ecore::EClass)) or (container.abstract) or (container.interface)"
						containerMappings += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass") ]
						extraMappings += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass") ]
						variable = NodeCreationVariable.create [
							name = "container"
						]
						viewVariable = ContainerViewVariable.create [
							name = "containerView"
						]
						initialOperation = InitialNodeCreationOperation.create [
							firstModelOperations = ChangeContext.create [
								browseExpression = "var:container"
								subModelOperations += If.create [
									conditionExpression = "service:isEPackage"
									subModelOperations += CreateInstance.create [
										typeName = "ecore.EClass"
										referenceName = "eClassifiers"
										subModelOperations += SetValue.create [
											featureName = "name"
											valueExpression = "aql:'NewEClass'  + self.eContainer().eContents(ecore::EClass)->size()"
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
					]
					tools += ContainerCreationDescription.create [
						name = "Abstract Class"
						precondition = "aql:(not container.oclIsKindOf(ecore::EClass)) or (not container.abstract)"
						iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/EClass_abstract.gif"
						containerMappings += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass") ]
						extraMappings += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass") ]
						variable = NodeCreationVariable.create [
							name = "container"
						]
						viewVariable = ContainerViewVariable.create [
							name = "containerView"
						]
						initialOperation = InitialNodeCreationOperation.create [
							firstModelOperations = ChangeContext.create [
								browseExpression = "var:container"
								subModelOperations += If.create [
									conditionExpression = "service:isEPackage"
									subModelOperations += CreateInstance.create [
										typeName = "ecore.EClass"
										referenceName = "eClassifiers"
										subModelOperations += SetValue.create [
											featureName = "name"
											valueExpression = "aql:'NewAbstractClass' + self.eContainer().eContents(ecore::EClass)->size()"
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
					]
					tools += ContainerCreationDescription.create [
						name = "Interface"
						precondition = "aql:(not container.oclIsKindOf(ecore::EClass)) or (not container.interface)"
						iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/EClass_interface.gif"
						containerMappings += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass") ]
						extraMappings += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass") ]
						variable = NodeCreationVariable.create [
							name = "container"
						]
						viewVariable = ContainerViewVariable.create [
							name = "containerView"
						]
						initialOperation = InitialNodeCreationOperation.create [
							firstModelOperations = ChangeContext.create [
								browseExpression = "var:container"
								subModelOperations += If.create [
									conditionExpression = "service:isEPackage"
									subModelOperations += CreateInstance.create [
										typeName = "ecore.EClass"
										referenceName = "eClassifiers"
										subModelOperations += SetValue.create [
											featureName = "name"
											valueExpression = "aql:'NewInterface' + self.eContainer().eContents(ecore::EClass)->size()"
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
				]
				ownedTools += ContainerCreationDescription.create [
					name = "Datatype"
					containerMappings += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EDataType") ]
					variable = NodeCreationVariable.create [
						name = "container"
					]
					viewVariable = ContainerViewVariable.create [
						name = "containerView"
					]
					initialOperation = InitialNodeCreationOperation.create [
						firstModelOperations = CreateInstance.create [
							typeName = "ecore.EDataType"
							referenceName = "eClassifiers"
							subModelOperations += SetValue.create [
								featureName = "name"
								valueExpression = "aql:'NewDataType' + self.eContainer().eContents(ecore::EDataType)->size()"
							]
							subModelOperations += SetValue.create [
								featureName = "instanceTypeName"
								valueExpression = "aql:'newDataType' + self.eContainer().eContents(ecore::EDataType)->size()"
							]
						]
					]
				]
				ownedTools += ContainerCreationDescription.create [
					name = "Enumeration"
					containerMappings += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EEnum") ]
					variable = NodeCreationVariable.create [
						name = "container"
					]
					viewVariable = ContainerViewVariable.create [
						name = "containerView"
					]
					initialOperation = InitialNodeCreationOperation.create [
						firstModelOperations = CreateInstance.create [
							typeName = "ecore.EEnum"
							referenceName = "eClassifiers"
							subModelOperations += SetValue.create [
								featureName = "name"
								valueExpression = "aql:'NewEnum' + self.eContainer().eContents(ecore::EEnum)->size()"
							]
						]
					]
				]
				ownedTools += DeleteElementDescription.create [
					name = "Delete EClass"
					element = ElementDeleteVariable.create [
						name = "element"
					]
					elementView = ElementDeleteVariable.create [
						name = "elementView"
					]
					containerView = ContainerViewVariable.create [
						name = "containerView"
					]
					initialOperation = InitialOperation.create [
						firstModelOperations = ChangeContext.create [
							browseExpression = "var:self"
							subModelOperations += For.create [
								expression = "service:getInverseEReferences"
								subModelOperations += RemoveElement.create
							]
							subModelOperations += RemoveElement.create
						]
					]
				]
				ownedTools += NodeCreationDescription.create [
					name = "ETypeParameter"
					nodeMappings += NodeMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").borderedNodeMappings.at("EC ETypeParameter") ]
					variable = NodeCreationVariable.create [
						name = "container"
					]
					viewVariable = ContainerViewVariable.create [
						name = "containerView"
					]
					initialOperation = InitialNodeCreationOperation.create [
						firstModelOperations = ChangeContext.create [
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
				]
				ownedTools += DeleteElementDescription.create [
					name = "NoOp"
					precondition = "aql:false"
					element = ElementDeleteVariable.create [
						name = "element"
					]
					elementView = ElementDeleteVariable.create [
						name = "elementView"
					]
					containerView = ContainerViewVariable.create [
						name = "containerView"
					]
					initialOperation = InitialOperation.create [
						firstModelOperations = ChangeContext.create [
							browseExpression = "var:self"
						]
					]
				]
			]
			toolSections += ToolSection.create [
				name = "Feature"
				ownedTools += NodeCreationDescription.create [
					name = "Literal"
					nodeMappings += NodeMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EEnum").subNodeMappings.at("EC EEnumLiteral") ]
					variable = NodeCreationVariable.create [
						name = "container"
					]
					viewVariable = ContainerViewVariable.create [
						name = "containerView"
					]
					initialOperation = InitialNodeCreationOperation.create [
						firstModelOperations = CreateInstance.create [
							typeName = "ecore.EEnumLiteral"
							referenceName = "eLiterals"
							subModelOperations += SetValue.create [
								featureName = "name"
								valueExpression = "aql:('literal' +( self.eContainer().eContents(ecore::EEnumLiteral)->size() -1)).toUpper()"
							]
							subModelOperations += SetValue.create [
								featureName = "value"
								valueExpression = "aql:self.eContainer().eContents(ecore::EEnumLiteral)->size()-1"
							]
						]
					]
				]
				ownedTools += NodeCreationDescription.create [
					name = "Operation"
					nodeMappings += NodeMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("Operation") ]
					variable = NodeCreationVariable.create [
						name = "container"
					]
					viewVariable = ContainerViewVariable.create [
						name = "containerView"
					]
					initialOperation = InitialNodeCreationOperation.create [
						firstModelOperations = CreateInstance.create [
							typeName = "ecore.EOperation"
							referenceName = "eOperations"
							subModelOperations += SetValue.create [
								featureName = "name"
								valueExpression = "aql:'newOperation' + self.eContainer().eContents(ecore::EOperation)->size()"
							]
						]
					]
				]
				ownedTools += NodeCreationDescription.create [
					name = "Attribute"
					nodeMappings += NodeMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("EC EAttribute") ]
					variable = NodeCreationVariable.create [
						name = "container"
					]
					viewVariable = ContainerViewVariable.create [
						name = "containerView"
					]
					initialOperation = InitialNodeCreationOperation.create [
						firstModelOperations = CreateInstance.create [
							typeName = "ecore.EAttribute"
							referenceName = "eStructuralFeatures"
							subModelOperations += SetValue.create [
								featureName = "name"
								valueExpression = "newAttribute"
							]
						]
					]
				]
				ownedTools += ContainerDropDescription.create [
					name = "Drop attribute"
					mappings += NodeMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("EC EAttribute") ]
					mappings += NodeMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("EC EReferenceNode") ]
					oldContainer = DropContainerVariable.create [
						name = "oldSemanticContainer"
					]
					newContainer = DropContainerVariable.create [
						name = "newSemanticContainer"
					]
					element = ElementDropVariable.create [
						name = "element"
					]
					newViewContainer = ContainerViewVariable.create [
						name = "newContainerView"
					]
					initialOperation = InitialContainerDropOperation.create [
						firstModelOperations = ChangeContext.create [
							browseExpression = "var:newSemanticContainer"
							subModelOperations += SetValue.create [
								featureName = "eStructuralFeatures"
								valueExpression = "var:element"
							]
						]
					]
				]
				ownedTools += ContainerDropDescription.create [
					name = "Drop operation"
					mappings += NodeMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("Operation") ]
					oldContainer = DropContainerVariable.create [
						name = "oldSemanticContainer"
					]
					newContainer = DropContainerVariable.create [
						name = "newSemanticContainer"
					]
					element = ElementDropVariable.create [
						name = "element"
					]
					newViewContainer = ContainerViewVariable.create [
						name = "newContainerView"
					]
					initialOperation = InitialContainerDropOperation.create [
						firstModelOperations = ChangeContext.create [
							browseExpression = "var:newSemanticContainer"
							subModelOperations += SetValue.create [
								featureName = "eOperations"
								valueExpression = "var:element"
							]
						]
					]
				]
			]
			toolSections += ToolSection.create [
				name = "Relation"
				ownedTools += DiagramCreationDescription.create [
					name = "New Package Entities"
					titleExpression = "aql:self.name + ' package entities'"
					diagramDescription = DiagramDescription.ref("EntitiesDiagram")
					initialOperation = InitialOperation.create [
						firstModelOperations = ChangeContext.create [
							browseExpression = "var:self"
						]
					]
					containerViewVariable = ContainerViewVariable.create [
						name = "containerView"
					]
					representationNameVariable = NameVariable.create [
						name = "diagramName"
					]
				]
				ownedTools += EdgeCreationDescription.create [
					name = "SuperType"
					iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/Inheritance.gif"
					edgeMappings += EdgeMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.edgeMappings.at("EC ESupertypes") ]
					sourceVariable = SourceEdgeCreationVariable.create [
						name = "source"
					]
					targetVariable = TargetEdgeCreationVariable.create [
						name = "target"
					]
					sourceViewVariable = SourceEdgeViewCreationVariable.create [
						name = "sourceView"
					]
					targetViewVariable = TargetEdgeViewCreationVariable.create [
						name = "targetView"
					]
					initialOperation = InitEdgeCreationOperation.create [
						firstModelOperations = ChangeContext.create [
							browseExpression = "var:source"
							subModelOperations += SetValue.create [
								featureName = "eSuperTypes"
								valueExpression = "var:target"
								subModelOperations += ChangeContext.create [
									browseExpression = "service:createTypeArgumentsIfNeeded(target)"
								]
							]
						]
					]
				]
				ownedTools += EdgeCreationDescription.create [
					name = "Reference"
					edgeMappings += EdgeMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.edgeMappings.at("EC_EReference") ]
					sourceVariable = SourceEdgeCreationVariable.create [
						name = "source"
					]
					targetVariable = TargetEdgeCreationVariable.create [
						name = "target"
					]
					sourceViewVariable = SourceEdgeViewCreationVariable.create [
						name = "sourceView"
					]
					targetViewVariable = TargetEdgeViewCreationVariable.create [
						name = "targetView"
					]
					initialOperation = InitEdgeCreationOperation.create [
						firstModelOperations = ChangeContext.create [
							browseExpression = "var:source"
							subModelOperations += CreateInstance.create [
								typeName = "ecore.EReference"
								referenceName = "eStructuralFeatures"
								subModelOperations += SetValue.create [
									featureName = "name"
									valueExpression = "aql:target.name.toLower()"
								]
								subModelOperations += ChangeContext.create [
									browseExpression = "service:setEType(target)"
								]
							]
						]
					]
				]
				ownedTools += EdgeCreationDescription.create [
					name = "Bi-directional Reference"
					edgeMappings += EdgeMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.edgeMappings.at("Bi-directional EC_EReference ") ]
					sourceVariable = SourceEdgeCreationVariable.create [
						name = "source"
					]
					targetVariable = TargetEdgeCreationVariable.create [
						name = "target"
					]
					sourceViewVariable = SourceEdgeViewCreationVariable.create [
						name = "sourceView"
					]
					targetViewVariable = TargetEdgeViewCreationVariable.create [
						name = "targetView"
					]
					initialOperation = InitEdgeCreationOperation.create [
						firstModelOperations = ChangeContext.create [
							browseExpression = "var:target"
							subModelOperations += CreateInstance.create [
								typeName = "ecore.EReference"
								referenceName = "eStructuralFeatures"
								variableName = "instanceTarget"
								subModelOperations += SetValue.create [
									featureName = "eType"
									valueExpression = "aql:source"
								]
								subModelOperations += SetValue.create [
									featureName = "name"
									valueExpression = "aql:source.name.toLower()"
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
										valueExpression = "aql:target.name.toLower()"
									]
									subModelOperations += SetValue.create [
										featureName = "eOpposite"
										valueExpression = "var:instanceTarget"
									]
									subModelOperations += If.create [
										conditionExpression = "aql:source = target"
										subModelOperations += SetValue.create [
											featureName = "name"
											valueExpression = "aql:target.name.toLower() + 'eOpposite'"
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
				]
				ownedTools += EdgeCreationDescription.create [
					name = "Composition"
					edgeMappings += EdgeMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.edgeMappings.at("EC_EReference") ]
					sourceVariable = SourceEdgeCreationVariable.create [
						name = "source"
					]
					targetVariable = TargetEdgeCreationVariable.create [
						name = "target"
					]
					sourceViewVariable = SourceEdgeViewCreationVariable.create [
						name = "sourceView"
					]
					targetViewVariable = TargetEdgeViewCreationVariable.create [
						name = "targetView"
					]
					initialOperation = InitEdgeCreationOperation.create [
						firstModelOperations = ChangeContext.create [
							browseExpression = "var:source"
							subModelOperations += CreateInstance.create [
								typeName = "ecore.EReference"
								referenceName = "eStructuralFeatures"
								subModelOperations += SetValue.create [
									featureName = "name"
									valueExpression = "aql:target.name.toLower()"
								]
								subModelOperations += SetValue.create [
									featureName = "containment"
									valueExpression = "true"
								]
								subModelOperations += SetValue.create [
									featureName = "upperBound"
									valueExpression = "-1"
								]
								subModelOperations += ChangeContext.create [
									browseExpression = "service:setEType(target)"
								]
							]
						]
					]
				]
				ownedTools += DeleteElementDescription.create [
					name = "Delete ESuperType"
					element = ElementDeleteVariable.create [
						name = "element"
					]
					elementView = ElementDeleteVariable.create [
						name = "elementView"
					]
					containerView = ContainerViewVariable.create [
						name = "containerView"
					]
					initialOperation = InitialOperation.create [
						firstModelOperations = ChangeContext.create [
							browseExpression = "service:getEdgeSourceSemantic(elementView)"
							subModelOperations += Unset.create [
								featureName = "eSuperTypes"
								elementExpression = "service:getEdgeTargetSemantic(elementView)"
							]
						]
					]
				]
			]
			toolSections += ToolSection.create [
				name = "Reconnect"
				ownedTools += ReconnectEdgeDescription.create [
					name = "ReconnectEReference Source"
					reconnectionKind = ReconnectionKind.RECONNECT_SOURCE_LITERAL
					source = SourceEdgeCreationVariable.create [
						name = "source"
					]
					target = TargetEdgeCreationVariable.create [
						name = "target"
					]
					sourceView = SourceEdgeViewCreationVariable.create [
						name = "sourceView"
					]
					targetView = TargetEdgeViewCreationVariable.create [
						name = "targetView"
					]
					element = ElementSelectVariable.create [
						name = "element"
					]
					initialOperation = InitialOperation.create [
						firstModelOperations = ChangeContext.create [
							browseExpression = "var:element"
							subModelOperations += ChangeContext.create [
								browseExpression = "service:reconnectEReferenceSource(target)"
							]
						]
					]
					edgeView = ElementSelectVariable.create [
						name = "edgeView"
					]
				]
				ownedTools += ReconnectEdgeDescription.create [
					name = "ReconnectEReference Target"
					source = SourceEdgeCreationVariable.create [
						name = "source"
					]
					target = TargetEdgeCreationVariable.create [
						name = "target"
					]
					sourceView = SourceEdgeViewCreationVariable.create [
						name = "sourceView"
					]
					targetView = TargetEdgeViewCreationVariable.create [
						name = "targetView"
					]
					element = ElementSelectVariable.create [
						name = "element"
					]
					initialOperation = InitialOperation.create [
						firstModelOperations = ChangeContext.create [
							browseExpression = "var:element"
							subModelOperations += ChangeContext.create [
								browseExpression = "service:reconnectEReferenceTarget(target)"
							]
						]
					]
					edgeView = ElementSelectVariable.create [
						name = "edgeView"
					]
				]
				ownedTools += ReconnectEdgeDescription.create [
					name = "ReconnectESupertypeSource"
					reconnectionKind = ReconnectionKind.RECONNECT_SOURCE_LITERAL
					source = SourceEdgeCreationVariable.create [
						name = "source"
					]
					target = TargetEdgeCreationVariable.create [
						name = "target"
					]
					sourceView = SourceEdgeViewCreationVariable.create [
						name = "sourceView"
					]
					targetView = TargetEdgeViewCreationVariable.create [
						name = "targetView"
					]
					element = ElementSelectVariable.create [
						name = "element"
					]
					initialOperation = InitialOperation.create [
						firstModelOperations = ChangeContext.create [
							browseExpression = "var:element"
							subModelOperations += ChangeContext.create [
								browseExpression = "aql:self.reconnectESuperTypeSource(target,source,otherEnd,edgeView,sourceView)"
							]
						]
					]
					edgeView = ElementSelectVariable.create [
						name = "edgeView"
					]
				]
				ownedTools += ReconnectEdgeDescription.create [
					name = "ReconnectESupertypeTarget"
					source = SourceEdgeCreationVariable.create [
						name = "source"
					]
					target = TargetEdgeCreationVariable.create [
						name = "target"
					]
					sourceView = SourceEdgeViewCreationVariable.create [
						name = "sourceView"
					]
					targetView = TargetEdgeViewCreationVariable.create [
						name = "targetView"
					]
					element = ElementSelectVariable.create [
						name = "element"
					]
					initialOperation = InitialOperation.create [
						firstModelOperations = ChangeContext.create [
							browseExpression = "var:element"
							subModelOperations += ChangeContext.create [
								browseExpression = "aql:self.reconnectESuperTypeTarget(target,source,otherEnd,edgeView,sourceView)"
							]
						]
					]
					edgeView = ElementSelectVariable.create [
						name = "edgeView"
					]
				]
				ownedTools += ReconnectEdgeDescription.create [
					name = "ReconnectBiDirectionnalEReference Source"
					reconnectionKind = ReconnectionKind.RECONNECT_SOURCE_LITERAL
					source = SourceEdgeCreationVariable.create [
						name = "source"
					]
					target = TargetEdgeCreationVariable.create [
						name = "target"
					]
					sourceView = SourceEdgeViewCreationVariable.create [
						name = "sourceView"
					]
					targetView = TargetEdgeViewCreationVariable.create [
						name = "targetView"
					]
					element = ElementSelectVariable.create [
						name = "element"
					]
					initialOperation = InitialOperation.create [
						firstModelOperations = ChangeContext.create [
							browseExpression = "var:target"
							subModelOperations += CreateInstance.create [
								typeName = "ecore.EReference"
								referenceName = "eStructuralFeatures"
								variableName = "newSource"
								subModelOperations += SetValue.create [
									featureName = "name"
									valueExpression = "aql:element.name"
								]
								subModelOperations += SetValue.create [
									featureName = "eType"
									valueExpression = "aql:element.eType"
								]
								subModelOperations += SetValue.create [
									featureName = "eOpposite"
									valueExpression = "aql:element.eOpposite"
								]
							]
							subModelOperations += ChangeContext.create [
								browseExpression = "aql:element.eOpposite"
								subModelOperations += SetValue.create [
									featureName = "eType"
									valueExpression = "var:target"
								]
								subModelOperations += SetValue.create [
									featureName = "eOpposite"
									valueExpression = "aql:newSource"
								]
							]
							subModelOperations += ChangeContext.create [
								browseExpression = "var:element"
								subModelOperations += RemoveElement.create
							]
						]
					]
					edgeView = ElementSelectVariable.create [
						name = "edgeView"
					]
				]
				ownedTools += ReconnectEdgeDescription.create [
					name = "ReconnectBiDirectionnalEReference Target"
					source = SourceEdgeCreationVariable.create [
						name = "source"
					]
					target = TargetEdgeCreationVariable.create [
						name = "target"
					]
					sourceView = SourceEdgeViewCreationVariable.create [
						name = "sourceView"
					]
					targetView = TargetEdgeViewCreationVariable.create [
						name = "targetView"
					]
					element = ElementSelectVariable.create [
						name = "element"
					]
					initialOperation = InitialOperation.create [
						firstModelOperations = ChangeContext.create [
							browseExpression = "var:target"
							subModelOperations += CreateInstance.create [
								typeName = "ecore.EReference"
								referenceName = "eStructuralFeatures"
								variableName = "newTarget"
								subModelOperations += SetValue.create [
									featureName = "name"
									valueExpression = "aql:element.eOpposite.name"
								]
								subModelOperations += SetValue.create [
									featureName = "eType"
									valueExpression = "aql:element.eOpposite.eType"
								]
								subModelOperations += SetValue.create [
									featureName = "eOpposite"
									valueExpression = "var:element"
								]
							]
							subModelOperations += ChangeContext.create [
								browseExpression = "aql:element.eOpposite"
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
					]
					edgeView = ElementSelectVariable.create [
						name = "edgeView"
					]
				]
			]
			toolSections += ToolSection.create [
				name = "Direct Edit"
				ownedTools += DirectEditLabel.create [
					name = "Edit Name with CamelCase"
					mask = EditMaskVariables.create [
						mask = "{0}"
					]
					initialOperation = InitialOperation.create [
						firstModelOperations = SetValue.create [
							featureName = "name"
							valueExpression = "service:toCamelCase(arg0)"
						]
					]
				]
				ownedTools += DirectEditLabel.create [
					name = "Edit EStructuralFeature Name"
					mask = EditMaskVariables.create [
						mask = "{0}"
					]
					initialOperation = InitialOperation.create [
						firstModelOperations = ChangeContext.create [
							browseExpression = "service:performEditAsAttribute(arg0)"
						]
					]
				]
				ownedTools += DirectEditLabel.create [
					name = "EReference Name"
					mask = EditMaskVariables.create [
						mask = "{0}"
					]
					initialOperation = InitialOperation.create [
						firstModelOperations = ChangeContext.create [
							browseExpression = "service:performEdit(arg0)"
						]
					]
				]
				ownedTools += DirectEditLabel.create [
					documentation = "- \"name\" : change the name of the operation"
					name = "Operation Name"
					forceRefresh = true
					mask = EditMaskVariables.create [
						mask = "{0}"
					]
					initialOperation = InitialOperation.create [
						firstModelOperations = ChangeContext.create [
							browseExpression = "service:performEdit(arg0)"
						]
					]
				]
				ownedTools += DoubleClickDescription.create [
					name = "ShowPropertiesView"
					mappings += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass") ]
					mappings += NodeMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("EC EAttribute") ]
					mappings += NodeMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("Operation") ]
					mappings += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EDataType") ]
					mappings += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EEnum") ]
					mappings += NodeMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EEnum").subNodeMappings.at("EC EEnumLiteral") ]
					mappings += NodeMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("EC EReferenceNode") ]
					mappings += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).additionalLayers.at("Package").containerMappings.at("Dropped Package") ]
					element = ElementDoubleClickVariable.create [
						name = "element"
					]
					elementView = ElementDoubleClickVariable.create [
						name = "elementView"
					]
					initialOperation = InitialOperation.create [
						firstModelOperations = ChangeContext.create [
							browseExpression = "var:element"
							subModelOperations += DialogModelOperation.create [
								titleExpression = "aql:'Properties for '  + input.emfEditServices(self).getText()"
								buttons += DialogButton.create [
									labelExpression = "Cancel"
									closeDialogOnClick = true
									rollbackChangesOnClose = true
									initialOperation = InitialOperation.create [
										firstModelOperations = ChangeContext.create [
											browseExpression = "var:self"
										]
									]
								]
								buttons += DialogButton.create [
									labelExpression = "OK"
									^default = true
									closeDialogOnClick = true
									initialOperation = InitialOperation.create [
										firstModelOperations = ChangeContext.create [
											browseExpression = "var:self"
										]
									]
								]
								page = PageDescription.create [
									name = "Default Page"
									labelExpression = "aql:input.emfEditServices(self).getText()"
									semanticCandidateExpression = "var:self"
									extends = PageDescription.ref("DefaultViewExtension") [ (it as ViewExtensionDescription).categories.head.pages.get(0) ]
								]
							]
						]
					]
				]
				ownedTools += DirectEditLabel.create [
					documentation = "- \"name\" : change the name of the operation"
					name = "InstanceClassName"
					forceRefresh = true
					mask = EditMaskVariables.create [
						mask = "{0}"
					]
					initialOperation = InitialOperation.create [
						firstModelOperations = SetValue.create [
							featureName = "instanceClassName"
							valueExpression = "var:arg0"
						]
					]
				]
				ownedTools += DirectEditLabel.create [
					name = "Edit Name no CamelCase"
					mask = EditMaskVariables.create [
						mask = "{0}"
					]
					initialOperation = InitialOperation.create [
						firstModelOperations = SetValue.create [
							featureName = "name"
							valueExpression = "var:arg0"
						]
					]
				]
				ownedTools += DirectEditLabel.create [
					name = "Direct Edit EOpposite"
					mask = EditMaskVariables.create [
						mask = "{0}"
					]
					initialOperation = InitialOperation.create [
						firstModelOperations = ChangeContext.create [
							browseExpression = "var:self"
						]
					]
				]
			]
			toolSections += ToolSection.create [
				name = "Help"
				label = "Help"
				ownedTools += OperationAction.create [
					name = "Open Entities User Guide"
					label = "Open User Guide"
					view = ContainerViewVariable.create [
						name = "views"
					]
					initialOperation = InitialOperation.create [
						firstModelOperations = ExternalJavaAction.create [
							name = "Open Entities User Guide Action"
							id = "org.eclipse.sirius.ui.business.api.action.openHelpSection"
							parameters += ExternalJavaActionParameter.create [
								name = "href"
								value = "/org.eclipse.emf.ecoretools.doc/doc/EcoreTools User Manual.html#EntitiesDiagramEditor"
							]
						]
					]
				]
			]
			toolSections += ToolSection.create [
				name = "Dynamic"
				ownedTools += ToolDescription.create [
					name = "Dynamic instance"
					precondition = "service:isEClass"
					iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/DynamicInstance.gif"
					element = ElementVariable.create [
						name = "element"
					]
					elementView = ElementViewVariable.create [
						name = "elementView"
					]
					initialOperation = InitialOperation.create [
						firstModelOperations = ExternalJavaAction.create [
							name = "Create dynamic instance of a specified EClass"
							id = "org.eclipse.emf.ecoretools.design.action.createDynamicInstanceActionID"
							parameters += ExternalJavaActionParameter.create [
								name = "eClass"
								value = "var:element"
							]
						]
					]
				]
			]
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
						appliedOn += CenterLabelStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.edgeMappings.at("EC_EReference").style.centerLabelStyleDescription ]
						appliedOn += BundledImageDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("EC EAttribute").style as BundledImageDescription ]
						appliedOn += BeginLabelStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.edgeMappings.at("Bi-directional EC_EReference ").style.beginLabelStyleDescription ]
						appliedOn += EndLabelStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.edgeMappings.at("Bi-directional EC_EReference ").style.endLabelStyleDescription ]
						appliedOn += BundledImageDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("EC EReferenceNode").style as BundledImageDescription ]
						appliedOn += BundledImageDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("EC EReferenceNode").conditionnalStyles.head.style as BundledImageDescription ]
					]
					featureCustomizations += EReferenceCustomization.create [
						referenceName = "strokeColor"
						appliedOn += EdgeStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.edgeMappings.at("Bi-directional EC_EReference ").style ]
						appliedOn += EdgeStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.edgeMappings.at("EC_EReference").style ]
						value = Environment.extraRef("$0").systemColors.entries.at("black")
					]
				]
				vsmElementCustomizations += VSMElementCustomization.create [
					predicateExpression = "feature:containment"
					featureCustomizations += EAttributeCustomization.create [
						attributeName = "sourceArrow"
						value = "service:arrowsFillDiamond"
						appliedOn += EdgeStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.edgeMappings.at("EC_EReference").style ]
						appliedOn += EdgeStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.edgeMappings.at("Bi-directional EC_EReference ").style ]
					]
					featureCustomizations += EAttributeCustomization.create [
						attributeName = "sizeComputationExpression"
						value = "1"
						appliedOn += EdgeStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.edgeMappings.at("EC_EReference").style ]
						appliedOn += EdgeStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.edgeMappings.at("Bi-directional EC_EReference ").style ]
					]
				]
				vsmElementCustomizations += VSMElementCustomization.create [
					predicateExpression = "feature:container"
					featureCustomizations += EAttributeCustomization.create [
						attributeName = "targetArrow"
						value = "service:arrowsFillDiamond"
						appliedOn += EdgeStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.edgeMappings.at("EC_EReference").style ]
						appliedOn += EdgeStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.edgeMappings.at("Bi-directional EC_EReference ").style ]
					]
					featureCustomizations += EAttributeCustomization.create [
						attributeName = "sizeComputationExpression"
						value = "1"
						appliedOn += EdgeStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.edgeMappings.at("EC_EReference").style ]
						appliedOn += EdgeStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.edgeMappings.at("Bi-directional EC_EReference ").style ]
					]
				]
				vsmElementCustomizations += VSMElementCustomization.create [
					predicateExpression = "feature:derived"
					featureCustomizations += EReferenceCustomization.create [
						referenceName = "strokeColor"
						appliedOn += EdgeStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.edgeMappings.at("EC_EReference").style ]
						appliedOn += EdgeStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.edgeMappings.at("Bi-directional EC_EReference ").style ]
						value = Environment.extraRef("$0").systemColors.entries.at("blue")
					]
					featureCustomizations += EReferenceCustomization.create [
						referenceName = "labelColor"
						appliedOn += BeginLabelStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.edgeMappings.at("Bi-directional EC_EReference ").style.beginLabelStyleDescription ]
						appliedOn += EndLabelStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.edgeMappings.at("Bi-directional EC_EReference ").style.endLabelStyleDescription ]
						appliedOn += CenterLabelStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.edgeMappings.at("EC_EReference").style.centerLabelStyleDescription ]
						appliedOn += BundledImageDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("EC EAttribute").style as BundledImageDescription ]
						appliedOn += BundledImageDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("EC EReferenceNode").style as BundledImageDescription ]
						appliedOn += BundledImageDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("EC EReferenceNode").conditionnalStyles.head.style as BundledImageDescription ]
						value = Environment.extraRef("$0").systemColors.entries.at("dark_blue")
					]
				]
			]
		]
		additionalLayers += AdditionalLayer.create [
			endUserDocumentation = "Add support for sub-packages."
			name = "Package"
			activeByDefault = true
			containerMappings += ContainerMapping.create [
				name = "Dropped Package"
				createElements = false
				domainClass = "ecore.EPackage"
				detailDescriptions += DiagramCreationDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.toolSections.get(3).ownedTools.at(DiagramCreationDescription, "New Package Entities") ]
				pasteDescriptions += PasteDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.toolSections.get(0).ownedTools.at(PasteDescription, "Paste Anything") ]
				labelDirectEdit = DirectEditLabel.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.toolSections.get(5).ownedTools.at(DirectEditLabel, "Edit Name no CamelCase") ]
				dropDescriptions += ContainerDropDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).additionalLayers.at("Package").toolSections.head.ownedTools.at(ContainerDropDescription, "Drop EClassifier into EPackage") ]
				dropDescriptions += ContainerDropDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).additionalLayers.at("Package").toolSections.head.ownedTools.at(ContainerDropDescription, "Drop EPackage into EPackage") ]
				reusedContainerMappings += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass") ]
				reusedContainerMappings += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EDataType") ]
				reusedContainerMappings += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EEnum") ]
				style = FlatContainerStyleDescription.create [
					arcWidth = 1
					arcHeight = 1
					borderSizeComputationExpression = "1"
					labelExpression = "aql:self.name"
					labelAlignment = LabelAlignment.LEFT
					widthComputationExpression = "24"
					heightComputationExpression = "16"
					backgroundStyle = BackgroundStyle.LIQUID_LITERAL
					borderColor = UserFixedColor.ref("ToolDesign") [ (it as Group).userColorsPalettes.at("Ecore Palette").entries.at(UserFixedColor, "Dark EPackage") ]
					labelColor = Environment.extraRef("$0").systemColors.entries.at("black")
					backgroundColor = Environment.extraRef("$0").systemColors.entries.at("white")
					foregroundColor = UserFixedColor.ref("ToolDesign") [ (it as Group).userColorsPalettes.at("Ecore Palette").entries.at(UserFixedColor, "EPackage") ]
					labelBorderStyle = Environment.extraRef("$0").labelBorderStyles.labelBorderStyleDescriptions.get(0)
				]
			]
			toolSections += ToolSection.create [
				name = "Package"
				ownedTools += ContainerCreationDescription.create [
					name = "Package"
					containerMappings += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).additionalLayers.at("Package").containerMappings.at("Dropped Package") ]
					variable = NodeCreationVariable.create [
						name = "container"
					]
					viewVariable = ContainerViewVariable.create [
						name = "containerView"
					]
					initialOperation = InitialNodeCreationOperation.create [
						firstModelOperations = CreateInstance.create [
							typeName = "ecore.EPackage"
							referenceName = "eSubpackages"
							variableName = "newPackage"
							subModelOperations += ChangeContext.create [
								browseExpression = "var:newPackage"
								subModelOperations += SetValue.create [
									featureName = "name"
									valueExpression = "aql:'newPackage' + self.eContainer().eContents(ecore::EPackage)->size()"
								]
							]
						]
					]
				]
				ownedTools += ContainerDropDescription.create [
					name = "Drop EClassifier into EPackage"
					mappings += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass") ]
					mappings += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EDataType") ]
					mappings += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EEnum") ]
					mappings += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).additionalLayers.at("Related EClasses").containerMappings.at("EC External EClasses") ]
					oldContainer = DropContainerVariable.create [
						name = "oldSemanticContainer"
					]
					newContainer = DropContainerVariable.create [
						name = "newSemanticContainer"
					]
					element = ElementDropVariable.create [
						name = "element"
					]
					newViewContainer = ContainerViewVariable.create [
						name = "newContainerView"
					]
					initialOperation = InitialContainerDropOperation.create [
						firstModelOperations = ChangeContext.create [
							browseExpression = "var:newSemanticContainer"
							subModelOperations += SetValue.create [
								featureName = "eClassifiers"
								valueExpression = "var:element"
							]
						]
					]
				]
				ownedTools += ContainerDropDescription.create [
					name = "Drop EPackage into EPackage"
					dragSource = DragSource.BOTH_LITERAL
					mappings += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).additionalLayers.at("Package").containerMappings.at("Dropped Package") ]
					oldContainer = DropContainerVariable.create [
						name = "oldSemanticContainer"
					]
					newContainer = DropContainerVariable.create [
						name = "newSemanticContainer"
					]
					element = ElementDropVariable.create [
						name = "element"
					]
					newViewContainer = ContainerViewVariable.create [
						name = "newContainerView"
					]
					initialOperation = InitialContainerDropOperation.create [
						firstModelOperations = ChangeContext.create [
							browseExpression = "var:newSemanticContainer"
							subModelOperations += SetValue.create [
								featureName = "eSubpackages"
								valueExpression = "var:element"
								subModelOperations += CreateView.create [
									containerViewExpression = "var:newContainerView"
									mapping = ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).additionalLayers.at("Package").containerMappings.at("Dropped Package") ]
								]
							]
						]
					]
				]
			]
		]
		additionalLayers += AdditionalLayer.create [
			name = "Documentation"
			nodeMappings += NodeMapping.create [
				name = "EC Doc Annotation"
				semanticCandidatesExpression = "service:getVisibleDocAnnotations(diagram)"
				domainClass = "ecore.EStringToStringMapEntry"
				labelDirectEdit = DirectEditLabel.ref("EntitiesDiagram") [ (it as DiagramDescription).additionalLayers.at("Documentation").toolSections.head.ownedTools.at(DirectEditLabel, "Edit Detail") ]
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
					borderColor = Environment.extraRef("$0").systemColors.entries.at("gray")
					labelColor = Environment.extraRef("$0").systemColors.entries.at("black")
					color = UserFixedColor.ref("ToolDesign") [ (it as Group).userColorsPalettes.at("Ecore Palette").entries.at(UserFixedColor, "Doc Annotation") ]
				]
			]
			edgeMappings += EdgeMapping.create [
				name = "EC Doc Assignment"
				semanticCandidatesExpression = "aql:self.eAllContents()"
				targetFinderExpression = "service:eContainerEContainer"
				sourceMapping += NodeMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).additionalLayers.at("Documentation").nodeMappings.at("EC Doc Annotation") ]
				targetMapping += EdgeMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.edgeMappings.at("EC_EReference") ]
				targetMapping += EdgeMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.edgeMappings.at("Bi-directional EC_EReference ") ]
				targetMapping += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass") ]
				targetMapping += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).additionalLayers.at("Package").containerMappings.at("Dropped Package") ]
				targetMapping += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EDataType") ]
				targetMapping += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EEnum") ]
				style = EdgeStyleDescription.create [
					lineStyle = LineStyle.DOT_LITERAL
					strokeColor = Environment.extraRef("$0").systemColors.entries.at("black")
					centerLabelStyleDescription = CenterLabelStyleDescription.create [
						showIcon = false
						labelColor = Environment.extraRef("$0").systemColors.entries.at("black")
					]
				]
			]
			toolSections += ToolSection.create [
				name = "Documentation"
				ownedTools += NodeCreationDescription.create [
					name = "Doc Annotation"
					iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/EAnnotation_24.gif"
					nodeMappings += NodeMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).additionalLayers.at("Documentation").nodeMappings.at("EC Doc Annotation") ]
					extraMappings += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass") ]
					extraMappings += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EDataType") ]
					extraMappings += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EEnum") ]
					extraMappings += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).additionalLayers.at("Package").containerMappings.at("Dropped Package") ]
					variable = NodeCreationVariable.create [
						name = "container"
					]
					viewVariable = ContainerViewVariable.create [
						name = "containerView"
					]
					initialOperation = InitialNodeCreationOperation.create [
						firstModelOperations = ChangeContext.create [
							browseExpression = "var:container"
							subModelOperations += If.create [
								conditionExpression = "aql:self.eAnnotations->select(a | a.source = 'http://www.eclipse.org/emf/2002/GenModel')->size() = 0"
								subModelOperations += CreateInstance.create [
									typeName = "ecore.EAnnotation"
									referenceName = "eAnnotations"
									subModelOperations += SetValue.create [
										featureName = "source"
										valueExpression = "aql:'http://www.eclipse.org/emf/2002/GenModel'"
									]
								]
							]
							subModelOperations += ChangeContext.create [
								browseExpression = "aql:self.eAnnotations->select(a | a.source = 'http://www.eclipse.org/emf/2002/GenModel')->asSequence()->first()"
								subModelOperations += If.create [
									conditionExpression = "aql:self.details->select(a | a.key = 'documentation')->size() = 0"
									subModelOperations += CreateInstance.create [
										typeName = "ecore.EStringToStringMapEntry"
										referenceName = "details"
										subModelOperations += SetValue.create [
											featureName = "key"
											valueExpression = "aql:'documentation'"
										]
									]
								]
								subModelOperations += ChangeContext.create [
									browseExpression = "aql:self.details->select(a | a.key = 'documentation')->asSequence()->first()"
									subModelOperations += SetValue.create [
										featureName = "value"
										valueExpression = "aql:'New documentation note'"
									]
								]
							]
						]
					]
				]
				ownedTools += DirectEditLabel.create [
					name = "Edit Detail"
					mask = EditMaskVariables.create [
						mask = "{0}"
					]
					initialOperation = InitialOperation.create [
						firstModelOperations = SetValue.create [
							featureName = "value"
							valueExpression = "var:arg0"
						]
					]
				]
				ownedTools += EdgeCreationDescription.create [
					name = "Doc Assignment"
					forceRefresh = true
					iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/AnnotationLink.gif"
					edgeMappings += EdgeMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).additionalLayers.at("Documentation").edgeMappings.at("EC Doc Assignment") ]
					sourceVariable = SourceEdgeCreationVariable.create [
						name = "source"
					]
					targetVariable = TargetEdgeCreationVariable.create [
						name = "target"
					]
					sourceViewVariable = SourceEdgeViewCreationVariable.create [
						name = "sourceView"
					]
					targetViewVariable = TargetEdgeViewCreationVariable.create [
						name = "targetView"
					]
					initialOperation = InitEdgeCreationOperation.create [
						firstModelOperations = ChangeContext.create [
							browseExpression = "aql:source.eContainer(ecore::EAnnotation)"
							subModelOperations += MoveElement.create [
								newContainerExpression = "var:target"
								featureName = "eAnnotations"
							]
						]
					]
				]
			]
			customization = Customization.create [
				vsmElementCustomizations += VSMElementCustomization.create [
					predicateExpression = "service:hasNoDocAnnotation"
					featureCustomizations += EReferenceCustomization.create [
						referenceName = "labelColor"
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").style as FlatContainerStyleDescription ]
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").conditionnalStyles.get(1).style as FlatContainerStyleDescription ]
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").conditionnalStyles.get(0).style as FlatContainerStyleDescription ]
						appliedOn += CenterLabelStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.edgeMappings.at("EC_EReference").style.centerLabelStyleDescription ]
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EDataType").style as FlatContainerStyleDescription ]
						value = Environment.extraRef("$0").systemColors.entries.at("red")
					]
					featureCustomizations += EReferenceCustomization.create [
						referenceName = "borderColor"
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").style as FlatContainerStyleDescription ]
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").conditionnalStyles.get(1).style as FlatContainerStyleDescription ]
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").conditionnalStyles.get(0).style as FlatContainerStyleDescription ]
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EDataType").style as FlatContainerStyleDescription ]
						value = Environment.extraRef("$0").systemColors.entries.at("red")
					]
					featureCustomizations += EReferenceCustomization.create [
						referenceName = "strokeColor"
						appliedOn += EdgeStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.edgeMappings.at("Bi-directional EC_EReference ").style ]
						appliedOn += EdgeStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.edgeMappings.at("EC_EReference").style ]
						value = Environment.extraRef("$0").systemColors.entries.at("red")
					]
				]
			]
		]
		additionalLayers += AdditionalLayer.create [
			name = "Validation"
			activeByDefault = true
			customization = Customization.create [
				vsmElementCustomizations += VSMElementCustomization.create [
					predicateExpression = "service:hasError"
					featureCustomizations += EReferenceCustomization.create [
						referenceName = "labelColor"
						appliedOn += BundledImageDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("EC EAttribute").style as BundledImageDescription ]
						appliedOn += BundledImageDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("Operation").style as BundledImageDescription ]
						appliedOn += CenterLabelStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.edgeMappings.at("EC_EReference").style.centerLabelStyleDescription ]
						appliedOn += CenterLabelStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.edgeMappings.at("EC ESupertypes").style.centerLabelStyleDescription ]
						appliedOn += CenterLabelStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.edgeMappings.at("EC ESupertypes").conditionnalStyles.get(0).style.centerLabelStyleDescription ]
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").conditionnalStyles.get(1).style as FlatContainerStyleDescription ]
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").conditionnalStyles.get(0).style as FlatContainerStyleDescription ]
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").style as FlatContainerStyleDescription ]
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EDataType").style as FlatContainerStyleDescription ]
						value = Environment.extraRef("$0").systemColors.entries.at("red")
					]
					featureCustomizations += EReferenceCustomization.create [
						referenceName = "borderColor"
						appliedOn += BundledImageDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("EC EAttribute").style as BundledImageDescription ]
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").style as FlatContainerStyleDescription ]
						appliedOn += BundledImageDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("Operation").style as BundledImageDescription ]
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").conditionnalStyles.get(1).style as FlatContainerStyleDescription ]
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").conditionnalStyles.get(0).style as FlatContainerStyleDescription ]
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EDataType").style as FlatContainerStyleDescription ]
						value = Environment.extraRef("$0").systemColors.entries.at("red")
					]
					featureCustomizations += EReferenceCustomization.create [
						referenceName = "strokeColor"
						appliedOn += EdgeStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.edgeMappings.at("Bi-directional EC_EReference ").style ]
						appliedOn += EdgeStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.edgeMappings.at("EC_EReference").style ]
						value = Environment.extraRef("$0").systemColors.entries.at("red")
					]
				]
			]
		]
		additionalLayers += AdditionalLayer.create [
			name = "Constraint"
			nodeMappings += NodeMapping.create [
				name = "EC Constraint Annotation"
				semanticCandidatesExpression = "service:getVisibleConstraintsAnnotations(diagram)"
				domainClass = "ecore.EStringToStringMapEntry"
				labelDirectEdit = DirectEditLabel.ref("EntitiesDiagram") [ (it as DiagramDescription).additionalLayers.at("Documentation").toolSections.head.ownedTools.at(DirectEditLabel, "Edit Detail") ]
				style = SquareDescription.create [
					borderSizeComputationExpression = "1"
					showIcon = false
					labelExpression = "feature:value"
					sizeComputationExpression = "1"
					labelPosition = LabelPosition.NODE_LITERAL
					resizeKind = ResizeKind.NSEW_LITERAL
					width = 12
					height = 5
					borderColor = Environment.extraRef("$0").systemColors.entries.at("dark_blue")
					labelColor = Environment.extraRef("$0").systemColors.entries.at("white")
					color = Environment.extraRef("$0").systemColors.entries.at("blue")
				]
			]
			edgeMappings += EdgeMapping.create [
				name = "EC Constraint Assignment"
				semanticCandidatesExpression = "aql:self.eAllContents()"
				targetFinderExpression = "service:eContainerEContainer"
				sourceMapping += NodeMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).additionalLayers.at("Constraint").nodeMappings.at("EC Constraint Annotation") ]
				targetMapping += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass") ]
				targetMapping += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EDataType") ]
				targetMapping += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EEnum") ]
				style = EdgeStyleDescription.create [
					lineStyle = LineStyle.DOT_LITERAL
					strokeColor = Environment.extraRef("$0").systemColors.entries.at("dark_blue")
					centerLabelStyleDescription = CenterLabelStyleDescription.create [
						showIcon = false
						labelColor = Environment.extraRef("$0").systemColors.entries.at("black")
					]
				]
			]
			toolSections += ToolSection.create [
				name = "Constraints"
				ownedTools += NodeCreationDescription.create [
					name = "Constraint"
					iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/EAnnotation_24.gif"
					nodeMappings += NodeMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).additionalLayers.at("Constraint").nodeMappings.at("EC Constraint Annotation") ]
					extraMappings += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass") ]
					extraMappings += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EDataType") ]
					extraMappings += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EEnum") ]
					extraMappings += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).additionalLayers.at("Package").containerMappings.at("Dropped Package") ]
					variable = NodeCreationVariable.create [
						name = "container"
					]
					viewVariable = ContainerViewVariable.create [
						name = "containerView"
					]
					initialOperation = InitialNodeCreationOperation.create [
						firstModelOperations = ChangeContext.create [
							browseExpression = "var:container"
							subModelOperations += If.create [
								conditionExpression = "aql:self.eAnnotations->select(a | a.source = 'http://www.eclipse.org/emf/2002/Ecore')->size() = 0"
								subModelOperations += CreateInstance.create [
									typeName = "ecore.EAnnotation"
									referenceName = "eAnnotations"
									subModelOperations += SetValue.create [
										featureName = "source"
										valueExpression = "aql:'http://www.eclipse.org/emf/2002/Ecore'"
									]
								]
							]
							subModelOperations += ChangeContext.create [
								browseExpression = "aql:self.eAnnotations->select(a | a.source = 'http://www.eclipse.org/emf/2002/Ecore')->asSequence()->first()"
								subModelOperations += If.create [
									conditionExpression = "aql:self.details->select(a | a.key = 'constraints')->size() = 0"
									subModelOperations += CreateInstance.create [
										typeName = "ecore.EStringToStringMapEntry"
										referenceName = "details"
										subModelOperations += SetValue.create [
											featureName = "key"
											valueExpression = "aql:'constraints'"
										]
									]
								]
								subModelOperations += ChangeContext.create [
									browseExpression = "aql:self.details->select(a | a.key = 'constraints')->asSequence()->first()"
									subModelOperations += SetValue.create [
										featureName = "value"
										valueExpression = "aql:'Constraint1 Constraint2'"
									]
								]
							]
						]
					]
				]
				ownedTools += EdgeCreationDescription.create [
					name = "Constraint Assignment"
					forceRefresh = true
					iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/AnnotationLink.gif"
					edgeMappings += EdgeMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).additionalLayers.at("Constraint").edgeMappings.at("EC Constraint Assignment") ]
					sourceVariable = SourceEdgeCreationVariable.create [
						name = "source"
					]
					targetVariable = TargetEdgeCreationVariable.create [
						name = "target"
					]
					sourceViewVariable = SourceEdgeViewCreationVariable.create [
						name = "sourceView"
					]
					targetViewVariable = TargetEdgeViewCreationVariable.create [
						name = "targetView"
					]
					initialOperation = InitEdgeCreationOperation.create [
						firstModelOperations = ChangeContext.create [
							browseExpression = "aql:source.eContainer(ecore::EAnnotation)"
							subModelOperations += MoveElement.create [
								newContainerExpression = "var:target"
								featureName = "eAnnotations"
							]
						]
					]
				]
			]
		]
		additionalLayers += AdditionalLayer.create [
			name = "Related EClasses"
			containerMappings += ContainerMapping.create [
				name = "EC External EClasses"
				semanticCandidatesExpression = "service:getExternalEClasses(diagram)"
				domainClass = "ecore.EClass"
				childrenPresentation = ContainerLayout.LIST
				deletionDescription = DeleteElementDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.toolSections.get(1).ownedTools.at(DeleteElementDescription, "NoOp") ]
				labelDirectEdit = DirectEditLabel.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.toolSections.get(5).ownedTools.at(DirectEditLabel, "Edit Name with CamelCase") ]
				reusedBorderedNodeMappings += NodeMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").borderedNodeMappings.at("EC ETypeParameter") ]
				dropDescriptions += ContainerDropDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.toolSections.get(2).ownedTools.at(ContainerDropDescription, "Drop attribute") ]
				dropDescriptions += ContainerDropDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.toolSections.get(2).ownedTools.at(ContainerDropDescription, "Drop operation") ]
				reusedNodeMappings += NodeMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("EC EAttribute") ]
				reusedNodeMappings += NodeMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("Operation") ]
				style = FlatContainerStyleDescription.create [
					arcWidth = 8
					arcHeight = 8
					borderSizeComputationExpression = "1"
					tooltipExpression = "service:renderTooltip"
					roundedCorner = true
					backgroundStyle = BackgroundStyle.LIQUID_LITERAL
					borderColor = Environment.extraRef("$0").systemColors.entries.at("black")
					labelColor = Environment.extraRef("$0").systemColors.entries.at("black")
					backgroundColor = Environment.extraRef("$0").systemColors.entries.at("white")
					foregroundColor = UserFixedColor.ref("ToolDesign") [ (it as Group).userColorsPalettes.at("Ecore Palette").entries.at(UserFixedColor, "EClass") ]
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
						borderColor = UserFixedColor.ref("ToolDesign") [ (it as Group).userColorsPalettes.at("Ecore Palette").entries.at(UserFixedColor, "Dark EClass") ]
						labelColor = Environment.extraRef("$0").systemColors.entries.at("black")
						backgroundColor = Environment.extraRef("$0").systemColors.entries.at("white")
						foregroundColor = UserFixedColor.ref("ToolDesign") [ (it as Group).userColorsPalettes.at("Ecore Palette").entries.at(UserFixedColor, "Abstract EClass") ]
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
						borderColor = UserFixedColor.ref("ToolDesign") [ (it as Group).userColorsPalettes.at("Ecore Palette").entries.at(UserFixedColor, "Dark EClass") ]
						labelColor = Environment.extraRef("$0").systemColors.entries.at("black")
						backgroundColor = Environment.extraRef("$0").systemColors.entries.at("white")
						foregroundColor = UserFixedColor.ref("ToolDesign") [ (it as Group).userColorsPalettes.at("Ecore Palette").entries.at(UserFixedColor, "Abstract EClass") ]
					]
				]
			]
		]
		additionalLayers += AdditionalLayer.create [
			name = "Icons Preview"
			icon = "/org.eclipse.emf.ecoretools.design/icons/full/etools16/image.gif"
			customization = Customization.create [
				vsmElementCustomizations += VSMElementCustomization.create [
					predicateExpression = "aql:self.oclIsKindOf(ecore::EClass) and self.eInverse(genmodel::GenClass) <> null"
					featureCustomizations += EAttributeCustomization.create [
						attributeName = "iconPath"
						value = "aql:self.eInverse(genmodel::GenClass).getEClassItemIconPath()->first()"
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").conditionnalStyles.get(1).style as FlatContainerStyleDescription ]
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").conditionnalStyles.get(0).style as FlatContainerStyleDescription ]
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").style as FlatContainerStyleDescription ]
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).additionalLayers.at("Related EClasses").containerMappings.at("EC External EClasses").conditionnalStyles.get(1).style as FlatContainerStyleDescription ]
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).additionalLayers.at("Related EClasses").containerMappings.at("EC External EClasses").conditionnalStyles.get(0).style as FlatContainerStyleDescription ]
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).additionalLayers.at("Related EClasses").containerMappings.at("EC External EClasses").style as FlatContainerStyleDescription ]
					]
				]
			]
		]
	}

}
