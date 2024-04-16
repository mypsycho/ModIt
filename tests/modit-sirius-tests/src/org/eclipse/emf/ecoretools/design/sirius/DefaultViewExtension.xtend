// Testing
package org.eclipse.emf.ecoretools.design.sirius

import org.eclipse.sirius.properties.ButtonDescription
import org.eclipse.sirius.properties.Category
import org.eclipse.sirius.properties.CheckboxDescription
import org.eclipse.sirius.properties.ContainerDescription
import org.eclipse.sirius.properties.GroupDescription
import org.eclipse.sirius.properties.GroupValidationSetDescription
import org.eclipse.sirius.properties.HyperlinkDescription
import org.eclipse.sirius.properties.LabelDescription
import org.eclipse.sirius.properties.ListDescription
import org.eclipse.sirius.properties.PageDescription
import org.eclipse.sirius.properties.PageValidationSetDescription
import org.eclipse.sirius.properties.RadioDescription
import org.eclipse.sirius.properties.TextAreaDescription
import org.eclipse.sirius.properties.TextDescription
import org.eclipse.sirius.properties.TitleBarStyle
import org.eclipse.sirius.properties.ToggleStyle
import org.eclipse.sirius.properties.ext.widgets.reference.propertiesextwidgetsreference.ExtReferenceDescription
import org.eclipse.sirius.viewpoint.FontFormat
import org.eclipse.sirius.viewpoint.description.tool.RemoveElement
import org.eclipse.sirius.viewpoint.description.validation.ERROR_LEVEL
import org.eclipse.sirius.viewpoint.description.validation.RuleAudit
import org.eclipse.sirius.viewpoint.description.validation.SemanticValidationRule
import org.mypsycho.modit.emf.sirius.api.AbstractPropertySet

import static extension org.mypsycho.modit.emf.sirius.api.SiriusDesigns.*

/**
 * Property editor 'Default'.
 * 
 * @generated
 */
class DefaultViewExtension extends AbstractPropertySet {

	new(EcoretoolsDesign parent) {
		super(parent)
	}

	override initDefaultCategory(Category it) {
		pages += PageDescription.createAs(Ns.page, "ecore_page") [
			labelExpression = "Ecore"
			semanticCandidateExpression = "var:self"
			groups += GroupDescription.localRef(Ns.group, "default rules")
			groups += GroupDescription.localRef(Ns.group, "egeneric supertypes-TBD")
			validationSet = PageValidationSetDescription.create [
				semanticValidationRules += SemanticValidationRule.create("NoNameOrInvalid") [
					level = ERROR_LEVEL.ERROR_LITERAL
					message = ''' ' The '  + self.eClass().name +  ' should have a name which is a valid Java identifier.' '''.trimAql
					targetClass = "ecore::ENamedElement"
					audits += RuleAudit.create [
						auditExpression = '''(not self.oclIsKindOf(ecore::ENamedElement) ) or (self.name <> null and self.name.size() > 0)'''.trimAql
					]
				]
			]
		]
		pages += PageDescription.createAs(Ns.page, "parameters_page") [
			labelExpression = "Parameters"
			domainClass = "ecore::EOperation"
			semanticCandidateExpression = "var:self"
			indented = true
			groups += GroupDescription.localRef(Ns.group, "eoperation parameters dynamic mapping")
			validationSet = PageValidationSetDescription.create [
				semanticValidationRules += SemanticValidationRule.create("NoNameOrInvalid") [
					level = ERROR_LEVEL.ERROR_LITERAL
					message = ''' ' The '  + self.eClass().name +  ' should have a name which is a valid Java identifier.' '''.trimAql
					targetClass = "ecore::ENamedElement"
					audits += RuleAudit.create [
						auditExpression = '''(not self.oclIsKindOf(ecore::ENamedElement) ) or self.name <> null and self.name.size() > 0'''.trimAql
					]
				]
			]
		]
		pages += PageDescription.createAs(Ns.page, "documentation_page") [
			labelExpression = "Documentation"
			semanticCandidateExpression = "var:self"
			indented = true
			groups += GroupDescription.localRef(Ns.group, "documentation")
		]
		pages += PageDescription.createAs(Ns.page, "annotation_page") [
			labelExpression = "Annotation"
			semanticCandidateExpression = "var:self"
			indented = true
			groups += GroupDescription.localRef(Ns.group, "eannotation dynamic")
			action("Add EAnnotation", "/org.eclipse.emf.ecore.edit/icons/full/ctool16/CreateEModelElement_eAnnotations_EAnnotation.gif",
				"var:self".toContext(
					"eAnnotations".creator("ecore::EAnnotation")
				)
			)
		]
		pages += PageDescription.createAs(Ns.page, "generation_page") [
			labelExpression = "Generation"
			semanticCandidateExpression = '''self'''.trimAql
			preconditionExpression = '''self.eInverse()->select( g | g.eClass().ePackage.nsURI->includes('http://www.eclipse.org/emf/2002/GenModel'))->asSet()->size() > 0'''.trimAql
			groups += GroupDescription.localRef(Ns.group, "genmodel_directories")
			groups += GroupDescription.localRef(Ns.group, "genmodel opposite instance")
			groups += GroupDescription.localRef(Ns.group, "generation_navigation")
			groups += GroupDescription.localRef(Ns.group, "genmodel root")
			action("Generate Model", "/org.eclipse.emf.ecoretools.design/icons/full/etools16/generate_single.gif",
				"var:self".toContext(
					"org.eclipse.emf.ecoretools.design.action.generateAllID".javaDo("Generate Model Properties", 
						"genmodels" -> '''self.eInverse()->select( g | g.eClass().ePackage.nsURI->includes('http://www.eclipse.org/emf/2002/GenModel'))->asSet().eContainerOrSelf(genmodel::GenModel)->asSet()'''.trimAql,
						"scope" -> "model"
					)
				)
			)
			action("Generate Edit", "/org.eclipse.emf.ecoretools.design/icons/full/etools16/generate_single.gif",
				"var:self".toContext(
					"org.eclipse.emf.ecoretools.design.action.generateAllID".javaDo("Generate Edit Properties", 
						"genmodels" -> '''self.eInverse()->select( g | g.eClass().ePackage.nsURI->includes('http://www.eclipse.org/emf/2002/GenModel'))->asSet().eContainerOrSelf(genmodel::GenModel)->asSet()'''.trimAql,
						"scope" -> "edit"
					)
				)
			)
			action("Generate Editor", "/org.eclipse.emf.ecoretools.design/icons/full/etools16/generate_single.gif",
				"var:self".toContext(
					"org.eclipse.emf.ecoretools.design.action.generateAllID".javaDo("Generate Editor Properties", 
						"genmodels" -> '''self.eInverse()->select( g | g.eClass().ePackage.nsURI->includes('http://www.eclipse.org/emf/2002/GenModel'))->asSet().eContainerOrSelf(genmodel::GenModel)->asSet()'''.trimAql,
						"scope" -> "editor"
					)
				)
			)
			action("Generate All", "/org.eclipse.emf.ecoretools.design/icons/full/etools16/generate.gif",
				"var:self".toContext(
					"org.eclipse.emf.ecoretools.design.action.generateAllID".javaDo("Generate All Properties", 
						"genmodels" -> '''self.eInverse()->select( g | g.eClass().ePackage.nsURI->includes('http://www.eclipse.org/emf/2002/GenModel'))->asSet().eContainerOrSelf(genmodel::GenModel)->asSet()'''.trimAql,
						"scope" -> "model, edit, editor, tests"
					)
				)
			)
		]
		pages += PageDescription.createAs(Ns.page, "execution_page") [
			labelExpression = "Execution"
			semanticCandidateExpression = "var:self"
			preconditionExpression = '''self.eContainerOrSelf(ecore::EPackage).isConfiguredForALE()'''.trimAql
			groups += GroupDescription.localRef(Ns.group, "execution_body")
			groups += GroupDescription.localRef(Ns.group, "execution_imports")
		]
		groups += GroupDescription.createAs(Ns.group, "default rules") [
			labelExpression = '''input.emfEditServices(self).getText()'''.trimAql
			semanticCandidateExpression = '''self.removeSemanticElementsToHide(input.getAllSemanticElements(),input.context().semanticDecorator())'''.trimAql
			preconditionExpression = ""
			style = [
				barStyle = TitleBarStyle.NO_TITLE
				toggleStyle = ToggleStyle.NONE
				expandedByDefault = true
			]
			styleIf('''self.removeSemanticElementsToHide(input.getAllSemanticElements(),input.context().semanticDecorator())->size() > 1'''.trimAql) [
				toggleStyle = ToggleStyle.NONE
				expandedByDefault = true
			]
			forAll("eStructuralFeature", '''self.removeFeaturesToHide(input.emfEditServices(self).getEStructuralFeatures())'''.trimAql) [
				name = "sirius_default_rules_structural_features_for"
				forceRefresh = false
				forIf('''input.emfEditServices(self).needsTextWidget(eStructuralFeature) and not input.emfEditServices(self).isMultiline(eStructuralFeature)'''.trimAql, TextDescription, "sirius_default_rules_mono_string") [
					labelExpression = ''' input.emfEditServices(self).getText(eStructuralFeature)+':' '''.trimAql
					helpExpression = '''input.emfEditServices(self).getDescription(eStructuralFeature)'''.trimAql
					isEnabledExpression = '''eStructuralFeature.changeable'''.trimAql
					valueExpression = '''if eStructuralFeature.name = 'upperBound' and self.oclIsKindOf(ecore::ETypedElement) then self.upperBoundDisplay() else self.eGet(eStructuralFeature.name) endif'''.trimAql
					operation = "var:self".toContext(
						switchDo(
							'''eStructuralFeature.name = 'upperBound' and self.oclIsKindOf(ecore::ETypedElement)'''.trimAql
								-> '''self.setUpperBound(newValue)'''.trimAql.toOperation)
						.setByDefault('''input.emfEditServices(self).setValue(eStructuralFeature, newValue)'''.trimAql.toOperation)
					)
					styleIf('''eStructuralFeature.lowerBound==1'''.trimAql) [
						labelFontFormat += FontFormat.BOLD_LITERAL
					]
				]
				forIf('''input.emfEditServices(self).needsTextWidget(eStructuralFeature) and input.emfEditServices(self).isMultiline(eStructuralFeature)'''.trimAql, TextAreaDescription, "sirius_default_rules_multi_string") [
					labelExpression = ''' input.emfEditServices(self).getText(eStructuralFeature)+':' '''.trimAql
					helpExpression = '''input.emfEditServices(self).getDescription(eStructuralFeature)'''.trimAql
					isEnabledExpression = '''eStructuralFeature.changeable'''.trimAql
					valueExpression = '''self.eGet(eStructuralFeature.name)'''.trimAql
					operation = '''input.emfEditServices(self).setValue(eStructuralFeature, newValue)'''.trimAql.toOperation
					styleIf('''eStructuralFeature.lowerBound==1'''.trimAql) [
						labelFontFormat += FontFormat.BOLD_LITERAL
					]
				]
				forIf('''input.emfEditServices(self).needsCheckboxWidget(eStructuralFeature)'''.trimAql, CheckboxDescription, "sirius_default_rules_mono_boolean") [
					labelExpression = '''input.emfEditServices(self).getText(eStructuralFeature)'''.trimAql
					helpExpression = '''input.emfEditServices(self).getDescription(eStructuralFeature)'''.trimAql
					isEnabledExpression = '''eStructuralFeature.changeable'''.trimAql
					valueExpression = '''self.eGet(eStructuralFeature.name)'''.trimAql
					operation = '''input.emfEditServices(self).setValue(eStructuralFeature, newValue)'''.trimAql.toOperation
					styleIf('''eStructuralFeature.lowerBound==1'''.trimAql) [
						labelFontFormat += FontFormat.BOLD_LITERAL
					]
				]
				forIf('''eStructuralFeature.eType.oclIsKindOf(ecore::EEnum) and not(eStructuralFeature.many)'''.trimAql, RadioDescription, "sirius_default_rules_enum") [
					labelExpression = ''' input.emfEditServices(self).getText(eStructuralFeature)+':' '''.trimAql
					helpExpression = '''input.emfEditServices(self).getDescription(eStructuralFeature)'''.trimAql
					isEnabledExpression = '''eStructuralFeature.changeable'''.trimAql
					valueExpression = '''eStructuralFeature.eType.oclAsType(ecore::EEnum).getEEnumLiteralByLiteral(self.eGet(eStructuralFeature.name).toString())'''.trimAql
					candidatesExpression = '''eStructuralFeature.eType.oclAsType(ecore::EEnum).eLiterals'''.trimAql
					candidateDisplayExpression = '''candidate.name'''.trimAql
					numberOfColumns = 5
					operation = '''input.emfEditServices(self).setValue(eStructuralFeature, newValue.instance)'''.trimAql.toOperation
					styleIf('''eStructuralFeature.lowerBound==1'''.trimAql) [
						labelFontFormat += FontFormat.BOLD_LITERAL
					]
				]
				forIf('''eStructuralFeature.oclIsKindOf(ecore::EAttribute) and eStructuralFeature.many'''.trimAql, ListDescription, "sirius_default_rules_eattribute_many") [
					labelExpression = ''' input.emfEditServices(self).getText(eStructuralFeature)+':' '''.trimAql
					helpExpression = '''input.emfEditServices(self).getDescription(eStructuralFeature)'''.trimAql
					isEnabledExpression = '''eStructuralFeature.changeable'''.trimAql
					valueExpression = '''self.eGet(eStructuralFeature.name)'''.trimAql
					displayExpression = "var:value"
				]
				forIf('''eStructuralFeature.oclIsKindOf(ecore::EReference) and eStructuralFeature.many = true'''.trimAql, ExtReferenceDescription, "sirius_default_rules_ereference") [
					labelExpression = ''' input.emfEditServices(self).getText(eStructuralFeature)+':' '''.trimAql
					helpExpression = '''input.emfEditServices(self).getDescription(eStructuralFeature)'''.trimAql
					referenceNameExpression = '''eStructuralFeature.name'''.trimAql
				]
				forIf('''eStructuralFeature.oclIsKindOf(ecore::EReference) and eStructuralFeature.many = false'''.trimAql, LabelDescription, "etype label") [
					labelExpression = ''' input.emfEditServices(self).getText(eStructuralFeature)+':' '''.trimAql
					helpExpression = '''input.emfEditServices(self).getDescription(eStructuralFeature)'''.trimAql
					valueExpression = '''self.eGetMonoRef(eStructuralFeature)'''.trimAql
					displayExpression = '''if self.eGetMonoRef(eStructuralFeature) <> null then input.emfEditServices(self.eGetMonoRef(eStructuralFeature)).getText() else '' endif'''.trimAql
					action("...", null,
						"org.eclipse.emf.ecoretools.design.action.openSelectModelElementID".javaDo("open select etype dialog", 
							"message" -> ''' 'Select an ' + eStructuralFeature.eType.name +  ' for the ' + eStructuralFeature.name +  ' reference.' '''.trimAql,
							"title" -> ''' 'Select ' + eStructuralFeature.eType.name '''.trimAql,
							"candidates" -> '''input.emfEditServices(self).getChoiceOfValues(eStructuralFeature)'''.trimAql,
							"feature" -> "var:eStructuralFeature",
							"host" -> "var:self"
						)
					)
					action("∅", null,
						"var:self".toContext(
							'''input.emfEditServices(self).setValue(eStructuralFeature, null)'''.trimAql.toOperation
						)
					)
				]
			]
		]
		groups += GroupDescription.createAs(Ns.group, "genmodel opposite instance") [
			labelExpression = '''self.eClass().name'''.trimAql
			semanticCandidateExpression = '''self.eInverse()->select( g | g.eClass().ePackage.nsURI->includes('http://www.eclipse.org/emf/2002/GenModel'))->asSet()'''.trimAql
			preconditionExpression = ""
			extends = GroupDescription.localRef(Ns.group, "default rules")
			style = [
				expandedByDefault = true
			]
		]
		groups += GroupDescription.createAs(Ns.group, "documentation") [
			labelExpression = "Documentation"
			domainClass = "ecore::EModelElement"
			style = [
				barStyle = TitleBarStyle.NO_TITLE
				toggleStyle = ToggleStyle.NONE
				expandedByDefault = true
			]
			controls += ContainerDescription.create("documentation_container") [
				controls += TextAreaDescription.create("doc_area") [
					lineCount = 16
					valueExpression = '''self.getVisibleDocAnnotations().value'''.trimAql
					operation = '''self.setDocAnnotation(newValue)'''.trimAql.toOperation
				]
			]
		]
		groups += GroupDescription.createAs(Ns.group, "generation_navigation") [
			semanticCandidateExpression = '''self.eInverse()->select( g | g.eClass().ePackage.nsURI->includes('http://www.eclipse.org/emf/2002/GenModel'))->asSet()'''.trimAql
			style = [
				barStyle = TitleBarStyle.NO_TITLE
				toggleStyle = ToggleStyle.NONE
				expandedByDefault = true
			]
			controls += ContainerDescription.create("generation_navigation_container") [
				controls += HyperlinkDescription.create("goto sourcecode") [
					isEnabledExpression = '''self.isJavaFileGenerated()'''.trimAql
					valueExpression = '''self'''.trimAql
					displayExpression = '''if self.isJavaFileGenerated() then 'Open Java Implementation' else '' endif'''.trimAql
					operation = "org.eclipse.emf.ecoretools.design.action.openFileInEditorID".javaDo("open java editor", 
						"path" -> '''self.getJavaImplementationPath()'''.trimAql
					)
				]
			]
		]
		groups += GroupDescription.createAs(Ns.group, "genmodel_directories") [
			labelExpression = "Directories"
			domainClass = "genmodel.GenModel"
			semanticCandidateExpression = '''(OrderedSet{self} + self.eInverse()  + self.eInverse().eContainer()- self.eContents()- OrderedSet{self.eContainer()})->select(e | e.eClass().ePackage.nsURI->includes('http://www.eclipse.org/emf/2002/GenModel'))->asSet()'''.trimAql
			style = [
				barStyle = TitleBarStyle.SHORT_TITLE_BAR
				expandedByDefault = true
			]
			controls += TextDescription.create("modelDirectory") [
				labelExpression = "Model"
				valueExpression = '''self.modelDirectory'''.trimAql
				operation = "modelDirectory".setter("var:newValue")
			]
			controls += TextDescription.create("editDirectory") [
				labelExpression = "Edit"
				valueExpression = "feature:editDirectory"
				operation = "editDirectory".setter("var:newValue")
			]
			controls += TextDescription.create("editorDirectory") [
				labelExpression = "Editor"
				valueExpression = "feature:editorDirectory"
				operation = "editorDirectory".setter("var:newValue")
			]
		]
		groups += GroupDescription.createAs(Ns.group, "egeneric supertypes-TBD") [
			labelExpression = ''' 'EGenericType : ' + input.emfEditServices(self).getText() '''.trimAql
			domainClass = "ecore::EGenericType"
			semanticCandidateExpression = '''input.getSemanticElement()->filter(ecore::EClass).eGenericSuperTypes'''.trimAql
			preconditionExpression = '''false and self.oclIsKindOf(ecore::EClass)'''.trimAql
			controls += LabelDescription.create("etypeparameter label") [
				labelExpression = "EType Parameter:"
				valueExpression = '''self.eTypeArguments->first().eTypeParameter'''.trimAql
				displayExpression = '''self.eTypeArguments->first().eTypeParameter.name'''.trimAql
				action("...", null,
					'''self.eClass().getEStructuralFeature('eTypeParameter')'''.trimAql
						.letDo("eStructuralFeature",
							"org.eclipse.emf.ecoretools.design.action.openSelectModelElementID".javaDo("open select etype dialog", 
								"message" -> ''' 'Select an ' + eStructuralFeature.eType.name +  ' for the ' + eStructuralFeature.name +  ' reference.' '''.trimAql,
								"title" -> ''' 'Select ' + eStructuralFeature.eType.name '''.trimAql,
								"candidates" -> '''input.emfEditServices(self).getChoiceOfValues(eStructuralFeature)'''.trimAql,
								"feature" -> "var:eStructuralFeature",
								"host" -> "var:self"
							)
					)
				)
			]
			controls += LabelDescription.create("EClassifier label") [
				labelExpression = "Classifier:"
				valueExpression = '''self.eTypeArguments->at(2).eClassifier'''.trimAql
				displayExpression = '''self.eTypeArguments->at(2).eClassifier.name'''.trimAql
				action("...", null,
					'''self.eClass().getEStructuralFeature('eClassifier')'''.trimAql
						.letDo("eStructuralFeature",
							"org.eclipse.emf.ecoretools.design.action.openSelectModelElementID".javaDo("open select etype dialog", 
								"message" -> ''' 'Select an ' + eStructuralFeature.eType.name +  ' for the ' + eStructuralFeature.name +  ' reference.' '''.trimAql,
								"title" -> ''' 'Select ' + eStructuralFeature.eType.name '''.trimAql,
								"candidates" -> '''input.emfEditServices(self).getChoiceOfValues(eStructuralFeature)'''.trimAql,
								"feature" -> "var:eStructuralFeature",
								"host" -> "var:self"
							)
					)
				)
			]
		]
		groups += GroupDescription.createAs(Ns.group, "genmodel root") [
			labelExpression = '''self.eClass().name'''.trimAql
			semanticCandidateExpression = '''self->select(e | e.oclIsKindOf(ecore::EPackage)).eInverse()->select( g | g.eClass().ePackage.nsURI->includes('http://www.eclipse.org/emf/2002/GenModel')).eContainer(genmodel::GenModel)->asSet()'''.trimAql
			preconditionExpression = ""
			extends = GroupDescription.localRef(Ns.group, "default rules")
			style = [
				expandedByDefault = true
			]
		]
		groups += GroupDescription.createAs(Ns.group, "execution_body") [
			labelExpression = '''self.getExecutableName()'''.trimAql
			semanticCandidateExpression = '''OrderedSet{self}->filter(ecore::EClassifier).getAllExecutables()'''.trimAql
			style = [
				barStyle = TitleBarStyle.NO_TITLE
				toggleStyle = ToggleStyle.NONE
				expandedByDefault = true
			]
			controls += ContainerDescription.create("container_execution_body") [
				controls += TextAreaDescription.create("executable_body") [
					lineCount = 14
					valueExpression = '''self.getExecutableBody()'''.trimAql
					operation = "var:self".toContext(
						'''self.setExecutableBody(newValue)'''.trimAql.toOperation
					)
				]
			]
			validationSet = GroupValidationSetDescription.create [
				semanticValidationRules += SemanticValidationRule.create("isValidSyntax") [
					level = ERROR_LEVEL.ERROR_LITERAL
					message = "Syntax error in body"
					targetClass = "EObject"
					audits += RuleAudit.create [
						auditExpression = '''self.isValidBody()'''.trimAql
					]
				]
			]
		]
		groups += GroupDescription.createAs(Ns.group, "execution_imports") [
			labelExpression = "Imports"
			domainClass = "ecore::EModelElement"
			semanticCandidateExpression = '''OrderedSet{self}->filter(ecore::EPackage)->select(p | p.getJavaImports()->size() > 0)'''.trimAql
			style = [
				expandedByDefault = true
			]
			controls += ButtonDescription.create("execution_button_addimport") [
				buttonLabelExpression = "Add New Import"
				operation = "var:self".toOperation
			]
			controls += ContainerDescription.create("execution_imports_container") [
				layoutHorizontal
				forAll("jImport", '''self.getJavaImports()'''.trimAql) [
					name = "iterate over imports"
					forceRefresh = false
					always(TextDescription, "java_import") [
						labelExpression = "Qualified Class Name: "
						valueExpression = '''jImport.getQualifiedName()'''.trimAql
						operation = '''jImport.setQualifiedName(newValue)'''.trimAql.toOperation
					]
					always(ButtonDescription, "execution_remove_import") [
						buttonLabelExpression = "Remove Import"
						operation = "var:jImport".toContext(
							RemoveElement.create
						)
					]
				]
			]
		]
		groups += GroupDescription.createAs(Ns.group, "eoperation parameters dynamic mapping") [
			labelExpression = "Parameters"
			domainClass = "ecore::EOperation"
			semanticCandidateExpression = "var:self"
			style = [
				expandedByDefault = true
			]
			controls += ContainerDescription.create("parameters_container") [
				layoutFreeGrid(5)
				forAll("self", '''self.eParameters'''.trimAql) [
					name = "foreach parameter"
					always(TextDescription, "param_name") [
						labelExpression = "Name: "
						valueExpression = '''self.name'''.trimAql
						operation = "var:self".toContext(
							"name".setter("var:newValue")
						)
						style = [
							labelFontSizeExpression = "8"
							labelFontFormat += FontFormat.ITALIC_LITERAL
						]
					]
					always(LabelDescription, "etype label") [
						labelExpression = "EType: "
						valueExpression = '''self.eGet('eType')'''.trimAql
						displayExpression = '''self.eGet('eType').name'''.trimAql
						style = [
							labelFontSizeExpression = "8"
							labelFontFormat += FontFormat.ITALIC_LITERAL
						]
						action("...", null,
							"org.eclipse.emf.ecoretools.design.action.openSelectModelElementID".javaDo("open select etype dialog", 
								"message" -> ''' 'Select an EClass for the eType reference.' '''.trimAql,
								"title" -> ''' 'Select EClass' '''.trimAql,
								"candidates" -> '''input.emfEditServices(self).getChoiceOfValues(self.eClass().getEStructuralFeature('eType'))'''.trimAql,
								"feature" -> '''self.eClass().getEStructuralFeature('eType')'''.trimAql,
								"host" -> "var:self"
							)
						)
						action("∅", null,
							"var:self".toContext(
								"eType".setter('''null'''.trimAql)
							)
						)
					]
					always(ButtonDescription, "up") [
						isEnabledExpression = '''self.precedingSiblings()->filter(ecore::EParameter)->size() > 0'''.trimAql
						imageExpression = "/org.eclipse.emf.ecoretools.design/icons/full/etools16/up.gif"
						operation = "var:self".toContext(
							'''self.moveUpInContainer()'''.trimAql.toOperation
						)
					]
					always(ButtonDescription, "down") [
						isEnabledExpression = '''self.precedingSiblings()->filter(ecore::EParameter)->size() +1 < self.eContainer(ecore::EOperation).eParameters->size()'''.trimAql
						imageExpression = "/org.eclipse.emf.ecoretools.design/icons/full/etools16/down.gif"
						operation = "var:self".toContext(
							'''self.moveDownInContainer()'''.trimAql.toOperation
						)
					]
					always(ButtonDescription, "del") [
						imageExpression = "/org.eclipse.emf.ecoretools.design/icons/full/etools16/unset.gif"
						operation = "var:self".toContext(
							RemoveElement.create
						)
					]
				]
			]
			forAll("d", '''self'''.trimAql) [
				name = "dummy_workaround_bug515586"
				forIf('''false'''.trimAql, TextDescription, "dummy") [
					operation = "var:self".toOperation
				]
			]
			action("Add New Parameter", "/org.eclipse.emf.ecore.edit/icons/full/ctool16/CreateEOperation_eParameters_EParameter.gif",
				"var:self".toContext(
					"eParameters".creator("ecore::EParameter").chain(
						"name".setter(''' 'param' + self.eContainer().eContents()->filter(ecore::EParameter)->size() '''.trimAql)
					)
				)
			)
		]
		groups += GroupDescription.createAs(Ns.group, "eannotation dynamic") [
			labelExpression = ''' 'EAnnotation ' + self.source '''.trimAql
			domainClass = "ecore::EAnnotation"
			semanticCandidateExpression = '''input.getSemanticElement()->filter(ecore::EModelElement).eAnnotations'''.trimAql
			style = [
				toggleStyle = ToggleStyle.TREE_NODE
				expandedByDefault = true
			]
			controls += TextDescription.create("source") [
				labelExpression = "Source:"
				helpExpression = '''input.emfEditServices(self).getDescription(self.eClass().getEStructuralFeature('source'))'''.trimAql
				valueExpression = '''self.source'''.trimAql
				operation = "var:self".toContext(
					"source".setter("var:newValue")
				)
			]
			controls += ExtReferenceDescription.create("references ref") [
				labelExpression = ''' input.emfEditServices(self).getText(self.eClass().getEStructuralFeature('references'))+':' '''.trimAql
				helpExpression = '''input.emfEditServices(self).getDescription(self.eClass().getEStructuralFeature('references'))'''.trimAql
				referenceNameExpression = "references"
				referenceOwnerExpression = '''self'''.trimAql
			]
			controls += ContainerDescription.create("eannota_buttons") [
				controls += ButtonDescription.create("eannotation_add_entry") [
					buttonLabelExpression = "Add Entry"
					operation = "var:self".toContext(
						"details".creator("ecore.EStringToStringMapEntry")
					)
				]
			]
			controls += ContainerDescription.create("eannotation_conainer_entries") [
				layoutFreeGrid(3)
				forAll("self", '''self.details'''.trimAql) [
					name = "iterate over entries"
					always(TextDescription, "detail_key") [
						labelExpression = "Key:"
						valueExpression = '''self.key'''.trimAql
						operation = "var:self".toContext(
							"key".setter("var:newValue")
						)
					]
					always(TextDescription, "detail_value") [
						labelExpression = "Value:"
						valueExpression = '''self.value'''.trimAql
						operation = "var:self".toContext(
							"value".setter("var:newValue")
						)
					]
					always(ButtonDescription, "del") [
						helpExpression = "Delete the entry"
						imageExpression = "/org.eclipse.emf.ecoretools.design/icons/full/etools16/unset.gif"
						operation = "var:self".toContext(
							RemoveElement.create
						)
					]
				]
			]
			forAll("d", '''self'''.trimAql) [
				name = "dummy_workaround_bug515586"
				forIf('''false'''.trimAql, TextDescription, "dummy_text") [
					operation = "var:self".toOperation
				]
			]
			action("Delete EAnnotation", "/org.eclipse.emf.ecoretools.design/icons/full/etools16/unset.gif",
				"var:self".toContext(
					RemoveElement.create
				)
			)
		]
	}
}