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

import java.util.Collections
import java.util.List
import java.util.Map
import java.util.Objects
import java.util.Set
import org.eclipse.core.runtime.Platform
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.sirius.properties.FillLayoutDescription
import org.eclipse.sirius.properties.GridLayoutDescription
import org.eclipse.sirius.properties.LayoutDescription
import org.eclipse.sirius.properties.PropertiesPackage
import org.eclipse.sirius.viewpoint.description.AbstractVariable
import org.eclipse.sirius.viewpoint.description.DescriptionPackage
import org.eclipse.sirius.viewpoint.description.IdentifiedElement
import org.eclipse.sirius.viewpoint.description.tool.AbstractToolDescription
import org.eclipse.sirius.viewpoint.description.tool.ChangeContext
import org.eclipse.sirius.viewpoint.description.tool.ContainerModelOperation
import org.eclipse.sirius.viewpoint.description.tool.CreateInstance
import org.eclipse.sirius.viewpoint.description.tool.EditMaskVariables
import org.eclipse.sirius.viewpoint.description.tool.ExternalJavaAction
import org.eclipse.sirius.viewpoint.description.tool.For
import org.eclipse.sirius.viewpoint.description.tool.If
import org.eclipse.sirius.viewpoint.description.tool.InitEdgeCreationOperation
import org.eclipse.sirius.viewpoint.description.tool.InitialContainerDropOperation
import org.eclipse.sirius.viewpoint.description.tool.InitialNodeCreationOperation
import org.eclipse.sirius.viewpoint.description.tool.InitialOperation
import org.eclipse.sirius.viewpoint.description.tool.Let
import org.eclipse.sirius.viewpoint.description.tool.ModelOperation
import org.eclipse.sirius.viewpoint.description.tool.SetValue
import org.eclipse.sirius.viewpoint.description.tool.Switch
import org.eclipse.sirius.viewpoint.description.tool.ToolPackage
import org.eclipse.sirius.viewpoint.description.tool.Unset
import org.eclipse.sirius.viewpoint.description.tool.VariableContainer
import org.mypsycho.modit.emf.ClassId
import org.mypsycho.modit.emf.EReversIt
import org.mypsycho.modit.emf.sirius.api.AbstractEdition
import org.mypsycho.modit.emf.sirius.api.SiriusDesigns

import static extension org.mypsycho.modit.emf.sirius.tool.SiriusReverseIt.*

/** 
 * Common methods for specific reverse for Representation Edition class.
 */
// Target EObject as DiagramExtensionDescription does not extends Representation.
abstract class RepresentationTemplate<R extends EObject> extends EReversIt {
	
	protected static val PKG = DescriptionPackage.eINSTANCE
	protected static val TPKG = ToolPackage.eINSTANCE
	protected static val PPKG = PropertiesPackage.eINSTANCE

	public static val Map<Class<? extends EObject>, 
			Set<? extends EStructuralFeature>> INIT_TEMPLATED = #{
		ExternalJavaAction as Class<? extends EObject> -> #{
			TPKG.externalJavaAction_Id, 
			TPKG.externalJavaAction_Parameters,
			TPKG.containerModelOperation_SubModelOperations
		}
	}

	static val CONTENT_PROVIDER_FIELDS = #{
		PKG.identifiedElement_Name,
		PKG.abstractVariable_Name
	}
	

	// XTend does not support statefull inner class
	protected val extension SiriusReverseIt tool
	protected val Class<R> targetClass
	
	// May an issue with Diagram sub-kind
	val AbstractEdition defaultContent
	protected Map<EClass, EObject> defaultInits = newHashMap
	
	new(SiriusGroupTemplate container, Class<R> target) {
		super(container)
		tool = container.tool
		targetClass = Objects.requireNonNull(target)
		defaultContent = createDefaultContent
	}
		
	def AbstractEdition createDefaultContent() { null }
	
	def getDefaultContent() { defaultContent }
	
	def List<? extends Pair<
			? extends Class<? extends EObject>, 
			? extends Enum<?>
			>> getNsMapping()
	
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
	
	/** Lists fields where a accelerator replace basic assignment. */
	def Map<? extends Class<? extends EObject>, 
			? extends Set<? extends EStructuralFeature>> 
			getInitTemplateds() {
		INIT_TEMPLATED
	}
	
	protected def String templateFilteredContent(EObject it, Class<? extends EObject> filter) {
		val filtered = initTemplateds.get(filter) ?: Collections.emptySet
		val content = innerContent
			.filter[ !filtered.contains(key) ]
			.toList
		templateInnerContent(content)
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
 	
	def dispatch smartTemplateCreate(EditMaskVariables it) { mask.toJava }
 	
 	def dispatch smartTemplateCreate(ChangeContext it) {
		if (subModelOperations.empty) {
			return '''«browseExpression.toJava».toOperation'''
		}
'''«browseExpression.toJava».toContext(
	«templateContainerOperations»
)'''
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
	
 	def dispatch smartTemplateCreate(Switch it) {
 		val defaultOps = (^default?.subModelOperations ?: List.of)
 		
 		if (cases.exists[ subModelOperations.length != 1 ] 
 			|| defaultOps.length > 1) {
			return super.smartTemplateCreate(it)
		}
'''switchDo(
«
FOR aCase : cases
SEPARATOR LValueSeparator
»	«aCase.conditionExpression.toJava»
		-> «aCase.subModelOperations.head.templateCreate»«
ENDFOR // section
»)«
IF !defaultOps.empty 
»
	.setByDefault(«defaultOps.head.templateCreate»)«ENDIF»'''}
	
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

 	def dispatch smartTemplateCreate(Unset it) {
'''«featureName.toJava».unsetter(«elementExpression.toJava»)«templateSubOperations»'''
	}

 	def dispatch smartTemplateCreate(CreateInstance it) {
'''«referenceName.toJava».creator(«typeName.toJava»)«
IF variableName != TPKG.createInstance_VariableName.defaultValue /* Default value*/            
                                  ».andThen[ variableName = «variableName.toJava» ]«
ENDIF
»«templateSubOperations»'''
	}

// Issue combining 2 operations
// 	def dispatch smartTemplateCreate(RemoveElement it) {
//'''«featureName.toJava».remover(«valueExpression.toJava»)«templateSubOperations»'''
//	}

 	def dispatch smartTemplateCreate(Let it) {
'''«valueExpression.toJava»
	.letDo(«variableName.toJava»«
IF !subModelOperations.empty    »,
		«templateContainerOperations»
«
ENDIF                            »)'''
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
'''«templateIdentifiedCreateHeader» [
	«templateInnerContent(innerContent)»
]'''
	}
	
	def String templateIdentifiedCreateHeader(IdentifiedElement it) { // Default
		// TODO verification:
		// We assume names follows the guidelines.
		// Store aliases to detect conflict.
		val ns = findNs
'''«templateClass».create«
IF ns !== null          »As(Ns.«ns.name», «
ELSE                    »(«
ENDIF                    »«name.toJava»)'''
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
		
		protected val Enum<?> ns
		protected val ClassId declaring
		
		new (IdentifiedElement src, Enum<?> ns, ClassId declaring) {
			super(src)
			this.ns = ns
			this.declaring = declaring
		}
		
		def isLocal() { declaring === null }
		
		def getSource() { super.src as IdentifiedElement }
	}
	
	protected def dispatch String templateRef(EObject it, NsRefExpr root, Expr path, Class<?> using) {
		val refRoot = root.local
			? "localRef("
			: '''ref(«root.declaring.name», '''

'''«eClass.templateClass».«refRoot»Ns.«root.ns.name», «root.source.aliasPath.toJava»)«templateAliasPath(path)»'''
	}

	protected def aliasPath(IdentifiedElement it) { name }

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

	def dispatch smartTemplateCreate(AbstractToolDescription it) {
		toolTemplateCreate	
	}

	def isReferencingSubType(EStructuralFeature it, Class<?> type) {
		type.isAssignableFrom(EType.instanceClass)
	}

	def String toolTemplateCreate(EObject it) {
		var variables = eContents
			.filter(VariableContainer)
			.toList
		
		val complexVariables = variables.empty
			|| variables.exists[ !subVariables.empty ]
		val filteredContent = innerContent
			.filter[ complexVariables || !key.isReferencingSubType(AbstractVariable) ]
		val header = it instanceof IdentifiedElement 
			? templateIdentifiedCreateHeader
			: '''«templateClass».create'''

'''«header» [
	«
IF !complexVariables
	»initVariables
	«
ENDIF
	»«templateInnerContent(filteredContent)»
]'''}
	
//	def getToolModelOperation(EObject it) {
//		switch(it) {
//			// All representations
//			OperationAction: initialOperation?.firstModelOperations
//			ToolDescription: initialOperation?.firstModelOperations
//			PasteDescription: initialOperation?.firstModelOperations
//			SelectionWizardDescription: initialOperation?.firstModelOperations
//			DirectEditLabel: initialOperation?.firstModelOperations
//			DialogButton: initialOperation.firstModelOperations
//			TextDescription: initialOperation.firstModelOperations
//			default: throw new UnsupportedOperationException // Caught by fallback
//		}
//	}
	
	def templateToolOperation(ModelOperation it) {
		// Not a smartTemplateCreate case.
		// Applicable only tool property
		it === null
			?  '''// no operation '''
			: '''operation = «templateInnerCreate»'''
	}
	
	override templatePropertyValue(EStructuralFeature feat, Object value, (Object)=>String encoding) {
		(value instanceof InitialOperation) // only used with tools and initialOperation
			? value.firstModelOperations.templateToolOperation
			: (value instanceof InitialContainerDropOperation) // legacy ?
			? value.firstModelOperations.templateToolOperation
			: (value instanceof InitialNodeCreationOperation) // legacy ?
			? value.firstModelOperations.templateToolOperation
			: (value instanceof InitEdgeCreationOperation) // legacy ?
			? value.firstModelOperations.templateToolOperation
			: PPKG.abstractContainerDescription_Layout == feat
			? (value as LayoutDescription).templatePropertiesLayout(encoding)
			: super.templatePropertyValue(feat, value, encoding)
	}
	
	def templatePropertiesLayout(LayoutDescription it, (Object)=>String encoding) {
		it instanceof FillLayoutDescription
			? '''layout«orientation.getName().toLowerCase.toFirstUpper»'''
			: it instanceof GridLayoutDescription
			? '''layout«makeColumnsWithEqualWidth ? "Regular" : "Free"»Grid(«numberOfColumns»)'''
			: super.templatePropertyValue(PPKG.abstractContainerDescription_Layout, it, encoding)
	}
	
	
}
