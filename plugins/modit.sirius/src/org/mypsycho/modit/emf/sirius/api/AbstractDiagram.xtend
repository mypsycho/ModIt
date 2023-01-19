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
import org.eclipse.sirius.diagram.description.BooleanLayoutOption
import org.eclipse.sirius.diagram.description.CustomLayoutConfiguration
import org.eclipse.sirius.diagram.description.DiagramDescription
import org.eclipse.sirius.diagram.description.DoubleLayoutOption
import org.eclipse.sirius.diagram.description.EnumLayoutOption
import org.eclipse.sirius.diagram.description.EnumLayoutValue
import org.eclipse.sirius.diagram.description.EnumSetLayoutOption
import org.eclipse.sirius.diagram.description.IntegerLayoutOption
import org.eclipse.sirius.diagram.description.Layer
import org.eclipse.sirius.diagram.description.LayoutOption
import org.eclipse.sirius.diagram.description.LayoutOptionTarget
import org.eclipse.sirius.diagram.description.StringLayoutOption

/**
 * Adaptation of Sirius model into Java and EClass reflections API for Diagrams.
 * 
 * @author nicolas.peransin
 */
abstract class AbstractDiagram extends AbstractDiagramPart<DiagramDescription> {

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
	new(AbstractGroup parent, String descrLabel, Class<? extends EObject> domain) {
		super(DiagramDescription, parent, descrLabel)
		
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
	new(AbstractGroup parent, String dName, String dLabel, Class<? extends EObject> domain) {
		this(parent, dLabel, domain)
		Objects.nonNull(dName)
		creationTasks.add[
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

    def customLayout(DiagramDescription it, String cfgId, String cfgTitle, LayoutOption... options) {
		layout = CustomLayoutConfiguration.create [
			id = cfgId
			label = cfgTitle
			layoutOptions += options
		]
	}
    
	/**
	 * Provides ELK Layered Layout.
	 * <p>
	 * Official doc: <a href="https://www.eclipse.org/elk/reference/algorithms/org-eclipse-elk-layered.html"
	 * >ELK Layered</a>.
	 * </p>
	 * 
	 * @param it container
	 * @param options of layout
	 * @return Custom Layout Configuration
	 */
	def elkLayered(DiagramDescription it, LayoutOption... options) {
		customLayout("org.eclipse.elk.layered", "ELK Layered", options)
	}
	
	/**
	 * Provides ELK Tree Layout.
	 * <p>
	 * Official doc: <a href="https://www.eclipse.org/elk/reference/algorithms/org-eclipse-elk-mrtree.html"
	 * >ELK Mr. Tree</a>.
	 * </p>
	 * 
	 * @param it container
	 * @param options of layout
	 * @return Custom Layout Configuration
	 */
	def elkMrTree(DiagramDescription it, LayoutOption... options) {
		customLayout("org.eclipse.elk.mrtree", "ELK Mr. Tree", options)
	}

	protected def <T extends LayoutOption> elkOption(Class<T> type, 
		String key, 
		LayoutOptionTarget[] targets
	) {
		type.create[
			id = "org.eclipse.elk." + key
			it.targets += targets
		]
	}

	def elkBool(String key, boolean param, LayoutOptionTarget... targets) {
		BooleanLayoutOption.elkOption(key, targets) => [
			value = param
		]
	}

	def elkDouble(String key, double param, LayoutOptionTarget... targets) {
		DoubleLayoutOption.elkOption(key, targets) => [
			value = param
		]
	}

	def elkEnum(String key, String param, LayoutOptionTarget... targets) {
		EnumLayoutOption.elkOption(key, targets) => [
			value = EnumLayoutValue.create [ name = param ]
		]
	}

	def elkEnums(String key, String names, LayoutOptionTarget... targets) {
		EnumSetLayoutOption.elkOption(key, targets) => [
			if (names !== null && !names.empty) {
				values += names.split(",")
					.map[ value | EnumLayoutValue.create [ name = value ] ]
			}
		]
	}

	def elkInt(String key, int param, LayoutOptionTarget... targets) {
		IntegerLayoutOption.elkOption(key, targets) => [
			value = param
		]
	}

	def elkString(String key, String param, LayoutOptionTarget... targets) {
		StringLayoutOption.elkOption(key, targets) => [
			it.value = param
		]
	}

	static val LayoutOptionTarget[] NO_TARGET = {} 
	def elkBool(String key, boolean value) {
		key.elkBool(value, NO_TARGET)
	}

	def elkDouble(String key, double value) {
		key.elkDouble(value, NO_TARGET)
	}

	def elkEnum(String key, String value) {
		key.elkEnum(value, NO_TARGET)
	}

	def elkEnums(String key, String values) {
		key.elkEnums(values, NO_TARGET)
	}

	def elkInt(String key, int value) {
		key.elkInt(value, NO_TARGET)
	}

	def elkString(String key, String value) {
		key.elkString(value, NO_TARGET)
	}

}
