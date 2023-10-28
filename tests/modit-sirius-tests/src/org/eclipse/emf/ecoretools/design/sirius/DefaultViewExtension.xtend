package org.eclipse.emf.ecoretools.design.sirius

import org.eclipse.emf.codegen.ecore.genmodel.GenModelPackage
import org.eclipse.emf.ecore.EcorePackage
import org.eclipse.sirius.properties.ButtonDescription
import org.eclipse.sirius.properties.Category
import org.eclipse.sirius.properties.CheckboxDescription
import org.eclipse.sirius.properties.CheckboxWidgetConditionalStyle
import org.eclipse.sirius.properties.CheckboxWidgetStyle
import org.eclipse.sirius.properties.ContainerDescription
import org.eclipse.sirius.properties.DynamicMappingForDescription
import org.eclipse.sirius.properties.DynamicMappingIfDescription
import org.eclipse.sirius.properties.FILL_LAYOUT_ORIENTATION
import org.eclipse.sirius.properties.FillLayoutDescription
import org.eclipse.sirius.properties.GridLayoutDescription
import org.eclipse.sirius.properties.GroupConditionalStyle
import org.eclipse.sirius.properties.GroupDescription
import org.eclipse.sirius.properties.GroupStyle
import org.eclipse.sirius.properties.GroupValidationSetDescription
import org.eclipse.sirius.properties.HyperlinkDescription
import org.eclipse.sirius.properties.LabelDescription
import org.eclipse.sirius.properties.LabelWidgetStyle
import org.eclipse.sirius.properties.ListDescription
import org.eclipse.sirius.properties.PageDescription
import org.eclipse.sirius.properties.PageValidationSetDescription
import org.eclipse.sirius.properties.RadioDescription
import org.eclipse.sirius.properties.RadioWidgetConditionalStyle
import org.eclipse.sirius.properties.RadioWidgetStyle
import org.eclipse.sirius.properties.TextAreaDescription
import org.eclipse.sirius.properties.TextDescription
import org.eclipse.sirius.properties.TextWidgetConditionalStyle
import org.eclipse.sirius.properties.TextWidgetStyle
import org.eclipse.sirius.properties.TitleBarStyle
import org.eclipse.sirius.properties.ToggleStyle
import org.eclipse.sirius.properties.ToolbarAction
import org.eclipse.sirius.properties.ViewExtensionDescription
import org.eclipse.sirius.properties.WidgetAction
import org.eclipse.sirius.properties.ext.widgets.reference.propertiesextwidgetsreference.ExtReferenceDescription
import org.eclipse.sirius.viewpoint.FontFormat
import org.eclipse.sirius.viewpoint.description.tool.Case
import org.eclipse.sirius.viewpoint.description.tool.ChangeContext
import org.eclipse.sirius.viewpoint.description.tool.CreateInstance
import org.eclipse.sirius.viewpoint.description.tool.Default
import org.eclipse.sirius.viewpoint.description.tool.ExternalJavaAction
import org.eclipse.sirius.viewpoint.description.tool.ExternalJavaActionParameter
import org.eclipse.sirius.viewpoint.description.tool.InitialOperation
import org.eclipse.sirius.viewpoint.description.tool.Let
import org.eclipse.sirius.viewpoint.description.tool.RemoveElement
import org.eclipse.sirius.viewpoint.description.tool.SetValue
import org.eclipse.sirius.viewpoint.description.tool.Switch
import org.eclipse.sirius.viewpoint.description.validation.ERROR_LEVEL
import org.eclipse.sirius.viewpoint.description.validation.RuleAudit
import org.eclipse.sirius.viewpoint.description.validation.SemanticValidationRule
import org.mypsycho.modit.emf.sirius.api.AbstractPropertySet

import static extension org.mypsycho.modit.emf.sirius.api.SiriusDesigns.*

class DefaultViewExtension extends AbstractPropertySet {

	new(EcoretoolsDesign parent) {
		super(parent)
	}

	override initCategory(Category it) {
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
			actions += ToolbarAction.create [
				tooltipExpression = "Add EAnnotation"
				imageExpression = "/org.eclipse.emf.ecore.edit/icons/full/ctool16/CreateEModelElement_eAnnotations_EAnnotation.gif"
				operation = "var:self".toContext(
					"eAnnotations".creator("ecore::EAnnotation")
				)
			]
		]
		pages += PageDescription.createAs(Ns.page, "generation_page") [
			labelExpression = "Generation"
			semanticCandidateExpression = '''self'''.trimAql
			preconditionExpression = '''self.eInverse()->select( g | g.eClass().ePackage.nsURI->includes('http://www.eclipse.org/emf/2002/GenModel'))->asSet()->size() > 0'''.trimAql
			groups += GroupDescription.localRef(Ns.group, "genmodel_directories")
			groups += GroupDescription.localRef(Ns.group, "genmodel opposite instance")
			groups += GroupDescription.localRef(Ns.group, "generation_navigation")
			groups += GroupDescription.localRef(Ns.group, "genmodel root")
			actions += ToolbarAction.create [
				tooltipExpression = "Generate Model"
				imageExpression = "/org.eclipse.emf.ecoretools.design/icons/full/etools16/generate_single.gif"
				operation = "var:self".toContext(
					"org.eclipse.emf.ecoretools.design.action.generateAllID".javaDo("Generate Model Properties", 
						"genmodels" -> '''self.eInverse()->select( g | g.eClass().ePackage.nsURI->includes('http://www.eclipse.org/emf/2002/GenModel'))->asSet().eContainerOrSelf(genmodel::GenModel)->asSet()'''.trimAql,
						"scope" -> "model"
					)
				)
			]
			actions += ToolbarAction.create [
				tooltipExpression = "Generate Edit"
				imageExpression = "/org.eclipse.emf.ecoretools.design/icons/full/etools16/generate_single.gif"
				operation = "var:self".toContext(
					"org.eclipse.emf.ecoretools.design.action.generateAllID".javaDo("Generate Edit Properties", 
						"genmodels" -> '''self.eInverse()->select( g | g.eClass().ePackage.nsURI->includes('http://www.eclipse.org/emf/2002/GenModel'))->asSet().eContainerOrSelf(genmodel::GenModel)->asSet()'''.trimAql,
						"scope" -> "edit"
					)
				)
			]
			actions += ToolbarAction.create [
				tooltipExpression = "Generate Editor"
				imageExpression = "/org.eclipse.emf.ecoretools.design/icons/full/etools16/generate_single.gif"
				operation = "var:self".toContext(
					"org.eclipse.emf.ecoretools.design.action.generateAllID".javaDo("Generate Editor Properties", 
						"genmodels" -> '''self.eInverse()->select( g | g.eClass().ePackage.nsURI->includes('http://www.eclipse.org/emf/2002/GenModel'))->asSet().eContainerOrSelf(genmodel::GenModel)->asSet()'''.trimAql,
						"scope" -> "editor"
					)
				)
			]
			actions += ToolbarAction.create [
				tooltipExpression = "Generate All"
				imageExpression = "/org.eclipse.emf.ecoretools.design/icons/full/etools16/generate.gif"
				operation = "var:self".toContext(
					"org.eclipse.emf.ecoretools.design.action.generateAllID".javaDo("Generate All Properties", 
						"genmodels" -> '''self.eInverse()->select( g | g.eClass().ePackage.nsURI->includes('http://www.eclipse.org/emf/2002/GenModel'))->asSet().eContainerOrSelf(genmodel::GenModel)->asSet()'''.trimAql,
						"scope" -> "model, edit, editor, tests"
					)
				)
			]
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
			controls += DynamicMappingForDescription.create("sirius_default_rules_structural_features_for") [
				iterator = "eStructuralFeature"
				iterableExpression = '''self.removeFeaturesToHide(input.emfEditServices(self).getEStructuralFeatures())'''.trimAql
				ifs += DynamicMappingIfDescription.create("sirius_default_rules_mono_string_if") [
					predicateExpression = '''input.emfEditServices(self).needsTextWidget(eStructuralFeature) and not input.emfEditServices(self).isMultiline(eStructuralFeature)'''.trimAql
					widget = TextDescription.create("sirius_default_rules_mono_string") [
						labelExpression = ''' input.emfEditServices(self).getText(eStructuralFeature)+':' '''.trimAql
						helpExpression = '''input.emfEditServices(self).getDescription(eStructuralFeature)'''.trimAql
						isEnabledExpression = '''eStructuralFeature.changeable'''.trimAql
						valueExpression = '''if eStructuralFeature.name = 'upperBound' and self.oclIsKindOf(ecore::ETypedElement) then self.upperBoundDisplay() else self.eGet(eStructuralFeature.name) endif'''.trimAql
						operation = "var:self".toContext(
							Switch.create [
								cases += Case.create [
									conditionExpression = '''eStructuralFeature.name = 'upperBound' and self.oclIsKindOf(ecore::ETypedElement)'''.trimAql
									subModelOperations += '''self.setUpperBound(newValue)'''.trimAql.toOperation
								]
								^default = Default.create [
									subModelOperations += '''input.emfEditServices(self).setValue(eStructuralFeature, newValue)'''.trimAql.toOperation
								]
							]
						)
						styleIf('''eStructuralFeature.lowerBound==1'''.trimAql) [
							labelFontFormat += FontFormat.BOLD_LITERAL
						]
					]
				]
				ifs += DynamicMappingIfDescription.create("sirius_default_rules_multi_string_if") [
					predicateExpression = '''input.emfEditServices(self).needsTextWidget(eStructuralFeature) and input.emfEditServices(self).isMultiline(eStructuralFeature)'''.trimAql
					widget = TextAreaDescription.create("sirius_default_rules_multi_string") [
						labelExpression = ''' input.emfEditServices(self).getText(eStructuralFeature)+':' '''.trimAql
						helpExpression = '''input.emfEditServices(self).getDescription(eStructuralFeature)'''.trimAql
						isEnabledExpression = '''eStructuralFeature.changeable'''.trimAql
						valueExpression = '''self.eGet(eStructuralFeature.name)'''.trimAql
						operation = '''input.emfEditServices(self).setValue(eStructuralFeature, newValue)'''.trimAql.toOperation
						styleIf('''eStructuralFeature.lowerBound==1'''.trimAql) [
							labelFontFormat += FontFormat.BOLD_LITERAL
						]
					]
				]
				ifs += DynamicMappingIfDescription.create("sirius_default_rules_mono_boolean") [
					predicateExpression = '''input.emfEditServices(self).needsCheckboxWidget(eStructuralFeature)'''.trimAql
					widget = CheckboxDescription.create("sirius_default_rules_mono_boolean") [
						labelExpression = '''input.emfEditServices(self).getText(eStructuralFeature)'''.trimAql
						helpExpression = '''input.emfEditServices(self).getDescription(eStructuralFeature)'''.trimAql
						isEnabledExpression = '''eStructuralFeature.changeable'''.trimAql
						valueExpression = '''self.eGet(eStructuralFeature.name)'''.trimAql
						operation = '''input.emfEditServices(self).setValue(eStructuralFeature, newValue)'''.trimAql.toOperation
						styleIf('''eStructuralFeature.lowerBound==1'''.trimAql) [
							labelFontFormat += FontFormat.BOLD_LITERAL
						]
					]
				]
				ifs += DynamicMappingIfDescription.create("sirius_default_rules_enum_if") [
					predicateExpression = '''eStructuralFeature.eType.oclIsKindOf(ecore::EEnum) and not(eStructuralFeature.many)'''.trimAql
					widget = RadioDescription.create("sirius_default_rules_enum") [
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
				]
				ifs += DynamicMappingIfDescription.create("sirius_default_rules_eattribute_many_if") [
					predicateExpression = '''eStructuralFeature.oclIsKindOf(ecore::EAttribute) and eStructuralFeature.many'''.trimAql
					widget = ListDescription.create("sirius_default_rules_eattribute_many") [
						labelExpression = ''' input.emfEditServices(self).getText(eStructuralFeature)+':' '''.trimAql
						helpExpression = '''input.emfEditServices(self).getDescription(eStructuralFeature)'''.trimAql
						isEnabledExpression = '''eStructuralFeature.changeable'''.trimAql
						valueExpression = '''self.eGet(eStructuralFeature.name)'''.trimAql
						displayExpression = "var:value"
					]
				]
				ifs += DynamicMappingIfDescription.create("sirius_default_rules_ereference_if") [
					predicateExpression = '''eStructuralFeature.oclIsKindOf(ecore::EReference) and eStructuralFeature.many = true'''.trimAql
					widget = ExtReferenceDescription.create("sirius_default_rules_ereference") [
						labelExpression = ''' input.emfEditServices(self).getText(eStructuralFeature)+':' '''.trimAql
						helpExpression = '''input.emfEditServices(self).getDescription(eStructuralFeature)'''.trimAql
						referenceNameExpression = '''eStructuralFeature.name'''.trimAql
					]
				]
				ifs += DynamicMappingIfDescription.create("ecoretools_etype_ereference") [
					predicateExpression = '''eStructuralFeature.oclIsKindOf(ecore::EReference) and eStructuralFeature.many = false'''.trimAql
					widget = LabelDescription.create("etype label") [
						labelExpression = ''' input.emfEditServices(self).getText(eStructuralFeature)+':' '''.trimAql
						helpExpression = '''input.emfEditServices(self).getDescription(eStructuralFeature)'''.trimAql
						valueExpression = '''self.eGetMonoRef(eStructuralFeature)'''.trimAql
						displayExpression = '''if self.eGetMonoRef(eStructuralFeature) <> null then input.emfEditServices(self.eGetMonoRef(eStructuralFeature)).getText() else '' endif'''.trimAql
						actions += WidgetAction.create [
							labelExpression = "..."
							operation = "org.eclipse.emf.ecoretools.design.action.openSelectModelElementID".javaDo("open select etype dialog", 
								"message" -> ''' 'Select an ' + eStructuralFeature.eType.name +  ' for the ' + eStructuralFeature.name +  ' reference.' '''.trimAql,
								"title" -> ''' 'Select ' + eStructuralFeature.eType.name '''.trimAql,
								"candidates" -> '''input.emfEditServices(self).getChoiceOfValues(eStructuralFeature)'''.trimAql,
								"feature" -> "var:eStructuralFeature",
								"host" -> "var:self"
							)
						]
						actions += WidgetAction.create [
							labelExpression = "∅"
							operation = "var:self".toContext(
								'''input.emfEditServices(self).setValue(eStructuralFeature, null)'''.trimAql.toOperation
							)
						]
					]
				]
			]
			style [
				barStyle = TitleBarStyle.NO_TITLE
				toggleStyle = ToggleStyle.NONE
				expandedByDefault = true
			]
			conditionalStyles += GroupConditionalStyle.create [
				preconditionExpression = '''self.removeSemanticElementsToHide(input.getAllSemanticElements(),input.context().semanticDecorator())->size() > 1'''.trimAql
				style = GroupStyle.create [
					toggleStyle = ToggleStyle.NONE
					expandedByDefault = true
				]
			]
		]
		groups += GroupDescription.createAs(Ns.group, "genmodel opposite instance") [
			labelExpression = '''self.eClass().name'''.trimAql
			semanticCandidateExpression = '''self.eInverse()->select( g | g.eClass().ePackage.nsURI->includes('http://www.eclipse.org/emf/2002/GenModel'))->asSet()'''.trimAql
			preconditionExpression = ""
			extends = GroupDescription.localRef(Ns.group, "default rules")
			style [
				expandedByDefault = true
			]
		]
		groups += GroupDescription.createAs(Ns.group, "documentation") [
			labelExpression = "Documentation"
			domainClass = "ecore::EModelElement"
			controls += ContainerDescription.create("documentation_container") [
				controls += TextAreaDescription.create("doc_area") [
					lineCount = 16
					valueExpression = '''self.getVisibleDocAnnotations().value'''.trimAql
					operation = '''self.setDocAnnotation(newValue)'''.trimAql.toOperation
				]
			]
			style [
				barStyle = TitleBarStyle.NO_TITLE
				toggleStyle = ToggleStyle.NONE
				expandedByDefault = true
			]
		]
		groups += GroupDescription.createAs(Ns.group, "generation_navigation") [
			semanticCandidateExpression = '''self.eInverse()->select( g | g.eClass().ePackage.nsURI->includes('http://www.eclipse.org/emf/2002/GenModel'))->asSet()'''.trimAql
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
			style [
				barStyle = TitleBarStyle.NO_TITLE
				toggleStyle = ToggleStyle.NONE
				expandedByDefault = true
			]
		]
		groups += GroupDescription.createAs(Ns.group, "genmodel_directories") [
			labelExpression = "Directories"
			domainClass = "genmodel.GenModel"
			semanticCandidateExpression = '''(OrderedSet{self} + self.eInverse()  + self.eInverse().eContainer()- self.eContents()- OrderedSet{self.eContainer()})->select(e | e.eClass().ePackage.nsURI->includes('http://www.eclipse.org/emf/2002/GenModel'))->asSet()'''.trimAql
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
			style [
				barStyle = TitleBarStyle.SHORT_TITLE_BAR
				expandedByDefault = true
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
				actions += WidgetAction.create [
					labelExpression = "..."
					operation = '''self.eClass().getEStructuralFeature('eTypeParameter')'''.trimAql.let("eStructuralFeature",
						"org.eclipse.emf.ecoretools.design.action.openSelectModelElementID".javaDo("open select etype dialog", 
							"message" -> ''' 'Select an ' + eStructuralFeature.eType.name +  ' for the ' + eStructuralFeature.name +  ' reference.' '''.trimAql,
							"title" -> ''' 'Select ' + eStructuralFeature.eType.name '''.trimAql,
							"candidates" -> '''input.emfEditServices(self).getChoiceOfValues(eStructuralFeature)'''.trimAql,
							"feature" -> "var:eStructuralFeature",
							"host" -> "var:self"
						)
					)
				]
			]
			controls += LabelDescription.create("EClassifier label") [
				labelExpression = "Classifier:"
				valueExpression = '''self.eTypeArguments->at(2).eClassifier'''.trimAql
				displayExpression = '''self.eTypeArguments->at(2).eClassifier.name'''.trimAql
				actions += WidgetAction.create [
					labelExpression = "..."
					operation = '''self.eClass().getEStructuralFeature('eClassifier')'''.trimAql.let("eStructuralFeature",
						"org.eclipse.emf.ecoretools.design.action.openSelectModelElementID".javaDo("open select etype dialog", 
							"message" -> ''' 'Select an ' + eStructuralFeature.eType.name +  ' for the ' + eStructuralFeature.name +  ' reference.' '''.trimAql,
							"title" -> ''' 'Select ' + eStructuralFeature.eType.name '''.trimAql,
							"candidates" -> '''input.emfEditServices(self).getChoiceOfValues(eStructuralFeature)'''.trimAql,
							"feature" -> "var:eStructuralFeature",
							"host" -> "var:self"
						)
					)
				]
			]
		]
		groups += GroupDescription.createAs(Ns.group, "genmodel root") [
			labelExpression = '''self.eClass().name'''.trimAql
			semanticCandidateExpression = '''self->select(e | e.oclIsKindOf(ecore::EPackage)).eInverse()->select( g | g.eClass().ePackage.nsURI->includes('http://www.eclipse.org/emf/2002/GenModel')).eContainer(genmodel::GenModel)->asSet()'''.trimAql
			preconditionExpression = ""
			extends = GroupDescription.localRef(Ns.group, "default rules")
			style [
				expandedByDefault = true
			]
		]
		groups += GroupDescription.createAs(Ns.group, "execution_body") [
			labelExpression = '''self.getExecutableName()'''.trimAql
			semanticCandidateExpression = '''OrderedSet{self}->filter(ecore::EClassifier).getAllExecutables()'''.trimAql
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
			style [
				barStyle = TitleBarStyle.NO_TITLE
				toggleStyle = ToggleStyle.NONE
				expandedByDefault = true
			]
		]
		groups += GroupDescription.createAs(Ns.group, "execution_imports") [
			labelExpression = "Imports"
			domainClass = "ecore::EModelElement"
			semanticCandidateExpression = '''OrderedSet{self}->filter(ecore::EPackage)->select(p | p.getJavaImports()->size() > 0)'''.trimAql
			controls += ButtonDescription.create("execution_button_addimport") [
				buttonLabelExpression = "Add New Import"
				operation = "var:self".toOperation
			]
			controls += ContainerDescription.create("execution_imports_container") [
				controls += DynamicMappingForDescription.create("iterate over imports") [
					iterator = "jImport"
					iterableExpression = '''self.getJavaImports()'''.trimAql
					ifs += DynamicMappingIfDescription.create("true") [
						predicateExpression = '''true'''.trimAql
						widget = TextDescription.create("java_import") [
							labelExpression = "Qualified Class Name: "
							valueExpression = '''jImport.getQualifiedName()'''.trimAql
							operation = '''jImport.setQualifiedName(newValue)'''.trimAql.toOperation
						]
					]
					ifs += DynamicMappingIfDescription.create("true") [
						predicateExpression = '''true'''.trimAql
						widget = ButtonDescription.create("execution_remove_import") [
							buttonLabelExpression = "Remove Import"
							operation = "var:jImport".toContext(
								RemoveElement.create
							)
						]
					]
				]
				layout = FillLayoutDescription.create [
					orientation = FILL_LAYOUT_ORIENTATION.HORIZONTAL
				]
			]
			style [
				expandedByDefault = true
			]
		]
		groups += GroupDescription.createAs(Ns.group, "eoperation parameters dynamic mapping") [
			labelExpression = "Parameters"
			domainClass = "ecore::EOperation"
			semanticCandidateExpression = "var:self"
			controls += ContainerDescription.create("parameters_container") [
				controls += DynamicMappingForDescription.create("foreach parameter") [
					iterator = "self"
					iterableExpression = '''self.eParameters'''.trimAql
					forceRefresh = true
					ifs += DynamicMappingIfDescription.create("always true") [
						predicateExpression = '''true'''.trimAql
						widget = TextDescription.create("param_name") [
							labelExpression = "Name: "
							valueExpression = '''self.name'''.trimAql
							operation = "var:self".toContext(
								"name".setter("var:newValue")
							)
							style [
								labelFontSizeExpression = "8"
								labelFontFormat += FontFormat.ITALIC_LITERAL
							]
						]
					]
					ifs += DynamicMappingIfDescription.create("always true") [
						predicateExpression = '''true'''.trimAql
						widget = LabelDescription.create("etype label") [
							labelExpression = "EType: "
							valueExpression = '''self.eGet('eType')'''.trimAql
							displayExpression = '''self.eGet('eType').name'''.trimAql
							style [
								labelFontSizeExpression = "8"
								labelFontFormat += FontFormat.ITALIC_LITERAL
							]
							actions += WidgetAction.create [
								labelExpression = "..."
								operation = "org.eclipse.emf.ecoretools.design.action.openSelectModelElementID".javaDo("open select etype dialog", 
									"message" -> ''' 'Select an EClass for the eType reference.' '''.trimAql,
									"title" -> ''' 'Select EClass' '''.trimAql,
									"candidates" -> '''input.emfEditServices(self).getChoiceOfValues(self.eClass().getEStructuralFeature('eType'))'''.trimAql,
									"feature" -> '''self.eClass().getEStructuralFeature('eType')'''.trimAql,
									"host" -> "var:self"
								)
							]
							actions += WidgetAction.create [
								labelExpression = "∅"
								operation = "var:self".toContext(
									"eType".setter('''null'''.trimAql)
								)
							]
						]
					]
					ifs += DynamicMappingIfDescription.create("always true") [
						predicateExpression = '''true'''.trimAql
						widget = ButtonDescription.create("up") [
							isEnabledExpression = '''self.precedingSiblings()->filter(ecore::EParameter)->size() > 0'''.trimAql
							imageExpression = "/org.eclipse.emf.ecoretools.design/icons/full/etools16/up.gif"
							operation = "var:self".toContext(
								'''self.moveUpInContainer()'''.trimAql.toOperation
							)
						]
					]
					ifs += DynamicMappingIfDescription.create("always true") [
						predicateExpression = '''true'''.trimAql
						widget = ButtonDescription.create("down") [
							isEnabledExpression = '''self.precedingSiblings()->filter(ecore::EParameter)->size() +1 < self.eContainer(ecore::EOperation).eParameters->size()'''.trimAql
							imageExpression = "/org.eclipse.emf.ecoretools.design/icons/full/etools16/down.gif"
							operation = "var:self".toContext(
								'''self.moveDownInContainer()'''.trimAql.toOperation
							)
						]
					]
					ifs += DynamicMappingIfDescription.create("always true") [
						predicateExpression = '''true'''.trimAql
						widget = ButtonDescription.create("del") [
							imageExpression = "/org.eclipse.emf.ecoretools.design/icons/full/etools16/unset.gif"
							operation = "var:self".toContext(
								RemoveElement.create
							)
						]
					]
				]
				layout = GridLayoutDescription.create [
					numberOfColumns = 5
				]
			]
			controls += DynamicMappingForDescription.create("dummy_workaround_bug515586") [
				iterator = "d"
				iterableExpression = '''self'''.trimAql
				forceRefresh = true
				ifs += DynamicMappingIfDescription.create("always false") [
					predicateExpression = '''false'''.trimAql
					widget = TextDescription.create("dummy") [
						operation = "var:self".toOperation
					]
				]
			]
			style [
				expandedByDefault = true
			]
			actions += ToolbarAction.create [
				tooltipExpression = "Add New Parameter"
				imageExpression = "/org.eclipse.emf.ecore.edit/icons/full/ctool16/CreateEOperation_eParameters_EParameter.gif"
				operation = "var:self".toContext(
					"eParameters".creator("ecore::EParameter").chain(
						"name".setter(''' 'param' + self.eContainer().eContents()->filter(ecore::EParameter)->size() '''.trimAql)
					)
				)
			]
		]
		groups += GroupDescription.createAs(Ns.group, "eannotation dynamic") [
			labelExpression = ''' 'EAnnotation ' + self.source '''.trimAql
			domainClass = "ecore::EAnnotation"
			semanticCandidateExpression = '''input.getSemanticElement()->filter(ecore::EModelElement).eAnnotations'''.trimAql
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
				controls += DynamicMappingForDescription.create("iterate over entries") [
					iterator = "self"
					iterableExpression = '''self.details'''.trimAql
					forceRefresh = true
					ifs += DynamicMappingIfDescription.create("always_true") [
						predicateExpression = '''true'''.trimAql
						widget = TextDescription.create("detail_key") [
							labelExpression = "Key:"
							valueExpression = '''self.key'''.trimAql
							operation = "var:self".toContext(
								"key".setter("var:newValue")
							)
						]
					]
					ifs += DynamicMappingIfDescription.create("always_true") [
						predicateExpression = '''true'''.trimAql
						widget = TextDescription.create("detail_value") [
							labelExpression = "Value:"
							valueExpression = '''self.value'''.trimAql
							operation = "var:self".toContext(
								"value".setter("var:newValue")
							)
						]
					]
					ifs += DynamicMappingIfDescription.create("always_true") [
						predicateExpression = '''true'''.trimAql
						widget = ButtonDescription.create("del") [
							helpExpression = "Delete the entry"
							imageExpression = "/org.eclipse.emf.ecoretools.design/icons/full/etools16/unset.gif"
							operation = "var:self".toContext(
								RemoveElement.create
							)
						]
					]
				]
				layout = GridLayoutDescription.create [
					numberOfColumns = 3
				]
			]
			controls += DynamicMappingForDescription.create("dummy_workaround_bug515586") [
				iterator = "d"
				iterableExpression = '''self'''.trimAql
				forceRefresh = true
				ifs += DynamicMappingIfDescription.create("always false") [
					predicateExpression = '''false'''.trimAql
					widget = TextDescription.create("dummy_text") [
						operation = "var:self".toOperation
					]
				]
			]
			style [
				toggleStyle = ToggleStyle.TREE_NODE
				expandedByDefault = true
			]
			actions += ToolbarAction.create [
				tooltipExpression = "Delete EAnnotation"
				imageExpression = "/org.eclipse.emf.ecoretools.design/icons/full/etools16/unset.gif"
				operation = "var:self".toContext(
					RemoveElement.create
				)
			]
		]
	}

}