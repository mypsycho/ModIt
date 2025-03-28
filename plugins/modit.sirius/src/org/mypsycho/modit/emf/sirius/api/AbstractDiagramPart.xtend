/*******************************************************************************
 * Copyright (c) 2019-2024 OBEO.
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

import java.util.Objects
import org.eclipse.emf.ecore.EAttribute
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.sirius.diagram.EdgeArrows
import org.eclipse.sirius.diagram.EdgeRouting
import org.eclipse.sirius.diagram.description.AbstractNodeMapping
import org.eclipse.sirius.diagram.description.CenteringStyle
import org.eclipse.sirius.diagram.description.ConditionalContainerStyleDescription
import org.eclipse.sirius.diagram.description.ConditionalEdgeStyleDescription
import org.eclipse.sirius.diagram.description.ConditionalNodeStyleDescription
import org.eclipse.sirius.diagram.description.ContainerMapping
import org.eclipse.sirius.diagram.description.ContainerMappingImport
import org.eclipse.sirius.diagram.description.DiagramElementMapping
import org.eclipse.sirius.diagram.description.EdgeMapping
import org.eclipse.sirius.diagram.description.Layer
import org.eclipse.sirius.diagram.description.NodeMapping
import org.eclipse.sirius.diagram.description.NodeMappingImport
import org.eclipse.sirius.diagram.description.style.BeginLabelStyleDescription
import org.eclipse.sirius.diagram.description.style.BorderedStyleDescription
import org.eclipse.sirius.diagram.description.style.BundledImageDescription
import org.eclipse.sirius.diagram.description.style.CenterLabelStyleDescription
import org.eclipse.sirius.diagram.description.style.ContainerStyleDescription
import org.eclipse.sirius.diagram.description.style.CustomStyleDescription
import org.eclipse.sirius.diagram.description.style.EdgeStyleDescription
import org.eclipse.sirius.diagram.description.style.EndLabelStyleDescription
import org.eclipse.sirius.diagram.description.style.FlatContainerStyleDescription
import org.eclipse.sirius.diagram.description.style.NodeStyleDescription
import org.eclipse.sirius.diagram.description.style.WorkspaceImageDescription
import org.eclipse.sirius.diagram.description.tool.ContainerCreationDescription
import org.eclipse.sirius.diagram.description.tool.ContainerDropDescription
import org.eclipse.sirius.diagram.description.tool.CreateView
import org.eclipse.sirius.diagram.description.tool.DeleteElementDescription
import org.eclipse.sirius.diagram.description.tool.DiagramCreationDescription
import org.eclipse.sirius.diagram.description.tool.DirectEditLabel
import org.eclipse.sirius.diagram.description.tool.DoubleClickDescription
import org.eclipse.sirius.diagram.description.tool.EdgeCreationDescription
import org.eclipse.sirius.diagram.description.tool.ElementDoubleClickVariable
import org.eclipse.sirius.diagram.description.tool.NodeCreationDescription
import org.eclipse.sirius.diagram.description.tool.NodeCreationVariable
import org.eclipse.sirius.diagram.description.tool.ReconnectEdgeDescription
import org.eclipse.sirius.diagram.description.tool.ReconnectionKind
import org.eclipse.sirius.diagram.description.tool.SourceEdgeCreationVariable
import org.eclipse.sirius.diagram.description.tool.SourceEdgeViewCreationVariable
import org.eclipse.sirius.diagram.description.tool.TargetEdgeCreationVariable
import org.eclipse.sirius.diagram.description.tool.TargetEdgeViewCreationVariable
import org.eclipse.sirius.viewpoint.description.Customization
import org.eclipse.sirius.viewpoint.description.DecorationDescriptionsSet
import org.eclipse.sirius.viewpoint.description.EAttributeCustomization
import org.eclipse.sirius.viewpoint.description.EReferenceCustomization
import org.eclipse.sirius.viewpoint.description.EStructuralFeatureCustomization
import org.eclipse.sirius.viewpoint.description.IVSMElementCustomization
import org.eclipse.sirius.viewpoint.description.VSMElementCustomization
import org.eclipse.sirius.viewpoint.description.style.BasicLabelStyleDescription
import org.eclipse.sirius.viewpoint.description.style.StyleDescription
import org.eclipse.sirius.viewpoint.description.style.StylePackage
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
import org.eclipse.sirius.viewpoint.description.validation.RuleAudit
import org.eclipse.sirius.viewpoint.description.validation.ViewValidationRule

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
		importnode, importedge,
		operation, section,
		menu, mitem,
		show // for filter + layer
	}
	
	public static val STYLE = StylePackage.eINSTANCE
	public static val DSTYLE = org.eclipse.sirius.diagram.description.style
			.StylePackage.eINSTANCE
	
	/**
	 * Creates a factory for a diagram description
	 * 
	 * @param type of edition
	 * @param parent context of representation
	 */
	new(Class<T> type, SiriusVpGroup parent) {
		super(type, parent)
	}
		
	/**
	 * Creates a factory for a diagram description
	 * 
	 * @param type of edition
	 * @param parent context of representation
	 * @param descrLabel displayed on representation groups
	 */
	new(Class<T> type, SiriusVpGroup parent, String descrLabel) {
		super(type, parent, descrLabel)
	}

	
	//
	// Reflection shortcuts
	// 
	
	/**
	 * Sets the domain class of a mapping.
	 * <p>
	 * EClass is resolved using businessPackages of AbstractGroup.
	 * </p>
	 * 
	 * @param it description to define
	 * @param type of the description
	 */
	def void setDomainClass(AbstractNodeMapping it, Class<? extends EObject> type) {
		domainClass = type.asEClass
	}

	/**
	 * Sets the domain class of a mapping.
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
	 * Sets the domain class of a mapping.
	 * <p>
	 * EClass is resolved using businessPackages of AbstractGroup.
	 * </p>
	 * 
	 * @param it description to define
	 * @param type of the description
	 */
	def void setDomainClass(EdgeMapping it, Class<? extends EObject> type) {
		domainClass = type.asEClass
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
		useDomainElement = true
	}

	/**
	 * Sets the candidates expression using a reference.
	 * <p>
	 * If name is not set, a derived value is provided.
	 * </p>
	 * <p>
     * If domain class and/or name is not set, a derived value is provided.
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
	        if (domainClass === null || domainClass.blank) {
            	domainClass = ref.EType as EClass
        	}
		} else if (it instanceof EdgeMapping) {
			if (domainClass === null || domainClass.blank) {
				domainClass = ref.EType as EClass
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
			borderColor = DColor.black.regular
		}
		
		if (it instanceof FlatContainerStyleDescription) {
			backgroundColor = DColor.white.regular
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
			// hide border
			(it as BorderedStyleDescription).borderSizeComputationExpression = "0"
		}

		if (it instanceof BundledImageDescription) {
			color = DColor.black.regular
		}
	}

	/**
	 * Sets the style of mapping.
	 * <p>
	 * APIs for Node and edge mapping style are different as node mappings have
	 * different style types.
	 * </p>
	 * @param it mapping to set
	 * @param init initialization of the style
	 */
	def <T extends ContainerStyleDescription> style(
		ContainerMapping it, Class<T> type, (T)=>void init			
	) {
        style = type.createStyle(init)
	}
	
	/**
	 * Sets the style of mapping.
	 * <p>
	 * APIs for Node and edge mapping style are different as node mappings have
	 * different style types.
	 * </p>
	 * @param it mapping to set
	 * @param init initialization of the style
	 */
	def <T extends NodeStyleDescription> style(
		NodeMapping it, Class<T> type, (T)=>void init
	) {
        style = type.createStyle(init)
	}
	
	/**
	 * Creates a conditional style for a container on provided condition.
	 * <p>
	 * Note conditional style are required only when shape is changed. Most of the time,
	 * customization is better solution.
	 * </p>
	 * @param type of style
	 * @param owner to add style
	 * @param condition of style application
	 * @param init of created style (after default initialization)
	 */
	def <T extends ContainerStyleDescription> styleIf(
			ContainerMapping owner, Class<T> type, 
			String condition, (T)=>void init
	) {
        // Init is required as default styling make not sense
        Objects.requireNonNull(init, "Conditional Style cannot have default properties")
        type.createStyle(init) => [ targetStyle |
			owner.conditionnalStyles += ConditionalContainerStyleDescription.create [
				predicateExpression = condition
				style = targetStyle
			]
        ]

	}
	
	/**
	 * Creates a conditional style for a node on provided condition.
	 * <p>
	 * Note conditional style are required only when shape is changed. Most of the time,
	 * customization is better solution.
	 * </p>
	 * @param type of style
	 * @param owner to add style
	 * @param condition of style application
	 * @param init of created style (after default initialization)
	 */
	def <T extends NodeStyleDescription> styleIf(
		NodeMapping owner, Class<T> type, String condition, (T)=>void init
	) {
	    // Init is required as default styling make not sense
        Objects.requireNonNull(init, "Conditional Style cannot have default properties")
        type.createStyle(init) => [ targetStyle |
			owner.conditionnalStyles += ConditionalNodeStyleDescription.create[
				predicateExpression = condition
				style = targetStyle
			]
        ]
	}
	
		
	/**
	 * Creates a conditional style for an edge on provided condition.
	 * <p>
	 * Note conditional style are required only when several pe. Most of the time,
	 * customization is better solution.
	 * </p>
	 * @param it to add style
	 * @param condition of style application
	 * @param init of created style (after default initialization)
	 */
	def styleIf(EdgeMapping owner,  String condition, (EdgeStyleDescription)=>void init) {
	    // Init is required as default styling make not sense
        Objects.requireNonNull(init, "Conditional Style cannot have default properties")
        EdgeStyleDescription.create [
        	initDefaultStyle
            init?.apply(it)
        ] => [ targetStyle |
			owner.conditionnalStyles += ConditionalEdgeStyleDescription.create [
				predicateExpression = condition
				style = targetStyle
			]
        ]
	}
	
	/**
	 * Sets the style of mapping.
	 * <p>
	 * APIs for Node and edge mapping style are different as node mappings have
	 * different style types.
	 * </p>
	 * @param it mapping to set
	 * @param init initialization of the style
	 */
	def style(EdgeMapping it, (EdgeStyleDescription)=>void init) {
        style = init
	}
	
	/**
	 * Sets the style of mapping.
	 * <p>
	 * APIs for Node and edge mapping style are different as node mappings have
	 * different style types.
	 * </p>
	 * @param it mapping to set
	 * @param init initialization of the style
	 */
	def setStyle(EdgeMapping it, (EdgeStyleDescription)=>void init) {
        style = EdgeStyleDescription.create [
        	initDefaultStyle
            init?.apply(it)
        ]
	}
	
	/** Initializes default values of edge style. */
	def initDefaultStyle(EdgeStyleDescription it) {
        // centerLabelStyleDescription = null <=> no label
        endsCentering = CenteringStyle.BOTH
        routingStyle = EdgeRouting.MANHATTAN_LITERAL // (Rectilinear)
        
        // by default, target is input arrow
        targetArrow = EdgeArrows.NO_DECORATION_LITERAL
        strokeColor = DColor.black.regular
        sizeComputationExpression = "1"
	}
	
	def initEdgeLabel(BasicLabelStyleDescription it) {
		super.initDefaultStyle(it)
		showIcon = false
		labelExpression = null
	}
	
	/** Set the center label of Edge. */
	def setCenterLabel(EdgeStyleDescription it, (CenterLabelStyleDescription)=>void init) {
		centerLabelStyleDescription = init !== null 
			? CenterLabelStyleDescription.create[
				initEdgeLabel
				init.apply(it)
			]
	}
	
	/** Set the begin label of Edge. */
	def setSourceLabel(EdgeStyleDescription it, (BeginLabelStyleDescription)=>void init) {
		beginLabelStyleDescription = init !== null 
			? BeginLabelStyleDescription.create[
				initEdgeLabel
				init.apply(it)
			]
	}
	
	/** Set the end label of Edge. */
	def setTargetLabel(EdgeStyleDescription it, (EndLabelStyleDescription)=>void init) {
		endLabelStyleDescription = init !== null 
			? EndLabelStyleDescription.create[
				initEdgeLabel
				init.apply(it)
			]
	}
	
	/**
	 * Customizes a Sirius layer.
	 * <p>
	 * Layer only support 1 customization. If it exists, content is aggregated.
	 * </p>
	 * Deprecated: use getStyleCustomisations()
	 * @param it to customize
	 * @param customs to apply
	 */
	@Deprecated
	def customizeStyles(Layer it, VSMElementCustomization... customs) {
		if (customization === null) {
			customization = Customization.create
		}
		customization.andThen[
			vsmElementCustomizations += customs
		]
	}
	
	/**
	 * Gets the elements customization of a layer.
	 * <p>
	 * Warning: Adding to this list only works when using full Reference.
	 * NO NAVIGATION in built-in
	 * </p>
	 * Using 'styleCustomisation' is safer.
	 */
	def getStyleCustomisations(Layer it) {
		if (customization === null) {
			customization = Customization.create
		}
		customization.vsmElementCustomizations
	}
	
	/** Gets decorations of a layer. */
	def getDecorations(Layer it) {
		if (decorationDescriptionsSet === null) {
			decorationDescriptionsSet = DecorationDescriptionsSet.create
		}
		decorationDescriptionsSet.decorationDescriptions
	}
	
	/**
	 * Add customization on assembly.
	 * <p>
	 * <ul>
	 * <li>Are available: self, diagram, view.</li>
	 * <li>When contained: container, containerView.</li>
	 * <li>When contained: sourceView, targetView.</li>
	 * </ul>
	 * </p>
	 */
	def styleCustomisation(Layer layer, ()=>IVSMElementCustomization provider) {
		layer.onAssembled[
			layer.styleCustomisations += provider.apply
		]
	}
	
		
	/**
	 * Creates a VSMElementCustomization.
	 * 
	 * @param predicate condition of customization
	 * @param siriusReference customized reference
	 * @param customValue to apply
	 * @throws IllegalArgumentException when 'reference' is not a valid feature name
	 */
	def thenStyle(String predicate, EStructuralFeatureCustomization... customs) {
		VSMElementCustomization.create[
			predicateExpression = predicate
			featureCustomizations += customs
		]
	}
				
	/** Creates a customization of an attribute. */	
	def styleAtt(String feat, String expression) {
		EAttributeCustomization.create => [
			attributeName = feat
			value = expression
		]
	}
	
	/** Creates a customization of a reference. */	
	def styleRef(String feat, EObject customValue) {
		EReferenceCustomization.create => [
			referenceName = feat
			value = customValue
		]
	}
	
	/** Creates a customization of an attribute. */	
	def style(EAttribute feat, String customExpression) {
		feat.name.styleAtt(customExpression)
	}
	
	/** Creates a customization of an attribute. */	
	def style(EReference feat, EObject customValue) {
		feat.name.styleRef(customValue)
	}
	
	// BasicLabelStyleDescription and EdgeStyleDescription covers all styles
	
	/** Customizes a style reference with provided value. */
	def customizeRef(
		BasicLabelStyleDescription it, String condition, 
		String styleReference, EObject value
	) {
		customizeFeatures(condition, styleReference.styleRef(value))
	}

	/** Customizes a style attribute with provided expression. */
	def void customize(
		BasicLabelStyleDescription it, String condition, 
		String styleAttribute, String expression
	) {
		customizeFeatures(condition, styleAttribute.styleAtt(expression))
	}
	
	/** Customizes a style reference with provided value. */
	def customize(
		BasicLabelStyleDescription it, String condition, 
		EReference styleReference, EObject value
	) {
		customizeRef(condition, styleReference.name, value)
	}

	/** Customizes a style attribute with provided expression. */
	def customize(
		BasicLabelStyleDescription it, String condition, 
		EAttribute styleAttribute, String expression
	) {
		customize(condition, styleAttribute.name, expression)
	}

	/** Customizes style properties. */
	def void customizeFeatures(
		BasicLabelStyleDescription it, String condition,
		EStructuralFeatureCustomization... featCustoms
	) {
		doCustoms(condition, featCustoms)
	}

	/** Customizes a style reference with provided value. */
	def customizeRef(
		EdgeStyleDescription it, String condition, 
		String styleReference, EObject value
	) {
		customizeFeatures(condition, styleReference.styleRef(value))
	}

	/** Customizes a style attribute with provided expression. */
	def void customize(
		EdgeStyleDescription it, String condition, String styleAttribute, String expression
	) {
		customizeFeatures(condition, styleAttribute.styleAtt(expression))
	}
	
	/** Customizes a style reference with provided value. */
	def customize(
		EdgeStyleDescription it, String condition, EReference styleReference, EObject value
	) {
		customizeRef(condition, styleReference.name, value)
	}

	/** Customizes a style attribute with provided expression. */
	def customize(
		EdgeStyleDescription it, String condition, EAttribute styleAttribute, String expression
	) {
		customize(condition, styleAttribute.name, expression)
	}

	/** Customizes style properties. */
	def void customizeFeatures(
		EdgeStyleDescription it, String condition, 
		EStructuralFeatureCustomization... featCustoms
	) {
		doCustoms(condition, featCustoms)
	}

	protected def void verifyCustomisation(
		EStructuralFeatureCustomization it, EObject target
	) {
		val descr = switch(it) {
			EAttributeCustomization: EAttribute -> attributeName
			EReferenceCustomization: EReference -> referenceName
		}
		
		'''«target.eClass.name» has no «descr.key.simpleName» «descr.value»'''
			.verify(descr.key.isInstance(target.eClass.getEStructuralFeature(descr.value)))
	}

	protected def void doCustoms(
		EObject target, String condition, EStructuralFeatureCustomization... featCustoms
	) {
		featCustoms.forEach [ verifyCustomisation(target) ]

		target.eContainer(Layer).styleCustomisations
			+= condition.thenStyle(
				featCustoms.map[ andThen[ appliedOn += target ] ]
			)
	}
	

	// Compatible with Iterable.
	/** Customizes an style attribute using reflection. */
	def customization(EAttribute feature, String valueExpression, EObject... customizeds) {
		feature.name.attCustomization(valueExpression, customizeds)
	}

	/** Customizes an style reference using reflection. */
	def customization(EReference feature, EObject newValue, EObject... customizeds) {
		feature.name.refCustomization(newValue, customizeds)
	}

	/** Customizes an style attribute. */
	def attCustomization(String feature, String valueExpression, EObject... customizeds) {
		EAttributeCustomization.create [
			attributeName = feature
			value = valueExpression
			appliedOn += customizeds
		]
	}

	/** Customizes an style reference. */
	def refCustomization(String feature, EObject newValue, EObject... customizeds) {
		EReferenceCustomization.create [
			referenceName = feature
			value = newValue
			appliedOn += customizeds
		]
	}
	
	/** Iterates on all styles of a mapping. */
	static def allStyles(DiagramElementMapping it) {
		switch(it) {
			EdgeMapping: 
				#[ style ] + conditionnalStyles.map[ style ]
			ContainerMapping: 
				#[ style ] + conditionnalStyles.map[ style ]
			NodeMapping: 
				#[ style ] + conditionnalStyles.map[ style ]
			default: #[] as Iterable<? extends StyleDescription> 
		}.filterNull
	}
	
	/** Iterates on all specific styles of a mapping. */
	static def <T extends EObject> allStyles(DiagramElementMapping it, Class<T> type) {
		allStyles.filter(type)
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
        	initVariables
            forceRefresh = true // simpler by default
            
            nodeMappings += nodeNames.map[ NodeMapping.ref(it) ]
            
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
        	initVariables
            forceRefresh = true // simpler by default
            
            containerMappings += nodeNames.map[ ContainerMapping.ref(it) ]
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
    
    /** Creates a delete description. */
    protected def createElementDelete(
    	String toolName, Enum<?> namespace, ModelOperation task
    ) {
        Objects.requireNonNull(task)
        // Alias is required as mapping declare drops
        DeleteElementDescription.createAs(namespace, toolName) [
        	initVariables
            forceRefresh = true // simpler by default
            operation = task
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
			initVariables
            forceRefresh = true // simpler by default

            edgeMappings += edgeNames.map[ EdgeMapping.ref(it) ]
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
    def createEdgeReconnect(String toolName, ReconnectionKind kind, ModelOperation task) {
        Objects.requireNonNull(task)
        // Alias is required as mapping association is made on mapping
        ReconnectEdgeDescription.createAs(Ns.reconnect, toolName) [
            initVariables
            forceRefresh = true // simpler by default
            reconnectionKind = kind
            
            operation = task
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
    def createBothEdgesReconnect(String toolName, ModelOperation operation) {
        toolName.createEdgeReconnect(ReconnectionKind.RECONNECT_BOTH_LITERAL, operation)
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
    	toolName.createEdgeReconnect(ReconnectionKind.RECONNECT_SOURCE_LITERAL, operation)
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
    	toolName.createEdgeReconnect(ReconnectionKind.RECONNECT_TARGET_LITERAL, operation)
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
       		initVariables
            dragSource = mode
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
			ContainerDropDescription: 
				initialOperation = InitialContainerDropOperation
					.create [ firstModelOperations = value ]
			NodeCreationDescription: 
				initialOperation = InitialNodeCreationOperation
					.create [ firstModelOperations = value ]
			ContainerCreationDescription:
				initialOperation = InitialNodeCreationOperation
					.create [ firstModelOperations = value ]
			EdgeCreationDescription:
				initialOperation = InitEdgeCreationOperation
					.create [ firstModelOperations = value ]
			ReconnectEdgeDescription: initialOperation = value.toTool
			DeleteElementDescription: initialOperation = value.toTool
			DoubleClickDescription: initialOperation = value.toTool
			DiagramCreationDescription: initialOperation = value.toTool
			default: super.setOperation(it, value)
		}
	}

	def setMask(DirectEditLabel it, String value) {
		mask = EditMaskVariables.create[ mask = value ]
	}

	/** Creates a edition based on a EAttribute. */
	def labelEdit(String id, String attribute) {
		DirectEditLabel.createAs(Ns.operation, id) [
			inputLabelExpression = attribute.asFeature
			mask = "{0}"
			operation = attribute.setter('''arg0'''.trimAql)
		]
	}

	/** Creates a edition based on a EAttribute. */
	def labelEdit(String id, EAttribute feature) {
		id.labelEdit(feature.name)
	}

	/** Sets a label edit based on the local id of 'DirectEditLabel' */
	def setLabelEdit(DiagramElementMapping it, String localId) {
		labelDirectEdit = DirectEditLabel.localRef(Ns.operation, localId)
	}
	

	/**
	 * Sets the synchronization mode of a mapping.
	 * <p>
	 * if 'mode' is null, the mapping will be driven by the "Unsynchronized" flag from diagram.
	 * (user mode)
	 * </p>
	 * 
	 * @param it mapping
	 * @param mode 
	 */
	def setSynch(DiagramElementMapping it, Boolean mode) {
		// See org.eclipse.sirius.diagram.editor.properties.section.description
		//     .diagramelementmapping.DiagramElementMappingSynchronizationPropertySection .
		if (mode === null) {
			createElements = true
			synchronizationLock = false
		} else {
			createElements = mode
			synchronizationLock = mode
		}
	}

	/**
	 * Sets the imported mapping.
	 * <p>
	 * Also copies the content, mainly operations.
	 * </p>
	 * @param it import
	 * @param imported mapping
	 */
	def void setImported(ContainerMappingImport it, ContainerMapping imported) {
		importedMapping = imported
		
		// Sub node must reused explicitly
		reusedNodeMappings += imported.subNodeMappings
		reusedNodeMappings += imported.reusedNodeMappings
		reusedContainerMappings += imported.subContainerMappings
		reusedContainerMappings += imported.reusedContainerMappings
		if (reusedContainerMappings.contains(imported)) {
			reusedContainerMappings += it
		}
		
		childrenPresentation = imported.childrenPresentation
		
		// Drop tools are inherited		
		// no need to copy style
				
		copyMappingImport(imported)
	}
	
	/**
	 * Sets the imported mapping.
	 * <p>
	 * Also copies the content, mainly operations.
	 * </p>
	 * @param it import
	 * @param imported mapping
	 */
	def void setImported(NodeMappingImport it, NodeMapping imported) {
		importedMapping = imported
		
		// Drop tools are inherited
		
		copyMappingImport(imported)
	}

	/**
	 * Copies the content of abstract node.
	 * 
	 * @param it import
	 * @param imported mapping
	 */
	def copyMappingImport(AbstractNodeMapping it, AbstractNodeMapping imported) {
		domainClass = imported.domainClass
		// inherited ?
		preconditionExpression = imported.preconditionExpression // required ?
		semanticCandidatesExpression = imported.semanticCandidatesExpression
		semanticElements = imported.semanticElements

		reusedBorderedNodeMappings += imported.borderedNodeMappings
		reusedBorderedNodeMappings += imported.reusedBorderedNodeMappings

		deletionDescription = imported.deletionDescription
		labelDirectEdit = imported.labelDirectEdit

		synchronizationLock = imported.synchronizationLock
		createElements = imported.createElements

		doubleClickDescription = imported.doubleClickDescription
		
		// Details and navigations are not inherited
		detailDescriptions += imported.detailDescriptions
		navigationDescriptions += imported.navigationDescriptions
	}

	override initVariables(AbstractToolDescription it) {
		switch(it) {
			ContainerCreationDescription: {
				variable = NodeCreationVariable.create("container")
				viewVariable = ContainerViewVariable.create("containerView")
			}
			ContainerDropDescription: {
				oldContainer = DropContainerVariable.create("oldSemanticContainer")
				newContainer = DropContainerVariable.create("newSemanticContainer")
				element = ElementDropVariable.create("element")
				newViewContainer = ContainerViewVariable.create("newContainerView")
			}
			DeleteElementDescription: {
				element = ElementDeleteVariable.create("element")
				elementView = ElementDeleteVariable.create("elementView")
				containerView = ContainerViewVariable.create("containerView")
			}
			DoubleClickDescription: {
				element = ElementDoubleClickVariable.create("element")
				elementView = ElementDoubleClickVariable.create("elementView")
			}
			EdgeCreationDescription: {
				sourceVariable = SourceEdgeCreationVariable.create("source")
				targetVariable = TargetEdgeCreationVariable.create("target")
				sourceViewVariable = SourceEdgeViewCreationVariable.create("sourceView")
				targetViewVariable = TargetEdgeViewCreationVariable.create("targetView")
			}
			NodeCreationDescription: {
				variable = NodeCreationVariable.create("container")
				viewVariable = ContainerViewVariable.create("containerView")
			}
			ReconnectEdgeDescription: {
				source = SourceEdgeCreationVariable.create("source")
				target = TargetEdgeCreationVariable.create("target")
				sourceView = SourceEdgeViewCreationVariable.create("sourceView")
				targetView = TargetEdgeViewCreationVariable.create("targetView")
				element = ElementSelectVariable.create("element")
				edgeView = ElementSelectVariable.create("edgeView")
			}
			default:
				super.initVariables(it)
		}
	}

	/** Creates a CreateView instance for this mapping in a ToolDescription. */
	def viewDo(DiagramElementMapping viewMapping) {
		viewMapping.viewDo('''elementView''')
	}
		
	/** Creates a CreateView instance for this mapping in a ToolDescription. */
	def viewDo(DiagramElementMapping viewMapping, String containerView) {
		CreateView.create [
			containerViewExpression = containerView.trimAql
			mapping = viewMapping
		]
	}
	
	// Validation
	
	def validFor(ViewValidationRule owner, String expression) {
		RuleAudit.create [
			auditExpression = expression
		] => [
			owner.audits += it
		]
	}
	
}
