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
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.sirius.diagram.description.AbstractNodeMapping
import org.eclipse.sirius.diagram.description.ConditionalContainerStyleDescription
import org.eclipse.sirius.diagram.description.ConditionalNodeStyleDescription
import org.eclipse.sirius.diagram.description.ContainerMapping
import org.eclipse.sirius.diagram.description.DiagramDescription
import org.eclipse.sirius.diagram.description.DiagramElementMapping
import org.eclipse.sirius.diagram.description.EdgeMapping
import org.eclipse.sirius.diagram.description.Layer
import org.eclipse.sirius.diagram.description.NodeMapping
import org.eclipse.sirius.diagram.description.style.BorderedStyleDescription
import org.eclipse.sirius.diagram.description.style.BundledImageDescription
import org.eclipse.sirius.diagram.description.style.ContainerStyleDescription
import org.eclipse.sirius.diagram.description.style.FlatContainerStyleDescription
import org.eclipse.sirius.diagram.description.style.NodeStyleDescription
import org.eclipse.sirius.diagram.description.style.WorkspaceImageDescription
import org.eclipse.sirius.diagram.description.tool.ContainerCreationDescription
import org.eclipse.sirius.diagram.description.tool.ContainerDropDescription
import org.eclipse.sirius.diagram.description.tool.DeleteElementDescription
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
import org.eclipse.sirius.viewpoint.description.tool.ContainerViewVariable
import org.eclipse.sirius.viewpoint.description.tool.DragSource
import org.eclipse.sirius.viewpoint.description.tool.DropContainerVariable
import org.eclipse.sirius.viewpoint.description.tool.ElementDeleteVariable
import org.eclipse.sirius.viewpoint.description.tool.ElementDropVariable
import org.eclipse.sirius.viewpoint.description.tool.ElementSelectVariable
import org.eclipse.sirius.viewpoint.description.tool.InitEdgeCreationOperation
import org.eclipse.sirius.viewpoint.description.tool.InitialContainerDropOperation
import org.eclipse.sirius.viewpoint.description.tool.InitialNodeCreationOperation
import org.eclipse.sirius.viewpoint.description.tool.ModelOperation

import static extension org.mypsycho.modit.emf.sirius.api.SiriusDesigns.*
import org.eclipse.emf.ecore.EClass

/**
 * Adaptation of Sirius model into Java and EClass reflections API
 * for Diagrams.
 * 
 * @author nicolas.peransin
 */
abstract class AbstractDiagram extends AbstractRepresentation<DiagramDescription> {

	/** Namespaces for identification */
	enum Ns { // namespace for identication
		node, creation, drop, del,
		edge, connect, disconnect, reconnect
	}
	
	/**
	 * Creates a factory for a diagram description
	 * 
	 * @param parent of diagram
	 */
	new(AbstractGroup parent, String dLabel, Class<? extends EObject> dClass) {
		super(DiagramDescription, parent, dLabel)
		
		creationTasks.add[
			domainClass = context.asDomainClass(dClass)
		]
	}
		
	/**
	 * Initializes the content of the created diagram.
	 * 
	 * @param it to initialize
	 */
	override initContent(DiagramDescription it) {
		defaultLayer = Layer.create[
			name = "Default"
			initContent
		]
	}
	
	/**
	 * Initializes the content of the created diagram.
	 * 
	 * @param it to initialize
	 */
	def void initContent(Layer it)
	
	override initDefaultStyle(BasicLabelStyleDescription it) {
		super.initDefaultStyle(it)
		
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

		if (it instanceof WorkspaceImageDescription) { // extends BorderedStyleDescription
			// when using a image in node, 
			// we usually don't want icon on label
			showIcon = false
			borderSizeComputationExpression = "0" // hide border
		}

		if (it instanceof BundledImageDescription) {
			color = (extras.get("color:black") as SystemColor)
		}
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
	 * Customizes a Sirius reference with provided value.
	 * <p>
	 * Keep in mind that Sirius can customize more than 1 element but there is no simple API.
	 * </p>
	 * 
	 * @param it to customize
	 * @param condition of customization
	 * @param siriusReference customized reference
	 * @param customValue to apply
	 * @throws IllegalArgumentException when 'reference' is not a valide feature name
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
	 * @throws IllegalArgumentException when 'siriusAttribute' is not a valide feature name
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

	//
	// Tool section
	// 
	/**
	 * Creates a creation tool for node mapping.
	 * 
	 * @param toolLabel used as id and name
	 * @param operation to perform
	 * @param nodeNames of mapping
	 * @return a NodeCreationDescription
	 */
    protected def createNodeCreate(String toolLabel, 
            ModelOperation operation, String... nodeNames) {
        NodeCreationDescription.create [
            name = Ns.creation.id(toolLabel) // this used in API
            label = toolLabel // this is used in 'undo'
            
            forceRefresh = true // simpler by default
            
            nodeMappings += nodeNames.map[ NodeMapping.ref(it) ]
            
            variable = NodeCreationVariable.create [ name = "container" ]
            viewVariable = ContainerViewVariable.create [ name = "containerView" ]
            
            initialOperation = InitialNodeCreationOperation.create [
                firstModelOperations = operation
            ]
        ]
    }
    
    /**
     * Creates a creation tool for container mapping.
     * 
     * @param toolLabel used as id and name
     * @param operation to perform
     * @param nodeNames of mapping
     * @return a ContainerCreationDescription
     */
   protected def createContainerCreate(String toolLabel, 
            ModelOperation operation, String... nodeNames) {
        ContainerCreationDescription.create [
            name = Ns.creation.id(toolLabel) // this used in API
            label = toolLabel // this is used in 'undo'
            
            forceRefresh = true // simpler by default
            
            containerMappings += nodeNames.map[ NodeMapping.ref(it) ]
            
            variable = NodeCreationVariable.create [ name = "container" ]
            viewVariable = ContainerViewVariable.create [ name = "containerView" ]
            
            initialOperation = InitialNodeCreationOperation.create [
                firstModelOperations = operation
            ]
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
        Objects.requireNonNull(operation)
        // Alias is required as mapping declare drops
        DeleteElementDescription.createAs(Ns.del.id(toolName)) [
            name = Ns.del.id(toolName)
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
     * @param toolname suffix of name
     * @param operation to perform
     * @param String... nodeNames
     * @return a ContainerCreationDescription
     */
    def createEdgeConnect(String toolLabel, ModelOperation operation, String... edgeNames) {
        Objects.requireNonNull(operation)
        EdgeCreationDescription.create [
            name = Ns.connect.id(toolLabel) // this is used in 'undo'
            forceRefresh = true // simpler by default

            edgeMappings += edgeNames.map[ EdgeMapping.ref(it) ]

            sourceVariable = SourceEdgeCreationVariable.create[ name = "source" ]
            sourceViewVariable= SourceEdgeViewCreationVariable.create [ name = "sourceView" ]
            targetVariable = TargetEdgeCreationVariable.create [ name = "target" ]
            targetViewVariable = TargetEdgeViewCreationVariable.create [ name = "targetView" ]

            initialOperation = InitEdgeCreationOperation.create[
                firstModelOperations = operation
            ]
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
        toolName.createElementDelete(operation).andThen[
            name = Ns.disconnect.id(toolName)
        ]
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
        ReconnectEdgeDescription.createAs(Ns.reconnect.id(toolName)) [
            name = Ns.reconnect.id(toolName)
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
     * @param 
     * @param operation to perform
     * @return a ReconnectEdgeDescription
     */
    def createContainerDrop(String toolName, DragSource mode, ModelOperation operation) {
       // Alias is required as mapping declare drops
       ContainerDropDescription.createAs(Ns.drop.id(toolName)) [
            name = Ns.drop.id(toolName)
            dragSource = mode
            
            oldContainer = DropContainerVariable.create [ name = "oldSemanticContainer" ]
            newContainer = DropContainerVariable.create [ name = "newSemanticContainer" ]
            element = ElementDropVariable.create [ name = "element" ]
            newViewContainer = ContainerViewVariable.create [ name = "newContainerView" ]
            initialOperation = InitialContainerDropOperation.create [
                firstModelOperations = operation
            ]
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

}
