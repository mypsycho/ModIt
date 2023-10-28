package org.eclipse.emf.ecoretools.design.split

import org.eclipse.emf.codegen.ecore.genmodel.GenModelPackage
import org.eclipse.emf.ecore.EcorePackage
import org.eclipse.sirius.diagram.BackgroundStyle
import org.eclipse.sirius.diagram.ContainerLayout
import org.eclipse.sirius.diagram.LabelPosition
import org.eclipse.sirius.diagram.LineStyle
import org.eclipse.sirius.diagram.ResizeKind
import org.eclipse.sirius.diagram.description.ContainerMapping
import org.eclipse.sirius.diagram.description.DiagramDescription
import org.eclipse.sirius.diagram.description.EdgeMapping
import org.eclipse.sirius.diagram.description.Layer
import org.eclipse.sirius.diagram.description.NodeMapping
import org.eclipse.sirius.diagram.description.style.BundledImageDescription
import org.eclipse.sirius.diagram.description.style.CenterLabelStyleDescription
import org.eclipse.sirius.diagram.description.style.EdgeStyleDescription
import org.eclipse.sirius.diagram.description.style.FlatContainerStyleDescription
import org.eclipse.sirius.diagram.description.tool.ContainerDropDescription
import org.eclipse.sirius.diagram.description.tool.CreateView
import org.eclipse.sirius.diagram.description.tool.DirectEditLabel
import org.eclipse.sirius.diagram.description.tool.ToolSection
import org.eclipse.sirius.viewpoint.LabelAlignment
import org.eclipse.sirius.viewpoint.description.Environment
import org.eclipse.sirius.viewpoint.description.Group
import org.eclipse.sirius.viewpoint.description.SystemColor
import org.eclipse.sirius.viewpoint.description.SytemColorsPalette
import org.eclipse.sirius.viewpoint.description.UserColorsPalette
import org.eclipse.sirius.viewpoint.description.UserFixedColor
import org.eclipse.sirius.viewpoint.description.style.LabelBorderStyleDescription
import org.eclipse.sirius.viewpoint.description.style.LabelBorderStyles
import org.eclipse.sirius.viewpoint.description.tool.ChangeContext
import org.eclipse.sirius.viewpoint.description.tool.ContainerViewVariable
import org.eclipse.sirius.viewpoint.description.tool.DeleteView
import org.eclipse.sirius.viewpoint.description.tool.DragSource
import org.eclipse.sirius.viewpoint.description.tool.DropContainerVariable
import org.eclipse.sirius.viewpoint.description.tool.ElementDropVariable
import org.eclipse.sirius.viewpoint.description.tool.ElementSelectVariable
import org.eclipse.sirius.viewpoint.description.tool.ElementVariable
import org.eclipse.sirius.viewpoint.description.tool.ElementViewVariable
import org.eclipse.sirius.viewpoint.description.tool.ExternalJavaAction
import org.eclipse.sirius.viewpoint.description.tool.ExternalJavaActionParameter
import org.eclipse.sirius.viewpoint.description.tool.For
import org.eclipse.sirius.viewpoint.description.tool.If
import org.eclipse.sirius.viewpoint.description.tool.InitialContainerDropOperation
import org.eclipse.sirius.viewpoint.description.tool.InitialOperation
import org.eclipse.sirius.viewpoint.description.tool.OperationAction
import org.eclipse.sirius.viewpoint.description.tool.SelectContainerVariable
import org.eclipse.sirius.viewpoint.description.tool.SelectModelElementVariable
import org.eclipse.sirius.viewpoint.description.tool.SelectionWizardDescription
import org.eclipse.sirius.viewpoint.description.tool.ToolDescription
import org.mypsycho.modit.emf.EModel
import static extension org.eclipse.emf.ecoretools.design.split.ToolDesign.*

class DependenciesDiagram extends EModel.Part<DiagramDescription> {

	new(ToolDesign parent) {
		super(DiagramDescription, parent)
	}

	protected override initContent(DiagramDescription it) {
		documentation = "<html>\n<head>\n</head>\n<body>\n<p>A  diagram used to highligh dependencies in between EPackages.</p>\n<br>\n<img src=\"/icons/full/wizban/packages.png\"/>\n</body>\n</html>\n\n\n"
		name = "Dependencies"
		label = "Package dependencies diagram"
		titleExpression = "aql:self.name + ' package dependencies'"
		domainClass = "ecore::EPackage"
		dropDescriptions += ContainerDropDescription.ref("DependenciesDiagram") [ (it as DiagramDescription).defaultLayer.toolSections.get(1).ownedTools.at(ContainerDropDescription, "External EPackageTo Analyze from treeview") ]
		metamodel += EcorePackage.eINSTANCE
		metamodel += GenModelPackage.eINSTANCE
		defaultLayer = Layer.create [
			name = "Default"
			edgeMappings += EdgeMapping.create [
				name = "Package Dependency"
				semanticCandidatesExpression = "service:getPackageDependencies"
				targetFinderExpression = "service:getPackageDependencies"
				domainClass = "ecore.EPackage"
				sourceMapping += ContainerMapping.ref("DependenciesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("Analyzed Package") ]
				targetMapping += ContainerMapping.ref("DependenciesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("Analyzed Package") ]
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
				labelDirectEdit = DirectEditLabel.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.toolSections.get(5).ownedTools.at(DirectEditLabel, "Edit Name no CamelCase") ]
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
					borderColor = UserFixedColor.ref("ToolDesign") [ (it as Group).userColorsPalettes.at("Ecore Palette").entries.at(UserFixedColor, "Dark EPackage") ]
					labelColor = Environment.extraRef("$0").systemColors.entries.at("black")
					backgroundColor = Environment.extraRef("$0").systemColors.entries.at("white")
					foregroundColor = UserFixedColor.ref("ToolDesign") [ (it as Group).userColorsPalettes.at("Ecore Palette").entries.at(UserFixedColor, "EPackage") ]
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
									mapping = ContainerMapping.ref("DependenciesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("Analyzed Package") ]
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
									mapping = ContainerMapping.ref("DependenciesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("Analyzed Package") ]
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
									mapping = ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass") ]
								]
							]
						]
					]
				]
			]
		]
	}

}
