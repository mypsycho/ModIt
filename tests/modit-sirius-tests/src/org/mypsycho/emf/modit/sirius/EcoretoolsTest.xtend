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
import org.mypsycho.emf.modit.sirius.tests.Activator

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

	protected static val RES_SEGMENT = "resource/EcoretoolsTest"


	protected static val PLUGIN_ID = Activator.PLUGIN_ID
	protected static val TEST_BUNDLE = "org.eclipse.emf.ecoretools.design"
	protected static val PACKAGE_PATH = "org.eclipse.emf.ecoretools.design".replace('.', '/')
	protected static val REFMODEL_PATH = '''/«PLUGIN_ID»/«RES_SEGMENT»/'''
	
	protected static val REFSRC_DIR = Paths.get("src").toAbsolutePath
		
	protected static val TESTSRC_PATH = TEST_DIR.resolve("src")
			
	@Test
	def void reverseSiriusModel() {
		val it = new SiriusReverseIt(
			REFMODEL_PATH + "ecoretools_result.odesign",
			TESTSRC_PATH,
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
			TESTSRC_PATH,
			rs.getResource(uri, true)
		).perform
		
		// TODO fixme
		// assertSamePackage(PACKAGE_PATH + "/modit")
	}

	
	@Test //@Ignore // Issue with default initialisation.
    def void writeSiriusODesign() {
    	val it = new EcoretoolsDesign()
    	pluginId = PLUGIN_ID
    	// assertOdesignEquals("ecoretools_result.odesign")
    }
    
    	
	@Test
    def void writeModitODesign() {
    	new PlainDesign()
    		.assertOdesignEquals("ecoretools_plain.odesign")
    }
    
    
    protected def void assertOdesignEquals(ModitModel content, String filename) {
    	val testFile = TEST_DIR.resolve(RES_SEGMENT).resolve(filename)
    	val rs = new ResourceSetImpl()
        val res = rs.createResource(URI.createFileURI(testFile.toString))
        content.loadContent(res).head
                        
        res.save(#{
        	XMIResource.OPTION_ENCODING -> "ASCII"
        });

		// TODO Fix issue with properties

//        FileComparator.assertIdentical(
//        	testFile, 
//        	Paths.get(RES_SEGMENT).resolve(filename).toAbsolutePath
//        )
    }
    
	def assertSamePackage(String packagePath) {
		FileComparator.assertIdentical(
        	TESTSRC_PATH.resolve(packagePath),
        	REFSRC_DIR.resolve(packagePath)
        )
	}	


}
