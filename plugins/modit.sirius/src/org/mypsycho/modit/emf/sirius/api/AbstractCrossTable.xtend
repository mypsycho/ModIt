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
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EObject
import org.eclipse.sirius.table.metamodel.table.description.CreateCellTool
import org.eclipse.sirius.table.metamodel.table.description.CreateCrossColumnTool
import org.eclipse.sirius.table.metamodel.table.description.CrossTableDescription
import org.eclipse.sirius.table.metamodel.table.description.DeleteColumnTool
import org.eclipse.sirius.table.metamodel.table.description.ElementColumnMapping
import org.eclipse.sirius.table.metamodel.table.description.IntersectionMapping
import org.eclipse.sirius.table.metamodel.table.description.LabelEditTool
import org.eclipse.sirius.viewpoint.description.tool.EditMaskVariables
import org.eclipse.sirius.viewpoint.description.tool.ModelOperation
import org.eclipse.xtext.xbase.lib.Procedures.Procedure3

/**
 * Adaptation of Sirius model into Java and EClass reflections API
 * for Cross tables.
 * 
 * @author nicolas.peransin
 */
abstract class AbstractCrossTable extends AbstractTable<CrossTableDescription> {

	/**
	 * Create a factory for a diagram description
	 * 
	 * @param parent of diagram
	 */
	new(AbstractGroup parent, String dLabel, Class<? extends EObject> dClass) {
		super(CrossTableDescription, parent, dLabel, dClass)
	}
	
	/**
	 * Sets the domain class of a description.
	 * <p>
	 * EClass is resolved using businessPackages of AbstractGroup.
	 * </p>
	 * 
	 * @param it description to define
	 * @param type of the description
	 */
	def void setDomainClass(ElementColumnMapping it, Class<? extends EObject> type) {
		domainClass = context.asDomainClass(type)
	}
		   
    /**
     * Sets the domain class of a description.
     * <p>
     * EClass is resolved using businessPackages of AbstractGroup.
     * </p>
     * 
     * @param it description to define
     * @param type of the description
     */
    def void setDomainClass(ElementColumnMapping it, EClass type) {
        domainClass = SiriusDesigns.encode(type)
    }
	
	/**
	 * Sets the domain class of a description.
	 * <p>
	 * EClass is resolved using businessPackages of AbstractGroup.
	 * </p>
	 * 
	 * @param it description to define
	 * @param type of the description
	 */
	def void setDomainClass(IntersectionMapping it, Class<? extends EObject> type) {
		domainClass = context.asDomainClass(type)
	}
		   
    /**
     * Sets the domain class of a description.
     * <p>
     * EClass is resolved using businessPackages of AbstractGroup.
     * </p>
     * 
     * @param it description to define
     * @param type of the description
     */
    def void setDomainClass(IntersectionMapping it, EClass type) {
        domainClass = SiriusDesigns.encode(type)
    }
	
	/**
	 * Sets edit operation for provided mapping.
	 * 
	 * @param it containing mapping
	 * @param operation to perform
	 */
	def void setDirectEdit(IntersectionMapping it, ModelOperation operation) {
		directEdit = operation.createLabelEdit
	}

	/**
	 * Sets edit operation for provided mapping.
	 * 
	 * @param it containing mapping
	 * @param operation to perform
	 */
	def void setDirectEdit(IntersectionMapping it, String operation) {
		directEdit = operation.toOperation
	}

	/**
	 * Sets edit operation for provided mapping.
	 * 
	 * @param it containing mapping
	 * @param operation (lineSemantic,columnSemantic,value) to perform
	 */
	def void setDirectEdit(IntersectionMapping it, 
		Procedure3<? extends EObject, ? extends EObject, String> operation
	) {
		directEdit = context.expression(
			params(EditArg.lineSemantic, EditArg.columnSemantic, EDIT_VALUE), 
			operation
		)
	}
	
	/**
	 * Creates a column with provided id.
	 * 
	 * @param name of column
	 * @param domain class of column value
	 * @param initializer of column
	 */
	def column(String name, 
		Class<? extends EObject> domain, 
		(ElementColumnMapping)=>void initializer
	) {
        Objects.requireNonNull(initializer)
        name.column[
        	domainClass = domain.asDomainClass
        	initializer.apply(it)
        ]
    }
    
    def column(CrossTableDescription it, 
    	String name, Class<? extends EObject> domain, 
    	(ElementColumnMapping)=>void initializer
    ) {
		ownedColumnMappings += name.column(domain, initializer)
	}
    
	/**
	 * Creates a column with provided id.
	 * 
	 * @param name of column
	 * @param initializer of column
	 */
	def column(String name, 
		(ElementColumnMapping)=>void initializer
	) {
        Objects.requireNonNull(initializer)
        ElementColumnMapping.createAs(Ns.column, name) [ 
            noDelete
            initializer.apply(it)
        ]
    }
    
    def column(CrossTableDescription it, String name, 
    	(ElementColumnMapping)=>void initializer
    ) {
		ownedColumnMappings += name.column(initializer)
	}
	
	protected def columnRef(String id) {
		ElementColumnMapping.ref(Ns.column.id(id))
	}
    
    def void noDelete(ElementColumnMapping it) {
        delete = DeleteColumnTool.create[
            precondition = SiriusDesigns.NEVER
        ]
    }
    
    	
	def setOperation(CreateCellTool it, ModelOperation operation) {
		// For reversing mainly, more precise API exists.
		// CreateLineTool is ambiguious with AbstractToolDescription
		firstModelOperation = operation
	}

	static val CELL_CREATE_ARGS = #[ 
	     EditArg.lineSemantic -> null,
	     EditArg.columnSemantic -> null,
	     EditArg.root -> null
	]

	static val COLUMN_CREATE_ARGS = #[ 
	     EditArg.root -> null,
	     EditArg.element -> null,
	     EditArg.container -> null
	]

	def initVariables(CreateCellTool it) {
		initVariables(CELL_CREATE_ARGS)
	}
	
	def initVariables(CreateCrossColumnTool it) {
		initVariables(COLUMN_CREATE_ARGS)
	}
	
	
	def setMask(CreateCellTool it, String value) {
		mask = EditMaskVariables.create[ mask = value ]
	}
	
	static val CELL_LABEL_ARGS = #[ 
	     EditArg.table -> null,
	     EditArg.line -> null,
	     EditArg.element -> "The currently edited element.",
	     EditArg.lineSemantic -> null,
	     EditArg.columnSemantic -> "The semantic element corresponding to the column (only available for Intersection Mapping).",
	     EditArg.root -> "The semantic element of the table."
	]
	
	override initVariables(LabelEditTool it) {
		if (eContainer instanceof IntersectionMapping) {
			initVariables(CELL_LABEL_ARGS)
		} else {
			super.initVariables(it)
		}
	}
	
	def createAddColumn(CrossTableDescription it, String toolLabel, ElementColumnMapping column, ModelOperation task) {
		var result = CreateCrossColumnTool.create [
			initVariables
			label = toolLabel
			mapping = column
			operation = task
		]
		createColumn += result
		result
	}
	
	/**
	 * Add a CreateCell tool using 'arg0' variable.
	 */
	def createCell(IntersectionMapping it, ModelOperation task) {
		create = CreateCellTool.create("Edit cell") [
			initVariables
			mask = "{0}"
			operation = task
		]

		create
	}
	
	
}
