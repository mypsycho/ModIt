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
import org.mypsycho.modit.emf.ModitModel

/**
 * Test model generation and reverse.
 * 
 * @author nperansin
 */
// Plugin-test: Sirius needs a lot of dependencies to load odesign.
class EcoretoolsTestBase {

	// Specific
	protected static val RES_SEGMENT = "resource/EcoretoolsTest"

	protected static val PLUGIN_ID = Activator.PLUGIN_ID
	protected static val TEST_BUNDLE = "org.eclipse.emf.ecoretools.design"
	protected static val REFMODEL_PATH = '''/«PLUGIN_ID»/«RES_SEGMENT»/'''
	
	protected static val REFSRC_DIR = Paths.get("src").toAbsolutePath
		
	protected val testDir = Paths.get("target/test-run")
		.toAbsolutePath
		.resolve(getClass().simpleName)
	protected val testSrcPath = testDir.resolve("src")
			

    protected def void assertOdesignEquals(ModitModel content, String filename) {
    	val testFile = testDir
    		.resolve(RES_SEGMENT)
    		.resolve(filename)
    	val rs = new ResourceSetImpl()
        val res = rs.createResource(URI.createFileURI(testFile.toString))
        content.loadContent(res).head
                        
        res.save(#{
        	XMIResource.OPTION_ENCODING -> "ASCII"
        });

        FileComparator.assertIdentical(
        	testFile, 
        	Paths.get(RES_SEGMENT).resolve(filename).toAbsolutePath
        )
    }
    
	def assertSamePackage(String packageName) {
		val packagePath = packageName.replace('.', '/')
		FileComparator.assertIdentical(
        	testSrcPath.resolve(packagePath),
        	REFSRC_DIR.resolve(packagePath)
        )
	}	

}
