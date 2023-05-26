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

import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.sirius.diagram.description.DiagramDescription
import org.eclipse.sirius.diagram.description.DiagramExtensionDescription
import org.eclipse.sirius.viewpoint.description.Group
import org.eclipse.sirius.viewpoint.description.RepresentationDescription
import org.eclipse.sirius.viewpoint.description.Viewpoint

import static extension org.mypsycho.modit.emf.sirius.api.SiriusDesigns.*
import java.util.Objects

/**
 * Adaptation of Sirius model into Java and EClass reflections API for Diagrams.
 * 
 * @author nicolas.peransin
 */
abstract class AbstractDiagramExtension extends AbstractDiagramPart<DiagramExtensionDescription> {
	
	protected var DiagramDescription extended

	/**
	 * Creates a factory for a diagram extension.
	 * 
	 * @param parent context of extension
	 */
	new(AbstractGroup parent) {
		this(parent, null as DiagramDescription)
	}
	
	/**
	 * Creates a factory for a diagram description
	 * 
	 * @param parent context of extension
	 * @param extendedId id of diagram (must be in extra)
	 */
	new(AbstractGroup parent, String extendedId) {
		this(parent, 
			Objects.requireNonNull(parent.extraRef(DiagramDescription, extendedId))
		)
	}
	
	/**
	 * Creates a factory for a diagram description
	 * 
	 * @param parent context of extension
	 * @param extended diagram (may be null)
	 */
	new(AbstractGroup parent, DiagramDescription extended) {
		super(DiagramExtensionDescription, parent)
		this.extended = extended
		creationTasks.add[
			if (extended !== null) {
				representationName = extended.name
				viewpointURI = extended.vpUri
				metamodel += extended.metamodel
			}
		]
	}
	
	def getVpUri(RepresentationDescription it) {
		eContainer(Group) == context.getContent() // local representation
			? context.pluginId.encodeVpUri(eContainer(Viewpoint).name)
			: extraVpUri
	}

	def static getExtraVpUri(RepresentationDescription it) {
		(eContainer as Viewpoint).extraVpUri
	}

	def static getExtraVpUri(Viewpoint it) {
		val extendedUri = EcoreUtil.getURI(it)
		'''Not plugin reference: «extendedUri»'''.verify(extendedUri.isPlatformPlugin)
		extendedUri.segment(1).encodeVpUri(name)
	}
	

}
