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

import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.sirius.diagram.description.tool.DirectEditLabel
import org.eclipse.sirius.viewpoint.description.IdentifiedElement
import org.eclipse.sirius.viewpoint.description.JavaExtension
import org.eclipse.sirius.viewpoint.description.SystemColor
import org.eclipse.sirius.viewpoint.description.Viewpoint
import org.eclipse.sirius.viewpoint.description.style.BasicLabelStyleDescription
import org.eclipse.sirius.viewpoint.description.tool.AbstractToolDescription
import org.eclipse.sirius.viewpoint.description.tool.Case
import org.eclipse.sirius.viewpoint.description.tool.ChangeContext
import org.eclipse.sirius.viewpoint.description.tool.CreateInstance
import org.eclipse.sirius.viewpoint.description.tool.Default
import org.eclipse.sirius.viewpoint.description.tool.If
import org.eclipse.sirius.viewpoint.description.tool.InitialOperation
import org.eclipse.sirius.viewpoint.description.tool.ModelOperation
import org.eclipse.sirius.viewpoint.description.tool.OperationAction
import org.eclipse.sirius.viewpoint.description.tool.PasteDescription
import org.eclipse.sirius.viewpoint.description.tool.RemoveElement
import org.eclipse.sirius.viewpoint.description.tool.SelectionWizardDescription
import org.eclipse.sirius.viewpoint.description.tool.SetValue
import org.eclipse.sirius.viewpoint.description.tool.Switch
import org.eclipse.sirius.viewpoint.description.tool.ToolDescription
import org.mypsycho.modit.emf.EModIt
import org.mypsycho.modit.emf.sirius.SiriusModelProvider

import static extension org.mypsycho.modit.emf.sirius.api.SiriusDesigns.*

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
				
		contentAlias = parent.getContentAlias(class)
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
	
	//
	// Identification
	//
	
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
	 * Builds an identification with provided category for local element.
	 * <p>
	 * This method has no side-effect, no id is reserved.
	 * </p>
	 * 
	 * @param cat of identification
	 * @param path 
	 */
	protected def String id(String category, String path) {
		category.id(contentAlias, path)
	}
	
	/**
	 * Creates an {@link IdentifiedElement} and initializes it.
	 * 
	 * @param type of IdentifiedElement to instantiate
	 * @param cat category of element
	 * @param eName name of element
	 * @param initializer of the given {@link EObject}
	 */
	protected def <R extends IdentifiedElement> R createAs(Class<R> type, Enum<?> cat, String eName, (R)=>void init) {
		type.createAs(cat.id(eName)) [
			name = eName
			init?.apply(it)
		]
	}
	
//	/**
//	 * Creates an {@link IdentifiedElement} and initializes it.
//	 * 
//	 * @param type of IdentifiedElement to instantiate
//	 * @param eName name of element
//	 * @param initializer of the given {@link EObject}
//	 */
//	protected def <R extends IdentifiedElement> R create(Class<R> type, String eName, (R)=>void init) {
//		type.create [
//			name = eName
//			init?.apply(it)
//		]
//	}

	/**
	 * Builds an identification with provided category for local element.
	 * <p>
	 * This method has no side-effect, no id is reserved.
	 * </p>
	 * <p>
	 * Not deprecated but you should consider 'createAs' or 'ref' method.
	 * </p>
	 * 
	 * @param cat of identification
	 * @param context of element
	 * @param path of element
	 */
	protected def String id(Enum<?> cat, String root, String path) {
		cat.name.id(root, path)
	}
	
	/**
	 * Builds an identification with provided category for local element.
	 * <p>
	 * This method has no side-effect, no id is reserved.
	 * </p>
	 * <p>
	 * Not deprecated by you should consider 'createAs' or 'ref' method.
	 * </p>
	 * 
	 * @param category of identification
	 * @param root of element
	 * @param path of element
	 */
	protected def String id(String category, String root, String path) {
		context.createId(category, root, path)
	}
		
	/**
	 * Builds a proxy to be resolved on 'loadContent' for a local element.
	 * 
	 * @param <R> Type of created proxy
	 * @param type of created proxy
	 * @param category of identification
	 * @param name of element
	 */
	protected def <R extends IdentifiedElement> R localRef(
			Class<R> type, 
			Enum<?> cat, 
			String name) {
		type.ref(contentAlias, cat, name)
	}
	
			
	/**
	 * Builds an id for proxy for a local element.
	 * 
	 * @param <R> Type of created proxy
	 * @param type of created proxy
	 * @param category of identification
	 * @param name of element
	 */
	protected def localId(Enum<?> cat, String name) {
		cat.id(contentAlias, name)
	}
	
	/**
	 * Builds a proxy to be resolved on 'loadContent' for an element defined in provided container.
	 * 
	 * @param <R> Type of created proxy
	 * @param type of created proxy
	 * @param container of element
	 * @param category of identification
	 * @param name of element
	 */
	protected def <R extends IdentifiedElement> R ref(
			Class<R> type, 
			Class<? extends AbstractEdition> container, 
			Enum<?> cat, 
			String name) {
		type.ref(context.getContentAlias(container), cat, name)
	}
	
		
	/**
	 * Builds a proxy to be resolved on 'loadContent' for an element defined in provided container.
	 * 
	 * @param container of element
	 * @param category of identification
	 * @param name of element
	 */
	protected def refId(Class<? extends AbstractEdition> container, Enum<?> cat, String name) {
		cat.id(context.getContentAlias(container), name)
	}
	
	/**
	 * Builds a proxy to be resolved on 'loadContent' for an element defined in provided container.
	 * 
	 * @param <R> Type of created proxy
	 * @param type of created proxy
	 * @param category of identification
	 * @param containerId of element
	 * @param name of element
	 */
	protected def <R extends IdentifiedElement> R ref(
		Class<R> type, String containerId, 
		Enum<?> cat, String id
	) {
		type.ref(cat.id(containerId, id))
	}
    
	
	//
	// Expressions
	// 
	
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
	 * Provides AQL expression for a class.
	 * <p>
	 * The must be contain in business Packages of the context.
	 * </p>
	 * 
	 * @param type to convert
	 * @return aql expression
	 */
	def asAql(Class<? extends EObject> type) {
		context.asEClass(type).asAql
	}
	
	//
	// Operations
	// 
	
	/**
	 * Create an ChangeContext for an expression.
	 * 
	 * @param expression
	 * @return ChangeContext
	 */
    protected def toOperation(String expression) {
        ChangeContext.create[ browseExpression = expression ]
    }
    
	/**
	 * Create an ChangeContext for an expression.
	 * 
	 * @param expression
	 * @return ChangeContext
	 */
    protected def toOperation(String expression, ModelOperation... subOperations) {
    	expression.toOperation.andThen [
        	subModelOperations += subOperations
        ]
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
    
    protected def creator(EReference ref, Class<? extends EObject> instanceType) {
    	CreateInstance.create [
			typeName = instanceType.asDomainClass
			referenceName = ref.name
		]
    }
    
    
    /**
     * Creates a remove element operation for provided feature.
     * <p>
     * Prefer 'remover'
     * </p>
     * 
     * @param feature to set
     * @param expression of value
     * @return a new SetValue
     */
    @Deprecated
    protected def removeElement(String expression) {
    	expression.remover
    }
    
     /**
     * Creates a remove element operation for provided feature.
     * 
     * @param feature to set
     * @param expression of value
     * @return a new SetValue
     */
    protected def remover(String expression) {
        expression.toOperation.andThen[
            subModelOperations += RemoveElement.create[]
        ]
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
	
	protected def ifThenDo(String expression, ModelOperation... operations) {
		If.create [
			conditionExpression = expression
			subModelOperations += operations
		]
	}
	
	protected def setDefault(Switch it, ModelOperation operation) {
		^default = Default.create[
			subModelOperations += operation
		]
		it		
	}
	
    protected def void addService(EObject it, Class<?> service) {
        eContainer(Viewpoint).ownedJavaExtensions += 
            JavaExtension.create[ qualifiedClassName = service.name ]
    }

}
