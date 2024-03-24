/*******************************************************************************
 * Copyright (c) 2019 OBEO.
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
package org.mypsycho.modit.emf.sirius.tool

import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.sirius.diagram.description.style.EdgeStyleDescription
import org.eclipse.sirius.tree.description.ConditionalTreeItemStyleDescription
import org.eclipse.sirius.tree.description.DescriptionPackage
import org.eclipse.sirius.tree.description.TreeDescription
import org.eclipse.sirius.tree.description.TreeItemContainerDropTool
import org.eclipse.sirius.tree.description.TreeItemCreationTool
import org.eclipse.sirius.tree.description.TreeItemDeletionTool
import org.eclipse.sirius.tree.description.TreeItemEditionTool
import org.eclipse.sirius.tree.description.TreeItemMapping
import org.eclipse.sirius.tree.description.TreeItemStyleDescription
import org.eclipse.sirius.tree.description.TreeItemTool
import org.eclipse.sirius.viewpoint.description.IdentifiedElement
import org.eclipse.sirius.viewpoint.description.style.BasicLabelStyleDescription
import org.mypsycho.modit.emf.ClassId
import org.mypsycho.modit.emf.sirius.api.SiriusTree
import org.eclipse.sirius.viewpoint.description.style.StylePackage

/** Override of default reverse for SiriusModelProvider class. */
class TreeTemplate extends RepresentationTemplate<TreeDescription> {
	
	static val TPKG = DescriptionPackage.eINSTANCE
	static val NS_MAPPING = #[
		TreeItemMapping -> SiriusTree.Ns.item
	]
	static val CONTAINMENT_ORDER = #[ 
		TreeDescription -> #[
			TPKG.treeItemMappingContainer_SubItemMappings
		]
	]
	static val INIT_TEMPLATED = #{
		TreeDescription -> #{
			PKG.identifiedElement_Label,
			TPKG.treeDescription_DomainClass
		},
		TreeItemTool -> #{
			TPKG.treeItemTool_Variables,
			// also container variables, it mays cause issue
			TPKG.treeItemContainerDropTool_OldContainer,
			TPKG.treeItemContainerDropTool_NewContainer,
			TPKG.treeItemContainerDropTool_Element,
			TPKG.treeItemContainerDropTool_NewViewContainer,
			TPKG.treeItemContainerDropTool_PrecedingSiblings,
			TPKG.treeItemTool_FirstModelOperation
		},
		TreeItemMapping -> #{
			PKG.identifiedElement_Name,
			TPKG.treeItemMapping_DomainClass
		}
	}
	static val TOOL_FEATS = #{
		TPKG.treeItemMappingContainer_DropTools,
		TPKG.treeItemMapping_Create,
		TPKG.treeDescription_CreateTreeItem,
		TPKG.treeItemMapping_Delete,
		TPKG.treeItemUpdater_DirectEdit
	}
	

	new(SiriusGroupTemplate container) {
		super(container, TreeDescription)
	}
	
	override getNsMapping() { NS_MAPPING }
		
	override getContainmentOrders() { CONTAINMENT_ORDER }
	
	/** Set of classes used in sub-parts by the default implementation  */
	override getPartStaticImports(EObject it) {
		#{ SiriusTree, BasicLabelStyleDescription, EdgeStyleDescription } 
			+ INIT_TEMPLATED.keySet
			// + !!! requires metamodel !!!
	}
	
	override getInitTemplateds() { INIT_TEMPLATED }

	override isApplicableTemplate(TreeDescription it) {
		domainClass.classFromDomain !== null
	}
	
	override templateRepresentation(ClassId it, TreeDescription content) {
'''package «pack»

«templateImports»

import static extension org.mypsycho.modit.emf.sirius.api.SiriusDesigns.*

class «name» extends «SiriusTree.templateClass» {

	new(«parentClassName» parent) {
		super(parent, «
			content.name.toJava», «
			content.label.toJava», «
			content.domainClass.classFromDomain.templateClass»)
	}

	override initContent(«TreeDescription.templateClass» it) {
		«content.templateFilteredContent(TreeDescription)»
	}

}''' // end-of-class
	}
	

	override templatePropertyValue(EStructuralFeature feat, Object value, (Object)=>String encoding) {
		feat == TPKG.styleUpdater_DefaultStyle
			? (value as TreeItemStyleDescription).templateMappingStyle
			: feat == TPKG.styleUpdater_ConditionalStyles
			? (value as ConditionalTreeItemStyleDescription).templateMappingConditionnalStyle
			: feat == TPKG.treeItemMappingContainer_SubItemMappings
			? (value as TreeItemMapping).templateSubItem
			: TOOL_FEATS.contains(feat)
			? (value as TreeItemTool).templateTreeTool
			: super.templatePropertyValue(feat, value, encoding)
	}
	
	private def extraRef(String name) {
		context.explicitExtras
			.entrySet
			.findFirst[ value == name ]
			?.key
	}
	
	override getInnerContent(EObject it) {
		val result = super.getInnerContent(it)
		if (it instanceof TreeItemStyleDescription) {
			val defaultValues = #{
				StylePackage.eINSTANCE.basicLabelStyleDescription_LabelColor -> (labelColor == extraRef("color:black")),
				TPKG.treeItemStyleDescription_BackgroundColor -> (backgroundColor == extraRef("color:white"))
			}
			return result.filter[ defaultValues.get(key) != Boolean.TRUE ]
		}
		result
	}
	
	def templateMappingStyle(TreeItemStyleDescription it) {
'''style = [
	«templateInnerContent(innerContent)»
]'''
	}
	
	def templateMappingConditionnalStyle(ConditionalTreeItemStyleDescription it) {
'''styleIf(«predicateExpression.toJava») [
	«style?.templateInnerContent(style?.innerContent) ?: ""»
]'''
	}

	
	def templateSubItem(TreeItemMapping it) {
'''subItem(«name.toJava», «domainClass.toJava») [
	«templateFilteredContent(TreeItemMapping)»
]'''
	}
	
	def templateTreeTool(TreeItemTool it) {
		val method = switch(it) {
			TreeItemContainerDropTool : "drop"
			TreeItemCreationTool: "itemCreate"
			TreeItemDeletionTool: "delete"
			TreeItemEditionTool: "edit"
		}
'''«method»(«name.toJava») [
	«templateFilteredContent(TreeItemTool)»
	«firstModelOperation.templateToolOperation»
]'''
	}

	override aliasPath(IdentifiedElement it) {
		it instanceof TreeItemMapping
			? SiriusTree.treePath(it)
			: super.aliasPath(it)
	}

}
