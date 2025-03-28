/*******************************************************************************
 * Copyright (c) 2019-2024 OBEO.
 * 
 * This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License 2.0
 * which accompanies this distribution, and is available at
 * https://www.eclipse.org/legal/epl-2.0/
 *
 * SPDX-License-Identifier: EPL-2.0
 *
 * Contributors:
 *    Nicolas PERANSIN - initial API and implementation
 *******************************************************************************/
package org.mypsycho.modit.emf.sirius.tool

import java.util.ArrayList
import java.util.Collection
import java.util.Collections
import java.util.List
import java.util.Map
import java.util.Objects
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.sirius.diagram.description.AdditionalLayer
import org.eclipse.sirius.diagram.description.ContainerMappingImport
import org.eclipse.sirius.diagram.description.DiagramDescription
import org.eclipse.sirius.diagram.description.DiagramExtensionDescription
import org.eclipse.sirius.viewpoint.description.Group
import org.eclipse.sirius.viewpoint.description.RepresentationDescription
import org.mypsycho.modit.emf.ClassId
import org.mypsycho.modit.emf.sirius.api.SiriusDiagramExtension

/** 
 * Override of default reverse for SiriusModelProvider class.
 */
class DiagramExtensionTemplate extends DiagramPartTemplate<DiagramExtensionDescription> {
	
	static val INIT_TEMPLATED = RepresentationTemplate.INIT_TEMPLATED + #{
		DiagramExtensionDescription -> #{
			// <Constructor>
			PKG.representationExtensionDescription_RepresentationName, 
			PKG.representationExtensionDescription_ViewpointURI,
			// <Template> initContent
			PKG.representationExtensionDescription_Name
		},
		AdditionalLayer -> #{}
	}
	
	var RepresentationDescription extended

	new(SiriusGroupTemplate container) {
		super(container, DiagramExtensionDescription)
	}

	override getInitTemplateds() { INIT_TEMPLATED }
	
	override createDefaultContent() {
		new SiriusDiagramExtension(tool.defaultContent) {
			
			override initContent(DiagramExtensionDescription it) {
				throw new UnsupportedOperationException("Must not be built")
			}
			
		}
	}
	
	static def isMatching(RepresentationDescription rep, DiagramExtensionDescription it) {
		try {
			representationName == rep.name
				&& viewpointURI == SiriusDiagramExtension.getExtraVpUri(rep)
		} catch (IllegalArgumentException iae) {
			false
		}
	}
	
	def findDiagramFromExtras(DiagramExtensionDescription content) {
		val descrs = context.explicitExtras
			.keySet
			.filter(DiagramDescription)
			.toList
		descrs.findFirst[ isMatching(content) ]
	}
	
	def findDiagramFromIndirectExtras(DiagramExtensionDescription content) {
		val descrs = context.explicitExtras
			.keySet
			.filter(Group)
			.flatMap[ ownedViewpoints ]
			.flatMap[ ownedRepresentations ]
			.toList
		descrs.findFirst[ isMatching(content) ]
	}
	
	def isExtendedLocal(DiagramExtensionDescription content) {
		tool.pluginId !== null
			&& content.viewpointURI.startsWith("viewpoint:/" + tool.pluginId)
	}
	
	def identifyExtended(DiagramExtensionDescription content) {
		if (content.extendedLocal) {
			// if extended diagram is part of context,
			// it cannot be used as a reference.
			return null
		}
		val result = content.findDiagramFromExtras 
			?: content.findDiagramFromIndirectExtras
		
		Objects.requireNonNull(result,
			'''Missing representation in extras: «content.viewpointURI»#/«content.representationName» '''
		)
	}

	override templateRepresentation(ClassId it, DiagramExtensionDescription content) {
		extended = content.identifyExtended

		try {
			mainTemplate(content)
		} finally {
			extended = null
		}
	}
	

	
	def String mainTemplate(ClassId it, DiagramExtensionDescription content) {
		val extendedAlias = context.explicitExtras.get(extended)
		if (extendedAlias === null) {
			extended = null
		}
'''«context.filerHeader»package «pack»

«templateImports»

import static extension org.mypsycho.modit.emf.sirius.api.SiriusDesigns.*

/**
 * Diagram extension '«content.name»'.
 * 
 * @generated
 */
class «name» extends «SiriusDiagramExtension.templateClass» {

	new(«parentClassName» parent) {
		super(parent«
IF extendedAlias !== null // 'extension' ensures reference expression works in constructor.
					», «extendedAlias.toJava»«
ENDIF               »)
	}

	«defaultStyleTemplate»
	override initContent(«DiagramExtensionDescription.templateClass» it) {
		name = «content.name.toJava»«
IF extended === null						
»
		viewpointURI = «content.viewpointURI.toJava»
		representationName = «content.representationName.toJava»«
ENDIF										
»
		metamodel.clear // Disable implicit metamodel import
		«content.templateFilteredContent(DiagramExtensionDescription)»
	}

«
FOR layer : content.layers
SEPARATOR statementSeparator 
»	def «smartTemplateCreate(layer)»() {
		«layer.templateIdentifiedCreate»
	}

«
	FOR section : layer.toolSections
	SEPARATOR statementSeparator
»	def «smartTemplateCreate(section)»() {
		«section.templateIdentifiedCreate»
	}

«
	ENDFOR // section
»«
ENDFOR // layer
»
}''' // end-of-class
	}

	override templateRef(EObject it, Class<?> using) {
		if (it !== null && it === extended) "extended"
		else super.templateRef(it, using)
	}

	// TODO ContainerMappingImport 
	// simplify reused and DiagramElementMapping.references
		
	override templateInnerContent(EObject it, 
			Iterable<? extends Pair<EStructuralFeature, 
				? extends (Object, Class<?>)=>String>> content
	) {
		if (it instanceof ContainerMappingImport) {
			if (importedMapping !== null) {
				return templateMappingImport(content)
			}
		} 

		super.templateInnerContent(it, content)
	}
	
	static val List<Pair<EReference, List<EReference>>> DUPLICATED_IMPORT_FIELDS = #[
		PKG.representationElementMapping_DetailDescriptions.recopy,
		PKG.representationElementMapping_NavigationDescriptions.recopy,
		DPKG.diagramElementMapping_DeletionDescription.recopy,
		DPKG.diagramElementMapping_LabelDirectEdit.recopy,
		DPKG.dragAndDropTargetDescription_DropDescriptions.recopy,
		DPKG.abstractNodeMapping_ReusedBorderedNodeMappings -> #[ 
			DPKG.abstractNodeMapping_ReusedBorderedNodeMappings,
			DPKG.abstractNodeMapping_BorderedNodeMappings
		],
		DPKG.containerMapping_ReusedNodeMappings -> #[ 
			DPKG.containerMapping_ReusedNodeMappings,
			DPKG.containerMapping_SubNodeMappings
		]
		// reusedContainerMappings is altered to target ContainerMappingImport
	]

	static def recopy(EReference it) {
		it -> #[ it ]
	}
	
	static val IMPORTED_FEATURE = DPKG.containerMappingImport_ImportedMapping
	
	def String templateMappingImport(ContainerMappingImport it, 
			Iterable<? extends Pair<EStructuralFeature, 
				? extends (Object, Class<?>)=>String>> content) {
		val defaultContent = content.toMap([ key ], [ value ])
		val copied = new ArrayList<EReference>

'''
«templateProperty(IMPORTED_FEATURE, defaultContent.get(IMPORTED_FEATURE))»
«
FOR copy : DUPLICATED_IMPORT_FIELDS
	.filter[ f | shouldCopyFeature(f.key, f.value, copied) ]
SEPARATOR statementSeparator 
»«templateMappingImportFeature(copy.key, copy.value, defaultContent)»«
ENDFOR
»
«super.templateInnerContent(it, content.filter[ !copied.contains(key) ])»
'''
	}
	
	def String templateMappingImportFeature(ContainerMappingImport it,
			EReference target, List<EReference> sources,
			Map<EStructuralFeature, (Object, Class<?>)=>String> defaultContent) {
'''«
FOR source : sources
SEPARATOR statementSeparator 
»«target.templatePropertyValue('''importedMapping.«source.name.safename»''')»«
ENDFOR
»«
IF !getUncopiedValues(target, sources).empty »
«
  FOR uncopiedValue : getUncopiedValues(target, sources)
  SEPARATOR statementSeparator 
»«target.templatePropertyValue(
	defaultContent.get(target)
		.apply(uncopiedValue, target.EType.instanceClass)
)»«
  ENDFOR
»«
ENDIF
»'''
	}
	
	
	def shouldCopyFeature(ContainerMappingImport element, 
		EReference target, List<EReference> source, 
		List<EReference> copied
	) {
		val targetValues = element.eGet(target).toMany
		val sourceValues = source
			.flatMap[ element.importedMapping.eGet(it).toMany as Iterable<Object> ]
			.toList
			
		val result = targetValues.containsAll(sourceValues)
		if (result) {
			copied += target
		}
		
		result // TODO
	}
	
	def List<?> getUncopiedValues(ContainerMappingImport element, 
		EReference target, List<EReference> source
	) {
		if (!target.many) {
			return Collections.emptyList
		}
		val sourceValues = source
			.flatMap[ element.importedMapping.eGet(it).toMany as Iterable<Object> ]
			.toList;
		
		val targetValue = element.eGet(target) as Iterable<?>
		targetValue
			.filter[ !sourceValues.contains(it) ]
			.toList
	}
	
	static def toMany(Object it) {
		if (it instanceof Collection)
			it as Collection<? extends EObject>
		else
			#[ it ]
	} 

}
