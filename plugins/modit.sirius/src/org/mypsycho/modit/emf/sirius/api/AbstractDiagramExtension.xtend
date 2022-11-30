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
import org.eclipse.sirius.viewpoint.description.RepresentationDescription
import org.eclipse.sirius.viewpoint.description.Viewpoint
import java.util.Objects

/**
 * Adaptation of Sirius model into Java and EClass reflections API
 * for Diagrams.
 * 
 * @author nicolas.peransin
 */
abstract class AbstractDiagramExtension extends AbstractDiagramPart<DiagramExtensionDescription> {
	
	val protected DiagramDescription extended
	
	/**
	 * Creates a factory for a diagram description
	 * 
	 * @param parent of diagram
	 */
	new(AbstractGroup parent, String dName, DiagramDescription extended) {
		super(DiagramExtensionDescription, parent)
		Objects.requireNonNull(dName)
		
		this.extended = extended
		val extendedUri = extended.vpUri
		
		creationTasks.add[
			name = dName
			representationName = extended.name
			viewpointURI = extendedUri
		]
	}

	def static getVpUri(RepresentationDescription it) {
		(eContainer as Viewpoint).vpUri
	}

	def static String getVpUri(Viewpoint it) {
		val extendedUri = EcoreUtil.getURI(it)
		if (!extendedUri.isPlatformPlugin) {
			throw new IllegalArgumentException('''Unsupported reference: «extendedUri»''')
		}
		'''viewpoint:/«extendedUri.segment(1)»/«name»'''
	}

}
