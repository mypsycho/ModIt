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
package org.mypsycho.modit.emf.i18n

import java.util.ArrayList
import java.util.Collections
import java.util.HashMap
import java.util.Locale
import java.util.ResourceBundle
import org.eclipse.emf.ecore.EClassifier
import org.eclipse.emf.ecore.EEnumLiteral
import org.eclipse.emf.ecore.ENamedElement
import org.eclipse.emf.ecore.EPackage
import org.mypsycho.modit.i18n.I18n

class EmfI18nFactory {

	public static val JAVAEXTENSION = "Package" // well-known extension for Java Classname for EPackage

	val instances = new HashMap<Pair<EPackage, Locale>, EmfI18n>

	val defaultValues = new HashMap<EPackage, EmfI18n>

	def EmfI18n get(EPackage it) {
		get(it, Locale.^default)
	}

	def EmfI18n get(EPackage it, Locale locale) {
		instances.computeIfAbsent(it -> locale) [
			create(key, locale, key.class.classLoader)
		]
	}


	/** Singleton to build localization sequence. */
	static val RB_CONTROL = new ResourceBundle.Control {/* Default instance is not accessible */}

	def EmfI18n create(EPackage it, Locale locale, ClassLoader loader) {
		val pkBasename = basename

		// Get or create the default values for all package elements
		val byDefault = defaultValues.computeIfAbsent(it) [
			// default labels
			val result = new EmfI18n(it, Locale.ROOT, EClassifiers.toMap[ instanceClass ])
			
			new EmfI18n.L10n { // default 
				override apply() {
					label = toDefaultLabel // current package
					EClassifiers // Don't iterate on sub-packages, don't use eAllContents
						.map[ eAllContents.toIterable + Collections.singletonList(it) ]
						.flatten.filter(ENamedElement)
						.forEach [ 
							label = toDefaultLabel
						]
				}
			}.init(result)

			// Perform locale.root once for all instance.
			(I18n.toL10n(Locale.ROOT, pkBasename, loader) as EmfI18n.L10n)?.init(result)

			result
		]

		val result = createInstance(locale)
		// Clone default values
		result.labels.putAll(byDefault.labels)

		// note: name is not used for getCandidateLocales, can be anything but null.
		RB_CONTROL.getCandidateLocales(name, locale)
			.reverseView // from general to local, 
			.tail // locale.root is already done in default creation
			.map[ I18n.toL10n(it, pkBasename, loader) as EmfI18n.L10n ]
			.filterNull
			.forEach[ init(result) ]
		result
	}

	def basename(EPackage it) { // TODO how to handle package name to class name
		toJavaname(it) + EmfI18n.CLASS_EXTENSION
	}

	def EmfI18n createInstance(EPackage it, Locale locale) {
		new EmfI18n(it, locale, defaultValues.get(it).classMap)
	}

	// not static so it can be overridden
	protected def toDefaultLabel(ENamedElement it) {
		if (it instanceof EEnumLiteral) 
			literal 
		else // Class should start with Upper case
			name.toText((it instanceof EClassifier) || (it instanceof EPackage))
	}

	static def getPublicPackageClass(EPackage it) {
		class.interfaces.findFirst[ 
			interfaces.contains(EPackage)
		]
	}

	static protected def toJavaname(EPackage it) {
		val javaname = publicPackageClass.name
		
		val pkgName = 
			if (javaname.endsWith(JAVAEXTENSION)) // trim extension
				javaname.substring(0, javaname.length - JAVAEXTENSION.length) 
			else javaname
		
		val qualifIndex = pkgName.lastIndexOf('.')
		
		if (qualifIndex != -1) 
			pkgName.substring(0, qualifIndex) + EmfI18n.PACKAGE_PATH + pkgName.substring(qualifIndex)
		else EmfI18n.PACKAGE_PATH + pkgName
	}


	static def toText(String it, boolean startUp) { // public for test purpose
		if (it === null || empty) {
			return it
		}

		val words = new ArrayList<String>
		var int tokenStart = 0
		var int currentType = Character.getType(charAt(tokenStart))
		for (var pos = tokenStart + 1; pos < length; pos++) {
			// TODO handle '_' as space
			val type = Character.getType(charAt(pos))
			if (type != currentType) {
				if (type == Character.LOWERCASE_LETTER && currentType == Character.UPPERCASE_LETTER) {
					val newTokenStart = pos - 1
					if (newTokenStart != tokenStart) {
						words += substring(tokenStart, newTokenStart)
						tokenStart = newTokenStart
					}
				} else {
					words += substring(tokenStart, pos)
					tokenStart = pos
				}
				currentType = type
			}
		}
		words += substring(tokenStart, length)

		// only words in the middle should not have uppercase
		(0..<words.length).forEach[
			val word = words.get(it)
			if ((!startUp || it != 0) 
				&& word.length > 1
				&& word != word.toUpperCase
			) {
				words.set(it, word.toLowerCase)
			}
		]

		words.join(" ")
	}

	

}
