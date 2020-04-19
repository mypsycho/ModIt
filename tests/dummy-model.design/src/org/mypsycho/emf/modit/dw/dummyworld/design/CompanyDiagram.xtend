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

import org.eclipse.sirius.business.api.session.SessionManager
import org.eclipse.sirius.diagram.ContainerLayout
import org.eclipse.sirius.diagram.EdgeArrows
import org.eclipse.sirius.diagram.LineStyle
import org.eclipse.sirius.diagram.description.ContainerMapping
import org.eclipse.sirius.diagram.description.EdgeMapping
import org.eclipse.sirius.diagram.description.Layer
import org.eclipse.sirius.diagram.description.NodeMapping
import org.eclipse.sirius.diagram.description.style.ContainerStyleDescription
import org.eclipse.sirius.diagram.description.style.EdgeStyleDescription
import org.eclipse.sirius.diagram.description.style.SquareDescription
import org.eclipse.sirius.viewpoint.description.SystemColor
import org.mypsycho.emf.modit.dw.dummyworld.Activity
import org.mypsycho.emf.modit.dw.dummyworld.Company
import org.mypsycho.emf.modit.dw.dummyworld.DwPackage
import org.mypsycho.emf.modit.dw.dummyworld.Job
import org.mypsycho.emf.modit.dw.dummyworld.Service
import org.mypsycho.modit.emf.sirius.api.AbstractDiagram
import org.mypsycho.modit.emf.sirius.api.SiriusDesigns

/**
 * Organization chart of Company.
 *
 * @author nperansin
 */
class CompanyDiagram extends AbstractDiagram {
	
	static val PKG = DwPackage.eINSTANCE
	
	new(DummyWorldDesign parent) {
		super(parent, "Organization chart", Company)
	}
	
	override initContent(Layer it) {
		
		containerMappings += ContainerMapping.createAs("node:company_Employees") [
			semanticCandidatesExpression = PKG.company_Employees
			childrenPresentation = ContainerLayout.LIST
			
			style = ContainerStyleDescription.createStyle
			
			subNodeMappings += NodeMapping.create[
				domainClass = Service	
			
				// Cross Reference fails !!
				// associated elements will always be wrong !!!
				semanticCandidatesExpression = context.expression[ Job it |
					SessionManager.INSTANCE.getSession(it)
						.semanticCrossReferencer.getNonNavigableInverseReferences(it)
						.filter[ EStructuralFeature == PKG.activity_SupportedBy ]
						.map[ EObject as Activity ]
						.toSet
				]
				
				style = SquareDescription.createStyle
			]
			
		]
		
		edgeMappings += EdgeMapping.createAs("edge:company_team")[
			sourceMapping += ContainerMapping.ref("node:company_Employees")
			targetMapping += ContainerMapping.ref("node:company_Employees")
			targetFinderExpression = SiriusDesigns.encode(PKG.job_Team)
			
			style = EdgeStyleDescription.create [
				lineStyle = LineStyle.DASH_LITERAL
				// by default, target is an arrow
				targetArrow = EdgeArrows.NO_DECORATION_LITERAL
				sourceArrow = EdgeArrows.INPUT_ARROW_LITERAL
				
				strokeColor = (extras.get("color:black") as SystemColor)
//				centerLabelStyleDescription = CenterLabelStyleDescription.createStyle [
//					showIcon = false				
//					labelExpression = "" // no text
//				]
			]
		]
		
		
	}
	
}