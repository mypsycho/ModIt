/*******************************************************************************
 * Copyright (c) 2023 Nicolas PERANSIN.
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
import java.util.Map
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.sirius.diagram.description.AbstractNodeMapping
import org.eclipse.sirius.diagram.description.DiagramDescription
import org.eclipse.sirius.diagram.description.EdgeMapping
import org.eclipse.sirius.properties.ViewExtensionDescription
import org.eclipse.sirius.viewpoint.description.Group
import org.eclipse.sirius.viewpoint.description.IdentifiedElement
import org.eclipse.sirius.viewpoint.description.RepresentationDescription
import org.eclipse.sirius.viewpoint.description.UserColor
import org.eclipse.sirius.viewpoint.description.tool.AbstractToolDescription
import org.eclipse.sirius.viewpoint.description.tool.ExternalJavaAction
import java.util.Collections
import java.util.Iterator

/**
 * Convenient methods and constants to handle dependencies between Sirius designs.
 *
 * @author nperansin
 */
class SiriusDependencies {
	
	/**
	 * Returns the colors of a group.
	 * <p>
	 * To prevent name conflict, applicable only for single palette.
	 * </p>
	 * 
	 * @param it to get colors from
	 * @return User colors
	 */
	static def getPaletteColors(Group it) {
		if (userColorsPalettes.size == 1) {
			// Protection against evolution
			userColorsPalettes.head.entries
		} else #[]
	}
	
	/**
	 * Provides a contextual alias for provided element.
	 * <p>
	 * Based on name and type, conflicts may arise.
	 * </p>
	 * 
	 * @param it to identify
	 * @param aliasBase context identification
	 * @return readable identification
	 */
	static def String getExtraAlias(EObject it, String aliasBase, (EObject)=>String toClassname) {
		switch(it) {
			UserColor: '''color:«aliasBase»«name»'''
			AbstractToolDescription: '''tool:«aliasBase»«name»'''
			AbstractNodeMapping: 
				if (eContainer instanceof AbstractNodeMapping)
					'''«eContainer.getExtraAlias(aliasBase, toClassname)»/«name»'''
				else
					'''node:«aliasBase»«name»'''
			EdgeMapping: '''edge:«aliasBase»«name»'''
			
			RepresentationDescription: aliasBase + toClassname.apply(it)
			ViewExtensionDescription: aliasBase + toClassname.apply(it)
			
		}
	}
	
	static val EXTRA_TYPES = #[ 
		AbstractToolDescription, 
		AbstractNodeMapping,
		EdgeMapping
	]
	
	static def getDependencyContent(ResourceSet rs, String resourcePath) {
		rs.getResource(URI.createPlatformPluginURI(resourcePath, false), true)
			.contents.head as Group
	}
	

	static def getDependencyExtras(RepresentationDescription it) {
		eAllContents
			.filter(IdentifiedElement)
			.filter[ !ExternalJavaAction.isInstance(it) ]
			.filter[ ide |
				EXTRA_TYPES.exists[ isInstance(ide) ]
			]
	}

	static def getDependencyExtras(String designId, 
		ResourceSet rs, String resourcePath
	) {
		designId.getDependencyExtras(rs, resourcePath, [ SiriusDesigns.toClassname(it) ])
	}
	
	static def getDependencyExtras(String designId, 
		ResourceSet rs, String resourcePath, (EObject)=>String toClassname
	) {
		val vpGroup = rs.getDependencyContent(resourcePath)
		
		val aliasBase = designId + "§"
		vpGroup.mapDependencyExtras(aliasBase, toClassname)
	}
	
	static def dispatch Map<EObject, String> mapDependencyExtras(EObject it,
		String aliasBase, (EObject)=>String toClassname
	) {
		Collections.emptyMap
	}

	static def dispatch Map<EObject, String> mapDependencyExtras(IdentifiedElement it,
		String aliasBase, (EObject)=>String toClassname
	) {
		#{ it -> getExtraAlias(aliasBase, toClassname) }
	}

	static def dispatch Map<EObject, String> mapDependencyExtras(DiagramDescription it,
		String aliasBase, (EObject)=>String toClassname
	) {
		val result = new HashMap<EObject, String>
	
		result += #{ it as EObject -> getExtraAlias(aliasBase, toClassname) }
		
		val representationAlias = aliasBase + toClassname.apply(it) + "#"
		result += dependencyExtras.toDependencyExtras(representationAlias, toClassname)
			
		result
	}

	static def dispatch Map<EObject, String> mapDependencyExtras(Group it,
		String aliasBase, (EObject)=>String toClassname
	) {
		val result = new HashMap<EObject, String>
		result += it -> aliasBase
		ownedViewpoints
			.flatMap[ ownedRepresentations + ownedRepresentationExtensions ]
			.forEach [ result += mapDependencyExtras(aliasBase, toClassname) ]

		ownedViewpoints
			.filter(ViewExtensionDescription)
			.forEach [ result += mapDependencyExtras(aliasBase, toClassname) ]
		
		result += paletteColors.iterator().toDependencyExtras(aliasBase, toClassname)
		
		result
	}
	
	static def toDependencyExtras(Iterator<? extends EObject> values,
		String aliasBase, (EObject)=>String toClassname
	) {
		values.toInvertedMap[ getExtraAlias(aliasBase, toClassname) ]
	}
	
}