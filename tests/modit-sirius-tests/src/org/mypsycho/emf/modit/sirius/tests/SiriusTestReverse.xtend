/*******************************************************************************
 * Copyright (c) 2023 Nicolas PERANSIN.
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
package org.mypsycho.emf.modit.sirius.tests

import org.junit.Test
import org.mypsycho.modit.emf.sirius.tool.SiriusReverseIt

/**
 * Test model generation and reverse.
 * 
 * @author nperansin
 */
class SiriusTestReverse extends EcoretoolsTestBase {

	@Test
	def void reverseSiriusModel() {
		new SiriusReverseIt(
			'''/«PLUGIN_ID»/resource/tables.odesign''',
			testSrcPath,
			"org.eclipse.sirius.tests.junit.TablesDesign"
		) => [
			pluginId = PLUGIN_ID
			perform
		]
	}
	
}
