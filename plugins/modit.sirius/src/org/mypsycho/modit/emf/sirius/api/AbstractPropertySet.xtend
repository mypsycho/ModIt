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
 *	Nicolas PERANSIN - initial API and implementation
 *******************************************************************************/
package org.mypsycho.modit.emf.sirius.api

import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.sirius.properties.AbstractTextDescription
import org.eclipse.sirius.properties.AbstractWidgetDescription
import org.eclipse.sirius.properties.Category
import org.eclipse.sirius.properties.CheckboxDescription
import org.eclipse.sirius.properties.ContainerDescription
import org.eclipse.sirius.properties.CustomDescription
import org.eclipse.sirius.properties.CustomExpression
import org.eclipse.sirius.properties.DynamicMappingForDescription
import org.eclipse.sirius.properties.DynamicMappingIfDescription
import org.eclipse.sirius.properties.GroupDescription
import org.eclipse.sirius.properties.GroupStyle
import org.eclipse.sirius.properties.HyperlinkDescription
import org.eclipse.sirius.properties.LabelDescription
import org.eclipse.sirius.properties.ListDescription
import org.eclipse.sirius.properties.PageDescription
import org.eclipse.sirius.properties.RadioDescription
import org.eclipse.sirius.properties.SelectDescription
import org.eclipse.sirius.properties.TitleBarStyle
import org.eclipse.sirius.properties.ToggleStyle
import org.eclipse.sirius.properties.ViewExtensionDescription
import org.eclipse.sirius.properties.WidgetAction
import org.eclipse.sirius.properties.WidgetDescription
import org.eclipse.sirius.properties.WidgetStyle
import org.eclipse.sirius.properties.ext.widgets.reference.propertiesextwidgetsreference.ExtReferenceDescription
import org.eclipse.sirius.viewpoint.FontFormat
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
	
	/** Default name for category. */
	public static val DEFAULT_NAME = "Default"
	
	enum Ns { view, category, page, group, foreach, then }
	
	// 'input' provides in 
	// org.eclipse.sirius.properties.core.api.SiriusInputDescriptor
	// @see org.eclipse.sirius.properties.core.internal.SiriusToolServices	
		
	static def eefEdit(String variable) {
		'''input.emfEditServices(«variable»)'''
	}
	protected static val EMFEDIT = "self".eefEdit

	val String extensionName

	/**
	 * Constructor with explicit name.
	 * <p>
	 * Reserved for reverse tool.
	 * </p>
	 */
	new(SiriusVpGroup parent, String extName) {
		super(parent)
		
		extensionName = extName
	}
	
	/** Default constructor. */
	new(SiriusVpGroup parent) {
		this(parent, DEFAULT_NAME)
	}
	
	def void setDomainClass(GroupDescription it, Class<? extends EObject> value) {
		domainClass = value.asDomainClass
	}
	
	/** Creates the content of Property Description. */
	def ViewExtensionDescription createContent() {
		ViewExtensionDescription.createAs(Ns.view.id(extensionName)) [
			name = extensionName
			metamodels += context.businessPackages
			initCategories
		]
	}
	
	/** Creates a category. */
	protected def category(ViewExtensionDescription it, String catName, (Category)=> void init) {
		categories += Category.createAs(Ns.category.id(catName)) [
			name = catName
			init?.apply(it)
		]
	}
	
	/** Creates categories. (Basically only a default one) */
	protected def void initCategories(ViewExtensionDescription it) {
		category("Default") [ initDefaultCategory ]
	}
	
	/** Initializes the default category. */
	protected def void initDefaultCategory(Category it) {}

	/** Initializes a widget with edited feature. */
	def <T extends AbstractWidgetDescription> T initWidget(T it, EStructuralFeature feature) {
		// TODO replace by a call to the default adapter factory
		initWidget("self".featureAql(feature))
		name = eClass.name + ":" + contentAlias + feature.name
		it
	}
	
	/** Initializes a widget with edited feature expression. */
	def <T extends AbstractWidgetDescription> initWidget(T it, String featureExpr) {
		name = eClass.name + ":" + contentAlias  + featureExpr
		
		// TODO replace by a call to the default adapter factory
		labelExpression = '''«EMFEDIT».getText(«featureExpr»)'''.trimAql
		
		if (!(it instanceof CheckboxDescription)) {
			labelExpression = labelExpression + " + ':' "
		}
		
		helpExpression = '''«EMFEDIT».getDescription(«featureExpr»)'''.trimAql
		isEnabledExpression = '''«featureExpr».changeable'''.trimAql
		
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
			default: {} // no-op
		}

		it
	}
	
	
	def getRequiredFieldExpression(String featExpression) {
		'''«featExpression».lowerBound > 0'''.trimAql
	}
	
	/** Format a style  */
	def void formatRequiredField(WidgetStyle it) {
		// Lambda
		labelFontFormat += FontFormat.BOLD_LITERAL
	}
	
	def String featureAql(String valueVar, EStructuralFeature feat) {
		'''«valueVar».eClass().getEStructuralFeature('«feat.name»')'''
	}
	
	def <T extends WidgetStyle> T createDetailStyle(Class<T> type) {
		type.create[ labelFontSizeExpression = "8" ]
	}
	
	private def eachOn(String collect, String iter, (DynamicMappingForDescription)=>void init) {
		DynamicMappingForDescription.create [
			name = iter + "#For"
			iterator = iter
			iterableExpression = collect
			forceRefresh = true
			init.apply(it)
		]
	}
	
	@Deprecated // prefer forAll 
	def eachOn(String collect, String iter, DynamicMappingIfDescription... conditions) {
		collect.eachOn(iter) [
			ifs += conditions
		]
	}
	
	def forAll(GroupDescription owner, String iter, String collect, (DynamicMappingForDescription)=>void init) {
		collect.eachOn(iter, init) => [
			owner.controls += it
		]
	}
	
	def forAll(ContainerDescription owner, String iter, String collect, (DynamicMappingForDescription)=>void init) {
		collect.eachOn(iter, init) => [
			owner.controls += it
		]
	}
	
	
	/** Create a list of widgets for a single condition. */
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
	
	@Deprecated
	def when(String condition, WidgetDescription editor) {
		DynamicMappingIfDescription.create [
			name = "" // no need for unicity ??
			predicateExpression = condition
			widget = editor
		]
	}
	
	def <T extends WidgetDescription> when(Class<T> type, String condition, (T)=>void init) {
		when(condition, type, type.simpleName, init)
	}

	def <T extends WidgetDescription> when(
		String condition, Class<T> type, String widgetName, (T)=>void init
	) {
		condition.when(type.create(widgetName, init)).andThen[ name = widgetName + "#If"]
	}

	def <W extends WidgetDescription> forIf(
		DynamicMappingForDescription owner, String condition, 
		Class<W> type, String widgetName, (W)=>void init
	) {
		type.create(widgetName, init) => [
			owner.ifs += condition.when(it).andThen[ name = widgetName + "#If"]
		]
	}
	
	def <W extends WidgetDescription> always(Class<W> type, (W)=>void init) {
		type.when(ALWAYS, init)
	}

	def <W extends WidgetDescription> always(
		DynamicMappingForDescription owner, Class<W> type, String widgetName, (W)=>void init
	) {
		owner.forIf(ALWAYS, type, widgetName, init)
	}
	
	def action(LabelDescription owner, String label, String icon, ModelOperation action) {
		label.createAction(icon, action) =>[ owner.actions += it ]
	}
	
	def action(HyperlinkDescription owner, String label, String icon, ModelOperation action) {
		label.createAction(icon, action) =>[ owner.actions += it ]
	}
	
	def action(ListDescription owner, String label, String icon, ModelOperation action) {
		label.createAction(icon, action) =>[ owner.actions += it ]
	}
	
	def createAction(String label, String icon, ModelOperation action) {
		WidgetAction.create [
			labelExpression = label
			operation = action
			imageExpression = icon
		]
	}
	
	def createAction(String label, ModelOperation operation) {
		label.createAction(null, operation)
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
	
	def page(Category owner, String pageName) {
		PageDescription.createAs(Ns.page, pageName) [
			semanticCandidateExpression = SiriusDesigns.IDENTITY
		] => [
			owner.pages += it
		]
	}
	

	def groups(PageDescription owner, String... names) {
		names.forEach[ 
			owner.groups += GroupDescription.localRef(Ns.group, it)
		]
	}
	
	def group(Category owner, String groupName) {
		GroupDescription.createAs(Ns.group, groupName) [
			semanticCandidateExpression = SiriusDesigns.IDENTITY
		] => [
			owner.groups += it
		]
	}
	
	def noTitle(GroupDescription it) {
		style = GroupStyle.create[
			barStyle = TitleBarStyle.NO_TITLE
			toggleStyle = ToggleStyle.NONE
		]
	}

}
