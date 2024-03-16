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
import org.eclipse.emf.ecore.EObject
import org.eclipse.sirius.diagram.description.DiagramDescription
import org.eclipse.sirius.diagram.description.DiagramElementMapping
import org.eclipse.sirius.diagram.description.Layer
import org.eclipse.sirius.diagram.description.filter.CompositeFilterDescription
import org.eclipse.sirius.diagram.description.filter.FilterKind
import org.eclipse.sirius.diagram.description.filter.MappingFilter

/**
 * Adaptation of Sirius model into Java and EClass reflections API for Diagrams.
 * 
 * @author nicolas.peransin
 */
abstract class AbstractBaseDiagram<T extends DiagramDescription> extends AbstractDiagramPart<T> {

//	/** Namespaces for identification */
//	enum Ns { // namespace for identication
//		node, creation, drop, del,
//		edge, connect, disconnect, reconnect,
//		operation, section,
//		menu, mitem,
//		show // for filter + layer
//	}
	
	protected val Class<? extends EObject> domain
	
	/**
	 * Creates a factory for a diagram description.
	 * 
	 * @param parent of diagram
	 * @param descrLabel displayed on representation groups
	 * @param domain class of diagram
	 */
	new(Class<T> type, SiriusVpGroup parent, String descrLabel, Class<? extends EObject> domain) {
		super(type, parent, descrLabel)
		
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
	new(Class<T> type, SiriusVpGroup parent, String dName, String dLabel, Class<? extends EObject> domain) {
		this(type, parent, dLabel, domain)
		changeName(dName)
	}
		
	static def <T extends DiagramDescription> void changeName(AbstractBaseDiagram<T> container, String dName) {
		Objects.nonNull(dName)
		container.creationTasks.add[
			name = dName
		]
	}
		
	/**
	 * Initializes the content of the created diagram.
	 * 
	 * @param it to initialize
	 */
	override initContent(DiagramDescription it) {
		defaultLayer = Layer.create[
			name = "Default"
			initContent
		]
	}
	
	/**
	 * Initializes the content of the created diagram.
	 * 
	 * @param it to initialize
	 */
	def void initContent(Layer it)
	
	//
	// Reflection short-cut
	// 

	def filterMapping(FilterKind kind, DiagramElementMapping... dMappings) {
		MappingFilter.create [
			filterKind = kind
			mappings += dMappings
		]
	}

	def allHide(CompositeFilterDescription owner, DiagramElementMapping... mappings) {
		FilterKind.HIDE_LITERAL.filterMapping(mappings) => [
			owner.filters += it
		]
	}

	def allCollapse(CompositeFilterDescription owner, DiagramElementMapping... mappings) {
		FilterKind.COLLAPSE_LITERAL.filterMapping(mappings) => [
			owner.filters += it
		]
	}

	def viewHide(CompositeFilterDescription it, String expression, DiagramElementMapping... mappings) {
		allHide(mappings).andThen[ viewConditionExpression = expression ]
	}

	def viewCollapse(CompositeFilterDescription it, String expression, DiagramElementMapping... mappings) {
		allCollapse(mappings).andThen[ viewConditionExpression = expression ]
	}

	def elementHide(CompositeFilterDescription it, String expression, DiagramElementMapping... mappings) {
		allHide(mappings).andThen[ semanticConditionExpression = expression ]
	}

	def elementCollapse(CompositeFilterDescription it, String expression, DiagramElementMapping... mappings) {
		allCollapse(mappings).andThen[ semanticConditionExpression = expression ]
	}
	
	def filtering(DiagramDescription owner, String name, (CompositeFilterDescription)=> void init) {
		Objects.requireNonNull(init)
		CompositeFilterDescription.create(name) [
			init.apply(it)
		] => [ // Must be reachable (out of init phase)
			owner.filters += it
		]
	} 



}
