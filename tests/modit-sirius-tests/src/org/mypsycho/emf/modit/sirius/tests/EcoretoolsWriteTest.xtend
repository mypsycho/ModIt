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

import org.eclipse.emf.ecoretools.design.modit.PlainDesign
import org.eclipse.emf.ecoretools.design.sirius.EcoretoolsDesign
import org.junit.Test

/**
 * Test model generation and reverse.
 * 
 * @author nperansin
 */
// Plugin-test: Sirius needs a lot of dependencies to load odesign.
class EcoretoolsWriteTest extends EcoretoolsTestBase {

	@Test //@Ignore // Issue with default initialisation.
    def void writeSiriusODesign() {
    	new EcoretoolsDesign() => [
	    	pluginId = PLUGIN_ID
	    	assertOdesignEquals("ecoretools_result.odesign")    	
    	]
    }
    
	@Test
    def void writeModitODesign() {
    	new PlainDesign()
    		.assertOdesignEquals("ecoretools_plain.odesign")
    }
    
    


}
