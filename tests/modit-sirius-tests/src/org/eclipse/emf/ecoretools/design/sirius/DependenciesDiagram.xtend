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
import org.eclipse.sirius.diagram.description.ContainerMapping
import org.eclipse.sirius.diagram.description.DiagramDescription
import org.eclipse.sirius.diagram.description.EdgeMapping
import org.eclipse.sirius.diagram.description.FoldingStyle
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
import org.eclipse.sirius.viewpoint.description.SystemColor
import org.eclipse.sirius.viewpoint.description.SytemColorsPalette
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
import org.mypsycho.modit.emf.sirius.api.AbstractDiagram

import static extension org.mypsycho.modit.emf.sirius.api.SiriusDesigns.*

class DependenciesDiagram extends AbstractDiagram {

	new(EcoretoolsDesign parent) {
		super(parent, "Package dependencies diagram", EPackage)
	}

	override initContent(DiagramDescription it) {
		super.initContent(it)
		name = "Dependencies"
		documentation = "<html>\n<head>\n</head>\n<body>\n<p>A  diagram used to highligh dependencies in between EPackages.</p>\n<br>\n<img src=\"/icons/full/wizban/packages.png\"/>\n</body>\n</html>\n\n\n"
		titleExpression = ''' self.name + ' package dependencies' '''.trimAql
		dropDescriptions += ContainerDropDescription.localRef(Ns.drop, "External EPackageTo Analyze from treeview")
	}

	override initContent(Layer it) {
		containerMappings += ContainerMapping.createAs(Ns.node, "Analyzed Package") [
			createElements = false
			domainClass = "ecore.EPackage"
			childrenPresentation = ContainerLayout.LIST
			labelDirectEdit = DirectEditLabel.ref(EntitiesDiagram, Ns.operation, "Edit Name no CamelCase")
			style = FlatContainerStyleDescription.create [
				arcWidth = 1
				arcHeight = 1
				borderSizeComputationExpression = "1"
				labelExpression = "feature:nsURI"
				labelAlignment = LabelAlignment.LEFT
				backgroundStyle = BackgroundStyle.LIQUID_LITERAL
				borderColor = UserFixedColor.ref("color:Dark EPackage")
				labelColor = SystemColor.extraRef("color:black")
				backgroundColor = SystemColor.extraRef("color:white")
				foregroundColor = UserFixedColor.ref("color:EPackage")
				labelBorderStyle = Environment.extraRef("$0").labelBorderStyles.labelBorderStyleDescriptions.get(0)
			]
			subNodeMappings += NodeMapping.createAs(Ns.node, "EClassfierIntroducingDependency") [
				semanticCandidatesExpression = "service:getElementsIntroducingDependencies(diagram)"
				domainClass = "ecore.EClassifier"
				style = BundledImageDescription.create [
					labelExpression = "service:getDependenciesLabel"
					labelAlignment = LabelAlignment.LEFT
					tooltipExpression = "service:getDependenciesTooltip(view)"
					labelPosition = LabelPosition.NODE_LITERAL
					resizeKind = ResizeKind.NSEW_LITERAL
					borderColor = SystemColor.extraRef("color:black")
					labelColor = SystemColor.extraRef("color:black")
					color = SystemColor.extraRef("color:black")
				]
			]
		]
		edgeMappings += EdgeMapping.createAs(Ns.edge, "Package Dependency") [
			semanticCandidatesExpression = "service:getPackageDependencies"
			targetFinderExpression = "service:getPackageDependencies"
			domainClass = "ecore.EPackage"
			sourceMapping += ContainerMapping.localRef(Ns.node, "Analyzed Package")
			targetMapping += ContainerMapping.localRef(Ns.node, "Analyzed Package")
			style = EdgeStyleDescription.create [
				lineStyle = LineStyle.DASH_LITERAL
				sizeComputationExpression = "service:getDependenciesAmount()"
				strokeColor = SystemColor.extraRef("color:red")
				centerLabelStyleDescription = CenterLabelStyleDescription.create [
					labelColor = SystemColor.extraRef("color:black")
				]
			]
		]
		toolSections += createHelpTools
		toolSections += createExistingElementsTools
	}

	def createHelpTools() {
		ToolSection.create("Help") [
			label = "Help"
			ownedTools += OperationAction.createAs(Ns.operation, "Open Dependencies User Guide") [
				label = "Open User Guide"
				view = ContainerViewVariable.create("views")
				operation = ExternalJavaAction.create("Open Dependencies User Guide Action") [
					id = "org.eclipse.sirius.ui.business.api.action.openHelpSection"
					parameters += ExternalJavaActionParameter.create [
						name = "href"
						value = "/org.eclipse.emf.ecoretools.design/doc/user-guide.html#quality.dependencies"
					]
				]
			]
		]
	}


	def createExistingElementsTools() {
		ToolSection.create("Existing Elements") [
			ownedTools += SelectionWizardDescription.createAs(Ns.operation, "Add") [
				precondition = "service:isEPackage"
				forceRefresh = true
				candidatesExpression = "service:getValidsForDiagram(containerView)"
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
					subModelOperations += If.create [
						conditionExpression = "service:isEPackage"
						subModelOperations += CreateView.create [
							containerViewExpression = "var:containerView"
							mapping = ContainerMapping.localRef(Ns.node, "Analyzed Package")
						]
					]
				]
			]
			ownedTools += ToolDescription.createAs(Ns.operation, "RemoveExistingElements") [
				label = "Remove"
				precondition = '''containerView.oclIsKindOf(diagram::DDiagram)'''.trimAql
				forceRefresh = true
				iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/etools16/search.gif"
				element = ElementVariable.create("element")
				elementView = ElementViewVariable.create("elementView")
				operation = ChangeContext.create [
					browseExpression = "var:elementView"
					subModelOperations += DeleteView.create
				]
			]
			ownedTools += ContainerDropDescription.createAs(Ns.drop, "External EPackageTo Analyze from treeview") [
				forceRefresh = true
				dragSource = DragSource.PROJECT_EXPLORER_LITERAL
				oldContainer = DropContainerVariable.create("oldSemanticContainer")
				newContainer = DropContainerVariable.create("newSemanticContainer")
				element = ElementDropVariable.create("element")
				newViewContainer = ContainerViewVariable.create("newContainerView")
				operation = ChangeContext.create [
					browseExpression = "var:element"
					subModelOperations += If.create [
						conditionExpression = "service:isEPackage"
						subModelOperations += CreateView.create [
							containerViewExpression = "var:newContainerView"
							mapping = ContainerMapping.localRef(Ns.node, "Analyzed Package")
						]
					]
				]
			]
			ownedTools += OperationAction.createAs(Ns.operation, "Add Related Elements") [
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
					subModelOperations += If.create [
						conditionExpression = "service:isEPackage"
						subModelOperations += CreateView.create [
							containerViewExpression = "var:diagram"
							mapping = ContainerMapping.ref(EntitiesDiagram, Ns.node, "EC EClass")
						]
					]
				]
			]
		]
	}

}