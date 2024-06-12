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

import java.nio.file.Path
import java.util.List
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.sirius.business.api.helper.ViewpointUtil
import org.eclipse.sirius.properties.ViewExtensionDescription
import org.eclipse.sirius.viewpoint.description.Group
import org.eclipse.sirius.viewpoint.description.JavaExtension
import org.eclipse.sirius.viewpoint.description.RepresentationDescription
import org.eclipse.sirius.viewpoint.description.RepresentationExtensionDescription
import org.eclipse.sirius.viewpoint.description.UserColorsPalette
import org.eclipse.sirius.viewpoint.description.UserFixedColor
import org.eclipse.sirius.viewpoint.description.Viewpoint
import org.mypsycho.modit.emf.sirius.api.SiriusVpGroup

/** 
 * Specific reverse for AbstractGroup class.
 */
class SiriusGroupTemplate extends TypedTemplate<Group> {
	
	static val INIT_TEMPLATED = #{
		Viewpoint -> #{ PKG.identifiedElement_Name },
		UserColorsPalette -> #{ PKG.userColorsPalette_Name }
	}
	
//	// XTend does not support statefull inner class
//	@Accessors
//	val SiriusReverseIt tool
	
	new(SiriusReverseIt container, String classname, Path dir, Resource res) {
		super(container, classname, dir, res, Group)

		delegates += #[
			DiagramTemplate, 
			DiagramExtensionTemplate, 
			TableTemplate, 
			TreeTemplate, 
			PropertiesTemplate
		].map[ getConstructor(SiriusGroupTemplate).newInstance(this) ]
	}
	
	override getNsMapping() { List.of }
		
	/** Lists fields where a accelerator replace basic assignment. */
	override getInitTemplateds() { INIT_TEMPLATED }

	override protected prepareContext() {
		context.aliases +=  tool.source
			.userColorsPalettes
			.flatMap[ entries ]
			.toMap([ it ]) [ '''color:«name»''' ]
		
		super.prepareContext()
	}
	
	// Xtend
	override templateMain(EObject it, Iterable<Class<?>> packages, ()=>String content) {
		val templateExtrasContent = templateExtras.trim ?: ""
'''«context.filerHeader»package «context.mainClass.pack»

«context.mainClass.templateImports»

import static extension org.mypsycho.modit.emf.sirius.api.SiriusDesigns.*

/**
 * Sirius viewpoints group.
 * 
 * @generated
 */
class «context.mainClass.name» extends «SiriusVpGroup.templateClass» {

	/** Metamodels used in expressions. */ // This list can be used in reverse.
	public static val EDITED_PKGS = #[
«
FOR pkg : tool.editedPackages
SEPARATOR LValueSeparator // cannot include comma in template: improper for last value.
»		«pkg.class.interfaces.head.templateClass».eINSTANCE«
ENDFOR
»
	]

	new () { super(EDITED_PKGS) }

	override initContent(«Group.templateClass» it) {
		«content.apply»
	}

« // initExtras must be performed AFTER model exploration
IF !templateExtrasContent.empty
»	override initExtras() {
		super.initExtras
		
		«templateExtrasContent»
	}

« ENDIF 
»}
'''}
	
	def isEnvironment(EObject it) {
		ViewpointUtil.ENVIRONMENT_URI_SCHEME == eResource?.URI?.scheme
	} 
	
	override getRecordedExplicitExtras() {
		val result = context.explicitExtras
			// environment is in 'initExtras'
			.filter[ key, value | !key.isEnvironment ]
			result
	}

	override templateExplicitAlias(EObject it)
'''«templateClass».eObject(«toUri.toJava »)'''	
	
	override templateSimpleContent(EObject it)
		// As assembling is performed by SiriusModelProvider,
		// use the code from #templateInnerCreate.
'''
«
FOR c : innerContent SEPARATOR statementSeparator 
»«templateProperty(c.key, c.value)»«
ENDFOR
»
'''

	override templateInnerCreate(EObject it) {
		switch (it) {
			// JavaExtension: '''use(«qualifiedClassName»)'''
			UserFixedColor: '''"«name»".color(«red», «green», «blue»)'''
			default: super.templateInnerCreate(it)
		}
	}
	
	override templatePropertyValue(EStructuralFeature feat, Object value, (Object)=>String encoding) {
		feat == PKG.viewpoint_OwnedJavaExtensions
			? '''use(«(value as JavaExtension).qualifiedClassName»)'''
			: feat.findSubClassCase(value) !== null
			? '''«feat.findSubClassCase(value)»(«context.splits.get(value).templateSplitClass»)'''
			: PKG.group_OwnedViewpoints == feat
			? (value as Viewpoint).templateViewpoint
			: PKG.group_UserColorsPalettes == feat
			? (value as UserColorsPalette).templateColorsPalette
			: super.templatePropertyValue(feat, value, encoding)
	}
	
	static val SUB_CLASSES_CASES = #{
		PKG.viewpoint_OwnedRepresentations -> RepresentationDescription -> "owned",
		PKG.viewpoint_OwnedRepresentationExtensions -> RepresentationExtensionDescription -> "owned",
		PKG.group_Extensions -> ViewExtensionDescription -> "properties"
	}
	
	def findSubClassCase(EStructuralFeature feat, Object target) {
		SUB_CLASSES_CASES.entrySet.findFirst[
			key.key == feat && key.value.isInstance(target)
		]?.value
	}

	def templateViewpoint(Viewpoint it)
'''viewpoint(«name.toJava») [
	«templateFilteredContent(Viewpoint)»
]'''

	def templateColorsPalette(UserColorsPalette it)
'''colorsPalette(«name.toJava»,
	«entries.templateContainedValues»
)'''


}
