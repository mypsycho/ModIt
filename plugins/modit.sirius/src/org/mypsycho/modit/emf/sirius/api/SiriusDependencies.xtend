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
	static def String getExtraAlias(EObject it, String aliasBase) {
		switch(it) {
			UserColor: '''color:«aliasBase»«name»'''
			AbstractToolDescription: '''tool:«aliasBase»«name»'''
			AbstractNodeMapping: 
				if (eContainer instanceof AbstractNodeMapping)
					'''«eContainer.getExtraAlias(aliasBase)»/«name»'''
				else
					'''node:«aliasBase»«name»'''
			EdgeMapping: '''edge:«aliasBase»«name»'''
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
		val Map<EObject, String> result = new HashMap
		val vpGroup = rs.getDependencyContent(resourcePath)
		
		val aliasBase = designId + "§"
		result += vpGroup -> aliasBase
		result += (
			vpGroup.ownedViewpoints.flatMap[ 
				ownedRepresentations + ownedRepresentationExtensions
			]
				+ vpGroup.extensions.filter(ViewExtensionDescription)
		).toInvertedMap[ aliasBase + toClassname.apply(it) ]
						

		val colors = vpGroup
			.paletteColors
			.toInvertedMap[ getExtraAlias(aliasBase) ]	
		result += colors
		
		vpGroup.ownedViewpoints
			.flatMap[ ownedRepresentations ]
			.filter(DiagramDescription)
			.forEach[
				val representationAlias = aliasBase + toClassname.apply(it) + "#"
				val identifiables = dependencyExtras
					.toInvertedMap[ getExtraAlias(representationAlias) ]
				result += identifiables
			]

		result
	}
}