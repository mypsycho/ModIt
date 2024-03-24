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

import java.util.List
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.sirius.diagram.description.ContainerMapping
import org.eclipse.sirius.diagram.description.DiagramDescription
import org.eclipse.sirius.diagram.description.EdgeMapping
import org.eclipse.sirius.diagram.description.Layer
import org.eclipse.sirius.diagram.description.NodeMapping
import org.eclipse.sirius.diagram.description.filter.CompositeFilterDescription
import org.eclipse.sirius.diagram.description.filter.MappingFilter
import org.eclipse.sirius.diagram.description.tool.ContainerDropDescription
import org.eclipse.sirius.diagram.description.tool.ToolGroup
import org.eclipse.sirius.diagram.description.tool.ToolSection
import org.eclipse.sirius.viewpoint.description.Customization
import org.eclipse.sirius.viewpoint.description.DocumentedElement
import org.eclipse.sirius.viewpoint.description.IVSMElementCustomization
import org.eclipse.sirius.viewpoint.description.IdentifiedElement
import org.eclipse.sirius.viewpoint.description.VSMElementCustomization

import static extension org.mypsycho.modit.emf.sirius.api.SiriusDesigns.*

/**
 * Abstract class to create diagram duplicating an existing one.
 */
abstract class DerivedDiagram extends SiriusDiagram {
	
	protected val DiagramDescription origin
	new(SiriusVpGroup parent, String dName, String dLabel, String extraId) {
		this(parent, dName, dLabel, 
			parent.extraRef(DiagramDescription, extraId)
		)
	}
	new(SiriusVpGroup parent, String dName, String dLabel, DiagramDescription dOrigin) {
		super(parent, dName, dLabel, null)
		origin = dOrigin
	}


	/** Copy all but name and domain. */
	static def void copyAll(DiagramDescription it, DiagramDescription source) {
		val copy = EcoreUtil.copy(source)
		
		// representation
		domainClass = copy.domainClass
		preconditionExpression = copy.preconditionExpression
		init = copy.init
		initialisation = copy.initialisation
		showOnStartup = copy.showOnStartup
		documentation = copy.documentation
		endUserDocumentation = copy.endUserDocumentation
		// metamodel ?

		// diagram
		filters += copy.filters
		validationSet = copy.validationSet
		concerns = copy.concerns
		defaultConcern = copy.defaultConcern
		defaultLayer = copy.defaultLayer
		additionalLayers += copy.additionalLayers
		nodeMappings += copy.nodeMappings
		containerMappings += copy.containerMappings
		edgeMappings += copy.edgeMappings
		edgeMappingImports += copy.edgeMappingImports
		reusedMappings += copy.reusedMappings
		toolSection = copy.toolSection
		reusedTools += copy.reusedTools
		enablePopupBars = copy.enablePopupBars
		backgroundColor = copy.backgroundColor
		
		// dndTarget, pasteTarget
		dropDescriptions += copy.dropDescriptions
		pasteDescriptions += copy.pasteDescriptions
		
	}

	final override initContent(Layer it) {} // unused
	final override initContent(DiagramDescription it) {
		copyAll(origin)
		overrideContent
	}
	def void overrideContent(DiagramDescription it)
	
	
	// Substitute Dispatch 
	def void substitute(EObject it, NodeMapping oldIt, ContainerMapping newIt) {
		switch(it) {
			CompositeFilterDescription: filters.substituteAll(oldIt, newIt)
			MappingFilter: mappings.replaceRefs(oldIt, newIt)
			Customization: newIt.onAssembled[ node |
				// newIt must be populated 
				vsmElementCustomizations.forEach[ substituteStyle(oldIt, newIt) ]
			]
			EdgeMapping: {
				sourceMapping.replaceRefs(oldIt, newIt)
				targetMapping.replaceRefs(oldIt, newIt)
			}
			ToolSection: ownedTools.substituteAll(oldIt, newIt)
				// Maybe others ... (Popup, Subsection)
			ToolGroup: tools.substituteAll(oldIt, newIt)
			ContainerDropDescription: mappings.replaceRefs(oldIt, newIt)
			default: {}
		}
	}
	
	static def void substituteStyle(IVSMElementCustomization it, NodeMapping oldIt, ContainerMapping newIt) {
		if (it instanceof VSMElementCustomization) {
			featureCustomizations.forEach[
				if (appliedOn.replaceRefs(oldIt.style, newIt.style)) {
					appliedOn -= oldIt.conditionnalStyles.map[ style ].toList
					appliedOn += newIt.conditionnalStyles.map[ style ].toList
				}
			]
		}
	}
	
	// Mass update
	def <T extends EObject> substituteAll(Iterable<T> references, NodeMapping oldIt, ContainerMapping newIt) {
		references.forEach[
			substitute(oldIt, newIt)
		]
	}
	
	static def <T extends EObject> replaceRefs(List<T> references, T oldIt, T newIt) {
		val index = references.indexOf(oldIt)
		
		if (index != -1) {
			references -= oldIt as T
			references.add(index, newIt as T)
			true
		} else false
	}
	
	static def <T extends IdentifiedElement> replaceByName(List<T> references, String name, (String)=>T factory) {
		val oldIt = references.atNamed(name)
		val T newIt = factory.apply(name)
		if (oldIt instanceof DocumentedElement) if (newIt instanceof DocumentedElement) {
			// Before application of properties.
			newIt.documentation = oldIt.documentation
		}
		
		references.replaceRefs(oldIt, newIt)
		newIt
	}


}
