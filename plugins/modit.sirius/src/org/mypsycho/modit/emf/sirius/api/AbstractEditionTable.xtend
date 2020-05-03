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
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.sirius.table.metamodel.table.description.EditionTableDescription
import org.eclipse.sirius.table.metamodel.table.description.FeatureColumnMapping
import org.eclipse.xtext.xbase.lib.Functions.Function1
import org.eclipse.xtext.xbase.lib.Procedures.Procedure2

/**
 * Adaptation of Sirius model into Java and EClass reflections API
 * for Edition Tables.
 * 
 * @author nicolas.peransin
 */
abstract class AbstractEditionTable extends AbstractTable<EditionTableDescription> {

	/**
	 * Create a factory for a diagram description.
	 * 
	 * @param parent of diagram
	 */
	new(AbstractGroup parent, String dLabel, Class<? extends EObject> dClass) {
		super(EditionTableDescription, parent, dLabel, dClass)
	}


	def void setFeature(FeatureColumnMapping it, EStructuralFeature feat) {
		featureName = feat.name
	}
	
	def column(String id, (FeatureColumnMapping)=>void initializer) {
		Objects.requireNonNull(initializer)
		FeatureColumnMapping.createAs(Ns.column.id(id)) [ 
			name = id
			initializer.apply(it)
		]
	}
	
	protected def columnRef(String id) {
		FeatureColumnMapping.ref(Ns.column.id(id))
	}

	
	protected def setCanEdit(FeatureColumnMapping it, Function1<? extends EObject, Boolean> predicat) {
		canEdit = context.expression(predicat) // use self
	}
	
	/**
	 * Defines the operation to edit a cell.
	 * <p>
	 * As Edition Table does not provide columns information, only line is provided.
	 * </p>
	 * 
	 * @param it column to edit
	 * @param operation on (line element, value)
	 */
	def void setDirectEdit(FeatureColumnMapping it, String operation) {
		directEdit = createLabelEdit[
			browseExpression = operation
		]
	}
	
	/**
	 * Defines the operation to edit a cell.
	 * <p>
	 * As Edition Table does not provide columns information, only line is provided.
	 * </p>
	 * 
	 * @param it column to edit
	 * @param operation on (line element, value)
	 */
	def void setDirectEdit(FeatureColumnMapping it, Procedure2<? extends EObject, String> operation) {
		directEdit = context.expression(params(EditArg.lineSemantic, EDIT_VALUE), operation)
	}
	

}
