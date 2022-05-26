package org.mypsycho.modit.emf.sirius.tool

import java.util.Collections
import java.util.List
import java.util.Map
import java.util.Objects
import java.util.Set
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.sirius.diagram.description.tool.DirectEditLabel
import org.eclipse.sirius.viewpoint.description.AbstractVariable
import org.eclipse.sirius.viewpoint.description.DescriptionPackage
import org.eclipse.sirius.viewpoint.description.IdentifiedElement
import org.eclipse.sirius.viewpoint.description.RepresentationDescription
import org.eclipse.sirius.viewpoint.description.tool.AbstractToolDescription
import org.eclipse.sirius.viewpoint.description.tool.OperationAction
import org.eclipse.sirius.viewpoint.description.tool.PasteDescription
import org.eclipse.sirius.viewpoint.description.tool.SelectionWizardDescription
import org.eclipse.sirius.viewpoint.description.tool.ToolDescription
import org.mypsycho.modit.emf.ClassId
import org.mypsycho.modit.emf.EReversIt
import org.mypsycho.modit.emf.sirius.api.SiriusDesigns

import static extension org.mypsycho.modit.emf.sirius.tool.SiriusReverseIt.*

/** Override of default reverse for SiriusModelProvider class. */
abstract class RepresentationTemplate<R extends RepresentationDescription> extends EReversIt {
	
	protected static val SPKG = DescriptionPackage.eINSTANCE


	// XTend does not support statefull inner class
	protected val extension SiriusReverseIt tool
	protected val Class<R> targetClass
	
	new(SiriusGroupTemplate container, Class<R> targetClass) {
		super(container)
		tool = container.tool
		this.targetClass = Objects.requireNonNull(targetClass)
	}
	
	override isPartTemplate(EObject it) {
		targetClass.isInstance(it) 
			&& 
			isApplicableTemplate(it as R)
	}
	
	def isApplicableTemplate(R it) {
		true
	}

	override templatePartBody(ClassId it, EObject content) {
		templateRepresentation(content as R)
	}
	
	def String templateRepresentation(ClassId it, R content)
	
	def Map<Class<? extends EObject>, Set<? extends EStructuralFeature>> getInitTemplateds() {
		Collections.emptyMap
	}
	
	protected def String templateFilteredContent(EObject it, Class<? extends EObject> filter) {
		val filtered = initTemplateds.get(filter) ?: Collections.emptySet
		val content = innerContent
			.filter[ !filtered.contains(key) ]	
		
		templateInnerContent(content)
	}
 
	val CONTENT_PROVIDER_FIELDS = #{
		SPKG.identifiedElement_Name,
		SPKG.abstractVariable_Name
	}
	
	override getInnerContent(EObject it) {
		super.getInnerContent(it)
			// Following feature are supported by contentProvider
			// See org.mypsycho.modit.emf.sirius.SiriusModelProvider#new(Iterable<? extends EPackage>)
			.filter[ !CONTENT_PROVIDER_FIELDS.contains(key)  ]
	}
	
 
	override templateInnerCreate(EObject it) {
		smartTemplateCreate.toString
	}


	
 	def dispatch smartTemplateCreate(AbstractVariable it) {
 		val content = innerContent
'''«templateClass».create("«name»")«
IF !innerContent.empty             » [
	«templateInnerContent(content)»
]
«
ENDIF
»'''
 	}
 	
 		
 	def dispatch smartTemplateCreate(IdentifiedElement it) {
		templateIdentifiedCreate(it)
	}

//	static val NS_MAPPING = #[
//		AbstractNodeMapping -> AbstractDiagram.Ns.node,
//		EdgeMapping -> AbstractDiagram.Ns.edge,
//		DeleteElementDescription -> AbstractDiagram.Ns.del,
//		EdgeCreationDescription -> AbstractDiagram.Ns.connect,
//		ReconnectEdgeDescription -> AbstractDiagram.Ns.reconnect,
//		
//		NodeCreationDescription -> AbstractDiagram.Ns.creation,
//		ContainerDropDescription -> AbstractDiagram.Ns.drop,
//		AbstractToolDescription -> AbstractDiagram.Ns.operation
//	]
	
	def List<? extends Pair<? extends Class<? extends EObject>, ? extends Enum<?>>> getNsMapping()
	
	def findNs(IdentifiedElement it) {
		nsMapping
			.findFirst[ mapping | mapping.key.isInstance(it) ]
			?.value
	}
	
	def templateIdentifiedCreate(IdentifiedElement it) { // Default
		val ns = findNs

'''«templateClass».create«
IF ns !== null
						»As(Ns.«ns.name», «
ELSE
						»(«
ENDIF
						»"«it.name»") [
	«templateInnerContent(innerContent)»
]'''
	}

 	def dispatch smartTemplateCreate(EObject it) { // Default
		super.templateInnerCreate(it)
	}

	override templateRef(EObject it, Class<?> using) {
		if (it instanceof IdentifiedElement) {
			val ns = findNs
			if (ns !== null) {
				if (currentContent.isContaining(it)) {
					return '''«eClass.templateClass».localRef(Ns.«ns.name», "«name»")'''
				}
				val declaring = context.splits.keySet
					.findFirst[ key | key.isContaining(it) ]
				if (declaring !== null) {
					val declaringId = context.splits.get(declaring)
					// TODO deal with different packages ?
					return '''«eClass.templateClass».ref(«declaringId.name», Ns.«ns.name», "«name»")'''
				}
			}
		}
		
		super.templateRef(it, using)
	}

	
	override templateProperty(EObject element, EStructuralFeature it, (Object, Class<?>)=>String encoding) {
		element.smartTemplateProperty(it, encoding)
	}

	def dispatch smartTemplateProperty(EObject element, EStructuralFeature it, (Object, Class<?>)=>String encoding) {
		// Default
		super.templateProperty(element, it, encoding)
	}
	
	def dispatch smartTemplateProperty(AbstractToolDescription element, EStructuralFeature it, (Object, Class<?>)=>String encoding) {
		if (name == "initialOperation") {
			try {
				return element.templateToolOperation
			} catch (UnsupportedOperationException ex) {
				System.err.println("Add operation in DiagramTemplate: " 
					+ (element as AbstractToolDescription).eClass.name
				)
			}
		}
		super.templateProperty(element, it, encoding)
	}
	
	def getToolModelOperation(AbstractToolDescription it) {
		switch(it) {
			// All representation
			OperationAction: initialOperation.firstModelOperations
			ToolDescription: initialOperation.firstModelOperations
			PasteDescription: initialOperation.firstModelOperations
			SelectionWizardDescription: initialOperation.firstModelOperations
			DirectEditLabel: initialOperation.firstModelOperations
			default: throw new UnsupportedOperationException
		}
	}
	
	def String templateToolOperation(AbstractToolDescription it) {
		val operation = toolModelOperation
		if (operation !== null)
			'''operation = «operation.templateCreate»'''
		else 
			'''// no operation '''
	}
	
	
	dispatch override toJava(String it) {
		if (!startsWith(SiriusDesigns.AQL))
			super._toJava(it)
		else {// «» can be used to escape '
			val expression = substring(SiriusDesigns.AQL.length)
			// Issue with _'_ in templates
			if (expression.startsWith("'") || expression.endsWith("'"))
				'''«"'''"» «expression» «"'''"».trimAql'''
			else
				'''«"'''"»«expression»«"'''"».trimAql'''
		}
	}
}
