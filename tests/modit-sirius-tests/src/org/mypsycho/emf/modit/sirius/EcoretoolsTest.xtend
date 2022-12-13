package org.mypsycho.emf.modit.sirius

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
import org.junit.Ignore

/**
 * Test model generation and reverse.
 * 
 * @author nperansin
 */
// Plugin-test: Sirius needs a lot of dependencies to load odesign.
class EcoretoolsTest {

	// Specific
	protected static val TEST_DIR = Paths.get("target/test-run").toAbsolutePath
		.resolve(EcoretoolsTest.simpleName)

	protected static val TEST_BUNDLE = "org.eclipse.emf.ecoretools.design"
	protected static val PACKAGE_PATH = "org.eclipse.emf.ecoretools.design".replace('.', '/')
	protected static val REFMODEL_PATH = '''/org.mypsycho.emf.modit.sirius.tests/resource/EcoretoolsTest/ecore.odesign'''
	
	protected static val REFSRC_DIR = Paths.get("src").toAbsolutePath
		
	protected static val TESTSRC_PATH = TEST_DIR.resolve("src")

	protected static val MODEL_REF = Paths.get("resource/EcoretoolsTest/ecore.odesign").toAbsolutePath
			
	@Test
	def void reverseSiriusModel() {
		new SiriusReverseIt(
			REFMODEL_PATH,
			TESTSRC_PATH,
			TEST_BUNDLE + ".sirius.EcoretoolsDesign"
		).perform
		
		assertSamePackage(PACKAGE_PATH + "/sirius")
	}
	
	@Test
	def void reverseModel() {
		val rs = new ResourceSetImpl
		new EReversIt(
			TEST_BUNDLE + ".modit.PlainDesign",
			TESTSRC_PATH,
			rs.getResource(URI.createPlatformPluginURI(REFMODEL_PATH, true), true)
		).perform
		
		assertSamePackage(PACKAGE_PATH + "/modit")
	}

	def assertSamePackage(String packagePath) {
		FileComparator.assertIdentical(
        	TESTSRC_PATH.resolve(packagePath),
        	REFSRC_DIR.resolve(packagePath)
        )
	}	

	
	@Test //@Ignore // Issue with default initialisation.
    def void writeSiriusODesign() {
    	new EcoretoolsDesign().assertContentEquals("description/ecoretools_result.odesign")
    }
    
    	
	@Test
    def void writeModitODesign() {
    	new PlainDesign().assertContentEquals("description/ecoretools_plain.odesign")
    }
    
    
    protected def void assertContentEquals(ModitModel content, String filename) {
    	val TEST_FILE = TEST_DIR.resolve(filename)
    	val rs = new ResourceSetImpl()
        val res = rs.createResource(URI.createFileURI(TEST_DIR.resolve(filename).toString))
        content.loadContent(res).head
                        
        res.save(#{
        	XMIResource.OPTION_ENCODING -> "ASCII"
        });

        FileComparator.assertIdentical(
        	TEST_DIR.resolve(filename), 
        	MODEL_REF
        )
    }
    

}
