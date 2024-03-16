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
import org.eclipse.sirius.table.tools.api.interpreter.IInterpreterSiriusTableVariables
import org.eclipse.sirius.tree.description.ConditionalTreeItemStyleDescription
import org.eclipse.sirius.tree.description.PrecedingSiblingsVariables
import org.eclipse.sirius.tree.description.StyleUpdater
import org.eclipse.sirius.tree.description.TreeDescription
import org.eclipse.sirius.tree.description.TreeItemContainerDropTool
import org.eclipse.sirius.tree.description.TreeItemCreationTool
import org.eclipse.sirius.tree.description.TreeItemDeletionTool
import org.eclipse.sirius.tree.description.TreeItemEditionTool
import org.eclipse.sirius.tree.description.TreeItemMapping
import org.eclipse.sirius.tree.description.TreeItemMappingContainer
import org.eclipse.sirius.tree.description.TreeItemStyleDescription
import org.eclipse.sirius.tree.description.TreeItemTool
import org.eclipse.sirius.tree.description.TreeVariable
import org.eclipse.sirius.viewpoint.description.IdentifiedElement
import org.eclipse.sirius.viewpoint.description.SystemColor
import org.eclipse.sirius.viewpoint.description.style.BasicLabelStyleDescription
import org.eclipse.sirius.viewpoint.description.tool.ContainerViewVariable
import org.eclipse.sirius.viewpoint.description.tool.DropContainerVariable
import org.eclipse.sirius.viewpoint.description.tool.ElementDropVariable
import org.eclipse.sirius.viewpoint.description.tool.ModelOperation
import org.eclipse.sirius.viewpoint.description.style.LabelStyleDescription

/**
 * Class adapting Sirius model into Java and EClass reflection s
 * for tables.
 * 
 * @author nicolas.peransin
 */
abstract class SiriusTree extends AbstractTypedEdition<TreeDescription> {

	/** Namespaces for identification */
	enum Ns { // namespace for identication
		item
	}

	protected val Class<? extends EObject> domain
	
	/**
	 * Creates a factory for a diagram description.
	 * 
	 * @param parent of diagram
	 * @param descrLabel displayed on representation groups
	 * @param domain class of diagram
	 */
	new(SiriusVpGroup parent, String descrLabel, Class<? extends EObject> domain) {
		super(TreeDescription, parent, descrLabel)
		this.domain = domain
		creationTasks.add[
			domainClass = context.asDomainClass(domain)
		]
	}
		
	/**
	 * Creates a factory for a diagram description.
	 * <p>
	 * Constructor for reverse code or variants.
	 * </p>
	 * 
	 * @param parent of diagram
	 * @param dName of this diagram
	 * @param descrLabel displayed on representation groups
	 * @param domain class of diagram
	 */
	new(SiriusVpGroup parent, String dName, String dLabel, Class<? extends EObject> domain) {
		this(parent, dLabel, domain)
		Objects.nonNull(dName)
		creationTasks.add[
			name = dName
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
	def void setDomainClass(TreeItemMapping it, Class<? extends EObject> type) {
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
    def void setDomainClass(TreeDescription it, EClass type) {
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
	def void setSemanticCandidates(TreeItemMapping it, EReference ref) {
		semanticCandidatesExpression = SiriusDesigns.encode(ref)
	}

	/**
	 * Sets a mapping as not removable.
	 * 
	 * @param it mapping
	 */
	def void noDelete(TreeItemMapping it) {
		delete = TreeItemDeletionTool.create[
			name = "del:" + mapping.name // no change it will be triggered.
			precondition = SiriusDesigns.NEVER
		]
	}
	

	def setOperation(TreeItemTool it, ModelOperation operation) {
		// For reversing mainly, more precise API exists.
		firstModelOperation = operation
	}

	
	@SuppressWarnings("restriction")
	def initVariables(TreeItemTool it) {
		// Inspired from TableToolVariables but is refactored between 6/7.
		variables += switch(it) {
			TreeItemContainerDropTool: #[
			]
			TreeItemCreationTool: #[ // column, crosscolumn, line
				IInterpreterSiriusTableVariables.ELEMENT,
				IInterpreterSiriusTableVariables.CONTAINER,
				IInterpreterSiriusTableVariables.ROOT
			]
			// TreeItemDragTool: #[ Deprecated

			TreeItemEditionTool: #[
				// ??
			]
			TreeItemDeletionTool: #[ // line, column
				IInterpreterSiriusTableVariables.ELEMENT,
				IInterpreterSiriusTableVariables.ROOT
			]
			default: #[]
		}.map[ vName | TreeVariable.create[ name = vName ] ]
		
		if (it instanceof TreeItemContainerDropTool) {
			oldContainer = DropContainerVariable.create("oldContainer")
			newContainer = DropContainerVariable.create("newContainer")
			element = ElementDropVariable.create("element")
			newViewContainer = ContainerViewVariable.create("newViewContainer")
			precedingSiblings = PrecedingSiblingsVariables.create("precedingSiblings")
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
    def setDelete(TreeItemMapping parent, ModelOperation action) {
        parent.delete(parent.name + ":delete") [
            label = "Delete"
            operation = action
        ]
    }

	override initDefaultStyle(BasicLabelStyleDescription it) {
		labelColor = SystemColor.extraRef("color:black")
		if (it instanceof TreeItemStyleDescription) {
			backgroundColor = SystemColor.extraRef("color:white")
		}
	}

	/**
	 * Set the foreground style.
	 */
	def setStyle(StyleUpdater it, (TreeItemStyleDescription)=>void descr) {
		Objects.requireNonNull(descr)
		defaultStyle = TreeItemStyleDescription.create[
			initDefaultStyle
			descr.apply(it)
		]
	}
	
	/**
	 * Set the foreground style for specified condition.
	 */	
	def styleIf(StyleUpdater owner, String condition, (TreeItemStyleDescription)=>void descr) {
		Objects.requireNonNull(descr)
		ConditionalTreeItemStyleDescription.create[
			predicateExpression = condition
			style = TreeItemStyleDescription.create[
				initDefaultStyle
				descr.apply(it)
			]
		] => [
			owner.conditionalStyles += it
		]
	}

	override protected <R extends IdentifiedElement> createAs(Class<R> type, Enum<?> cat, String eName, (R)=>void init) {
		super.<R>createAs(type, cat, eName) [
			if (type == TreeItemMapping) {
				cat.id(treePath(it as TreeItemMapping)).alias(it)
			}
			init?.apply(it)
		]
	}
	
	
	def subItem(TreeItemMappingContainer owner, String name, String domain, (TreeItemMapping)=>void init) {
		TreeItemMapping.createAs(Ns.item, name) [
			domainClass = domain
			init?.apply(it)
		] => [
			owner.subItemMappings += it
		]
	}
	
	def drop(TreeItemMappingContainer owner, String name, (TreeItemContainerDropTool)=>void init) {
		TreeItemContainerDropTool.create(name) [
			initVariables
			init?.apply(it)
		] => [
			owner.dropTools += it
		]
	}
	
	def itemCreate(TreeItemMapping owner, String name, (TreeItemCreationTool)=>void init) {
		TreeItemCreationTool.create(name) [
			initVariables
			init?.apply(it)
		] => [
			owner.create += it
		]
	}
	
	def itemCreate(TreeDescription owner, String name, (TreeItemCreationTool)=>void init) {
		TreeItemCreationTool.create(name) [
			initVariables
			init?.apply(it)
		] => [
			owner.createTreeItem += it
		]
	}
	
	def delete(TreeItemMapping owner, String name, (TreeItemDeletionTool)=>void init) {
		owner.delete = TreeItemDeletionTool.create(name) [
			initVariables
			init?.apply(it)
		]
	}
	
	def edit(TreeItemMapping owner, String name, (TreeItemEditionTool)=>void init) {
		owner.directEdit = TreeItemEditionTool.create(name) [
			initVariables
			init?.apply(it)
		]
	}
	
	static def String treePath(TreeItemMapping it) {
		val parent = eContainer
		parent instanceof TreeItemMapping
			? '''«parent.treePath»/«name»'''
			: name
	}
	
	
}
