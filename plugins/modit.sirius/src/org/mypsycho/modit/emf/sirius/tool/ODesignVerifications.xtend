package org.mypsycho.modit.emf.sirius.tool

import java.util.ResourceBundle
import org.eclipse.emf.common.util.BasicDiagnostic
import org.eclipse.emf.common.util.Diagnostic
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.util.Diagnostician
import org.eclipse.emf.ecore.util.ECrossReferenceAdapter
import org.eclipse.emf.ecore.util.EObjectValidator
import org.eclipse.sirius.diagram.description.AdditionalLayer
import org.eclipse.sirius.diagram.description.filter.FilterDescription
import org.eclipse.sirius.diagram.description.tool.DoubleClickDescription
import org.eclipse.sirius.diagram.description.tool.ToolSection
import org.eclipse.sirius.viewpoint.description.Group
import org.eclipse.sirius.viewpoint.description.IdentifiedElement
import org.eclipse.sirius.viewpoint.description.RepresentationDescription
import org.eclipse.sirius.viewpoint.description.RepresentationElementMapping
import org.eclipse.sirius.viewpoint.description.Viewpoint
import org.eclipse.sirius.viewpoint.description.tool.ExternalJavaAction
import org.eclipse.sirius.viewpoint.description.tool.ExternalJavaActionCall
import org.eclipse.sirius.viewpoint.description.tool.AbstractToolDescription
import org.eclipse.sirius.diagram.description.tool.ReconnectEdgeDescription
import org.eclipse.sirius.diagram.description.tool.DeleteElementDescription
import org.eclipse.sirius.diagram.description.tool.ContainerDropDescription

class ODesignVerifications {
	static val IDENT = "  "
	
	static val IMPLICIT_CLASSES = #{
		// common
		ExternalJavaAction, ExternalJavaActionCall, RepresentationElementMapping,
		// diagram
		DoubleClickDescription, ReconnectEdgeDescription, DeleteElementDescription,
		ContainerDropDescription

	}
	
	static val DISPLAYED_CLASSES = #{
		// common
		ToolSection, AbstractToolDescription, RepresentationDescription,
		// diagram
		Viewpoint, AdditionalLayer, FilterDescription
		// no table
	}
	
    static def void printValidation(String modelName, Group content) {
        val diagnostic = modelName.validateModel(content.eResource)
        if (diagnostic.severity === Diagnostic.OK) {
        	println("Diagnostic OK") // Print report         	
        } else {
        	print("Diagnostic ")
        	diagnostic.printDiagnostic("")
        }
    }
    
    
    static def void printDiagnostic(Diagnostic it, String prefix) {
    	val status = switch(severity) {
    		case Diagnostic.ERROR : "Error"
    		case Diagnostic.WARNING : "Warning"
    		case Diagnostic.INFO : "Info"
    		default: Integer.toString(severity)	
		}
		// Only print INFO when no issue.
		val withHint = severity <= Diagnostic.INFO

    	println(prefix + status + ": " 
    		+ message.replaceAll("\\R", // newline
    			"\n" + prefix + IDENT + IDENT)
    	) // Print report 
    	children
	    	.filter[ withHint || severity > Diagnostic.INFO ]
	    	.forEach[
	    		printDiagnostic(prefix + IDENT)
	    	]
    }
    
    static def validateModel(String modelName, Resource res) {
    	val xRefs = new ECrossReferenceAdapter()
    	xRefs.target = res.resourceSet
    	
    	// Inspired from:
    	// org.eclipse.emf.edit.ui.action.ValidateAction
        val diagnostician = new Diagnostician()
        val result = new BasicDiagnostic(EObjectValidator.DIAGNOSTIC_SOURCE, 0,
        	modelName + " diagnostic", 
        	res.contents);
    	val context = diagnostician.createDefaultContext();
        res.contents.forEach[
        	diagnostician.validate(it, result, context);
        	context.remove(EObjectValidator.ROOT_OBJECT);
        ]
        
        xRefs.unsetTarget(res.resourceSet)
		result
    }
    
    
    static def void printI18nReport(Group content, ResourceBundle i18n) {
    	
 		// All elements
	 	(#[ content ].iterator + content.eAllContents)
		 	.filter(IdentifiedElement)
		 	.filter[ !IMPLICIT_CLASSES.exists[ t | t.isInstance(it) ] ]
		 	// regular case: no need to trace
		 	.filter[ !(i18nRequired && i18n.isI18nDefined(it)) ]
	 		.forEach[
		 		println(
'''«name» -> «
IF label !== null && !label.empty
			 »«label»=«i18n.getI18nLabel(it)»«
ELSE
			 »{«eClass.name»} <no label>«
ENDIF
			 							 »«
IF i18nRequired && !i18n.isI18nDefined(it)
			 							  » !!!«
ENDIF
»'''
		 		)
		 	]
    }
    
    static def isI18nRequired(IdentifiedElement value) {
    	DISPLAYED_CLASSES.exists[ isInstance(value) ]
    }
    
    static def isI18nDefined(ResourceBundle i18n, IdentifiedElement it) {
    	label !== null 
    		&& label.startsWith("%") 
    		&& i18n.containsKey(label.substring(1))
    }

	static def getI18nLabel(ResourceBundle i18n, IdentifiedElement it) {
		val key = label.substring(1)
		
		i18n.containsKey(key)
			? i18n.getString(key)
			: "/!\\"
	}
}
