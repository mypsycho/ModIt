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
package org.mypsycho.modit.emf.sirius.api

import java.util.ArrayList
import java.util.Collection
import java.util.List
import org.eclipse.emf.ecore.EClassifier
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EPackage
import org.eclipse.sirius.diagram.DiagramPackage
import org.eclipse.sirius.properties.PropertiesPackage
import org.eclipse.sirius.table.metamodel.table.TablePackage
import org.eclipse.sirius.viewpoint.ViewpointPackage
import org.eclipse.sirius.viewpoint.description.Group
import org.eclipse.sirius.viewpoint.description.IdentifiedElement
import org.eclipse.sirius.viewpoint.description.JavaExtension
import org.eclipse.sirius.viewpoint.description.RepresentationDescription
import org.eclipse.sirius.viewpoint.description.RepresentationExtensionDescription
import org.eclipse.sirius.viewpoint.description.UserColor
import org.eclipse.sirius.viewpoint.description.UserColorsPalette
import org.eclipse.sirius.viewpoint.description.UserFixedColor
import org.eclipse.sirius.viewpoint.description.Viewpoint
import org.mypsycho.modit.emf.sirius.SiriusModelProvider

/**
 * Class regrouping a common adaptation of Sirius into Java and EClass reflection for group.
 * 
 * @author nicolas.peransin
 */
abstract class SiriusVpGroup extends SiriusModelProvider {
	
	/** Packages used in design */
	protected val List<EPackage> businessPackages = new ArrayList
	protected var boolean enableRtExpression = false
	
	static val BUILT_IN_PACKAGES = #[
		ViewpointPackage.eINSTANCE,
		DiagramPackage.eINSTANCE,
		TablePackage.eINSTANCE,
		PropertiesPackage.eINSTANCE
	]
	
	/**
	 * Construction of model using provided packages.
	 * 
	 * @param editPackages used by expression
	 * @param vpPackages used by ModitModel
	 */
	new(Iterable<? extends EPackage> editPackages, Iterable<? extends EPackage> vpPackages) {
		super(vpPackages)
		businessPackages += editPackages
	}
		
	
	/** Construction of model using default Sirius package. */
	new(Iterable<? extends EPackage> editPackages) {
		this(editPackages, DEFAULT_PACKAGES)
	}
	
	/**
	 * Construction of model using default Sirius package.
	 * <p>For compatibility.</p>
	 */
	@Deprecated
	new() { this(List.of) }
	
	var String iplExpression = "feature:name" // built-in default
	def getItemProviderLabel() {
		if (enableRtExpression && iplExpression === null) {
			iplExpression = expression[ EObject it | 
				SiriusDesigns.getItemProvider(it).getText(it)
			]
		}
		iplExpression
	}
	
	/**
	 * Returns packages used in the design.
	 * 
	 * @returns the registered packages
	 */
	def Collection<? extends EPackage> getBusinessPackages() { businessPackages }
	
	/**
	 * Provides text used for domainClass properties from java Class.
	 * 
	 * @param type to encode
	 * @return encoded typee
	 */
	def String asDomainClass(Class<? extends EObject> it) {
		if (it !== null) SiriusDesigns.encode(asEClass)
	}

	
	/**
	 * Provides text used for domainClass properties from java Class.
	 * 
	 * @param type to encode
	 * @return encoded typee
	 */
	def EClassifier asEClass(Class<? extends EObject> type) {
		val result = (businessPackages + BUILT_IN_PACKAGES)
			.flatMap[ EClassifiers ]
			.findFirst[ instanceClass == type ]
		
		if (result === null) {
			val names = (businessPackages + BUILT_IN_PACKAGES)
				.join(',')[ name ]
			'''EClass of «type» is not defined in packages [«names»]'''.verify(false)
		}
		result
	}
	

	//
	// Identification
	// 
	
	/**
	 * Creates an alias for provided class.
	 * <p>
	 * By default, based on name.
	 * </p>
	 * <p>
	 * Alias should be unique, even for inner class. It is up to user to avoid namesake class.
	 * </p>
	 * @param context to identify
	 * @return identification 
	 */
	def getContentAlias(Class<?> context) {
		if (!context.anonymousClass) {
			return context.simpleName
		}

		var fullname = context.name
		fullname.substring(
			fullname.lastIndexOf(".") + 1, 
			fullname.lastIndexOf("$")
		)
	}
	
		
	/**
	 * Builds an identification with provided category for local element.
	 * <p>
	 * This method has no side-effect, no id should be reserved.
	 * </p>
	 * <p>
	 * Not deprecated by you should consider 'createAs' or 'ref' method.
	 * </p>
	 * 
	 * @param category of identification
	 * @param context of element
	 * @param path of element
	 */
	protected def String createId(String category, String context, String path)
		'''«category»:«context».«path.toFirstLower.replace(" ", "_")»'''
	
	
	/**
	 * Returns the element with provided name.
	 * 
	 * @param values to get from
	 * @param key name of the element
	 * @return found element
	 */
	static def <T extends IdentifiedElement> atIdentifiedElement(Iterable<T> values, Object key) {
		SiriusDesigns.atNamed(values, key as String)
	}
	
	// 
	// API
	//
	
	/**
	 * Creates a fixed color.
	 * 
	 * @param colorName used to be referenced as 'color:&lt;colorName>'
	 * @param r red from 0..255
	 * @param g green from 0..255
	 * @param b blue from 0..255
	 * @return UserFixedColor
	 */
	def color(String colorname, int r, int g, int b) {
		UserFixedColor.createAs("color:" + colorname)[
			name = colorname
			red = r
			green = g
			blue = b
		]
	}
	
	/** Creates a user colors palette. */
	def colorsPalette(Group owner, String paletteName, UserColor... values) {
		UserColorsPalette.create [
			name = paletteName
			entries += values
		] => [ owner.userColorsPalettes += it ]
	}
	
	/** Creates a user colors palette. */
	def viewpoint(Group owner, String vpName, (Viewpoint)=>void init) {
		Viewpoint.create [
			name = vpName
			init.apply(it)
		] => [ owner.ownedViewpoints += it ]
	}
	

	/**
	 * Registers service classes.
	 * 
	 * @param vp viewpoint
	 * @param services to register
	 */
	def void use(Viewpoint vp, Class<?>... services) {
		services.forEach[ vp.use(it) ]
	}
	
	/**
	 * Registers service class.
	 * 
	 * @param vp viewpoint
	 * @param service to register
	 */
	def void use(Viewpoint it, Class<?> service) {
		// method name is a tribute to ADA
		ownedJavaExtensions += JavaExtension.create[ qualifiedClassName = service.name ]
	}
	
	def owned(Viewpoint owner, Class<? extends AbstractTypedEdition<?>> descr) {
		val part = descr.constructors.head.newInstance(this) as AbstractTypedEdition<?>
		part.createContent => [
			switch(it) {
				RepresentationExtensionDescription: owner.ownedRepresentationExtensions += it
				RepresentationDescription: owner.ownedRepresentations += it
			}	
		]		
	}
	
	def properties(Group owner, Class<? extends AbstractPropertySet> descr) {
		val part = descr.constructors.head.newInstance(this) as AbstractPropertySet
		part.createContent => [ owner.extensions += it ]
	}
}