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
import org.eclipse.sirius.table.metamodel.table.description.CreateColumnTool
import org.eclipse.sirius.table.metamodel.table.description.CreateCrossColumnTool
import org.eclipse.sirius.table.metamodel.table.description.CrossTableDescription
import org.eclipse.sirius.table.metamodel.table.description.DeleteColumnTool
import org.eclipse.sirius.table.metamodel.table.description.ElementColumnMapping
import org.eclipse.sirius.table.metamodel.table.description.IntersectionMapping
import org.eclipse.sirius.table.metamodel.table.description.LabelEditTool
import org.eclipse.sirius.table.metamodel.table.description.LineMapping
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
			params(EditArg.lineSemantic, EditArg.columnSemantic, SiriusDesigns.EDIT_VALUE), 
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
    
    def ownedColumn(CrossTableDescription it, 
    	String name, Class<? extends EObject> domain, 
    	(ElementColumnMapping)=>void initializer
    ) {
    	val result = name.column(domain, initializer)
		ownedColumnMappings += result
		result
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
    
    def ownedColumn(CrossTableDescription it, String name, 
    	(ElementColumnMapping)=>void initializer
    ) {
		val result = name.column(initializer)
		ownedColumnMappings += result
		result
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

	static val COLUMN_DEL_ARGS = #[ 
	     EditArg.root -> null,
	     EditArg.element -> null
	]

	def initVariables(CreateCellTool it) {
		initVariables(CELL_CREATE_ARGS)
	}
	
	def initVariables(CreateCrossColumnTool it) {
		initVariables(COLUMN_CREATE_ARGS)
	}
	
	def initVariables(CreateColumnTool it) {
		initVariables(COLUMN_CREATE_ARGS)
	}
	
	def initVariables(DeleteColumnTool it) {
		initVariables(COLUMN_DEL_ARGS)
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
	
	/**
	 * Creates and add to tool create new column.
	 * <p>
	 * Reminder: Context menu has issue for Column header.
	 * Menu only consider last selected cell to build the menu.
	 * </p>
	 */
	def createAddColumn(CrossTableDescription it, String column, String role, String toolLabel, ModelOperation task) {
		var result = CreateCrossColumnTool.createAs(Ns.create, column + role) [
			initVariables
			label = toolLabel
			mapping = column.columnRef
			operation = task
		]
		createColumn += result
		result
	}
	
	/**
	 * Creates and add to tool create new column.
	 * <p>
	 * Reminder: Context menu has issue for Column header.
	 * Menu only consider last selected cell to build the menu.
	 * </p>
	 */
	def createAddColumn(ElementColumnMapping it, String role, String toolLabel, ModelOperation task) {
		var result = CreateColumnTool.createAs(Ns.create, role) [
			initVariables
			label = toolLabel
			// mapping is opposite
			operation = task
		]
		create += result
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
	
		
	protected def initCellStyle(IntersectionMapping it) {
		foreground = []
	}
	
		
	/**
	 * Creates an Element Intersection.
	 * <p>
	 * Description must provide expression, edition and mappings using
	 * {@link 
	 * VseDataTable#toLines(IntersectionMapping, String, LineMapping...) 
	 * toLines} and {@link 
	 * VseDataTable#toColumn(IntersectionMapping, String, ElementColumnMapping) 
	 * toColumn}.
	 * </p>
	 */
	def cells(CrossTableDescription owner, String mappingName, Class<? extends EObject> domain, 
		String candidatesExpr, (IntersectionMapping)=>void descr
	) {
		Objects.requireNonNull(descr)
		val result = IntersectionMapping.create(mappingName) [
			useDomainClass = true
			domainClass = domain
			
			// self is root
			semanticCandidatesExpression = candidatesExpr
			initCellStyle
			
			// Required:
			//   lineMapping,
			//   columnMapping,
			//   lineFinderExpression,
			//   columnFinderExpression,
			descr.apply(it)
		]
		owner.intersection += result
		result
	}

	/**
	 * Defines the lines of Element-based cell.
	 */
	def toLines(IntersectionMapping it, String expr, LineMapping... mappings) {
		"This method is applicable only to Domain intersection".verify(useDomainClass)
		lineMapping += mappings
		lineFinderExpression = expr
	}

	/**
	 * Defines the column of Element-based cell.
	 */
	def toColumn(IntersectionMapping it, String expr, ElementColumnMapping mapping) {
		"This method is applicable only to Domain intersection".verify(useDomainClass)
		columnMapping = mapping
		columnFinderExpression = expr
	}

	/**
	 * Creates a Relationship Intersection.
	 * <p>
	 * Description must provide expression, edition and mappings using
	 * {@link 
	 * VseDataTable#forMappings(IntersectionMapping, ElementColumnMapping, LineMapping...) 
	 * forMappings}.
	 * </p>
	 */
	def links(CrossTableDescription owner, String mappingName, 
		String columnExpr, (IntersectionMapping)=>void descr
	) {
		Objects.requireNonNull(descr)
		val result = IntersectionMapping.create(mappingName) [
			useDomainClass = false
			
			// self is root
			columnFinderExpression = columnExpr
			initCellStyle

			// Required:
			//   lineMapping,
			//   columnMapping
			descr.apply(it)
		]
		owner.intersection += result
		result
	}
	
	/**
	 * Defines the mappings of RelationShip-based cell.
	 */
	def forMappings(IntersectionMapping it, ElementColumnMapping column, LineMapping... lines) {
		"This method is applicable only to Relation intersection".verify(!useDomainClass)
		columnMapping = column
		lineMapping += lines
	}
	
}
