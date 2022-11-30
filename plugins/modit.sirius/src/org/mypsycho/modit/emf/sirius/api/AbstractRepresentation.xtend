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

import org.eclipse.sirius.viewpoint.description.RepresentationDescription

/**
 * Adaptation of Sirius model into Java and EClass reflections API
 * for representation.
 * 
 * @author nicolas.peransin
 */
abstract class AbstractRepresentation<T extends RepresentationDescription> extends AbstractTypedEdition<T> {
	// TODO extend AbstractDiagramPart ??

	/**
	 * Creates a factory for a representation description.
	 * 
	 * @param parent context of representation
	 */
	new(Class<T> type, AbstractGroup parent, String dLabel) {
		super(type, parent)
	
		creationTasks.add[  // xtend fails to infere '+=' .
			label = dLabel
			name = contentAlias
			metamodel += context.businessPackages
		]
	}



}
