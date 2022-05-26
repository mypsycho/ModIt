package org.mypsycho.modit.emf.sirius.tool

import java.nio.file.Path
import java.util.HashMap
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.sirius.viewpoint.description.DescriptionPackage
import org.eclipse.sirius.viewpoint.description.Environment
import org.eclipse.sirius.viewpoint.description.JavaExtension
import org.eclipse.sirius.viewpoint.description.UserFixedColor
import org.eclipse.xtend.lib.annotations.Accessors
import org.mypsycho.modit.emf.EModIt
import org.mypsycho.modit.emf.EReversIt
import org.mypsycho.modit.emf.ModitModel
import org.mypsycho.modit.emf.sirius.api.AbstractGroup

/** Override of default reverse for SiriusModelProvider class. */
class SiriusGroupTemplate extends EReversIt {
	
	static val VP = DescriptionPackage.eINSTANCE
	
	// XTend does not support statefull inner class
	@Accessors
	val SiriusReverseIt tool
	
	new(SiriusReverseIt container, String classname, Path dir, Resource res) {
		super(classname, dir, res)
		tool = container
		delegates += new DiagramTemplate(this)
	}
	
	// Only used in SiriusModelProvider class.
	static val UNUSED_MAIN_IMPORTS = #[ 
		HashMap, ResourceSetImpl, Accessors, EModIt, ModitModel, EObject
	]
	static val EXTRA_MAIN_IMPORTS = #[ AbstractGroup, Environment ]
	
	override getMainStaticImports() {
		super.mainStaticImports
			.filter[ !UNUSED_MAIN_IMPORTS.contains(it) ]
			+ EXTRA_MAIN_IMPORTS
	}
	
	override protected prepareContext() {
		context.aliases += 
			tool.source
				.userColorsPalettes
				.flatMap[ entries ]
				.toMap([ it ]) [ '''color:«name»''' ]
		
		super.prepareContext()
	}
	
	// Xtend
	override templateMain(Iterable<Class<?>> packages, ()=>String content) {
'''package «context.mainClass.pack»

«templateImports(context.mainClass)»

import static extension org.mypsycho.modit.emf.sirius.api.SiriusDesigns.*

class «context.mainClass.name» extends AbstractGroup {
	
	new () {
        businessPackages += #[
«
FOR pkg : tool.editedPackages
SEPARATOR ",\n" // cannot include comma in template: improper for last value.
»			«pkg.class.interfaces.head.name».eINSTANCE«
ENDFOR
»
        ]
	}

	override initContent(Group it) {
		«content.apply»
	}

« // initExtras must be performed AFTER model exploration
IF !context.implicitExtras.empty || !context.explicitExtras.empty
»	override initExtras() {
		super.initExtras
		
		«templateExtras»
	}

«
ENDIF // extras
»
	def context() { this }
	
	«templateShorcuts»
}
'''
	}

	// Xtend
	override templateExplicitExtras() {
		val colors = tool.source.systemColorsPalette.entries
		if (context.explicitExtras.keySet.equals(colors.toSet)) {
			return "" // no named element
		}
'''extras.putAll(#{ // Named elements
«
FOR ext : context.explicitExtras.entrySet
		// ignore SystemColors as they are already provided in template.
	.filter[ !colors.contains(key) ]
	.toList.sortBy[ value ]
SEPARATOR ",\n" // cannot include comma in template: improper for last value.
»	«ext.value.toJava» -> «ext.key.templateAlias»«
ENDFOR
»
})
'''
	}

	override templateExplicitAlias(EObject it) {
'''«templateClass».eObject(«toUri.toJava »)'''	
	}

	override templateSimpleContent(EObject it) {
		// As assembling is performed by SiriusModelProvider,
		// use the code from #templateInnerCreate.
'''
«
FOR c : innerContent SEPARATOR statementSeparator 
»«templateProperty(c.key, c.value)»«
ENDFOR
»
'''
	}

	override templateInnerCreate(EObject it) {
		switch (it) {
			// JavaExtension: '''use(«qualifiedClassName»)'''
			UserFixedColor: '''"«name»".color(«red», «green», «blue»)'''
			default: super.templateInnerCreate(it)
		}
	}
	
	override templatePropertyValue(EStructuralFeature it, Object value, (Object)=>String encoding) {
		if (it == VP.viewpoint_OwnedJavaExtensions)
			'''use(«(value as JavaExtension).qualifiedClassName»)'''
		else
			templatePropertyValue(encoding.apply(value))
	}

	override templateRef(EObject it, Class<?> using) {
		super.templateRef(it, using)
	}

}
