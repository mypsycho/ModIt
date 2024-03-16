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

import java.util.HashMap
import java.util.HashSet
import java.util.Map
import java.util.Set
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EStructuralFeature

/**
 * Groups the Eclasses concerned by keys of features->id.
 * 
 * @author nperansin
 */
class FeaturePaging<T> {
	
	val T defaultGroup
	val Map<?extends EStructuralFeature, T> featureGroups
	val Map<T, Set<EClass>> groupClasses = new HashMap
	
	/**
	 * Default constructor.
	 * <p>
	 * The map is analyzed at construction: it must be complete.
	 * </p>
	 */
	new(T byDefault, Map<?extends EStructuralFeature, T> featGroups) {
		featureGroups = featGroups
		defaultGroup = byDefault
		
		featureGroups.forEach[ feat, group | 
			val type = feat.containerClass
			val set = groupClasses.computeIfAbsent(group) [ new HashSet ]
			if (!set.exists[ instanceClass.isAssignableFrom(type) ]) {
				// remove sub-types
				set.removeIf[ type.isAssignableFrom(instanceClass) ]
				set += feat.EContainingClass;
			}
		]
	}

			
	def boolean isApplicable(EObject value, Object pageId) {
		val classes = groupClasses.get(pageId)
		if (classes === null) pageId === defaultGroup
		else classes.exists[ isInstance(value) ]
	}
			
	def isApplicable(EObject value, EStructuralFeature feature, Object pageId) {
		featureGroups.getOrDefault(feature, defaultGroup) == pageId
	}
	

}