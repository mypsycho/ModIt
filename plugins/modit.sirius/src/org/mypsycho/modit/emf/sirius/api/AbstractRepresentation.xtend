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

import java.util.ArrayList
import java.util.List
import javax.sound.sampled.Port
import org.eclipse.emf.ecore.EObject
import org.eclipse.sirius.diagram.description.tool.DirectEditLabel
import org.eclipse.sirius.viewpoint.description.JavaExtension
import org.eclipse.sirius.viewpoint.description.RepresentationDescription
import org.eclipse.sirius.viewpoint.description.SystemColor
import org.eclipse.sirius.viewpoint.description.Viewpoint
import org.eclipse.sirius.viewpoint.description.style.BasicLabelStyleDescription
import org.eclipse.sirius.viewpoint.description.tool.AbstractToolDescription
import org.eclipse.sirius.viewpoint.description.tool.Case
import org.eclipse.sirius.viewpoint.description.tool.Default
import org.eclipse.sirius.viewpoint.description.tool.InitialOperation
import org.eclipse.sirius.viewpoint.description.tool.ModelOperation
import org.eclipse.sirius.viewpoint.description.tool.OperationAction
import org.eclipse.sirius.viewpoint.description.tool.PasteDescription
import org.eclipse.sirius.viewpoint.description.tool.SelectionWizardDescription
import org.eclipse.sirius.viewpoint.description.tool.Switch
import org.eclipse.sirius.viewpoint.description.tool.ToolDescription
import org.eclipse.sirius.viewpoint.description.tool.Unset

import static extension org.mypsycho.modit.emf.sirius.api.SiriusDesigns.*

/**
 * Adaptation of Sirius model into Java and EClass reflections API
 * for representation.
 * 
 * @author nicolas.peransin
 */
abstract class AbstractRepresentation<T extends RepresentationDescription> extends AbstractEdition {

	val Class<T> contentType
	
	protected val List<(T)=>void> creationTasks = new ArrayList(5)

	/**
	 * Creates a factory for a representation description.
	 * 
	 * @param parent context of representation
	 */
	new(Class<T> type, AbstractGroup parent, String dLabel) {
		super(parent)
	
		contentType = type
		creationTasks.add[ label = dLabel ] // xtend fails to infere '+=' .
	}
	
	/**
	 * Gets a reference from current representation.
	 * 
	 * @param <R> result type
	 * @param type to return
	 * @param path in representation
	 */
	def <R extends EObject> R ref(Class<R> type, (T)=>R path) {
		factory.ref(type, contentAlias) [ path.apply(it as T) ]
	}
	
	/**
	 * Creates a representation description
	 * 
	 * @return new description
	 */
	def T createContent() {
		contentType.createAs(contentAlias) [
			creationTasks.forEach[task | task.apply(it) ]
			name = contentAlias
			metamodel += context.businessPackages
			initContent
		]
	}
	
	/**
	 * Initializes the content of the created representation.
	 * 
	 * @param it to initialize
	 */
	def void initContent(T it)
	
    protected def void addService(EObject it, Class<?> service) {
        eContainer(Viewpoint).ownedJavaExtensions += 
            JavaExtension.create[ qualifiedClassName = service.name ]
    }

	/**
	 * Creates a Style with common default values.
	 * 
	 * @param <T> type of style
	 * @param it type of Style
	 * @param init custom initialization of style
	 * @return created Style
	 */
	protected def <T extends BasicLabelStyleDescription> T createStyle(Class<T> it, (T)=>void init) {
		create[
			initDefaultStyle
			init?.apply(it)
		]
	}
	
	/**
	 * Creates a Style with common default values.
	 * 
	 * @param <T> type of style
	 * @param type of Style
	 * @return created Style
	 */
	protected def <T extends BasicLabelStyleDescription> T createStyle(Class<T> it) {
		// explicit it is required to avoid infinite loop
		it.createStyle(null)
	}
	
	/**
	 * Initializes a Style with common default values.
	 * 
	 * @param <T> type of style
	 * @param type of Style
	 * @param init custom initialization of style
	 * @return created Style
	 */
	protected def void initDefaultStyle(BasicLabelStyleDescription it) {
		labelSize = 10 // ODesign is provide 12, but eclipse default is Segoe:9
		labelColor = SystemColor.extraRef("color:black")
		
		labelExpression = context.itemProviderLabel
	}
	
	/**
	 * Sets the operation for provided tool.
	 * <p>
	 * This class unifies the initialOperation declaration of sub-class tool.
	 * </p>
	 * @param it tool to set
	 * @param value operation to perform
	 */
	protected def setOperation(AbstractToolDescription it, ModelOperation value) {
		switch(it) {
			OperationAction: initialOperation = value.toTool
			ToolDescription: initialOperation = InitialOperation.create [ firstModelOperations = value ]
			PasteDescription: initialOperation = value.toTool
			SelectionWizardDescription: initialOperation = value.toTool
			DirectEditLabel: initialOperation = value.toTool
			
			default: throw new UnsupportedOperationException
		}
	}

	
	protected def createCases(Pair<String, ? extends ModelOperation>... subCases) {
		Switch.create[
			cases += subCases.map[
				val condition = key
				val operation = value
				Case.create [
					conditionExpression = condition.trimAql
					subModelOperations += operation
				]
			]
			
			^default = Default.create[]
		]
	}
	
	protected def setDefault(Switch it, ModelOperation operation) {
		^default = Default.create[
			subModelOperations += operation
		]
		it		
	}


}
