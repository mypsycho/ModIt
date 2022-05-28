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
import org.mypsycho.modit.emf.sirius.api.AbstractCrossTable
import org.mypsycho.modit.emf.sirius.api.AbstractEditionTable
import org.mypsycho.modit.emf.sirius.api.AbstractTable

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
		}
	}
	
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
		if (it instanceof CrossTableDescription)
			AbstractCrossTable
		else
			AbstractEditionTable
	}
	
	
	override templateRepresentation(ClassId it, TableDescription content) {
		// Parent class cannot use import detection 
		//   as class does not exist (part of generation)
		val parentName = 
			if (pack != context.mainClass.pack) 
				context.mainClass.qName 
			else 
				context.mainClass.name
		
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
					
			val fct = switch(value) {
				LineMapping: "line" -> value // autocast
				ElementColumnMapping: "column" -> value
				FeatureColumnMapping: "column" -> value
				default: null
			}
			if (fct !== null) {
				val it = fct.value
				return
'''it.«fct.key»("«name»") [
	«templateInnerContent(innerContent)»
]'''
			}
		}
		return super.templatePropertyValue(feat, value, encoding)
	}

 	def dispatch smartTemplateCreate(TableTool it) {
'''«templateClass».create«
IF it instanceof IdentifiedElement
						»("«name»")«
ENDIF                                   » [
	initVariables
	«templateFilteredContent(TableTool)»
	operation = «firstModelOperation.templateCreate»
]'''
	}

	override templateRef(EObject it, Class<?> using) {
		switch(it) {
			LineMapping: '''"«name»".lineRef'''
			ColumnMapping: '''"«name»".columnRef'''
			default: super.templateRef(it, using)
		}	
	}
}
