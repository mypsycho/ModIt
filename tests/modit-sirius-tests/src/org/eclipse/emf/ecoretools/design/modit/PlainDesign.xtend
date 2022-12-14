package org.eclipse.emf.ecoretools.design.modit

import java.lang.Class
import java.util.HashMap
import org.eclipse.emf.common.util.EList
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.emf.ecore.util.EcoreEList
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
import org.eclipse.sirius.diagram.description.DiagramExtensionDescription
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
import org.eclipse.sirius.properties.ButtonDescription
import org.eclipse.sirius.properties.Category
import org.eclipse.sirius.properties.CheckboxDescription
import org.eclipse.sirius.properties.CheckboxWidgetConditionalStyle
import org.eclipse.sirius.properties.CheckboxWidgetStyle
import org.eclipse.sirius.properties.ContainerDescription
import org.eclipse.sirius.properties.DialogButton
import org.eclipse.sirius.properties.DialogModelOperation
import org.eclipse.sirius.properties.DynamicMappingForDescription
import org.eclipse.sirius.properties.DynamicMappingIfDescription
import org.eclipse.sirius.properties.FILL_LAYOUT_ORIENTATION
import org.eclipse.sirius.properties.FillLayoutDescription
import org.eclipse.sirius.properties.GridLayoutDescription
import org.eclipse.sirius.properties.GroupConditionalStyle
import org.eclipse.sirius.properties.GroupDescription
import org.eclipse.sirius.properties.GroupStyle
import org.eclipse.sirius.properties.GroupValidationSetDescription
import org.eclipse.sirius.properties.HyperlinkDescription
import org.eclipse.sirius.properties.LabelDescription
import org.eclipse.sirius.properties.LabelWidgetStyle
import org.eclipse.sirius.properties.ListDescription
import org.eclipse.sirius.properties.PageDescription
import org.eclipse.sirius.properties.PageValidationSetDescription
import org.eclipse.sirius.properties.RadioDescription
import org.eclipse.sirius.properties.RadioWidgetConditionalStyle
import org.eclipse.sirius.properties.RadioWidgetStyle
import org.eclipse.sirius.properties.TextAreaDescription
import org.eclipse.sirius.properties.TextDescription
import org.eclipse.sirius.properties.TextWidgetConditionalStyle
import org.eclipse.sirius.properties.TextWidgetStyle
import org.eclipse.sirius.properties.TitleBarStyle
import org.eclipse.sirius.properties.ToggleStyle
import org.eclipse.sirius.properties.ToolbarAction
import org.eclipse.sirius.properties.ViewExtensionDescription
import org.eclipse.sirius.properties.WidgetAction
import org.eclipse.sirius.properties.ext.widgets.reference.propertiesextwidgetsreference.ExtReferenceDescription
import org.eclipse.sirius.table.metamodel.table.description.BackgroundConditionalStyle
import org.eclipse.sirius.table.metamodel.table.description.BackgroundStyleDescription
import org.eclipse.sirius.table.metamodel.table.description.CreateCellTool
import org.eclipse.sirius.table.metamodel.table.description.CreateLineTool
import org.eclipse.sirius.table.metamodel.table.description.CrossTableDescription
import org.eclipse.sirius.table.metamodel.table.description.EditionTableDescription
import org.eclipse.sirius.table.metamodel.table.description.ElementColumnMapping
import org.eclipse.sirius.table.metamodel.table.description.FeatureColumnMapping
import org.eclipse.sirius.table.metamodel.table.description.ForegroundConditionalStyle
import org.eclipse.sirius.table.metamodel.table.description.ForegroundStyleDescription
import org.eclipse.sirius.table.metamodel.table.description.IntersectionMapping
import org.eclipse.sirius.table.metamodel.table.description.LabelEditTool
import org.eclipse.sirius.table.metamodel.table.description.LineMapping
import org.eclipse.sirius.table.metamodel.table.description.TableVariable
import org.eclipse.sirius.viewpoint.FontFormat
import org.eclipse.sirius.viewpoint.LabelAlignment
import org.eclipse.sirius.viewpoint.description.Customization
import org.eclipse.sirius.viewpoint.description.DecorationDescriptionsSet
import org.eclipse.sirius.viewpoint.description.DecorationDistributionDirection
import org.eclipse.sirius.viewpoint.description.EAttributeCustomization
import org.eclipse.sirius.viewpoint.description.EReferenceCustomization
import org.eclipse.sirius.viewpoint.description.Environment
import org.eclipse.sirius.viewpoint.description.Group
import org.eclipse.sirius.viewpoint.description.InterpolatedColor
import org.eclipse.sirius.viewpoint.description.JavaExtension
import org.eclipse.sirius.viewpoint.description.Position
import org.eclipse.sirius.viewpoint.description.SemanticBasedDecoration
import org.eclipse.sirius.viewpoint.description.SystemColor
import org.eclipse.sirius.viewpoint.description.SytemColorsPalette
import org.eclipse.sirius.viewpoint.description.UserColorsPalette
import org.eclipse.sirius.viewpoint.description.UserFixedColor
import org.eclipse.sirius.viewpoint.description.VSMElementCustomization
import org.eclipse.sirius.viewpoint.description.Viewpoint
import org.eclipse.sirius.viewpoint.description.style.LabelBorderStyleDescription
import org.eclipse.sirius.viewpoint.description.style.LabelBorderStyles
import org.eclipse.sirius.viewpoint.description.tool.AcceleoVariable
import org.eclipse.sirius.viewpoint.description.tool.Case
import org.eclipse.sirius.viewpoint.description.tool.ChangeContext
import org.eclipse.sirius.viewpoint.description.tool.ContainerViewVariable
import org.eclipse.sirius.viewpoint.description.tool.CreateInstance
import org.eclipse.sirius.viewpoint.description.tool.Default
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
import org.eclipse.sirius.viewpoint.description.tool.Let
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
import org.eclipse.sirius.viewpoint.description.tool.Switch
import org.eclipse.sirius.viewpoint.description.tool.ToolDescription
import org.eclipse.sirius.viewpoint.description.tool.Unset
import org.eclipse.sirius.viewpoint.description.validation.ERROR_LEVEL
import org.eclipse.sirius.viewpoint.description.validation.RuleAudit
import org.eclipse.sirius.viewpoint.description.validation.SemanticValidationRule
import org.eclipse.sirius.viewpoint.description.validation.ValidationFix
import org.eclipse.sirius.viewpoint.description.validation.ValidationSet
import org.eclipse.sirius.viewpoint.description.validation.ViewValidationRule
import org.eclipse.xtend.lib.annotations.Accessors
import org.mypsycho.modit.emf.EModIt
import org.mypsycho.modit.emf.ModitModel

class PlainDesign implements ModitModel {

	@Accessors
	val extras = new HashMap<String, EObject> 

	@Accessors
	protected val extension EModIt factory = EModIt.using(
		org.eclipse.sirius.diagram.description.DescriptionPackage.eINSTANCE,
		org.eclipse.sirius.diagram.description.filter.FilterPackage.eINSTANCE,
		org.eclipse.sirius.diagram.description.style.StylePackage.eINSTANCE,
		org.eclipse.sirius.diagram.description.tool.ToolPackage.eINSTANCE,
		org.eclipse.sirius.properties.PropertiesPackage.eINSTANCE,
		org.eclipse.sirius.properties.ext.widgets.reference.propertiesextwidgetsreference.PropertiesExtWidgetsReferencePackage.eINSTANCE,
		org.eclipse.sirius.table.metamodel.table.description.DescriptionPackage.eINSTANCE,
		org.eclipse.sirius.viewpoint.description.DescriptionPackage.eINSTANCE,
		org.eclipse.sirius.viewpoint.description.tool.ToolPackage.eINSTANCE,
		org.eclipse.sirius.viewpoint.description.validation.ValidationPackage.eINSTANCE
	)

	override loadContent(Resource it) {
		val values = resourceSet.buildModel.roots
		contents += values
		values
	}

	def buildModel() {
		buildModel(new ResourceSetImpl())
	}

	def buildModel(ResourceSet rs) {
		rs.initExtras()
		createContent
	}

	protected def createContent() {
		// provide a ModitPool
		Group.createAs("PlainDesign") [
			name = "EcoreTools"
			version = "12.0.0.2017041100"
			ownedViewpoints += Viewpoint.create [
				endUserDocumentation = "<html>\n<head>\n</head>\n<body>\n<p>Provides graphical and tabular representation to design an Ecore model.</p>\n<br>\n<img src=\"/icons/full/wizban/entities.png\"/>\n<img src=\"/icons/full/wizban/classes.png\"/>\n</body>\n</html>\n\n\n"
				name = "Design"
				modelFileExtension = "ecore xcore ecorebin"
				ownedRepresentations += DiagramDescription.create [
					documentation = "<html>\n<head>\n</head>\n<body>\n<p>Provides a class diagram to represent EClasses, EDatatypes, EAttributes and their relationships.</p>\n<br>\n<img src=\"/icons/full/wizban/entities.png\"/>\n</body>\n</html>\n\n\n"
					endUserDocumentation = "A class diagram to represent EClasses, EDatatypes, EAttributes and their relationships."
					name = "Entities"
					label = "Entities in a Class Diagram"
					titleExpression = "aql:self.name + ' class diagram'"
					domainClass = "ecore.EPackage"
					enablePopupBars = true
					dropDescriptions += ContainerDropDescription.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.toolSections.get(0).ownedTools.at(ContainerDropDescription, "External EClass from treeview") ]
					dropDescriptions += ContainerDropDescription.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").additionalLayers.at("Package").toolSections.head.ownedTools.at(ContainerDropDescription, "Drop EClassifier into EPackage") ]
					metamodel += org.eclipse.emf.ecore.EcorePackage.eINSTANCE
					metamodel += org.eclipse.emf.codegen.ecore.genmodel.GenModelPackage.eINSTANCE
					pasteDescriptions += PasteDescription.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.toolSections.get(0).ownedTools.at(PasteDescription, "Paste Anything") ]
					filters += CompositeFilterDescription.create [
						name = "Hide class content"
						filters += MappingFilter.create [
							mappings += NodeMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("EC EAttribute") ]
							mappings += NodeMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("Operation") ]
						]
					]
					filters += CompositeFilterDescription.create [
						name = "Hide generalizations"
						filters += MappingFilter.create [
							mappings += EdgeMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.edgeMappings.at("EC ESupertypes") ]
						]
					]
					filters += CompositeFilterDescription.create [
						name = "Hide indirect generalizations"
						filters += MappingFilter.create [
							viewConditionExpression = "aql:not self.oclAsType(diagram::DEdge).sourceNode.oclAsType(viewpoint::DSemanticDecorator).target.oclAsType(ecore::EClass).eSuperTypes->includes(self.oclAsType(diagram::DEdge).targetNode.oclAsType(viewpoint::DSemanticDecorator).target)"
							mappings += EdgeMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.edgeMappings.at("EC ESupertypes") ]
						]
					]
					filters += CompositeFilterDescription.create [
						name = "Hide references (edges)"
						filters += MappingFilter.create [
							mappings += EdgeMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.edgeMappings.at("EC_EReference") ]
							mappings += EdgeMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.edgeMappings.at("Bi-directional EC_EReference ") ]
						]
					]
					filters += CompositeFilterDescription.create [
						name = "Hide references (nodes)"
						filters += MappingFilter.create [
							mappings += NodeMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("EC EReferenceNode") ]
						]
					]
					filters += CompositeFilterDescription.create [
						name = "Hide inherited references (nodes)"
						filters += MappingFilter.create [
							viewConditionExpression = "aql:self.eContainer().oclAsType(viewpoint::DSemanticDecorator).target = self.oclAsType(viewpoint::DSemanticDecorator).target.eContainer()"
							mappings += NodeMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("EC EReferenceNode") ]
						]
					]
					filters += CompositeFilterDescription.create [
						name = "Hide derived features"
						filters += MappingFilter.create [
							semanticConditionExpression = "aql:not self.derived"
							mappings += EdgeMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.edgeMappings.at("EC_EReference") ]
							mappings += NodeMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("EC EAttribute") ]
							mappings += EdgeMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.edgeMappings.at("Bi-directional EC_EReference ") ]
							mappings += NodeMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("EC EReferenceNode") ]
						]
					]
					filters += CompositeFilterDescription.create [
						name = "Hide operations"
						filters += MappingFilter.create [
							semanticConditionExpression = ""
							mappings += NodeMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("Operation") ]
						]
					]
					validationSet = ValidationSet.create [
						ownedRules += ViewValidationRule.create [
							name = "Unused EClass"
							message = "aql:'The ' + self.target.oclAsType(ecore::EClass).name +' class is never used'"
							targets += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass") ]
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
							targets += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass") ]
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
							deletionDescription = DeleteElementDescription.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.toolSections.get(1).ownedTools.at(DeleteElementDescription, "NoOp") ]
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
							labelDirectEdit = DirectEditLabel.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.toolSections.get(5).ownedTools.at(DirectEditLabel, "EReference Name") ]
							sourceMapping += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass") ]
							sourceMapping += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").additionalLayers.at("Related EClasses").containerMappings.at("EC External EClasses") ]
							targetMapping += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass") ]
							targetMapping += NodeMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").borderedNodeMappings.at("EC ETypeParameter") ]
							targetMapping += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").additionalLayers.at("Related EClasses").containerMappings.at("EC External EClasses") ]
							reconnections += ReconnectEdgeDescription.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.toolSections.get(4).ownedTools.at(ReconnectEdgeDescription, "ReconnectEReference Source") ]
							reconnections += ReconnectEdgeDescription.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.toolSections.get(4).ownedTools.at(ReconnectEdgeDescription, "ReconnectEReference Target") ]
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
							deletionDescription = DeleteElementDescription.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.toolSections.get(3).ownedTools.at(DeleteElementDescription, "Delete ESuperType") ]
							sourceMapping += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass") ]
							sourceMapping += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").additionalLayers.at("Related EClasses").containerMappings.at("EC External EClasses") ]
							targetMapping += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass") ]
							targetMapping += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").additionalLayers.at("Related EClasses").containerMappings.at("EC External EClasses") ]
							reconnections += ReconnectEdgeDescription.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.toolSections.get(4).ownedTools.at(ReconnectEdgeDescription, "ReconnectESupertypeSource") ]
							reconnections += ReconnectEdgeDescription.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.toolSections.get(4).ownedTools.at(ReconnectEdgeDescription, "ReconnectESupertypeTarget") ]
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
									strokeColor = UserFixedColor.ref("PlainDesign")[ (it as Group).userColorsPalettes.at("Ecore Palette").entries.at(UserFixedColor, "Inherited") ]
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
							labelDirectEdit = DirectEditLabel.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.toolSections.get(5).ownedTools.at(DirectEditLabel, "Direct Edit EOpposite") ]
							sourceMapping += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass") ]
							sourceMapping += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").additionalLayers.at("Related EClasses").containerMappings.at("EC External EClasses") ]
							targetMapping += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass") ]
							targetMapping += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").additionalLayers.at("Related EClasses").containerMappings.at("EC External EClasses") ]
							reconnections += ReconnectEdgeDescription.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.toolSections.get(4).ownedTools.at(ReconnectEdgeDescription, "ReconnectBiDirectionnalEReference Target") ]
							reconnections += ReconnectEdgeDescription.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.toolSections.get(4).ownedTools.at(ReconnectEdgeDescription, "ReconnectBiDirectionnalEReference Source") ]
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
							deletionDescription = DeleteElementDescription.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.toolSections.get(1).ownedTools.at(DeleteElementDescription, "Delete EClass") ]
							labelDirectEdit = DirectEditLabel.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.toolSections.get(5).ownedTools.at(DirectEditLabel, "Edit Name with CamelCase") ]
							dropDescriptions += ContainerDropDescription.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.toolSections.get(2).ownedTools.at(ContainerDropDescription, "Drop attribute") ]
							dropDescriptions += ContainerDropDescription.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.toolSections.get(2).ownedTools.at(ContainerDropDescription, "Drop operation") ]
							borderedNodeMappings += NodeMapping.create [
								name = "EC ETypeParameter"
								semanticCandidatesExpression = "feature:eTypeParameters"
								domainClass = "ecore.ETypeParameter"
								labelDirectEdit = DirectEditLabel.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.toolSections.get(5).ownedTools.at(DirectEditLabel, "Edit Name with CamelCase") ]
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
								labelDirectEdit = DirectEditLabel.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.toolSections.get(5).ownedTools.at(DirectEditLabel, "Edit EStructuralFeature Name") ]
								dropDescriptions += ContainerDropDescription.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.toolSections.get(0).ownedTools.at(ContainerDropDescription, "Drop EStructuralFeature into EClass") ]
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
								labelDirectEdit = DirectEditLabel.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.toolSections.get(5).ownedTools.at(DirectEditLabel, "Operation Name") ]
								dropDescriptions += ContainerDropDescription.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.toolSections.get(0).ownedTools.at(ContainerDropDescription, "Drop EStructuralFeature into EClass") ]
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
								labelDirectEdit = DirectEditLabel.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.toolSections.get(5).ownedTools.at(DirectEditLabel, "Edit EStructuralFeature Name") ]
								dropDescriptions += ContainerDropDescription.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.toolSections.get(0).ownedTools.at(ContainerDropDescription, "Drop EStructuralFeature into EClass") ]
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
										labelColor = UserFixedColor.ref("PlainDesign")[ (it as Group).userColorsPalettes.at("Ecore Palette").entries.at(UserFixedColor, "Inherited") ]
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
								foregroundColor = UserFixedColor.ref("PlainDesign")[ (it as Group).userColorsPalettes.at("Ecore Palette").entries.at(UserFixedColor, "EClass") ]
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
									borderColor = UserFixedColor.ref("PlainDesign")[ (it as Group).userColorsPalettes.at("Ecore Palette").entries.at(UserFixedColor, "Dark EClass") ]
									labelColor = Environment.extraRef("$0").systemColors.entries.at("black")
									backgroundColor = Environment.extraRef("$0").systemColors.entries.at("white")
									foregroundColor = UserFixedColor.ref("PlainDesign")[ (it as Group).userColorsPalettes.at("Ecore Palette").entries.at(UserFixedColor, "Abstract EClass") ]
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
									borderColor = UserFixedColor.ref("PlainDesign")[ (it as Group).userColorsPalettes.at("Ecore Palette").entries.at(UserFixedColor, "Dark EClass") ]
									labelColor = Environment.extraRef("$0").systemColors.entries.at("black")
									backgroundColor = Environment.extraRef("$0").systemColors.entries.at("white")
									foregroundColor = UserFixedColor.ref("PlainDesign")[ (it as Group).userColorsPalettes.at("Ecore Palette").entries.at(UserFixedColor, "Abstract EClass") ]
								]
							]
						]
						containerMappings += ContainerMapping.create [
							name = "EC EEnum"
							createElements = false
							domainClass = "ecore.EEnum"
							childrenPresentation = ContainerLayout.LIST
							labelDirectEdit = DirectEditLabel.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.toolSections.get(5).ownedTools.at(DirectEditLabel, "Edit Name with CamelCase") ]
							subNodeMappings += NodeMapping.create [
								name = "EC EEnumLiteral"
								semanticCandidatesExpression = "feature:eLiterals"
								domainClass = "ecore.EEnumLiteral"
								labelDirectEdit = DirectEditLabel.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.toolSections.get(5).ownedTools.at(DirectEditLabel, "Edit Name no CamelCase") ]
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
								borderColor = UserFixedColor.ref("PlainDesign")[ (it as Group).userColorsPalettes.at("Ecore Palette").entries.at(UserFixedColor, "Dark EEnum") ]
								labelColor = Environment.extraRef("$0").systemColors.entries.at("black")
								backgroundColor = Environment.extraRef("$0").systemColors.entries.at("white")
								foregroundColor = UserFixedColor.ref("PlainDesign")[ (it as Group).userColorsPalettes.at("Ecore Palette").entries.at(UserFixedColor, "EEnum") ]
							]
						]
						containerMappings += ContainerMapping.create [
							name = "EC EDataType"
							preconditionExpression = "service:isEDataType"
							createElements = false
							domainClass = "ecore.EDataType"
							childrenPresentation = ContainerLayout.LIST
							labelDirectEdit = DirectEditLabel.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.toolSections.get(5).ownedTools.at(DirectEditLabel, "Edit Name with CamelCase") ]
							subNodeMappings += NodeMapping.create [
								name = "EC_DataType_InstanceClassName"
								semanticCandidatesExpression = "var:self"
								domainClass = "ecore.EDataType"
								labelDirectEdit = DirectEditLabel.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.toolSections.get(5).ownedTools.at(DirectEditLabel, "InstanceClassName") ]
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
								borderColor = UserFixedColor.ref("PlainDesign")[ (it as Group).userColorsPalettes.at("Ecore Palette").entries.at(UserFixedColor, "Dark EDataType") ]
								labelColor = Environment.extraRef("$0").systemColors.entries.at("black")
								backgroundColor = Environment.extraRef("$0").systemColors.entries.at("white")
								foregroundColor = UserFixedColor.ref("PlainDesign")[ (it as Group).userColorsPalettes.at("Ecore Palette").entries.at(UserFixedColor, "EDataType") ]
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
													mapping = ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass") ]
												]
											]
											subModelOperations += If.create [
												conditionExpression = "service:isEDataType"
												subModelOperations += CreateView.create [
													containerViewExpression = "var:containerView"
													mapping = ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EDataType") ]
												]
											]
											subModelOperations += If.create [
												conditionExpression = "service:isEEnum"
												subModelOperations += CreateView.create [
													containerViewExpression = "var:containerView"
													mapping = ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EEnum") ]
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
													mapping = ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass") ]
												]
											]
											subModelOperations += If.create [
												conditionExpression = "service:isEDataType"
												subModelOperations += CreateView.create [
													containerViewExpression = "var:newContainerView"
													mapping = ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EDataType") ]
												]
											]
											subModelOperations += If.create [
												conditionExpression = "service:isEEnum"
												subModelOperations += CreateView.create [
													containerViewExpression = "var:newContainerView"
													mapping = ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EEnum") ]
												]
											]
											subModelOperations += If.create [
												conditionExpression = "service:isEPackage"
												subModelOperations += CreateView.create [
													containerViewExpression = "var:newContainerView"
													mapping = ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").additionalLayers.at("Package").containerMappings.at("Dropped Package") ]
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
													mapping = ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass") ]
												]
											]
											subModelOperations += If.create [
												conditionExpression = "service:isEDataType"
												subModelOperations += CreateView.create [
													containerViewExpression = "var:diagram"
													mapping = ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EDataType") ]
												]
											]
											subModelOperations += If.create [
												conditionExpression = "service:isEEnum"
												subModelOperations += CreateView.create [
													containerViewExpression = "var:diagram"
													mapping = ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EEnum") ]
												]
											]
										]
									]
								]
							]
							ownedTools += ContainerDropDescription.create [
								name = "Drop EStructuralFeature into EClass"
								mappings += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").additionalLayers.at("Package").containerMappings.at("Dropped Package") ]
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
								mappings += NodeMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.nodeMappings.at("Empty Diagram") ]
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
														mapping = ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass") ]
													]
												]
												subModelOperations += If.create [
													conditionExpression = "service:isEDataType"
													subModelOperations += CreateView.create [
														containerViewExpression = "var:diagram"
														mapping = ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EDataType") ]
													]
												]
												subModelOperations += If.create [
													conditionExpression = "service:isEEnum"
													subModelOperations += CreateView.create [
														containerViewExpression = "var:diagram"
														mapping = ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EEnum") ]
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
									containerMappings += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass") ]
									extraMappings += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass") ]
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
									containerMappings += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass") ]
									extraMappings += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass") ]
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
									containerMappings += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass") ]
									extraMappings += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass") ]
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
								containerMappings += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EDataType") ]
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
								containerMappings += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EEnum") ]
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
								nodeMappings += NodeMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").borderedNodeMappings.at("EC ETypeParameter") ]
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
								nodeMappings += NodeMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EEnum").subNodeMappings.at("EC EEnumLiteral") ]
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
								nodeMappings += NodeMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("Operation") ]
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
								nodeMappings += NodeMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("EC EAttribute") ]
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
								mappings += NodeMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("EC EAttribute") ]
								mappings += NodeMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("EC EReferenceNode") ]
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
								mappings += NodeMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("Operation") ]
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
								diagramDescription = DiagramDescription.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities") ]
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
								edgeMappings += EdgeMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.edgeMappings.at("EC ESupertypes") ]
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
								edgeMappings += EdgeMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.edgeMappings.at("EC_EReference") ]
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
								edgeMappings += EdgeMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.edgeMappings.at("Bi-directional EC_EReference ") ]
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
								edgeMappings += EdgeMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.edgeMappings.at("EC_EReference") ]
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
								mappings += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass") ]
								mappings += NodeMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("EC EAttribute") ]
								mappings += NodeMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("Operation") ]
								mappings += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EDataType") ]
								mappings += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EEnum") ]
								mappings += NodeMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EEnum").subNodeMappings.at("EC EEnumLiteral") ]
								mappings += NodeMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("EC EReferenceNode") ]
								mappings += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").additionalLayers.at("Package").containerMappings.at("Dropped Package") ]
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
												extends = PageDescription.ref("PlainDesign")[ ((it as Group).extensions.head as ViewExtensionDescription).categories.head.pages.get(0) ]
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
									appliedOn += CenterLabelStyleDescription.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.edgeMappings.at("EC_EReference").style.centerLabelStyleDescription ]
									appliedOn += BundledImageDescription.ref("PlainDesign")[ ((it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("EC EAttribute").style as BundledImageDescription) ]
									appliedOn += BeginLabelStyleDescription.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.edgeMappings.at("Bi-directional EC_EReference ").style.beginLabelStyleDescription ]
									appliedOn += EndLabelStyleDescription.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.edgeMappings.at("Bi-directional EC_EReference ").style.endLabelStyleDescription ]
									appliedOn += BundledImageDescription.ref("PlainDesign")[ ((it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("EC EReferenceNode").style as BundledImageDescription) ]
									appliedOn += BundledImageDescription.ref("PlainDesign")[ ((it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("EC EReferenceNode").conditionnalStyles.head.style as BundledImageDescription) ]
								]
								featureCustomizations += EReferenceCustomization.create [
									referenceName = "strokeColor"
									appliedOn += EdgeStyleDescription.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.edgeMappings.at("Bi-directional EC_EReference ").style ]
									appliedOn += EdgeStyleDescription.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.edgeMappings.at("EC_EReference").style ]
									value = Environment.extraRef("$0").systemColors.entries.at("black")
								]
							]
							vsmElementCustomizations += VSMElementCustomization.create [
								predicateExpression = "feature:containment"
								featureCustomizations += EAttributeCustomization.create [
									attributeName = "sourceArrow"
									value = "service:arrowsFillDiamond"
									appliedOn += EdgeStyleDescription.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.edgeMappings.at("EC_EReference").style ]
									appliedOn += EdgeStyleDescription.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.edgeMappings.at("Bi-directional EC_EReference ").style ]
								]
								featureCustomizations += EAttributeCustomization.create [
									attributeName = "sizeComputationExpression"
									value = "1"
									appliedOn += EdgeStyleDescription.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.edgeMappings.at("EC_EReference").style ]
									appliedOn += EdgeStyleDescription.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.edgeMappings.at("Bi-directional EC_EReference ").style ]
								]
							]
							vsmElementCustomizations += VSMElementCustomization.create [
								predicateExpression = "feature:container"
								featureCustomizations += EAttributeCustomization.create [
									attributeName = "targetArrow"
									value = "service:arrowsFillDiamond"
									appliedOn += EdgeStyleDescription.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.edgeMappings.at("EC_EReference").style ]
									appliedOn += EdgeStyleDescription.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.edgeMappings.at("Bi-directional EC_EReference ").style ]
								]
								featureCustomizations += EAttributeCustomization.create [
									attributeName = "sizeComputationExpression"
									value = "1"
									appliedOn += EdgeStyleDescription.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.edgeMappings.at("EC_EReference").style ]
									appliedOn += EdgeStyleDescription.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.edgeMappings.at("Bi-directional EC_EReference ").style ]
								]
							]
							vsmElementCustomizations += VSMElementCustomization.create [
								predicateExpression = "feature:derived"
								featureCustomizations += EReferenceCustomization.create [
									referenceName = "strokeColor"
									appliedOn += EdgeStyleDescription.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.edgeMappings.at("EC_EReference").style ]
									appliedOn += EdgeStyleDescription.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.edgeMappings.at("Bi-directional EC_EReference ").style ]
									value = Environment.extraRef("$0").systemColors.entries.at("blue")
								]
								featureCustomizations += EReferenceCustomization.create [
									referenceName = "labelColor"
									appliedOn += BeginLabelStyleDescription.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.edgeMappings.at("Bi-directional EC_EReference ").style.beginLabelStyleDescription ]
									appliedOn += EndLabelStyleDescription.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.edgeMappings.at("Bi-directional EC_EReference ").style.endLabelStyleDescription ]
									appliedOn += CenterLabelStyleDescription.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.edgeMappings.at("EC_EReference").style.centerLabelStyleDescription ]
									appliedOn += BundledImageDescription.ref("PlainDesign")[ ((it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("EC EAttribute").style as BundledImageDescription) ]
									appliedOn += BundledImageDescription.ref("PlainDesign")[ ((it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("EC EReferenceNode").style as BundledImageDescription) ]
									appliedOn += BundledImageDescription.ref("PlainDesign")[ ((it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("EC EReferenceNode").conditionnalStyles.head.style as BundledImageDescription) ]
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
							detailDescriptions += DiagramCreationDescription.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.toolSections.get(3).ownedTools.at(DiagramCreationDescription, "New Package Entities") ]
							pasteDescriptions += PasteDescription.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.toolSections.get(0).ownedTools.at(PasteDescription, "Paste Anything") ]
							labelDirectEdit = DirectEditLabel.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.toolSections.get(5).ownedTools.at(DirectEditLabel, "Edit Name no CamelCase") ]
							dropDescriptions += ContainerDropDescription.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").additionalLayers.at("Package").toolSections.head.ownedTools.at(ContainerDropDescription, "Drop EClassifier into EPackage") ]
							dropDescriptions += ContainerDropDescription.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").additionalLayers.at("Package").toolSections.head.ownedTools.at(ContainerDropDescription, "Drop EPackage into EPackage") ]
							reusedContainerMappings += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass") ]
							reusedContainerMappings += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EDataType") ]
							reusedContainerMappings += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EEnum") ]
							style = FlatContainerStyleDescription.create [
								arcWidth = 1
								arcHeight = 1
								borderSizeComputationExpression = "1"
								labelExpression = "aql:self.name"
								labelAlignment = LabelAlignment.LEFT
								widthComputationExpression = "24"
								heightComputationExpression = "16"
								backgroundStyle = BackgroundStyle.LIQUID_LITERAL
								borderColor = UserFixedColor.ref("PlainDesign")[ (it as Group).userColorsPalettes.at("Ecore Palette").entries.at(UserFixedColor, "Dark EPackage") ]
								labelColor = Environment.extraRef("$0").systemColors.entries.at("black")
								backgroundColor = Environment.extraRef("$0").systemColors.entries.at("white")
								foregroundColor = UserFixedColor.ref("PlainDesign")[ (it as Group).userColorsPalettes.at("Ecore Palette").entries.at(UserFixedColor, "EPackage") ]
								labelBorderStyle = Environment.extraRef("$0").labelBorderStyles.labelBorderStyleDescriptions.get(0)
							]
						]
						toolSections += ToolSection.create [
							name = "Package"
							ownedTools += ContainerCreationDescription.create [
								name = "Package"
								containerMappings += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").additionalLayers.at("Package").containerMappings.at("Dropped Package") ]
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
								mappings += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass") ]
								mappings += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EDataType") ]
								mappings += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EEnum") ]
								mappings += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").additionalLayers.at("Related EClasses").containerMappings.at("EC External EClasses") ]
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
								mappings += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").additionalLayers.at("Package").containerMappings.at("Dropped Package") ]
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
												mapping = ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").additionalLayers.at("Package").containerMappings.at("Dropped Package") ]
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
							labelDirectEdit = DirectEditLabel.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").additionalLayers.at("Documentation").toolSections.head.ownedTools.at(DirectEditLabel, "Edit Detail") ]
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
								color = UserFixedColor.ref("PlainDesign")[ (it as Group).userColorsPalettes.at("Ecore Palette").entries.at(UserFixedColor, "Doc Annotation") ]
							]
						]
						edgeMappings += EdgeMapping.create [
							name = "EC Doc Assignment"
							semanticCandidatesExpression = "aql:self.eAllContents()"
							targetFinderExpression = "service:eContainerEContainer"
							sourceMapping += NodeMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").additionalLayers.at("Documentation").nodeMappings.at("EC Doc Annotation") ]
							targetMapping += EdgeMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.edgeMappings.at("EC_EReference") ]
							targetMapping += EdgeMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.edgeMappings.at("Bi-directional EC_EReference ") ]
							targetMapping += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass") ]
							targetMapping += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").additionalLayers.at("Package").containerMappings.at("Dropped Package") ]
							targetMapping += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EDataType") ]
							targetMapping += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EEnum") ]
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
								nodeMappings += NodeMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").additionalLayers.at("Documentation").nodeMappings.at("EC Doc Annotation") ]
								extraMappings += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass") ]
								extraMappings += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EDataType") ]
								extraMappings += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EEnum") ]
								extraMappings += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").additionalLayers.at("Package").containerMappings.at("Dropped Package") ]
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
								edgeMappings += EdgeMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").additionalLayers.at("Documentation").edgeMappings.at("EC Doc Assignment") ]
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
									appliedOn += FlatContainerStyleDescription.ref("PlainDesign")[ ((it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").style as FlatContainerStyleDescription) ]
									appliedOn += FlatContainerStyleDescription.ref("PlainDesign")[ ((it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").conditionnalStyles.get(1).style as FlatContainerStyleDescription) ]
									appliedOn += FlatContainerStyleDescription.ref("PlainDesign")[ ((it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").conditionnalStyles.get(0).style as FlatContainerStyleDescription) ]
									appliedOn += CenterLabelStyleDescription.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.edgeMappings.at("EC_EReference").style.centerLabelStyleDescription ]
									appliedOn += FlatContainerStyleDescription.ref("PlainDesign")[ ((it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EDataType").style as FlatContainerStyleDescription) ]
									value = Environment.extraRef("$0").systemColors.entries.at("red")
								]
								featureCustomizations += EReferenceCustomization.create [
									referenceName = "borderColor"
									appliedOn += FlatContainerStyleDescription.ref("PlainDesign")[ ((it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").style as FlatContainerStyleDescription) ]
									appliedOn += FlatContainerStyleDescription.ref("PlainDesign")[ ((it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").conditionnalStyles.get(1).style as FlatContainerStyleDescription) ]
									appliedOn += FlatContainerStyleDescription.ref("PlainDesign")[ ((it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").conditionnalStyles.get(0).style as FlatContainerStyleDescription) ]
									appliedOn += FlatContainerStyleDescription.ref("PlainDesign")[ ((it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EDataType").style as FlatContainerStyleDescription) ]
									value = Environment.extraRef("$0").systemColors.entries.at("red")
								]
								featureCustomizations += EReferenceCustomization.create [
									referenceName = "strokeColor"
									appliedOn += EdgeStyleDescription.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.edgeMappings.at("Bi-directional EC_EReference ").style ]
									appliedOn += EdgeStyleDescription.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.edgeMappings.at("EC_EReference").style ]
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
									appliedOn += BundledImageDescription.ref("PlainDesign")[ ((it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("EC EAttribute").style as BundledImageDescription) ]
									appliedOn += BundledImageDescription.ref("PlainDesign")[ ((it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("Operation").style as BundledImageDescription) ]
									appliedOn += CenterLabelStyleDescription.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.edgeMappings.at("EC_EReference").style.centerLabelStyleDescription ]
									appliedOn += CenterLabelStyleDescription.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.edgeMappings.at("EC ESupertypes").style.centerLabelStyleDescription ]
									appliedOn += CenterLabelStyleDescription.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.edgeMappings.at("EC ESupertypes").conditionnalStyles.get(0).style.centerLabelStyleDescription ]
									appliedOn += FlatContainerStyleDescription.ref("PlainDesign")[ ((it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").conditionnalStyles.get(1).style as FlatContainerStyleDescription) ]
									appliedOn += FlatContainerStyleDescription.ref("PlainDesign")[ ((it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").conditionnalStyles.get(0).style as FlatContainerStyleDescription) ]
									appliedOn += FlatContainerStyleDescription.ref("PlainDesign")[ ((it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").style as FlatContainerStyleDescription) ]
									appliedOn += FlatContainerStyleDescription.ref("PlainDesign")[ ((it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EDataType").style as FlatContainerStyleDescription) ]
									value = Environment.extraRef("$0").systemColors.entries.at("red")
								]
								featureCustomizations += EReferenceCustomization.create [
									referenceName = "borderColor"
									appliedOn += BundledImageDescription.ref("PlainDesign")[ ((it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("EC EAttribute").style as BundledImageDescription) ]
									appliedOn += FlatContainerStyleDescription.ref("PlainDesign")[ ((it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").style as FlatContainerStyleDescription) ]
									appliedOn += BundledImageDescription.ref("PlainDesign")[ ((it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("Operation").style as BundledImageDescription) ]
									appliedOn += FlatContainerStyleDescription.ref("PlainDesign")[ ((it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").conditionnalStyles.get(1).style as FlatContainerStyleDescription) ]
									appliedOn += FlatContainerStyleDescription.ref("PlainDesign")[ ((it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").conditionnalStyles.get(0).style as FlatContainerStyleDescription) ]
									appliedOn += FlatContainerStyleDescription.ref("PlainDesign")[ ((it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EDataType").style as FlatContainerStyleDescription) ]
									value = Environment.extraRef("$0").systemColors.entries.at("red")
								]
								featureCustomizations += EReferenceCustomization.create [
									referenceName = "strokeColor"
									appliedOn += EdgeStyleDescription.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.edgeMappings.at("Bi-directional EC_EReference ").style ]
									appliedOn += EdgeStyleDescription.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.edgeMappings.at("EC_EReference").style ]
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
							labelDirectEdit = DirectEditLabel.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").additionalLayers.at("Documentation").toolSections.head.ownedTools.at(DirectEditLabel, "Edit Detail") ]
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
							sourceMapping += NodeMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").additionalLayers.at("Constraint").nodeMappings.at("EC Constraint Annotation") ]
							targetMapping += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass") ]
							targetMapping += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EDataType") ]
							targetMapping += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EEnum") ]
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
								nodeMappings += NodeMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").additionalLayers.at("Constraint").nodeMappings.at("EC Constraint Annotation") ]
								extraMappings += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass") ]
								extraMappings += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EDataType") ]
								extraMappings += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EEnum") ]
								extraMappings += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").additionalLayers.at("Package").containerMappings.at("Dropped Package") ]
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
								edgeMappings += EdgeMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").additionalLayers.at("Constraint").edgeMappings.at("EC Constraint Assignment") ]
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
							deletionDescription = DeleteElementDescription.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.toolSections.get(1).ownedTools.at(DeleteElementDescription, "NoOp") ]
							labelDirectEdit = DirectEditLabel.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.toolSections.get(5).ownedTools.at(DirectEditLabel, "Edit Name with CamelCase") ]
							reusedBorderedNodeMappings += NodeMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").borderedNodeMappings.at("EC ETypeParameter") ]
							dropDescriptions += ContainerDropDescription.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.toolSections.get(2).ownedTools.at(ContainerDropDescription, "Drop attribute") ]
							dropDescriptions += ContainerDropDescription.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.toolSections.get(2).ownedTools.at(ContainerDropDescription, "Drop operation") ]
							reusedNodeMappings += NodeMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("EC EAttribute") ]
							reusedNodeMappings += NodeMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").subNodeMappings.at("Operation") ]
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
								foregroundColor = UserFixedColor.ref("PlainDesign")[ (it as Group).userColorsPalettes.at("Ecore Palette").entries.at(UserFixedColor, "EClass") ]
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
									borderColor = UserFixedColor.ref("PlainDesign")[ (it as Group).userColorsPalettes.at("Ecore Palette").entries.at(UserFixedColor, "Dark EClass") ]
									labelColor = Environment.extraRef("$0").systemColors.entries.at("black")
									backgroundColor = Environment.extraRef("$0").systemColors.entries.at("white")
									foregroundColor = UserFixedColor.ref("PlainDesign")[ (it as Group).userColorsPalettes.at("Ecore Palette").entries.at(UserFixedColor, "Abstract EClass") ]
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
									borderColor = UserFixedColor.ref("PlainDesign")[ (it as Group).userColorsPalettes.at("Ecore Palette").entries.at(UserFixedColor, "Dark EClass") ]
									labelColor = Environment.extraRef("$0").systemColors.entries.at("black")
									backgroundColor = Environment.extraRef("$0").systemColors.entries.at("white")
									foregroundColor = UserFixedColor.ref("PlainDesign")[ (it as Group).userColorsPalettes.at("Ecore Palette").entries.at(UserFixedColor, "Abstract EClass") ]
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
									appliedOn += FlatContainerStyleDescription.ref("PlainDesign")[ ((it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").conditionnalStyles.get(1).style as FlatContainerStyleDescription) ]
									appliedOn += FlatContainerStyleDescription.ref("PlainDesign")[ ((it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").conditionnalStyles.get(0).style as FlatContainerStyleDescription) ]
									appliedOn += FlatContainerStyleDescription.ref("PlainDesign")[ ((it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").style as FlatContainerStyleDescription) ]
									appliedOn += FlatContainerStyleDescription.ref("PlainDesign")[ ((it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").additionalLayers.at("Related EClasses").containerMappings.at("EC External EClasses").conditionnalStyles.get(1).style as FlatContainerStyleDescription) ]
									appliedOn += FlatContainerStyleDescription.ref("PlainDesign")[ ((it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").additionalLayers.at("Related EClasses").containerMappings.at("EC External EClasses").conditionnalStyles.get(0).style as FlatContainerStyleDescription) ]
									appliedOn += FlatContainerStyleDescription.ref("PlainDesign")[ ((it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").additionalLayers.at("Related EClasses").containerMappings.at("EC External EClasses").style as FlatContainerStyleDescription) ]
								]
							]
						]
					]
				]
				ownedRepresentations += EditionTableDescription.create [
					documentation = "<html>\n<head>\n</head>\n<body>\n<p>A tabular editor (spreadsheet-like) of the entities in an Ecore model.</p>\n<br>\n<img src=\"/icons/full/wizban/classes.png\"/>\n</body>\n</html>\n\n\n"
					endUserDocumentation = "A tabular editor (spreadsheet-like) of the entities in an Ecore model."
					name = "Classes"
					label = "Classes in a spreadsheet"
					titleExpression = "aql:self.name + ' class table'"
					domainClass = "ecore.EPackage"
					metamodel += org.eclipse.emf.codegen.ecore.genmodel.GenModelPackage.eINSTANCE
					metamodel += org.eclipse.emf.ecore.EcorePackage.eINSTANCE
					ownedLineMappings += LineMapping.create [
						name = "Classes lines"
						domainClass = "ecore.EClass"
						semanticCandidatesExpression = "feature:eContents"
						reusedInMappings += LineMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(EditionTableDescription, "Classes").ownedLineMappings.at("Package") ]
						foregroundConditionalStyle += ForegroundConditionalStyle.create [
							predicateExpression = "feature:abstract"
							style = ForegroundStyleDescription.create [
								labelSize = 10
								labelFormat += FontFormat.ITALIC_LITERAL
								foreGroundColor = Environment.extraRef("$0").systemColors.entries.at("black")
							]
						]
						ownedSubLines += LineMapping.create [
							name = "Feature"
							domainClass = "ecore.EStructuralFeature"
						]
					]
					ownedLineMappings += LineMapping.create [
						name = "Package"
						domainClass = "ecore.EPackage"
						headerLabelExpression = "feature:name"
						defaultBackground = BackgroundStyleDescription.create [
							backgroundColor = Environment.extraRef("$0").systemColors.entries.at("light_yellow")
						]
					]
					ownedCreateLine += CreateLineTool.create [
						name = "Create Class"
						forceRefresh = true
						elementsToSelect = "service:stdEmptyCollection"
						mapping = LineMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(EditionTableDescription, "Classes").ownedLineMappings.at("Classes lines") ]
						variables += TableVariable.create [
							name = "root"
							documentation = "The semantic element of the table."
						]
						variables += TableVariable.create [
							name = "element"
							documentation = "The semantic currently edited element."
						]
						variables += TableVariable.create [
							name = "container"
							documentation = "The semantic element corresponding to the view container."
						]
						firstModelOperation = ChangeContext.create [
							browseExpression = "var:container"
							subModelOperations += CreateInstance.create [
								typeName = "ecore.EClass"
								referenceName = "eClassifiers"
								subModelOperations += SetValue.create [
									featureName = "name"
									valueExpression = "aql:'NewEClass'  + self.eContainer().eContents(ecore::EClass)->size()"
								]
							]
						]
					]
					ownedColumnMappings += FeatureColumnMapping.create [
						name = "Name"
						headerLabelExpression = "Name"
						featureName = "name"
						labelExpression = "service:getClassesTableName"
					]
				]
				ownedJavaExtensions += JavaExtension.create [
					qualifiedClassName = "org.eclipse.emf.ecoretools.design.service.DesignServices"
				]
				ownedJavaExtensions += JavaExtension.create [
					qualifiedClassName = "org.eclipse.sirius.common.tools.api.interpreter.StandardServices"
				]
				ownedJavaExtensions += JavaExtension.create [
					qualifiedClassName = "org.eclipse.emf.ecoretools.design.service.PropertiesServices"
				]
				ownedJavaExtensions += JavaExtension.create [
					qualifiedClassName = "org.eclipse.emf.ecoretools.design.service.ALEServices"
				]
			]
			ownedViewpoints += Viewpoint.create [
				endUserDocumentation = "Add support for archetypes-based modeling to the Entities modeler."
				name = "Archetype"
				modelFileExtension = "ecore xcore ecorebin"
				ownedRepresentationExtensions += DiagramExtensionDescription.create [
					name = "Entities With Archetypes"
					viewpointURI = "viewpoint:/org.mypsycho.emf.modit.sirius.tests/Design"
					representationName = "Entities"
					metamodel += org.eclipse.emf.ecore.EcorePackage.eINSTANCE
					layers += AdditionalLayer.create [
						name = "Archetypes"
						activeByDefault = true
						toolSections += ToolSection.create [
							name = "Archetype"
							ownedTools += ContainerCreationDescription.create [
								documentation = "Does the class represent a moment or interval of time that we need to track for business or legal reasons? "
								name = "MomentInterval"
								forceRefresh = true
								iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/MomentInterval.gif"
								containerMappings += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass") ]
								extraMappings += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass") ]
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
													valueExpression = "aql:'newMomentInterval' + self.eContainer()->filter(ecore::EPackage).eClassifiers->filter(ecore::EClass)->size()"
													subModelOperations += ChangeContext.create [
														browseExpression = "aql:self.addArchetypeAnnotation('MomentInterval')"
													]
												]
											]
										]
										subModelOperations += If.create [
											conditionExpression = "service:isEClass"
											subModelOperations += ChangeContext.create [
												browseExpression = "aql:self.addArchetypeAnnotation('MomentInterval')"
											]
										]
									]
								]
							]
							ownedTools += ContainerCreationDescription.create [
								documentation = "Does the class represent a catalog-entry like description? "
								name = "Description"
								forceRefresh = true
								iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/Description.gif"
								containerMappings += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass") ]
								extraMappings += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass") ]
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
											conditionExpression = "aql:container.oclIsTypeOf(ecore::EPackage)"
											subModelOperations += CreateInstance.create [
												typeName = "ecore.EClass"
												referenceName = "eClassifiers"
												subModelOperations += SetValue.create [
													featureName = "name"
													valueExpression = "aql:'newDescription' + self.eContainer()->filter(ecore::EPackage).eClassifiers->filter(ecore::EClass)->size()"
													subModelOperations += ChangeContext.create [
														browseExpression = "aql:self.addArchetypeAnnotation('Description')"
													]
												]
											]
										]
										subModelOperations += If.create [
											conditionExpression = "aql:container.oclIsTypeOf(ecore::EClass)"
											subModelOperations += ChangeContext.create [
												browseExpression = "aql:self.addArchetypeAnnotation('Description')"
											]
										]
									]
								]
							]
							ownedTools += ContainerCreationDescription.create [
								documentation = "Does the class represent a role being played by a party (person or organization), place or thing? "
								name = "Role"
								forceRefresh = true
								iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/Role.gif"
								containerMappings += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass") ]
								extraMappings += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass") ]
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
											conditionExpression = "aql:container.oclIsTypeOf(ecore::EPackage)"
											subModelOperations += CreateInstance.create [
												typeName = "ecore.EClass"
												referenceName = "eClassifiers"
												subModelOperations += SetValue.create [
													featureName = "name"
													valueExpression = "aql:'newRole' + self.eContainer()->filter(ecore::EPackage).eClassifiers->filter(ecore::EClass)->size()"
													subModelOperations += ChangeContext.create [
														browseExpression = "aql:self.addArchetypeAnnotation('Role')"
													]
												]
											]
										]
										subModelOperations += If.create [
											conditionExpression = "aql:container.oclIsTypeOf(ecore::EClass)"
											subModelOperations += ChangeContext.create [
												browseExpression = "aql:self.addArchetypeAnnotation('Role')"
											]
										]
									]
								]
							]
							ownedTools += ContainerCreationDescription.create [
								name = "Place/Thing"
								forceRefresh = true
								iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/Thing.gif"
								containerMappings += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass") ]
								extraMappings += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass") ]
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
											conditionExpression = "aql:container.oclIsTypeOf(ecore::EPackage)"
											subModelOperations += CreateInstance.create [
												typeName = "ecore.EClass"
												referenceName = "eClassifiers"
												subModelOperations += SetValue.create [
													featureName = "name"
													valueExpression = "aql:'newThing' + self.eContainer()->filter(ecore::EPackage).eClassifiers->filter(ecore::EClass)->size()"
													subModelOperations += ChangeContext.create [
														browseExpression = "aql:self.addArchetypeAnnotation('Thing')"
													]
												]
											]
										]
										subModelOperations += If.create [
											conditionExpression = "aql:container.oclIsTypeOf(ecore::EClass)"
											subModelOperations += ChangeContext.create [
												browseExpression = "aql:self.addArchetypeAnnotation('Thing')"
											]
										]
									]
								]
							]
						]
						customization = Customization.create [
							vsmElementCustomizations += VSMElementCustomization.create [
								predicateExpression = "service:isMomentInterval"
								featureCustomizations += EReferenceCustomization.create [
									referenceName = "foregroundColor"
									appliedOn += FlatContainerStyleDescription.ref("PlainDesign")[ ((it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").style as FlatContainerStyleDescription) ]
									appliedOn += FlatContainerStyleDescription.ref("PlainDesign")[ ((it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").conditionnalStyles.get(1).style as FlatContainerStyleDescription) ]
									appliedOn += FlatContainerStyleDescription.ref("PlainDesign")[ ((it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").conditionnalStyles.get(0).style as FlatContainerStyleDescription) ]
									value = UserFixedColor.ref("PlainDesign")[ (it as Group).userColorsPalettes.at("Ecore Palette").entries.at(UserFixedColor, "MomentIntervalColor") ]
								]
							]
							vsmElementCustomizations += VSMElementCustomization.create [
								predicateExpression = "service:isDescription"
								featureCustomizations += EReferenceCustomization.create [
									referenceName = "foregroundColor"
									appliedOn += FlatContainerStyleDescription.ref("PlainDesign")[ ((it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").style as FlatContainerStyleDescription) ]
									appliedOn += FlatContainerStyleDescription.ref("PlainDesign")[ ((it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").conditionnalStyles.get(1).style as FlatContainerStyleDescription) ]
									appliedOn += FlatContainerStyleDescription.ref("PlainDesign")[ ((it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").conditionnalStyles.get(0).style as FlatContainerStyleDescription) ]
									value = UserFixedColor.ref("PlainDesign")[ (it as Group).userColorsPalettes.at("Ecore Palette").entries.at(UserFixedColor, "DescriptionColor") ]
								]
							]
							vsmElementCustomizations += VSMElementCustomization.create [
								predicateExpression = "service:isThing"
								featureCustomizations += EReferenceCustomization.create [
									referenceName = "foregroundColor"
									appliedOn += FlatContainerStyleDescription.ref("PlainDesign")[ ((it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").style as FlatContainerStyleDescription) ]
									appliedOn += FlatContainerStyleDescription.ref("PlainDesign")[ ((it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").conditionnalStyles.get(1).style as FlatContainerStyleDescription) ]
									appliedOn += FlatContainerStyleDescription.ref("PlainDesign")[ ((it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").conditionnalStyles.get(0).style as FlatContainerStyleDescription) ]
									value = UserFixedColor.ref("PlainDesign")[ (it as Group).userColorsPalettes.at("Ecore Palette").entries.at(UserFixedColor, "PartyPlaceThingColor") ]
								]
							]
							vsmElementCustomizations += VSMElementCustomization.create [
								predicateExpression = "service:isRole"
								featureCustomizations += EReferenceCustomization.create [
									referenceName = "foregroundColor"
									appliedOn += FlatContainerStyleDescription.ref("PlainDesign")[ ((it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").style as FlatContainerStyleDescription) ]
									appliedOn += FlatContainerStyleDescription.ref("PlainDesign")[ ((it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").conditionnalStyles.get(1).style as FlatContainerStyleDescription) ]
									appliedOn += FlatContainerStyleDescription.ref("PlainDesign")[ ((it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass").conditionnalStyles.get(0).style as FlatContainerStyleDescription) ]
									value = UserFixedColor.ref("PlainDesign")[ (it as Group).userColorsPalettes.at("Ecore Palette").entries.at(UserFixedColor, "RoleColor") ]
								]
							]
						]
					]
				]
				ownedJavaExtensions += JavaExtension.create [
					qualifiedClassName = "org.eclipse.emf.ecoretools.design.service.ArchetypeServices"
				]
				ownedJavaExtensions += JavaExtension.create [
					qualifiedClassName = "org.eclipse.emf.ecoretools.design.service.PropertiesServices"
				]
				ownedJavaExtensions += JavaExtension.create [
					qualifiedClassName = "org.eclipse.emf.ecoretools.design.service.ALEServices"
				]
			]
			ownedViewpoints += Viewpoint.create [
				endUserDocumentation = "Provides representation to document and review Ecore models."
				name = "Review"
				modelFileExtension = "ecore xcore ecorebin"
				ownedRepresentations += CrossTableDescription.create [
					documentation = "<html>\n<head>\n</head>\n<body>\n<p>Document the concepts in a package.</p>\n<br>\n<img src=\"/icons/full/wizban/documentation_table.png\"/>\n</body>\n</html>\n\n\n"
					name = "Documentation"
					label = "Documentation annotations in a spreadsheet"
					titleExpression = "aql:self.name + ' documentation table'"
					domainClass = "ecore.EPackage"
					metamodel += org.eclipse.emf.ecore.EcorePackage.eINSTANCE
					ownedLineMappings += LineMapping.create [
						name = "Doc EClassifiers"
						semanticElements = "var:self"
						domainClass = "ecore.EClassifier"
						semanticCandidatesExpression = "feature:eClassifiers"
						headerLabelExpression = "aql:self.eClass().name + ' : ' + self.name"
						defaultBackground = BackgroundStyleDescription.create [
							backgroundColor = Environment.extraRef("$0").systemColors.entries.at("white")
						]
						ownedSubLines += LineMapping.create [
							name = "Doc EStructural Features"
							domainClass = "ecore.EStructuralFeature"
							semanticCandidatesExpression = "feature:eContents"
							headerLabelExpression = "aql:self.eClass().name + ' : ' + self.name"
							defaultBackground = BackgroundStyleDescription.create [
								backgroundColor = Environment.extraRef("$0").systemColors.entries.at("white")
							]
						]
					]
					ownedColumnMappings += ElementColumnMapping.create [
						name = "Doc Root"
						headerLabelExpression = "Domain Documentation"
						domainClass = "ecore.EPackage"
						semanticCandidatesExpression = "service:getRootContainer"
					]
					intersection += IntersectionMapping.create [
						name = "EModelElements to Doc Annotation"
						semanticElements = "var:self"
						labelExpression = "aql:self.value"
						useDomainClass = true
						columnFinderExpression = "service:getRootContainer"
						lineFinderExpression = "aql:self.eContainer(ecore::EAnnotation).eContainer()"
						semanticCandidatesExpression = "aql:self.eAllContents(ecore::EAnnotation)->select(a | a.source = 'http://www.eclipse.org/emf/2002/GenModel').details->select(a | a.key = 'documentation')"
						domainClass = "ecore.EStringToStringMapEntry"
						lineMapping += LineMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Review").ownedRepresentations.at(CrossTableDescription, "Documentation").ownedLineMappings.at("Doc EClassifiers") ]
						lineMapping += LineMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Review").ownedRepresentations.at(CrossTableDescription, "Documentation").ownedLineMappings.at("Doc EClassifiers").ownedSubLines.at("Doc EStructural Features") ]
						columnMapping = ElementColumnMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Review").ownedRepresentations.at(CrossTableDescription, "Documentation").ownedColumnMappings.head ]
						directEdit = LabelEditTool.create [
							variables += TableVariable.create [
								name = "table"
								documentation = "The current DTable."
							]
							variables += TableVariable.create [
								name = "line"
								documentation = "The DLine of the current DCell."
							]
							variables += TableVariable.create [
								name = "element"
								documentation = "The currently edited element."
							]
							variables += TableVariable.create [
								name = "lineSemantic"
								documentation = "The semantic element corresponding to the line."
							]
							variables += TableVariable.create [
								name = "columnSemantic"
								documentation = "The semantic element corresponding to the column (only available for Intersection Mapping)."
							]
							variables += TableVariable.create [
								name = "root"
								documentation = "The semantic element of the table."
							]
							firstModelOperation = SetValue.create [
								featureName = "value"
								valueExpression = "var:arg0"
							]
							mask = EditMaskVariables.create [
								mask = "{0}"
							]
						]
						defaultBackground = BackgroundStyleDescription.create [
							backgroundColor = UserFixedColor.ref("PlainDesign")[ (it as Group).userColorsPalettes.at("Ecore Palette").entries.at(UserFixedColor, "Doc Annotation") ]
						]
						create = CreateCellTool.create [
							name = "New Documentation"
							forceRefresh = true
							variables += TableVariable.create [
								name = "lineSemantic"
								documentation = "The semantic element corresponding to the line."
							]
							variables += TableVariable.create [
								name = "columnSemantic"
								documentation = "The semantic element corresponding to the column."
							]
							variables += TableVariable.create [
								name = "root"
								documentation = "The semantic root element of the table."
							]
							firstModelOperation = ChangeContext.create [
								browseExpression = "var:lineSemantic"
								subModelOperations += If.create [
									conditionExpression = "aql:lineSemantic.eAnnotations->select(a | a.source = 'http://www.eclipse.org/emf/2002/GenModel')->size() = 0"
									subModelOperations += CreateInstance.create [
										typeName = "ecore.EAnnotation"
										referenceName = "eAnnotations"
										variableName = "newAnnotation"
										subModelOperations += SetValue.create [
											featureName = "source"
											valueExpression = "aql:'http://www.eclipse.org/emf/2002/GenModel'"
										]
									]
								]
								subModelOperations += ChangeContext.create [
									browseExpression = "aql:lineSemantic.eAnnotations->select(a | a.source = 'http://www.eclipse.org/emf/2002/GenModel')->first()"
									subModelOperations += If.create [
										conditionExpression = "aql:self.details->select(a| a.key = 'documentation')->size() = 0"
										subModelOperations += CreateInstance.create [
											typeName = "ecore.EStringToStringMapEntry"
											referenceName = "details"
											variableName = "newDetail"
											subModelOperations += SetValue.create [
												featureName = "key"
												valueExpression = "aql:'documentation'"
											]
										]
									]
								]
								subModelOperations += ChangeContext.create [
									browseExpression = "aql:lineSemantic.eAnnotations->select(a | a.source = 'http://www.eclipse.org/emf/2002/GenModel').details->select(a | a.key = 'documentation')->first()"
									subModelOperations += SetValue.create [
										featureName = "value"
										valueExpression = "var:arg0"
									]
								]
							]
							mask = EditMaskVariables.create [
								mask = "{0}"
							]
						]
					]
				]
				ownedRepresentations += DiagramDescription.create [
					documentation = "<html>\n<head>\n</head>\n<body>\n<p>A  diagram used to highligh dependencies in between EPackages.</p>\n<br>\n<img src=\"/icons/full/wizban/packages.png\"/>\n</body>\n</html>\n\n\n"
					name = "Dependencies"
					label = "Package dependencies diagram"
					titleExpression = "aql:self.name + ' package dependencies'"
					domainClass = "ecore.EPackage"
					dropDescriptions += ContainerDropDescription.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Review").ownedRepresentations.at(DiagramDescription, "Dependencies").defaultLayer.toolSections.get(1).ownedTools.at(ContainerDropDescription, "External EPackageTo Analyze from treeview") ]
					metamodel += org.eclipse.emf.ecore.EcorePackage.eINSTANCE
					defaultLayer = Layer.create [
						name = "Default"
						edgeMappings += EdgeMapping.create [
							name = "Package Dependency"
							semanticCandidatesExpression = "service:getPackageDependencies"
							targetFinderExpression = "service:getPackageDependencies"
							domainClass = "ecore.EPackage"
							sourceMapping += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Review").ownedRepresentations.at(DiagramDescription, "Dependencies").defaultLayer.containerMappings.at("Analyzed Package") ]
							targetMapping += ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Review").ownedRepresentations.at(DiagramDescription, "Dependencies").defaultLayer.containerMappings.at("Analyzed Package") ]
							style = EdgeStyleDescription.create [
								lineStyle = LineStyle.DASH_LITERAL
								sizeComputationExpression = "service:getDependenciesAmount()"
								strokeColor = Environment.extraRef("$0").systemColors.entries.at("red")
								centerLabelStyleDescription = CenterLabelStyleDescription.create [
									labelColor = Environment.extraRef("$0").systemColors.entries.at("black")
								]
							]
						]
						containerMappings += ContainerMapping.create [
							name = "Analyzed Package"
							createElements = false
							domainClass = "ecore.EPackage"
							childrenPresentation = ContainerLayout.LIST
							labelDirectEdit = DirectEditLabel.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.toolSections.get(5).ownedTools.at(DirectEditLabel, "Edit Name no CamelCase") ]
							subNodeMappings += NodeMapping.create [
								name = "EClassfierIntroducingDependency"
								semanticCandidatesExpression = "service:getElementsIntroducingDependencies(diagram)"
								domainClass = "ecore.EClassifier"
								style = BundledImageDescription.create [
									labelExpression = "service:getDependenciesLabel"
									labelAlignment = LabelAlignment.LEFT
									tooltipExpression = "service:getDependenciesTooltip(view)"
									labelPosition = LabelPosition.NODE_LITERAL
									resizeKind = ResizeKind.NSEW_LITERAL
									borderColor = Environment.extraRef("$0").systemColors.entries.at("black")
									labelColor = Environment.extraRef("$0").systemColors.entries.at("black")
									color = Environment.extraRef("$0").systemColors.entries.at("black")
								]
							]
							style = FlatContainerStyleDescription.create [
								arcWidth = 1
								arcHeight = 1
								borderSizeComputationExpression = "1"
								labelExpression = "feature:nsURI"
								labelAlignment = LabelAlignment.LEFT
								backgroundStyle = BackgroundStyle.LIQUID_LITERAL
								borderColor = UserFixedColor.ref("PlainDesign")[ (it as Group).userColorsPalettes.at("Ecore Palette").entries.at(UserFixedColor, "Dark EPackage") ]
								labelColor = Environment.extraRef("$0").systemColors.entries.at("black")
								backgroundColor = Environment.extraRef("$0").systemColors.entries.at("white")
								foregroundColor = UserFixedColor.ref("PlainDesign")[ (it as Group).userColorsPalettes.at("Ecore Palette").entries.at(UserFixedColor, "EPackage") ]
								labelBorderStyle = Environment.extraRef("$0").labelBorderStyles.labelBorderStyleDescriptions.get(0)
							]
						]
						toolSections += ToolSection.create [
							name = "Help"
							label = "Help"
							ownedTools += OperationAction.create [
								name = "Open Dependencies User Guide"
								label = "Open User Guide"
								view = ContainerViewVariable.create [
									name = "views"
								]
								initialOperation = InitialOperation.create [
									firstModelOperations = ExternalJavaAction.create [
										name = "Open Dependencies User Guide Action"
										id = "org.eclipse.sirius.ui.business.api.action.openHelpSection"
										parameters += ExternalJavaActionParameter.create [
											name = "href"
											value = "/org.eclipse.emf.ecoretools.design/doc/user-guide.html#quality.dependencies"
										]
									]
								]
							]
						]
						toolSections += ToolSection.create [
							name = "Existing Elements"
							ownedTools += SelectionWizardDescription.create [
								name = "Add"
								precondition = "service:isEPackage"
								forceRefresh = true
								candidatesExpression = "service:getValidsForDiagram(containerView)"
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
										subModelOperations += If.create [
											conditionExpression = "service:isEPackage"
											subModelOperations += CreateView.create [
												containerViewExpression = "var:containerView"
												mapping = ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Review").ownedRepresentations.at(DiagramDescription, "Dependencies").defaultLayer.containerMappings.at("Analyzed Package") ]
											]
										]
									]
								]
							]
							ownedTools += ToolDescription.create [
								name = "RemoveExistingElements"
								label = "Remove"
								precondition = "aql:containerView.oclIsKindOf(diagram::DDiagram)"
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
								name = "External EPackageTo Analyze from treeview"
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
										subModelOperations += If.create [
											conditionExpression = "service:isEPackage"
											subModelOperations += CreateView.create [
												containerViewExpression = "var:newContainerView"
												mapping = ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Review").ownedRepresentations.at(DiagramDescription, "Dependencies").defaultLayer.containerMappings.at("Analyzed Package") ]
											]
										]
									]
								]
							]
							ownedTools += OperationAction.create [
								name = "Add Related Elements"
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
										subModelOperations += If.create [
											conditionExpression = "service:isEPackage"
											subModelOperations += CreateView.create [
												containerViewExpression = "var:diagram"
												mapping = ContainerMapping.ref("PlainDesign")[ (it as Group).ownedViewpoints.at("Design").ownedRepresentations.at(DiagramDescription, "Entities").defaultLayer.containerMappings.at("EC EClass") ]
											]
										]
									]
								]
							]
						]
					]
				]
				ownedJavaExtensions += JavaExtension.create [
					qualifiedClassName = "org.eclipse.emf.ecoretools.design.service.ReviewServices"
				]
				ownedJavaExtensions += JavaExtension.create [
					qualifiedClassName = "org.eclipse.emf.ecoretools.design.service.PropertiesServices"
				]
				ownedJavaExtensions += JavaExtension.create [
					qualifiedClassName = "org.eclipse.emf.ecoretools.design.service.ALEServices"
				]
			]
			ownedViewpoints += Viewpoint.create [
				endUserDocumentation = "Adds support for EMF GenModel configuration."
				name = "Generation"
				modelFileExtension = "genmodel"
				ownedRepresentations += EditionTableDescription.create [
					documentation = "<html>\n<head>\n</head>\n<body>\n<p>To set generation related parameters:</p>\n<ul>\n  <li>the property category</li>\n  <li>the user facing documentation for each property</li>\n</ul>\n<br>\n</body>\n</html>\n\n\n"
					name = "GenPackage Attributes"
					label = "Properties attributes and categories"
					titleExpression = "aql:self.prefix + ' generation table'"
					domainClass = "genmodel.GenPackage"
					metamodel += org.eclipse.emf.codegen.ecore.genmodel.GenModelPackage.eINSTANCE
					metamodel += org.eclipse.emf.ecore.EcorePackage.eINSTANCE
					ownedLineMappings += LineMapping.create [
						name = "GenClass"
						domainClass = "genmodel.GenClass"
						headerLabelExpression = "aql:self.ecoreClass.name"
						ownedSubLines += LineMapping.create [
							name = "GenFeature"
							domainClass = "genmodel.GenFeature"
							semanticCandidatesExpression = "aql:self.eAllContents(genmodel::GenFeature)->select(a | a.ecoreFeature.oclIsTypeOf(ecore::EAttribute) or a.ecoreFeature.oclIsTypeOf(ecore::EReference) and not(a.ecoreFeature.oclAsType(ecore::EReference).containment) and not(a.ecoreFeature.oclAsType(ecore::EReference).derived))"
							headerLabelExpression = "aql:self.ecoreFeature.name"
							backgroundConditionalStyle += BackgroundConditionalStyle.create [
								predicateExpression = "aql:self.propertyCategory = ''"
								style = BackgroundStyleDescription.create [
									backgroundColor = Environment.extraRef("$0").systemColors.entries.at("light_yellow")
								]
							]
						]
					]
					ownedColumnMappings += FeatureColumnMapping.create [
						name = "Category"
						headerLabelExpression = "Category"
						canEdit = "aql:self.oclIsTypeOf(genmodel::GenFeature)"
						featureName = "propertyCategory"
						labelExpression = "aql:self->filter(genmodel::GenFeature).propertyCategory->first()"
					]
					ownedColumnMappings += FeatureColumnMapping.create [
						name = "Decription"
						headerLabelExpression = "Description"
						canEdit = "aql:self.oclIsTypeOf(genmodel::GenFeature)"
						featureName = "propertyDescription"
						labelExpression = "aql:self->filter(genmodel::GenFeature).propertyDescription->first()"
					]
				]
				ownedJavaExtensions += JavaExtension.create [
					qualifiedClassName = "org.eclipse.emf.ecoretools.design.service.GenerationServices"
				]
				ownedJavaExtensions += JavaExtension.create [
					qualifiedClassName = "org.eclipse.emf.ecoretools.design.service.PropertiesServices"
				]
				ownedJavaExtensions += JavaExtension.create [
					qualifiedClassName = "org.eclipse.emf.ecoretools.design.service.ALEServices"
				]
			]
			userColorsPalettes += UserColorsPalette.create [
				name = "Ecore Palette"
				entries += InterpolatedColor.create [
					name = "Size Based Color"
					minValueComputationExpression = "aql:0"
					maxValueComputationExpression = "aql:10"
				]
				entries += UserFixedColor.create [
					red = 250
					green = 190
					blue = 190
					name = "MomentIntervalColor"
				]
				entries += UserFixedColor.create [
					red = 250
					green = 240
					blue = 180
					name = "RoleColor"
				]
				entries += UserFixedColor.create [
					red = 180
					green = 230
					blue = 180
					name = "PartyPlaceThingColor"
				]
				entries += UserFixedColor.create [
					red = 180
					green = 200
					blue = 210
					name = "DescriptionColor"
				]
				entries += UserFixedColor.create [
					red = 255
					green = 245
					blue = 182
					name = "Package Color"
				]
				entries += UserFixedColor.create [
					red = 253
					green = 208
					blue = 142
					name = "External Package Color"
				]
				entries += UserFixedColor.create [
					red = 255
					green = 252
					blue = 216
					name = "EClass"
				]
				entries += UserFixedColor.create [
					red = 217
					green = 210
					blue = 220
					name = "EPackage"
				]
				entries += UserFixedColor.create [
					red = 255
					green = 250
					blue = 191
					name = "EDataType"
				]
				entries += UserFixedColor.create [
					red = 221
					green = 236
					blue = 202
					name = "EEnum"
				]
				entries += UserFixedColor.create [
					name = "Dark EClass"
				]
				entries += UserFixedColor.create [
					name = "Dark EPackage"
				]
				entries += UserFixedColor.create [
					name = "Dark EDataType"
				]
				entries += UserFixedColor.create [
					name = "Dark EEnum"
				]
				entries += UserFixedColor.create [
					red = 220
					green = 234
					blue = 183
					name = "Doc Annotation"
				]
				entries += UserFixedColor.create [
					red = 228
					green = 228
					blue = 228
					name = "Abstract EClass"
				]
				entries += UserFixedColor.create [
					name = "Inherited"
				]
			]
			extensions += ViewExtensionDescription.create [
				name = "ecoretools"
				metamodels += org.eclipse.emf.ecore.EcorePackage.eINSTANCE
				metamodels += org.eclipse.emf.codegen.ecore.genmodel.GenModelPackage.eINSTANCE
				categories += Category.create [
					name = "Default"
					pages += PageDescription.create [
						name = "ecore_page"
						labelExpression = "Ecore"
						semanticCandidateExpression = "var:self"
						groups += GroupDescription.ref("PlainDesign")[ ((it as Group).extensions.head as ViewExtensionDescription).categories.head.groups.get(0) ]
						groups += GroupDescription.ref("PlainDesign")[ ((it as Group).extensions.head as ViewExtensionDescription).categories.head.groups.get(5) ]
						validationSet = PageValidationSetDescription.create [
							semanticValidationRules += SemanticValidationRule.create [
								name = "NoNameOrInvalid"
								level = ERROR_LEVEL.ERROR_LITERAL
								message = "aql:' The '  + self.eClass().name +  ' should have a name which is a valid Java identifier.'"
								targetClass = "ecore::ENamedElement"
								audits += RuleAudit.create [
									auditExpression = "aql: (not self.oclIsKindOf(ecore::ENamedElement) ) or (self.name <> null and self.name.size() > 0)"
								]
							]
						]
					]
					pages += PageDescription.create [
						name = "parameters_page"
						labelExpression = "Parameters"
						domainClass = "ecore::EOperation"
						semanticCandidateExpression = "var:self"
						indented = true
						groups += GroupDescription.ref("PlainDesign")[ ((it as Group).extensions.head as ViewExtensionDescription).categories.head.groups.get(9) ]
						validationSet = PageValidationSetDescription.create [
							semanticValidationRules += SemanticValidationRule.create [
								name = "NoNameOrInvalid"
								level = ERROR_LEVEL.ERROR_LITERAL
								message = "aql:' The '  + self.eClass().name +  ' should have a name which is a valid Java identifier.'"
								targetClass = "ecore::ENamedElement"
								audits += RuleAudit.create [
									auditExpression = "aql:(not self.oclIsKindOf(ecore::ENamedElement) ) or self.name <> null and self.name.size() > 0"
								]
							]
						]
					]
					pages += PageDescription.create [
						name = "documentation_page"
						labelExpression = "Documentation"
						semanticCandidateExpression = "var:self"
						indented = true
						groups += GroupDescription.ref("PlainDesign")[ ((it as Group).extensions.head as ViewExtensionDescription).categories.head.groups.get(2) ]
					]
					pages += PageDescription.create [
						name = "annotation_page"
						labelExpression = "Annotation"
						semanticCandidateExpression = "var:self"
						indented = true
						groups += GroupDescription.ref("PlainDesign")[ ((it as Group).extensions.head as ViewExtensionDescription).categories.head.groups.get(10) ]
						actions += ToolbarAction.create [
							tooltipExpression = "Add EAnnotation"
							imageExpression = "/org.eclipse.emf.ecore.edit/icons/full/ctool16/CreateEModelElement_eAnnotations_EAnnotation.gif"
							initialOperation = InitialOperation.create [
								firstModelOperations = ChangeContext.create [
									browseExpression = "var:self"
									subModelOperations += CreateInstance.create [
										typeName = "ecore::EAnnotation"
										referenceName = "eAnnotations"
									]
								]
							]
						]
					]
					pages += PageDescription.create [
						name = "generation_page"
						labelExpression = "Generation"
						semanticCandidateExpression = "aql:self"
						preconditionExpression = "aql:self.eInverse()->select( g | g.eClass().ePackage.nsURI->includes('http://www.eclipse.org/emf/2002/GenModel'))->asSet()->size() > 0"
						groups += GroupDescription.ref("PlainDesign")[ ((it as Group).extensions.head as ViewExtensionDescription).categories.head.groups.get(4) ]
						groups += GroupDescription.ref("PlainDesign")[ ((it as Group).extensions.head as ViewExtensionDescription).categories.head.groups.get(1) ]
						groups += GroupDescription.ref("PlainDesign")[ ((it as Group).extensions.head as ViewExtensionDescription).categories.head.groups.get(3) ]
						groups += GroupDescription.ref("PlainDesign")[ ((it as Group).extensions.head as ViewExtensionDescription).categories.head.groups.get(6) ]
						actions += ToolbarAction.create [
							tooltipExpression = "Generate Model"
							imageExpression = "/org.eclipse.emf.ecoretools.design/icons/full/etools16/generate_single.gif"
							initialOperation = InitialOperation.create [
								firstModelOperations = ChangeContext.create [
									browseExpression = "var:self"
									subModelOperations += ExternalJavaAction.create [
										name = "Generate Model Properties"
										id = "org.eclipse.emf.ecoretools.design.action.generateAllID"
										parameters += ExternalJavaActionParameter.create [
											name = "genmodels"
											value = "aql:self.eInverse()->select( g | g.eClass().ePackage.nsURI->includes('http://www.eclipse.org/emf/2002/GenModel'))->asSet().eContainerOrSelf(genmodel::GenModel)->asSet()"
										]
										parameters += ExternalJavaActionParameter.create [
											name = "scope"
											value = "model"
										]
									]
								]
							]
						]
						actions += ToolbarAction.create [
							tooltipExpression = "Generate Edit"
							imageExpression = "/org.eclipse.emf.ecoretools.design/icons/full/etools16/generate_single.gif"
							initialOperation = InitialOperation.create [
								firstModelOperations = ChangeContext.create [
									browseExpression = "var:self"
									subModelOperations += ExternalJavaAction.create [
										name = "Generate Edit Properties"
										id = "org.eclipse.emf.ecoretools.design.action.generateAllID"
										parameters += ExternalJavaActionParameter.create [
											name = "genmodels"
											value = "aql:self.eInverse()->select( g | g.eClass().ePackage.nsURI->includes('http://www.eclipse.org/emf/2002/GenModel'))->asSet().eContainerOrSelf(genmodel::GenModel)->asSet()"
										]
										parameters += ExternalJavaActionParameter.create [
											name = "scope"
											value = "edit"
										]
									]
								]
							]
						]
						actions += ToolbarAction.create [
							tooltipExpression = "Generate Editor"
							imageExpression = "/org.eclipse.emf.ecoretools.design/icons/full/etools16/generate_single.gif"
							initialOperation = InitialOperation.create [
								firstModelOperations = ChangeContext.create [
									browseExpression = "var:self"
									subModelOperations += ExternalJavaAction.create [
										name = "Generate Editor Properties"
										id = "org.eclipse.emf.ecoretools.design.action.generateAllID"
										parameters += ExternalJavaActionParameter.create [
											name = "genmodels"
											value = "aql:self.eInverse()->select( g | g.eClass().ePackage.nsURI->includes('http://www.eclipse.org/emf/2002/GenModel'))->asSet().eContainerOrSelf(genmodel::GenModel)->asSet()"
										]
										parameters += ExternalJavaActionParameter.create [
											name = "scope"
											value = "editor"
										]
									]
								]
							]
						]
						actions += ToolbarAction.create [
							tooltipExpression = "Generate All"
							imageExpression = "/org.eclipse.emf.ecoretools.design/icons/full/etools16/generate.gif"
							initialOperation = InitialOperation.create [
								firstModelOperations = ChangeContext.create [
									browseExpression = "var:self"
									subModelOperations += ExternalJavaAction.create [
										name = "Generate All Properties"
										id = "org.eclipse.emf.ecoretools.design.action.generateAllID"
										parameters += ExternalJavaActionParameter.create [
											name = "genmodels"
											value = "aql:self.eInverse()->select( g | g.eClass().ePackage.nsURI->includes('http://www.eclipse.org/emf/2002/GenModel'))->asSet().eContainerOrSelf(genmodel::GenModel)->asSet()"
										]
										parameters += ExternalJavaActionParameter.create [
											name = "scope"
											value = "model, edit, editor, tests"
										]
									]
								]
							]
						]
					]
					pages += PageDescription.create [
						name = "execution_page"
						labelExpression = "Execution"
						semanticCandidateExpression = "var:self"
						preconditionExpression = "aql:self.eContainerOrSelf(ecore::EPackage).isConfiguredForALE()"
						groups += GroupDescription.ref("PlainDesign")[ ((it as Group).extensions.head as ViewExtensionDescription).categories.head.groups.get(7) ]
						groups += GroupDescription.ref("PlainDesign")[ ((it as Group).extensions.head as ViewExtensionDescription).categories.head.groups.get(8) ]
					]
					groups += GroupDescription.create [
						name = "default rules"
						labelExpression = "aql:input.emfEditServices(self).getText()"
						semanticCandidateExpression = "aql:self.removeSemanticElementsToHide(input.getAllSemanticElements(),input.context().semanticDecorator())"
						preconditionExpression = ""
						controls += DynamicMappingForDescription.create [
							name = "sirius_default_rules_structural_features_for"
							iterator = "eStructuralFeature"
							iterableExpression = "aql:self.removeFeaturesToHide(input.emfEditServices(self).getEStructuralFeatures())"
							ifs += DynamicMappingIfDescription.create [
								name = "sirius_default_rules_mono_string_if"
								predicateExpression = "aql:input.emfEditServices(self).needsTextWidget(eStructuralFeature) and not input.emfEditServices(self).isMultiline(eStructuralFeature)"
								widget = TextDescription.create [
									name = "sirius_default_rules_mono_string"
									labelExpression = "aql:input.emfEditServices(self).getText(eStructuralFeature)+':'"
									helpExpression = "aql:input.emfEditServices(self).getDescription(eStructuralFeature)"
									isEnabledExpression = "aql:eStructuralFeature.changeable"
									valueExpression = "aql:if eStructuralFeature.name = 'upperBound' and self.oclIsKindOf(ecore::ETypedElement) then self.upperBoundDisplay() else self.eGet(eStructuralFeature.name) endif"
									initialOperation = InitialOperation.create [
										firstModelOperations = ChangeContext.create [
											browseExpression = "var:self"
											subModelOperations += Switch.create [
												cases += Case.create [
													conditionExpression = "aql:eStructuralFeature.name = 'upperBound' and self.oclIsKindOf(ecore::ETypedElement)"
													subModelOperations += ChangeContext.create [
														browseExpression = "aql:self.setUpperBound(newValue)"
													]
												]
												^default = Default.create [
													subModelOperations += ChangeContext.create [
														browseExpression = "aql:input.emfEditServices(self).setValue(eStructuralFeature, newValue)"
													]
												]
											]
										]
									]
									conditionalStyles += TextWidgetConditionalStyle.create [
										preconditionExpression = "aql:eStructuralFeature.lowerBound==1"
										style = TextWidgetStyle.create [
											labelFontFormat += FontFormat.BOLD_LITERAL
										]
									]
								]
							]
							ifs += DynamicMappingIfDescription.create [
								name = "sirius_default_rules_multi_string_if"
								predicateExpression = "aql:input.emfEditServices(self).needsTextWidget(eStructuralFeature) and input.emfEditServices(self).isMultiline(eStructuralFeature)"
								widget = TextAreaDescription.create [
									name = "sirius_default_rules_multi_string"
									labelExpression = "aql:input.emfEditServices(self).getText(eStructuralFeature)+':'"
									helpExpression = "aql:input.emfEditServices(self).getDescription(eStructuralFeature)"
									isEnabledExpression = "aql:eStructuralFeature.changeable"
									valueExpression = "aql:self.eGet(eStructuralFeature.name)"
									initialOperation = InitialOperation.create [
										firstModelOperations = ChangeContext.create [
											browseExpression = "aql:input.emfEditServices(self).setValue(eStructuralFeature, newValue)"
										]
									]
									conditionalStyles += TextWidgetConditionalStyle.create [
										preconditionExpression = "aql:eStructuralFeature.lowerBound==1"
										style = TextWidgetStyle.create [
											labelFontFormat += FontFormat.BOLD_LITERAL
										]
									]
								]
							]
							ifs += DynamicMappingIfDescription.create [
								name = "sirius_default_rules_mono_boolean"
								predicateExpression = "aql:input.emfEditServices(self).needsCheckboxWidget(eStructuralFeature)"
								widget = CheckboxDescription.create [
									name = "sirius_default_rules_mono_boolean"
									labelExpression = "aql:input.emfEditServices(self).getText(eStructuralFeature)"
									helpExpression = "aql:input.emfEditServices(self).getDescription(eStructuralFeature)"
									isEnabledExpression = "aql:eStructuralFeature.changeable"
									valueExpression = "aql:self.eGet(eStructuralFeature.name)"
									initialOperation = InitialOperation.create [
										firstModelOperations = ChangeContext.create [
											browseExpression = "aql:input.emfEditServices(self).setValue(eStructuralFeature, newValue)"
										]
									]
									conditionalStyles += CheckboxWidgetConditionalStyle.create [
										preconditionExpression = "aql:eStructuralFeature.lowerBound==1"
										style = CheckboxWidgetStyle.create [
											labelFontFormat += FontFormat.BOLD_LITERAL
										]
									]
								]
							]
							ifs += DynamicMappingIfDescription.create [
								name = "sirius_default_rules_enum_if"
								predicateExpression = "aql:eStructuralFeature.eType.oclIsKindOf(ecore::EEnum) and not(eStructuralFeature.many)"
								widget = RadioDescription.create [
									name = "sirius_default_rules_enum"
									labelExpression = "aql:input.emfEditServices(self).getText(eStructuralFeature)+':'"
									helpExpression = "aql:input.emfEditServices(self).getDescription(eStructuralFeature)"
									isEnabledExpression = "aql:eStructuralFeature.changeable"
									valueExpression = "aql:eStructuralFeature.eType.oclAsType(ecore::EEnum).getEEnumLiteralByLiteral(self.eGet(eStructuralFeature.name).toString())"
									candidatesExpression = "aql:eStructuralFeature.eType.oclAsType(ecore::EEnum).eLiterals"
									candidateDisplayExpression = "aql:candidate.name"
									numberOfColumns = 5
									initialOperation = InitialOperation.create [
										firstModelOperations = ChangeContext.create [
											browseExpression = "aql:input.emfEditServices(self).setValue(eStructuralFeature, newValue.instance)"
										]
									]
									conditionalStyles += RadioWidgetConditionalStyle.create [
										preconditionExpression = "aql:eStructuralFeature.lowerBound==1"
										style = RadioWidgetStyle.create [
											labelFontFormat += FontFormat.BOLD_LITERAL
										]
									]
								]
							]
							ifs += DynamicMappingIfDescription.create [
								name = "sirius_default_rules_eattribute_many_if"
								predicateExpression = "aql:eStructuralFeature.oclIsKindOf(ecore::EAttribute) and eStructuralFeature.many"
								widget = ListDescription.create [
									name = "sirius_default_rules_eattribute_many"
									labelExpression = "aql:input.emfEditServices(self).getText(eStructuralFeature)+':'"
									helpExpression = "aql:input.emfEditServices(self).getDescription(eStructuralFeature)"
									isEnabledExpression = "aql:eStructuralFeature.changeable"
									valueExpression = "aql:self.eGet(eStructuralFeature.name)"
									displayExpression = "var:value"
								]
							]
							ifs += DynamicMappingIfDescription.create [
								name = "sirius_default_rules_ereference_if"
								predicateExpression = "aql:eStructuralFeature.oclIsKindOf(ecore::EReference) and eStructuralFeature.many = true"
								widget = ExtReferenceDescription.create [
									name = "sirius_default_rules_ereference"
									labelExpression = "aql:input.emfEditServices(self).getText(eStructuralFeature)+':'"
									helpExpression = "aql:input.emfEditServices(self).getDescription(eStructuralFeature)"
									referenceNameExpression = "aql:eStructuralFeature.name"
								]
							]
							ifs += DynamicMappingIfDescription.create [
								name = "ecoretools_etype_ereference"
								predicateExpression = "aql:eStructuralFeature.oclIsKindOf(ecore::EReference) and eStructuralFeature.many = false"
								widget = LabelDescription.create [
									name = "etype label"
									labelExpression = "aql:input.emfEditServices(self).getText(eStructuralFeature)+':'"
									helpExpression = "aql:input.emfEditServices(self).getDescription(eStructuralFeature)"
									valueExpression = "aql:self.eGetMonoRef(eStructuralFeature)"
									displayExpression = "aql:if self.eGetMonoRef(eStructuralFeature) <> null then input.emfEditServices(self.eGetMonoRef(eStructuralFeature)).getText() else '' endif"
									actions += WidgetAction.create [
										labelExpression = "..."
										initialOperation = InitialOperation.create [
											firstModelOperations = ExternalJavaAction.create [
												name = "open select etype dialog"
												id = "org.eclipse.emf.ecoretools.design.action.openSelectModelElementID"
												parameters += ExternalJavaActionParameter.create [
													name = "message"
													value = "aql:'Select an ' + eStructuralFeature.eType.name +  ' for the ' + eStructuralFeature.name +  ' reference.'"
												]
												parameters += ExternalJavaActionParameter.create [
													name = "title"
													value = "aql:'Select ' + eStructuralFeature.eType.name "
												]
												parameters += ExternalJavaActionParameter.create [
													name = "candidates"
													value = "aql:input.emfEditServices(self).getChoiceOfValues(eStructuralFeature)"
												]
												parameters += ExternalJavaActionParameter.create [
													name = "feature"
													value = "var:eStructuralFeature"
												]
												parameters += ExternalJavaActionParameter.create [
													name = "host"
													value = "var:self"
												]
											]
										]
									]
									actions += WidgetAction.create [
										labelExpression = "∅"
										initialOperation = InitialOperation.create [
											firstModelOperations = ChangeContext.create [
												browseExpression = "var:self"
												subModelOperations += ChangeContext.create [
													browseExpression = "aql:input.emfEditServices(self).setValue(eStructuralFeature, null)"
												]
											]
										]
									]
								]
							]
						]
						style = GroupStyle.create [
							barStyle = TitleBarStyle.NO_TITLE
							toggleStyle = ToggleStyle.NONE
							expandedByDefault = true
						]
						conditionalStyles += GroupConditionalStyle.create [
							preconditionExpression = "aql:self.removeSemanticElementsToHide(input.getAllSemanticElements(),input.context().semanticDecorator())->size() > 1"
							style = GroupStyle.create [
								toggleStyle = ToggleStyle.NONE
								expandedByDefault = true
							]
						]
					]
					groups += GroupDescription.create [
						name = "genmodel opposite instance"
						labelExpression = "aql:self.eClass().name"
						semanticCandidateExpression = "aql:self.eInverse()->select( g | g.eClass().ePackage.nsURI->includes('http://www.eclipse.org/emf/2002/GenModel'))->asSet()"
						preconditionExpression = ""
						extends = GroupDescription.ref("PlainDesign")[ ((it as Group).extensions.head as ViewExtensionDescription).categories.head.groups.get(0) ]
						style = GroupStyle.create [
							expandedByDefault = true
						]
					]
					groups += GroupDescription.create [
						name = "documentation"
						labelExpression = "Documentation"
						domainClass = "ecore::EModelElement"
						controls += ContainerDescription.create [
							name = "documentation_container"
							controls += TextAreaDescription.create [
								name = "doc_area"
								lineCount = 16
								valueExpression = "aql:self.getVisibleDocAnnotations().value"
								initialOperation = InitialOperation.create [
									firstModelOperations = ChangeContext.create [
										browseExpression = "aql:self.setDocAnnotation(newValue)"
									]
								]
							]
						]
						style = GroupStyle.create [
							barStyle = TitleBarStyle.NO_TITLE
							toggleStyle = ToggleStyle.NONE
							expandedByDefault = true
						]
					]
					groups += GroupDescription.create [
						name = "generation_navigation"
						semanticCandidateExpression = "aql:self.eInverse()->select( g | g.eClass().ePackage.nsURI->includes('http://www.eclipse.org/emf/2002/GenModel'))->asSet()"
						controls += ContainerDescription.create [
							name = "generation_navigation_container"
							controls += HyperlinkDescription.create [
								name = "goto sourcecode"
								isEnabledExpression = "aql:self.isJavaFileGenerated()"
								valueExpression = "aql:self"
								displayExpression = "aql:if self.isJavaFileGenerated() then 'Open Java Implementation' else '' endif"
								initialOperation = InitialOperation.create [
									firstModelOperations = ExternalJavaAction.create [
										name = "open java editor"
										id = "org.eclipse.emf.ecoretools.design.action.openFileInEditorID"
										parameters += ExternalJavaActionParameter.create [
											name = "path"
											value = "aql:self.getJavaImplementationPath()"
										]
									]
								]
							]
						]
						style = GroupStyle.create [
							barStyle = TitleBarStyle.NO_TITLE
							toggleStyle = ToggleStyle.NONE
							expandedByDefault = true
						]
					]
					groups += GroupDescription.create [
						name = "genmodel_directories"
						labelExpression = "Directories"
						domainClass = "genmodel.GenModel"
						semanticCandidateExpression = "aql:(OrderedSet{self} + self.eInverse()  + self.eInverse().eContainer()- self.eContents()- OrderedSet{self.eContainer()})->select(e | e.eClass().ePackage.nsURI->includes('http://www.eclipse.org/emf/2002/GenModel'))->asSet()"
						controls += TextDescription.create [
							name = "modelDirectory"
							labelExpression = "Model"
							valueExpression = "aql:self.modelDirectory"
							initialOperation = InitialOperation.create [
								firstModelOperations = SetValue.create [
									featureName = "modelDirectory"
									valueExpression = "var:newValue"
								]
							]
						]
						controls += TextDescription.create [
							name = "editDirectory"
							labelExpression = "Edit"
							valueExpression = "feature:editDirectory"
							initialOperation = InitialOperation.create [
								firstModelOperations = SetValue.create [
									featureName = "editDirectory"
									valueExpression = "var:newValue"
								]
							]
						]
						controls += TextDescription.create [
							name = "editorDirectory"
							labelExpression = "Editor"
							valueExpression = "feature:editorDirectory"
							initialOperation = InitialOperation.create [
								firstModelOperations = SetValue.create [
									featureName = "editorDirectory"
									valueExpression = "var:newValue"
								]
							]
						]
						style = GroupStyle.create [
							barStyle = TitleBarStyle.SHORT_TITLE_BAR
							expandedByDefault = true
						]
					]
					groups += GroupDescription.create [
						name = "egeneric supertypes-TBD"
						labelExpression = "aql:'EGenericType : ' + input.emfEditServices(self).getText()"
						domainClass = "ecore::EGenericType"
						semanticCandidateExpression = "aql: input.getSemanticElement()->filter(ecore::EClass).eGenericSuperTypes"
						preconditionExpression = "aql:false and self.oclIsKindOf(ecore::EClass)"
						controls += LabelDescription.create [
							name = "etypeparameter label"
							labelExpression = "EType Parameter:"
							valueExpression = "aql:self.eTypeArguments->first().eTypeParameter"
							displayExpression = "aql:self.eTypeArguments->first().eTypeParameter.name"
							actions += WidgetAction.create [
								labelExpression = "..."
								initialOperation = InitialOperation.create [
									firstModelOperations = Let.create [
										variableName = "eStructuralFeature"
										valueExpression = "aql:self.eClass().getEStructuralFeature('eTypeParameter')"
										subModelOperations += ExternalJavaAction.create [
											name = "open select etype dialog"
											id = "org.eclipse.emf.ecoretools.design.action.openSelectModelElementID"
											parameters += ExternalJavaActionParameter.create [
												name = "message"
												value = "aql:'Select an ' + eStructuralFeature.eType.name +  ' for the ' + eStructuralFeature.name +  ' reference.'"
											]
											parameters += ExternalJavaActionParameter.create [
												name = "title"
												value = "aql:'Select ' + eStructuralFeature.eType.name "
											]
											parameters += ExternalJavaActionParameter.create [
												name = "candidates"
												value = "aql:input.emfEditServices(self).getChoiceOfValues(eStructuralFeature)"
											]
											parameters += ExternalJavaActionParameter.create [
												name = "feature"
												value = "var:eStructuralFeature"
											]
											parameters += ExternalJavaActionParameter.create [
												name = "host"
												value = "var:self"
											]
										]
									]
								]
							]
						]
						controls += LabelDescription.create [
							name = "EClassifier label"
							labelExpression = "Classifier:"
							valueExpression = "aql:self.eTypeArguments->at(2).eClassifier"
							displayExpression = "aql:self.eTypeArguments->at(2).eClassifier.name"
							actions += WidgetAction.create [
								labelExpression = "..."
								initialOperation = InitialOperation.create [
									firstModelOperations = Let.create [
										variableName = "eStructuralFeature"
										valueExpression = "aql:self.eClass().getEStructuralFeature('eClassifier')"
										subModelOperations += ExternalJavaAction.create [
											name = "open select etype dialog"
											id = "org.eclipse.emf.ecoretools.design.action.openSelectModelElementID"
											parameters += ExternalJavaActionParameter.create [
												name = "message"
												value = "aql:'Select an ' + eStructuralFeature.eType.name +  ' for the ' + eStructuralFeature.name +  ' reference.'"
											]
											parameters += ExternalJavaActionParameter.create [
												name = "title"
												value = "aql:'Select ' + eStructuralFeature.eType.name "
											]
											parameters += ExternalJavaActionParameter.create [
												name = "candidates"
												value = "aql:input.emfEditServices(self).getChoiceOfValues(eStructuralFeature)"
											]
											parameters += ExternalJavaActionParameter.create [
												name = "feature"
												value = "var:eStructuralFeature"
											]
											parameters += ExternalJavaActionParameter.create [
												name = "host"
												value = "var:self"
											]
										]
									]
								]
							]
						]
					]
					groups += GroupDescription.create [
						name = "genmodel root"
						labelExpression = "aql:self.eClass().name"
						semanticCandidateExpression = "aql:self->select(e | e.oclIsKindOf(ecore::EPackage)).eInverse()->select( g | g.eClass().ePackage.nsURI->includes('http://www.eclipse.org/emf/2002/GenModel')).eContainer(genmodel::GenModel)->asSet()"
						preconditionExpression = ""
						extends = GroupDescription.ref("PlainDesign")[ ((it as Group).extensions.head as ViewExtensionDescription).categories.head.groups.get(0) ]
						style = GroupStyle.create [
							expandedByDefault = true
						]
					]
					groups += GroupDescription.create [
						name = "execution_body"
						labelExpression = "aql:self.getExecutableName()"
						semanticCandidateExpression = "aql:OrderedSet{self}->filter(ecore::EClassifier).getAllExecutables()"
						controls += ContainerDescription.create [
							name = "container_execution_body"
							controls += TextAreaDescription.create [
								name = "executable_body"
								lineCount = 14
								valueExpression = "aql:self.getExecutableBody()"
								initialOperation = InitialOperation.create [
									firstModelOperations = ChangeContext.create [
										browseExpression = "var:self"
										subModelOperations += ChangeContext.create [
											browseExpression = "aql:self.setExecutableBody(newValue)"
										]
									]
								]
							]
						]
						validationSet = GroupValidationSetDescription.create [
							semanticValidationRules += SemanticValidationRule.create [
								name = "isValidSyntax"
								level = ERROR_LEVEL.ERROR_LITERAL
								message = "Syntax error in body"
								targetClass = "EObject"
								audits += RuleAudit.create [
									auditExpression = "aql:self.isValidBody()"
								]
							]
						]
						style = GroupStyle.create [
							barStyle = TitleBarStyle.NO_TITLE
							toggleStyle = ToggleStyle.NONE
							expandedByDefault = true
						]
					]
					groups += GroupDescription.create [
						name = "execution_imports"
						labelExpression = "Imports"
						domainClass = "ecore::EModelElement"
						semanticCandidateExpression = "aql:OrderedSet{self}->filter(ecore::EPackage)->select(p | p.getJavaImports()->size() > 0)"
						controls += ButtonDescription.create [
							name = "execution_button_addimport"
							buttonLabelExpression = "Add New Import"
							initialOperation = InitialOperation.create [
								firstModelOperations = ChangeContext.create [
									browseExpression = "var:self"
								]
							]
						]
						controls += ContainerDescription.create [
							name = "execution_imports_container"
							controls += DynamicMappingForDescription.create [
								name = "iterate over imports"
								iterator = "jImport"
								iterableExpression = "aql:self.getJavaImports()"
								ifs += DynamicMappingIfDescription.create [
									name = "true"
									predicateExpression = "aql:true"
									widget = TextDescription.create [
										name = "java_import"
										labelExpression = "Qualified Class Name: "
										valueExpression = "aql:jImport.getQualifiedName()"
										initialOperation = InitialOperation.create [
											firstModelOperations = ChangeContext.create [
												browseExpression = "aql:jImport.setQualifiedName(newValue)"
											]
										]
									]
								]
								ifs += DynamicMappingIfDescription.create [
									name = "true"
									predicateExpression = "aql:true"
									widget = ButtonDescription.create [
										name = "execution_remove_import"
										buttonLabelExpression = "Remove Import"
										initialOperation = InitialOperation.create [
											firstModelOperations = ChangeContext.create [
												browseExpression = "var:jImport"
												subModelOperations += RemoveElement.create
											]
										]
									]
								]
							]
							layout = FillLayoutDescription.create [
								orientation = FILL_LAYOUT_ORIENTATION.HORIZONTAL
							]
						]
						style = GroupStyle.create [
							expandedByDefault = true
						]
					]
					groups += GroupDescription.create [
						name = "eoperation parameters dynamic mapping"
						labelExpression = "Parameters"
						domainClass = "ecore::EOperation"
						semanticCandidateExpression = "var:self"
						controls += ContainerDescription.create [
							name = "parameters_container"
							controls += DynamicMappingForDescription.create [
								name = "foreach parameter"
								iterator = "self"
								iterableExpression = "aql:self.eParameters"
								forceRefresh = true
								ifs += DynamicMappingIfDescription.create [
									name = "always true"
									predicateExpression = "aql:true"
									widget = TextDescription.create [
										name = "param_name"
										labelExpression = "Name: "
										valueExpression = "aql:self.name"
										initialOperation = InitialOperation.create [
											firstModelOperations = ChangeContext.create [
												browseExpression = "var:self"
												subModelOperations += SetValue.create [
													featureName = "name"
													valueExpression = "var:newValue"
												]
											]
										]
										style = TextWidgetStyle.create [
											labelFontSizeExpression = "8"
											labelFontFormat += FontFormat.ITALIC_LITERAL
										]
									]
								]
								ifs += DynamicMappingIfDescription.create [
									name = "always true"
									predicateExpression = "aql:true"
									widget = LabelDescription.create [
										name = "etype label"
										labelExpression = "EType: "
										valueExpression = "aql:self.eGet('eType')"
										displayExpression = "aql:self.eGet('eType').name"
										style = LabelWidgetStyle.create [
											labelFontSizeExpression = "8"
											labelFontFormat += FontFormat.ITALIC_LITERAL
										]
										actions += WidgetAction.create [
											labelExpression = "..."
											initialOperation = InitialOperation.create [
												firstModelOperations = ExternalJavaAction.create [
													name = "open select etype dialog"
													id = "org.eclipse.emf.ecoretools.design.action.openSelectModelElementID"
													parameters += ExternalJavaActionParameter.create [
														name = "message"
														value = "aql:'Select an EClass for the eType reference.'"
													]
													parameters += ExternalJavaActionParameter.create [
														name = "title"
														value = "aql:'Select EClass'"
													]
													parameters += ExternalJavaActionParameter.create [
														name = "candidates"
														value = "aql:input.emfEditServices(self).getChoiceOfValues(self.eClass().getEStructuralFeature('eType'))"
													]
													parameters += ExternalJavaActionParameter.create [
														name = "feature"
														value = "aql:self.eClass().getEStructuralFeature('eType')"
													]
													parameters += ExternalJavaActionParameter.create [
														name = "host"
														value = "var:self"
													]
												]
											]
										]
										actions += WidgetAction.create [
											labelExpression = "∅"
											initialOperation = InitialOperation.create [
												firstModelOperations = ChangeContext.create [
													browseExpression = "var:self"
													subModelOperations += SetValue.create [
														featureName = "eType"
														valueExpression = "aql:null"
													]
												]
											]
										]
									]
								]
								ifs += DynamicMappingIfDescription.create [
									name = "always true"
									predicateExpression = "aql:true"
									widget = ButtonDescription.create [
										name = "up"
										isEnabledExpression = "aql:self.precedingSiblings()->filter(ecore::EParameter)->size() > 0"
										imageExpression = "/org.eclipse.emf.ecoretools.design/icons/full/etools16/up.gif"
										initialOperation = InitialOperation.create [
											firstModelOperations = ChangeContext.create [
												browseExpression = "var:self"
												subModelOperations += ChangeContext.create [
													browseExpression = "aql:self.moveUpInContainer()"
												]
											]
										]
									]
								]
								ifs += DynamicMappingIfDescription.create [
									name = "always true"
									predicateExpression = "aql:true"
									widget = ButtonDescription.create [
										name = "down"
										isEnabledExpression = "aql:self.precedingSiblings()->filter(ecore::EParameter)->size() +1 < self.eContainer(ecore::EOperation).eParameters->size()"
										imageExpression = "/org.eclipse.emf.ecoretools.design/icons/full/etools16/down.gif"
										initialOperation = InitialOperation.create [
											firstModelOperations = ChangeContext.create [
												browseExpression = "var:self"
												subModelOperations += ChangeContext.create [
													browseExpression = "aql:self.moveDownInContainer()"
												]
											]
										]
									]
								]
								ifs += DynamicMappingIfDescription.create [
									name = "always true"
									predicateExpression = "aql:true"
									widget = ButtonDescription.create [
										name = "del"
										imageExpression = "/org.eclipse.emf.ecoretools.design/icons/full/etools16/unset.gif"
										initialOperation = InitialOperation.create [
											firstModelOperations = ChangeContext.create [
												browseExpression = "var:self"
												subModelOperations += RemoveElement.create
											]
										]
									]
								]
							]
							layout = GridLayoutDescription.create [
								numberOfColumns = 5
							]
						]
						controls += DynamicMappingForDescription.create [
							name = "dummy_workaround_bug515586"
							iterator = "d"
							iterableExpression = "aql:self"
							forceRefresh = true
							ifs += DynamicMappingIfDescription.create [
								name = "always false"
								predicateExpression = "aql:false"
								widget = TextDescription.create [
									name = "dummy"
									initialOperation = InitialOperation.create [
										firstModelOperations = ChangeContext.create [
											browseExpression = "var:self"
										]
									]
								]
							]
						]
						style = GroupStyle.create [
							expandedByDefault = true
						]
						actions += ToolbarAction.create [
							tooltipExpression = "Add New Parameter"
							imageExpression = "/org.eclipse.emf.ecore.edit/icons/full/ctool16/CreateEOperation_eParameters_EParameter.gif"
							initialOperation = InitialOperation.create [
								firstModelOperations = ChangeContext.create [
									browseExpression = "var:self"
									subModelOperations += CreateInstance.create [
										typeName = "ecore::EParameter"
										referenceName = "eParameters"
										subModelOperations += SetValue.create [
											featureName = "name"
											valueExpression = "aql:'param' + self.eContainer().eContents()->filter(ecore::EParameter)->size()"
										]
									]
								]
							]
						]
					]
					groups += GroupDescription.create [
						name = "eannotation dynamic"
						labelExpression = "aql:'EAnnotation ' + self.source"
						domainClass = "ecore::EAnnotation"
						semanticCandidateExpression = "aql:input.getSemanticElement()->filter(ecore::EModelElement).eAnnotations"
						controls += TextDescription.create [
							name = "source"
							labelExpression = "Source:"
							helpExpression = "aql:input.emfEditServices(self).getDescription(self.eClass().getEStructuralFeature('source'))"
							valueExpression = "aql:self.source"
							initialOperation = InitialOperation.create [
								firstModelOperations = ChangeContext.create [
									browseExpression = "var:self"
									subModelOperations += SetValue.create [
										featureName = "source"
										valueExpression = "var:newValue"
									]
								]
							]
						]
						controls += ExtReferenceDescription.create [
							name = "references ref"
							labelExpression = "aql:input.emfEditServices(self).getText(self.eClass().getEStructuralFeature('references'))+':'"
							helpExpression = "aql:input.emfEditServices(self).getDescription(self.eClass().getEStructuralFeature('references'))"
							referenceNameExpression = "references"
							referenceOwnerExpression = "aql:self"
						]
						controls += ContainerDescription.create [
							name = "eannota_buttons"
							controls += ButtonDescription.create [
								name = "eannotation_add_entry"
								buttonLabelExpression = "Add Entry"
								initialOperation = InitialOperation.create [
									firstModelOperations = ChangeContext.create [
										browseExpression = "var:self"
										subModelOperations += CreateInstance.create [
											typeName = "ecore.EStringToStringMapEntry"
											referenceName = "details"
										]
									]
								]
							]
						]
						controls += ContainerDescription.create [
							name = "eannotation_conainer_entries"
							controls += DynamicMappingForDescription.create [
								name = "iterate over entries"
								iterator = "self"
								iterableExpression = "aql:self.details"
								forceRefresh = true
								ifs += DynamicMappingIfDescription.create [
									name = "always_true"
									predicateExpression = "aql:true"
									widget = TextDescription.create [
										name = "detail_key"
										labelExpression = "Key:"
										valueExpression = "aql:self.key"
										initialOperation = InitialOperation.create [
											firstModelOperations = ChangeContext.create [
												browseExpression = "var:self"
												subModelOperations += SetValue.create [
													featureName = "key"
													valueExpression = "var:newValue"
												]
											]
										]
									]
								]
								ifs += DynamicMappingIfDescription.create [
									name = "always_true"
									predicateExpression = "aql:true"
									widget = TextDescription.create [
										name = "detail_value"
										labelExpression = "Value:"
										valueExpression = "aql:self.value"
										initialOperation = InitialOperation.create [
											firstModelOperations = ChangeContext.create [
												browseExpression = "var:self"
												subModelOperations += SetValue.create [
													featureName = "value"
													valueExpression = "var:newValue"
												]
											]
										]
									]
								]
								ifs += DynamicMappingIfDescription.create [
									name = "always_true"
									predicateExpression = "aql:true"
									widget = ButtonDescription.create [
										name = "del"
										helpExpression = "Delete the entry"
										imageExpression = "/org.eclipse.emf.ecoretools.design/icons/full/etools16/unset.gif"
										initialOperation = InitialOperation.create [
											firstModelOperations = ChangeContext.create [
												browseExpression = "var:self"
												subModelOperations += RemoveElement.create
											]
										]
									]
								]
							]
							layout = GridLayoutDescription.create [
								numberOfColumns = 3
							]
						]
						controls += DynamicMappingForDescription.create [
							name = "dummy_workaround_bug515586"
							iterator = "d"
							iterableExpression = "aql:self"
							forceRefresh = true
							ifs += DynamicMappingIfDescription.create [
								name = "always false"
								predicateExpression = "aql:false"
								widget = TextDescription.create [
									name = "dummy_text"
									initialOperation = InitialOperation.create [
										firstModelOperations = ChangeContext.create [
											browseExpression = "var:self"
										]
									]
								]
							]
						]
						style = GroupStyle.create [
							toggleStyle = ToggleStyle.TREE_NODE
							expandedByDefault = true
						]
						actions += ToolbarAction.create [
							tooltipExpression = "Delete EAnnotation"
							imageExpression = "/org.eclipse.emf.ecoretools.design/icons/full/etools16/unset.gif"
							initialOperation = InitialOperation.create [
								firstModelOperations = ChangeContext.create [
									browseExpression = "var:self"
									subModelOperations += RemoveElement.create
								]
							]
						]
					]
				]
			]
		].assemble
	}

	protected def void initExtras(ResourceSet it) {
		extras.putAll(#{ // anonymous resources
			"$0" -> eObject(Environment, "environment:/viewpoint#/")
		})
	}

	def <T> T extraRef(Class<T> type, String key) {
		extras.get(key) as T
	}
	
}
