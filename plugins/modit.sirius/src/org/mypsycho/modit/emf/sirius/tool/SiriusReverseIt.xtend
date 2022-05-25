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
import java.util.Collections
import java.util.List
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.sirius.properties.ViewExtensionDescription
import org.eclipse.sirius.viewpoint.description.DescriptionPackage
import org.eclipse.sirius.viewpoint.description.Group
import org.eclipse.sirius.viewpoint.description.RepresentationDescription
import org.eclipse.sirius.viewpoint.description.RepresentationExtensionDescription
import org.eclipse.sirius.viewpoint.description.Viewpoint
import org.eclipse.xtend.lib.annotations.Accessors
import org.mypsycho.modit.emf.ClassId
import org.eclipse.emf.ecore.EClass
import java.util.regex.Pattern

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

	
	protected val ResourceSet rs
	protected val Group source
	protected val ClassId classId
	
	protected val List<EPackage> editedPackages
	
	@Accessors
	val SiriusGroupTemplate engine
	
	/**
	 * Construct a reverse of a Odesign.
	 * 
	 * @param odesignUri plugin path
	 * @param dir to generate source
	 * @param classname of main class
	 * @param editeds edited packages
	 */
	new(String odesignUri, Path dir, String classname, EPackage... editeds) {
		this(URI.createPlatformPluginURI(odesignUri, true), 
			dir, classname, editeds
		)
	}
	
	/**
	 * Construct a reverse of a Odesign.
	 * 
	 * @param odesignUri to access content
	 * @param dir to generate source
	 * @param classname of main class
	 * @param editeds edited packages
	 */
	new(URI odesignUri, Path dir, String classname, EPackage... editeds) {
		this(odesignUri.loadSiriusGroup(new ResourceSetImpl), 
			dir, classname, editeds
		)
	}

	/**
	 * Construct a reverse of a Odesign.
	 * 
	 * @param content to reverse
	 * @param dir to generate source
	 * @param classname of main class
	 * @param editeds edited packages
	 */
	new(Group content, Path dir, String classname, EPackage... editeds) {
		
		source = content
		// use provided resourceset or a default one
		rs = content.eResource?.resourceSet ?: new ResourceSetImpl
		classId = new ClassId(classname)
		
		editedPackages = (editeds + usedMetamodels)
			// Normalize
			.map[ EPackage.Registry.INSTANCE.getEPackage(nsURI) ]
			.flatMap[ #[ it ] + eAllContents.toIterable.filter(EPackage) ]
			.toSet
			.toList
			.sortBy[ nsURI ]
		
		engine = source.eResource.createEngine(classname, dir) => [
			
			// Split RepresentationDescription DiagramExtensionDescription
			splits.putAll(findDefaultSplits)
				
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
		).toInvertedMap[ toClassId ]
	}
	
	
	
	protected def getUsedMetamodels() {		
		// we need a copy as resources list is extended by navigation
		source.eAllContents
			.toIterable
			.flatMap[ metamodels ]
			.toSet
//			.toInvertedMap[
//				// To improve: Sirius stores 2 kinds of Package instances.
//				// We must keep both in reverse so they are found in call tree.
//				val uri = EcoreUtil.getURI(it)
//				if (uri.scheme == "platform" && uri.segments.head == "plugin") 
//					"ecore:" + nsURI 
//				else "epackage:" + nsURI
//			]
	}
	
	protected static def getMetamodels(EObject it) {
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
		new SiriusGroupTemplate(this, classname, dir, content)
	}
	
	/**
	 * Create the files.
	 */
	def perform() { engine.perform }
	
	protected def toClassId(EObject it) {
		new ClassId(classId.pack, toClassname)
	}
	
	
	protected def toClassname(EObject it) {
		val basename = switch (it) {
			RepresentationDescription: name.techName
			RepresentationExtensionDescription: name.techName
			ViewExtensionDescription: name.techName
		}
		val end = aliasSuffix
		// avoid duplicated end
		val applySuffix = !basename.toLowerCase.endsWith(end.toLowerCase)
		basename + (applySuffix ? end : "")
	}	

	def getClassFromDomain(String domain) {
		if (domain === null || domain.empty)
			return null
		
		
		var sep = '::'
		var qIndex = domain.indexOf(sep)
		
		if (qIndex == -1) {
			sep = '.'
			qIndex = domain.indexOf('.')	
		}
		
		val classname = 
			qIndex == -1
				? domain
				: domain.substring(qIndex + sep.length, domain.length)
		
		val packages =
			(qIndex == -1)
				? editedPackages
				: {
					val qName = domain.substring(0, qIndex)
					editedPackages
						.filter[ name == qName ]
				}
		
		packages
			.map[ getEClassifier(classname) ]
			.filter(EClass)
			.map[ instanceClass ]
			.head
	}
	
	protected def getAliasSuffix(EObject it) {
		val className = eClass.name
		className.endsWith("Description") // trim Sirius Object end.
			? className.substring(0, className.length - "Description".length) 
			: className
	}
	
	static val NO_TECH = Pattern.compile("[^a-zA-Z0-9 _]")
	static def techName(String it) {
		NO_TECH.matcher(it)
			.replaceAll("_")
			.split("\\s+")
			.join("")[ toFirstUpper ]
	}
	
	static def loadSiriusGroup(URI uri, ResourceSet rs) { 
		rs.getResource(uri, true).contents.head as Group
	}
	
	def static boolean isContaining(EObject it, EObject value) {
		value !== null && (it == value || isContaining(value.eContainer))
	}
	
}
