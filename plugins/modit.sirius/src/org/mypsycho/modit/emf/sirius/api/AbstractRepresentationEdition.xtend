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
import org.eclipse.sirius.viewpoint.description.RepresentationDescription
import org.eclipse.sirius.viewpoint.description.RepresentationExtensionDescription

/**
 * Adaptation of Sirius model into Java and EClass reflections API
 * for representation.
 * 
 * @author nicolas.peransin
 */
abstract class AbstractRepresentationEdition<T extends EObject> extends AbstractTypedEdition<T> {
	
	/**
	 * Creates a factory for a representation description.
	 * 
	 * @param type of edition
	 * @param parent context of representation
	 * @param descrLabel displayed on representation groups
	 */
	new(Class<T> type, SiriusVpGroup parent) {
		super(type, parent)
		creationTasks.add [ // xtend fails to infere '+=' .
			if (it instanceof RepresentationExtensionDescription) {
				name = contentAlias
				metamodel += businessPackages
			} else if (it instanceof RepresentationDescription) {
				name = contentAlias
				metamodel += businessPackages
			}
		]
	}
	
	/**
	 * Creates a factory for a representation description.
	 * 
	 * @param type of edition
	 * @param parent context of representation
	 * @param descrLabel displayed on representation groups
	 */
	 new(Class<T> type, SiriusVpGroup parent, String descrLabel) {
		this(type, parent)
	
		creationTasks.add[  // xtend fails to infere '+=' .
			if (it instanceof RepresentationDescription) {
				label = descrLabel
			}
		]
	}
	
}
