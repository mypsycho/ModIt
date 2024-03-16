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
package org.mypsycho.modit.emf.sirius.tool

import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.sirius.table.metamodel.table.description.ColumnMapping
import org.eclipse.sirius.table.metamodel.table.description.CreateLineTool
import org.eclipse.sirius.table.metamodel.table.description.CrossTableDescription
import org.eclipse.sirius.table.metamodel.table.description.DescriptionPackage
import org.eclipse.sirius.table.metamodel.table.description.ElementColumnMapping
import org.eclipse.sirius.table.metamodel.table.description.FeatureColumnMapping
import org.eclipse.sirius.table.metamodel.table.description.LineMapping
import org.eclipse.sirius.table.metamodel.table.description.TableDescription
import org.eclipse.sirius.table.metamodel.table.description.TableTool
import org.eclipse.sirius.viewpoint.description.IdentifiedElement
import org.mypsycho.modit.emf.ClassId
import org.mypsycho.modit.emf.sirius.api.AbstractTable

import static extension org.mypsycho.modit.emf.sirius.api.SiriusDesigns.*
import org.mypsycho.modit.emf.sirius.api.SiriusCrossTable
import org.mypsycho.modit.emf.sirius.api.SiriusFeatureTable

/** Override of default reverse for SiriusModelProvider class. */
class TableTemplate extends RepresentationTemplate<TableDescription> {
	
	static val TPKG = DescriptionPackage.eINSTANCE

	new(SiriusGroupTemplate container) {
		super(container, TableDescription)
	}
	
	override isApplicableTemplate(TableDescription it) {
		domainClass.classFromDomain !== null
	}
	
	static val INIT_TEMPLATED = #{
		TableDescription -> #{
			SPKG.identifiedElement_Label,
			SPKG.representationDescription_Metamodel,
			TPKG.tableDescription_DomainClass
		}, 
		TableTool -> #{
			SPKG.identifiedElement_Name,
			TPKG.tableTool_Variables,
			TPKG.tableTool_FirstModelOperation
		},
		FeatureColumnMapping -> #{
			TPKG.featureColumnMapping_FeatureName
		}
	} + RepresentationTemplate.INIT_TEMPLATED
	
	override getInitTemplateds() {
		INIT_TEMPLATED
	}
	
	override getPartStaticImports(EObject it) {
		// no super: EModit and EObject are not used directly
		INIT_TEMPLATED.keySet 
			+ #[ 
				tableEditor,
				LineMapping,
				eClass.instanceClass,
				(it as TableDescription).domainClass.classFromDomain
			]
	}
	
	def getTableEditor(EObject it) {
		it instanceof CrossTableDescription
			? SiriusCrossTable
			: SiriusFeatureTable
	}
	
	
	override templateRepresentation(ClassId it, TableDescription content) {
		// Parent class cannot use import detection 
		//   as class does not exist (part of generation)
		val parentName = 
			(pack != context.mainClass.pack) 
				? context.mainClass.qName 
				: context.mainClass.name
		
'''package «pack»

«templateImports»

import static extension org.mypsycho.modit.emf.sirius.api.SiriusDesigns.*

class «name» extends «content.tableEditor.templateClass» {

	new(«parentName» parent) {
		super(parent, "«content.label»", «content.domainClass.classFromDomain.templateClass»)
	}

	override initDefaultLineStyle(LineMapping it) {}

	override initContent(«content.eClass.instanceClass.templateClass» it) {
		name = «content.name.toJava»
		«content.templateFilteredContent(TableDescription)»
	}

}''' // end-of-class
	}

	static val NS_MAPPING = #[
		FeatureColumnMapping -> AbstractTable.Ns.column,
		ElementColumnMapping -> AbstractTable.Ns.column,
		LineMapping -> AbstractTable.Ns.line,
		CreateLineTool -> AbstractTable.Ns.create
	]
	
	override getNsMapping() {
		NS_MAPPING
	}
	
	override templatePropertyValue(EStructuralFeature feat, Object value, (Object)=>String encoding) {
		if (feat instanceof EReference && (feat as EReference).containment) {
			val axisProperty = feat.templateAxisValue(value, encoding)
			if (axisProperty !== null) {
				return axisProperty
			}
		}
		super.templatePropertyValue(feat, value, encoding)
	}

	def templateAxisValue(EStructuralFeature feat, Object value, (Object)=>String encoding) {
		val call = switch(value) {
			LineMapping: '''ownedLine(«value.name.toJava»)''' // autocast
			ElementColumnMapping: '''ownedColumn(«value.name.toJava»)'''
			FeatureColumnMapping:
				(value.featureName == SiriusFeatureTable.VIRTUAL_FEATURE) 
					? '''ownedVirtualColumn(«value.name.toJava»)'''
					: '''ownedColumn(«value.name.toJava», «value.featureName.toJava»)'''
			default: return null
		}

		val it = value as EObject
'''«call» [
	«templateFilteredContent(eClass.instanceClass as Class<? extends EObject>)»
]'''
	}


 	def dispatch smartTemplateCreate(TableTool it) {
'''«templateClass».create«
IF it instanceof IdentifiedElement
						»(«name.toJava»)«
ENDIF                                  » [
	initVariables
	«templateFilteredContent(TableTool)»
	«templateToolOperation»
]'''
	}

	override templateRef(EObject it, Class<?> using) {
		val localRef = 
			if (currentContent.isContaining(it))
				switch(it) {
					LineMapping: '''«name.toJava».lineRef'''
					ColumnMapping: '''«name.toJava».columnRef'''
					default: null
				}
		localRef ?: super.templateRef(it, using)
	}
	
	// TODO Template for links, cells, forMapping, toLines, toColumns
	
}
