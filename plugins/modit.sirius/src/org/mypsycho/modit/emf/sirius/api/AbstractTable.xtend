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
import org.eclipse.emf.ecore.EReference
import org.eclipse.sirius.table.metamodel.table.description.BackgroundStyleDescription
import org.eclipse.sirius.table.metamodel.table.description.CreateLineTool
import org.eclipse.sirius.table.metamodel.table.description.DeleteLineTool
import org.eclipse.sirius.table.metamodel.table.description.LabelEditTool
import org.eclipse.sirius.table.metamodel.table.description.LineMapping
import org.eclipse.sirius.table.metamodel.table.description.TableDescription
import org.eclipse.sirius.table.metamodel.table.description.TableVariable
import org.eclipse.sirius.viewpoint.description.SystemColor
import org.eclipse.sirius.viewpoint.description.tool.EditMaskVariables
import org.eclipse.sirius.viewpoint.description.tool.ModelOperation
import org.eclipse.xtext.xbase.lib.Procedures.Procedure2
import org.eclipse.xtext.xbase.lib.Procedures.Procedure3

/**
 * Class adapting Sirius model into Java and EClass reflection s
 * for tables.
 * 
 * @author nicolas.peransin
 */
abstract class AbstractTable<T extends TableDescription> extends AbstractRepresentation<T>{

	/** Namespaces for identification */
	enum Ns { // namespace for identication
		line, column, create
	}

	enum EditArg {
		/** feature of column */ element, // only used by feature table
		/** Current DTable. */ table, 
		/** DLine of the current DCell: table.DLine */line, 
		/** semantic target of line */lineSemantic, 
		/** DColumn of the current DCell: table.DColumn */column, 
		/** semantic target of column */columnSemantic, // only used by cross table
		/** semantic target of the current DTable. */root
	}
	
	static val LINE_DELETE_ARGS = #[ 
	     EditArg.element, // line semantic
	     EditArg.root // table semantic
	]

	
	/** Value return by field edit */
	public static val EDIT_VALUE = "arg0"
	
	
	// root='ecore.EObject | semantic target of the current DTable.' 
// line='table.DLine | DLine of the current DCell.'
// lineSemantic='ecore.EObject | semantic target of $line' 
// container='ecore.EObject | semantic target of $line.' 
// column='table.DColumn | DColumn of the current DCell.' 
// columnSemantic='ecore.EObject | semantic target of $column'
	
	enum CreateMappingArg {
		root, // "The semantic root element of the table.",
		element, //"The semantic currently edited element.",
		container // The semantic element corresponding to the view container."
	}
	static val CREATE_MAPPING_ARGS = CreateMappingArg.values.params

	/**
	 * Create a factory for a diagram description
	 * 
	 * @param parent of diagram
	 */
	new(Class<T> type, AbstractGroup parent, String dLabel, Class<? extends EObject> dClass) {
		super(type, parent, dLabel)
		creationTasks.add [
			domainClass = context.asDomainClass(dClass)
		]
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
	def void setDomainClass(LineMapping it, Class<? extends EObject> type) {
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
    def void setDomainClass(LineMapping it, EClass type) {
        domainClass = SiriusDesigns.encode(type)
    }
	
	/**
	 * Sets the candidate expression of a description.
	 * <p>
	 * If domain class and/or name is not set, a derived value is provided
	 * </p>
	 * 
	 * @param it description to define
	 * @param type of the description
	 */
	def void setSemanticCandidates(LineMapping it, EReference ref) {
		semanticCandidatesExpression = SiriusDesigns.encode(ref)
	}

	/**
	 * Sets a mapping as not removable.
	 * 
	 * @param it mapping
	 */
	def void noDelete(LineMapping it) {
		delete = DeleteLineTool.create[
			name = "del:" + mapping.name // no change it will be triggered.
			precondition = SiriusDesigns.NEVER
		]
	}
	
	def void setVirtual(LineMapping it, String headerExpression) {
		val owner = eContainer
		
		domainClass = 
			if (owner instanceof LineMapping) owner.domainClass
			else if (owner instanceof TableDescription) owner.domainClass
			else SiriusDesigns.ANY_TYPE // should not happen, log ?
		
		semanticCandidatesExpression = SiriusDesigns.IDENTITY
		noDelete // delete would apply on directory element.
		headerLabelExpression = headerExpression // could be localized
	}

	protected def line(String id, (LineMapping)=>void initializer) {
		Objects.requireNonNull(initializer)
		LineMapping.createAs(Ns.line, id) [
			initializer.apply(it)

			defaultBackground = BackgroundStyleDescription.create [ // null is grey
				backgroundColor = SystemColor.extraRef("color:white")
			]
			
		]
 	}

	protected def lineRef(String id) {
		LineMapping.ref(Ns.line.id(id))
	}
	
	def createLabelEdit(ModelOperation operation) {
		 LabelEditTool.create [
			// Built-in variables, 
			// required to handle scope in interpreter
			// (seems like a dirty hack)
			variables += EditArg.values.toToolVariables
			mask = EditMaskVariables.create[ mask = "{0}" ]
			firstModelOperation = operation
		]
	}
	
    /**
     * Set Delete tool of a line.
     * 
     * @param parent to Delete
     * @param toolLabel
     * @param init of tool
     * @param operation to perform
     */
    def setDelete(LineMapping parent, ModelOperation operation) {
        parent.delete = DeleteLineTool.create [
            name = parent.name + ":delete"
            label = "Delete"
            variables += LINE_DELETE_ARGS.toToolVariables
            firstModelOperation = operation
        ]
    }

    
    /**
     * Set Delete tool of a line.
     * 
     * @param it to Delete
     * @param toolLabel
     * @param init of tool
     * @param action(root target, line target, line view)
     */
    def setDelete(LineMapping it, Procedure2<EObject, EObject> action) {
        delete = context.expression(LINE_DELETE_ARGS.params, action).toOperation
    }
	
    /**
     * Creates a creation tool for a line.
     * 
     * @param line id
     * @param role of the tool
     * @param toolLabel to display
     * @param operation to perform
     * @return new CreateLineTool instance
     */
	def createLine(String line, String role, String toolLabel, ModelOperation operation) {
		CreateLineTool.createAs(Ns.create, line + role) [
			label = toolLabel
			mapping = line.lineRef
			variables += CreateMappingArg.values.toToolVariables
			firstModelOperation = operation
		]
	}

    /**
     * Creates a creation tool for a line.
     * 
     * @param line to create
     * @param toolLabel to display
     * @param operation to perform
     * @return new CreateLineTool instance
     */
	def createLine(String line, String toolLabel, ModelOperation operation) {
		line.createLine("", "", operation)
	}
	
    /**
     * Creates a creation tool for a line.
     * 
     * @param line name
     * @param toolLabel to display
     * @param action(root target, line target, line view)
     * @return new CreateLineTool instance
     */
    def createLine(String line, String toolLabel, Procedure3<EObject, EObject, EObject> action
	) {
		line.createLine("", toolLabel, action)
	}
	
    /**
     * Creates a creation tool for a line.
     * <p>
     * A role is required if there is several way to create this kind of line. 
     * </p>
     * 
     * @param line name
     * @param role of the tool
     * @param toolLabel to display
     * @param action(root target, line target, line view)
     * @return new CreateLineTool instance
     */
    def createLine(String line, String role, String toolLabel, Procedure3<EObject, EObject, EObject> action
	) {
		line.createLine(toolLabel, role, context.expression(CREATE_MAPPING_ARGS, action).toOperation)
	}
	
	def toToolVariables(Enum<?>... names) {
	    names.map[ descr |
            TableVariable.create[ name = descr.name ]
        ]
	}
	
}
