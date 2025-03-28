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

import java.util.regex.Pattern
import org.eclipse.emf.common.util.EList
import org.eclipse.emf.common.util.Enumerator
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EClassifier
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.emf.ecore.util.EcoreEList
import org.eclipse.emf.edit.provider.IItemLabelProvider
import org.eclipse.sirius.diagram.ui.provider.DiagramUIPlugin
import org.eclipse.sirius.properties.ViewExtensionDescription
import org.eclipse.sirius.viewpoint.description.DocumentedElement
import org.eclipse.sirius.viewpoint.description.IdentifiedElement
import org.eclipse.sirius.viewpoint.description.RepresentationDescription
import org.eclipse.sirius.viewpoint.description.RepresentationExtensionDescription
import org.mypsycho.modit.emf.sirius.SiriusConstantInterpreter

/**
 * Convenient methods and constants for Sirius design creation.
 *
 * @author nperansin
 */
class SiriusDesigns {

	public static val AQL = "aql:"
	
	/** Expression for return semantic container */
	public static val IDENTITY = "var:self"

	public static val PROP_VALUE = "var:newValue"

	/** Value return by field edit */
	public static val EDIT_VALUE = "arg0"

	/** Value return by field edit */
	public static val EDIT_VAR = "var:" + EDIT_VALUE

	/** Expression for return semantic container */
	public static val ALWAYS = AQL + "true"

	/** Expression for return semantic container */
	public static val NEVER = AQL + "false"

	public static val ANY_TYPE = "EObject" 
	// Constant used in:
	//   org.eclipse.sirius.ecore.extender.business.internal.accessor.ecore.EcoreIntrinsicExtender
	//   #eInstanceOf

	/**
	 * Creates a constant of the value.
	 * <p>
	 * This expression cannot be mistaken for dynamic expression.
	 * </p>
	 * @param value
	 * @return expression
	 */
	static def constant(String value) {
		SiriusConstantInterpreter.toExpression(value)
	}
	
	/**
	 * Returns the default item provider of an element
	 * 
	 * @param it to adapt
	 * @return item provider
	 */
	static def getItemProvider(EObject it) {
		DiagramUIPlugin.plugin.itemProvidersAdapterFactory
			.adapt(it, IItemLabelProvider) as IItemLabelProvider
	}
	
	/**
	 * Convert a classifier to be used in descriptor (domainClass).
	 * 
	 * @param it to convert
	 * @return associated text
	 */
	static def String encode(EClassifier it) {
		asAql
	}
	
	   
    /**
     * Converts a classifier to be used in aql expression.
     * 
     * @param it to convert
     * @return associated text
     */
    static def String asAql(EClassifier it) {
        '''«EPackage.name»::«name»'''
    }
    
           
    /**
     * Converts a feature to be used in aql expression.
     * 
     * @param it to convert
     * @return associated text
     */
    static def String asAql(EStructuralFeature it) {
        '''«EContainingClass.asAql».getEStructuralFeature('«name»')'''
    }
    
    /** Converts a enum item  */
    static def String asAql(Enumerator it) {
    	val path = class.package.name
    	val packageClass = path + '.'
    		+ path.substring(path.lastIndexOf('.') + 1, path.length).toFirstUpper
    		+ "Package"
    	val ePackName = class.classLoader
    		.loadClass(packageClass)
    		.getDeclaredField('eNAME')
    	
    	'''«ePackName.get(null)»::«class.simpleName»::«name»'''
    }
	
		
	/**
	 * Converts a feature to be used in descriptor (full expression).
	 * 
	 * @param it to convert
	 * @return associated text
	 */
	static def String encode(EReference it) {
		name.asFeature
	}
	
	/**
	 * Provides an expression for a feature.
	 * 
	 * @param featname to convert
	 * @return associated text
	 */
	static def String asFeature(String featname) {
		'''feature:«featname»'''
	}
	
	/**
	 * Removes all return carriages from an expression.
	 * <p>
	 * Odesign editor fails to handle multi-line in expression.
	 * </p>
	 * @param text to trim
	 * @param text but '\n' is 'space'
	 */
	static def String trimAql(CharSequence text) {
		val result = text.toString.trim.replaceAll("\\s*\\R\\s*", " ") // 
		if (result.startsWith(AQL)) result else AQL + result
	}

	/**
	 * Finds a value in a reference based on reference key.
	 * 
	 * @param values of reference
	 * @param type expected
	 * @param keys of element
	 * @return found element or null
	 * @throws ClassCastException if not a reference list
	 * @throws IllegalArgumentException if number of key is not matching
	 */
	// Only works for feature with keys
	// Ambiguous
	static def <R extends EObject> R at(EList<?> values, Class<R> type, Object... keys) {
		val attKeys = ((values as EcoreEList<?>).feature as EReference).EKeys
		val keyValues = keys.toList
		
		if (keyValues.size != attKeys.size) {
			throw new IllegalArgumentException("Wrong args size: " 
				+ keyValues.size + " instead of " + attKeys.size
			)	
		}
		values
			.filter(type)
			.findFirst[ r| attKeys.map[ r.eGet(it) ] == keyValues ]
	}
	
	
	/**
	 * Finds a value in a reference based on reference key.
	 * 
	 * @param values of reference
	 * @param keys of element
	 * @return found element or null
	 * @throws ClassCastException if not a reference list
	 * @throws IllegalArgumentException if number of key is not matching
	 */
	static def <R extends EObject> R at(EList<R> values, Object... keys) {
		values.at(EObject, keys) as R
	}
	
	/**
	 * Finds a identified element in list based on it name.
	 * 
	 * @param values of reference
	 * @param keys of element
	 * @return found element or null
	 */
	static def <T extends IdentifiedElement> atNamed(Iterable<T> values, String key) {
		values.findFirst[ name == key ]
	}
	
	/**
	 * Finds a identified element in list based on it name.
	 * 
	 * @param values of reference
	 * @param keys of element
	 * @return found element or null
	 */
	static def <T extends IdentifiedElement, R extends T> T atNamed(Iterable<T> values, Class<R> expectedType, String key) {
		values.filter(expectedType).findFirst[ name == key ]
	}
		
	/**
	 * !!! Why is not in EcoreUtil already? Every project uses it. :'(
	 */
	static def <T> T eContainer(EObject it, Class<T> type) {
		var result = eContainer
		while(result !== null && !type.isInstance(result)) {
			result = result.eContainer
		}
		result as T
	}
	
	/** Evaluates if a value is contained by it. */
	static def isContaining(EObject it, EObject value) {
		for(var current = value; 
			current !== null; 
			current = current.eContainer
		) {
			if (it == current) {
				return true
			}
		}
		false
	}
	
	/** Aql request to evaluate if selected target all matches a type. */
	static def final allTargetViews(EClassifier eclass) {
		// Usefull for OperationAction
		'''
		views.target
			->select(it | not it.oclIsKindOf(«eclass.asAql»))
			->isEmpty()
		'''.trimAql
	} 
	
	/** Unsupported characters for Java name. */
	static val NO_TECH = Pattern.compile("[^a-zA-Z0-9 _]")
	
	/** Gets a name compatible with Java name. */
	static def techName(String it) {
		NO_TECH.matcher(it)
			.replaceAll("_")
			.split("\\s+")
			.join("")[ toFirstUpper ]
	}
	
	/** Removes "Description" from a class name. */
	static def trimDescriptionSuffix(EClass it) {
		name.endsWith("Description") // trim Sirius Object end.
			? name.substring(0, name.length - "Description".length) 
			: name
	}
	
	/** Adds a suffix based on the element type. */
	static def hungarianSuffix(String basename, EObject it) {
		// Suffix description is redundant when everything is a description.
		val end = eClass.trimDescriptionSuffix
		// avoid duplicated end
		val applySuffix = !basename.toLowerCase.endsWith(end.toLowerCase)
		// Add a suffix based on type if needed.
		basename + (applySuffix ? end : "")
	}
	
	/** Converts an object in to class name. */
	static def toClassname(EObject it) {
		val basename = switch (it) {
			RepresentationDescription: name.techName
			RepresentationExtensionDescription: name.techName
			ViewExtensionDescription: name.techName
		}
		basename.hungarianSuffix(it)
	}
	
	/** Initializes label and documentation based on a Plugin Property key. */
	static def void setI18n(IdentifiedElement it, String key) {
		label = "%" + key
		if (it instanceof DocumentedElement) {
			documentation = label + "?ttip"	
		}
	}

	
	/** Initializes label and documentation based on a Plugin Property key. */
	static def void setI18n(IdentifiedElement it) {
		i18n = name
	}
	
	static def String encodeVpUri(String pluginId, String vpName) {
		'''viewpoint:/«pluginId»/«vpName»'''
	}	
	
	
}