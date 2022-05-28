package org.eclipse.emf.ecoretools.design.sirius

import org.eclipse.emf.codegen.ecore.genmodel.GenPackage
import org.eclipse.emf.ecore.EPackage
import org.eclipse.sirius.table.metamodel.table.description.BackgroundConditionalStyle
import org.eclipse.sirius.table.metamodel.table.description.BackgroundStyleDescription
import org.eclipse.sirius.table.metamodel.table.description.EditionTableDescription
import org.eclipse.sirius.table.metamodel.table.description.FeatureColumnMapping
import org.eclipse.sirius.table.metamodel.table.description.LineMapping
import org.eclipse.sirius.table.metamodel.table.description.TableDescription
import org.eclipse.sirius.table.metamodel.table.description.TableTool
import org.eclipse.sirius.viewpoint.description.Environment
import org.eclipse.sirius.viewpoint.description.SystemColor
import org.eclipse.sirius.viewpoint.description.SytemColorsPalette
import org.mypsycho.modit.emf.sirius.api.AbstractEditionTable

import static extension org.mypsycho.modit.emf.sirius.api.SiriusDesigns.*

class GenPackageAttributesEditionTable extends AbstractEditionTable {

	new(EcoretoolsDesign parent) {
		super(parent, "Properties attributes and categories", GenPackage)
	}

	override initDefaultLineStyle(LineMapping it) {}

	override initContent(EditionTableDescription it) {
		name = "GenPackage Attributes"
		documentation = "<html>\n<head>\n</head>\n<body>\n<p>To set generation related parameters:</p>\n<ul>\n  <li>the property category</li>\n  <li>the user facing documentation for each property</li>\n</ul>\n<br>\n</body>\n</html>\n\n\n"
		titleExpression = ''' self.prefix + ' generation table' '''.trimAql
		it.line("GenClass") [
			domainClass = "genmodel.GenClass"
			headerLabelExpression = '''self.ecoreClass.name'''.trimAql
			it.line("GenFeature") [
				domainClass = "genmodel.GenFeature"
				semanticCandidatesExpression = '''self.eAllContents(genmodel::GenFeature)->select(a | a.ecoreFeature.oclIsTypeOf(ecore::EAttribute) or a.ecoreFeature.oclIsTypeOf(ecore::EReference) and not(a.ecoreFeature.oclAsType(ecore::EReference).containment) and not(a.ecoreFeature.oclAsType(ecore::EReference).derived))'''.trimAql
				headerLabelExpression = '''self.ecoreFeature.name'''.trimAql
				backgroundConditionalStyle += BackgroundConditionalStyle.create [
					predicateExpression = ''' self.propertyCategory = '' '''.trimAql
					style = BackgroundStyleDescription.create [
						backgroundColor = SystemColor.extraRef("color:light_yellow")
					]
				]
			]
		]
		it.column("Category") [
			headerLabelExpression = "Category"
			canEdit = '''self.oclIsTypeOf(genmodel::GenFeature)'''.trimAql
			featureName = "propertyCategory"
			labelExpression = '''self->filter(genmodel::GenFeature).propertyCategory->first()'''.trimAql
		]
		it.column("Decription") [
			headerLabelExpression = "Description"
			canEdit = '''self.oclIsTypeOf(genmodel::GenFeature)'''.trimAql
			featureName = "propertyDescription"
			labelExpression = '''self->filter(genmodel::GenFeature).propertyDescription->first()'''.trimAql
		]
	}

}