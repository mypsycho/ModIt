package org.eclipse.emf.ecoretools.design.sirius

import org.eclipse.emf.ecore.EPackage
import org.eclipse.sirius.table.metamodel.table.description.CreateCellTool
import org.eclipse.sirius.table.metamodel.table.description.CrossTableDescription
import org.eclipse.sirius.table.metamodel.table.description.DeleteColumnTool
import org.eclipse.sirius.table.metamodel.table.description.LineMapping
import org.eclipse.sirius.viewpoint.description.SystemColor
import org.eclipse.sirius.viewpoint.description.UserFixedColor
import org.mypsycho.modit.emf.sirius.api.SiriusCrossTable

import static extension org.mypsycho.modit.emf.sirius.api.SiriusDesigns.*

class DocumentationCrossTable extends SiriusCrossTable {

	new(EcoretoolsDesign parent) {
		super(parent, "Documentation annotations in a spreadsheet", EPackage)
	}

	override initDefaultLineStyle(LineMapping it) {}

	override initContent(CrossTableDescription it) {
		name = "Documentation"
		documentation = "<html>\n<head>\n</head>\n<body>\n<p>Document the concepts in a package.</p>\n<br>\n<img src=\"/icons/full/wizban/documentation_table.png\"/>\n</body>\n</html>\n\n\n"
		titleExpression = ''' self.name + ' documentation table' '''.trimAql
		ownedLine("Doc EClassifiers") [
			semanticElements = "var:self"
			domainClass = "ecore.EClassifier"
			semanticCandidatesExpression = "feature:eClassifiers"
			headerLabelExpression = '''self.eClass().name + ' : ' + self.name'''.trimAql
			background = SystemColor.extraRef("color:white")
			ownedLine("Doc EStructural Features") [
				domainClass = "ecore.EStructuralFeature"
				semanticCandidatesExpression = "feature:eContents"
				headerLabelExpression = '''self.eClass().name + ' : ' + self.name'''.trimAql
				background = SystemColor.extraRef("color:white")
			]
		]
		ownedColumn("Doc Root") [
			headerLabelExpression = "Domain Documentation"
			domainClass = "ecore.EPackage"
			semanticCandidatesExpression = "service:getRootContainer"
			delete = DeleteColumnTool.create("") [
				initVariables
				precondition = '''false'''.trimAql
			]
		]
		cells("EModelElements to Doc Annotation", "ecore.EStringToStringMapEntry", 
			'''self.eAllContents(ecore::EAnnotation)->select(a | a.source = 'http://www.eclipse.org/emf/2002/GenModel').details->select(a | a.key = 'documentation')'''.trimAql) [
			toLines('''self.eContainer(ecore::EAnnotation).eContainer()'''.trimAql,
					"Doc EClassifiers".lineRef,
					"Doc EStructural Features".lineRef)
			toColumn("service:getRootContainer",
				"Doc Root".columnRef)
		
			foreground = null // cancel default initialisation
			semanticElements = "var:self"
			labelExpression = '''self.value'''.trimAql
			directEdit = "value".setter("var:arg0")
			background = UserFixedColor.ref("color:Doc Annotation")
			create = CreateCellTool.create("New Documentation") [
				initVariables
				forceRefresh = true
				operation = "var:lineSemantic".toContext(
					'''lineSemantic.eAnnotations->select(a | a.source = 'http://www.eclipse.org/emf/2002/GenModel')->size() = 0'''.trimAql.ifThenDo(
						"eAnnotations".creator("ecore.EAnnotation").andThen[ variableName = "newAnnotation" ].chain(
							"source".setter(''' 'http://www.eclipse.org/emf/2002/GenModel' '''.trimAql)
						)
					),
					'''lineSemantic.eAnnotations->select(a | a.source = 'http://www.eclipse.org/emf/2002/GenModel')->first()'''.trimAql.toContext(
						'''self.details->select(a| a.key = 'documentation')->size() = 0'''.trimAql.ifThenDo(
							"details".creator("ecore.EStringToStringMapEntry").andThen[ variableName = "newDetail" ].chain(
								"key".setter(''' 'documentation' '''.trimAql)
							)
						)
					),
					'''lineSemantic.eAnnotations->select(a | a.source = 'http://www.eclipse.org/emf/2002/GenModel').details->select(a | a.key = 'documentation')->first()'''.trimAql.toContext(
						"value".setter("var:arg0")
					)
				)
				mask = "{0}"
			]
		]
	}

}