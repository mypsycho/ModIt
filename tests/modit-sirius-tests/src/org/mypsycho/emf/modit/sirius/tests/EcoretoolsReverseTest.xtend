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

import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.sirius.properties.ViewExtensionDescription
import org.eclipse.sirius.viewpoint.description.Group
import org.junit.Test
import org.mypsycho.modit.emf.ClassId
import org.mypsycho.modit.emf.EReversIt
import org.mypsycho.modit.emf.ESingleReversIt
import org.mypsycho.modit.emf.sirius.api.SiriusDesigns
import org.mypsycho.modit.emf.sirius.tool.SiriusReverseIt

/**
 * Test model generation and reverse.
 * 
 * @author nperansin
 */
// Plugin-test: Sirius needs a lot of dependencies to load odesign.
class EcoretoolsReverseTest extends EcoretoolsTestBase {

	@Test
	def void reverseSiriusModel() {
		new SiriusReverseIt(
			REFMODEL_PATH + "ecoretools_sirius.odesign",
			testSrcPath,
			TEST_BUNDLE + ".sirius.EcoretoolsDesign"
		) =>[
			pluginId = PLUGIN_ID
			perform
		]

		assertSamePackage(TEST_BUNDLE + ".sirius")
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
		
		assertSamePackage(TEST_BUNDLE + ".modit")
	}

	@Test
	def void reverseSingleModel() {
		val rs = new ResourceSetImpl
		val uri = URI.createPlatformPluginURI(REFMODEL_PATH + "ecoretools_plain.odesign", true)
		val res = rs.getResource(uri, true)
		val pack = TEST_BUNDLE + ".split"
		
		val it = new ESingleReversIt(
			pack + ".ToolDesign",
			testSrcPath,
			res
		)
		
		splits += (res.contents.head as Group)
			.findSplitGroupParts
			.toInvertedMap[ toClassId(pack) ]
		
		perform
		
		assertSamePackage(TEST_BUNDLE + ".split")
	}


	protected def findSplitGroupParts(Group it) {
		ownedViewpoints.flatMap[ ownedRepresentations + ownedRepresentationExtensions ]
			+ extensions.filter(ViewExtensionDescription)
	}

	protected def toClassId(EObject it, String packName) {
		new ClassId(packName, SiriusDesigns.toClassname(it))
	}

}

