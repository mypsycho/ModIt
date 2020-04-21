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

import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.sirius.table.metamodel.table.description.EditionTableDescription
import org.eclipse.sirius.table.metamodel.table.description.FeatureColumnMapping

/**
 * Class regrouping a common adaptation of Sirius into Java and EClass reflection for Diagram.
 * 
 * @author nicolas.peransin
 */
abstract class AbstractEditionTable extends AbstractTable<EditionTableDescription> {

	/**
	 * Create a factory for a diagram description
	 * 
	 * @param parent of diagram
	 */
	new(AbstractGroup parent, String dLabel, Class<? extends EObject> dClass) {
		super(EditionTableDescription, parent, dLabel, dClass)
	}


	def void setFeature(FeatureColumnMapping it, EStructuralFeature feat) {
		featureName = feat.name
	}
	
}