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
package org.mypsycho.modit.i18n

import java.text.DateFormat
import java.text.DecimalFormat
import java.text.DecimalFormatSymbols
import java.text.NumberFormat
import java.text.SimpleDateFormat
import java.util.Date
import java.util.HashMap
import java.util.List
import java.util.Locale
import java.util.Map
import java.util.ResourceBundle
import org.eclipse.xtend.lib.annotations.AccessorType
import org.eclipse.xtend.lib.annotations.Accessors

import static extension org.eclipse.xtend.lib.annotations.AccessorType.*

/**
 * Abstract class to declare internationalized elements.
 * <p>
 * Default elements must be defined in a I18n subclass as not final fields.<br/>
 * Localization in applied by redefinition by I18n.L10n sub-class applied to I18n class.<br/>
 * Name of I18n.L10n must ResourceBundle pattern to be recognized.
 * </p>
 * <p>
 * For a faster coding/reading, user should declare accessors as:
 * <pre>
 * @Accessors(#[PUBLIC_GETTER, PACKAGE_SETTER])
 * </pre>
 * </p>
 * <p>
 * For OSGI bundle, localized class must be set in the same bundle or in a fragment of the 
 * one declaring I18n class.
 * </p>
 */
abstract class I18n {
	
	/**
	 * Retrieves or creates an I18N instance for default Locale.
	 * <p>
	 * Improper approach for OSGI: static field ruins bundle class loader. <br/>
	 * User must create a specific provider for each bundle using #create method.
	 * </p>
	 * @param I18n class to localize
	 */
	static def <T extends I18n> T get(Class<T> it) { 
		get(Locale.^default)
	}
	
		
	/**
	 * Retrieves or creates an I18N instance for provided locale.
	 * <p>
	 * Improper approach for OSGI: static field ruins bundle class loader. <br/>
	 * User must create a specific provider for each bundle using #create method.
	 * </p>
	 * @param I18n class to localize
	 * @param Locale of expected
	 */
	static def <T extends I18n> T get(Class<T> type, Locale locale) {
		// may be WeakHashMap<ClassLoader, Map...
		INSTANCES.computeIfAbsent(type->locale) [
			// ResourceBundle wraps the system class loader. I don't know why.
			/*
			if (System.getSecurityManager() === null) 
				create(type, locale)
			else 
				AccessController.doPrivileged(
					[ create(type, locale) ] as PrivilegedAction<I18n>
				) */
			I18n.create(type, locale)
		] as T
	}
	
	/**
	 * Abstract class to provide localized value of an internationalized class.
	 * 
	 * @param <T> I18n class to localize
	 */
	abstract static class L10n<T extends I18n> {
		
		var T instance
		
		protected def void setLabel(Class<?> it, String value) { setLabel(it, null, value) }
			
		protected def void setLabel(Enum<?> it, String value) { setLabel(it, null, value) }
		
		protected def void setLabel(Class<?> it, String hint, String value) { 
			instance.reflections.put(staticKey(hint), value)
		}
		
		protected def void setLabel(Enum<?> it, String hint, String value) { 
			instance.reflections.put(staticKey(hint), value)
		}
		
		private def void init(T it) {
			instance = it
			apply
		}
		
		/**
		 * Placeholder for user to attach local value to a container.
		 * <p>
		 * For a faster coding/reading, user should declare the content as extension.
		 * </p>
		 * @param content to localize (avoid 'it' to write lambda)
		 */
		def void apply(T content)
	}
	
	/**
	 * Singleton to build localization sequence.
	 */
	static val RB_CONTROL = new ResourceBundle.Control {/* Default instance is not accessible */}
	
	// This singleton is an issue for OSGI classloaders.
	static val INSTANCES = new HashMap<Pair<Class<? extends I18n>,Locale>,I18n>
	
	
	// Inspired from {@link java.text.MessageFormat#makeFormat(int, int, StringBuilder[])}
	static val List<? extends PredefinedFormat<Object, ? extends NumberFormat>> NUMBER_FORMATS = #[
		new PredefinedFormat(null)       [ it, locale | new DecimalFormat(it, DecimalFormatSymbols.getInstance(locale)) ],
		new PredefinedFormat("")         [ it, locale | NumberFormat.getInstance(locale) ],
		new PredefinedFormat("currency") [ it, locale | NumberFormat.getCurrencyInstance(locale) ],
		new PredefinedFormat("percent")  [ it, locale | NumberFormat.getPercentInstance(locale) ],
		new PredefinedFormat("integer")  [ it, locale | NumberFormat.getIntegerInstance(locale) ]
	]	
	// We could offer a printf approach for date and number ?? 
	
	static class PredefinedFormat<T,F> {
		val String pattern
		val (String, Locale)=>F provider
		
		new(String pattern, (String, Locale)=>F provider) {
			this.pattern = pattern
			this.provider = provider
		}
	}
	
	@Accessors(AccessorType.PUBLIC_GETTER)
	package var Locale locale // Protected from modification outside creation
	
	/** 
	 * Association of static elements (class and enum) to labels.
	 */
	package val reflections = new HashMap<Object, String>
	
		
	/** Provide a date formatter with multi-thread support. */
	val dateFormatProvider = 
			ThreadLocal.<Map<String, (Date)=>String>>withInitial[ new HashMap ]

	/** Provide a number formatter with multi-thread support. */
	val numberFormatProvider = 
			ThreadLocal.<Map<String, (Number)=>String>>withInitial[ new HashMap ]
	
	/**
	 * Returns the label associated to this element.
	 * 
	 * @param it to localize
	 */
	def String getLabel(Object it) { 
		getLabel(it, null)
	}
	
	/**
	 * Returns the label associated to this element.
	 * <p>
	 * If not hint is provided and no value is associated, provide toString value.
	 * </p>
	 * 
	 * @param it to localize
	 * @param hint of label to find
	 */
	def dispatch String getLabel(Object it, String hint) { 
		reflections.get(staticKey(hint)) 
			?: if (hint === null) String.valueOf(it)
	}
			
	/**
	 * Returns the label associated to this enum.
	 * 
	 * @param it to localize
	 * @param hint of label to find
	 */
	def dispatch String getLabel(Enum<?> it, String hint) {
		reflections.get(staticKey(hint)) ?: if (hint === null) name
	}
		
	/**
	 * Returns the label associated to this class.
	 * 
	 * @param it to localize
	 * @param hint of label to find
	 */
	def dispatch String getLabel(Class<?> it, String hint) {
		reflections.get(staticKey(hint)) ?: if (hint === null) simpleName
	}
	
	/**
	 * Returns the localized text of this date.
	 * 
	 * @param it to localize
	 * @param hint of label to find
	 */
	def dispatch getLabel(Date it, String hint) {
		hint.dateFormat.apply(it)
	}
	
	/**
	 * Returns the localized text of this number.
	 * 
	 * @param it to localize
	 * @param hint of label to find
	 */
	def dispatch getLabel(Number it, String hint) {
		hint.numberFormat.apply(it)
	}
	
	/**
	 * Provides a date format to localize a date.
	 * <p>
	 * This method can be updated to provide a specific strategy.
	 * </p>
	 * @param hint of format
	 */
	protected def (Date)=>String getDateFormat(String hint) {
		dateFormatProvider.get().computeIfAbsent(hint) [ createDateFormat ]
	}
	
	/**
	 * Create a reusable date format to localize a date.
	 * <p>
	 * This method can be updated to provide a specific strategy.
	 * </p>
	 * @param hint of format
	 */
	protected def (Date)=>String createDateFormat(String hint) {
		val format = if (hint === null) 
			DateFormat.getDateTimeInstance(DateFormat.SHORT, DateFormat.SHORT, locale)
		else 
			new SimpleDateFormat(hint, locale)
		
		return [ format.format(it) ]
	}
	
	/**
	 * Provides a number format to localize a date.
	 * <p>
	 * This is based on ThreadLocal&lt;Map&gt;: override for a faster implementation.
	 * </p>
	 * @param hint of format
	 */
	protected def (Number)=>String getNumberFormat(String hint) {
		numberFormatProvider.get().computeIfAbsent(hint) [ createNumberFormat ]
	}
	
	
	/**
	 * Create a reusable format to localize a number.
	 * <p>
	 * This method can be updated to provide a specific strategy.
	 * </p>
	 * @param hint of format
	 */
	protected def (Number)=>String createNumberFormat(String hint) {
		if (hint === null) {
			return [ String.valueOf(it) ]
		}
		val format = 
			(NUMBER_FORMATS.findFirst[ hint == pattern ] ?: NUMBER_FORMATS.get(0))
			.provider.apply(hint, locale)

		return [ format.format(it) ]
	}
	

	/**
	 * Associate a label to the provided class.
	 * <p>
	 * This method is protected so only subclass can call it.
	 * </p>
	 * 
	 * @param it class to associate
	 * @param value associated
	 */
	protected def void setLabel(Class<?> it, String value) { 
		setLabel(it, null, value)
	}
		
	/**
	 * Associate a label to the provided enumeration.
	 * <p>
	 * This method is protected so only subclass can call it.
	 * </p>
	 * 
	 * @param it enumeration to associate
	 * @param value associated
	 */
	protected def void setLabel(Enum<?> it, String value) { 
		setLabel(it, null, value)
	}
	
	/**
	 * Associate a label to the provided class with a specific context.
	 * <p>
	 * This method is protected so only subclass can call it.
	 * </p>
	 * 
	 * @param it class to associate
	 * @param value associated
	 * @param hint of association
	 */
	protected def void setLabel(Class<?> it, String hint, String value) { 
		reflections.put(staticKey(hint), value)
	}
	
	/**
	 * Associate a label to the provided enumeration with a specific context.
	 * <p>
	 * This method is protected so only subclass can call it.
	 * </p>
	 * 
	 * @param it enumeration to associate
	 * @param value associated
	 * @param hint of association
	 */
	protected def void setLabel(Enum<?> it, String hint, String value) { 
		reflections.put(staticKey(hint), value)
	}

	/** 
	 * Create a key for this object  
	 */
	private def static staticKey(Object it, String hint) { 
		if (hint === null) it else it->hint
	}

	
	static def <T extends I18n> T create(Class<T> type, Locale locale) {
		val loader = type.classLoader ?: ClassLoader.systemClassLoader
		val result = type.getConstructor().newInstance
		result.locale = locale
		
		val basename = type.name
		
		RB_CONTROL.getCandidateLocales(type.name, locale)
			.reverseView.tail // from general to local, avoiding root
			.map[ toL10n(basename, loader) ]
			.filter(L10n)
			// Xtend bug : it should provide <?> in parameter.
			.forEach[ Object it | (it as L10n<T>).init(result) ]
		result
	}
	
		
	static def toL10n(Locale it, String basename, ClassLoader loader) {
		val fullname = basename
			+ if (language.empty) "" else '_' + language 
			+ if (country.empty) "" else '_' + country 
			+ if (variant.empty) "" else '_' + variant
		try {
			// it is more fast to test existence or catch an exception
			// if (loader.getResource(fullname.replace('.', '/') + '.java') !== null)
			loader.loadClass(fullname).getConstructor().newInstance
		} catch(ClassNotFoundException e) {
			//TODO provided a reflection based on detected properties ??
			null
		}	
	}
	
}