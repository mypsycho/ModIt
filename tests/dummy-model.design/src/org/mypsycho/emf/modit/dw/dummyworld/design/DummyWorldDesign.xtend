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
package org.mypsycho.emf.modit.dw.dummyworld.design

import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.sirius.properties.GroupDescription
import org.eclipse.sirius.viewpoint.description.Group
import org.eclipse.sirius.viewpoint.description.Viewpoint
import org.mypsycho.emf.modit.dw.dummyworld.DwPackage
import org.mypsycho.modit.emf.sirius.api.AbstractGroup
import org.mypsycho.modit.emf.sirius.api.DefaultPropertiesExtension
import org.mypsycho.modit.emf.sirius.api.FeaturePaging
import org.eclipse.emf.ecore.EReference

/**
 * Demo of simple 
 * 
 * 
 * @author nperansin
 */
class DummyWorldDesign extends AbstractGroup {
	
	static val PKG = DwPackage.eINSTANCE
	
	public static val VP_NAME = "DummyWorld"
	
	new () {
		businessPackages += PKG
		enableRtExpression = true
	}
		
	enum Tab { World, Comments }
	val static PAGING = new FeaturePaging(Tab.World,
		 #{
			 // 1rst is default; use null to hide.
			PKG.detailed_Description -> Tab.Comments,
			PKG.detailed_Hints -> Tab.Comments
		} 
		+ PKG.eAllContents
			.filter(EStructuralFeature)
			.filter[ reverseContainer ]
			.toInvertedMap[ null ]
	)
	
	static def isReverseContainer(EStructuralFeature it) {
		if (it instanceof EReference)
			container
		else false
	}
	
	override protected initContent(Group it) {
		ownedViewpoints += Viewpoint.create[
			name = VP_NAME
			modelFileExtension = "*.dw"
			ownedRepresentations += new CompanyDiagram(this).createContent
			ownedRepresentations += new DirectoryTable(this).createContent
		]
		
		extensions += new DefaultPropertiesExtension(this, Tab.values) {
			
			override isPageApplicable(EObject value, Object pageId) {
				PAGING.isApplicable(value, pageId)
			}
			
			override isFeatureApplicable(EObject value, EStructuralFeature feature, Object pageId) {
				PAGING.isApplicable(value, feature, pageId)
			}
				
			override createSpecificGroups() {
				#[
					Tab.World -> GroupDescription.create[
						name = "DummyWorldSuppProps"
						label = "Debug"
						
//						controls += LabelDescription.create[
//							name = "DummyWorldSuppLabel"
//							labelExpression = "aql:'Type'"
//							valueExpression = "aql:self"
//							displayExpression = expression[ eClass.name ]
//						]
						
					]
				]
			}
			
		}.createContent

	}
	
}