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

import java.nio.file.Paths
import org.eclipse.emf.common.util.URI
import java.util.Objects

/**
 * Lightweight object to store class identification.
 * <p>
 * Used by EReverse to identify generated classes.
 * </p>
 */
class ClassId {

	/** Package name */
	public val String pack

	/** Simple class name */
	public val String name

	/** Constructor for class fullname */
	new(String classname) {
		val index = classname.lastIndexOf('.')
		if (index != -1) {
			pack = classname.substring(0, index)
			name = classname.substring(index + 1).replace("\\$", ".")
		} else {
			pack = null
			name = classname.replace("\\$", ".")
		}
	}

  /** Constructor for package and simple class name */
	new(String pack, String name) {
		this.pack = pack
		this.name = name
	}

	new(ClassId parent, URI id) {
		pack = parent.pack
		name = id.path
	}

	def toPath() {
		Paths.get(pack?.replace('.', '/') ?: '.', name.replace("\\.", "\\$") + ".xtend")
	}

	def qName() {
		if (pack !== null) pack + "." + name else name
	}

	override toString() {
		qName
	}
	
	override equals(Object o) {
		(this == o)
			|| if (o instanceof ClassId) 
				(Objects.equals(name, o.name) && Objects.equals(pack, o.pack)) 
			else false
	}
	
	override hashCode() {
		(name?:"").hashCode + (pack?:"").hashCode*32
	}
	

}
