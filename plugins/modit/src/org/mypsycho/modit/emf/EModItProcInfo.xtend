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

import org.eclipse.emf.common.notify.impl.AdapterImpl
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.util.EcoreUtil

/**
 * Class to bind values to an EObject.
 * <p>
 * Identification of attachment is link to type.
 * </p>
 */
class EModItProcInfo extends AdapterImpl {
	
	/** Possible types of attachment */
	enum PiType { 
		alias, path, content, init, assemble, reference, id
	}

	/** type of attachment */
	val PiType type

	/** value attached */
	val Object value

	/**
	 * Create a new attachment.
	 * 
	 * @param type of attachment
	 * @param value attached
	 */
	new(PiType type, Object value) {
		this.value = value;
		this.type = type;
	}

	override isAdapterForType(Object type) {
		return this.type == type
	}
	
	/**
	 * Attaches a value on the given EObject.
	 *
	 * @param type of attachment
	 * @param it to attach
	 * @param value to be attach
	 */
	static def void bind(PiType type, EObject it, Object value) {
		unbind(type, it)
		eAdapters.add(new EModItProcInfo(type, value))
	}
	
		
	/**
	 * Returns true if a value of the type is attached 
	 *
	 * @param type of attachment
	 * @param it to test
	 */
	static def void isBound(PiType type, EObject it) {
		EcoreUtil.getAdapter(eAdapters, type) !== null
	}
	
	/**
	 * Detaches any id from the object and returns it.
	 *
	 * @param type of attachment
	 * @param it to detach
	 * @return attached value or null
	 */
	 static def <S> S unbind(PiType type, EObject it) {
		val previous = EcoreUtil.getAdapter(eAdapters, type) as EModItProcInfo
		if (previous === null) return null
		eAdapters.remove(previous)
		previous.value as S
	}

	
	/**
	 * Detaches any id from the object and returns it.
	 *
	 * @param type of attachment
	 * @param it to detach
	 * @return attached value or null
	 */
	 static def <S> S test(PiType type, EObject it) {
		(EcoreUtil.getAdapter(eAdapters, type) as EModItProcInfo)?.value as S
	}

}