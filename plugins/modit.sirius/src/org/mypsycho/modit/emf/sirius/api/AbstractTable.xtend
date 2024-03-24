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
import org.eclipse.emf.ecore.EReference
import org.eclipse.sirius.table.metamodel.table.description.BackgroundConditionalStyle
import org.eclipse.sirius.table.metamodel.table.description.BackgroundStyleDescription
import org.eclipse.sirius.table.metamodel.table.description.CreateLineTool
import org.eclipse.sirius.table.metamodel.table.description.CreateTool
import org.eclipse.sirius.table.metamodel.table.description.DeleteLineTool
import org.eclipse.sirius.table.metamodel.table.description.DeleteTool
import org.eclipse.sirius.table.metamodel.table.description.ForegroundConditionalStyle
import org.eclipse.sirius.table.metamodel.table.description.ForegroundStyleDescription
import org.eclipse.sirius.table.metamodel.table.description.LabelEditTool
import org.eclipse.sirius.table.metamodel.table.description.LineMapping
import org.eclipse.sirius.table.metamodel.table.description.StyleUpdater
import org.eclipse.sirius.table.metamodel.table.description.TableDescription
import org.eclipse.sirius.table.metamodel.table.description.TableTool
import org.eclipse.sirius.table.metamodel.table.description.TableVariable
import org.eclipse.sirius.table.tools.api.interpreter.IInterpreterSiriusTableVariables
import org.eclipse.sirius.viewpoint.description.ColorDescription
import org.eclipse.sirius.viewpoint.description.tool.AbstractToolDescription
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
abstract class AbstractTable<T extends TableDescription> extends AbstractTypedEdition<T> {

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
	new(Class<T> type, SiriusVpGroup parent, String dLabel, Class<? extends EObject> dClass) {
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
	
	/** Initializes line as virtual: semantic = container and custom label  */
	def void setVirtual(LineMapping it, String headerExpression) {
		val owner = eContainer
		
		domainClass = switch(owner) {
			LineMapping: owner.domainClass
			TableDescription: owner.domainClass
			// should not happen, log ?
			default: SiriusDesigns.ANY_TYPE
		}
		
		semanticCandidatesExpression = SiriusDesigns.IDENTITY
		noDelete // delete would apply on directory element.
		headerLabelExpression = headerExpression // could be localized
	}

	/** Initializes the line style. */
	protected def initDefaultLineStyle(LineMapping it) {
		// Default background is grey.
		// (Sirius 6x ot more) There is a bug in header column
		// Always grey !!
		background = DColor.white.regular
		foreground = []
	}

	/** Creates a line. */
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

	/** Adds a line description. */
	def ownedLine(TableDescription owner, String id, (LineMapping)=>void initializer) {
		id.line(initializer) => [
			owner.ownedLineMappings += it
		]
	}

	/** Adds a line description. */
	def ownedLine(LineMapping owner, String id, (LineMapping)=>void initializer) {
		id.line(initializer) => [
			owner.ownedSubLines += it
		]
	}

	/** Reference of a local line */
	def lineRef(String id) {
		LineMapping.ref(Ns.line.id(id))
	}

	/** Reference of a local line */
	def lineRef(String owner, String id) {
		LineMapping.ref(Ns.line.id(owner, id))
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
	
	/** Creates a label edit.  */
	protected def createLabelEdit(ModelOperation task) {
		 LabelEditTool.create [
			// Built-in variables, 
			// required to handle scope in interpreter
			// (seems like a dirty hack)
			initVariables
			mask = "{0}"
			operation = task
		]
	}
	
	/** Sets the mask pattern. */
	def setMask(LabelEditTool it, String value) {
		mask = EditMaskVariables.create[ mask = value ]
	}
	
	/** Initializes variable in a tool. */
	def void initTableVariables(TableTool it) {
		// Inspired from TableToolVariables but is refactored between 6/7.
		variables += tableVariableNames
			.map[ vName | TableVariable.create[ name = vName ] ]
	}
	
	def getTableVariableNames(TableTool it) {
		switch(it) {
			CreateTool: #[ // column, crosscolumn, line
				IInterpreterSiriusTableVariables.ELEMENT,
				IInterpreterSiriusTableVariables.CONTAINER,
				IInterpreterSiriusTableVariables.ROOT
			]
			LabelEditTool: #[
				IInterpreterSiriusTableVariables.ELEMENT,
				IInterpreterSiriusTableVariables.TABLE,
				IInterpreterSiriusTableVariables.LINE,
				IInterpreterSiriusTableVariables.LINE_SEMANTIC,
				IInterpreterSiriusTableVariables.COLUMN_SEMANTIC,
				IInterpreterSiriusTableVariables.ROOT
			]
			DeleteTool: #[ // line, column
				IInterpreterSiriusTableVariables.ELEMENT,
				IInterpreterSiriusTableVariables.ROOT
			]
			default: #[]
		 }
	}
	
	/** Initializes variable in a tool. */
	def initVariables(LabelEditTool it) {
		// Disjunction of AbstractToolDescription and TableTool
		initTableVariables 
	}
	
	/** Initializes variable in a tool. */
	override initVariables(AbstractToolDescription it) {
		if (it instanceof TableTool) {
			initTableVariables
		} else {
			super.initVariables(it)
		}
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
	
	/**
     * Creates a creation tool for a line.
     * 
     * @param it container
     * @param line id
     * @param role of the tool
     * @param toolLabel to display
     * @param operation to perform
     * @return new CreateLineTool instance
     */
	def createAddLine(TableDescription owner, String line, String role, String toolLabel, ModelOperation operation) {
		line.createLine(role, toolLabel, operation) => [
			owner.ownedCreateLine += it
		]
	}
	
	/**
     * Creates a creation tool for a line.
     * 
     * @param it container
     * @param line id
     * @param role of the tool
     * @param toolLabel to display
     * @param operation to perform
     * @return new CreateLineTool instance
     */
	def createAddLine(LineMapping owner, String line, String role, String toolLabel, ModelOperation operation) {
		line.createLine(role, toolLabel, operation) => [
			owner.create += it
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
    def createLine(String line, String toolLabel, 
    	Procedure3<EObject, EObject, EObject> action
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
    def createLine(String line, String role, String toolLabel, 
    	Procedure3<EObject, EObject, EObject> action
	) {
		line.createLine(toolLabel, role, context.expression(CREATE_LINE_PARAMS, action).toOperation)
	}
	
    /**
     * Creates a creation tool for a line.
     * 
     * @param line name
     * @param toolLabel to display
     * @param action(root target, line target, line view)
     * @return new CreateLineTool instance
     */
    def createAddLine(TableDescription owner, String line, String toolLabel, 
    	Procedure3<EObject, EObject, EObject> action
	) {
		line.createLine("", toolLabel, action) => [
			owner.ownedCreateLine += it
		]
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
    def createAddLine(TableDescription owner, String line, String role, String toolLabel, 
    	Procedure3<EObject, EObject, EObject> action
	) {
		val op = context.expression(CREATE_LINE_PARAMS, action).toOperation
		line.createLine(toolLabel, role, op) => [
			owner.ownedCreateLine += it
		]
	}
	
    /**
     * Creates a creation tool for a line.
     * 
     * @param line name
     * @param toolLabel to display
     * @param action(root target, line target, line view)
     * @return new CreateLineTool instance
     */
    def createAddLine(LineMapping owner, String line, String toolLabel, 
    	Procedure3<EObject, EObject, EObject> action
	) {
		line.createLine("", toolLabel, action) => [
			owner.create += it
		]
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
    def createAddLine(LineMapping owner, String line, String role, String toolLabel, 
    	Procedure3<EObject, EObject, EObject> action
	) {
		val op = context.expression(CREATE_LINE_PARAMS, action).toOperation
		line.createLine(toolLabel, role, op) => [
			owner.create += it
		]
	}
	
	
	/** Sets the foreground style. */
	def setForeground(StyleUpdater it, (ForegroundStyleDescription)=>void descr) {
		defaultForeground = descr !== null
			? ForegroundStyleDescription.create[
				initForeground
				descr.apply(it)
			]
	}
	
	/** Sets the foreground style for specified condition. */
	def foregroundIf(StyleUpdater owner, String condition, (ForegroundStyleDescription)=>void descr) {
		Objects.requireNonNull(descr)
		ForegroundConditionalStyle.create[
			predicateExpression = condition
			style = ForegroundStyleDescription.create[
				initForeground
				descr.apply(it)
			]
		] => [
			owner.foregroundConditionalStyle += it
		]
	}

	/** Sets the background Color. */
	def setBackground(StyleUpdater owner, ColorDescription color) {
		owner.defaultBackground = BackgroundStyleDescription.create[
			backgroundColor = color
		]
	}
	
	/** Set the background Color for specified condition. */
	def backgroundIf(StyleUpdater owner, String condition, ColorDescription color) {
		BackgroundConditionalStyle.create[
			predicateExpression = condition
			style = BackgroundStyleDescription.create[
				backgroundColor = color
			]
		] => [
			owner.backgroundConditionalStyle += it
		]
	}
	
	/**
	 * Initializes a Style with common default values.
	 * 
	 * @param <T> type of style
	 * @param type of Style
	 * @param init custom initialization of style
	 * @return created Style
	 */
	def void initForeground(ForegroundStyleDescription it) {
		labelSize = 9 // ODesign is provide 12, but eclipse default is Segoe:9
		foreGroundColor = DColor.black.regular
	}
	
}
