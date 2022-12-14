package org.eclipse.emf.ecoretools.design.sirius

import org.eclipse.emf.ecore.EPackage
import org.eclipse.sirius.table.metamodel.table.description.BackgroundStyleDescription
import org.eclipse.sirius.table.metamodel.table.description.CreateCellTool
import org.eclipse.sirius.table.metamodel.table.description.CrossTableDescription
import org.eclipse.sirius.table.metamodel.table.description.DeleteColumnTool
import org.eclipse.sirius.table.metamodel.table.description.ElementColumnMapping
import org.eclipse.sirius.table.metamodel.table.description.IntersectionMapping
import org.eclipse.sirius.table.metamodel.table.description.LabelEditTool
import org.eclipse.sirius.table.metamodel.table.description.LineMapping
import org.eclipse.sirius.table.metamodel.table.description.TableDescription
import org.eclipse.sirius.table.metamodel.table.description.TableTool
import org.eclipse.sirius.table.metamodel.table.description.TableVariable
import org.eclipse.sirius.viewpoint.description.Environment
import org.eclipse.sirius.viewpoint.description.SystemColor
import org.eclipse.sirius.viewpoint.description.SytemColorsPalette
import org.eclipse.sirius.viewpoint.description.UserFixedColor
import org.eclipse.sirius.viewpoint.description.tool.ChangeContext
import org.eclipse.sirius.viewpoint.description.tool.CreateInstance
import org.eclipse.sirius.viewpoint.description.tool.EditMaskVariables
import org.eclipse.sirius.viewpoint.description.tool.If
import org.eclipse.sirius.viewpoint.description.tool.SetValue
import org.mypsycho.modit.emf.sirius.api.AbstractCrossTable

import static extension org.mypsycho.modit.emf.sirius.api.SiriusDesigns.*

class DocumentationCrossTable extends AbstractCrossTable {

	new(EcoretoolsDesign parent) {
		super(parent, "Documentation annotations in a spreadsheet", EPackage)
	}

	override initDefaultLineStyle(LineMapping it) {}

	override initContent(CrossTableDescription it) {
		name = "Documentation"
		documentation = "<html>\n<head>\n</head>\n<body>\n<p>Document the concepts in a package.</p>\n<br>\n<img src=\"/icons/full/wizban/documentation_table.png\"/>\n</body>\n</html>\n\n\n"
		titleExpression = ''' self.name + ' documentation table' '''.trimAql
		it.line("Doc EClassifiers") [
			semanticElements = "var:self"
			domainClass = "ecore.EClassifier"
			semanticCandidatesExpression = "feature:eClassifiers"
			headerLabelExpression = '''self.eClass().name + ' : ' + self.name'''.trimAql
			defaultBackground = BackgroundStyleDescription.create [
				backgroundColor = SystemColor.extraRef("color:white")
			]
			it.line("Doc EStructural Features") [
				domainClass = "ecore.EStructuralFeature"
				semanticCandidatesExpression = "feature:eContents"
				headerLabelExpression = '''self.eClass().name + ' : ' + self.name'''.trimAql
				defaultBackground = BackgroundStyleDescription.create [
					backgroundColor = SystemColor.extraRef("color:white")
				]
			]
		]
		it.column("Doc Root") [
			headerLabelExpression = "Domain Documentation"
			domainClass = "ecore.EPackage"
			semanticCandidatesExpression = "service:getRootContainer"
			delete = DeleteColumnTool.create("") [
				initVariables
				precondition = '''false'''.trimAql
				// no operation 
			]
		]
		intersection += IntersectionMapping.create("EModelElements to Doc Annotation") [
			semanticElements = "var:self"
			labelExpression = '''self.value'''.trimAql
			useDomainClass = true
			columnFinderExpression = "service:getRootContainer"
			lineFinderExpression = '''self.eContainer(ecore::EAnnotation).eContainer()'''.trimAql
			semanticCandidatesExpression = '''self.eAllContents(ecore::EAnnotation)->select(a | a.source = 'http://www.eclipse.org/emf/2002/GenModel').details->select(a | a.key = 'documentation')'''.trimAql
			domainClass = "ecore.EStringToStringMapEntry"
			lineMapping += "Doc EClassifiers".lineRef
			lineMapping += "Doc EStructural Features".lineRef
			columnMapping = "Doc Root".columnRef
			directEdit = LabelEditTool.create [
				initVariables
				mask = "{0}"
				operation = SetValue.create [
					featureName = "value"
					valueExpression = "var:arg0"
				]
			]
			defaultBackground = BackgroundStyleDescription.create [
				backgroundColor = UserFixedColor.ref("color:Doc Annotation")
			]
			create = CreateCellTool.create("New Documentation") [
				initVariables
				forceRefresh = true
				mask = "{0}"
				operation = ChangeContext.create [
					browseExpression = "var:lineSemantic"
					subModelOperations += If.create [
						conditionExpression = '''lineSemantic.eAnnotations->select(a | a.source = 'http://www.eclipse.org/emf/2002/GenModel')->size() = 0'''.trimAql
						subModelOperations += CreateInstance.create [
							typeName = "ecore.EAnnotation"
							referenceName = "eAnnotations"
							variableName = "newAnnotation"
							subModelOperations += SetValue.create [
								featureName = "source"
								valueExpression = ''' 'http://www.eclipse.org/emf/2002/GenModel' '''.trimAql
							]
						]
					]
					subModelOperations += ChangeContext.create [
						browseExpression = '''lineSemantic.eAnnotations->select(a | a.source = 'http://www.eclipse.org/emf/2002/GenModel')->first()'''.trimAql
						subModelOperations += If.create [
							conditionExpression = '''self.details->select(a| a.key = 'documentation')->size() = 0'''.trimAql
							subModelOperations += CreateInstance.create [
								typeName = "ecore.EStringToStringMapEntry"
								referenceName = "details"
								variableName = "newDetail"
								subModelOperations += SetValue.create [
									featureName = "key"
									valueExpression = ''' 'documentation' '''.trimAql
								]
							]
						]
					]
					subModelOperations += ChangeContext.create [
						browseExpression = '''lineSemantic.eAnnotations->select(a | a.source = 'http://www.eclipse.org/emf/2002/GenModel').details->select(a | a.key = 'documentation')->first()'''.trimAql
						subModelOperations += SetValue.create [
							featureName = "value"
							valueExpression = "var:arg0"
						]
					]
				]
			]
		]
	}

}