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

import java.util.Objects
import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.sirius.diagram.description.DiagramDescription
import org.eclipse.sirius.diagram.description.DiagramExtensionDescription
import org.eclipse.sirius.viewpoint.description.Group
import org.eclipse.sirius.viewpoint.description.RepresentationDescription
import org.eclipse.sirius.viewpoint.description.Viewpoint

/**
 * Adaptation of Sirius model into Java and EClass reflections API
 * for Diagrams.
 * 
 * @author nicolas.peransin
 */
abstract class AbstractDiagramExtension extends AbstractDiagramPart<DiagramExtensionDescription> {
	
	protected var DiagramDescription extended

		
	/**
	 * Creates a factory for a diagram description
	 * 
	 * @param parent of diagram
	 * @param dName of diagram
	 */
	new(AbstractGroup parent, String dName) {
		super(DiagramExtensionDescription, parent)
		Objects.requireNonNull(dName)
		
		creationTasks.add[
			name = dName
			if (extended != null) {
				representationName = extended.name
				viewpointURI = extended.vpUri				
			}
		]
	}
	
	/**
	 * Creates a factory for a diagram description
	 * 
	 * @param parent of diagram
	 * @param dName of diagram
	 * @param extended diagram
	 */
	new(AbstractGroup parent, String dName, DiagramDescription extended) {
		this(parent, dName)
		
		this.extended = extended
	}
	

	def getVpUri(RepresentationDescription it) {
		(SiriusDesigns.eContainer(it, Group) == context.getContent()) // local representation
		? SiriusDesigns.encodeVpUri(context.pluginId, SiriusDesigns.eContainer(it, Viewpoint).name)
		: extraVpUri
	}

	def static getExtraVpUri(RepresentationDescription it) {
		(eContainer as Viewpoint).extraVpUri
	}

	def static getExtraVpUri(Viewpoint it) {
		val extendedUri = EcoreUtil.getURI(it)
		if (!extendedUri.isPlatformPlugin) {
			throw new IllegalArgumentException('''Unsupported reference: «extendedUri»''')
		}
		SiriusDesigns.encodeVpUri(extendedUri.segment(1), name)
	}
	

}
