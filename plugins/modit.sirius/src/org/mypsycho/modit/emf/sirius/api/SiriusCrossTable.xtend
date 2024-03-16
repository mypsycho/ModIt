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
abstract class SiriusCrossTable extends AbstractTable<CrossTableDescription> {

	
	public static val CELL_LABEL_ARGS = #[ 
	     EditArg.table -> null,
	     EditArg.line -> null,
	     EditArg.element -> "The currently edited element.",
	     EditArg.lineSemantic -> null,
	     EditArg.columnSemantic -> "The semantic element corresponding to the column (only available for Intersection Mapping).",
	     EditArg.root -> "The semantic element of the table."
	]

	/**
	 * Create a factory for a diagram description
	 * 
	 * @param parent of diagram
	 */
	new(SiriusVpGroup parent, String dLabel, Class<? extends EObject> dClass) {
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


	
	def setMask(CreateCellTool it, String value) {
		mask = EditMaskVariables.create[ mask = value ]
	}

	
	/**
	 * Creates and add to tool create new column.
	 * <p>
	 * Reminder: Context menu has issue for Column header.
	 * Menu only consider last selected cell to build the menu.
	 * </p>
	 */
	def createAddColumn(CrossTableDescription owner, String column, String role, String toolLabel, ModelOperation task) {
		CreateCrossColumnTool.createAs(Ns.create, column + role) [
			initVariables
			label = toolLabel
			mapping = column.columnRef
			operation = task
		] => [
			owner.createColumn += it
		]
	}
	
	/**
	 * Creates and add to tool create new column.
	 * <p>
	 * Reminder: Context menu has issue for Column header.
	 * Menu only consider last selected cell to build the menu.
	 * </p>
	 */
	def createAddColumn(ElementColumnMapping owner, String role, String toolLabel, ModelOperation task) {
		CreateColumnTool.createAs(Ns.create, role) [
			initVariables
			label = toolLabel
			// mapping is opposite
			operation = task
		] => [
			owner.create += it
		]
	}
	
	/**
	 * Add a CreateCell tool using 'arg0' variable.
	 */
	def createCell(IntersectionMapping owner, ModelOperation task) {
		CreateCellTool.create("Edit cell") [
			initVariables
			mask = "{0}"
			operation = task
		] => [
			owner.create = it
		]
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
	def linkColumns(CrossTableDescription owner, String mappingName, 
		ElementColumnMapping column, (IntersectionMapping)=>void descr
	) {
		Objects.requireNonNull(descr)
		val result = IntersectionMapping.create(mappingName) [
			useDomainClass = false
			// no DomainClass, no semanticCandidatesExpression
			
			// self is root
			columnMapping = column
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
	 * Defines the source mappings of RelationShip-based cell.
	 */
	def forLines(IntersectionMapping it, String toColumnExpr, LineMapping... lines) {
		"This method is applicable only to Relation intersection".verify(!useDomainClass)
		columnFinderExpression = toColumnExpr
		lineMapping += lines
	}
	
}
