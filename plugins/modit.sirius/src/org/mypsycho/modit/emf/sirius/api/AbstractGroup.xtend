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
package org.mypsycho.modit.emf.sirius.api

import java.util.ArrayList
import java.util.Collection
import java.util.List
import org.eclipse.emf.ecore.EClassifier
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EPackage
import org.eclipse.sirius.viewpoint.description.Environment
import org.eclipse.sirius.viewpoint.description.JavaExtension
import org.eclipse.sirius.viewpoint.description.UserFixedColor
import org.eclipse.sirius.viewpoint.description.Viewpoint
import org.mypsycho.modit.emf.sirius.SiriusModelProvider

/**
 * Class regrouping a common adaptation of Sirius into Java and EClass reflection for group.
 * 
 * @author nicolas.peransin
 */
abstract class AbstractGroup extends SiriusModelProvider {
	
	/** Packages used in design */
	protected val List<EPackage> businessPackages = new ArrayList
	protected var boolean enableRtExpression = false
	
	/**
	 * Construction of model using provided packages.
	 * 
	 * @param descriptorPackages used by Sirius
	 */
	new(Iterable<? extends EPackage> descriptorPackages) {
		super(descriptorPackages)
	}
		
	/**
	 * Construction of model using provided package.
	 * 
	 * @param descriptorPackages used by Sirius
	 */
	new(EPackage... descriptorPackages) {
		this(descriptorPackages as Iterable<EPackage>)
	}
	
	/**
	 * Construction of model using default Sirius package.
	 */
	new() { /* required by other constructor existence */ }
	
	var String iplExpression
	def getItemProviderLabel() {
		if (enableRtExpression && iplExpression === null) {
			iplExpression = expression[ EObject it | 
				SiriusDesigns.getItemProvider(it).getText(it)
			]
		}
		iplExpression
	}
	
	override initExtras() {
		super.initExtras()
		
		val siriusStyles = Environment.eObject("environment:/viewpoint#/")
            .labelBorderStyles
            
		// ** List border style
		// Border 0 : labelBorderStyleWithBeveledCorner = Label Border Style With Beveled Corner
		// Border 1 : labelBorderForContainer = Label Border For Container
		// Border 2 : nolabelBorderForList = No Label Border For List
		
		// println("** List border style")
		// val count = new AtomicInteger
        siriusStyles.labelBorderStyleDescriptions
            .forEach[ 
            	// println('''Border «count.andIncrement» : «id» = «name»''')
            	extras.put("labelBorder:" + id, it)
            ]
	}
	
	
	/**
	 * Returns packages used in the design.
	 * 
	 * @returns the registered packages
	 */
	def Collection<? extends EPackage> getBusinessPackages() {
		businessPackages
	}
	
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
	
	/**
	 * Provides text used for domainClass properties from java Class.
	 * 
	 * @param type to encode
	 * @return encoded typee
	 */
	def String asDomainClass(Class<? extends EObject> it) {
		SiriusDesigns.encode(asEClass)
	}

	
	/**
	 * Provides text used for domainClass properties from java Class.
	 * 
	 * @param type to encode
	 * @return encoded typee
	 */
	def EClassifier asEClass(Class<? extends EObject> type) {
		val result = businessPackages
			.flatMap[ EClassifiers ]
			.findFirst[ instanceClass == type ]
		if (result === null) {
			throw new UnsupportedOperationException(
			'''EClass of «type» is not defined in packages [«businessPackages
				.join(',')[ name ]»]''')
		}
		result
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
		if (!context.anonymousClass) context.simpleName
		else {
			var fullname = context.name
			fullname.substring(
				fullname.lastIndexOf(".") + 1, 
				fullname.lastIndexOf("$")
			)
		}
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
	protected def String createId(String category, String context, String path) {
		'''«category»:«context».«path.toFirstLower.replace(" ", "_")»'''
	}
	
}