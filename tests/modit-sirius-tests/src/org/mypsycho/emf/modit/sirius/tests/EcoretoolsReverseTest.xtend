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

import java.nio.file.Paths
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.emf.ecore.xmi.XMIResource
import org.eclipse.emf.ecoretools.design.modit.PlainDesign
import org.eclipse.emf.ecoretools.design.sirius.EcoretoolsDesign
import org.junit.Test
import org.mypsycho.modit.emf.EReversIt
import org.mypsycho.modit.emf.ModitModel
import org.mypsycho.modit.emf.sirius.tool.SiriusReverseIt
import org.mypsycho.emf.modit.sirius.tests.Activator

/**
 * Test model generation and reverse.
 * 
 * @author nperansin
 */
// Plugin-test: Sirius needs a lot of dependencies to load odesign.
class EcoretoolsReverseTest extends EcoretoolsTestBase {


	@Test
	def void reverseSiriusModel() {
		val it = new SiriusReverseIt(
			REFMODEL_PATH + "ecoretools_result.odesign",
			testSrcPath,
			TEST_BUNDLE + ".sirius.EcoretoolsDesign"
		)
		pluginId = PLUGIN_ID
		perform
		
		assertSamePackage(PACKAGE_PATH + "/sirius")
	}
	
	@Test
	def void reverseModel() {
		val rs = new ResourceSetImpl
		val uri = URI.createPlatformPluginURI(REFMODEL_PATH + "ecoretools_plain.odesign", true)
		new EReversIt(
			TEST_BUNDLE + ".modit.PlainDesign",
			testSrcPath,
			rs.getResource(uri, true)
		).perform
		
		// TODO fixme
		// assertSamePackage(PACKAGE_PATH + "/modit")
	}


}
