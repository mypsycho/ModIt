package org.eclipse.emf.ecoretools.design.split

import org.eclipse.emf.codegen.ecore.genmodel.GenModelPackage
import org.eclipse.emf.ecore.EcorePackage
import org.eclipse.sirius.table.metamodel.table.description.BackgroundConditionalStyle
import org.eclipse.sirius.table.metamodel.table.description.BackgroundStyleDescription
import org.eclipse.sirius.table.metamodel.table.description.EditionTableDescription
import org.eclipse.sirius.table.metamodel.table.description.FeatureColumnMapping
import org.eclipse.sirius.table.metamodel.table.description.LineMapping
import org.eclipse.sirius.viewpoint.description.Environment
import org.mypsycho.modit.emf.EModel
import static extension org.mypsycho.modit.emf.ModitModel.*

class GenPackageAttributesEditionTable extends EModel.Part<EditionTableDescription> {

	new(ToolDesign parent) {
		super(EditionTableDescription, parent)
	}

	protected override initContent(EditionTableDescription it) {
		documentation = "<html>\n<head>\n</head>\n<body>\n<p>To set generation related parameters:</p>\n<ul>\n  <li>the property category</li>\n  <li>the user facing documentation for each property</li>\n</ul>\n<br>\n</body>\n</html>\n\n\n"
		name = "GenPackage Attributes"
		label = "Properties attributes and categories"
		titleExpression = "aql:self.prefix + ' generation table'"
		domainClass = "genmodel::GenPackage"
		metamodel += EcorePackage.eINSTANCE
		metamodel += GenModelPackage.eINSTANCE
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
	}

}
