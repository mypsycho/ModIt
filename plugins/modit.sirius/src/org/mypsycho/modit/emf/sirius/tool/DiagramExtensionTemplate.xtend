package org.mypsycho.modit.emf.sirius.tool

import java.util.ArrayList
import java.util.Collection
import java.util.Collections
import java.util.List
import java.util.Map
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
import org.mypsycho.modit.emf.sirius.api.AbstractDiagramExtension
import org.mypsycho.modit.emf.sirius.api.SiriusDesigns

/** 
 * Override of default reverse for SiriusModelProvider class.
 */
class DiagramExtensionTemplate extends DiagramPartTemplate<DiagramExtensionDescription> {
	
	var RepresentationDescription extended

	new(SiriusGroupTemplate container) {
		super(container, DiagramExtensionDescription)
	}
	
	static val INIT_TEMPLATED = #{
		DiagramExtensionDescription -> #{
			// <Constructor>
			SPKG.representationExtensionDescription_RepresentationName, 
			SPKG.representationExtensionDescription_ViewpointURI,
			// <Template> initContent
			SPKG.representationExtensionDescription_Name
		},
		AdditionalLayer -> #{}
	}
	
	/** Set of classes used in sub parts by the default implementation  */
	protected static val PART_IMPORTS = (
			#{ 
				AbstractDiagramExtension
			} 
			+ INIT_TEMPLATED.keySet
		).toList
	
	override getPartStaticImports(EObject it) {
		// no super: EModit and EObject are not used directly
		PART_IMPORTS
			// + !!! requires metamodel !!!
	}
	
	override getInitTemplateds() {
		INIT_TEMPLATED
	}
	
	static def isMatching(RepresentationDescription descr, DiagramExtensionDescription content) {
		try {
			content.representationName == descr.name
				&& content.viewpointURI == AbstractDiagramExtension.getExtraVpUri(descr)
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
	
	@Deprecated
	def findDiagramFromLocal(DiagramExtensionDescription content) {
		SiriusDesigns.eContainer(content, Group)
			.ownedViewpoints
			.filter[ content.viewpointURI.endsWith("/" + name) ]
			.flatMap[ ownedRepresentations ]
			.filter(DiagramDescription)
			.findFirst[ content.representationName == name  ]
	}
	
	def identifyExtended(DiagramExtensionDescription content) {
		if (content.extendedLocal) {
			// 
			return null
		}
		val result =  content.findDiagramFromExtras 
			?: content.findDiagramFromIndirectExtras
		if (result === null) {
			throw new IllegalStateException(
				'''No representation in extras: «content.viewpointURI»#/«content.representationName» ''')
		}
		result
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
'''package «pack»

«templateImports»

import static extension org.mypsycho.modit.emf.sirius.api.SiriusDesigns.*

class «name» extends «AbstractDiagramExtension.templateClass» {

««« extension ensures template expression work the same
	new(extension «parentClassName» parent) {
		super(parent, «content.name.toJava»«
IF extended !== null						», «extended.templateRef(DiagramDescription)»«
ENDIF										»)
	}

	override initContent(«DiagramExtensionDescription.templateClass» it) {
«
IF extended === null						
»		viewpointURI = «content.viewpointURI.toJava»
		representationName = «content.representationName.toJava»
«
ENDIF										
»		«content.templateFilteredContent(DiagramExtensionDescription)»
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

	override templateExtra(EObject it, String key) {
		if (it === extended) "extended"
		else super.templateExtra(it, key)
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
		SPKG.representationElementMapping_DetailDescriptions.recopy,
		SPKG.representationElementMapping_NavigationDescriptions.recopy,
		DPKG.diagramElementMapping_DeletionDescription.recopy,
		DPKG.diagramElementMapping_LabelDirectEdit.recopy,
		DPKG.dragAndDropTargetDescription_DropDescriptions.recopy,
		DPKG.abstractNodeMapping_ReusedBorderedNodeMappings -> 
			#[ 
				DPKG.abstractNodeMapping_ReusedBorderedNodeMappings,
				DPKG.abstractNodeMapping_BorderedNodeMappings
			],
		DPKG.containerMapping_ReusedNodeMappings -> 
			#[ 
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
»«target.templatePropertyValue('''importedMapping.«source.safename»''')»«
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
