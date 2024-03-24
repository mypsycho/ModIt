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
import org.eclipse.sirius.diagram.description.CenteringStyle
import org.eclipse.sirius.diagram.description.ContainerMapping
import org.eclipse.sirius.diagram.description.DiagramDescription
import org.eclipse.sirius.diagram.description.EdgeMapping
import org.eclipse.sirius.diagram.description.Layer
import org.eclipse.sirius.diagram.description.NodeMapping
import org.eclipse.sirius.diagram.description.style.BundledImageDescription
import org.eclipse.sirius.diagram.description.style.FlatContainerStyleDescription
import org.eclipse.sirius.diagram.description.tool.ContainerDropDescription
import org.eclipse.sirius.diagram.description.tool.CreateView
import org.eclipse.sirius.diagram.description.tool.DirectEditLabel
import org.eclipse.sirius.diagram.description.tool.ToolSection
import org.eclipse.sirius.viewpoint.LabelAlignment
import org.eclipse.sirius.viewpoint.description.SystemColor
import org.eclipse.sirius.viewpoint.description.UserFixedColor
import org.eclipse.sirius.viewpoint.description.style.LabelBorderStyleDescription
import org.eclipse.sirius.viewpoint.description.tool.ContainerViewVariable
import org.eclipse.sirius.viewpoint.description.tool.DeleteView
import org.eclipse.sirius.viewpoint.description.tool.DragSource
import org.eclipse.sirius.viewpoint.description.tool.OperationAction
import org.eclipse.sirius.viewpoint.description.tool.SelectModelElementVariable
import org.eclipse.sirius.viewpoint.description.tool.SelectionWizardDescription
import org.eclipse.sirius.viewpoint.description.tool.ToolDescription
import org.mypsycho.modit.emf.sirius.api.SiriusDiagram

import static extension org.mypsycho.modit.emf.sirius.api.SiriusDesigns.*

class DependenciesDiagram extends SiriusDiagram {

	new(EcoretoolsDesign parent) {
		super(parent, "Dependencies", "Package dependencies diagram", EPackage)
	}

	override initContent(DiagramDescription it) {
		super.initContent(it)
		metamodel.clear // Disable implicit metamodel import
		documentation = "<html>\n<head>\n</head>\n<body>\n<p>A  diagram used to highligh dependencies in between EPackages.</p>\n<br>\n<img src=\"/icons/full/wizban/packages.png\"/>\n</body>\n</html>\n\n\n"
		titleExpression = ''' self.name + ' package dependencies' '''.trimAql
		dropDescriptions += ContainerDropDescription.localRef(Ns.drop, "External EPackageTo Analyze from treeview")
		metamodel += EcorePackage.eINSTANCE
		metamodel += GenModelPackage.eINSTANCE
	}

	override initContent(Layer it) {
		containerMappings += ContainerMapping.createAs(Ns.node, "Analyzed Package") [
			createElements = false
			domainClass = "ecore.EPackage"
			childrenPresentation = ContainerLayout.LIST
			labelDirectEdit = DirectEditLabel.ref(EntitiesDiagram, Ns.operation, "Edit Name no CamelCase")
			style(FlatContainerStyleDescription) [
				arcWidth = 1
				arcHeight = 1
				labelSize = 8
				labelExpression = "feature:nsURI"
				labelAlignment = LabelAlignment.LEFT
				backgroundStyle = BackgroundStyle.LIQUID_LITERAL
				borderColor = UserFixedColor.ref("color:Dark EPackage")
				foregroundColor = UserFixedColor.ref("color:EPackage")
				labelBorderStyle = LabelBorderStyleDescription.extraRef("LabelBorder:Label Border Style With Beveled Corner")
			]
			subNodeMappings += NodeMapping.createAs(Ns.node, "EClassfierIntroducingDependency") [
				semanticCandidatesExpression = "service:getElementsIntroducingDependencies(diagram)"
				domainClass = "ecore.EClassifier"
				style(BundledImageDescription) [
					borderSizeComputationExpression = "0"
					labelSize = 8
					labelExpression = "service:getDependenciesLabel"
					labelAlignment = LabelAlignment.LEFT
					tooltipExpression = "service:getDependenciesTooltip(view)"
					sizeComputationExpression = "3"
					labelPosition = LabelPosition.NODE_LITERAL
					resizeKind = ResizeKind.NSEW_LITERAL
				]
			]
		]
		edgeMappings += EdgeMapping.createAs(Ns.edge, "Package Dependency") [
			semanticCandidatesExpression = "service:getPackageDependencies"
			targetFinderExpression = "service:getPackageDependencies"
			domainClass = "ecore.EPackage"
			sourceMapping += ContainerMapping.localRef(Ns.node, "Analyzed Package")
			targetMapping += ContainerMapping.localRef(Ns.node, "Analyzed Package")
			style [
				lineStyle = LineStyle.DASH_LITERAL
				targetArrow = EdgeArrows.INPUT_ARROW_LITERAL
				sizeComputationExpression = "service:getDependenciesAmount()"
				routingStyle = EdgeRouting.STRAIGHT_LITERAL
				endsCentering = CenteringStyle.NONE
				strokeColor = SystemColor.extraRef("color:red")
				centerLabel = [
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
				initVariables
				label = "Open User Guide"
				operation = "org.eclipse.sirius.ui.business.api.action.openHelpSection".javaDo("Open Dependencies User Guide Action", 
					"href" -> "/org.eclipse.emf.ecoretools.design/doc/user-guide.html#quality.dependencies"
				)
			]
		]
	}


	def createExistingElementsTools() {
		ToolSection.create("Existing Elements") [
			ownedTools += SelectionWizardDescription.createAs(Ns.operation, "Add") [
				initVariables
				precondition = "service:isEPackage"
				forceRefresh = true
				candidatesExpression = "service:getValidsForDiagram(containerView)"
				multiple = true
				tree = true
				rootExpression = "service:rootEPackages"
				childrenExpression = "feature:eContents"
				iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/etools16/search.gif"
				windowTitle = "Select element to add in diagram"
				operation = "var:element".forDo("i", 
					"service:isEPackage".ifThenDo(
						CreateView.create [
							containerViewExpression = "var:containerView"
							mapping = ContainerMapping.localRef(Ns.node, "Analyzed Package")
						]
					)
				)
			]
			ownedTools += ToolDescription.createAs(Ns.operation, "RemoveExistingElements") [
				initVariables
				label = "Remove"
				precondition = '''containerView.oclIsKindOf(diagram::DDiagram)'''.trimAql
				forceRefresh = true
				iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/etools16/search.gif"
				operation = "var:elementView".toContext(
					DeleteView.create
				)
			]
			ownedTools += ContainerDropDescription.createAs(Ns.drop, "External EPackageTo Analyze from treeview") [
				initVariables
				forceRefresh = true
				dragSource = DragSource.PROJECT_EXPLORER_LITERAL
				operation = "var:element".toContext(
					"service:isEPackage".ifThenDo(
						CreateView.create [
							containerViewExpression = "var:newContainerView"
							mapping = ContainerMapping.localRef(Ns.node, "Analyzed Package")
						]
					)
				)
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
				operation = "var:selected".forDo("i", 
					"service:isEPackage".ifThenDo(
						CreateView.create [
							containerViewExpression = "var:diagram"
							mapping = ContainerMapping.ref(EntitiesDiagram, Ns.node, "EC EClass")
						]
					)
				)
			]
		]
	}

}