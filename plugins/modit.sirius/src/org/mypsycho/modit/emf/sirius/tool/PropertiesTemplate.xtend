package org.mypsycho.modit.emf.sirius.tool

import java.util.List
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.sirius.properties.ButtonDescription
import org.eclipse.sirius.properties.Category
import org.eclipse.sirius.properties.CheckboxDescription
import org.eclipse.sirius.properties.GroupDescription
import org.eclipse.sirius.properties.HyperlinkDescription
import org.eclipse.sirius.properties.PageDescription
import org.eclipse.sirius.properties.RadioDescription
import org.eclipse.sirius.properties.SelectDescription
import org.eclipse.sirius.properties.TextAreaDescription
import org.eclipse.sirius.properties.TextDescription
import org.eclipse.sirius.properties.ToolbarAction
import org.eclipse.sirius.properties.ViewExtensionDescription
import org.eclipse.sirius.properties.WidgetAction
import org.eclipse.sirius.properties.WidgetConditionalStyle
import org.eclipse.sirius.properties.WidgetDescription
import org.eclipse.sirius.properties.WidgetStyle
import org.mypsycho.modit.emf.ClassId
import org.mypsycho.modit.emf.sirius.api.AbstractPropertySet
import org.eclipse.sirius.properties.PropertiesPackage

class PropertiesTemplate extends RepresentationTemplate<ViewExtensionDescription> {
	
	static val PKG = PropertiesPackage.eINSTANCE
	
	new(SiriusGroupTemplate container) {
		super(container, ViewExtensionDescription)
	}
	
	override isApplicableTemplate(ViewExtensionDescription it) {
		categories.size == 1
	}
	

	/** Set of classes used in sub parts by the default implementation  */
	protected static val PART_IMPORTS = #{  
		AbstractPropertySet, Category
	}
	
	override getPartStaticImports(EObject it) {
		// no super: EModit and EObject are not used directly
		PART_IMPORTS
	}
	
	static val NS_MAPPING = #[
		Category -> AbstractPropertySet.Ns.category,
		PageDescription -> AbstractPropertySet.Ns.page,
		ViewExtensionDescription -> AbstractPropertySet.Ns.view,
		GroupDescription -> AbstractPropertySet.Ns.group
	]
	
	override getNsMapping() {
		NS_MAPPING
	}
	
	override templateRepresentation(ClassId it, ViewExtensionDescription content) {
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

class «name» extends «AbstractPropertySet.templateClass» {

	new(«parentName» parent) {
		super(parent)
	}

	override initCategory(Category it) {
		«content.categories.head.templateFilteredContent(Category)»
	}

}''' // end-of-class
	}
	
	override getToolModelOperation(EObject it) {
		switch(it) {
			TextDescription: initialOperation.firstModelOperations
			WidgetAction: initialOperation.firstModelOperations
			HyperlinkDescription: initialOperation.firstModelOperations
			TextAreaDescription: initialOperation.firstModelOperations
			SelectDescription: initialOperation.firstModelOperations
			CheckboxDescription: initialOperation.firstModelOperations
			RadioDescription: initialOperation.firstModelOperations
			ToolbarAction: initialOperation.firstModelOperations
			ButtonDescription: initialOperation.firstModelOperations
			default: super.getToolModelOperation(it)
		}
	}
	
	override templateProperty(EObject element, EStructuralFeature it, (Object, Class<?>)=>String encoding) {
		if (element instanceof WidgetDescription) {
			if (name == "style") {
				return element.templateWidgetStyle(it)
			} else if (name == "conditionalStyles") {
				return element.templateWidgetConditionalStyles(it)
			}
		} else if (element instanceof GroupDescription) {
			if (it == PKG.abstractGroupDescription_Style) {
				return element.templateGroupStyle
			} else if (name == PKG.abstractGroupDescription_ConditionalStyles) {
				return element.templateGroupConditionalStyles
			}
		}
		
		super.templateProperty(element, it, encoding)
	}
	
	def templateGroupStyle(GroupDescription element) {
		val it = element.style
'''style [
	«templateInnerContent(innerContent)»
]'''
	}
	
	def templateGroupConditionalStyles(GroupDescription element) {
'''«
FOR it : element.conditionalStyles
	.map[ it -> style ]
SEPARATOR statementSeparator
»styleIf(«key.preconditionExpression.toJava») [
	«value.templateInnerContent(value.innerContent)»
]«
ENDFOR
»'''
	}
	
	def templateWidgetStyle(WidgetDescription element, EStructuralFeature feature) {
		val it = element.eGet(feature) as WidgetStyle
'''style [
	«templateInnerContent(innerContent)»
]'''
	}
		
	def templateWidgetConditionalStyles(WidgetDescription element, EStructuralFeature feature) {
'''«
FOR it : (element.eGet(feature) as List<WidgetConditionalStyle>)
	.map[
		val styleFeat = eClass.getEStructuralFeature("style")
		it -> eGet(styleFeat) as WidgetStyle
	]
SEPARATOR statementSeparator
»styleIf(«key.preconditionExpression.toJava») [
	«value.templateInnerContent(value.innerContent)»
]«
ENDFOR
»'''
	}
	
}