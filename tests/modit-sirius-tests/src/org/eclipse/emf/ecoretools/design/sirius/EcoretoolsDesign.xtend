// Testing
package org.eclipse.emf.ecoretools.design.sirius

import org.eclipse.emf.codegen.ecore.genmodel.GenModelPackage
import org.eclipse.emf.ecore.EcorePackage
import org.eclipse.sirius.viewpoint.description.Group
import org.eclipse.sirius.viewpoint.description.InterpolatedColor
import org.mypsycho.modit.emf.sirius.api.SiriusVpGroup

import static extension org.mypsycho.modit.emf.sirius.api.SiriusDesigns.*

/**
 * Sirius viewpoints group.
 * 
 * @generated
 */
class EcoretoolsDesign extends SiriusVpGroup {

	/** Metamodels used in expressions. */ // This list can be used in reverse.
	public static val EDITED_PKGS = #[
		EcorePackage.eINSTANCE,
		GenModelPackage.eINSTANCE
	]

	new () { super(EDITED_PKGS) }

	override initContent(Group it) {
		name = "EcoreTools"
		version = "12.0.0.2017041100"
		viewpoint("Design") [
			endUserDocumentation = "<html>\n<head>\n</head>\n<body>\n<p>Provides graphical and tabular representation to design an Ecore model.</p>\n<br>\n<img src=\"/icons/full/wizban/entities.png\"/>\n<img src=\"/icons/full/wizban/classes.png\"/>\n</body>\n</html>\n\n\n"
			modelFileExtension = "ecore xcore ecorebin"
			owned(EntitiesDiagram)
			owned(ClassesEditionTable)
			use(org.eclipse.emf.ecoretools.design.service.DesignServices)
			use(org.eclipse.sirius.common.tools.api.interpreter.StandardServices)
			use(org.eclipse.emf.ecoretools.design.service.PropertiesServices)
			use(org.eclipse.emf.ecoretools.design.service.ALEServices)
		]
		viewpoint("Archetype") [
			endUserDocumentation = "Add support for archetypes-based modeling to the Entities modeler."
			modelFileExtension = "ecore xcore ecorebin"
			owned(EntitiesWithArchetypesDiagramExtension)
			use(org.eclipse.emf.ecoretools.design.service.ArchetypeServices)
			use(org.eclipse.emf.ecoretools.design.service.PropertiesServices)
			use(org.eclipse.emf.ecoretools.design.service.ALEServices)
		]
		viewpoint("Review") [
			endUserDocumentation = "Provides representation to document and review Ecore models."
			modelFileExtension = "ecore xcore ecorebin"
			owned(DocumentationCrossTable)
			owned(DependenciesDiagram)
			use(org.eclipse.emf.ecoretools.design.service.ReviewServices)
			use(org.eclipse.emf.ecoretools.design.service.PropertiesServices)
			use(org.eclipse.emf.ecoretools.design.service.ALEServices)
		]
		viewpoint("Generation") [
			endUserDocumentation = "Adds support for EMF GenModel configuration."
			modelFileExtension = "genmodel"
			owned(GenPackageAttributesEditionTable)
			use(org.eclipse.emf.ecoretools.design.service.GenerationServices)
			use(org.eclipse.emf.ecoretools.design.service.PropertiesServices)
			use(org.eclipse.emf.ecoretools.design.service.ALEServices)
		]
		colorsPalette("Ecore Palette",
			InterpolatedColor.createAs("color:Size Based Color") [
				name = "Size Based Color"
				minValueComputationExpression = '''0'''.trimAql
				maxValueComputationExpression = '''10'''.trimAql
			],
			"MomentIntervalColor".color(250, 190, 190),
			"RoleColor".color(250, 240, 180),
			"PartyPlaceThingColor".color(180, 230, 180),
			"DescriptionColor".color(180, 200, 210),
			"Package Color".color(255, 245, 182),
			"External Package Color".color(253, 208, 142),
			"EClass".color(255, 252, 216),
			"EPackage".color(217, 210, 220),
			"EDataType".color(255, 250, 191),
			"EEnum".color(221, 236, 202),
			"Dark EClass".color(125, 125, 125),
			"Dark EPackage".color(125, 125, 125),
			"Dark EDataType".color(125, 125, 125),
			"Dark EEnum".color(125, 125, 125),
			"Doc Annotation".color(220, 234, 183),
			"Abstract EClass".color(228, 228, 228),
			"Inherited".color(125, 125, 125)
		)
		properties(DefaultViewExtension)
	}

}
