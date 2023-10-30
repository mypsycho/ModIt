package org.mypsycho.modit.emf.sirius.tool

import java.util.Collections
import java.util.List
import java.util.Map
import java.util.Objects
import java.util.Set
import org.eclipse.core.runtime.Platform
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.sirius.diagram.description.tool.DirectEditLabel
import org.eclipse.sirius.table.metamodel.table.description.TableTool
import org.eclipse.sirius.viewpoint.description.AbstractVariable
import org.eclipse.sirius.viewpoint.description.DescriptionPackage
import org.eclipse.sirius.viewpoint.description.IdentifiedElement
import org.eclipse.sirius.viewpoint.description.tool.ChangeContext
import org.eclipse.sirius.viewpoint.description.tool.ContainerModelOperation
import org.eclipse.sirius.viewpoint.description.tool.CreateInstance
import org.eclipse.sirius.viewpoint.description.tool.EditMaskVariables
import org.eclipse.sirius.viewpoint.description.tool.ExternalJavaAction
import org.eclipse.sirius.viewpoint.description.tool.For
import org.eclipse.sirius.viewpoint.description.tool.If
import org.eclipse.sirius.viewpoint.description.tool.Let
import org.eclipse.sirius.viewpoint.description.tool.OperationAction
import org.eclipse.sirius.viewpoint.description.tool.PasteDescription
import org.eclipse.sirius.viewpoint.description.tool.SelectionWizardDescription
import org.eclipse.sirius.viewpoint.description.tool.SetValue
import org.eclipse.sirius.viewpoint.description.tool.ToolDescription
import org.mypsycho.modit.emf.ClassId
import org.mypsycho.modit.emf.EReversIt
import org.mypsycho.modit.emf.sirius.api.SiriusDesigns

import static extension org.mypsycho.modit.emf.sirius.tool.SiriusReverseIt.*
import org.eclipse.sirius.viewpoint.description.tool.ToolPackage

/** 
 * Common methods for specific reverse for Representation Edition class.
 */
// Target EObject as DiagramExtensionDescription does not extends Representation.
abstract class RepresentationTemplate<R extends EObject> extends EReversIt {
	
	protected static val SPKG = DescriptionPackage.eINSTANCE
	protected static val TPKG = ToolPackage.eINSTANCE

	// XTend does not support statefull inner class
	protected val extension SiriusReverseIt tool
	protected val Class<R> targetClass
	
	new(SiriusGroupTemplate container, Class<R> target) {
		super(container)
		tool = container.tool
		targetClass = Objects.requireNonNull(target)
	}
	
	def List<? extends Pair<? extends Class<? extends EObject>, ? extends Enum<?>>> getNsMapping()
	
	def String templateRepresentation(ClassId it, R content)

	override isPartTemplate(EObject it) {
		targetClass.isInstance(it) 
			&& isApplicableTemplate(it as R)
	}
	
	def isApplicableTemplate(R it) { true }

	override templatePartBody(ClassId it, EObject content) {
		templateRepresentation(content as R)
	}	
	
	def getParentClassName(ClassId it) {
		// Parent class cannot use import detection 
		//   as class does not exist (part of generation)
		pack != context.mainClass.pack
			? context.mainClass.qName 
			: context.mainClass.name
	}
	
	public static val INIT_TEMPLATED = #{
		ExternalJavaAction -> #{
			TPKG.externalJavaAction_Id, 
			TPKG.externalJavaAction_Parameters,
			TPKG.containerModelOperation_SubModelOperations
		}
	}
	
	def Map<? extends Class<? extends EObject>, ? extends Set<? extends EStructuralFeature>> getInitTemplateds() {
		INIT_TEMPLATED
	}
	
	protected def String templateFilteredContent(EObject it, Class<? extends EObject> filter) {
		val filtered = initTemplateds.get(filter) ?: Collections.emptySet
		val content = innerContent
			.filter[ !filtered.contains(key) ]
			.toList
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
			.filter[ !CONTENT_PROVIDER_FIELDS.contains(key) ]
	}

 	def dispatch smartTemplateCreate(EObject it) {
		super.smartTemplateCreate(it)
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
		if (subModelOperations.empty)
'''«browseExpression.toJava».toOperation'''
		else
'''«browseExpression.toJava».toContext«
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
	
 	def dispatch smartTemplateCreate(ExternalJavaAction it) {
 		val details = templateFilteredContent(ExternalJavaAction)
 		
'''«id.classExits
	? id // use xtend reflection
	: id.toJava».javaDo(«name.toJava»«
IF !parameters.empty     », 
	«parameters.map[ '''«name.toJava» -> «value.toJava»''' ].join(LValueSeparator)»
«
ENDIF                   »)«
IF !details.blank        ».andThen[
	«details»
]«
ENDIF                    »«templateSubOperations»'''
	}
	
	def templateSubOperations(ContainerModelOperation it) {
		if (subModelOperations.empty) {
			return ""
		}
'''.chain(
	«templateContainerOperations»
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
	
	def templateContainerOperations(ContainerModelOperation it) {
		subModelOperations
			.map[ templateCreate ]
			.join(LValueSeparator)
	}

 	def dispatch smartTemplateCreate(SetValue it) {
'''«featureName.toJava».setter(«valueExpression.toJava»)«templateSubOperations»'''
	}

 	def dispatch smartTemplateCreate(CreateInstance it) {
'''«referenceName.toJava».creator(«typeName.toJava»)«
IF variableName != "instance" /* Default */            
».andThen[ variableName = «variableName.toJava» ]«
ENDIF
»«templateSubOperations»'''
	}

// Issue combining 2 operations
// 	def dispatch smartTemplateCreate(RemoveElement it) {
//'''«featureName.toJava».setter(«valueExpression.toJava»)«templateSubOperations»'''
//	}

 	def dispatch smartTemplateCreate(Let it) {
'''«valueExpression.toJava».let(«variableName.toJava»«
IF !subModelOperations.empty                        »,
	«templateContainerOperations»
«
ENDIF                                               »)'''
	}

 	def dispatch smartTemplateCreate(IdentifiedElement it) {
		templateIdentifiedCreate(it)
	}
	
	def findNs(IdentifiedElement it) {
		nsMapping
			.findFirst[ mapping | mapping.key.isInstance(it) ]
			?.value
	}
	
	def String templateIdentifiedCreate(IdentifiedElement it) { // Default
		// TODO verification:
		// We assume names follows the guidelines.
		// Store aliases to detect conflict.
		val ns = findNs
'''«templateClass».create«
IF ns !== null          »As(Ns.«ns.name», «
ELSE                    »(«
ENDIF                    »«name.toJava») [
	«templateInnerContent(innerContent)»
]'''
	}


	override callPath(EObject it, boolean withExtras) {
		if (it instanceof IdentifiedElement) {
			if (withExtras) {
				val ns = findNs
				if (ns !== null) {
					return nsRefCallPath(ns)
				}
			}
		}
		return super.callPath(it, withExtras)
	}
	
	def nsRefCallPath(IdentifiedElement it, Enum<?> ns) {
		currentContent.toString
		
		if (currentContent.isContaining(it)) {
			return new NsRefExpr(it, ns, null)
		}
		val declaring = context.splits.keySet
			.findFirst[ key | key.isContaining(it) ]
		declaring !== null
			? new NsRefExpr(it, ns, context.splits.get(declaring))
			: super.callPath(it, true)
	}
	
	static class NsRefExpr extends Expr {
		
		val Enum<?> ns
		val ClassId declaring
		
		new (IdentifiedElement src, Enum<?> ns, ClassId declaring) {
			super(src)
			this.ns = ns
			this.declaring = declaring
		}
		
		def isLocal() { declaring === null }
		
		def getSource() { super.src as IdentifiedElement }
	}
	
	protected def dispatch String templateRef(EObject it, NsRefExpr root, Expr path, Class<?> using) {
		val refRoot = root.declaring === null
			? "localRef("
			: '''ref(«root.declaring.name», '''

'''«eClass.templateClass».«refRoot»Ns.«root.ns.name», «root.source.name.toJava»)«templateAliasPath(path)»'''
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
