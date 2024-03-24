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
import java.util.HashMap
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.sirius.viewpoint.description.DescriptionPackage
import org.eclipse.sirius.viewpoint.description.Environment
import org.eclipse.sirius.viewpoint.description.JavaExtension
import org.eclipse.sirius.viewpoint.description.UserFixedColor
import org.eclipse.xtend.lib.annotations.Accessors
import org.mypsycho.modit.emf.EModIt
import org.mypsycho.modit.emf.EReversIt
import org.mypsycho.modit.emf.ModitModel
import org.mypsycho.modit.emf.sirius.api.SiriusVpGroup
import org.eclipse.sirius.business.api.helper.ViewpointUtil
import org.eclipse.sirius.viewpoint.description.Group

/** 
 * Specific reverse for AbstractGroup class.
 */
class SiriusGroupTemplate extends EReversIt {
	
	static val VP = DescriptionPackage.eINSTANCE
	
	// XTend does not support statefull inner class
	@Accessors
	val SiriusReverseIt tool
	
	new(SiriusReverseIt container, String classname, Path dir, Resource res) {
		super(classname, dir, res)
		tool = container
		delegates += new DiagramTemplate(this)
		delegates += new TableTemplate(this)
		delegates += new TreeTemplate(this)
		delegates += new PropertiesTemplate(this)
		delegates += new DiagramExtensionTemplate(this)
	}
	
	// Only used in SiriusModelProvider class.
	static val UNUSED_MAIN_IMPORTS = #[ 
		HashMap, ResourceSetImpl, Accessors, EModIt, ModitModel, EObject
	]
	static val EXTRA_MAIN_IMPORTS = #[ SiriusVpGroup, Environment ]
	
	@Deprecated
	override getMainStaticImports() {
		super.mainStaticImports
			.filter[ !UNUSED_MAIN_IMPORTS.contains(it) ]
			+ EXTRA_MAIN_IMPORTS
	}
	
	override protected prepareContext() {
		context.aliases +=  tool.source
			.userColorsPalettes
			.flatMap[ entries ]
			.toMap([ it ]) [ '''color:«name»''' ]
		
		super.prepareContext()
	}
	
	// Xtend
	override templateMain(EObject it, Iterable<Class<?>> packages, ()=>String content) {
		val templateExtrasContent = templateExtras ?: ""
'''package «context.mainClass.pack»

«context.mainClass.templateImports»

import static extension org.mypsycho.modit.emf.sirius.api.SiriusDesigns.*

class «context.mainClass.name» extends «SiriusVpGroup.templateClass» {
	
	new () {
        businessPackages += #[
«
FOR pkg : tool.editedPackages
SEPARATOR LValueSeparator // cannot include comma in template: improper for last value.
»			«pkg.class.interfaces.head.name».eINSTANCE«
ENDFOR
»
        ]
	}

	override initContent(«Group.templateClass» it) {
		«content.apply»
	}

« // initExtras must be performed AFTER model exploration
IF !templateExtrasContent.blank
»	override initExtras() {
		super.initExtras
		
		«templateExtrasContent»
	}

« ENDIF »

}
'''
	}
	
	def isEnvironment(EObject it) {
		ViewpointUtil.ENVIRONMENT_URI_SCHEME == eResource?.URI?.scheme
	} 
	
	override getRecordedExplicitExtras() {
		val result = context.explicitExtras
			// environment is in 'initExtras'
			.filter[ key, value | !key.isEnvironment ]
			result
	}

	override templateExplicitAlias(EObject it) {
'''«templateClass».eObject(«toUri.toJava »)'''	
	}

	override templateSimpleContent(EObject it) {
		// As assembling is performed by SiriusModelProvider,
		// use the code from #templateInnerCreate.
'''
«
FOR c : innerContent SEPARATOR statementSeparator 
»«templateProperty(c.key, c.value)»«
ENDFOR
»
'''}

	override templateInnerCreate(EObject it) {
		switch (it) {
			// JavaExtension: '''use(«qualifiedClassName»)'''
			UserFixedColor: '''"«name»".color(«red», «green», «blue»)'''
			default: super.templateInnerCreate(it)
		}
	}
	
	override templatePropertyValue(EStructuralFeature feat, Object value, (Object)=>String encoding) {
		feat == VP.viewpoint_OwnedJavaExtensions
			? '''use(«(value as JavaExtension).qualifiedClassName»)'''
			: feat == VP.viewpoint_OwnedRepresentations || feat == VP.viewpoint_OwnedRepresentationExtensions
			? feat.templateOwned(value, encoding)
			: super.templatePropertyValue(feat, value, encoding)
	}
	
	def templateOwned(EStructuralFeature feat, Object value, (Object)=>String encoding) {
		val split = context.splits.get(value)
		split !== null
			? '''owned(«split.templateSplitClass»)'''
			: super.templatePropertyValue(feat, value, encoding) // unlikely
	}

	override templateRef(EObject it, Class<?> using) {
		super.templateRef(it, using)
	}

}
