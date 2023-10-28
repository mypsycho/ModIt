/*******************************************************************************
 * Copyright (c) 2020 Nicolas PERANSIN.
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
package org.mypsycho.modit.emf

import java.nio.file.Path
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.resource.ResourceSet

/**
 * Source code Generator reversing model into Xtend class.
 * <p>
 * It can reverse 1 or several resources or model root objects. <br/>
 * EObject hierarchy can be 'split' into several class using mapping of EObject and ClassId. <br/>
 * Non-generated referenced elements can be 'aliased' with specified String.
 * </p>
 * <p>
 * As generation templates are separated from model analysis, it would be easy to extend the class
 * to generate into another language.
 * </p>
 */
class ESingleReversIt extends EReversIt {
	
	/**
	 * Construction of generation context based on content of resources set.
	 * 
	 * @param classname of main class
	 * @param dir folder of generation
	 * @param res resource to en-code
	 */
	new(String classname, Path dir, Resource res) {
		super(classname, dir, res)
		if (res.contents.size != 1) {
			throw new IllegalArgumentException("Only 1 element is expected")
		}
	}
	
		
	/**
	 * Construction of generation based on shared context.
	 * 
	 * @param Context of generation
	 */
	protected new(EReversIt parent) {
		super(parent)
	}
	
	override getMainStaticImports() { #[ EModel ] }
	
	// Xtend
	override templateMain(EObject it, Iterable<Class<?>> packages, ()=>String content) {
'''package «context.mainClass.pack»

«context.mainClass.templateImports»

class «context.mainClass.name» extends EModel<«templateClass»> {

	new() {
		super(«templateClass»,
«
FOR p : packages 
SEPARATOR LValueSeparator
»			«p.name».eINSTANCE«
ENDFOR                       »)
	}

	override initContent(«templateClass» it) {
		«templateInnerContent(innerContent)»
	}

«
IF !context.implicitExtras.empty || !context.explicitExtras.empty
»	override initExtras(ResourceSet it) {
		«templateExtras /* extras must happen AFTER model exploration */ »
	}

«
ENDIF
»
«templateShortcuts»}

'''
	}
	
	override getPartStaticImports(EObject it) { #{ EModel } }
		
	// Xtend
	override templatePartBody(ClassId it, EObject content) {
		val parentTemplate = parentPart
		
'''package «pack»

«parentTemplate.value»«templateImports(it)»
import static extension «context.mainClass.qName».*

class «name» extends EModel.Part<«content.templateClass»> {

	new(«parentTemplate.key» parent) {
		super(«content.templateClass», parent)
	}

	protected override initContent(«content.templateClass» it) {
		«content.templateXmlId(false)»«
		content.templateInnerContent(content.innerContent)»
	}

}
'''
	}
	
	
}