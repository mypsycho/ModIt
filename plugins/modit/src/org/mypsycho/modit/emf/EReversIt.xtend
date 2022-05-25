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
package org.mypsycho.modit.emf

import java.io.IOException
import java.lang.reflect.Modifier
import java.nio.charset.Charset
import java.nio.charset.StandardCharsets
import java.nio.file.Files
import java.nio.file.Path
import java.util.ArrayList
import java.util.Collection
import java.util.Collections
import java.util.HashMap
import java.util.HashSet
import java.util.List
import java.util.Map
import java.util.Set
import org.eclipse.emf.common.notify.Notifier
import org.eclipse.emf.common.util.EList
import org.eclipse.emf.common.util.Enumerator
import org.eclipse.emf.common.util.TreeIterator
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.EAttribute
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.emf.ecore.util.EcoreEList
import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.xtend.lib.annotations.Accessors

/**
 * Source code Generator reversing model into Xtend class.
 * <p>
 * It can reverse 1 or several resources or model root objects. <br/>
 * EObject hierarchy can be 'split' into several class using mapping of EObject and ClassId. <br/>
 * Non-generated referenced elements can be 'aliased' with specified String.
 * </p>
 * <p>
 * As generation templates are separated from model analysis, it would be easy to extend the class
 * to generate into another language.
 * </p>
 */
class EReversIt {

	/** Set of classes used in main model by the default implementation  */
	protected static val MAIN_IMPORTS = #{ 
		HashMap, Class, // java
		Accessors, // xtend.lib
		EObject, EList, EReference, Resource, ResourceSet, ResourceSetImpl, // emf
		EcoreEList, URI, // emf queries
		EModIt, ModitModel
	}
	
	// 
	// Constructor context
	//
	static class Context {
		
		/** Id of main class */
		@Accessors
		val ClassId mainClass
	
		/** Path of generated code to create packages from */
		@Accessors
		val Path target
	
		/** Groups of objects to generate */
		@Accessors
		val Map<EObject, ClassId> roots
	
		/** List of objects to generated: consistent with root but keep order */
		@Accessors
		val List<EObject> orderedRoots
	
		// Generation parameters
		/** Elements contained in their own class */
		@Accessors
		val Map<EObject, ClassId> splits = new HashMap
	
		/** Generated elements with user identification */
		@Accessors
		val Map<EObject, String> aliases = new HashMap
		
		/** Non-Generated elements with an user identification */
		@Accessors
		val Map<EObject, String> explicitExtras = new HashMap
	
		@Accessors
		var Charset encoding = StandardCharsets.UTF_8
	
		@Accessors
		val List<EAttribute> shortcuts = new ArrayList

		@Accessors
		/** All generated elements with an user name: roots + aliases + splits */
		var Map<EObject, String> namings // initialized in #preparecontext()
	
		/** Non-Generated elements without identification (generated id) */
		// Tracking anonymous extras elements using generated id
		@Accessors
		var Map<EObject, String> implicitExtras // initialized in #preparecontext()


		new(ClassId definition, Path dir, Pair<? extends Notifier, ClassId>... values) {
			mainClass = definition
			target = dir
			orderedRoots = values.map[ key.toEObject ]
			roots = 
				if (values.size == 1) 
					#{ values.head.key.toEObject -> definition }
				else 
					values.toMap( [ key.toEObject ], [ value ] )
		}

	}

	protected val Context context
	
	protected val List<EReversIt> delegates = new ArrayList


	// Reset for each generated file.
	
	/** Imported Classes for the generated class */
	val Map<Class<?>, Boolean> currentImports = new HashMap

	/** Current generated Class */
	protected var ClassId currentClass
	protected var EObject currentContent

	/**
	 * Construction of generation context based on content of resources set.
	 * 
	 * @param classname of main class
	 * @param dir folder of generation
	 * @param res resource to en-code
	 */
	new(String classname, Path dir, Resource... res) {
		this(new ClassId(classname), dir, 
			res.map[ it -> new ClassId(new ClassId(classname), URI) ]
		)
	}

	/**
	 * Construction of generation context based on content of resources set.
	 * 
	 * @param definition of main class
	 * @param dir folder of generation
	 * @param values ordered map of objects to class.
	 */
	new(ClassId definition, Path dir, Pair<? extends Notifier, ClassId>... values) {
		this(new Context(definition, dir, values))
	}

	
	/**
	 * Construction of generation based on shared context.
	 * 
	 * @param Context of generation
	 */
	protected new(Context context) {
		this.context = context
	}
	
	/**
	 * Construction of generation based on shared context.
	 * 
	 * @param Context of generation
	 */
	protected new(EReversIt parent) {
		this(parent.context)
	}
	
	def getSplits() { context.splits }

	def getExplicitExtras() { context.explicitExtras }
	
	def getShortcuts() { context.shortcuts }

	def isPartTemplate(EObject it) { true }

	/**
	 * Ensures root, aliases, splits and extras are consistent and valuates
	 * 'namings' map.
	 */
	protected def prepareContext() {
		// Check alias and splits are defined in the serialized tree.
		#[
			"Alias" -> context.aliases, 
			"Split" -> context.splits.mapValues[ name ] 
		].forEach[
			// val Map<EObject, Object> cast = new HashMap(value) // Cast is required by xtend transformation.
			val headlesses = value.filter[ it, id | !context.roots.containsKey(toRoot) ].values
			if (!headlesses.empty) {
				throw new IllegalArgumentException(
					key + " values must be contained by reversed resource. Use explicitExtras: " + headlesses
				)
			}
		]

		// Check explicit extra are pure reference
		val illegalExtras = context.explicitExtras
			.filter[ it, id | context.roots.containsKey(toRoot) ]
			.values
		if (!illegalExtras.empty) {
			throw new IllegalArgumentException(
				"Explicit extra values must not be contained by reversed resource. Use splits or alias: " + illegalExtras
			)
		}

		// Check explicit extra are unique.
		// extras may different instance but same uri: Package !!
		val extrasByUris = new HashMap<String, String>
		val redundantExtras = new ArrayList<String>
		context.explicitExtras.entrySet.forEach[
			if (extrasByUris.containsKey(value)) {
				if (key.toUri != extrasByUris.get(value)) {
					redundantExtras += value
				}
			} else {
				extrasByUris.put(value, key.toUri)
			}
		]
		
		if (!redundantExtras.empty) {
			throw new IllegalArgumentException(
				"Explicit extra must be unique for: " + redundantExtras
			)
		}

		val mappings = #[ 
			context.roots.mapValues[ name ], 
			context.splits.mapValues[ name ], 
			context.aliases
		]
		
		// Checks mappings are a bijection.
		#[
			"Target elements" -> [ Map<EObject, String> it| keySet ],
			"Names" -> [ Map<EObject, String> it| values ]
		].forEach[ rule |
			val ends = mappings.map(rule.value).flatten.toList // list to keep all occurrences
			
			val redundants = ends.filter[ !isUniqueIn(ends) ].toSet
			if (!redundants.empty) {
				throw new IllegalArgumentException(
					rule.key + " cannot be used in several alias : " + redundants
				)
			}
		]

		val shortcutNames = context.shortcuts
			.map[ EContainingClass.instanceClass.simpleName ]
			.toList
		val redundantShortcuts = shortcutNames
			.filter[ !isUniqueIn(shortcutNames) ]
			.toSet
		if (!redundantShortcuts.empty) {
			throw new IllegalArgumentException(
				"Shortcuts have conflicting name : " + redundantShortcuts
			)
		}
		
		context.implicitExtras = new HashMap()// We tracks anonymous extras elements
		context.namings = mappings.map[ entrySet ].flatten.toMap([ key ], [ value ])
	}

	/**
	 * Generates the classes for the models using EModIt.
	 */
	def perform() throws IOException {
		prepareContext

		context.splits.forEach[ element, classId |
			classId.resolePath.toFile[
				classId.templatePart(element).toString
			]
		]

		// val mainFile = context.target.resolve(context.mainClass.toPath)
		
		if (context.roots.size == 1) {
			context.mainClass.resolePath.toFile[ context.orderedRoots.head.templateSimpleMain ]
			
		} else {
			// Write class of each elements
			context.orderedRoots.forEach [
				val classId = context.roots.get(it)
				classId.resolePath.toFile[ 
					templatePart(classId, it).toString
				]
			]
			context.mainClass.resolePath.toFile[ templateComposedMain ]
		}

	}
	
	def resolePath(ClassId it) {
		context.target.resolve(toPath)
	}

	// XTend
	def Iterable<?extends Class<?>> getMainStaticImports() { MAIN_IMPORTS }
	
	def withCurrent(ClassId id, EObject content, ()=>String task) {
		currentClass = id
		currentContent = content
		var result = task.apply
		currentClass = null
		currentContent = null
		result
	} 

	protected def templateSimpleMain(EObject it) {
		context.mainClass.withCurrent(it) [
			registerImports(
				mainStaticImports 
				+ findExtrasReferencedClasses 
				+ findShortcutsClasses
			)
			templateMain(#[ it ].usedPackages) [ templateSimpleContent ]
		]
	}

	// Xtend
	protected def templateSimpleContent(EObject it) {
		// Call modit.assemble on it
		templateCreate + ".assemble"
	}
		
	protected def templateComposedMain() {
		context.mainClass.withCurrent(null) [
			null.registerImports(
				mainStaticImports 
				+ findExtrasReferencedClasses 
				+ findShortcutsClasses
			)
			
			templateMain(context.orderedRoots.usedPackages) [ 
				context
					.orderedRoots
					.map[ context.roots.get(it) ]
					.templateComposedContent
			]
		]
	}
	
	// Xtend
	protected def String templateComposedContent(Iterable<?extends ClassId> values) {
		// call modit.assemble
'''#[
	«
FOR value : values SEPARATOR ',\n'
»new «value.qName»(this).createContent«
ENDFOR
»
].assemble'''
	}

	/** Set of classes used in sub parts by the default implementation  */
	protected static val PART_IMPORTS = #{ EObject, EModIt }

	// XTend
	def Iterable<?extends Class<?>> getPartStaticImports(EObject it) { PART_IMPORTS }

	protected def templatePart(ClassId it, EObject content) {
		(delegates.reverseView + #[ EReversIt.this /* default implementation */ ])
			// Delegate to applicable case.
			.filter[ isPartTemplate(content) ]
			.head
			.performTemplatePart(it, content)
	}
	
	protected def performTemplatePart(ClassId it, EObject content) {
		withCurrent(content) [
			currentContent = content
			content.registerImports(content.partStaticImports)
			templatePartBody(content).toString
		]
	}

	// Xtend
	protected def templatePartBody(ClassId it, EObject content) {
		val parentName = 
			if (pack != context.mainClass.pack) 
				context.mainClass.qName 
			else 
				context.mainClass.name
'''package «pack»

«templateImports(it)»
import static extension «context.mainClass.qName».*

class «name» {
	val «parentName» context
	val extension EModIt factory

	new(«parentName» parent) {
		this.context = parent
		this.factory = parent.factory
	}

	def «content.templateClass» createContent() {
		«content.templateInnerCreate»
	}

	def <T> T extraRef(Class<T> type, String key) {
		context.extraRef(type, key)
	}
	
}
'''
	}


	// Xtend
	protected def String templateMain(Iterable<Class<?>> packages, ()=>String content) {
'''package «context.mainClass.pack»

«templateImports(context.mainClass)»

class «context.mainClass.name» implements ModitModel {

	@Accessors
	val extras = new HashMap<String, EObject> 

	@Accessors
	protected val extension EModIt factory = EModIt.using(
		«FOR p : packages SEPARATOR ',\n' »«p.name».eINSTANCE«ENDFOR»
	)

	override loadContent(Resource it) {
		val values = resourceSet.buildModel.roots
		contents += values
		values
	}

	def buildModel() {
		buildModel(new ResourceSetImpl())
	}

	def buildModel(ResourceSet rs) {
		rs.initExtras()
		createContent
	}

	protected def createContent() {
		// provide a ModitPool
		«content.apply»
	}

	protected def void initExtras(ResourceSet it) {
		«templateExtras /* extras must happen AFTER model exploration */ »
	}

	def <T> T extraRef(Class<T> type, String key) {
		extras.get(key) as T
	}
	
	«templateShorcuts»
}
'''
	}

	// xtend
	protected def String templateExtras() {
		// 
		(if (!context.implicitExtras.empty) templateImplicitExtras else "")
		+ 
		(if (!context.explicitExtras.empty) templateExplicitExtras else "")
	}

	// xtend
	protected def String templateImplicitExtras() {
'''extras.putAll(#{ // anonymous resources
«
FOR ext : context.implicitExtras.entrySet.map[ value -> key ].toList.sortBy[ key ]
SEPARATOR ",\n" // cannot include comma in template: improper for last value
»	"«ext.key»" -> eObject(«ext.value.templateClass», «ext.value.toUri.toString.toJava»)«
ENDFOR
»
})
'''
	}

	// xtend
	protected def String templateExplicitExtras() {
'''extras.putAll(#{ // Named elements
«
FOR ext : context.explicitExtras.entrySet.toList.sortBy[ value ]
SEPARATOR ",\n" // cannot include comma in template: improper for last value
»	«ext.value.toJava» -> «ext.key.templateAlias»«
ENDFOR
»
})
'''
	}

	// xtend
	protected def String templateShorcuts() {
'''«
FOR shortcut : context.shortcuts 
»
static def <T extends «shortcut.EContainingClass.templateClass
»> at«shortcut.EContainingClass.instanceClass.simpleName
»(Iterable<T> values, Object key) {
	values.findFirst[ «shortcut.name» == key ]
}
«
ENDFOR
»
'''
	}

	protected def templateCreate(EObject it) {
		val split = context.splits.get(it)
		if (split !== null) templateOutterCreate(split)
		else templateInnerCreate
	}
	
	// Xtend
	protected def String templateOutterCreate(EObject it, ClassId split) {
		// TODO use import registry short name ( a current package is needed )
		val packPrefix = 
			if (context.mainClass.pack != split.pack) 
				split.pack + "." 
			else 
				""
		'''new «packPrefix»«split.name»(this).createContent'''
	}

	// Xtend
	protected def String templateInnerCreate(EObject it) {
		// Find setted attributes, references, <>references
		val content = innerContent

'''«templateClass».create«
IF context.namings.containsKey(it)
»As(«context.namings.get(it).toJava»)«
ENDIF
»«
IF content.exists[ c | eIsSet(c.key) ]
» [
	«templateInnerContent(content)»
]«
ENDIF
»'''
	}
	
	protected def String templateInnerContent(EObject it, 
			Iterable<? extends Pair<EStructuralFeature, 
				? extends (Object, Class<?>)=>String>> content
	) {
'''«
FOR prop : content 
SEPARATOR statementSeparator 
	»«templateProperty(prop.key, prop.value)»«
ENDFOR
»'''
	}
	
	
	protected def getInnerContent(EObject it) {
		// Find setted attributes, references, <>references
		#[
			eClass.EAllAttributes.filter[ a | eIsSet(a) && a.defaultValue != eGet(a) ]
				-> [ Object it, Class<?> using | toJava ],
			eClass.EAllReferences.filter[ r | eIsSet(r) && r.pureReference ]
				-> [ Object it, Class<?> using | (it as EObject).templateRef(using) ],
			eClass.EAllReferences.filter[ r | eIsSet(r) && r.isContainment ]
				-> [ Object it, Class<?> using | (it as EObject).templateCreate ]
		]
		.flatMap[ (key as Iterable<EStructuralFeature>).map[ f | f -> value ] ]
		
	}
	
	protected static class Expr {
		public val EObject src
		public val Iterable<? extends Class<?>> chain // required for import evaluation
		
		public val Expr parent
		public val EClass cast
		public val (String)=>String segment
		
		new (EObject src, Iterable<? extends Class<?>> chain) {
			parent = null
			this.src = src
			this.chain = chain
			cast = null
			segment = null
		}
			
		new (Expr parent, Iterable<? extends Class<?>> chain, EClass cast, (String)=>String segment) {
			this.parent = parent
			this.src = parent.src
			this.chain = chain
			this.cast = cast
			this.segment = segment
		}
		
		def isEmpty() { segment === null }
	}

	protected def String templateExpr(Expr it, String source) {
		val key = (parent?.templateExpr(source) ?: source).templateCast(cast)
		segment?.apply(key) ?: key
	}

	protected def String templateAlias(EObject it) {
		val path = callPath(false)
		val base = path.src
		
		path.templateExpr(
			if (context.implicitExtras.containsKey(base))
			 	// FIXME suspicious: how to get an element not included ? (require test)
				base.templateExtra(context.implicitExtras.get(base))
			else base.templateExplicitAlias
		)
	}
	
	// Xtend
	protected def String templateExtra(EObject it, String key) {
'''«templateClass».extraRef("«key»")'''	
	}
	
	// Xtend
	protected def String templateExplicitAlias(EObject it) {
'''eObject(«templateClass», «toUri.toJava »)'''	
	}	
	
	protected def toUri(EObject it) {
		if (it instanceof EPackage) nsURI + '#'
		else EcoreUtil.getURI(it).toString
	}
	
	protected def String templateRef(EObject it, Class<?> using) {
		val path = callPath(true)
		val alias = context.namings.get(path.src)
		val expectedType = if (alias !== null) eClass.getInstanceClass() else using

		val cast = if (!expectedType.isAssignableFrom(path.chain.head)) eClass // else null

		if (alias !== null)
			templateSimpleRef(path, alias, cast)
		else if (context.explicitExtras.containsKey(path.src))
			path.templateExpr(path.src.templateExtra(context.explicitExtras.get(path.src))).templateCast(cast)
		else if (path.src.generatedEPackage)
			path.templateExpr(templateEPackage(path.src as EPackage)) // no cast required
		else if (path.src.eResource !== null)
			path.templateExpr(path.src.templateExtra(identifyImplicitExtra(path.src))).templateCast(cast)
		else "// headless object" // throw or generate invalid statement ?
	}
	
	// Xtend
	protected def String templateSimpleRef(EObject it, Expr path, String alias, EClass cast) {
'''«templateClass».ref("«alias»")«
IF !path.empty
»[ «path.templateExpr("it".templateCast(path.src.eClass)).templateCast(cast)» ]«
ENDIF
»'''		
	}	

	protected def isGeneratedEPackage(EObject it) {
		if (it instanceof EPackage) 
			class.fields.exists[ // all public 
				Modifier.isStatic(modifiers)
				&& name == "eINSTANCE"
			]
		else false
	}

	// xtend (possibly the same for all packages)
	protected def templateEPackage(EPackage it) {
		class.fields.findFirst[
			Modifier.isStatic(modifiers)
			&& Modifier.isPublic(modifiers)
			&& name == "eINSTANCE"
		].declaringClass.name + ".eINSTANCE"
	}

	protected def identifyImplicitExtra(EObject it) {
		context.implicitExtras.computeIfAbsent(it) [ "$" + context.implicitExtras.size ]
	}
	
	/**
	 * Returns the expression of this path.
	 * 
	 * @param it element go to
	 * @param withExtras to use extras as result
	 * @return (root element) -> (exposed type) -> path
	 */
	protected def Expr callPath(EObject it, boolean withExtras) {
		if (context.namings.containsKey(it)) 
			return new Expr(it, #[ eClass.instanceClass, eClass.instanceClass ])

		if (eContainer === null || (withExtras && context.explicitExtras.containsKey(it))) // To extras
			return new Expr(it, #[ eClass.instanceClass, eClass.instanceClass ])

		val feat = eContainingFeature as EReference		
		val casted = feat.isReferenceSegmentCasted(it)
		
		val parentPath = eContainer.callPath(withExtras)

		// Test if cast required 
		val declaring = feat.EContainingClass
		val onRootAlias = !withExtras && eContainer.eContainer === null // eContainer is already handle
		val castRequired = !declaring.instanceClass.isAssignableFrom(parentPath.chain.head)
			&& !onRootAlias
		
		val usedTypes = parentPath.chain.tail
		val typePath = #[ 
			if (casted) eClass.instanceClass else feat.EReferenceType.instanceClass,
			eClass.instanceClass
		] + usedTypes
		// val typePathHead = typePath.toList.head // Debug expression
		// val typePathTail = typePath.toList.tail.toList // Debug expression
		new Expr(parentPath, typePath.toList, 
			if (castRequired) declaring else null
		) [ source | templateReferenceSegment(feat, source) ]
	}

	// Xtend
	def isReferenceSegmentCasted(EReference it, EObject value) {
		// must be consistent with templateReferenceSegment
		many && !EKeys.empty
	}	

	// Xtend
	def String templateReferenceSegment(EObject it, EReference feat, String source) {
		if (!feat.many)
			return source + "." + feat.toGetter

		val siblings = eContainer.eGet(feat) as List<EObject> // Ecore only provide Elist
		val keyed = !feat.EKeys.empty
		val shortcut = if (!keyed) context.shortcuts.findFirst[ 
			containerClass.isAssignableFrom(feat.EType.instanceClass)
		]
		
		if (keyed) {// 'at' syntax is specific to Xtend
			val typePrefix = 
				if (feat.EType != eClass) 
					templateClass + ", " 
				else ""
'''«source».«feat.name».at(«typePrefix»«feat.EKeys.map[att| eGet(att).toJava ].join(', ')»)'''			
		} else if (siblings.size == 1)
'''«source».«feat.toGetter».head'''
		else if (shortcut !== null) 
'''«source».«feat.toGetter».at«shortcut.EContainingClass.instanceClass.simpleName»(«eGet(shortcut).toJava»)'''			
		else 
'''«source».«feat.toGetter».get(«siblings.indexOf(it)»)'''

	}

	
	//Xtend
	def templateCast(CharSequence expr, EClass expected) {
		if (expected === null) expr.toString
		else "(" + expr + " as " + expected.templateClass + ")"
	}
	
	protected def templateProperty(EObject element, EStructuralFeature it, (Object, Class<?>)=>String encoding) {
		val usingType = EType.instanceClass
		val valueEncoding = [ encoding.apply(it, usingType) ]
		if (isMany) {
			(element.eGet(it) as Collection<?>)
				.join(statementSeparator) // Let's hope command separator is universal ...
				[ value | templateProperty(value, valueEncoding) ]
		} else {
			templateProperty(element.eGet(it), valueEncoding)
		}
	}
	
	protected def templateProperty(EStructuralFeature it, Object value, (Object)=>String encoding) {
		templatePropertyValue(encoding.apply(value))
	}
	
	
	// Xtend
	protected def templatePropertyValue(EStructuralFeature it, String value) {
		if (value === null)  // is this universal (for any lang) ??
			'''// «safename» is headless''' // TODO log an error
		else if (isMany) 
			'''«safename» += «value»'''
		else 
			'''«safename» = «value»'''

	}

	protected def isPureReference(EReference it) {
		if (containment || derived || transient || !changeable) false
		else if (EOpposite === null) true
		else if (EOpposite.derived) true // is it possible ?
		else if (EOpposite.containment) false
		else if (many != EOpposite.many) many
		else name < EOpposite.name // a bit irrational
	}

	protected def templateClass(EObject it) {
		eClass.templateClass
	}
	
	protected def templateClass(EClass it) {
		instanceClass.templateClass
	}

	protected def templateClass(Class<?> it) {
		if (currentImports.get(it) ?: Boolean.FALSE) simpleName else name
	}

	protected def usedPackages(Iterable<? extends EObject> values) {
		values.map[ #[ it ] + eAllContents.toIterable ]
			.flatten // all EObject
			.map[ findDeclaringPackageClass ] // all Class<? extend EPackage>
			.toSet
			.sortBy[ name ] // To have a repeatable import
	}

	
	protected def findShortcutsClasses() {
		context.shortcuts.map[ EContainingClass.instanceClass ].toSet
	}

	protected def findExtrasReferencedClasses() {
		context.explicitExtras.keySet.map[
			callPath(false).chain.tail
		].flatten.toSet
	}

	protected def void registerImports(EObject root, Iterable<? extends Class<?>> staticImports) {
		currentImports.clear
		staticImports.forEach[ registerImport ]

		if (root === null) {
			return
		}
		val Set<Class<?>> usedClasses = new HashSet
		usedClasses += root.getReferencedClasses
		// Cannot use Iterable concatenation, prune must be used.
		for (val TreeIterator<EObject> iContents = root.eAllContents; iContents.hasNext; ) {
			val child = iContents.next
			if (context.splits.containsKey(child)) {
				iContents.prune
			} else {
				usedClasses += child.getReferencedClasses
			}
		}

		usedClasses
			.sortBy[ name ] // sort to always have the same import
			// a optimal code would count but homonyms of Classes are not common in a model
			.forEach [ registerImport ]
	}
	
	protected def getReferencedClasses(EObject it) {	
		// we want the interface for EModIt
		#[ eClass.instanceClass ]

		+ eClass.EAllAttributes // Enum
			.map[ a| eGet(a) ]
			.filterNull // get defined
			.map[
				if (it instanceof Collection<?>) (it as Collection<?>) 
				else #[ it ]
			].flatten
			.filter[ it instanceof Enum<?> ]
			// TODO handle DataType parsing (using Package parse)
			// We need the factory of the bound to the attributes
			// to encode/decode
			.map[ class ]

		+ eClass.EAllReferences // only pure referenced elements
			.filter[ pureReference ]
			.map[ r| eGet(r) ] // only defined
			.map[
				if (it instanceof Collection) (it as Collection<? extends EObject>) 
				else if (it instanceof EObject) #[ it ]
				else Collections.emptyList
			]
			.flatten
			.map[ callPath(false).chain.tail ]
			.flatten
	}

	protected def void registerImport(Class<?> it) {
		if (!currentImports.containsKey(it)) {
			// Simple name already found
			val exist = currentClass.name !== simpleName
				&& currentImports
					.keySet
					.map[ simpleName ]
					.exists[n| n.equals(simpleName) ]
			currentImports.put(it, Boolean.valueOf(!exist))
		}	
	}
	
	protected def templateImports(ClassId container) {
'''«
FOR c : currentImports.entrySet
	.filter[ value 
		&& key.packageName != container.pack
	].map[ key ]
	.toList
	.sortBy[ name ] 
SEPARATOR statementSeparator
»«c.templateImport»«
ENDFOR
»'''
	}
		
	// XTend
	protected def templateImport(Class<?> it) { "import " + name }
	

	static def toContent(Resource res) { res.contents.get(0) }

	def toFile(Path target, ()=>String content) throws IOException {
		Files.createDirectories(target.parent)
		val it = Files.newBufferedWriter(target, context.encoding)
		try {
			print('Writing ' + target)
			write(content.apply)
			println(' : ok')
		} finally { close }
	}

	static def findDeclaringPackageClass(EObject it) {
		eClass.EPackage.publicPackageClass
	}
	
	static def getPublicPackageClass(EPackage it) {
		class.interfaces.findFirst[ 
			interfaces.contains(EPackage)
		]
	}

	dispatch def toJava(Void it) {
		// to handle null in dispatch, uses void.
		"null"
	}

	dispatch def toJava(Object it) {
		toString
	}

	dispatch def toJava(String it) {
		// TODO: Very ugly, probably not complete
		"\"" 
			+ replace("\\", "\\\\") // order matters
				.replace("\"", "\\\"") //
				.replace("\t", "\\t") //
				.replace("\r\n", "\\n") // order matters
				.replace("\r", "\\n") //
				.replace("\n", "\\n") //
			+ "\""
	}

	dispatch def toJava(Enumerator it) {
		class.templateClass
			+ "." + (
				if (class.isEnum) (it as Enum<?>).name()
				else ("getByName(\"" + name + "\")")
			)
	}


	static val XTEND_RESERVEDS = "extension,default,transient".split(",").toList
	// Xtend
	def safename(EStructuralFeature it) {
		if (XTEND_RESERVEDS.contains(name)) '^' + name else name
	}
	
	// Xtend (generic)
	def getStatementSeparator() { "\n" }

	static def EObject toRoot(EObject it) { eContainer?.toRoot ?: it }

	static def toGetter(EReference it) {
		if (name.length > 1 && Character.isUpperCase(name.charAt(1))) name.toFirstUpper
		else name
	}

	static def toEObject(Notifier it) {
		if (it instanceof EObject) it
		else if (it instanceof Resource) toContent 
		else throw new IllegalArgumentException("Unsupported type of " + it)
	}
	
	static def isUniqueIn(Object it, Iterable<?> values) {
		values.filter[ value | it == value ].size <= 1
	}
	
}
