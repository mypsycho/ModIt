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
import java.util.List
import java.util.Map
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.util.ECrossReferenceAdapter
import org.eclipse.sirius.common.tools.api.interpreter.EvaluationException
import org.eclipse.sirius.common.tools.api.interpreter.IInterpreter
import org.eclipse.sirius.common.tools.api.interpreter.IInterpreterContext
import org.eclipse.sirius.common.tools.api.interpreter.IInterpreterProvider
import org.eclipse.sirius.ecore.extender.business.api.accessor.MetamodelDescriptor
import org.eclipse.sirius.ecore.extender.business.api.accessor.ModelAccessor

/**
 * Provide a interpreter to memory model.
 * <p>
 * Aql cannot be used with java extension as the Sirius engine checks the model 
 * physically (why ??) to register project in classpath of extensions.
 * </p> 
 */
class SiriusModelInterpreter implements IInterpreter {
	
	static class Provider implements IInterpreterProvider {
				
		override createInterpreter() { new SiriusModelInterpreter() }
		
		override provides(String it) { applicable }
	}
	
	static val char SEP = ':'
	
	static val String PROTOCOL = "modit" + SEP
	
	static def isApplicable(String it) {
		it !== null && startsWith(PROTOCOL)
	}
	
	static def String toExpression(SiriusModelProvider it, int methodId, String params) {
		val resId = if (id == SiriusModelProvider.RESOURCE_MODE) class.name else id 

		// Warning: no space between Sequence and '{'
		PROTOCOL + resId + SEP + methodId + SEP + params
	}
	
	
	val Map<String, Object> variables = new HashMap(5)
		
	protected def <P0, P1, P2, P3, P4, P5> Object evaluate(int resID, int methodID, List<?> values) {
		val it = ModitSiriusPlugin.instance.registry.getProvider(resID).apply(methodID)
		it.getClass().getInterfaces()
		switch (it) {
			// functions
			Functions.Function1<P0, ?> :                     apply(values.get(0) as P0)
			Functions.Function2<P0, P1, ?> :                 apply(values.get(0) as P0, values.get(1) as P1)
			Functions.Function3<P0, P1, P2, ?> :             apply(values.get(0) as P0, values.get(1) as P1, values.get(2) as P2)
			Functions.Function4<P0, P1, P2, P3, ?> :         apply(values.get(0) as P0, values.get(1) as P1, values.get(2) as P2, values.get(3) as P3)
			Functions.Function5<P0, P1, P2, P3, P4, ?> :     apply(values.get(0) as P0, values.get(1) as P1, values.get(2) as P2, values.get(3) as P3, values.get(4) as P4)
			Functions.Function6<P0, P1, P2, P3, P4, P5, ?> : apply(values.get(0) as P0, values.get(1) as P1, values.get(2) as P2, values.get(3) as P3, values.get(4) as P4, values.get(5) as P5)
			default: {
				switch (it) {
					// procedures return void.
					Procedures.Procedure1<P0> :                     apply(values.get(0) as P0)
					Procedures.Procedure2<P0, P1> :                 apply(values.get(0) as P0, values.get(1) as P1)
					Procedures.Procedure3<P0, P1, P2> :             apply(values.get(0) as P0, values.get(1) as P1, values.get(2) as P2)
					Procedures.Procedure4<P0, P1, P2, P3> :         apply(values.get(0) as P0, values.get(1) as P1, values.get(2) as P2, values.get(3) as P3)
					Procedures.Procedure5<P0, P1, P2, P3, P4> :     apply(values.get(0) as P0, values.get(1) as P1, values.get(2) as P2, values.get(3) as P3, values.get(4) as P4)
					Procedures.Procedure6<P0, P1, P2, P3, P4, P5> : apply(values.get(0) as P0, values.get(1) as P1, values.get(2) as P2, values.get(3) as P3, values.get(4) as P4, values.get(5) as P5)
					default : throw new EvaluationException("Unsupported implementation: " + getClass?.toString)
				}
				null
			}
		}
	}
	

	static def segmentAt(String it, int from) {
		val position = indexOf(SEP, from)
		if (position == -1) throw new EvaluationException("Invalid format: " + it)
		try {
			Integer.parseInt(substring(from, position)) -> (position + 1)
		} catch (NumberFormatException nbe) {
			 throw new EvaluationException("Invalid id: " + it)
		}
	}
	
	override evaluate(EObject target, String expression) {
		val resId = expression.segmentAt(PROTOCOL.length)
		val methodId = expression.segmentAt(resId.value)
		val values = expression.substring(methodId.value)
			.split(SiriusModelProvider.PARAM_SEP)
			.map[ 
				if (equals(SiriusModelProvider.DEFAULT_INSTANCE)) target // ??
				else variables.get(it)
			]
		
		try {
			val result = evaluate(resId.key, methodId.key, values) // AQL handle collection but not iterable provided by xtend.
			(if (result instanceof Iterable) if (!(result instanceof Collection)) result.toList) ?: result
			
		} catch (ClassCastException cce) {
			throw new EvaluationException("Type mismatch", cce)
		}
	}
	
	override provides(String it) { applicable }
	
	override getConverter() { ModitSiriusPlugin.DEFAULT_CONVERTER }
	
	override getImports() { Collections.emptyList }
	
	override getPrefix() { null }
			
	override getVariablePrefix() { null }
	
	override getVariable(String name) { variables.get(name) }

	override getVariables() { variables }
	
	override setVariable(String name, Object value) {
		variables.put(name, value)
	}
	
	override unSetVariable(String name) {
		variables.remove(name)
	}
	
	override clearVariables() {
		variables.clear
	}
	
	
	override supportsValidation() { false }
	
	override validateExpression(IInterpreterContext context, String it) { 
		Collections.emptyList
	}
	
	override dispose() {
		clearVariables
	}

	override setProperty(Object key, Object value) { /* unused */ }
	
	override setCrossReferencer(ECrossReferenceAdapter crossReferencer) { /* unused */ }

	override addImport(String dependency) { /* unused */ }
			
	override removeImport(String dependency) { /* unused */}
	
	override clearImports() { /* unused */ }
	
	override setModelAccessor(ModelAccessor modelAccessor) { /* unused */ }

 	override activateMetamodels(Collection<MetamodelDescriptor> metamodels) { /* unused */ }

	
}