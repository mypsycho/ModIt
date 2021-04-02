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
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.sirius.viewpoint.description.tool.ChangeContext
import org.eclipse.sirius.viewpoint.description.tool.InitialOperation
import org.eclipse.sirius.viewpoint.description.tool.ModelOperation
import org.eclipse.sirius.viewpoint.description.tool.RemoveElement
import org.eclipse.sirius.viewpoint.description.tool.SetValue
import org.mypsycho.modit.emf.EModIt
import org.mypsycho.modit.emf.sirius.SiriusModelProvider

/**
 * Adaptation of Sirius model into Java and EClass reflections API
 * for representation.
 * 
 * @author nicolas.peransin
 */
abstract class AbstractEdition {

	/** Main container */
	protected val extension AbstractGroup context
	
	/** Factory of Sirius elements */
	protected val extension EModIt factory

	/**
	 * Alias root for the identified elements.
	 * <p>
	 * Default implementation is based on class name.
	 * </p>
	 */
	protected var String contentAlias

	/**
	 * Create a factory for a diagram description
	 * 
	 * @param parent of diagram
	 */
	new(AbstractGroup parent) {
		this.context = parent
		this.factory = parent.factory
				
		contentAlias = if (!class.anonymousClass) class.simpleName
			else {
				var fullname = class.name
				fullname.substring(
					fullname.lastIndexOf(".") + 1, 
					fullname.lastIndexOf("$")
				)
			}
	}

	/**
	 * Returns a reference from extra elements.
	 * 
	 * @param type of referenced element (strict, no inheritance)
	 * @param key of reference
	 * @return element
	 */
	def <T> T extraRef(Class<T> type, String key) {
		context.extraRef(type, key)
	}
	
	
	/**
	 * Creates an identification with provided category.
	 * <p>
	 * This method has no side-effect, no id is reserved.
	 * </p>
	 * 
	 * @param cat of identification
	 * @param path 
	 */
	protected def String id(EClass cat, String path) {
		cat.name.id(path)
	}
	
		
	/**
	 * Creates an identification with provided category.
	 * <p>
	 * This method has no side-effect, no id is reserved.
	 * </p>
	 * 
	 * @param cat of identification
	 * @param path 
	 */
	protected def String id(Enum<?> cat, String path) {
		cat.name.id(path)
	}
	
	/**
	 * Creates an identification with provided category.
	 * <p>
	 * This method has no side-effect, no id is reserved.
	 * </p>
	 * 
	 * @param cat of identification
	 * @param path 
	 */
	protected def String id(String category, String path) {
		'''«category»:«contentAlias».«Objects.requireNonNull(path).toLowerCase.replace(" ", "_")»'''
	}
	
	/**
	 * Create a string from expression from a sequence of parameter names.
	 * 
	 * @param params names
	 * @return string of parameters
	 */
	static def params(String... params) { 
		params.join(SiriusModelProvider.PARAM_SEP)
	}
	
	/**
	 * Create a string from expression from a sequence of parameter names.
	 * 
	 * @param params names
	 * @return string of parameters
	 */
	static def params(Object... params) { 
		params.join(SiriusModelProvider.PARAM_SEP)
	}
	
	/**
	 * Create an ChangeContext for an expression.
	 * 
	 * @param expression
	 * @return ChangeContext
	 */
    protected def toOperation(String expression) {
        ChangeContext.create[ browseExpression = expression ]
    }
    
    protected def toTool(ModelOperation operation) {
        InitialOperation.create[
            firstModelOperations = operation
        ]
    }
    
    
    /**
     * Creates a Set operation for provided feature.
     * 
     * @param featureExpr expression to identify a feature (constant or aql)
     * @param expression of value
     * @return a new SetValue
     */
    def setter(String featureExpr, String value) {
        SetValue.create[
            featureName = featureExpr
            valueExpression = value
        ]
    }
        
    /**
     * Creates a Set operation for provided feature.
     * 
     * @param feature to set
     * @param expression of value
     * @return a new SetValue
     */
    protected def SetValue setter(EStructuralFeature feature, String expression) {
        feature.name.setter(expression)
    }

    /**
     * Creates a Set operation for provided feature using default Properties variable.
     * 
     * @param feature to set
     * @return a new SetValue
     */
    protected def SetValue setter(EStructuralFeature feature) {
        feature.setter("var:newValue")
    }

    
    /**
     * Creates a Set operation for provided feature.
     * 
     * @param feature to set
     * @param expression of value
     * @return a new SetValue
     */
    protected def <T> SetValue setter(EStructuralFeature feature, 
            Functions.Function1<? extends EObject, ?>  expr) {
        SetValue.create[
            featureName = feature.name
            valueExpression = expression(expr)
        ]
    }
    
    /**
     * Creates a remove element operation operation for provided feature.
     * 
     * @param feature to set
     * @param expression of value
     * @return a new SetValue
     */
    protected def removeElement(String expression) {
        expression.toOperation.andThen[
            subModelOperations += RemoveElement.create[]
        ]
    }
    
	
}
