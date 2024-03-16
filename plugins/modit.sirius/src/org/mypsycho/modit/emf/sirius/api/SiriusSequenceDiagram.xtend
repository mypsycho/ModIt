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

import org.eclipse.emf.ecore.EObject
import org.eclipse.sirius.diagram.sequence.description.SequenceDiagramDescription

/**
 * Adaptation of Sirius model into Java and EClass reflections API for Diagrams.
 * 
 * @author nicolas.peransin
 */
abstract class SiriusSequenceDiagram extends AbstractBaseDiagram<SequenceDiagramDescription> {


	/**
	 * Creates a factory for a diagram description.
	 * 
	 * @param parent of diagram
	 * @param descrLabel displayed on representation groups
	 * @param domain class of diagram
	 */
	new(SiriusVpGroup parent, String descrLabel, Class<? extends EObject> domain) {
		super(SequenceDiagramDescription, parent, descrLabel, domain)
	}
		
	/**
	 * Creates a factory for a diagram description.
	 * <p>
	 * Constructor for reverse code or variants.
	 * </p>
	 * 
	 * @param parent of diagram
	 * @param dName of this diagram
	 * @param descrLabel displayed on representation groups
	 * @param domain class of diagram
	 */
	new(SiriusVpGroup parent, String dName, String dLabel, Class<? extends EObject> domain) {
		this(parent, dLabel, domain)
		changeName(dName)
	}


}
