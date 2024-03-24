package org.eclipse.emf.ecoretools.design.sirius

import org.eclipse.sirius.viewpoint.description.Group
import org.eclipse.sirius.viewpoint.description.InterpolatedColor
import org.eclipse.sirius.viewpoint.description.UserColorsPalette
import org.eclipse.sirius.viewpoint.description.Viewpoint
import org.mypsycho.modit.emf.sirius.api.SiriusVpGroup

import static extension org.mypsycho.modit.emf.sirius.api.SiriusDesigns.*

class EcoretoolsDesign extends SiriusVpGroup {
	
	new () {
        businessPackages += #[
			org.eclipse.emf.ecore.EcorePackage.eINSTANCE,
			org.eclipse.emf.codegen.ecore.genmodel.GenModelPackage.eINSTANCE
        ]
	}

	override initContent(Group it) {
		name = "EcoreTools"
		version = "12.0.0.2017041100"
		ownedViewpoints += Viewpoint.create [
			endUserDocumentation = "<html>\n<head>\n</head>\n<body>\n<p>Provides graphical and tabular representation to design an Ecore model.</p>\n<br>\n<img src=\"/icons/full/wizban/entities.png\"/>\n<img src=\"/icons/full/wizban/classes.png\"/>\n</body>\n</html>\n\n\n"
			name = "Design"
			modelFileExtension = "ecore xcore ecorebin"
			owned(EntitiesDiagram)
			owned(ClassesEditionTable)
			use(org.eclipse.emf.ecoretools.design.service.DesignServices)
			use(org.eclipse.sirius.common.tools.api.interpreter.StandardServices)
			use(org.eclipse.emf.ecoretools.design.service.PropertiesServices)
			use(org.eclipse.emf.ecoretools.design.service.ALEServices)
		]
		ownedViewpoints += Viewpoint.create [
			endUserDocumentation = "Add support for archetypes-based modeling to the Entities modeler."
			name = "Archetype"
			modelFileExtension = "ecore xcore ecorebin"
			owned(EntitiesWithArchetypesDiagramExtension)
			use(org.eclipse.emf.ecoretools.design.service.ArchetypeServices)
			use(org.eclipse.emf.ecoretools.design.service.PropertiesServices)
			use(org.eclipse.emf.ecoretools.design.service.ALEServices)
		]
		ownedViewpoints += Viewpoint.create [
			endUserDocumentation = "Provides representation to document and review Ecore models."
			name = "Review"
			modelFileExtension = "ecore xcore ecorebin"
			owned(DocumentationCrossTable)
			owned(DependenciesDiagram)
			use(org.eclipse.emf.ecoretools.design.service.ReviewServices)
			use(org.eclipse.emf.ecoretools.design.service.PropertiesServices)
			use(org.eclipse.emf.ecoretools.design.service.ALEServices)
		]
		ownedViewpoints += Viewpoint.create [
			endUserDocumentation = "Adds support for EMF GenModel configuration."
			name = "Generation"
			modelFileExtension = "genmodel"
			owned(GenPackageAttributesEditionTable)
			use(org.eclipse.emf.ecoretools.design.service.GenerationServices)
			use(org.eclipse.emf.ecoretools.design.service.PropertiesServices)
			use(org.eclipse.emf.ecoretools.design.service.ALEServices)
		]
		userColorsPalettes += UserColorsPalette.create [
			name = "Ecore Palette"
			entries += InterpolatedColor.createAs("color:Size Based Color") [
				name = "Size Based Color"
				minValueComputationExpression = "aql:0"
				maxValueComputationExpression = "aql:10"
			]
			entries += "MomentIntervalColor".color(250, 190, 190)
			entries += "RoleColor".color(250, 240, 180)
			entries += "PartyPlaceThingColor".color(180, 230, 180)
			entries += "DescriptionColor".color(180, 200, 210)
			entries += "Package Color".color(255, 245, 182)
			entries += "External Package Color".color(253, 208, 142)
			entries += "EClass".color(255, 252, 216)
			entries += "EPackage".color(217, 210, 220)
			entries += "EDataType".color(255, 250, 191)
			entries += "EEnum".color(221, 236, 202)
			entries += "Dark EClass".color(125, 125, 125)
			entries += "Dark EPackage".color(125, 125, 125)
			entries += "Dark EDataType".color(125, 125, 125)
			entries += "Dark EEnum".color(125, 125, 125)
			entries += "Doc Annotation".color(220, 234, 183)
			entries += "Abstract EClass".color(228, 228, 228)
			entries += "Inherited".color(125, 125, 125)
		]
		extensions += new DefaultViewExtension(this).createContent
	}


}
