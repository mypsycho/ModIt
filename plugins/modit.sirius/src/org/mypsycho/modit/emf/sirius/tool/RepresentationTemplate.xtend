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

import java.util.List
import java.util.Map
import java.util.Set
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
import org.mypsycho.modit.emf.sirius.api.AbstractEdition

/** 
 * Common methods for specific reverse for Representation Edition class.
 */
// Target EObject as DiagramExtensionDescription does not extends Representation.
abstract class RepresentationTemplate<R extends EObject> extends TypedTemplate<R> {
	
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
	
	// May an issue with Diagram sub-kind
	val AbstractEdition defaultContent
	protected Map<EClass, EObject> defaultInits = newHashMap
	
	new(SiriusGroupTemplate container, Class<R> target) {
		super(container, target)

		defaultContent = createDefaultContent
	}

	/** Lists fields where a accelerator replace basic assignment. */
	override getInitTemplateds() { INIT_TEMPLATED }
		
	def AbstractEdition createDefaultContent() { null }
	
	def getDefaultContent() { defaultContent }
	
	override templatePartBody(ClassId it, EObject content) { templateRepresentation(content as R) }	

	def String templateRepresentation(ClassId it, R content)
	
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
	«subModelOperations.templateContainedValues»
)'''
	}
 	
 	def dispatch smartTemplateCreate(If it) {
'''«conditionExpression.toJava».ifThenDo(
	«subModelOperations.templateContainedValues»
)'''
	}
	
 	def dispatch smartTemplateCreate(For it) {
'''«expression.toJava».forDo(«iteratorName.toJava», 
	«subModelOperations.templateContainedValues»
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
	«subModelOperations.templateContainedValues»
)'''
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
		«subModelOperations.templateContainedValues»
«
ENDIF                            »)'''
	}

	def dispatch smartTemplateCreate(AbstractToolDescription it) {
		toolTemplateCreate	
	}

	def String toolTemplateCreate(EObject it) {
		var variables = eContents
			.filter(AbstractVariable)
			.toList
		
		val useDefaultVariables = variables.empty
			|| variables.filter(VariableContainer).exists[ !subVariables.empty ]
			
		val filteredContent = innerContent
			.filter[ useDefaultVariables || !key.isReferencingSubType(AbstractVariable) ]
		val header = it instanceof IdentifiedElement 
			? templateIdentifiedCreateHeader
			: '''«templateClass».create'''

'''«header» [
	«
IF !useDefaultVariables
	»initVariables
	«
ENDIF
	»«templateInnerContent(filteredContent)»
]'''}
	

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
