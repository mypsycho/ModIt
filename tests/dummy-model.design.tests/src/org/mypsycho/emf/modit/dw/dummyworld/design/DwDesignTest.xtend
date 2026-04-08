package org.mypsycho.emf.modit.dw.dummyworld.design

import java.nio.file.Paths
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.emf.ecore.xmi.XMIResource
import org.junit.Test
import org.mypsycho.modit.emf.sirius.tool.SiriusReverseIt

/**
 * Test model generation and reverse.
 * 
 * @author nperansin
 */
// Plugin-test: Sirius needs a lot of dependencies to load odesign.
class DwDesignTest {

	// Specific
	protected static val TEST_PATH = Paths.get("target/test-run")
		.resolve(DwDesignTest.simpleName).toAbsolutePath

    	// Derived
	protected static val CLASS_NAME = DummyWorldDesign.name
	protected static val DESIGN_FILENAME = "DummyWorld.odesign"
	
	protected static val TEST_BUNDLE = "org.mypsycho.emf.modit.dummy-model.design.tests"
	protected static val REFMODEL_PATH = '''/«TEST_BUNDLE»/resources/DesignTest/«DESIGN_FILENAME»'''
	
	
	@Test
    def void writeODesign() {
    	val rs = new ResourceSetImpl()
    	
//    	// plugin test is required: Sirius drags indirect dependencies.
//    	rs.resourceFactoryRegistry.extensionToFactoryMap.put("odesign", 
//    		new ResourceFactoryImpl() // replace 
//    		// org.eclipse.sirius.viewpoint.description.util.DescriptionResourceFactoryImpl
//    	)
//    	
//    	
//    	rs.URIConverter.URIMap.put(
//    		URI.createURI("environment:/viewpoint"),
//    		URI.createPlatformPluginURI(SiriusPlugin.ID + "/model/Environment.odesign", true)
//    	)
//    	
		// new ResourceSetImpl().resourceFactoryRegistry.extensionToFactoryMap
        val res = rs.createResource(URI.createFileURI(TEST_PATH.resolve(DESIGN_FILENAME).toString))
        
        new DummyWorldDesign().loadContent(res).head
                        
        res.save(#{
        	XMIResource.OPTION_ENCODING -> "UTF-8"
        });

        // TODO compare content with Files.
    }
    
			
	@Test
	def void reverseModel() {
		new SiriusReverseIt(REFMODEL_PATH, TEST_PATH, CLASS_NAME).perform
	}
	

}