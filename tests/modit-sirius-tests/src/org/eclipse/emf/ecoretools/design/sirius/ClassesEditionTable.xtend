package org.eclipse.emf.ecoretools.design.sirius

import org.eclipse.emf.codegen.ecore.genmodel.GenModelPackage
import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.EcorePackage
import org.eclipse.sirius.table.metamodel.table.description.BackgroundStyleDescription
import org.eclipse.sirius.table.metamodel.table.description.CreateLineTool
import org.eclipse.sirius.table.metamodel.table.description.EditionTableDescription
import org.eclipse.sirius.table.metamodel.table.description.FeatureColumnMapping
import org.eclipse.sirius.table.metamodel.table.description.ForegroundConditionalStyle
import org.eclipse.sirius.table.metamodel.table.description.ForegroundStyleDescription
import org.eclipse.sirius.table.metamodel.table.description.LineMapping
import org.eclipse.sirius.table.metamodel.table.description.TableDescription
import org.eclipse.sirius.table.metamodel.table.description.TableTool
import org.eclipse.sirius.table.metamodel.table.description.TableVariable
import org.eclipse.sirius.viewpoint.FontFormat
import org.eclipse.sirius.viewpoint.description.Environment
import org.eclipse.sirius.viewpoint.description.SystemColor
import org.eclipse.sirius.viewpoint.description.SytemColorsPalette
import org.eclipse.sirius.viewpoint.description.tool.ChangeContext
import org.eclipse.sirius.viewpoint.description.tool.CreateInstance
import org.eclipse.sirius.viewpoint.description.tool.ExternalJavaAction
import org.eclipse.sirius.viewpoint.description.tool.SetValue
import org.mypsycho.modit.emf.sirius.api.SiriusFeatureTable

import static extension org.mypsycho.modit.emf.sirius.api.SiriusDesigns.*

class ClassesEditionTable extends SiriusFeatureTable {

	new(EcoretoolsDesign parent) {
		super(parent, "Classes in a spreadsheet", EPackage)
	}

	override initDefaultLineStyle(LineMapping it) {}

	override initContent(EditionTableDescription it) {
		name = "Classes"
		documentation = "<html>\n<head>\n</head>\n<body>\n<p>A tabular editor (spreadsheet-like) of the entities in an Ecore model.</p>\n<br>\n<img src=\"/icons/full/wizban/classes.png\"/>\n</body>\n</html>\n\n\n"
		endUserDocumentation = "A tabular editor (spreadsheet-like) of the entities in an Ecore model."
		titleExpression = ''' self.name + ' class table' '''.trimAql
		ownedLine("Classes lines") [
			domainClass = "ecore.EClass"
			semanticCandidatesExpression = "feature:eContents"
			reusedInMappings += "Package".lineRef
			foregroundConditionalStyle += ForegroundConditionalStyle.create [
				predicateExpression = "feature:abstract"
				style = ForegroundStyleDescription.create [
					labelSize = 10
					labelFormat += FontFormat.ITALIC_LITERAL
					foreGroundColor = SystemColor.extraRef("color:black")
				]
			]
			ownedLine("Feature") [
				domainClass = "ecore.EStructuralFeature"
			]
		]
		ownedLine("Package") [
			domainClass = "ecore.EPackage"
			headerLabelExpression = "feature:name"
			defaultBackground = BackgroundStyleDescription.create [
				backgroundColor = SystemColor.extraRef("color:light_yellow")
			]
		]
		ownedCreateLine += CreateLineTool.create("Create Class") [
			initVariables
			forceRefresh = true
			elementsToSelect = "service:stdEmptyCollection"
			mapping = "Classes lines".lineRef
			operation = "var:container".toContext(
				"eClassifiers".creator("ecore.EClass").chain(
					"name".setter(''' 'NewEClass'  + self.eContainer().eContents(ecore::EClass)->size() '''.trimAql)
				)
			)
		]
		ownedColumn("Name", "name") [
			headerLabelExpression = "Name"
			labelExpression = "service:getClassesTableName"
		]
	}

}