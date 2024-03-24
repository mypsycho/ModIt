package org.eclipse.emf.ecoretools.design.split

import org.eclipse.emf.codegen.ecore.genmodel.GenModelPackage
import org.eclipse.emf.ecore.EcorePackage
import org.eclipse.sirius.table.metamodel.table.description.BackgroundStyleDescription
import org.eclipse.sirius.table.metamodel.table.description.CreateCellTool
import org.eclipse.sirius.table.metamodel.table.description.CrossTableDescription
import org.eclipse.sirius.table.metamodel.table.description.DeleteColumnTool
import org.eclipse.sirius.table.metamodel.table.description.ElementColumnMapping
import org.eclipse.sirius.table.metamodel.table.description.IntersectionMapping
import org.eclipse.sirius.table.metamodel.table.description.LabelEditTool
import org.eclipse.sirius.table.metamodel.table.description.LineMapping
import org.eclipse.sirius.table.metamodel.table.description.TableVariable
import org.eclipse.sirius.viewpoint.description.Environment
import org.eclipse.sirius.viewpoint.description.Group
import org.eclipse.sirius.viewpoint.description.UserFixedColor
import org.eclipse.sirius.viewpoint.description.tool.ChangeContext
import org.eclipse.sirius.viewpoint.description.tool.CreateInstance
import org.eclipse.sirius.viewpoint.description.tool.EditMaskVariables
import org.eclipse.sirius.viewpoint.description.tool.If
import org.eclipse.sirius.viewpoint.description.tool.SetValue
import org.mypsycho.modit.emf.EModel
import static extension org.mypsycho.modit.emf.ModitModel.*

class DocumentationCrossTable extends EModel.Part<CrossTableDescription> {

	new(ToolDesign parent) {
		super(CrossTableDescription, parent)
	}

	protected override initContent(CrossTableDescription it) {
		documentation = "<html>\n<head>\n</head>\n<body>\n<p>Document the concepts in a package.</p>\n<br>\n<img src=\"/icons/full/wizban/documentation_table.png\"/>\n</body>\n</html>\n\n\n"
		name = "Documentation"
		label = "Documentation annotations in a spreadsheet"
		titleExpression = "aql:self.name + ' documentation table'"
		domainClass = "ecore::EPackage"
		metamodel += EcorePackage.eINSTANCE
		metamodel += GenModelPackage.eINSTANCE
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
			delete = DeleteColumnTool.create [
				precondition = "aql:false"
			]
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
			lineMapping += LineMapping.ref("DocumentationCrossTable") [ (it as CrossTableDescription).ownedLineMappings.at("Doc EClassifiers") ]
			lineMapping += LineMapping.ref("DocumentationCrossTable") [ (it as CrossTableDescription).ownedLineMappings.at("Doc EClassifiers").ownedSubLines.at("Doc EStructural Features") ]
			columnMapping = ElementColumnMapping.ref("DocumentationCrossTable") [ (it as CrossTableDescription).ownedColumnMappings.head ]
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
				backgroundColor = UserFixedColor.ref("ToolDesign") [ (it as Group).userColorsPalettes.at("Ecore Palette").entries.at(UserFixedColor, "Doc Annotation") ]
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
	}

}
