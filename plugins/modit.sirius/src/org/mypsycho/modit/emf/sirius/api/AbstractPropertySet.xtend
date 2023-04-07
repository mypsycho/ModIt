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

import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.sirius.properties.AbstractButtonDescription
import org.eclipse.sirius.properties.AbstractCheckboxDescription
import org.eclipse.sirius.properties.AbstractCustomDescription
import org.eclipse.sirius.properties.AbstractHyperlinkDescription
import org.eclipse.sirius.properties.AbstractLabelDescription
import org.eclipse.sirius.properties.AbstractListDescription
import org.eclipse.sirius.properties.AbstractRadioDescription
import org.eclipse.sirius.properties.AbstractSelectDescription
import org.eclipse.sirius.properties.AbstractTextAreaDescription
import org.eclipse.sirius.properties.AbstractTextDescription
import org.eclipse.sirius.properties.AbstractWidgetDescription
import org.eclipse.sirius.properties.ButtonDescription
import org.eclipse.sirius.properties.ButtonWidgetConditionalStyle
import org.eclipse.sirius.properties.ButtonWidgetStyle
import org.eclipse.sirius.properties.Category
import org.eclipse.sirius.properties.CheckboxDescription
import org.eclipse.sirius.properties.CheckboxWidgetConditionalStyle
import org.eclipse.sirius.properties.CheckboxWidgetStyle
import org.eclipse.sirius.properties.CustomDescription
import org.eclipse.sirius.properties.CustomExpression
import org.eclipse.sirius.properties.CustomWidgetConditionalStyle
import org.eclipse.sirius.properties.CustomWidgetStyle
import org.eclipse.sirius.properties.DynamicMappingForDescription
import org.eclipse.sirius.properties.DynamicMappingIfDescription
import org.eclipse.sirius.properties.GroupDescription
import org.eclipse.sirius.properties.GroupStyle
import org.eclipse.sirius.properties.HyperlinkDescription
import org.eclipse.sirius.properties.HyperlinkWidgetConditionalStyle
import org.eclipse.sirius.properties.HyperlinkWidgetStyle
import org.eclipse.sirius.properties.LabelDescription
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
import org.eclipse.sirius.properties.ViewExtensionDescription
import org.eclipse.sirius.properties.WidgetAction
import org.eclipse.sirius.properties.WidgetConditionalStyle
import org.eclipse.sirius.properties.WidgetDescription
import org.eclipse.sirius.properties.WidgetStyle
import org.eclipse.sirius.properties.ext.widgets.reference.propertiesextwidgetsreference.AbstractExtReferenceDescription
import org.eclipse.sirius.properties.ext.widgets.reference.propertiesextwidgetsreference.ExtReferenceDescription
import org.eclipse.sirius.properties.ext.widgets.reference.propertiesextwidgetsreference.ExtReferenceWidgetConditionalStyle
import org.eclipse.sirius.properties.ext.widgets.reference.propertiesextwidgetsreference.ExtReferenceWidgetStyle
import org.eclipse.sirius.viewpoint.FontFormat
import org.eclipse.sirius.viewpoint.description.IdentifiedElement
import org.eclipse.sirius.viewpoint.description.tool.InitialOperation
import org.eclipse.sirius.viewpoint.description.tool.ModelOperation

import static extension org.mypsycho.modit.emf.sirius.api.SiriusDesigns.*

/**
 * Adaptation of Sirius model into Java and EClass reflections API
 * for Properties set.
 *
 * @author nperansin
 *
 */
abstract class AbstractPropertySet extends AbstractEdition {
	
	enum Ns { view, category, page, group, foreach, then }
	
	// 'input' provides in 
	// org.eclipse.sirius.properties.core.api.SiriusInputDescriptor
	// @see org.eclipse.sirius.properties.core.internal.SiriusToolServices	
		
	static def eefEdit(String variable) {
		'''input.emfEditServices(«variable»)'''
	}
	protected static val EMFEDIT = "self".eefEdit

	new(AbstractGroup parent) {
		super(parent)
		
		// Compatibility:
		// contentAlias was : Ns.view.id("Default")
	}
	
	def void setDomainClass(GroupDescription it, Class<? extends EObject> value) {
		domainClass = value.asDomainClass
	}
	
	def ViewExtensionDescription createContent() {
		ViewExtensionDescription.createAs(Ns.view.id("Default")) [
			name = "Default"
			metamodels += context.businessPackages
			categories += Category.createAs(Ns.category.id("Default")) [
				name =  Ns.category.id("Default")
				initCategory
			]
		]
	}
	
	abstract protected def void initCategory(Category it)

	def <T extends AbstractWidgetDescription> T initWidget(T it, EStructuralFeature feature) {
		// TODO replace by a call to the default adapter factory
		initWidget("self".featureAql(feature))
		name = eClass.name + ":" + contentAlias + feature.name
		it
	}
	
	def <T extends AbstractWidgetDescription> T initWidget(T it, String featureExpr) {
		name = eClass.name + ":" + contentAlias  + featureExpr
		
		// TODO replace by a call to the default adapter factory
		labelExpression = '''aql:«EMFEDIT».getText(«featureExpr») '''
		
		if (!(it instanceof CheckboxDescription)) {
			labelExpression = labelExpression + " + ':' "
		}
		
		helpExpression = '''aql:«EMFEDIT».getDescription(«featureExpr»)'''
		isEnabledExpression = '''aql:«featureExpr».changeable'''
		
		// handle 
		val requiredExpression = featureExpr.requiredFieldExpression
		// all WidgetDescription so far
		switch(it) {
			AbstractTextDescription: styleIf(requiredExpression) [ formatRequiredField ]
			CustomDescription: styleIf(requiredExpression) [ formatRequiredField ]
			ExtReferenceDescription: styleIf(requiredExpression) [ formatRequiredField ]
			HyperlinkDescription: styleIf(requiredExpression) [ formatRequiredField ]
			LabelDescription: styleIf(requiredExpression) [ formatRequiredField ]
			ListDescription: styleIf(requiredExpression) [ formatRequiredField ]
			RadioDescription: styleIf(requiredExpression) [ formatRequiredField ]
			SelectDescription: styleIf(requiredExpression) [ formatRequiredField ]
			default: toString // no-op
		}

		it
	}
	
    def getRequiredFieldExpression(String featExpression) {
        '''«featExpression».lowerBound > 0'''.trimAql
    }
    
    def void formatRequiredField(WidgetStyle it) {
        // Lambda
        labelFontFormat += FontFormat.BOLD_LITERAL
    }
    
    /**
     * Creates a conditional style for widget on provided condition.
     *  
     * @param it WidgetDescription to style
     * @param condition of style application
     * @param init of created style
     */
    def styleIf(AbstractButtonDescription it, 
        String condition, (ButtonWidgetStyle)=>void init
    ) {
        conditionalStyles += ButtonWidgetConditionalStyle.styleIf(ButtonWidgetStyle, 
            condition, init
        ) [ c,s | c.style = s ]
    }
    
    /**
     * Creates a conditional style for widget on provided condition.
     *  
     * @param it WidgetDescription to style
     * @param condition of style application
     * @param init of created style
     */
    def styleIf(AbstractCheckboxDescription it, 
        String condition, (CheckboxWidgetStyle)=>void init
    ) {
        conditionalStyles += CheckboxWidgetConditionalStyle.styleIf(CheckboxWidgetStyle, 
            condition, init
        ) [ c,s | c.style = s ]
    }
    
    /**
     * Creates a conditional style for widget on provided condition.
     *  
     * @param it WidgetDescription to style
     * @param condition of style application
     * @param init of created style
     */
    def styleIf(AbstractCustomDescription it, 
        String condition, (CustomWidgetStyle)=>void init
    ) {
        conditionalStyles += CustomWidgetConditionalStyle.styleIf(CustomWidgetStyle, 
            condition, init
        ) [ c,s | c.style = s ]
    }
    
    /**
     * Creates a conditional style for widget on provided condition.
     *  
     * @param it WidgetDescription to style
     * @param condition of style application
     * @param init of created style
     */
    def styleIf(AbstractExtReferenceDescription it, 
        String condition, (ExtReferenceWidgetStyle)=>void init
    ) {
        conditionalStyles += ExtReferenceWidgetConditionalStyle.styleIf(ExtReferenceWidgetStyle, 
            condition, init
        ) [ c,s | c.style = s ]
    }
    
    /**
     * Creates a conditional style for widget on provided condition.
     *  
     * @param it WidgetDescription to style
     * @param condition of style application
     * @param init of created style
     */
    def styleIf(AbstractHyperlinkDescription it, 
        String condition, (HyperlinkWidgetStyle)=>void init
    ) {
        conditionalStyles += HyperlinkWidgetConditionalStyle.styleIf(HyperlinkWidgetStyle, 
            condition, init
        ) [ c,s | c.style = s ]
    }
    
    /**
     * Creates a conditional style for widget on provided condition.
     *  
     * @param it WidgetDescription to style
     * @param condition of style application
     * @param init of created style
     */
    def styleIf(AbstractLabelDescription it, 
        String condition, (LabelWidgetStyle)=>void init
    ) {
        conditionalStyles += LabelWidgetConditionalStyle.styleIf(LabelWidgetStyle, 
            condition, init
        ) [ c,s | c.style = s ]
    }
    
    /**
     * Creates a conditional style for widget on provided condition.
     *  
     * @param it WidgetDescription to style
     * @param condition of style application
     * @param init of created style
     */
    def styleIf(AbstractListDescription it, 
        String condition, (ListWidgetStyle)=>void init
    ) {
        conditionalStyles += ListWidgetConditionalStyle.styleIf(ListWidgetStyle, 
            condition, init
        ) [ c,s | c.style = s ]
    }
    
    /**
     * Creates a conditional style for widget on provided condition.
     *  
     * @param it WidgetDescription to style
     * @param condition of style application
     * @param init of created style
     */
    def styleIf(AbstractRadioDescription it, 
        String condition, (RadioWidgetStyle)=>void init
    ) {
        conditionalStyles += RadioWidgetConditionalStyle.styleIf(RadioWidgetStyle, 
            condition, init
        ) [ c,s | c.style = s ]
    }
    
    /**
     * Creates a conditional style for widget on provided condition.
     *  
     * @param it WidgetDescription to style
     * @param condition of style application
     * @param init of created style
     */
    def styleIf(AbstractSelectDescription it, 
        String condition, (SelectWidgetStyle)=>void init
    ) {
        conditionalStyles += SelectWidgetConditionalStyle.styleIf(SelectWidgetStyle, 
            condition, init
        ) [ c,s | c.style = s ]
    }
    
    /**
     * Creates a conditional style for widget on provided condition.
     *  
     * @param it WidgetDescription to style
     * @param condition of style application
     * @param init of created style
     */
    def styleIf(AbstractTextAreaDescription it, 
        String condition, (TextWidgetStyle)=>void init
    ) {
        conditionalStyles += TextWidgetConditionalStyle.styleIf(TextWidgetStyle, 
            condition, init
        ) [ c,s | c.style = s ]
    }
    
    /**
     * Creates a conditional style for widget on provided condition.
     *  
     * @param it WidgetDescription to style
     * @param condition of style application
     * @param init of created style
     */
    def styleIf(AbstractTextDescription it, 
        String condition, (TextWidgetStyle)=>void init
    ) {
        conditionalStyles += TextWidgetConditionalStyle.styleIf(TextWidgetStyle, 
            condition, init
        ) [ c,s | c.style = s ]
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
    def <C extends WidgetConditionalStyle, S extends WidgetStyle> styleIf(
        Class<C> conditionType, Class<S> styleType, 
        String condition, (S)=>void init, (C, S) => void assign
    ) {
        conditionType.create[
            preconditionExpression = condition
            assign.apply(it, styleType.create(init))
        ]
    }
    
    
    /**
     * Creates a style for widget.
     *  
     * @param it WidgetDescription to style
     * @param init of created style
     */
    def style(AbstractButtonDescription it, (ButtonWidgetStyle)=>void init) {
        style = ButtonWidgetStyle.create(init)
    }
    
    /**
     * Creates a style for widget.
     *  
     * @param it WidgetDescription to style
     * @param init of created style
     */
    def style(AbstractCheckboxDescription it, (CheckboxWidgetStyle)=>void init) {
        style = CheckboxWidgetStyle.create(init)
    }

    /**
     * Creates a style for widget.
     *  
     * @param it WidgetDescription to style
     * @param init of created style
     */
    def style(AbstractCustomDescription it, (CustomWidgetStyle)=>void init) {
        style = CustomWidgetStyle.create(init)
    }

    /**
     * Creates a style for widget.
     *  
     * @param it WidgetDescription to style
     * @param init of created style
     */
    def style(AbstractExtReferenceDescription it, (ExtReferenceWidgetStyle)=>void init) {
        style = ExtReferenceWidgetStyle.create(init)
    }

    /**
     * Creates a style for widget.
     *  
     * @param it WidgetDescription to style
     * @param init of created style
     */
    def style(AbstractHyperlinkDescription it, (HyperlinkWidgetStyle)=>void init) {
        style = HyperlinkWidgetStyle.create(init)
    }

    /**
     * Creates a style for widget.
     *  
     * @param it WidgetDescription to style
     * @param init of created style
     */
    def style(AbstractLabelDescription it, (LabelWidgetStyle)=>void init) {
        style = LabelWidgetStyle.create(init)
    }

    /**
     * Creates a style for widget.
     *  
     * @param it WidgetDescription to style
     * @param init of created style
     */
    def style(AbstractListDescription it, (ListWidgetStyle)=>void init) {
        style = ListWidgetStyle.create(init)
    }

    /**
     * Creates a style for widget.
     *  
     * @param it WidgetDescription to style
     * @param init of created style
     */
    def style(AbstractRadioDescription it, (RadioWidgetStyle)=>void init) {
        style = RadioWidgetStyle.create(init)
    }

    /**
     * Creates a style for widget.
     *  
     * @param it WidgetDescription to style
     * @param init of created style
     */
    def style(AbstractSelectDescription it, (SelectWidgetStyle)=>void init) {
        style = SelectWidgetStyle.create(init)
    }

    /**
     * Creates a style for widget.
     *  
     * @param it WidgetDescription to style
     * @param init of created style
     */
    def style(AbstractTextAreaDescription it, (TextWidgetStyle)=>void init) {
        style = TextWidgetStyle.create(init)
    }

    /**
     * Creates a style for widget.
     *  
     * @param it WidgetDescription to style
     * @param init of created style
     */
    def style(AbstractTextDescription it, (TextWidgetStyle)=>void init) {
        style = TextWidgetStyle.create(init)
    }
	
    def style(GroupDescription it, (GroupStyle)=>void init) {
        style = GroupStyle.create(init)
    }
	
	
	def String featureAql(String valueVar, EStructuralFeature feat) {
		'''«valueVar».eClass().getEStructuralFeature('«feat.name»')'''
	}
	
	def <T extends WidgetStyle> T createDetailStyle(Class<T> type) {
		type.create[ labelFontSizeExpression = "8" ]
	}
	
	def eachOn(String collect, String iter, DynamicMappingIfDescription... conditions) {
		DynamicMappingForDescription.create [
			name = eContainer(IdentifiedElement).name
			iterator = iter
			iterableExpression = collect
			forceRefresh = true
			ifs += conditions
		]
	}
	
	def controlsIf(CharSequence condition, WidgetDescription... widgets) {
        '''
            if («condition»)
            then self 
            else Sequence{}
            endif
        '''.trimAql.eachOn("", widgets.map[ ALWAYS.when(it) ])
    }
	
	def eachOn(String collect, DynamicMappingIfDescription... conditions) {
		collect.eachOn("self", conditions)
	}
	
	def when(String condition, WidgetDescription editor) {
		DynamicMappingIfDescription.create [
			name = Ns.then.id(editor.eClass.name) // no need for unicity ??
			predicateExpression = condition
			widget = editor
		]
	}
	
	def <T extends WidgetDescription> when(Class<T> type, String condition, (T)=>void init) {
		condition.when(type.create [
			init.apply(it)
		])
	}
	
	def <T extends WidgetDescription> always(Class<T> type, (T)=>void init) {
		type.when(ALWAYS, init)
	}
	
	def void setOperation(WidgetDescription it, ModelOperation value) {
		val init = InitialOperation.create [ firstModelOperations = value ]
		switch(it) {
			ButtonDescription: initialOperation = init
			CheckboxDescription: initialOperation = init
			HyperlinkDescription: initialOperation = init
			ListDescription: onClickOperation = init
			RadioDescription: initialOperation = init
			SelectDescription: initialOperation = init
			AbstractTextAreaDescription: initialOperation = init
		}
	}

	def void setOperation(WidgetDescription it, String expression) {
		operation = expression.toOperation
	}

	def void setOperation(WidgetAction it, ModelOperation value) {
		initialOperation = InitialOperation.create [ firstModelOperations = value ]
	}

	def void setOperation(WidgetAction it, String expression) {
		operation = expression.toOperation
	}

	def toolbar(String label, String icon, ModelOperation operation) {
		ToolbarAction.create [
			tooltipExpression = label
			imageExpression = icon
			initialOperation = InitialOperation.create [ firstModelOperations = operation ]	
		]
	}

	def void setOperation(ToolbarAction it, ModelOperation value) {
		initialOperation = InitialOperation.create [ firstModelOperations = value ]
	}

	
    def action(String label, String icon, ModelOperation operation) {
        WidgetAction.create [
            labelExpression = label
            it.operation = operation
            imageExpression = icon
        ]
    }
    
    def action(String label, ModelOperation operation) {
        label.action(null, operation)
    }
    
	// ECore API has no constraint.
	def String asDomainClass(Class<? extends EObject> type) {
		context.asDomainClass(type)
	}

    def param(CustomDescription it, String key, String value) {
        customExpressions += CustomExpression.create [
            name = key
            customExpression = value
        ]
    }

}
