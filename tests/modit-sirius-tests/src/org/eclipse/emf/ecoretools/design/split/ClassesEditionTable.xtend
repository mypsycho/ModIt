package org.eclipse.emf.ecoretools.design.split

import org.eclipse.emf.codegen.ecore.genmodel.GenModelPackage
import org.eclipse.emf.ecore.EcorePackage
import org.eclipse.sirius.table.metamodel.table.description.BackgroundStyleDescription
import org.eclipse.sirius.table.metamodel.table.description.CreateLineTool
import org.eclipse.sirius.table.metamodel.table.description.EditionTableDescription
import org.eclipse.sirius.table.metamodel.table.description.FeatureColumnMapping
import org.eclipse.sirius.table.metamodel.table.description.ForegroundConditionalStyle
import org.eclipse.sirius.table.metamodel.table.description.ForegroundStyleDescription
import org.eclipse.sirius.table.metamodel.table.description.LineMapping
import org.eclipse.sirius.table.metamodel.table.description.TableVariable
import org.eclipse.sirius.viewpoint.FontFormat
import org.eclipse.sirius.viewpoint.description.Environment
import org.eclipse.sirius.viewpoint.description.SystemColor
import org.eclipse.sirius.viewpoint.description.SytemColorsPalette
import org.eclipse.sirius.viewpoint.description.tool.ChangeContext
import org.eclipse.sirius.viewpoint.description.tool.CreateInstance
import org.eclipse.sirius.viewpoint.description.tool.SetValue
import org.mypsycho.modit.emf.EModel
import static extension org.eclipse.emf.ecoretools.design.split.ToolDesign.*

class ClassesEditionTable extends EModel.Part<EditionTableDescription> {

	new(ToolDesign parent) {
		super(EditionTableDescription, parent)
	}

	protected override initContent(EditionTableDescription it) {
		documentation = "<html>\n<head>\n</head>\n<body>\n<p>A tabular editor (spreadsheet-like) of the entities in an Ecore model.</p>\n<br>\n<img src=\"/icons/full/wizban/classes.png\"/>\n</body>\n</html>\n\n\n"
		endUserDocumentation = "A tabular editor (spreadsheet-like) of the entities in an Ecore model."
		name = "Classes"
		label = "Classes in a spreadsheet"
		titleExpression = "aql:self.name + ' class table'"
		domainClass = "ecore::EPackage"
		metamodel += EcorePackage.eINSTANCE
		metamodel += GenModelPackage.eINSTANCE
		ownedLineMappings += LineMapping.create [
			name = "Classes lines"
			domainClass = "ecore.EClass"
			semanticCandidatesExpression = "feature:eContents"
			reusedInMappings += LineMapping.ref("ClassesEditionTable") [ (it as EditionTableDescription).ownedLineMappings.at("Package") ]
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
			mapping = LineMapping.ref("ClassesEditionTable") [ (it as EditionTableDescription).ownedLineMappings.at("Classes lines") ]
			variables += TableVariable.create [
				name = "root"
				documentation = "The semantic root element of the table."
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
	}

}
