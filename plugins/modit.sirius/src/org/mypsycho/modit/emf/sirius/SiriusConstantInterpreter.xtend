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
package org.mypsycho.modit.emf.sirius

import java.util.Collection
import java.util.Collections
import java.util.HashMap
import java.util.Map
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.util.ECrossReferenceAdapter
import org.eclipse.sirius.common.tools.api.interpreter.IInterpreter
import org.eclipse.sirius.common.tools.api.interpreter.IInterpreterContext
import org.eclipse.sirius.common.tools.api.interpreter.IInterpreterProvider
import org.eclipse.sirius.ecore.extender.business.api.accessor.MetamodelDescriptor
import org.eclipse.sirius.ecore.extender.business.api.accessor.ModelAccessor

/**
 * Provide an interpreter to Sirius to handle constant value.
 * <p>
 * This is the default option of sirius but when using business terms, 
 * we do not want complex escape.
 * </p>
 */
class SiriusConstantInterpreter implements IInterpreter {
	
	static class Provider implements IInterpreterProvider {
				
		override createInterpreter() { new SiriusConstantInterpreter() }
		
		override provides(String it) { applicable }
		
	}
		
	static val String PROTOCOL = "cst:"
	
	static def isApplicable(String it) { it !== null && startsWith(PROTOCOL) }
	
	static def String toExpression(String value) { PROTOCOL + value }
	
	// maybe this is useless
	val Map<String, Object> variables = new HashMap(5)

	override evaluate(EObject target, String expression) {
		expression.substring(PROTOCOL.length, expression.length)
	}
	
	override provides(String it) { applicable }
	
	override getConverter() { ModitSiriusPlugin.DEFAULT_CONVERTER }
	
	override getImports() { Collections.emptyList }
	
	override getPrefix() { null }
			
	override getVariablePrefix() { null }
	
	override getVariable(String name) { variables.get(name) }

	override getVariables() { variables }
	
	override setVariable(String name, Object value) { variables.put(name, value) }
	
	override unSetVariable(String name) { variables.remove(name) }
	
	override clearVariables() { variables.clear }
	
	override supportsValidation() { false }
	
	override validateExpression(IInterpreterContext context, String it) { Collections.emptyList }
	
	override dispose() { clearVariables }

	override setProperty(Object key, Object value) { /* unused */ }
	
	override setCrossReferencer(ECrossReferenceAdapter crossReferencer) { /* unused */ }

	override addImport(String dependency) { /* unused */ }
			
	override removeImport(String dependency) { /* unused */}
	
	override clearImports() { /* unused */ }
	
	override setModelAccessor(ModelAccessor modelAccessor) { /* unused */ }

 	override activateMetamodels(Collection<MetamodelDescriptor> metamodels) { /* unused */ }

}