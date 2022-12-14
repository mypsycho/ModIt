package org.eclipse.emf.ecoretools.design.sirius

import org.eclipse.emf.ecore.EPackage
import org.eclipse.sirius.diagram.description.AdditionalLayer
import org.eclipse.sirius.diagram.description.ConditionalContainerStyleDescription
import org.eclipse.sirius.diagram.description.ContainerMapping
import org.eclipse.sirius.diagram.description.DiagramDescription
import org.eclipse.sirius.diagram.description.DiagramExtensionDescription
import org.eclipse.sirius.diagram.description.Layer
import org.eclipse.sirius.diagram.description.style.FlatContainerStyleDescription
import org.eclipse.sirius.diagram.description.tool.ContainerCreationDescription
import org.eclipse.sirius.diagram.description.tool.NodeCreationVariable
import org.eclipse.sirius.diagram.description.tool.ToolSection
import org.eclipse.sirius.viewpoint.description.Customization
import org.eclipse.sirius.viewpoint.description.EReferenceCustomization
import org.eclipse.sirius.viewpoint.description.UserFixedColor
import org.eclipse.sirius.viewpoint.description.VSMElementCustomization
import org.eclipse.sirius.viewpoint.description.tool.ChangeContext
import org.eclipse.sirius.viewpoint.description.tool.ContainerViewVariable
import org.eclipse.sirius.viewpoint.description.tool.CreateInstance
import org.eclipse.sirius.viewpoint.description.tool.If
import org.eclipse.sirius.viewpoint.description.tool.InitialNodeCreationOperation
import org.eclipse.sirius.viewpoint.description.tool.SetValue
import org.mypsycho.modit.emf.sirius.api.AbstractDiagramExtension

import static extension org.mypsycho.modit.emf.sirius.api.SiriusDesigns.*

class EntitiesWithArchetypesDiagramExtension extends AbstractDiagramExtension {

	new(extension EcoretoolsDesign parent) {
		super(parent, "Entities With Archetypes")
	}

	override initContent(DiagramExtensionDescription it) {
		viewpointURI = "viewpoint:/org.mypsycho.emf.modit.sirius.tests/Design"
		representationName = "Entities"
		metamodel += org.eclipse.emf.ecore.EcorePackage.eINSTANCE
layers += createArchetypesLayer
	}

	def createArchetypesLayer() {
		AdditionalLayer.create("Archetypes") [
			activeByDefault = true
			customization = Customization.create [
				vsmElementCustomizations += VSMElementCustomization.create [
					predicateExpression = "service:isMomentInterval"
					featureCustomizations += EReferenceCustomization.create [
						referenceName = "foregroundColor"
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram")[ ((it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").style as FlatContainerStyleDescription) ]
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram")[ ((it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").conditionnalStyles.get(1).style as FlatContainerStyleDescription) ]
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram")[ ((it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").conditionnalStyles.get(0).style as FlatContainerStyleDescription) ]
						value = UserFixedColor.ref("color:MomentIntervalColor")
					]
				]
				vsmElementCustomizations += VSMElementCustomization.create [
					predicateExpression = "service:isDescription"
					featureCustomizations += EReferenceCustomization.create [
						referenceName = "foregroundColor"
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram")[ ((it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").style as FlatContainerStyleDescription) ]
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram")[ ((it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").conditionnalStyles.get(1).style as FlatContainerStyleDescription) ]
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram")[ ((it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").conditionnalStyles.get(0).style as FlatContainerStyleDescription) ]
						value = UserFixedColor.ref("color:DescriptionColor")
					]
				]
				vsmElementCustomizations += VSMElementCustomization.create [
					predicateExpression = "service:isThing"
					featureCustomizations += EReferenceCustomization.create [
						referenceName = "foregroundColor"
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram")[ ((it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").style as FlatContainerStyleDescription) ]
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram")[ ((it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").conditionnalStyles.get(1).style as FlatContainerStyleDescription) ]
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram")[ ((it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").conditionnalStyles.get(0).style as FlatContainerStyleDescription) ]
						value = UserFixedColor.ref("color:PartyPlaceThingColor")
					]
				]
				vsmElementCustomizations += VSMElementCustomization.create [
					predicateExpression = "service:isRole"
					featureCustomizations += EReferenceCustomization.create [
						referenceName = "foregroundColor"
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram")[ ((it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").style as FlatContainerStyleDescription) ]
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram")[ ((it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").conditionnalStyles.get(1).style as FlatContainerStyleDescription) ]
						appliedOn += FlatContainerStyleDescription.ref("EntitiesDiagram")[ ((it as DiagramDescription).defaultLayer.containerMappings.at("EC EClass").conditionnalStyles.get(0).style as FlatContainerStyleDescription) ]
						value = UserFixedColor.ref("color:RoleColor")
					]
				]
			]
			toolSections += createArchetypesArchetypeTools
		]
	}

	def createArchetypesArchetypeTools() {
		ToolSection.create("Archetype") [
			ownedTools += ContainerCreationDescription.createAs(Ns.operation, "MomentInterval") [
				documentation = "Does the class represent a moment or interval of time that we need to track for business or legal reasons? "
				forceRefresh = true
				iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/MomentInterval.gif"
				containerMappings += ContainerMapping.ref(EntitiesDiagram, Ns.node, "EC EClass")
				extraMappings += ContainerMapping.ref(EntitiesDiagram, Ns.node, "EC EClass")
				variable = NodeCreationVariable.create("container")
				viewVariable = ContainerViewVariable.create("containerView")
				operation = ChangeContext.create [
					browseExpression = "var:container"
					subModelOperations += If.create [
						conditionExpression = "service:isEPackage"
						subModelOperations += CreateInstance.create [
							typeName = "ecore.EClass"
							referenceName = "eClassifiers"
							subModelOperations += SetValue.create [
								featureName = "name"
								valueExpression = ''' 'newMomentInterval' + self.eContainer()->filter(ecore::EPackage).eClassifiers->filter(ecore::EClass)->size() '''.trimAql
								subModelOperations += '''self.addArchetypeAnnotation('MomentInterval')'''.trimAql.toOperation
							]
						]
					]
					subModelOperations += If.create [
						conditionExpression = "service:isEClass"
						subModelOperations += '''self.addArchetypeAnnotation('MomentInterval')'''.trimAql.toOperation
					]
				]
			]
			ownedTools += ContainerCreationDescription.createAs(Ns.operation, "Description") [
				documentation = "Does the class represent a catalog-entry like description? "
				forceRefresh = true
				iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/Description.gif"
				containerMappings += ContainerMapping.ref(EntitiesDiagram, Ns.node, "EC EClass")
				extraMappings += ContainerMapping.ref(EntitiesDiagram, Ns.node, "EC EClass")
				variable = NodeCreationVariable.create("container")
				viewVariable = ContainerViewVariable.create("containerView")
				operation = ChangeContext.create [
					browseExpression = "var:container"
					subModelOperations += If.create [
						conditionExpression = '''container.oclIsTypeOf(ecore::EPackage)'''.trimAql
						subModelOperations += CreateInstance.create [
							typeName = "ecore.EClass"
							referenceName = "eClassifiers"
							subModelOperations += SetValue.create [
								featureName = "name"
								valueExpression = ''' 'newDescription' + self.eContainer()->filter(ecore::EPackage).eClassifiers->filter(ecore::EClass)->size() '''.trimAql
								subModelOperations += '''self.addArchetypeAnnotation('Description')'''.trimAql.toOperation
							]
						]
					]
					subModelOperations += If.create [
						conditionExpression = '''container.oclIsTypeOf(ecore::EClass)'''.trimAql
						subModelOperations += '''self.addArchetypeAnnotation('Description')'''.trimAql.toOperation
					]
				]
			]
			ownedTools += ContainerCreationDescription.createAs(Ns.operation, "Role") [
				documentation = "Does the class represent a role being played by a party (person or organization), place or thing? "
				forceRefresh = true
				iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/Role.gif"
				containerMappings += ContainerMapping.ref(EntitiesDiagram, Ns.node, "EC EClass")
				extraMappings += ContainerMapping.ref(EntitiesDiagram, Ns.node, "EC EClass")
				variable = NodeCreationVariable.create("container")
				viewVariable = ContainerViewVariable.create("containerView")
				operation = ChangeContext.create [
					browseExpression = "var:container"
					subModelOperations += If.create [
						conditionExpression = '''container.oclIsTypeOf(ecore::EPackage)'''.trimAql
						subModelOperations += CreateInstance.create [
							typeName = "ecore.EClass"
							referenceName = "eClassifiers"
							subModelOperations += SetValue.create [
								featureName = "name"
								valueExpression = ''' 'newRole' + self.eContainer()->filter(ecore::EPackage).eClassifiers->filter(ecore::EClass)->size() '''.trimAql
								subModelOperations += '''self.addArchetypeAnnotation('Role')'''.trimAql.toOperation
							]
						]
					]
					subModelOperations += If.create [
						conditionExpression = '''container.oclIsTypeOf(ecore::EClass)'''.trimAql
						subModelOperations += '''self.addArchetypeAnnotation('Role')'''.trimAql.toOperation
					]
				]
			]
			ownedTools += ContainerCreationDescription.createAs(Ns.operation, "Place/Thing") [
				forceRefresh = true
				iconPath = "/org.eclipse.emf.ecoretools.design/icons/full/obj16/Thing.gif"
				containerMappings += ContainerMapping.ref(EntitiesDiagram, Ns.node, "EC EClass")
				extraMappings += ContainerMapping.ref(EntitiesDiagram, Ns.node, "EC EClass")
				variable = NodeCreationVariable.create("container")
				viewVariable = ContainerViewVariable.create("containerView")
				operation = ChangeContext.create [
					browseExpression = "var:container"
					subModelOperations += If.create [
						conditionExpression = '''container.oclIsTypeOf(ecore::EPackage)'''.trimAql
						subModelOperations += CreateInstance.create [
							typeName = "ecore.EClass"
							referenceName = "eClassifiers"
							subModelOperations += SetValue.create [
								featureName = "name"
								valueExpression = ''' 'newThing' + self.eContainer()->filter(ecore::EPackage).eClassifiers->filter(ecore::EClass)->size() '''.trimAql
								subModelOperations += '''self.addArchetypeAnnotation('Thing')'''.trimAql.toOperation
							]
						]
					]
					subModelOperations += If.create [
						conditionExpression = '''container.oclIsTypeOf(ecore::EClass)'''.trimAql
						subModelOperations += '''self.addArchetypeAnnotation('Thing')'''.trimAql.toOperation
					]
				]
			]
		]
	}

}