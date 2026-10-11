/*******************************************************************************
 * Copyright (c) 2026 OBEO.
 * 
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
 package org.mypsycho.modit.emf.sirius.api

import java.nio.charset.StandardCharsets
import java.nio.file.Files
import java.nio.file.Path
import java.util.Map
import org.eclipse.emf.codegen.ecore.genmodel.GenModel
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.plugin.EcorePlugin
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.emf.ecore.xmi.XMIResource
import org.eclipse.emf.ecore.xmi.XMLResource
import org.eclipse.sirius.viewpoint.description.Group
import org.eclipse.sirius.viewpoint.description.RepresentationDescription
import org.eclipse.sirius.viewpoint.description.RepresentationExtensionDescription
import org.eclipse.emf.ecore.xmi.impl.URIHandlerImpl
import org.mypsycho.modit.emf.sirius.SiriusModelProvider

class SiriusSaves {
	
	
	static val SAVE_OPTIONS = #{
		XMIResource.OPTION_ENCODING -> StandardCharsets.UTF_8.name(),
		XMLResource.OPTION_RECORD_UNKNOWN_FEATURE -> true, // DescriptionResourceFactoryImpl
		XMLResource.OPTION_URI_HANDLER -> new URIHandlerImpl.PlatformSchemeAware // CustomSiriusEditor
	}
	
	
	def static save(Class<? extends SiriusModelProvider> contentClass, String pluginFile, Path pluginsFolder) {
		contentClass.declaredConstructor.newInstance.save(pluginFile, pluginsFolder)
	}
	
	def static save(SiriusModelProvider content, String pluginFile, Path pluginsFolder) {
		
		val rs = new ResourceSetImpl()
		val res = rs.createResource(URI.createPlatformResourceURI(pluginFile, true))
		if (res instanceof XMLResource) {
			// DescriptionResourceFactoryImpl add a version modifier.
			res.defaultSaveOptions.remove(XMLResource.OPTION_RESOURCE_HANDLER)
			// It is un-welcome for patch.
		}
		
        val result = content
        	.loadContent(res)
        	.head
		
		result.updateMetamodels
		
		try (val out = Files.newOutputStream(pluginsFolder.resolve(pluginFile))) {
			res.save(out, SAVE_OPTIONS)
		}
		
		result
	}
	
	static def updateMetamodels(Group it) {
    	val toGenModels = EcorePlugin.getEPackageNsURIToGenModelLocationMap(false)
        val toEcorePackages = <EPackage, EPackage>newHashMap
        val rs = eResource.resourceSet
        
        ownedViewpoints
        	.flatMap[ eContents ]
        	.map[
        		switch (it) {
        			RepresentationDescription: metamodel
        			RepresentationExtensionDescription: metamodel
        			default: #[]
        		}
        		
        	].forEach[ metamodels |
        		for (i : 0 ..< metamodels.size) {
        			val mm = metamodels.get(i);
        			val mmSource = mm.findMetamodelSource(rs, toGenModels, toEcorePackages)
        			metamodels.set(i, mmSource ?: mm)
        		}
        	]
    }
    
    static def findMetamodelSource(EPackage mm, ResourceSet context, Map<String, URI> epackageToGenModels, Map<EPackage, EPackage> cache) {
   		cache.computeIfAbsent(mm) [
			val genModelUri = epackageToGenModels.get(mm.getNsURI())
			if (genModelUri === null) {
				return null
			}
			context.getResource(genModelUri, true)
				.contents
				.filter(GenModel)
				.flatMap[ allGenPackagesWithClassifiers ]
				.map[ getEcorePackage ]
				.findFirst[ mm.nsURI == nsURI ]
		]
    
    }
    
    
	
}