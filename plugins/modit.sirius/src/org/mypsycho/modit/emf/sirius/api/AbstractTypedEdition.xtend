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

import java.util.ArrayList
import java.util.List
import org.eclipse.emf.ecore.EObject

/**
 * Adaptation of Sirius model into Java and EClass reflections API
 * for representation.
 * 
 * @author nicolas.peransin
 */
abstract class AbstractTypedEdition<T extends EObject> extends AbstractEdition {

	protected val Class<T> contentType
	
	protected val List<(T)=>void> creationTasks = new ArrayList(5)

	/**
	 * Creates a factory for a representation description.
	 * 
	 * @param type of edition
	 * @param parent context of representation
	 * @param descrLabel displayed on representation groups
	 */
	new(Class<T> type, SiriusVpGroup parent) {
		super(parent)
		contentType = type
	}
		
	/**
	 * Gets a reference from current representation.
	 * 
	 * @param <R> result type
	 * @param type to return
	 * @param path in representation
	 */
	def <R extends EObject> R localRef(Class<R> type, (T)=>R path) {
		factory.ref(type, contentAlias) [ path.apply(it as T) ]
	}
	
	/**
	 * Gets a reference from current representation.
	 * 
	 * @param <R> result type
	 * @param type to return
	 * @param path in representation
	 */
	@Deprecated // use localRef
	def <R extends EObject> R ref(Class<R> type, (T)=>R path) {
		factory.ref(type, contentAlias) [ path.apply(it as T) ]
	}
	
	/** Creates a representation description. */
	def T createContent() {
		contentType.createAs(contentAlias) [
			creationTasks.forEach[task | task.apply(it) ]
			initContent
		]
	}
	
	/** Initializes the content of the created representation. */
	def void initContent(T it)
	
}
