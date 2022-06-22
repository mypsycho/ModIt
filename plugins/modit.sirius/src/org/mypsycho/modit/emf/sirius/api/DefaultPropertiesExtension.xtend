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

import java.text.SimpleDateFormat
import java.util.ArrayList
import java.util.Date
import java.util.List
import java.util.Locale
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.emf.ecore.impl.EFactoryImpl
import org.eclipse.sirius.properties.Category
import org.eclipse.sirius.properties.CheckboxDescription
import org.eclipse.sirius.properties.GroupDescription
import org.eclipse.sirius.properties.GroupStyle
import org.eclipse.sirius.properties.ListDescription
import org.eclipse.sirius.properties.PageDescription
import org.eclipse.sirius.properties.RadioDescription
import org.eclipse.sirius.properties.SelectDescription
import org.eclipse.sirius.properties.TextAreaDescription
import org.eclipse.sirius.properties.TextDescription
import org.eclipse.sirius.properties.TitleBarStyle
import org.eclipse.sirius.properties.ToggleStyle
import org.eclipse.sirius.properties.WidgetDescription
import org.eclipse.sirius.properties.ext.widgets.reference.propertiesextwidgetsreference.ExtReferenceDescription

import static extension org.mypsycho.modit.emf.sirius.api.SiriusDesigns.*

/**
 * Abstract class to edit properties of a model.
 * 
 * @author nperansin
 */
class DefaultPropertiesExtension extends AbstractPropertySet {
	
	// 'input' provides in 
	// org.eclipse.sirius.properties.core.api.SiriusInputDescriptor
	// @see org.eclipse.sirius.properties.core.internal.SiriusToolServices	
	
	// emfEditServices return a org.eclipse.sirius.properties.core.internal.EditSupportSpec.


	/** @see EFactoryImpl#EDATE_FORMATS  */ 
	public static val DEFAULT_DATE_FORMAT = "yyyy-MM-dd"
	
	protected val List<Object> tabNames = new ArrayList
		
	new(AbstractGroup parent) {
		this(parent, parent.businessPackages.head?.name)
	}
	
	new(AbstractGroup parent, Object... tabs) {
		this(parent, tabs.toList)
	}
	
	new(AbstractGroup parent, Iterable<?> tabs) {
		super(parent)
		
		tabNames += tabs
	}
	
	override initCategory(Category it) {
		val specificGroups = createSpecificGroups()
		groups += specificGroups.map[ value ]
		
		tabNames.forEach[ page |
			pages += page.createDefaultPage.andThen[
				groups += specificGroups.filter[ key == page ].map[ value ]
			]
			groups += page.createDefaultGroup
		]
		
	}
	
	protected def List<? extends Pair<Object, GroupDescription>> createSpecificGroups() {
		#[]
	}
	
	def createDefaultPage(Object pageId) {
		PageDescription.createAs(Ns.page.id(pageId.toString)) [
			name = pageId.toString
			indented = pageId != tabNames.head
			
			labelExpression = pageId.toString.constant
			
			semanticCandidateExpression = "aql:input.getAllSemanticElements()"

			preconditionExpression = pageId.pageApplicableExpression				
			
			groups += GroupDescription.ref(Ns.group.id(pageId.toString)) // this could be remove using '.andThen[]'

		]
	}

	/**
	 * Requires overriding for static page.
	 */
	def isPageApplicableExpression(Object pageId) {
		context.expression[ isPageApplicable(pageId) ]
	}

	def isPageApplicable(EObject it, Object pageId) {
		pageId == tabNames.head // should be overridden
	}

	/**
	 * Requires overriding for static page.
	 */
	def getApplicableFeaturesExpression(Object pageId) {
		context.expression[ value |
			value.eClass.EAllStructuralFeatures
				.filter[ f | f.editable && value.isFeatureApplicable(f, pageId) ]
		]
	}

	def isFeatureApplicable(EObject it, EStructuralFeature feature, Object pageId) {
		pageId == tabNames.head // should be overridden
	}

    /**
     * Helper to check if a given feature should (by default) appear in the property sheet of an element.
     * <p>
     * TODO Should be bound to the item provider !!!
     * </p>
     * 
     * @param eStructuralFeature
     *            the feature to test.
     * @return <code>true</code> if the feature should appear in the property sheet by default.
     */
    def static boolean isEditable(EStructuralFeature it) {
        !derived && !transient 
            && !(it instanceof EReference && (it as EReference).isContainment())
    }


	def createDefaultGroup(Object pageId) {
		GroupDescription.createAs(Ns.group.id(pageId.toString)) [
			name = pageId + "_Default"
			
			semanticCandidateExpression = IDENTITY
			
			// No label by default, can be modified by 'andThen[]'
			labelExpression = "" 
			style = GroupStyle.create[
				barStyle = TitleBarStyle.NO_TITLE
				toggleStyle = ToggleStyle.NONE
			]
						
			controls += pageId.getApplicableFeaturesExpression
				.eachOn("eStructuralFeature", 
					createDefaultWidgetCases("self", "eStructuralFeature").values
				)
		]
	}
	
	/**
	 * Requires overriding for static page.
	 */
	def getDateExpression(String iValue, String iFeat) {
		context.expression(params(iValue, iFeat)) [
			EObject it, EStructuralFeature feat |
			val result = eGet(feat) as Date
			if (result === null) "" // text field needs WISIWYG (or think it as conflict)
			else new SimpleDateFormat(DEFAULT_DATE_FORMAT, Locale.ENGLISH)
				.format(result)
		]
	}
	
	enum WidgetCase { 
		line, text, date, // texts
		bool, alternative, choice, // limited value
		list, map, // set of value
		reference1, referenceN
	}
	
	def createDefaultWidgetCases(String iValue, String iFeat) {
		val valEmfEdit = iValue.eefEdit

		val dateFeature = '''«iFeat».eType = ecore::EDate'''
		val mapAttribute = '''«iFeat».eType = ecore::EStringToStringMapEntry'''
		// TODO add default actions for lists and maps, handle date
		
		#[
			WidgetCase.line -> '''
				«valEmfEdit».needsTextWidget(«iFeat»)
				and not «valEmfEdit».isMultiline(«iFeat»)
				and not («dateFeature»)''', // dont know why '()' are needed now
				
			WidgetCase.text -> '''
				«valEmfEdit».needsTextWidget(«iFeat») 
				and «valEmfEdit».isMultiline(«iFeat»)
				and not («dateFeature»)''',
				
			WidgetCase.date -> '''
				«valEmfEdit».needsTextWidget(«iFeat») 
				and («dateFeature»)''',
			
			WidgetCase.bool -> 
				'''«valEmfEdit».needsCheckboxWidget(«iFeat»)''',
			
			WidgetCase.alternative -> '''
				«iFeat».eType.oclIsKindOf(ecore::EEnum) 
				and not(«iFeat».many) 
				and «iFeat».eType.oclAsType(ecore::EEnum).eLiterals->size() <= 4''',
			
			WidgetCase.choice -> '''
				«iFeat».eType.oclIsKindOf(ecore::EEnum) 
				and not(«iFeat».many) 
				and «iFeat».eType.oclAsType(ecore::EEnum).eLiterals->size() > 4''',
			
			WidgetCase.list -> '''
				«iFeat».oclIsKindOf(ecore::EAttribute) 
				and «iFeat».many''',
			
			WidgetCase.map -> '''
				«iFeat».oclIsKindOf(ecore::EReference) 
				and «mapAttribute»''',
			
			WidgetCase.reference1 -> '''
				«iFeat».oclIsKindOf(ecore::EReference)
				and not(«iFeat».many) 
				and «iFeat».eType != ecore::EStringToStringMapEntry''',
			
			WidgetCase.referenceN -> '''
				«iFeat».oclIsKindOf(ecore::EReference)
				and («iFeat».many) 
				and «iFeat».eType != ecore::EStringToStringMapEntry'''
			
		].toMap([ key ]) [
			value.trimAql.when(createDefaultWidgets(key, iValue, iFeat))
		]

	}


	def WidgetDescription createDefaultWidgets(Object wcase, String iValue, String iFeat) {
		val valEmfEdit = iValue.eefEdit
		
		val valueGetter = '''aql:«iValue».eGet(«iFeat».name)'''
		val valueSetter = '''aql:«valEmfEdit».setValue(«iFeat», newValue)'''
		
		// AQL can only operate at Ecore level, 
		// everything must be bring to meta definition
		val enumValue = '''
			«iFeat».eType.oclAsType(ecore::EEnum)
			.getEEnumLiteralByLiteral(«iValue».eGet(«iFeat».name).toString())'''.trimAql
		val enumSetter = '''aql:«valEmfEdit».setValue(«iFeat», newValue.instance)'''
		val enumCandidates = '''aql:«iFeat».eType.oclAsType(ecore::EEnum).eLiterals'''
		val enumDisplay = "aql:candidate.name"
	
		
		switch(wcase as WidgetCase) {
			
			case line:TextDescription.create [
					initWidget(iFeat)
					valueExpression = valueGetter
					operation = valueSetter
				]
			
			case text: TextAreaDescription.create [
					initWidget(iFeat)
					valueExpression = valueGetter
					operation = valueSetter
				]
			
			case date: TextDescription.create [
					initWidget(iFeat)
					// assume we are still on aql
					helpExpression =  '''«helpExpression» + ' («DEFAULT_DATE_FORMAT»)' '''
					
					valueExpression = getDateExpression(iValue, iFeat)
					
					// Emf and sirius cannot handle empty date on their own
					operation = '''
						«valEmfEdit».setValue(«iFeat», 
							if (newValue.size() = 0) 
							then null 
							else newValue endif)'''.trimAql
				]
			
			case bool: CheckboxDescription.create [
					initWidget(iFeat)
					valueExpression = valueGetter
					operation = valueSetter
				]
				
			case alternative: RadioDescription.create [
					initWidget(iFeat)
	
					valueExpression = enumValue
					candidatesExpression = enumCandidates
					candidateDisplayExpression = enumDisplay
					operation = enumSetter
	
					//numberOfColumns = 2 // Tradeoff: there is a issue with horizontal scroll.
				]
				
			case choice: SelectDescription.create [
					initWidget(iFeat)
					
					valueExpression = enumValue
					candidatesExpression = enumCandidates
					candidateDisplayExpression = enumDisplay
					operation = enumSetter
				]
				
			case list: ListDescription.create [
					initWidget(iFeat)
					valueExpression = valueGetter
					displayExpression = '''var:value'''
					// TODO 
					// add create 
					// edit 
					// move up/down
					// delete
				]
			
			case map: ListDescription.create [
					initWidget(iFeat)
					valueExpression = valueGetter
					displayExpression = '''aql:value.key + ' = ' + value.value'''
					// TODO create a dialog using EStringToString
					// Create: check the key is not defined.
					// Modify: the key is not editable.
					// no move up or down 
				]
				
			// TODO replace with hyperlink + list
			case reference1, case referenceN:
				ExtReferenceDescription.create [
					initWidget(iFeat)
					referenceNameExpression = '''aql:«iFeat».name''' // in Sirius 
					// default dialog is disappointing
					// Create wrapper of org.eclipse.sirius.common.ui.tools.api.selection.EObjectSelectionWizard
					// but the user must choose 
				]
				
			default : throw new UnsupportedOperationException()
		}
		
	}
	
	
}