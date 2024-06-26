// Testing
package org.eclipse.emf.ecoretools.design.split

import org.eclipse.emf.ecore.EcorePackage
import org.eclipse.sirius.diagram.description.AdditionalLayer
import org.eclipse.sirius.diagram.description.ContainerMapping
import org.eclipse.sirius.diagram.description.DiagramDescription
import org.eclipse.sirius.diagram.description.DiagramExtensionDescription
import org.eclipse.sirius.diagram.description.style.FlatContainerStyleDescription
import org.eclipse.sirius.diagram.description.tool.ContainerCreationDescription
import org.eclipse.sirius.diagram.description.tool.NodeCreationVariable
import org.eclipse.sirius.diagram.description.tool.ToolSection
import org.eclipse.sirius.viewpoint.description.Customization
import org.eclipse.sirius.viewpoint.description.EReferenceCustomization
import org.eclipse.sirius.viewpoint.description.Group
import org.eclipse.sirius.viewpoint.description.UserFixedColor
import org.eclipse.sirius.viewpoint.description.VSMElementCustomization
import org.eclipse.sirius.viewpoint.description.tool.ChangeContext
import org.eclipse.sirius.viewpoint.description.tool.ContainerViewVariable
import org.eclipse.sirius.viewpoint.description.tool.CreateInstance
import org.eclipse.sirius.viewpoint.description.tool.If
import org.eclipse.sirius.viewpoint.description.tool.InitialNodeCreationOperation
import org.eclipse.sirius.viewpoint.description.tool.SetValue
import org.mypsycho.modit.emf.EModel
import static extension org.mypsycho.modit.emf.ModitModel.*

class EntitiesWithArchetypesDiagramExtension extends EModel.Part<DiagramExtensionDescription> {

	new(ToolDesign parent) {
		super(DiagramExtensionDescription, parent)
	}

	protected override initContent(DiagramExtensionDescription it) {
		name = "Entities With Archetypes"
		viewpointURI = "viewpoint:/org.mypsycho.emf.modit.sirius.tests/Design"
		representationName = "Entities"
		metamodel += EcorePackage.eINSTANCE
		layers += AdditionalLayer.create [
			name = "Archetypes"
			activeByDefault = true
			toolSections += ToolSection.create [
				name = "Archetype"
				ownedTools += ContainerCreationDescription.create [
					documentation = "Does the class represent a moment or interval of time that we need to track for business or legal reasons? "
					name = "MomentInterval"
					forceRefresh = true
					iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/MomentInterval.gif"
					containerMappings += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass") ]
					extraMappings += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass") ]
					variable = NodeCreationVariable.create [
						name = "container"
					]
					viewVariable = ContainerViewVariable.create [
						name = "containerView"
					]
					initialOperation = InitialNodeCreationOperation.create [
						firstModelOperations = ChangeContext.create [
							browseExpression = "var:container"
							subModelOperations += If.create [
								conditionExpression = "service:isEPackage"
								subModelOperations += CreateInstance.create [
									typeName = "ecore.EClass"
									referenceName = "eClassifiers"
									subModelOperations += SetValue.create [
										featureName = "name"
										valueExpression = "aql:'newMomentInterval' + self.eContainer()->filter(ecore::EPackage).eClassifiers->filter(ecore::EClass)->size()"
										subModelOperations += ChangeContext.create [
											browseExpression = "aql:self.addArchetypeAnnotation('MomentInterval')"
										]
									]
								]
							]
							subModelOperations += If.create [
								conditionExpression = "service:isEClass"
								subModelOperations += ChangeContext.create [
									browseExpression = "aql:self.addArchetypeAnnotation('MomentInterval')"
								]
							]
						]
					]
				]
				ownedTools += ContainerCreationDescription.create [
					documentation = "Does the class represent a catalog-entry like description? "
					name = "Description"
					forceRefresh = true
					iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/Description.gif"
					containerMappings += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass") ]
					extraMappings += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass") ]
					variable = NodeCreationVariable.create [
						name = "container"
					]
					viewVariable = ContainerViewVariable.create [
						name = "containerView"
					]
					initialOperation = InitialNodeCreationOperation.create [
						firstModelOperations = ChangeContext.create [
							browseExpression = "var:container"
							subModelOperations += If.create [
								conditionExpression = "aql:container.oclIsTypeOf(ecore::EPackage)"
								subModelOperations += CreateInstance.create [
									typeName = "ecore.EClass"
									referenceName = "eClassifiers"
									subModelOperations += SetValue.create [
										featureName = "name"
										valueExpression = "aql:'newDescription' + self.eContainer()->filter(ecore::EPackage).eClassifiers->filter(ecore::EClass)->size()"
										subModelOperations += ChangeContext.create [
											browseExpression = "aql:self.addArchetypeAnnotation('Description')"
										]
									]
								]
							]
							subModelOperations += If.create [
								conditionExpression = "aql:container.oclIsTypeOf(ecore::EClass)"
								subModelOperations += ChangeContext.create [
									browseExpression = "aql:self.addArchetypeAnnotation('Description')"
								]
							]
						]
					]
				]
				ownedTools += ContainerCreationDescription.create [
					documentation = "Does the class represent a role being played by a party (person or organization), place or thing? "
					name = "Role"
					forceRefresh = true
					iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/Role.gif"
					containerMappings += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass") ]
					extraMappings += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass") ]
					variable = NodeCreationVariable.create [
						name = "container"
					]
					viewVariable = ContainerViewVariable.create [
						name = "containerView"
					]
					initialOperation = InitialNodeCreationOperation.create [
						firstModelOperations = ChangeContext.create [
							browseExpression = "var:container"
							subModelOperations += If.create [
								conditionExpression = "aql:container.oclIsTypeOf(ecore::EPackage)"
								subModelOperations += CreateInstance.create [
									typeName = "ecore.EClass"
									referenceName = "eClassifiers"
									subModelOperations += SetValue.create [
										featureName = "name"
										valueExpression = "aql:'newRole' + self.eContainer()->filter(ecore::EPackage).eClassifiers->filter(ecore::EClass)->size()"
										subModelOperations += ChangeContext.create [
											browseExpression = "aql:self.addArchetypeAnnotation('Role')"
										]
									]
								]
							]
							subModelOperations += If.create [
								conditionExpression = "aql:container.oclIsTypeOf(ecore::EClass)"
								subModelOperations += ChangeContext.create [
									browseExpression = "aql:self.addArchetypeAnnotation('Role')"
								]
							]
						]
					]
				]
				ownedTools += ContainerCreationDescription.create [
					name = "Place/Thing"
					forceRefresh = true
					iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/Thing.gif"
					containerMappings += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass") ]
					extraMappings += ContainerMapping.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass") ]
					variable = NodeCreationVariable.create [
						name = "container"
					]
					viewVariable = ContainerViewVariable.create [
						name = "containerView"
					]
					initialOperation = InitialNodeCreationOperation.create [
						firstModelOperations = ChangeContext.create [
							browseExpression = "var:container"
							subModelOperations += If.create [
								conditionExpression = "aql:container.oclIsTypeOf(ecore::EPackage)"
								subModelOperations += CreateInstance.create [
									typeName = "ecore.EClass"
									referenceName = "eClassifiers"
									subModelOperations += SetValue.create [
										featureName = "name"
										valueExpression = "aql:'newThing' + self.eContainer()->filter(ecore::EPackage).eClassifiers->filter(ecore::EClass)->size()"
										subModelOperations += ChangeContext.create [
											browseExpression = "aql:self.addArchetypeAnnotation('Thing')"
										]
									]
								]
							]
							subModelOperations += If.create [
								conditionExpression = "aql:container.oclIsTypeOf(ecore::EClass)"
								subModelOperations += ChangeContext.create [
									browseExpression = "aql:self.addArchetypeAnnotation('Thing')"
								]
							]
						]
					]
				]
			]
			customization = Customization.create [
				vsmElementCustomizations += VSMElementCustomization.create [
					predicateExpression = "service:isMomentInterval"
					featureCustomizations += EReferenceCustomization.create [
						referenceName = "foregroundColor"
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").style as FlatContainerStyleDescription ]
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").conditionnalStyles.get(1).style as FlatContainerStyleDescription ]
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").conditionnalStyles.get(0).style as FlatContainerStyleDescription ]
						value = UserFixedColor.ref("ToolDesign") [ (it as Group).userColorsPalettes.at("Ecore Palette").entries.at(UserFixedColor, "MomentIntervalColor") ]
					]
				]
				vsmElementCustomizations += VSMElementCustomization.create [
					predicateExpression = "service:isDescription"
					featureCustomizations += EReferenceCustomization.create [
						referenceName = "foregroundColor"
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").style as FlatContainerStyleDescription ]
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").conditionnalStyles.get(1).style as FlatContainerStyleDescription ]
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").conditionnalStyles.get(0).style as FlatContainerStyleDescription ]
						value = UserFixedColor.ref("ToolDesign") [ (it as Group).userColorsPalettes.at("Ecore Palette").entries.at(UserFixedColor, "DescriptionColor") ]
					]
				]
				vsmElementCustomizations += VSMElementCustomization.create [
					predicateExpression = "service:isThing"
					featureCustomizations += EReferenceCustomization.create [
						referenceName = "foregroundColor"
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").style as FlatContainerStyleDescription ]
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").conditionnalStyles.get(1).style as FlatContainerStyleDescription ]
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").conditionnalStyles.get(0).style as FlatContainerStyleDescription ]
						value = UserFixedColor.ref("ToolDesign") [ (it as Group).userColorsPalettes.at("Ecore Palette").entries.at(UserFixedColor, "PartyPlaceThingColor") ]
					]
				]
				vsmElementCustomizations += VSMElementCustomization.create [
					predicateExpression = "service:isRole"
					featureCustomizations += EReferenceCustomization.create [
						referenceName = "foregroundColor"
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").style as FlatContainerStyleDescription ]
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").conditionnalStyles.get(1).style as FlatContainerStyleDescription ]
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram") [ (it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").conditionnalStyles.get(0).style as FlatContainerStyleDescription ]
						value = UserFixedColor.ref("ToolDesign") [ (it as Group).userColorsPalettes.at("Ecore Palette").entries.at(UserFixedColor, "RoleColor") ]
					]
				]
			]
		]
	}

}
