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

import java.util.List
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.sirius.diagram.description.tool.DiagramCreationDescription
import org.eclipse.sirius.diagram.description.tool.DiagramNavigationDescription
import org.eclipse.sirius.diagram.description.tool.DirectEditLabel
import org.eclipse.sirius.properties.AbstractButtonDescription
import org.eclipse.sirius.properties.AbstractCheckboxDescription
import org.eclipse.sirius.properties.AbstractContainerDescription
import org.eclipse.sirius.properties.AbstractCustomDescription
import org.eclipse.sirius.properties.AbstractGroupDescription
import org.eclipse.sirius.properties.AbstractHyperlinkDescription
import org.eclipse.sirius.properties.AbstractLabelDescription
import org.eclipse.sirius.properties.AbstractListDescription
import org.eclipse.sirius.properties.AbstractRadioDescription
import org.eclipse.sirius.properties.AbstractSelectDescription
import org.eclipse.sirius.properties.AbstractTextAreaDescription
import org.eclipse.sirius.properties.AbstractTextDescription
import org.eclipse.sirius.properties.ButtonDescription
import org.eclipse.sirius.properties.ButtonWidgetConditionalStyle
import org.eclipse.sirius.properties.ButtonWidgetStyle
import org.eclipse.sirius.properties.CheckboxDescription
import org.eclipse.sirius.properties.CheckboxWidgetConditionalStyle
import org.eclipse.sirius.properties.CheckboxWidgetStyle
import org.eclipse.sirius.properties.CustomWidgetConditionalStyle
import org.eclipse.sirius.properties.CustomWidgetStyle
import org.eclipse.sirius.properties.DialogButton
import org.eclipse.sirius.properties.FILL_LAYOUT_ORIENTATION
import org.eclipse.sirius.properties.FillLayoutDescription
import org.eclipse.sirius.properties.GridLayoutDescription
import org.eclipse.sirius.properties.GroupConditionalStyle
import org.eclipse.sirius.properties.GroupDescription
import org.eclipse.sirius.properties.GroupStyle
import org.eclipse.sirius.properties.HyperlinkDescription
import org.eclipse.sirius.properties.HyperlinkWidgetConditionalStyle
import org.eclipse.sirius.properties.HyperlinkWidgetStyle
import org.eclipse.sirius.properties.LabelWidgetConditionalStyle
import org.eclipse.sirius.properties.LabelWidgetStyle
import org.eclipse.sirius.properties.ListDescription
import org.eclipse.sirius.properties.ListWidgetConditionalStyle
import org.eclipse.sirius.properties.ListWidgetStyle
import org.eclipse.sirius.properties.RadioDescription
import org.eclipse.sirius.properties.RadioWidgetConditionalStyle
import org.eclipse.sirius.properties.RadioWidgetStyle
import org.eclipse.sirius.properties.SelectDescription
import org.eclipse.sirius.properties.SelectWidgetConditionalStyle
import org.eclipse.sirius.properties.SelectWidgetStyle
import org.eclipse.sirius.properties.TextWidgetConditionalStyle
import org.eclipse.sirius.properties.TextWidgetStyle
import org.eclipse.sirius.properties.ToolbarAction
import org.eclipse.sirius.properties.WidgetAction
import org.eclipse.sirius.properties.WidgetConditionalStyle
import org.eclipse.sirius.properties.WidgetDescription
import org.eclipse.sirius.properties.ext.widgets.reference.propertiesextwidgetsreference.AbstractExtReferenceDescription
import org.eclipse.sirius.properties.ext.widgets.reference.propertiesextwidgetsreference.ExtReferenceWidgetConditionalStyle
import org.eclipse.sirius.properties.ext.widgets.reference.propertiesextwidgetsreference.ExtReferenceWidgetStyle
import org.eclipse.sirius.table.metamodel.table.description.TableCreationDescription
import org.eclipse.sirius.table.metamodel.table.description.TableNavigationDescription
import org.eclipse.sirius.tree.description.TreeCreationDescription
import org.eclipse.sirius.tree.description.TreeNavigationDescription
import org.eclipse.sirius.viewpoint.description.JavaExtension
import org.eclipse.sirius.viewpoint.description.SystemColor
import org.eclipse.sirius.viewpoint.description.Viewpoint
import org.eclipse.sirius.viewpoint.description.style.BasicLabelStyleDescription
import org.eclipse.sirius.viewpoint.description.tool.AbstractToolDescription
import org.eclipse.sirius.viewpoint.description.tool.Case
import org.eclipse.sirius.viewpoint.description.tool.ChangeContext
import org.eclipse.sirius.viewpoint.description.tool.ContainerModelOperation
import org.eclipse.sirius.viewpoint.description.tool.ContainerViewVariable
import org.eclipse.sirius.viewpoint.description.tool.CreateInstance
import org.eclipse.sirius.viewpoint.description.tool.Default
import org.eclipse.sirius.viewpoint.description.tool.DropContainerVariable
import org.eclipse.sirius.viewpoint.description.tool.ElementSelectVariable
import org.eclipse.sirius.viewpoint.description.tool.ElementVariable
import org.eclipse.sirius.viewpoint.description.tool.ElementViewVariable
import org.eclipse.sirius.viewpoint.description.tool.ExternalJavaAction
import org.eclipse.sirius.viewpoint.description.tool.ExternalJavaActionParameter
import org.eclipse.sirius.viewpoint.description.tool.For
import org.eclipse.sirius.viewpoint.description.tool.If
import org.eclipse.sirius.viewpoint.description.tool.InitialOperation
import org.eclipse.sirius.viewpoint.description.tool.Let
import org.eclipse.sirius.viewpoint.description.tool.ModelOperation
import org.eclipse.sirius.viewpoint.description.tool.NameVariable
import org.eclipse.sirius.viewpoint.description.tool.OperationAction
import org.eclipse.sirius.viewpoint.description.tool.PasteDescription
import org.eclipse.sirius.viewpoint.description.tool.RemoveElement
import org.eclipse.sirius.viewpoint.description.tool.RepresentationCreationDescription
import org.eclipse.sirius.viewpoint.description.tool.RepresentationNavigationDescription
import org.eclipse.sirius.viewpoint.description.tool.SelectionWizardDescription
import org.eclipse.sirius.viewpoint.description.tool.SetValue
import org.eclipse.sirius.viewpoint.description.tool.Switch
import org.eclipse.sirius.viewpoint.description.tool.ToolDescription
import org.eclipse.sirius.viewpoint.description.tool.Unset
import org.eclipse.sirius.viewpoint.description.validation.ValidationFix

import static extension org.mypsycho.modit.emf.sirius.api.SiriusDesigns.*
import org.eclipse.sirius.properties.PageDescription
import org.eclipse.sirius.properties.GroupOverrideDescription
import org.eclipse.sirius.properties.PageOverrideDescription

/**
 * Adaptation of Sirius model into Java and EClass reflections API
 * for representation.
 * 
 * @author nicolas.peransin
 */
abstract class AbstractEdition extends AbstractIdentifiableElement {

	/**
	 * Create a factory for a diagram description
	 * 
	 * @param parent of diagram
	 */
	new(SiriusVpGroup parent) {
		super(parent)
	}
	
	//
	// Operations
	// 
	
	/**
	 * Creates an ChangeContext for an expression.
	 * 
	 * @param expression to evaluate
	 */
    def toOperation(String expression) {
        ChangeContext.create[ browseExpression = expression ]
    }
    
    /**
	 * Creates a ChangeContext from an expression.
	 * 
	 * @param expression to evaluate
	 */
    def toContext(String expression, ModelOperation... subOperations) {
    	expression.toOperation.andThen [
        	subModelOperations += subOperations
        ]
    }
    
    /**
	 * Creates a ChangeContext from an expression.
	 * <p>
	 * Use toContext when sub-operations are provided.
	 * </p>
	 * 
	 * @param expression to evaluate
	 */
	@Deprecated
    protected def toOperation(String expression, ModelOperation... subOperations) {
    	expression.toContext(subOperations)
    }
    
    def toTool(ModelOperation operation) {
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
    def SetValue setter(EStructuralFeature feature, String expression) {
        feature.name.setter(expression)
    }

    /**
     * Creates a Set operation for provided feature using default Properties variable.
     * 
     * @param feature to set
     * @return a new SetValue
     */
    def SetValue setter(EStructuralFeature feature) {
        feature.setter(SiriusDesigns.PROP_VALUE)
    }
    
    /**
     * Creates a Set operation for provided feature.
     * 
     * @param feature to set
     * @param expr expression of value
     * @return a new SetValue
     */
    def <T> SetValue setter(EStructuralFeature feature, 
            Functions.Function1<? extends EObject, ?>  expr) {
        SetValue.create[
            featureName = feature.name
            valueExpression = expression(expr)
        ]
    }
    
	
    /** Creates a 'CreateIntance' operation. */
    def creator(EReference ref, Class<? extends EObject> instanceType) {
    	ref.name.creator(instanceType)
    }
    
    /** Creates a 'CreateIntance' operation. */
    def creator(String refName, Class<? extends EObject> instanceType) {
		refName.creator(instanceType.asDomainClass)
    }

    /** Deprecated: use typed signature. */
	// for reverse template only
    def creator(String refName, String instanceType) {
    	CreateInstance.create [
			referenceName = refName
			typeName = instanceType
		]
    }

    /**
     * Creates a remove element operation for provided feature.
     * 
     * @param expression of value
     * @return a new RemoveElement
     */
    def remover(String expression) {
        expression.toOperation.chain(RemoveElement.create)
    }
        
    /**
     * Creates a unset value operation for provided feature.
     * 
     * @param feature to unset
     * @param expression of element
     * @return a new Unset
     */
    def unsetter(String feature, String expression) {
		Unset.create [
			featureName = feature
			elementExpression = expression
		]
    }
    
    /**
     * Creates an UnsetValue operation for provided feature.
     * 
     * @param feature to unset
     * @param expression of element
     * @return a new Unset
     */
    def unsetter(EStructuralFeature feature, String expression) {
    	expression.unsetter(feature.name)
    }
	
    /**
     * Creates a Let operation for provided feature.
     * 
     * @param feature to unset
     * @param expression of element
     * @return a new Unset
     */
    def letDo(String expression, String varName, ModelOperation... operations) {
		Let.create [
			variableName = varName
			valueExpression = expression
			subModelOperations += operations
		]
    }
    
    /** - Use letDo instead - */
    @Deprecated
    protected def let(String expression, String varName, ModelOperation... operations) {
		expression.letDo(varName, operations)
	}

	/** Creates a 'switch' operation. */
	def switchDo(Pair<String, ? extends ModelOperation>... subCases) {
		Switch.create[
			cases += subCases.map[ descr |
				Case.create [
					conditionExpression = descr.key.trimAql
					subModelOperations += descr.value
				]
			]
			
			^default = Default.create[]
		]
	}
	
	/** Sets a default case to a 'Switch' operation. */
	def setByDefault(Switch it, ModelOperation operation) {
		andThen[
			// must be performed after original empty default
			^default = Default.create[
				subModelOperations += operation
			]
		]
	}
		
	/** Creates a 'If' operation. */
	def ifThenDo(String expression, ModelOperation... operations) {
		If.create [
			conditionExpression = expression
			subModelOperations += operations
		]
	}

	/** Creates a 'If' operation. Use 'ifThenDo' ! */
	@Deprecated 
	def thenDo(String expression, ModelOperation... operations) {
		expression.ifThenDo(operations)
	}
	
	/**
	 * Creates a 'For' operation.
	 * 
	 * @param it 'iterator' -&gt; 'collection'
	 * @param operations to perform
	 */
	def forDo(Pair<String, String> it, ModelOperation... operations) {
		value.forDo(key, operations)
	}
	
	/**
	 * Creates a 'For' operation.
	 * 
	 * @param valuesExpression to iterate on
	 * @param iter iterator name
	 * @param operations to perform
	 */
	def forDo(String valuesExpression, String iter, ModelOperation... operations) {
		For.create [
			expression = valuesExpression
			iteratorName = iter
			subModelOperations += operations
		]
	}
	
	/**
	 * Creates a 'For' operation using 'i' as iterator.
	 * 
	 * @param valuesExpression to iterate on
	 * @param operations to perform
	 */
	protected def forDo(String valuesExpression, ModelOperation... operations) {
		valuesExpression.forDo("i", operations)
	}

	/** Adds a service to the child of Viewpoint. */
    protected def void addService(EObject it, Class<?> service) {
        eContainer(Viewpoint).ownedJavaExtensions += 
            JavaExtension.create[ qualifiedClassName = service.name ]
    }

	/** Adds sub-operation to an operation container. */
	protected def <O extends ContainerModelOperation> O chain(O it, ModelOperation... operations) {
		andThen[ subModelOperations += operations ]
	}
	
	def jparam(String pName, String pValue) {
		ExternalJavaActionParameter.create [
			name = pName
			value = pValue
		]
	}
	
	/** Creates an external java action. */
	def javaDo(Class<?> actionId, String name, Pair<String, String>... params) {
		actionId.name.javaDo(name, params)
	}
	
	/** Creates an external java action. */
	def javaDo(String actionId, String name, Pair<String, String>... params) {
		ExternalJavaAction.create(name) [
			id = actionId
			parameters += params.map[ key.jparam(value) ]
		]
	}

	/** Adds an action to a group. */
	def action(GroupDescription owner, String label, String icon, ModelOperation operation) {
		label.createToolAction(icon, operation) => [ owner.actions += it ]
	}

	/** Adds an action to a page. */
	def action(PageDescription owner, String label, String icon, ModelOperation operation) {
		label.createToolAction(icon, operation) => [ owner.actions += it ]
	}
	
	/** Adds an action to a group. */
	def action(GroupOverrideDescription owner, String label, String icon, ModelOperation operation) {
		label.createToolAction(icon, operation) => [ owner.actions += it ]
	}

	/** Adds an action to a page. */
	def action(PageOverrideDescription owner, String label, String icon, ModelOperation operation) {
		label.createToolAction(icon, operation) => [ owner.actions += it ]
	}

	/**
	 * Sets the operation for provided widget.
	 * <p>
	 * Widget may be used in wizard operation of all views.
	 * </p>
	 * <p>
	 * This class unifies the initialOperation declaration of sub-class tool.
	 * </p>
	 * @param it tool to set
	 * @param value operation to perform
	 */
	def createToolAction(String label, String icon, ModelOperation operation) {
		ToolbarAction.create [
			tooltipExpression = label
			imageExpression = icon
			initialOperation = InitialOperation.create [ firstModelOperations = operation ]	
		]
	}

	/**
	 * Sets the operation for provided tool.
	 * <p>
	 * This class unifies the initialOperation declaration of sub-class tool.
	 * </p>
	 * @param it tool to set
	 * @param value operation to perform
	 */
	def setOperation(AbstractToolDescription it, ModelOperation value) {
		switch(it) {
			OperationAction: initialOperation = value.toTool
			ToolDescription: initialOperation = value.toTool
			PasteDescription: initialOperation = value.toTool
			SelectionWizardDescription: initialOperation = value.toTool
			DirectEditLabel: initialOperation = value.toTool
			default: throw new UnsupportedOperationException
		}
	}
		
	/**
	 * Sets the operation for provided widget.
	 * <p>
	 * Widget may be used in wizard operation of all views.
	 * </p>
	 * <p>
	 * This class unifies the initialOperation declaration of sub-class tool.
	 * </p>
	 * @param it tool to set
	 * @param value operation to perform
	 */
	def void setOperation(WidgetDescription it, ModelOperation value) {
		switch(it) {
			ButtonDescription: initialOperation = value.toTool
			CheckboxDescription: initialOperation = value.toTool
			HyperlinkDescription: initialOperation = value.toTool
			ListDescription: onClickOperation = value.toTool
			RadioDescription: initialOperation = value.toTool
			SelectDescription: initialOperation = value.toTool
			AbstractTextAreaDescription: initialOperation = value.toTool
			AbstractTextDescription: initialOperation = value.toTool
			default: throw new UnsupportedOperationException
		}
	}

	/**
	 * Sets the operation for provided widget.
	 * <p>
	 * Widget may be used in wizard operation of all views.
	 * </p>
	 * <p>
	 * This class unifies the initialOperation declaration of sub-class tool.
	 * </p>
	 * @param it tool to set
	 * @param value operation to perform
	 */
	def void setOperation(WidgetDescription it, String expression) {
		operation = expression.toOperation
	}

	/**
	 * Sets the operation for provided widget.
	 * <p>
	 * Widget may be used in wizard operation of all views.
	 * </p>
	 * <p>
	 * This class unifies the initialOperation declaration of sub-class tool.
	 * </p>
	 * @param it tool to set
	 * @param value operation to perform
	 */
	def void setOperation(WidgetAction it, ModelOperation value) {
		initialOperation = InitialOperation.create [ firstModelOperations = value ]
	}

	/**
	 * Sets the operation for provided widget.
	 * <p>
	 * Widget may be used in wizard operation of all views.
	 * </p>
	 * <p>
	 * This class unifies the initialOperation declaration of sub-class tool.
	 * </p>
	 * @param it tool to set
	 * @param value operation to perform
	 */
	def void setOperation(WidgetAction it, String expression) {
		operation = expression.toOperation
	}

	/**
	 * Sets the operation for provided widget.
	 * <p>
	 * Widget may be used in wizard operation of all views.
	 * </p>
	 * <p>
	 * This class unifies the initialOperation declaration of sub-class tool.
	 * </p>
	 * @param it tool to set
	 * @param value operation to perform
	 */
	def void setOperation(DialogButton it, ModelOperation value) {
		initialOperation = InitialOperation.create [ firstModelOperations = value ]
	}

	/**
	 * Sets the operation for provided widget.
	 * <p>
	 * Widget may be used in wizard operation of all views.
	 * </p>
	 * <p>
	 * This class unifies the initialOperation declaration of sub-class tool.
	 * </p>
	 * @param it tool to set
	 * @param value operation to perform
	 */
	def void setOperation(DialogButton it, String expression) {
		operation = expression.toOperation
	}

	/**
	 * Sets the operation for provided widget.
	 * <p>
	 * Widget may be used in wizard operation of all views.
	 * </p>
	 * <p>
	 * This class unifies the initialOperation declaration of sub-class tool.
	 * </p>
	 * @param it tool to set
	 * @param value operation to perform
	 */
	def void setOperation(ToolbarAction it, ModelOperation value) {
		initialOperation = InitialOperation.create [ firstModelOperations = value ]
	}

	/**
	 * Sets the operation for provided widget.
	 * <p>
	 * Widget may be used in wizard operation of all views.
	 * </p>
	 * <p>
	 * This class unifies the initialOperation declaration of sub-class tool.
	 * </p>
	 * @param it tool to set
	 * @param value operation to perform
	 */
	def void setOperation(ToolbarAction it, String expression) {
		operation = expression.toOperation
	}
	
	/** Sets operation for validation fix. */
	def setOperation(ValidationFix it, ModelOperation value) {
		initialOperation = value.toTool
	}

	/** Initializes a Style with common default values. */
	def void initDefaultStyle(BasicLabelStyleDescription it) {
		labelSize = 10 // ODesign is provide 12, but eclipse default is Segoe:9
		labelColor = SystemColor.extraRef("color:black")
		
		labelExpression = context.itemProviderLabel
	}
	
	/** Initializes variables of the tool. */
	def initVariables(AbstractToolDescription it) {
		switch(it) {
			RepresentationNavigationDescription: {
				representationNameVariable = NameVariable.create(switch(it) {
					DiagramNavigationDescription: "diagramName"
					TableNavigationDescription: "tableName"
					TreeNavigationDescription: "treeName"
					default : "name"
				})
				containerVariable = ElementSelectVariable.create("container")
				containerViewVariable = ContainerViewVariable.create("containerView")
			}
			RepresentationCreationDescription: {
				representationNameVariable = NameVariable.create(switch(it) {
					DiagramCreationDescription: "diagramName"
					TableCreationDescription: "tableName"
					TreeCreationDescription: "treeName"
					default : "name"
				})
				containerViewVariable = ContainerViewVariable.create("containerView")
			}
			ToolDescription: {
				element = ElementVariable.create("element")
				elementView = ElementViewVariable.create("elementView")
			}
			OperationAction: {
				view = ContainerViewVariable.create("views")
			}
			PasteDescription: {
				copiedElement = ElementVariable.create("copiedElement")
				copiedView = ElementViewVariable.create("copiedView")
				containerView = ContainerViewVariable.create("containerView")
				container = DropContainerVariable.create("container")
			}
		}
	}
	

	/**
	 * Creates a Style with common default values.
	 * 
	 * @param <T> type of style
	 * @param it type of Style
	 * @param init custom initialization of style
	 * @return created Style
	 */
	def <T extends BasicLabelStyleDescription> T createStyle(Class<T> it, (T)=>void init) {
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
	def <T extends BasicLabelStyleDescription> T createStyle(Class<T> it) {
		createStyle(null as (T)=>void) // using only null for 'init' creates a ambiguity and an infinite loop.
	}
	
	
    /** Creates a style for widget. */
    def setStyle(AbstractButtonDescription it, (ButtonWidgetStyle)=>void init) {
        style = ButtonWidgetStyle.create(init)
    }
    
    /** Creates a style for widget. */
    def setStyle(AbstractCheckboxDescription it, (CheckboxWidgetStyle)=>void init) {
        style = CheckboxWidgetStyle.create(init)
    }

    /** Creates a style for widget. */
    def setStyle(AbstractCustomDescription it, (CustomWidgetStyle)=>void init) {
        style = CustomWidgetStyle.create(init)
    }

    /** Creates a style for widget. */
    def setStyle(AbstractExtReferenceDescription it, (ExtReferenceWidgetStyle)=>void init) {
        style = ExtReferenceWidgetStyle.create(init)
    }

    /** Creates a style for widget. */
    def setStyle(AbstractHyperlinkDescription it, (HyperlinkWidgetStyle)=>void init) {
        style = HyperlinkWidgetStyle.create(init)
    }

    /** Creates a style for widget. */
    def setStyle(AbstractLabelDescription it, (LabelWidgetStyle)=>void init) {
        style = LabelWidgetStyle.create(init)
    }

    /** Creates a style for widget. */
    def setStyle(AbstractListDescription it, (ListWidgetStyle)=>void init) {
        style = ListWidgetStyle.create(init)
    }

    /** Creates a style for widget. */
    def setStyle(AbstractRadioDescription it, (RadioWidgetStyle)=>void init) {
        style = RadioWidgetStyle.create(init)
    }

    /** Creates a style for widget. */
    def setStyle(AbstractSelectDescription it, (SelectWidgetStyle)=>void init) {
        style = SelectWidgetStyle.create(init)
    }

    /** Creates a style for widget. */
    def setStyle(AbstractTextAreaDescription it, (TextWidgetStyle)=>void init) {
        style = TextWidgetStyle.create(init)
    }

    /** Creates a style for widget. */
    def setStyle(AbstractTextDescription it, (TextWidgetStyle)=>void init) {
        style = TextWidgetStyle.create(init)
    }
	
    /** Creates a style for a group. */
    def setStyle(AbstractGroupDescription it, (GroupStyle)=>void init) {
        style = GroupStyle.create(init)
    }
	
	/** Creates a conditional style for group on provided condition. */
	def styleIf(AbstractGroupDescription it, String condition, (GroupStyle)=>void init) {
        GroupConditionalStyle
        	.styleIf(GroupStyle, conditionalStyles, condition, init)
    }
	    
    /**
     * Creates a conditional style for node on provided condition.
     * <p>
     * Note conditional style are required only when shape is changed. Most of the time,
     * customization is better solution.
     * </p>
     * @param type of style
     * @param it to add style
     * @param condition of style application
     * @param init of created style (after default initialization)
     */
    private def <C extends WidgetConditionalStyle, S extends EObject> 
    	styleIf(
        	Class<C> conditionType, Class<S> styleType, 
        	List<C> containment, String condition, (S)=>void init
    ) {
    	val style = styleType.create(init)
        containment += conditionType.create[
            preconditionExpression = condition
			eSet(eClass().getEStructuralFeature("style"), style)
        ]
        style
    }
    
    
	/** Creates a conditional style for widget on provided condition. */
    def void styleIf(AbstractButtonDescription it, String condition, (ButtonWidgetStyle)=>void init) {
        ButtonWidgetConditionalStyle
        	.styleIf(ButtonWidgetStyle, conditionalStyles, condition, init) 
    }
    
	/** Creates a conditional style for widget on provided condition. */
    def styleIf(AbstractCheckboxDescription it, String condition, (CheckboxWidgetStyle)=>void init) {
    	CheckboxWidgetConditionalStyle
        	.styleIf(CheckboxWidgetStyle, conditionalStyles, condition, init) 
    }
    
	/** Creates a conditional style for widget on provided condition. */
    def styleIf(AbstractCustomDescription it, String condition, (CustomWidgetStyle)=>void init) {
        CustomWidgetConditionalStyle
        	.styleIf(CustomWidgetStyle, conditionalStyles, condition, init) 
    }
    
	/** Creates a conditional style for widget on provided condition. */
    def styleIf(AbstractExtReferenceDescription it, String condition, (ExtReferenceWidgetStyle)=>void init) {
        ExtReferenceWidgetConditionalStyle
        	.styleIf(ExtReferenceWidgetStyle, conditionalStyles, condition, init) 
    }
    
	/** Creates a conditional style for widget on provided condition. */
    def styleIf(AbstractHyperlinkDescription it, String condition, (HyperlinkWidgetStyle)=>void init) {
        HyperlinkWidgetConditionalStyle
        	.styleIf(HyperlinkWidgetStyle, conditionalStyles, condition, init) 
    }
    
	/** Creates a conditional style for widget on provided condition. */
    def styleIf(AbstractLabelDescription it, 
        String condition, (LabelWidgetStyle)=>void init
    ) {
        LabelWidgetConditionalStyle
        	.styleIf(LabelWidgetStyle, conditionalStyles, condition, init) 
    }
    
	/** Creates a conditional style for widget on provided condition. */
    def styleIf(AbstractListDescription it, String condition, (ListWidgetStyle)=>void init) {
        ListWidgetConditionalStyle
        	.styleIf(ListWidgetStyle, conditionalStyles, condition, init) 
    }
    
	/** Creates a conditional style for widget on provided condition. */
    def styleIf(AbstractRadioDescription it, String condition, (RadioWidgetStyle)=>void init) {
        RadioWidgetConditionalStyle
        	.styleIf(RadioWidgetStyle, conditionalStyles, condition, init) 
    }
    
	/** Creates a conditional style for widget on provided condition. */
    def styleIf(AbstractSelectDescription it, String condition, (SelectWidgetStyle)=>void init) {
        SelectWidgetConditionalStyle
        	.styleIf(SelectWidgetStyle, conditionalStyles, condition, init) 
    }
    
	/** Creates a conditional style for widget on provided condition. */
    def styleIf(AbstractTextAreaDescription it, String condition, (TextWidgetStyle)=>void init) {
        TextWidgetConditionalStyle
        	.styleIf(TextWidgetStyle, conditionalStyles, condition, init) 
    }
    
	/** Creates a conditional style for widget on provided condition. */
    def styleIf(AbstractTextDescription it, String condition, (TextWidgetStyle)=>void init) {
        TextWidgetConditionalStyle
        	.styleIf(TextWidgetStyle, conditionalStyles, condition, init) 
    }
    
	/** Horizontal layout for Container. */
	def layoutHorizontal(AbstractContainerDescription it) {
		layoutFill(FILL_LAYOUT_ORIENTATION.HORIZONTAL)
	}
	
	/** Vertical layout for Container. */
	def layoutVertical(AbstractContainerDescription it) {
		layoutFill(FILL_LAYOUT_ORIENTATION.VERTICAL)
	}
	
	private def layoutFill(AbstractContainerDescription owner, FILL_LAYOUT_ORIENTATION value) {
		FillLayoutDescription.create [
			orientation = value
		] => [ owner.layout = it ]
	}
	
	/** Grid layout for Container. */
	def layoutGrid(AbstractContainerDescription owner, int size, boolean equalSize) {
		GridLayoutDescription.create [
			numberOfColumns = size
			makeColumnsWithEqualWidth = equalSize
		] => [ owner.layout = it ]
	}
	
	/** Grid layout for Container with same size columns */
	def layoutRegularGrid(AbstractContainerDescription it, int size) {
		layoutGrid(size, true)
	}
	
	/** Grid layout for Container with adaptable size columns */
	def layoutFreeGrid(AbstractContainerDescription it, int size) {
		layoutGrid(size, false)
	}
	
	/** Built-in color identities. */
	static enum DColor {
		blue, chocolate, gray, green, orange, purple, red, yellow, black, white
	}
	
	/** Retrieves the build-it in color. */
	def getRegular(DColor it) {
		getSystemColor("")
	}
	
	/** Retrieves the build-it in color but in light mode. */
	def getLight(DColor it) {
		getSystemColor("light_")
	}
	
	/** Retrieves the build-it in color but in dark mode. */
	def getDark(DColor it) {
		getSystemColor("dark_")
	}
	
	private def getSystemColor(DColor it, String modifier) {
		val mod = (it !== DColor.white && it !== DColor.black) 
			 ? modifier 
			 : "" // invariant
		SystemColor.extraRef("color:" + mod + name)
	}

}
