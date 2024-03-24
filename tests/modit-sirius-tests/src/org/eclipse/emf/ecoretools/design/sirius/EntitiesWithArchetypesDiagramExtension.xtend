package org.eclipse.emf.ecoretools.design.sirius

import org.eclipse.emf.ecore.EcorePackage
import org.eclipse.sirius.diagram.description.AdditionalLayer
import org.eclipse.sirius.diagram.description.ContainerMapping
import org.eclipse.sirius.diagram.description.DiagramExtensionDescription
import org.eclipse.sirius.diagram.description.style.FlatContainerStyleDescription
import org.eclipse.sirius.diagram.description.tool.ContainerCreationDescription
import org.eclipse.sirius.diagram.description.tool.ToolSection
import org.eclipse.sirius.viewpoint.description.UserFixedColor
import org.mypsycho.modit.emf.sirius.api.SiriusDiagramExtension

import static extension org.mypsycho.modit.emf.sirius.api.SiriusDesigns.*

class EntitiesWithArchetypesDiagramExtension extends SiriusDiagramExtension {

	new(EcoretoolsDesign parent) {
		super(parent)
	}

	override initContent(DiagramExtensionDescription it) {
		name = "Entities With Archetypes"
		viewpointURI = "viewpoint:/org.mypsycho.emf.modit.sirius.tests/Design"
		representationName = "Entities"
		metamodel.clear // Disable implicit metamodel import
		metamodel += EcorePackage.eINSTANCE
		layers += createArchetypesLayer
	}

	def createArchetypesLayer() {
		AdditionalLayer.create("Archetypes") [
			activeByDefault = true
			styleCustomisations += "service:isMomentInterval".thenStyle(
				"foregroundColor".refCustomization(UserFixedColor.ref("color:MomentIntervalColor"),
					FlatContainerStyleDescription.ref(EntitiesDiagram, Ns.node, "EC EClass") [ (it as ContainerMapping).style as FlatContainerStyleDescription ],
					FlatContainerStyleDescription.ref(EntitiesDiagram, Ns.node, "EC EClass") [ (it as ContainerMapping).conditionnalStyles.get(1).style as FlatContainerStyleDescription ],
					FlatContainerStyleDescription.ref(EntitiesDiagram, Ns.node, "EC EClass") [ (it as ContainerMapping).conditionnalStyles.get(0).style as FlatContainerStyleDescription ]
				)
			)
			styleCustomisations += "service:isDescription".thenStyle(
				"foregroundColor".refCustomization(UserFixedColor.ref("color:DescriptionColor"),
					FlatContainerStyleDescription.ref(EntitiesDiagram, Ns.node, "EC EClass") [ (it as ContainerMapping).style as FlatContainerStyleDescription ],
					FlatContainerStyleDescription.ref(EntitiesDiagram, Ns.node, "EC EClass") [ (it as ContainerMapping).conditionnalStyles.get(1).style as FlatContainerStyleDescription ],
					FlatContainerStyleDescription.ref(EntitiesDiagram, Ns.node, "EC EClass") [ (it as ContainerMapping).conditionnalStyles.get(0).style as FlatContainerStyleDescription ]
				)
			)
			styleCustomisations += "service:isThing".thenStyle(
				"foregroundColor".refCustomization(UserFixedColor.ref("color:PartyPlaceThingColor"),
					FlatContainerStyleDescription.ref(EntitiesDiagram, Ns.node, "EC EClass") [ (it as ContainerMapping).style as FlatContainerStyleDescription ],
					FlatContainerStyleDescription.ref(EntitiesDiagram, Ns.node, "EC EClass") [ (it as ContainerMapping).conditionnalStyles.get(1).style as FlatContainerStyleDescription ],
					FlatContainerStyleDescription.ref(EntitiesDiagram, Ns.node, "EC EClass") [ (it as ContainerMapping).conditionnalStyles.get(0).style as FlatContainerStyleDescription ]
				)
			)
			styleCustomisations += "service:isRole".thenStyle(
				"foregroundColor".refCustomization(UserFixedColor.ref("color:RoleColor"),
					FlatContainerStyleDescription.ref(EntitiesDiagram, Ns.node, "EC EClass") [ (it as ContainerMapping).style as FlatContainerStyleDescription ],
					FlatContainerStyleDescription.ref(EntitiesDiagram, Ns.node, "EC EClass") [ (it as ContainerMapping).conditionnalStyles.get(1).style as FlatContainerStyleDescription ],
					FlatContainerStyleDescription.ref(EntitiesDiagram, Ns.node, "EC EClass") [ (it as ContainerMapping).conditionnalStyles.get(0).style as FlatContainerStyleDescription ]
				)
			)
			toolSections += createArchetypesArchetypeTools
		]
	}

	def createArchetypesArchetypeTools() {
		ToolSection.create("Archetype") [
			ownedTools += ContainerCreationDescription.createAs(Ns.operation, "MomentInterval") [
				initVariables
				documentation = "Does the class represent a moment or interval of time that we need to track for business or legal reasons? "
				forceRefresh = true
				iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/MomentInterval.gif"
				containerMappings += ContainerMapping.ref(EntitiesDiagram, Ns.node, "EC EClass")
				extraMappings += ContainerMapping.ref(EntitiesDiagram, Ns.node, "EC EClass")
				operation = "var:container".toContext(
					"service:isEPackage".ifThenDo(
						"eClassifiers".creator("ecore.EClass").chain(
							"name".setter(''' 'newMomentInterval' + self.eContainer()->filter(ecore::EPackage).eClassifiers->filter(ecore::EClass)->size() '''.trimAql).chain(
								'''self.addArchetypeAnnotation('MomentInterval')'''.trimAql.toOperation
							)
						)
					),
					"service:isEClass".ifThenDo(
						'''self.addArchetypeAnnotation('MomentInterval')'''.trimAql.toOperation
					)
				)
			]
			ownedTools += ContainerCreationDescription.createAs(Ns.operation, "Description") [
				initVariables
				documentation = "Does the class represent a catalog-entry like description? "
				forceRefresh = true
				iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/Description.gif"
				containerMappings += ContainerMapping.ref(EntitiesDiagram, Ns.node, "EC EClass")
				extraMappings += ContainerMapping.ref(EntitiesDiagram, Ns.node, "EC EClass")
				operation = "var:container".toContext(
					'''container.oclIsTypeOf(ecore::EPackage)'''.trimAql.ifThenDo(
						"eClassifiers".creator("ecore.EClass").chain(
							"name".setter(''' 'newDescription' + self.eContainer()->filter(ecore::EPackage).eClassifiers->filter(ecore::EClass)->size() '''.trimAql).chain(
								'''self.addArchetypeAnnotation('Description')'''.trimAql.toOperation
							)
						)
					),
					'''container.oclIsTypeOf(ecore::EClass)'''.trimAql.ifThenDo(
						'''self.addArchetypeAnnotation('Description')'''.trimAql.toOperation
					)
				)
			]
			ownedTools += ContainerCreationDescription.createAs(Ns.operation, "Role") [
				initVariables
				documentation = "Does the class represent a role being played by a party (person or organization), place or thing? "
				forceRefresh = true
				iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/Role.gif"
				containerMappings += ContainerMapping.ref(EntitiesDiagram, Ns.node, "EC EClass")
				extraMappings += ContainerMapping.ref(EntitiesDiagram, Ns.node, "EC EClass")
				operation = "var:container".toContext(
					'''container.oclIsTypeOf(ecore::EPackage)'''.trimAql.ifThenDo(
						"eClassifiers".creator("ecore.EClass").chain(
							"name".setter(''' 'newRole' + self.eContainer()->filter(ecore::EPackage).eClassifiers->filter(ecore::EClass)->size() '''.trimAql).chain(
								'''self.addArchetypeAnnotation('Role')'''.trimAql.toOperation
							)
						)
					),
					'''container.oclIsTypeOf(ecore::EClass)'''.trimAql.ifThenDo(
						'''self.addArchetypeAnnotation('Role')'''.trimAql.toOperation
					)
				)
			]
			ownedTools += ContainerCreationDescription.createAs(Ns.operation, "Place/Thing") [
				initVariables
				forceRefresh = true
				iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/Thing.gif"
				containerMappings += ContainerMapping.ref(EntitiesDiagram, Ns.node, "EC EClass")
				extraMappings += ContainerMapping.ref(EntitiesDiagram, Ns.node, "EC EClass")
				operation = "var:container".toContext(
					'''container.oclIsTypeOf(ecore::EPackage)'''.trimAql.ifThenDo(
						"eClassifiers".creator("ecore.EClass").chain(
							"name".setter(''' 'newThing' + self.eContainer()->filter(ecore::EPackage).eClassifiers->filter(ecore::EClass)->size() '''.trimAql).chain(
								'''self.addArchetypeAnnotation('Thing')'''.trimAql.toOperation
							)
						)
					),
					'''container.oclIsTypeOf(ecore::EClass)'''.trimAql.ifThenDo(
						'''self.addArchetypeAnnotation('Thing')'''.trimAql.toOperation
					)
				)
			]
		]
	}

}