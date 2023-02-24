package org.mypsycho.modit.emf.sirius.tool

import java.util.Collections
import java.util.List
import java.util.Map
import java.util.Objects
import java.util.Set
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.sirius.diagram.description.tool.DirectEditLabel
import org.eclipse.sirius.table.metamodel.table.description.TableTool
import org.eclipse.sirius.viewpoint.description.AbstractVariable
import org.eclipse.sirius.viewpoint.description.DescriptionPackage
import org.eclipse.sirius.viewpoint.description.IdentifiedElement
import org.eclipse.sirius.viewpoint.description.tool.ChangeContext
import org.eclipse.sirius.viewpoint.description.tool.ContainerModelOperation
import org.eclipse.sirius.viewpoint.description.tool.EditMaskVariables
import org.eclipse.sirius.viewpoint.description.tool.ExternalJavaAction
import org.eclipse.sirius.viewpoint.description.tool.ExternalJavaActionParameter
import org.eclipse.sirius.viewpoint.description.tool.For
import org.eclipse.sirius.viewpoint.description.tool.If
import org.eclipse.sirius.viewpoint.description.tool.OperationAction
import org.eclipse.sirius.viewpoint.description.tool.PasteDescription
import org.eclipse.sirius.viewpoint.description.tool.SelectionWizardDescription
import org.eclipse.sirius.viewpoint.description.tool.SetValue
import org.eclipse.sirius.viewpoint.description.tool.ToolDescription
import org.mypsycho.modit.emf.ClassId
import org.mypsycho.modit.emf.EReversIt
import org.mypsycho.modit.emf.sirius.api.SiriusDesigns

import static extension org.mypsycho.modit.emf.sirius.tool.SiriusReverseIt.*
import org.eclipse.core.runtime.Platform

/** 
 * Common methods for specific reverse for Representation Edition class.
 */
// Target EObject as DiagramExtensionDescription does not extends Representation.
abstract class RepresentationTemplate<R extends EObject> extends EReversIt {
	
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
			&& isApplicableTemplate(it as R)
	}
	
	def isApplicableTemplate(R it) {
		true
	}

	override templatePartBody(ClassId it, EObject content) {
		templateRepresentation(content as R)
	}
	
	def String templateRepresentation(ClassId it, R content)
	
	def getParentClassName(ClassId it) {
		// Parent class cannot use import detection 
		//   as class does not exist (part of generation)
		pack != context.mainClass.pack
			? context.mainClass.qName 
			: context.mainClass.name
	}
	
	
	def Map<? extends Class<? extends EObject>, ? extends Set<? extends EStructuralFeature>> getInitTemplateds() {
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
	
	def dispatch smartTemplateCreate(EObject it) { // Default
		super.templateInnerCreate(it)
	}

 	def dispatch smartTemplateCreate(AbstractVariable it) {
 		val content = innerContent
'''«templateClass».create("«name»")«
IF !innerContent.empty             » [
	«templateInnerContent(content)»
]«
ENDIF
»'''
 	}
 	
	def dispatch smartTemplateCreate(EditMaskVariables it) {
		mask.toJava
	}
 	
 	def dispatch smartTemplateCreate(ChangeContext it) {
'''«browseExpression.toJava».toOperation«
IF !subModelOperations.empty           »(
	«templateContainerOperations»
)«
ENDIF
»'''
	}
 	
 	def dispatch smartTemplateCreate(If it) {
'''«conditionExpression.toJava».ifThenDo(
	«templateContainerOperations»
)'''
	}
	
 	def dispatch smartTemplateCreate(For it) {
'''«expression.toJava».forDo(«iteratorName.toJava», 
	«templateContainerOperations»
)'''
	}
	
	static val SIMPLE_JACTION_CASES = #[
		#{ "id", "parameters" }, // name is caught by CONTENT_PROVIDER_FIELDS
		#{ "id" }
	]
 	def dispatch smartTemplateCreate(ExternalJavaAction it) {
 		val fields = innerContent.map[
 			key.name
 		].toSet
 		
 		if (!SIMPLE_JACTION_CASES.contains(fields)) {
 			return super.templateInnerCreate(it)
		}
	
'''«id.classExits
			? id // use xtend reflection
			: id.toJava».javaDo(«name.toJava», 
	«parameters
		.map[ templateCreate ]
		.join(LValueSeparator)»
)'''
	}
	
	def classExits(String classname) {
		try {
			pluginId !== null
				&& Platform?.getBundle(pluginId)
					?.loadClass(classname) !== null
		} catch(ClassNotFoundException cnfe) {
			false
		}
	}
				
	def dispatch smartTemplateCreate(ExternalJavaActionParameter it) {
'''«name.toJava».jparam(«value.toJava»)'''
	}
	
	def templateContainerOperations(ContainerModelOperation it) {
		subModelOperations
			.map[ templateCreate ]
			.join(LValueSeparator)
	}
	

 	def dispatch smartTemplateCreate(SetValue it) {
		'''«featureName.toJava».setter(«valueExpression.toJava»)'''
	}


 	def dispatch smartTemplateCreate(IdentifiedElement it) {
		templateIdentifiedCreate(it)
	}


	def List<? extends Pair<? extends Class<? extends EObject>, ? extends Enum<?>>> getNsMapping()
	
	def findNs(IdentifiedElement it) {
		nsMapping
			.findFirst[ mapping | mapping.key.isInstance(it) ]
			?.value
	}
	
	def templateIdentifiedCreate(IdentifiedElement it) { // Default
		val ns = findNs
'''«templateClass».create«
IF ns !== null          »As(Ns.«ns.name», «
ELSE                    »(«
ENDIF                     »"«it.name»") [
	«templateInnerContent(innerContent)»
]'''
	}



	override templateRef(EObject it, Class<?> using) {
		(it instanceof IdentifiedElement 
			? templateIdentifiedRef // mirror smartTemplateCreate(IdentifiedElement)
		) ?: super.templateRef(it, using)
	}

	def String templateIdentifiedRef(IdentifiedElement it) {
		val ns = findNs
		if (ns === null) {
			return null
		}

		if (currentContent.isContaining(it)) {
			return '''«eClass.templateClass».localRef(Ns.«ns.name», "«name»")'''
		}
		val declaring = context.splits.keySet
			.findFirst[ key | key.isContaining(it) ]
		if (declaring === null) {
			return null
		}
		
		val declaringId = context.splits.get(declaring)
		// TODO: invalid if different package and duplicated name ! (rare)		
		'''«eClass.templateClass».ref(«declaringId.name», Ns.«ns.name», "«name»")'''
	}

	override templateProperty(EObject element, EStructuralFeature it, (Object, Class<?>)=>String encoding) {
		if (name == "initialOperation") { // No reflection for this.
			try {
				return element.templateToolOperation
			} catch (UnsupportedOperationException ex) {
				System.err.println('''Add operation in «this.class.simpleName»: «element.eClass.name»''')
			}
		}
		super.templateProperty(element, it, encoding)
	}
	
	
	def getToolModelOperation(EObject it) {
		switch(it) {
			// All representation
			OperationAction: initialOperation?.firstModelOperations
			ToolDescription: initialOperation?.firstModelOperations
			PasteDescription: initialOperation?.firstModelOperations
			SelectionWizardDescription: initialOperation?.firstModelOperations
			DirectEditLabel: initialOperation?.firstModelOperations
			TableTool: firstModelOperation
			default: throw new UnsupportedOperationException
		}
	}
	
	def String templateToolOperation(EObject it) {
		val operation = toolModelOperation
		operation !== null
			? '''operation = «operation.templateInnerCreate»'''
			: '''// no operation '''
	}
	
	
	dispatch override toJava(String it) {
		if (!startsWith(SiriusDesigns.AQL)) {
			return super._toJava(it)
		} 
		
		var expression = substring(SiriusDesigns.AQL.length)
		// Issue with _'_ in templates
		if (expression.startsWith("'") || expression.endsWith("'")) {
			expression = ''' «expression» ''' // add a safe-space
		}
		// «» can be used to escape '
		'''«"'''"»«expression»«"'''"».trimAql'''
		
	}
}
