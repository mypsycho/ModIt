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
import org.eclipse.sirius.table.metamodel.table.description.CreateTool
import org.eclipse.sirius.table.metamodel.table.description.DeleteLineTool
import org.eclipse.sirius.table.metamodel.table.description.LabelEditTool
import org.eclipse.sirius.table.metamodel.table.description.LineMapping
import org.eclipse.sirius.table.metamodel.table.description.TableDescription
import org.eclipse.sirius.table.metamodel.table.description.TableTool
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
abstract class AbstractTable<T extends TableDescription> extends AbstractTypedEdition<T>{

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
		/** semantic target of the current DTable. */root,
		container
	}
	
	static val EDIT_ARGS_DOCUMENTATIONS = #{
		EditArg.element -> "The current DCell.",
		EditArg.table -> "The current DTable.",
		EditArg.line -> "The DLine of the current DCell.",
		EditArg.lineSemantic -> "The semantic element corresponding to the line.",
		EditArg.root -> "The semantic root element of the table.",
		EditArg.columnSemantic -> "The semantic element corresponding to the column.",
		EditArg.column -> "xxx",
		EditArg.container -> "The semantic element corresponding to the view container."
	}
	
	static val ALL_ARGS = EditArg.values.map[ it -> null ]
	
	static val LINE_DELETE_ARGS = #[ 
	     EditArg.element -> null, // line semantic
	     EditArg.root -> null // table semantic
	]

	static val CREATE_LINE_ARGS = #[ 
		EditArg.root -> null, 
		EditArg.element -> "The semantic currently edited element.", // "The current DCell.", 
		EditArg.container -> null
	]


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
			if (owner instanceof LineMapping) 
				owner.domainClass
			else if (owner instanceof TableDescription) 
				owner.domainClass
			else  // should not happen, log ?
				SiriusDesigns.ANY_TYPE
		
		semanticCandidatesExpression = SiriusDesigns.IDENTITY
		noDelete // delete would apply on directory element.
		headerLabelExpression = headerExpression // could be localized
	}

	protected def initDefaultLineStyle(LineMapping it) {
		defaultBackground = BackgroundStyleDescription.create [ // null is grey
			backgroundColor = SystemColor.extraRef("color:white")
		]
	}

	def line(String id, (LineMapping)=>void initializer) {
		Objects.requireNonNull(initializer)
		LineMapping.createAs(Ns.line, id) [
			initDefaultLineStyle
			initializer.apply(it)
		]
 	}
 	
 	@Deprecated // ambiguous: use ownedLine
	def line(TableDescription it, String id, (LineMapping)=>void initializer) {
		ownedLine(id, initializer)
	}

	@Deprecated // ambiguous: use ownedLine
	def line(LineMapping it, String id, (LineMapping)=>void initializer) {
		ownedLine(id, initializer)
	}

	def ownedLine(TableDescription it, String id, (LineMapping)=>void initializer) {
		ownedLineMappings += id.line(initializer)
	}

	def ownedLine(LineMapping it, String id, (LineMapping)=>void initializer) {
		ownedSubLines += id.line(initializer)
	}

	def lineRef(String id) {
		LineMapping.ref(Ns.line.id(id))
	}
	
	def initVariables(TableTool it, Iterable<? extends Pair<EditArg, ?>> variableNames) {
		variables += variableNames.map[ descr |
            TableVariable.create[ 
            	name = descr.key.name
            	documentation = descr.value?.toString 
            		?: EDIT_ARGS_DOCUMENTATIONS.get(descr.key)
            ]
        ]
	}

	def setOperation(TableTool it, ModelOperation operation) {
		// For reversing mainly, more precise API exists.
		firstModelOperation = operation
	}
		
	def setOperation(CreateTool it, ModelOperation operation) {
		// For reversing mainly, more precise API exists.
		// CreateLineTool is ambiguious with AbstractToolDescription
		firstModelOperation = operation
	}
	
	def createLabelEdit(ModelOperation operation) {
		 LabelEditTool.create [
			// Built-in variables, 
			// required to handle scope in interpreter
			// (seems like a dirty hack)
			initVariables
			mask = "{0}"
			firstModelOperation = operation
		]
	}
	
	def setMask(LabelEditTool it, String value) {
		mask = EditMaskVariables.create[ mask = value ]
	}
	
	def initVariables(LabelEditTool it) {
		initVariables(ALL_ARGS)
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
            initVariables
            firstModelOperation = operation
        ]
    }

	def initVariables(DeleteLineTool it) {
		initVariables(LINE_DELETE_ARGS)
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
			initVariables
			firstModelOperation = operation
		]
	}
	
	def initVariables(CreateLineTool it) {
		initVariables(CREATE_LINE_ARGS)
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
		line.createLine("", toolLabel, operation)
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
    static val CREATE_LINE_PARAMS = CREATE_LINE_ARGS.params
    def createLine(String line, String role, String toolLabel, Procedure3<EObject, EObject, EObject> action
	) {
		line.createLine(toolLabel, role, context.expression(CREATE_LINE_PARAMS, action).toOperation)
	}
	

	
}
