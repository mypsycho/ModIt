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
import org.eclipse.sirius.table.metamodel.table.DColumn
import org.eclipse.sirius.table.metamodel.table.description.EditionTableDescription
import org.mypsycho.emf.modit.dw.dummyworld.Company
import org.mypsycho.emf.modit.dw.dummyworld.Contact
import org.mypsycho.emf.modit.dw.dummyworld.Directory
import org.mypsycho.emf.modit.dw.dummyworld.DwPackage
import org.mypsycho.emf.modit.dw.dummyworld.Person
import org.mypsycho.modit.emf.sirius.api.SiriusFeatureTable
import org.mypsycho.modit.emf.sirius.api.SiriusVpGroup

import static extension org.mypsycho.modit.emf.sirius.api.SiriusDesigns.*

/**
 * Create a table of contact location.
 * <p>
 * It contains a tree of companies and 
 * </p>
 * 
 * @author nperansin
 */
class DirectoryTable extends SiriusFeatureTable {
	
	static val PKG = DwPackage.eINSTANCE

	static val GROUP_LINES = #[ // header   -> add.title -> add.task
		'Companies' -> Company -> [ PKG.dwFactory.createCompany ],
		'People' -> Person -> [ PKG.dwFactory.createPerson ]
	]
	
	new(SiriusVpGroup context) {
		super(context, "Directory", Directory)
	}
	
	override initContent(EditionTableDescription it) {
		
		createLine("subDir", Directory.simpleName + ' at root') [ root, element, container |
			(root as Directory).directories += PKG.dwFactory.createDirectory
		]
		
		ownedLine("subDir") [
			domainClass = Directory
			semanticCandidates = PKG.directory_Directories
			headerLabelExpression = context.expression[ (it as Directory).name ] // could be localized
			
			createAddLine("subDir", "Sub-" + Directory.simpleName) [ root, element, container |
				(element as Directory).directories += PKG.dwFactory.createDirectory
			]
			
			reusedSubLines += "subDir".lineRef
			reusedSubLines += GROUP_LINES.map[ (key.value.simpleName + "Group").lineRef ]
		]
		
		
		GROUP_LINES.forEach[ descr |
			val title = descr.key.key
			val type = descr.key.value
			val doCreate = descr.value
			
			ownedLine(type.simpleName + "Group") [
				virtual = title.constant
				
				ownedLine(type.simpleName) [
					domainClass = type
					semanticCandidates = PKG.directory_Contacts
					headerLabelExpression = context.itemProviderLabel
				]
								
				createAddLine(type.simpleName, type.simpleName) [ root, element, container |
					(element as Directory).contacts += doCreate.apply(element)
				]
			]
		]
		
		
		// expression should be out of loop
		val cellLabel = context.expression(params(EditArg.lineSemantic, EditArg.column))
			[ EObject it, DColumn col |
				if (it instanceof Contact) locations.findFirst[ name == col.label ]?.value
			]
		
		
		// well-known location
		"Mail,Phone,Address,Web site".split(",").forEach[ locationId |
			ownedColumn(locationId, PKG.contact_Locations) [
				// any valid property but is useless in all examples.
				headerLabelExpression = locationId
				labelExpression = cellLabel
				
				canEdit = [ it instanceof Contact ]
				directEdit = [ Contact it, String value |
				
					(locations.findFirst[ name == locationId ] ?: {
						val newLoc = PKG.dwFactory.createLocation
						newLoc.name = locationId
						locations += newLoc
						newLoc
					}).value = value
				]	
			]

		]
		

	}
	
	
}