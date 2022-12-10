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
 package org.mypsycho.modit.emf.sirius.api

import java.util.Objects
import org.eclipse.emf.ecore.EAttribute
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.sirius.diagram.EdgeArrows
import org.eclipse.sirius.diagram.EdgeRouting
import org.eclipse.sirius.diagram.description.AbstractNodeMapping
import org.eclipse.sirius.diagram.description.BooleanLayoutOption
import org.eclipse.sirius.diagram.description.CenteringStyle
import org.eclipse.sirius.diagram.description.ConditionalContainerStyleDescription
import org.eclipse.sirius.diagram.description.ConditionalNodeStyleDescription
import org.eclipse.sirius.diagram.description.ContainerMapping
import org.eclipse.sirius.diagram.description.CustomLayoutConfiguration
import org.eclipse.sirius.diagram.description.DiagramDescription
import org.eclipse.sirius.diagram.description.DiagramElementMapping
import org.eclipse.sirius.diagram.description.DoubleLayoutOption
import org.eclipse.sirius.diagram.description.EdgeMapping
import org.eclipse.sirius.diagram.description.EnumLayoutOption
import org.eclipse.sirius.diagram.description.EnumLayoutValue
import org.eclipse.sirius.diagram.description.EnumSetLayoutOption
import org.eclipse.sirius.diagram.description.IntegerLayoutOption
import org.eclipse.sirius.diagram.description.Layer
import org.eclipse.sirius.diagram.description.LayoutOption
import org.eclipse.sirius.diagram.description.LayoutOptionTarget
import org.eclipse.sirius.diagram.description.NodeMapping
import org.eclipse.sirius.diagram.description.StringLayoutOption
import org.eclipse.sirius.diagram.description.style.BorderedStyleDescription
import org.eclipse.sirius.diagram.description.style.BundledImageDescription
import org.eclipse.sirius.diagram.description.style.ContainerStyleDescription
import org.eclipse.sirius.diagram.description.style.CustomStyleDescription
import org.eclipse.sirius.diagram.description.style.EdgeStyleDescription
import org.eclipse.sirius.diagram.description.style.FlatContainerStyleDescription
import org.eclipse.sirius.diagram.description.style.NodeStyleDescription
import org.eclipse.sirius.diagram.description.style.WorkspaceImageDescription
import org.eclipse.sirius.diagram.description.tool.ContainerCreationDescription
import org.eclipse.sirius.diagram.description.tool.ContainerDropDescription
import org.eclipse.sirius.diagram.description.tool.DeleteElementDescription
import org.eclipse.sirius.diagram.description.tool.DiagramCreationDescription
import org.eclipse.sirius.diagram.description.tool.DirectEditLabel
import org.eclipse.sirius.diagram.description.tool.DoubleClickDescription
import org.eclipse.sirius.diagram.description.tool.EdgeCreationDescription
import org.eclipse.sirius.diagram.description.tool.NodeCreationDescription
import org.eclipse.sirius.diagram.description.tool.NodeCreationVariable
import org.eclipse.sirius.diagram.description.tool.ReconnectEdgeDescription
import org.eclipse.sirius.diagram.description.tool.ReconnectionKind
import org.eclipse.sirius.diagram.description.tool.SourceEdgeCreationVariable
import org.eclipse.sirius.diagram.description.tool.SourceEdgeViewCreationVariable
import org.eclipse.sirius.diagram.description.tool.TargetEdgeCreationVariable
import org.eclipse.sirius.diagram.description.tool.TargetEdgeViewCreationVariable
import org.eclipse.sirius.viewpoint.description.Customization
import org.eclipse.sirius.viewpoint.description.EAttributeCustomization
import org.eclipse.sirius.viewpoint.description.EReferenceCustomization
import org.eclipse.sirius.viewpoint.description.EStructuralFeatureCustomization
import org.eclipse.sirius.viewpoint.description.SystemColor
import org.eclipse.sirius.viewpoint.description.VSMElementCustomization
import org.eclipse.sirius.viewpoint.description.style.BasicLabelStyleDescription
import org.eclipse.sirius.viewpoint.description.tool.AbstractToolDescription
import org.eclipse.sirius.viewpoint.description.tool.ContainerViewVariable
import org.eclipse.sirius.viewpoint.description.tool.DragSource
import org.eclipse.sirius.viewpoint.description.tool.DropContainerVariable
import org.eclipse.sirius.viewpoint.description.tool.EditMaskVariables
import org.eclipse.sirius.viewpoint.description.tool.ElementDeleteVariable
import org.eclipse.sirius.viewpoint.description.tool.ElementDropVariable
import org.eclipse.sirius.viewpoint.description.tool.ElementSelectVariable
import org.eclipse.sirius.viewpoint.description.tool.InitEdgeCreationOperation
import org.eclipse.sirius.viewpoint.description.tool.InitialContainerDropOperation
import org.eclipse.sirius.viewpoint.description.tool.InitialNodeCreationOperation
import org.eclipse.sirius.viewpoint.description.tool.ModelOperation

import static extension org.mypsycho.modit.emf.sirius.api.SiriusDesigns.*

/**
 * Adaptation of Sirius model into Java and EClass reflections API
 * for Diagrams.
 * 
 * @author nicolas.peransin
 */
abstract class AbstractDiagramPart<T extends EObject> extends AbstractTypedEdition<T> {

	/** Namespaces for identification */
	enum Ns { // namespace for identication
		node, creation, drop, del,
		edge, connect, disconnect, reconnect,
		operation, section,
		menu, mitem,
		show // for filter + layer
	}
	
	
	/**
	 * Creates a factory for a diagram description
	 * 
	 * @param parent of diagram
	 */
	new(Class<T> type, AbstractGroup parent) {
		super(type, parent)
	}
		

	
	//
	// Reflection short-cut
	// 
	
	/**
	 * Sets the domain class of a description.
	 * <p>
	 * EClass is resolved using businessPackages of AbstractGroup.
	 * </p>
	 * 
	 * @param it description to define
	 * @param type of the description
	 */
	def void setDomainClass(AbstractNodeMapping it, Class<? extends EObject> type) {
		domainClass = context.asEClass(type) as EClass
	}

	/**
	 * Sets the domain class of a description.
	 * <p>
	 * EClass is resolved using businessPackages of AbstractGroup.
	 * </p>
	 * 
	 * @param it description to define
	 * @param type of the description
	 */
	def void setDomainClass(EdgeMapping it, Class<? extends EObject> type) {
		domainClass = context.asEClass(type) as EClass
	}

	/**
	 * Sets the domain class of a description.
	 * <p>
	 * EClass is resolved using businessPackages of AbstractGroup.
	 * </p>
	 * 
	 * @param it description to define
	 * @param type of the description
	 */
	def void setDomainClass(AbstractNodeMapping it, EClass type) {
		domainClass = SiriusDesigns.encode(type)
	}

	/**
	 * Sets the domain class of a description.
	 * <p>
	 * EClass is resolved using businessPackages of AbstractGroup.
	 * </p>
	 * 
	 * @param it description to define
	 * @param type of the description
	 */
	def void setDomainClass(EdgeMapping it, EClass type) {
		domainClass = SiriusDesigns.encode(type)
	}

	/**
	 * Sets the candidates expression using a reference.
	 * <p>
	 * If name is not set, a derived value is provided
	 * </p>
	 * <p>
     * If domain class and/or name is not set, a derived value is provided
     * </p>
	 * 
	 * @param it description to define
	 * @param type of the description
	 */
	def void setSemanticCandidates(DiagramElementMapping it, EReference ref) {
		semanticCandidatesExpression = "feature:" + ref.name
		if (name === null || name.empty) {
			name = ref.name
		}
		if (it instanceof AbstractNodeMapping) {
	        if (domainClass === null || domainClass.empty) {
            	domainClass = SiriusDesigns.encode(ref.EType)
        	}
		} else if (it instanceof EdgeMapping) {
			if (domainClass === null || domainClass.empty) {
				domainClass = SiriusDesigns.encode(ref.EType)
			}
		}
	}

	//
	// Style
	// 
	
	override initDefaultStyle(BasicLabelStyleDescription it) {
		super.initDefaultStyle(it)
		// Reminder: label.size=10, label.color=black, expression= /!\ dynamic
		
		if (it instanceof BorderedStyleDescription) {
			borderSizeComputationExpression = "1" // default
			borderColor = SystemColor.extraRef("color:black")
		}
		
		if (it instanceof FlatContainerStyleDescription) {
			backgroundColor = SystemColor.extraRef("color:white")
		}

		if (it instanceof NodeStyleDescription) {
			sizeComputationExpression = "2"
		}

		if (it instanceof WorkspaceImageDescription
			|| it instanceof CustomStyleDescription
		) { // extends BorderedStyleDescription
			// when using a image in node, 
			// we usually don't want icon on label
			showIcon = false
			(it as BorderedStyleDescription).borderSizeComputationExpression = "0" // hide border
		}

		if (it instanceof BundledImageDescription) {
			color = (extras.get("color:black") as SystemColor)
		}
	}

	
	/**
	 * Creates a conditional style for container node on provided condition.
	 * <p>
	 * Note conditional style are required only when shape is changed. Most of the time,
	 * customization is better solution.
	 * </p>
	 * @param type of style
	 * @param it to add style
	 * @param condition of style application
	 * @param init of created style (after default initialization)
	 */
	def <T extends ContainerStyleDescription> styleIf(ContainerMapping it, 
	    Class<T> type, String condition, (T)=>void init
	) {
        // Init is required as default styling make not sense
        Objects.requireNonNull(init, "Conditional Style cannot have default properties")
		conditionnalStyles += ConditionalContainerStyleDescription.create[
			predicateExpression = condition
			style = type.createStyle(init)
		]
	}
	
	/**
	 * Creates a conditional style for node on provided condition.
	 * <p>
	 * Note conditional style are required only when shape is changed. Most of the time,
	 * customization is better solution.
	 * </p>
	 * @param type of style
	 * @param it to add style
	 * @param condition of style application
	 * @param init of created style (after default initialization)
	 */
	def <T extends NodeStyleDescription> styleIf(NodeMapping it, 
	    Class<T> type, String condition, (T)=>void init
	) {
	    // Init is required as default styling make not sense
        Objects.requireNonNull(init, "Conditional Style cannot have default properties")
		conditionnalStyles += ConditionalNodeStyleDescription.create[
			predicateExpression = condition
			style = type.createStyle(init)
		]
	}
	
	/**
	 * Sets the style of mapping.
	 * <p>
	 * APIs for Node and edge mapping style are different as node mappings have different style types.
	 * </p>
	 * @param it mapping to set
	 * @param init initialization of the style
	 */
	def setStyle(EdgeMapping it, (EdgeStyleDescription)=>void init) {
        style = EdgeStyleDescription.create [
        	initDefaultEdgeStyle
            init?.apply(it)
        ]
	}
	
	protected def initDefaultEdgeStyle(EdgeStyleDescription it) {
        // centerLabelStyleDescription = null <=> no label
        endsCentering = CenteringStyle.BOTH
        routingStyle = EdgeRouting.MANHATTAN_LITERAL // (Rectilinear)
        
        // by default, target is input arrow
        targetArrow = EdgeArrows.NO_DECORATION_LITERAL
        strokeColor = SystemColor.extraRef("color:black")
        sizeComputationExpression = "1"
	}
	
	
	/**
	 * Customizes a Sirius reference with provided value.
	 * <p>
	 * Keep in mind that Sirius can customize more than 1 element but there is no simple API.
	 * </p>
	 * 
	 * @param it to customize
	 * @param condition of customization
	 * @param siriusReference customized reference
	 * @param customValue to apply
	 * @throws IllegalArgumentException when 'reference' is not a valid feature name
	 */
	def <T extends EObject> customizeRef(T it, 
		String condition, String siriusReference, EObject customValue
	) {
		doCustomize(condition, siriusReference, EReference, 
			EReferenceCustomization.create[
				referenceName = siriusReference
				value = customValue
			])
	}

	/**
	 * Customizes a Sirius attribute with provided expression.
	 * <p>
	 * Keep in mind that Sirius can customize more than 1 element but there is no simple API.
	 * </p>
	 * 
	 * @param it to customize
	 * @param condition of customization
	 * @param siriusAttribute customized attribute
	 * @param customValue to apply
	 * @throws IllegalArgumentException when 'siriusAttribute' is not a valid feature name
	 */
	def <T extends EObject> customize(T it, 
		String condition, String siriusAttribute, String customExpression
	) {
		doCustomize(condition, siriusAttribute, EAttribute, 
			EAttributeCustomization.create[
				attributeName = siriusAttribute
				value = customExpression
			])
	}
	
	
	/**
	 * Customizes a Sirius reference with provided value.
	 * <p>
	 * Keep in mind that Sirius can customize more than 1 element but there is no simple API.
	 * </p>
	 * 
	 * @param it to customize
	 * @param condition of customization
	 * @param siriusReference customized reference
	 * @param customValue to apply
	 * @throws IllegalArgumentException when 'reference' is not a valid feature name
	 */
	def <T extends EObject> customize(T it, 
		String condition, EReference siriusReference, EObject customValue
	) {
		customizeRef(condition, siriusReference.name, customValue)
	}

	/**
	 * Customizes a Sirius attribute with provided expression.
	 * <p>
	 * Keep in mind that Sirius can customize more than 1 element but there is no simple API.
	 * </p>
	 * 
	 * @param it to customize
	 * @param condition of customization
	 * @param siriusAttribute customized attribute
	 * @param customValue to apply
	 * @throws IllegalArgumentException when 'siriusAttribute' is not a valid feature name
	 */
	def <T extends EObject> customize(T it, 
		String condition, EAttribute siriusAttribute, String customExpression
	) {
		customize(condition, siriusAttribute.name, customExpression)
	}

	private def <T extends EObject> T doCustomize(T target, String condition, String feature, 
		Class<? extends EStructuralFeature> type, EStructuralFeatureCustomization custo
	) {
		val layer = Objects.requireNonNull(target.eContainer(Layer))
		if (!type.isInstance(target.eClass.getEStructuralFeature(feature))) {
			throw new IllegalArgumentException(
				'''«target?.eClass» has no «type.simpleName» «feature»''')
		}

		VSMElementCustomization.create[
			predicateExpression = condition
			featureCustomizations += custo.andThen[
				appliedOn += target
			]
		].onAssembledWith(layer)[
			if (layer.customization === null) {
				layer.customization = Customization.create
			}
			layer.customization.vsmElementCustomizations += it
		]
		target
	}
	
	def customization(EAttribute feature, String valueExpression, Iterable<? extends EObject> customizeds) {
		EAttributeCustomization.create [
			attributeName = feature.name
			value = valueExpression
			appliedOn += customizeds			
		]
	}

	def customization(EReference feature, EObject newValue, Iterable<? extends EObject> customizeds) {
		EReferenceCustomization.create [
			referenceName = feature.name
			value = newValue
			appliedOn += customizeds
		]
	}

	//
	// Tool section
	// 
	/**
	 * Creates a creation tool for node mapping.
	 * 
	 * @param toolLabel used as id and name
	 * @param task to perform
	 * @param nodeNames of mapping
	 * @return a NodeCreationDescription
	 */
    protected def createNodeCreate(String toolname, 
            ModelOperation task, String... nodeNames) {
        NodeCreationDescription.createAs(Ns.creation, toolname) [
            
            forceRefresh = true // simpler by default
            
            nodeMappings += nodeNames.map[ NodeMapping.ref(it) ]
            
            variable = NodeCreationVariable.create [ name = "container" ]
            viewVariable = ContainerViewVariable.create [ name = "containerView" ]
            
            operation = task
        ]
    }
    
    /**
     * Creates a creation tool for container mapping.
     * 
     * @param toolname used as id and name
     * @param task to perform
     * @param nodeNames of mapping
     * @return a ContainerCreationDescription
     */
   protected def createContainerCreate(String toolname, 
            ModelOperation task, String... nodeNames) {
        ContainerCreationDescription.createAs(Ns.creation, toolname) [
            forceRefresh = true // simpler by default
            
            containerMappings += nodeNames.map[ ContainerMapping.ref(it) ]
            
            variable = NodeCreationVariable.create [ name = "container" ]
            viewVariable = ContainerViewVariable.create [ name = "containerView" ]
            
            operation = task
        ]
    }
    
    /**
     * Creates a DeleteElement tool for mapped element.
     * <p>
     * For container, mapped sub-elements are also delete by default. we may want to avoid it.
     * </p>
     * <p>
     * Aliased by 'Ns.del.id(toolName)', used in mapping.
     * </p>
     * 
     * @param toolname suffix of name
     * @param operation to perform
     * @return a DeleteElementDescription
     */
    def createElementDelete(String toolName, ModelOperation operation) {
    	toolName.createElementDelete(Ns.del, operation)
    }
    
    protected def createElementDelete(String toolName, Enum<?> namespace, ModelOperation operation) {
        Objects.requireNonNull(operation)
        // Alias is required as mapping declare drops
        DeleteElementDescription.createAs(namespace, toolName) [
            forceRefresh = true // simpler by default

            element = ElementDeleteVariable.create[ name = "element" ]
            elementView = ElementDeleteVariable.create[ name = "elementView" ]
            containerView = ContainerViewVariable.create[ name = "containerView" ]

            initialOperation = operation.toTool
        ]
    }
    
    /**
     * Creates a creation tool for edge.
     * 
     * @param toolname to use
     * @param task to perform
     * @param String... nodeNames
     * @return a ContainerCreationDescription
     */
    def createEdgeConnect(String toolname, ModelOperation task, String... edgeNames) {
        Objects.requireNonNull(task)
        EdgeCreationDescription.createAs(Ns.connect, toolname) [
            forceRefresh = true // simpler by default

            edgeMappings += edgeNames.map[ EdgeMapping.ref(it) ]

            sourceVariable = SourceEdgeCreationVariable.create[ name = "source" ]
            sourceViewVariable= SourceEdgeViewCreationVariable.create [ name = "sourceView" ]
            targetVariable = TargetEdgeCreationVariable.create [ name = "target" ]
            targetViewVariable = TargetEdgeViewCreationVariable.create [ name = "targetView" ]

            operation = task
        ]
    }
    
    /**
     * Creates a DeleteElement tool for mapped element.
     * <p>
     * For container, mapped sub-elements are also delete by default. we may want to avoid it.
     * </p>
     * <p>
     * Aliased by 'Ns.disconnect.id(toolName)', used in edge mapping.
     * </p>
     * 
     * @param toolname suffix of name
     * @param operation to perform
     * @return a DeleteElementDescription
     */
    def createEdgeDisconnect(String toolName, ModelOperation operation) {
        toolName.createElementDelete(Ns.disconnect, operation)
    }
    
    /**
     * Creates a reconnection tool for edge.
     * <p>
     * Aliased by 'Ns.reconnect.id(toolName)', used in edge mapping.
     * </p>
     * 
     * @param toolname suffix of name
     * @param operation to perform
     * @return a ReconnectEdgeDescription
     */
    def createEdgeReconnect(String toolName, ModelOperation operation) {
        Objects.requireNonNull(operation)
        // Alias is required as mapping association is made on mapping
        ReconnectEdgeDescription.createAs(Ns.reconnect, toolName) [
            forceRefresh = true // simpler by default
            reconnectionKind = ReconnectionKind.RECONNECT_BOTH_LITERAL
            
            // mappings += // inverse reference: do NOT add mapping here.
            
            element = ElementSelectVariable.create[ name = "element" ]
            edgeView = ElementSelectVariable.create[ name = "edgeView" ]
            
            source = SourceEdgeCreationVariable.create[ name = "source" ]
            sourceView = SourceEdgeViewCreationVariable.create [ name = "sourceView" ]
            target = TargetEdgeCreationVariable.create [ name = "target" ]
            targetView = TargetEdgeViewCreationVariable.create [ name = "targetView" ]
            initialOperation = operation.toTool
        ]
    }

    /**
     * Creates a reconnection tool for edge from source.
     * <p>
     * Aliased by 'Ns.reconnect.id(toolName)', used in edge mapping.
     * </p>
     * 
     * @param toolname suffix of name
     * @param operation to perform
     * @return a ReconnectEdgeDescription
     */
    def createSourceEdgeReconnect(String toolName, ModelOperation operation) {
        toolName.createEdgeReconnect(operation).andThen[
            reconnectionKind = ReconnectionKind.RECONNECT_SOURCE_LITERAL
        ]
    }

    /**
     * Creates a reconnection tool for edge from target.
     * <p>
     * Aliased by 'Ns.reconnect.id(toolName)', used in edge mapping.
     * </p>
     * 
     * @param toolname suffix of name
     * @param operation to perform
     * @return a ReconnectEdgeDescription
     */
    def createTargetEdgeReconnect(String toolName, ModelOperation operation) {
        toolName.createEdgeReconnect(operation).andThen[
            reconnectionKind = ReconnectionKind.RECONNECT_TARGET_LITERAL
        ]
    }
    
    /**
     * Creates a drop tool.
     * <p>
     * Aliased by 'Ns.drop.id(toolName)', used in container mapping.
     * </p>
     * 
     * @param toolname suffix of name
     * @param mode of drag and drop
     * @param operation to perform
     * @return a ReconnectEdgeDescription
     */
    def createContainerDrop(String toolName, DragSource mode, ModelOperation init) {
       // Alias is required as mapping declare drops
       ContainerDropDescription.createAs(Ns.drop, toolName) [
            dragSource = mode
            
            oldContainer = DropContainerVariable.create [ name = "oldSemanticContainer" ]
            newContainer = DropContainerVariable.create [ name = "newSemanticContainer" ]
            element = ElementDropVariable.create [ name = "element" ]
            newViewContainer = ContainerViewVariable.create [ name = "newContainerView" ]
            operation = init
        ]
    }
        
    /**
     * Creates a drop tool from Diagram or Plugin.
     * <p>
     * Aliased by 'Ns.drop.id(toolName)', used in container mapping.
     * </p>
     * 
     * @param toolname suffix of name
     * @param operation to perform
     * @return a ReconnectEdgeDescription
     */
    def createContainerDrop(String toolName, ModelOperation operation) {
        toolName.createContainerDrop(DragSource.BOTH_LITERAL, operation)
    }
            
    /**
     * Creates a drop tool from Diagram.
     * <p>
     * Aliased by 'Ns.drop.id(toolName)', used in container mapping.
     * </p>
     * 
     * @param toolname suffix of name
     * @param operation to perform
     * @return a ReconnectEdgeDescription
     */
    def createDiagramContainerDrop(String toolName, ModelOperation operation) {
        toolName.createContainerDrop(DragSource.DIAGRAM_LITERAL, operation)
    }

    /**
     * Creates a drop tool from Plugin view.
     * <p>
     * Aliased by 'Ns.drop.id(toolName)', used in container mapping.
     * </p>
     * 
     * @param toolname suffix of name
     * @param operation to perform
     * @return a ReconnectEdgeDescription
     */
    def createViewContainerDrop(String toolName, ModelOperation operation) {
        toolName.createContainerDrop(DragSource.PROJECT_EXPLORER_LITERAL, operation)
    }
    
    /**
     * {@inheritDoc}
     * Appropriate for refactoring but dedicated 'createXxx' method should be preferred.
     */
	override setOperation(AbstractToolDescription it, ModelOperation value) {
		switch(it) {
			ContainerDropDescription: initialOperation = InitialContainerDropOperation.create [ firstModelOperations = value ]
			ReconnectEdgeDescription: initialOperation = value.toTool
			NodeCreationDescription: initialOperation = InitialNodeCreationOperation.create [ firstModelOperations = value ]
			ContainerCreationDescription: initialOperation = InitialNodeCreationOperation.create [ firstModelOperations = value ]
			EdgeCreationDescription: initialOperation = InitEdgeCreationOperation.create [ firstModelOperations = value ]
			DeleteElementDescription: initialOperation = value.toTool
			DoubleClickDescription: initialOperation = value.toTool
			DiagramCreationDescription: initialOperation = value.toTool
			default: super.setOperation(it, value)
		}
	}

    
	def elkLayered(DiagramDescription it, LayoutOption... options) {
		layout = CustomLayoutConfiguration.create [
			id = "org.eclipse.elk.layered"
			label = "ELK Layered"
			description = "Layer-based algorithm provided by the Eclipse Layout Kernel."
				+ " Arranges as many edges as possible into one direction by placing nodes into subsequent layers."
				+ " This implementation supports different routing styles (straight, orthogonal, splines);" 
				+ " if orthogonal routing is selected, arbitrary port constraints are respected," 
				+ " thus enabling the layout of block diagrams such as actor-oriented models or circuit schematics."
  				+ " Furthermore, full layout of compound graphs with cross-hierarchy edges is supported" 
				+ " when the respective option is activated on the top level."
			layoutOptions += options
		]
	}

	protected def <T extends LayoutOption> elkOption(Class<T> type, String key, LayoutOptionTarget[] targets) {
		type.create[
			id = "org.eclipse.elk." + key
			it.targets += targets
		]
	}

	def elkBool(String key, boolean value, LayoutOptionTarget... targets) {
		BooleanLayoutOption.elkOption(key, targets) => [
			it.value = value
		]
	}

	def elkDouble(String key, double value, LayoutOptionTarget... targets) {
		DoubleLayoutOption.elkOption(key, targets) => [
			it.value = value
		]
	}

	def elkEnum(String key, String value, LayoutOptionTarget... targets) {
		EnumLayoutOption.elkOption(key, targets) => [
			value = EnumLayoutValue.create [ name = value ]
		]
	}

	def elkEnums(String key, String values, LayoutOptionTarget... targets) {
		EnumSetLayoutOption.elkOption(key, targets) => [
			if (values !== null && !values.empty)
				it.values += values.split(",")
					.map[ value |
						EnumLayoutValue.create [ name = value ]
					]
		]
	}

	def elkInt(String key, int value, LayoutOptionTarget... targets) {
		IntegerLayoutOption.elkOption(key, targets) => [
			it.value = value
		]
	}

	def elkString(String key, String value, LayoutOptionTarget... targets) {
		StringLayoutOption.elkOption(key, targets) => [
			it.value = value
		]
	}
	
	def setMask(DirectEditLabel it, String value) {
		mask = EditMaskVariables.create[ mask = value ]
	}

	def labelEdit(String id, String feature) {
		DirectEditLabel.createAs(Ns.operation, id) [
			inputLabelExpression = feature.asFeature
			mask = "{0}"
			operation = feature.setter('''arg0'''.trimAql)
		]
	}

	def labelEdit(String id, EAttribute feature) {
		id.labelEdit(feature.name)
	}

	def setLabelEdit(DiagramElementMapping it, String localId) {
		labelDirectEdit = DirectEditLabel.localRef(Ns.operation, localId)
	}

}