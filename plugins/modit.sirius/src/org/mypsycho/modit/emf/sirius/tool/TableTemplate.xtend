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

import java.util.List
import org.eclipse.emf.ecore.EAttribute
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.sirius.table.metamodel.table.description.BackgroundConditionalStyle
import org.eclipse.sirius.table.metamodel.table.description.BackgroundStyleDescription
import org.eclipse.sirius.table.metamodel.table.description.CellEditorTool
import org.eclipse.sirius.table.metamodel.table.description.ColumnMapping
import org.eclipse.sirius.table.metamodel.table.description.CreateLineTool
import org.eclipse.sirius.table.metamodel.table.description.CrossTableDescription
import org.eclipse.sirius.table.metamodel.table.description.DescriptionPackage
import org.eclipse.sirius.table.metamodel.table.description.ElementColumnMapping
import org.eclipse.sirius.table.metamodel.table.description.FeatureColumnMapping
import org.eclipse.sirius.table.metamodel.table.description.ForegroundConditionalStyle
import org.eclipse.sirius.table.metamodel.table.description.ForegroundStyleDescription
import org.eclipse.sirius.table.metamodel.table.description.IntersectionMapping
import org.eclipse.sirius.table.metamodel.table.description.LabelEditTool
import org.eclipse.sirius.table.metamodel.table.description.LineMapping
import org.eclipse.sirius.table.metamodel.table.description.TableDescription
import org.eclipse.sirius.table.metamodel.table.description.TableMapping
import org.eclipse.sirius.table.metamodel.table.description.TableTool
import org.eclipse.sirius.viewpoint.description.tool.ModelOperation
import org.mypsycho.modit.emf.ClassId
import org.mypsycho.modit.emf.sirius.api.AbstractTable
import org.mypsycho.modit.emf.sirius.api.SiriusCrossTable
import org.mypsycho.modit.emf.sirius.api.SiriusFeatureTable

import static extension org.mypsycho.modit.emf.sirius.api.SiriusDesigns.*
import org.eclipse.sirius.viewpoint.description.ColorDescription

/** Override of default reverse for SiriusModelProvider class. */
class TableTemplate extends RepresentationTemplate<TableDescription> {
	
	static val TPKG = DescriptionPackage.eINSTANCE

	static val NS_MAPPING = #[
		FeatureColumnMapping -> AbstractTable.Ns.column,
		ElementColumnMapping -> AbstractTable.Ns.column,
		LineMapping -> AbstractTable.Ns.line,
		CreateLineTool -> AbstractTable.Ns.create
	]
	
	static val INIT_TEMPLATED = #{
		TableDescription -> #{
			PKG.identifiedElement_Label,
			PKG.representationDescription_Metamodel,
			TPKG.tableDescription_DomainClass
		}, 
		TableTool -> #{
			PKG.identifiedElement_Name,
			TPKG.tableTool_Variables,
			TPKG.tableTool_FirstModelOperation
		},
		FeatureColumnMapping -> #{
			TPKG.featureColumnMapping_FeatureName
		},
		IntersectionMapping -> #{
			PKG.identifiedElement_Name,
			TPKG.intersectionMapping_UseDomainClass,
			TPKG.intersectionMapping_SemanticCandidatesExpression,
			TPKG.intersectionMapping_DomainClass,
			TPKG.intersectionMapping_ColumnMapping,
			TPKG.intersectionMapping_ColumnFinderExpression,
			TPKG.intersectionMapping_LineMapping,
			TPKG.intersectionMapping_LineFinderExpression
		}
	} + RepresentationTemplate.INIT_TEMPLATED	

	new(SiriusGroupTemplate container) {
		super(container, TableDescription)
	}
	
	override createDefaultContent() {
		new SiriusCrossTable(tool.defaultContent, "", null) {
			
			override initContent(CrossTableDescription it) {
				throw new UnsupportedOperationException("Must not be built")
			}
			
		}
	}
	
	override AbstractTable<?> getDefaultContent() {
		super.defaultContent
			as AbstractTable<?>
	}

	def <R extends EObject> R getDefaultStyleValues(R src) {
		defaultInits.computeIfAbsent(src.eClass) [
			EcoreUtil.create(it) => [
				switch(it) {
					ForegroundStyleDescription: defaultContent.initForeground(it)
				}
			]
		] as R
	}
	
	override isAttributeReversed(EObject it, EAttribute f) {
		it instanceof ForegroundStyleDescription
			? isStyleFeatureSet(f)
			: super.isAttributeReversed(it, f)
	}
		
	override isPureReferenceReversed(EObject it, EReference f) {
		it instanceof ForegroundStyleDescription
			? isStyleFeatureSet(f)
			: super.isPureReferenceReversed(it, f)
	}

	def boolean isStyleFeatureSet(EObject it, EStructuralFeature feat) {
		eGet(feat) != defaultStyleValues.eGet(feat)
	}
	
	override isApplicableTemplate(TableDescription it) {
		domainClass.classFromDomain !== null
	}
	
	override getNsMapping() { NS_MAPPING }	
	
	override getInitTemplateds() { INIT_TEMPLATED }
	
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
		val parentName = pack != context.mainClass.pack
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

}'''} // end-of-class
	
	override templateRef(EObject it, Class<?> using) {
		val localRef = currentContent.isContaining(it)
			? switch(it) {
				LineMapping: '''«name.toJava».lineRef'''
				ColumnMapping: '''«name.toJava».columnRef'''
				default: null
			}
		// TODO handle 'remote' lineRef
		localRef ?: super.templateRef(it, using)
	}	
	
	// 
	// Smart create
	// 
	
	def dispatch smartTemplateCreate(CellEditorTool it) {
 		// Other TableTools are AbstractToolDescription
 		toolTemplateCreate
	}

	//
	// Custom properties
	//
	
	override templatePropertyValue(EStructuralFeature feat, Object value, (Object)=>String encoding) {
		feat.isMappingContainment(value) 
			? (value as EObject).templateAxisValue
			: TPKG.cellUpdater_DirectEdit == feat
			? (value as LabelEditTool).templateDirectEdit
			: value instanceof ForegroundStyleDescription
			? value.templateForeground
			: value instanceof ForegroundConditionalStyle
			? value.templateConditionalForeground
			: value instanceof BackgroundStyleDescription
			? value.templateBackground
			: value instanceof BackgroundConditionalStyle
			? value.templateConditionalBackground
			: TPKG.tableTool_FirstModelOperation == feat
			? (value as ModelOperation).templateToolOperation
			: super.templatePropertyValue(feat, value, encoding)
	}
	
	def isMappingContainment(EStructuralFeature it, Object value) {
		it instanceof EReference 
			? containment && value instanceof TableMapping
			: false
	}
	
	def templateAxisValue(EObject it) {
		val call = switch(it) {
			LineMapping: '''ownedLine(«name.toJava»)'''
			// Column
			ElementColumnMapping: '''ownedColumn(«name.toJava»)'''
			FeatureColumnMapping:
				(featureName == SiriusFeatureTable.VIRTUAL_FEATURE) 
					? '''ownedVirtualColumn(«name.toJava»)'''
					: '''ownedColumn(«name.toJava», «featureName.toJava»)'''
			IntersectionMapping: 
				return useDomainClass 
					? templateDomainCellValue 
					: templateColumnCellValue
		}

'''«call» [
	«templateFilteredContent(eClass.instanceClass as Class<? extends EObject>)»
]'''}

	def String templateDomainCellValue(IntersectionMapping it) {
'''cells(«name.toJava», «domainClass.toJava», 
	«semanticCandidatesExpression.toJava») [
	toLines(«lineFinderExpression.toJava»«lineMapping.appendLinesArg»)
	toColumn(«columnFinderExpression.toJava»,
		«columnMapping.templateRef(ElementColumnMapping)»)

	foreground = null // cancel default initialisation
	«templateFilteredContent(IntersectionMapping)»
]'''}

	def String templateColumnCellValue(IntersectionMapping it) {
'''linkColumn(«name.toJava», «columnMapping.templateRef(ElementColumnMapping)») [
	forLines(«columnFinderExpression.toJava»«lineMapping.appendLinesArg»)

	«templateFilteredContent(IntersectionMapping)»
]'''}

	def appendLinesArg(List<LineMapping> lines) {
		lines.empty
			? ""
			: ''',
«
FOR line : lines
SEPARATOR LValueSeparator
»		«line.templateRef(LineMapping)»«
ENDFOR
»'''}

	def templateDirectEdit(LabelEditTool it) {
		if (firstModelOperation === null || mask?.mask != "{0}") {
			return toolTemplateCreate
		}
		'''directEdit = «firstModelOperation.templateInnerCreate»'''
	}


	def templateForeground(ForegroundStyleDescription it) {
'''foreground = [
	«templateFilteredContent(ForegroundStyleDescription)»
]
'''}
	
	def templateConditionalForeground(ForegroundConditionalStyle it) {
'''foregroundIf(«predicateExpression.toJava») [
	«style?.templateFilteredContent(ForegroundStyleDescription) ?: ""»
]
'''}
	
	def templateBackground(BackgroundStyleDescription it) {
'''background = «backgroundColor.templateRef(ColorDescription)»'''}
	
	def templateConditionalBackground(BackgroundConditionalStyle it) {
'''backgroundIf(«predicateExpression.toJava»,
	«style?.backgroundColor?.templateRef(ColorDescription) ?: "null"»)
'''}

}
