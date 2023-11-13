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
import org.eclipse.emf.ecore.EAttribute
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.sirius.table.metamodel.table.description.EditionTableDescription
import org.eclipse.sirius.table.metamodel.table.description.FeatureColumnMapping
import org.eclipse.sirius.viewpoint.description.tool.ModelOperation
import org.eclipse.xtext.xbase.lib.Functions.Function1
import org.eclipse.xtext.xbase.lib.Procedures.Procedure2

/**
 * Adaptation of Sirius model into Java and EClass reflections API
 * for Edition Tables.
 * 
 * @author nicolas.peransin
 */
abstract class SiriusFeatureTable extends AbstractTable<EditionTableDescription> {

	public static val VIRTUAL_FEATURE = "*"

	/**
	 * Creates a factory for a diagram description.
	 * 
	 * @param parent of diagram
	 */
	new(SiriusVpGroup parent, String dLabel, Class<? extends EObject> dClass) {
		super(EditionTableDescription, parent, dLabel, dClass)
	}

	/**
	 * Sets the feature of a column.
	 */
	protected def void setFeature(FeatureColumnMapping it, EStructuralFeature feat) {
		featureName = feat.name
	}
	
	protected def initColumnStyle(FeatureColumnMapping it) {
		// foreground = []
		// background = null
	}
	
	/** Creates a column. */
	def column(String id, (FeatureColumnMapping)=>void initializer) {
		Objects.requireNonNull(initializer)
		FeatureColumnMapping.createAs(Ns.column, id) [ 
			name = id
			initColumnStyle
			initializer.apply(it)
		]
	}
	
	/** Creates a column editing the feature. */
	def column(String id, EStructuralFeature feat, (FeatureColumnMapping)=>void initializer) {
		Objects.requireNonNull(initializer)
		Objects.requireNonNull(feat)
		id.column [
			feature = feat
			initializer.apply(it)
		]
	}
	
	/** Creates a column without feature. */
	def virtualColumn(String id, (FeatureColumnMapping)=>void initializer) {
		Objects.requireNonNull(initializer)
		id.column [
			featureName = VIRTUAL_FEATURE // See table documentation.
			initializer.apply(it)
		]
	}
	
	@Deprecated // use ownedColumn
	def column(EditionTableDescription it, String id, (FeatureColumnMapping)=>void initializer) {
		val result = id.column(initializer)
		ownedColumnMappings += result
		result
	}
	
	/** Creates a column in the table. */
	def ownedColumn(EditionTableDescription it, String id, EStructuralFeature feat, (FeatureColumnMapping)=>void initializer) {
		ownedColumn(id, feat.name, initializer)
	}

	/** Creates a column in the table. */
	def ownedColumn(EditionTableDescription it, String id, String feat, (FeatureColumnMapping)=>void initializer) {
		val result = id.column[
			featureName = feat
			initializer.apply(it)
		]
		ownedColumnMappings += result
		result
	}
		
	/** Creates a column in the table. */
	def ownedVirtualColumn(EditionTableDescription it, String id, (FeatureColumnMapping)=>void initializer) {
		val result = id.virtualColumn(initializer)
		ownedColumnMappings += result
		result
	}
	
	/** References a column. */
	protected def columnRef(String id) {
		FeatureColumnMapping.ref(Ns.column.id(id))
	}
	
	protected def setCanEdit(FeatureColumnMapping it, 
		Function1<? extends EObject, Boolean> predicat
	) {
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
	protected def void setDirectEdit(FeatureColumnMapping it, String operation) {
		directEdit = operation.toOperation
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
	protected def void setDirectEdit(FeatureColumnMapping it, ModelOperation operation) {
		directEdit = operation.createLabelEdit
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
	protected def void setDirectEdit(FeatureColumnMapping it, EAttribute editedFeat) {
		directEdit = editedFeat.setter(SiriusDesigns.EDIT_VAR)
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
	protected def void setDirectEdit(FeatureColumnMapping it, 
		Procedure2<? extends EObject, String> operation
	) {
		directEdit = context.expression(params(EditArg.lineSemantic, SiriusDesigns.EDIT_VALUE), operation)
	}
	
}
