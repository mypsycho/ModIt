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
package org.mypsycho.modit.emf.sirius.tool;

import java.nio.file.Path
import java.util.ArrayList
import java.util.Collections
import java.util.HashMap
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.sirius.properties.ViewExtensionDescription
import org.eclipse.sirius.viewpoint.description.DescriptionPackage
import org.eclipse.sirius.viewpoint.description.Environment
import org.eclipse.sirius.viewpoint.description.Group
import org.eclipse.sirius.viewpoint.description.RepresentationDescription
import org.eclipse.sirius.viewpoint.description.RepresentationExtensionDescription
import org.eclipse.sirius.viewpoint.description.Viewpoint
import org.eclipse.xtend.lib.annotations.Accessors
import org.mypsycho.modit.emf.ClassId
import org.mypsycho.modit.emf.EModIt
import org.mypsycho.modit.emf.EReversIt
import org.mypsycho.modit.emf.ModitModel
import org.mypsycho.modit.emf.sirius.SiriusModelProvider

/**
 * 
 * add following plugins 
 * org.eclipse.sirius.properties
 * org.eclipse.sirius.table
 * org.mypsycho.emf.modit.sirius
 * 
 * @author nperansin
 */
class SiriusReverseIt {

	val ResourceSet rs
	val Group source
	val ClassId classId
	
	@Accessors
	val Engine engine
	
	/**
	 * Construct a reverse of a Odesign.
	 * 
	 * @param odesignUri plugin path
	 * @param dir to generate source
	 * @param classname of main class
	 */
	new(String odesignUri, Path dir, String classname) {
		this(URI.createPlatformPluginURI(odesignUri, true), dir, classname)
	}
	
	/**
	 * Construct a reverse of a Odesign.
	 * 
	 * @param odesignUri to access content
	 * @param dir to generate source
	 * @param classname of main class
	 */
	new(URI odesignUri, Path dir, String classname) {
		this(odesignUri.loadSiriusGroup(new ResourceSetImpl), dir, classname)
	}

	/**
	 * Construct a reverse of a Odesign.
	 * 
	 * @param content to reverse
	 * @param dir to generate source
	 * @param classname of main class
	 */
	new(Group content, Path dir, String classname) {
		
		source = content
		// use provided resourceset or a default one
		rs = content.eResource?.resourceSet ?: new ResourceSetImpl
		classId = new ClassId(classname)
		
		engine = source.eResource.createEngine(classname, dir) => [
			
			// Split RepresentationDescription DiagramExtensionDescription
			splits.putAll(findDefaultSplits)
			 
			// explicitExtras.putAll(usedMetamodels)

			explicitExtras.putAll(source.systemColorsPalette.entries.toInvertedMap[ "color:" + name ])

			shortcuts += DescriptionPackage.eINSTANCE.identifiedElement_Name
		]
	}
	
	protected def findDefaultSplits() {
		(
			source.ownedViewpoints
				.flatMap[ ownedRepresentations + ownedRepresentationExtensions ]
			+ source.extensions
				.filter(ViewExtensionDescription)
		).toInvertedMap[ 
			new ClassId(classId.pack, toClassname)
		]
	}
	
	@Deprecated
	protected def getUsedMetamodels() {		
		// we need a copy as resources list is extended by navigation
		new ArrayList(rs.resources)
			.map[ o | [ o.allContents ] as Iterable<EObject> ].flatten
			.map[ metamodels ].flatten.toSet
			.toInvertedMap[
				// To improve: Sirius stores 2 kinds of Package instances.
				// We must keep both in reverse so they are found in call tree.
				val uri = EcoreUtil.getURI(it)
				if (uri.scheme == "platform" && uri.segments.head == "plugin") 
					"ecore:" + nsURI 
				else "epackage:" + nsURI
			]
	}
	
	@Deprecated
	protected def getMetamodels(Object it) {
		if (it instanceof RepresentationExtensionDescription) metamodel
		else if (it instanceof RepresentationDescription) metamodel
		else Collections.emptyList
	}
	
	protected def aliasViewpoints(String prefix, String groupUri) {
		engine.explicitExtras.putAll(
			URI.createURI(groupUri).loadSiriusGroup(rs)
				.ownedViewpoints.toInvertedMap[ toVpAlias(prefix) ]
		)
	}
	
	protected def toVpAlias(Viewpoint it, String prefix) { "VP:" + prefix + "#" + name }
	
	protected def createEngine(Resource content, String classname, Path dir) {
		new Engine(this, classname, dir, content)
	}
	
	/**
	 * Create the files.
	 */
	def perform() { engine.perform }
	
	protected def toClassname(EObject it) {
		val basename = switch (it) {
			RepresentationDescription: name.camel
			RepresentationExtensionDescription: name.camel
			ViewExtensionDescription: name.camel
		}
		val end = aliasSuffix
		
		basename 
			+ (!basename.toLowerCase.endsWith(end.toLowerCase) // avoid duplicated end
				? end : "")
	}	

	
	protected def getAliasSuffix(EObject it) {
		val className = eClass.name
		className.endsWith("Description") // trim Sirius Object end.
			? className.substring(0, className.length - "Description".length) 
			: className
	}
	
	static def camel(String it) {
		split("\\s+").join("")[ toFirstUpper ]
	}
	
	static def loadSiriusGroup(URI uri, ResourceSet rs) { 
		rs.getResource(uri, true).contents.head as Group
	}
	
	
	// Only used in SiriusModelProvider class.
	static val UNUSED_IMPORTS = #[ HashMap, ResourceSetImpl, Accessors, EModIt, ModitModel ]
	
	/** Override of default reverse for SiriusModelProvider class. */
	protected static class Engine extends EReversIt {
		// XTend does not support statefull inner class
		val SiriusReverseIt container
		
		new(SiriusReverseIt container, String classname, Path dir, Resource res) {
			super(classname, dir, res)
			this.container = container
		}
		
		override getMainStaticImports() {
			super.mainStaticImports.filter[ !UNUSED_IMPORTS.contains(it) ]
			+ #[ SiriusModelProvider, Environment ]
		}
		
		// Xtend
		override templateMain(Iterable<Class<?>> packages, ()=>String content) {
'''package «mainClass.pack»

«templateImports»

class «mainClass.name» extends SiriusModelProvider {

	override initContent(Group it) {
		«content.apply»
	}

« // initExtras must be performed AFTER model exploration
IF !implicitExtras.empty || !explicitExtras.empty
»	override initExtras() {
		super.initExtras
		
		«templateExtras»
	}

«
ENDIF // extras
»
	def context() { this }
	
	«templateShorcuts»
}
'''
		}

		// Xtend
		override templateExplicitExtras() {
			val colors = container.source.systemColorsPalette.entries
			if (explicitExtras.keySet.equals(colors.toSet)) {
				return "" // no named element
			}
'''extras.putAll(#{ // Named elements
«
FOR ext : explicitExtras.entrySet
		// ignore SystemColors as they are already provided in template.
		.filter[ !colors.contains(key) ]
		.toList.sortBy[ value ]
	SEPARATOR ",\n" // cannot include comma in template: improper for last value.
»	«ext.value.toJava» -> «ext.key.templateAlias»«
ENDFOR
»
})
'''
		}
	
		// Xtend
		override templateExplicitAlias(EObject it) {
'''«templateClass».eObject(«toUri.toJava »)'''	
		}
	
		// Xtend
		override templateSimpleContent(EObject it) {
			// As assembling is performed by SiriusModelProvider,
			// use the code from #templateInnerCreate.
'''
«
FOR c : innerContent SEPARATOR statementSeparator 
»«templateProperty(c.key, c.value)»«
ENDFOR
»'''
		}


	
	}
}
