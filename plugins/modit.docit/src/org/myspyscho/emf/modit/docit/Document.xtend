package org.myspyscho.emf.modit.docit

import java.nio.file.Path
import org.eclipse.emf.ecore.EObject


class Document<T extends EObject> {
		
	public var T model 

	static class DocumentSection<T> {
		
		public var T model 
		
		public var DocumentSection<?> parent

		def String section(String id, (DocumentSection<T>)=>String defaultContent) {
			id.section(model, defaultContent)
		}
		
		def <V> String section(String id, V value, (DocumentSection<V>)=>String defaultContent) {
			val newSection = new DocumentSection => [
				parent = this
				model = value
			]
			defaultContent.apply(newSection)
		}
		
		
		def String defaultSection(String id, (DocumentSection<T>)=>String defaultContent) {
			defaultContent.apply(this)
		}
		
		def String overrideProperty(String id, String value) {
			'''// «id» = «value»'''
		}

		def String ensureInSection(String id, String value) {
			'''// «id» = «value»'''
		}

		def String ensureGlobal(String id, String value) {
		}
		
		def Object sectionProperty(String id) {
			"none"
		}
		
		def Object globalProperty(String id) {
			"none"
		}

		def boolean existInSection(String id) {
			sectionProperty(id) !== null
		}
		
		def boolean existGlobal(String id) {
			globalProperty(id) !== null
		}
		
		
	}
	
	def void publish(Path target, (DocumentSection<T>)=>String template) {
		// read existing 
		
	}
	
	static def demo() {
		new Document<EObject>.publish(null) [
'''
some content
« section("id")[ '''
replaceable
«IF existInSection("typo")»
«ensureInSection("real", model.eClass.name)»
«ELSE»
«myTemplate(model)»
«ENDIF»
'''] »

'''
]
	}


	static def myTemplate(DocumentSection<?> it, EObject value) {
		''' 
		hello
		«section("id")[
			
		]»
		 '''
	}

}