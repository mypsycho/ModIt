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

import org.eclipse.emf.ecore.EObject
import org.eclipse.sirius.diagram.description.tool.ContainerCreationDescription
import org.eclipse.sirius.diagram.description.tool.NodeCreationVariable
import org.eclipse.sirius.diagram.sequence.description.CoveredLifelinesVariable
import org.eclipse.sirius.diagram.sequence.description.MessageEndVariable
import org.eclipse.sirius.diagram.sequence.description.SequenceDiagramDescription
import org.eclipse.sirius.diagram.sequence.description.tool.CoveringElementCreationTool
import org.eclipse.sirius.diagram.sequence.description.tool.InstanceRoleCreationTool
import org.eclipse.sirius.diagram.sequence.description.tool.InstanceRoleReorderTool
import org.eclipse.sirius.diagram.sequence.description.tool.OrderedElementCreationTool
import org.eclipse.sirius.diagram.sequence.description.tool.ReorderTool
import org.eclipse.sirius.viewpoint.description.tool.AbstractToolDescription
import org.eclipse.sirius.viewpoint.description.tool.ContainerViewVariable
import org.eclipse.sirius.viewpoint.description.tool.ElementVariable
import org.eclipse.sirius.viewpoint.description.tool.ModelOperation
import org.eclipse.sirius.diagram.sequence.description.tool.StateCreationTool

/**
 * Adaptation of Sirius model into Java and EClass reflections API for Diagrams.
 * 
 * @author nicolas.peransin
 */
abstract class SiriusSequenceDiagram extends AbstractBaseDiagram<SequenceDiagramDescription> {


	/**
	 * Creates a factory for a diagram description.
	 * 
	 * @param parent of diagram
	 * @param descrLabel displayed on representation groups
	 * @param domain class of diagram
	 */
	new(SiriusVpGroup parent, String descrLabel, Class<? extends EObject> domain) {
		super(SequenceDiagramDescription, parent, descrLabel, domain)
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
		changeName(dName)
	}

	override setOperation(AbstractToolDescription it, ModelOperation value) {
		switch(it) {
			InstanceRoleReorderTool: instanceRoleMoved = value.toTool
			ReorderTool: onEventMovedOperation = value.toTool
			default: super.setOperation(it, value)
		}
	}

	override initVariables(AbstractToolDescription it) {
		if (it instanceof CoveringElementCreationTool) {
			coveredLifelines = CoveredLifelinesVariable.create("coveredLifelines")
		}
		switch(it) {
			InstanceRoleCreationTool: {
				predecessor = ElementVariable.create("predecessor")
				super.initVariables(it)
			}
			InstanceRoleReorderTool: {
				predecessorBefore = ElementVariable.create("predecessorBefore")
				predecessorAfter = ElementVariable.create("predecessorAfter")
			}
			ReorderTool: {
				startingEndPredecessorBefore = MessageEndVariable.create("startingEndPredecessorBefore")
				startingEndPredecessorAfter = MessageEndVariable.create("startingEndPredecessorAfter")
				finishingEndPredecessorBefore = MessageEndVariable.create("finishingEndPredecessorBefore")
				finishingEndPredecessorAfter = MessageEndVariable.create("finishingEndPredecessorAfter")
			}
			OrderedElementCreationTool: {
				startingEndPredecessor = MessageEndVariable.create("startingEndPredecessor")
				finishingEndPredecessor = MessageEndVariable.create("finishingEndPredecessor")
				// Mutli-inheritance
				if (it instanceof ContainerCreationDescription) {
					variable = NodeCreationVariable.create("variable")
					viewVariable = ContainerViewVariable.create("viewVariable")
				} else if (it instanceof StateCreationTool) {
					variable = NodeCreationVariable.create("variable")
					viewVariable = ContainerViewVariable.create("viewVariable")
				} else {
					super.initVariables(it)
				}
			}
			default:
				super.initVariables(it)
		}
	}
}
