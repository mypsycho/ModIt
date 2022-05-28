package org.eclipse.emf.ecoretools.design.sirius

import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EPackage
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
import org.mypsycho.modit.emf.EModIt
import static extension org.eclipse.emf.ecoretools.design.sirius.EcoretoolsDesign.*

class EcoretoolsViewExtension {
	val EcoretoolsDesign context
	val extension EModIt factory

	new(EcoretoolsDesign parent) {
		this.context = parent
		this.factory = parent.factory
	}

	def ViewExtensionDescription createContent() {
		ViewExtensionDescription.createAs("EcoretoolsViewExtension") [
			name = "ecoretools"
			metamodels += org.eclipse.emf.ecore.EcorePackage.eINSTANCE
			metamodels += org.eclipse.emf.codegen.ecore.genmodel.GenModelPackage.eINSTANCE
			categories += Category.create [
				name = "Default"
				pages += PageDescription.create [
					name = "ecore_page"
					labelExpression = "Ecore"
					semanticCandidateExpression = "var:self"
					groups += GroupDescription.ref("EcoretoolsViewExtension")[ (it as ViewExtensionDescription).categories.head.groups.atIdentifiedElement("default rules") ]
					groups += GroupDescription.ref("EcoretoolsViewExtension")[ (it as ViewExtensionDescription).categories.head.groups.atIdentifiedElement("egeneric supertypes-TBD") ]
					validationSet = PageValidationSetDescription.create [
						semanticValidationRules += SemanticValidationRule.create [
							name = "NoNameOrInvalid"
							level = ERROR_LEVEL.ERROR_LITERAL
							message = "aql:' The '  + self.eClass().name +  ' should have a name which is a valid Java identifier.'"
							targetClass = "ecore::ENamedElement"
							audits += RuleAudit.create [
								auditExpression = "aql: (not self.oclIsKindOf(ecore::ENamedElement) ) or (self.name <> null and self.name.size() > 0)"
							]
						]
					]
				]
				pages += PageDescription.create [
					name = "parameters_page"
					labelExpression = "Parameters"
					domainClass = "ecore::EOperation"
					semanticCandidateExpression = "var:self"
					indented = true
					groups += GroupDescription.ref("EcoretoolsViewExtension")[ (it as ViewExtensionDescription).categories.head.groups.atIdentifiedElement("eoperation parameters dynamic mapping") ]
					validationSet = PageValidationSetDescription.create [
						semanticValidationRules += SemanticValidationRule.create [
							name = "NoNameOrInvalid"
							level = ERROR_LEVEL.ERROR_LITERAL
							message = "aql:' The '  + self.eClass().name +  ' should have a name which is a valid Java identifier.'"
							targetClass = "ecore::ENamedElement"
							audits += RuleAudit.create [
								auditExpression = "aql:(not self.oclIsKindOf(ecore::ENamedElement) ) or self.name <> null and self.name.size() > 0"
							]
						]
					]
				]
				pages += PageDescription.create [
					name = "documentation_page"
					labelExpression = "Documentation"
					semanticCandidateExpression = "var:self"
					indented = true
					groups += GroupDescription.ref("EcoretoolsViewExtension")[ (it as ViewExtensionDescription).categories.head.groups.atIdentifiedElement("documentation") ]
				]
				pages += PageDescription.create [
					name = "annotation_page"
					labelExpression = "Annotation"
					semanticCandidateExpression = "var:self"
					indented = true
					groups += GroupDescription.ref("EcoretoolsViewExtension")[ (it as ViewExtensionDescription).categories.head.groups.atIdentifiedElement("eannotation dynamic") ]
					actions += ToolbarAction.create [
						tooltipExpression = "Add EAnnotation"
						imageExpression = "/org.eclipse.emf.ecore.edit/icons/full/ctool16/CreateEModelElement_eAnnotations_EAnnotation.gif"
						initialOperation = InitialOperation.create [
							firstModelOperations = ChangeContext.create [
								browseExpression = "var:self"
								subModelOperations += CreateInstance.create [
									typeName = "ecore::EAnnotation"
									referenceName = "eAnnotations"
								]
							]
						]
					]
				]
				pages += PageDescription.create [
					name = "generation_page"
					labelExpression = "Generation"
					semanticCandidateExpression = "aql:self"
					preconditionExpression = "aql:self.eInverse()->select( g | g.eClass().ePackage.nsURI->includes('http://www.eclipse.org/emf/2002/GenModel'))->asSet()->size() > 0"
					groups += GroupDescription.ref("EcoretoolsViewExtension")[ (it as ViewExtensionDescription).categories.head.groups.atIdentifiedElement("genmodel_directories") ]
					groups += GroupDescription.ref("EcoretoolsViewExtension")[ (it as ViewExtensionDescription).categories.head.groups.atIdentifiedElement("genmodel opposite instance") ]
					groups += GroupDescription.ref("EcoretoolsViewExtension")[ (it as ViewExtensionDescription).categories.head.groups.atIdentifiedElement("generation_navigation") ]
					groups += GroupDescription.ref("EcoretoolsViewExtension")[ (it as ViewExtensionDescription).categories.head.groups.atIdentifiedElement("genmodel root") ]
					actions += ToolbarAction.create [
						tooltipExpression = "Generate Model"
						imageExpression = "/org.eclipse.emf.ecoretools.design/icons/full/etools16/generate_single.gif"
						initialOperation = InitialOperation.create [
							firstModelOperations = ChangeContext.create [
								browseExpression = "var:self"
								subModelOperations += ExternalJavaAction.create [
									name = "Generate Model Properties"
									id = "org.eclipse.emf.ecoretools.design.action.generateAllID"
									parameters += ExternalJavaActionParameter.create [
										name = "genmodels"
										value = "aql:self.eInverse()->select( g | g.eClass().ePackage.nsURI->includes('http://www.eclipse.org/emf/2002/GenModel'))->asSet().eContainerOrSelf(genmodel::GenModel)->asSet()"
									]
									parameters += ExternalJavaActionParameter.create [
										name = "scope"
										value = "model"
									]
								]
							]
						]
					]
					actions += ToolbarAction.create [
						tooltipExpression = "Generate Edit"
						imageExpression = "/org.eclipse.emf.ecoretools.design/icons/full/etools16/generate_single.gif"
						initialOperation = InitialOperation.create [
							firstModelOperations = ChangeContext.create [
								browseExpression = "var:self"
								subModelOperations += ExternalJavaAction.create [
									name = "Generate Edit Properties"
									id = "org.eclipse.emf.ecoretools.design.action.generateAllID"
									parameters += ExternalJavaActionParameter.create [
										name = "genmodels"
										value = "aql:self.eInverse()->select( g | g.eClass().ePackage.nsURI->includes('http://www.eclipse.org/emf/2002/GenModel'))->asSet().eContainerOrSelf(genmodel::GenModel)->asSet()"
									]
									parameters += ExternalJavaActionParameter.create [
										name = "scope"
										value = "edit"
									]
								]
							]
						]
					]
					actions += ToolbarAction.create [
						tooltipExpression = "Generate Editor"
						imageExpression = "/org.eclipse.emf.ecoretools.design/icons/full/etools16/generate_single.gif"
						initialOperation = InitialOperation.create [
							firstModelOperations = ChangeContext.create [
								browseExpression = "var:self"
								subModelOperations += ExternalJavaAction.create [
									name = "Generate Editor Properties"
									id = "org.eclipse.emf.ecoretools.design.action.generateAllID"
									parameters += ExternalJavaActionParameter.create [
										name = "genmodels"
										value = "aql:self.eInverse()->select( g | g.eClass().ePackage.nsURI->includes('http://www.eclipse.org/emf/2002/GenModel'))->asSet().eContainerOrSelf(genmodel::GenModel)->asSet()"
									]
									parameters += ExternalJavaActionParameter.create [
										name = "scope"
										value = "editor"
									]
								]
							]
						]
					]
					actions += ToolbarAction.create [
						tooltipExpression = "Generate All"
						imageExpression = "/org.eclipse.emf.ecoretools.design/icons/full/etools16/generate.gif"
						initialOperation = InitialOperation.create [
							firstModelOperations = ChangeContext.create [
								browseExpression = "var:self"
								subModelOperations += ExternalJavaAction.create [
									name = "Generate All Properties"
									id = "org.eclipse.emf.ecoretools.design.action.generateAllID"
									parameters += ExternalJavaActionParameter.create [
										name = "genmodels"
										value = "aql:self.eInverse()->select( g | g.eClass().ePackage.nsURI->includes('http://www.eclipse.org/emf/2002/GenModel'))->asSet().eContainerOrSelf(genmodel::GenModel)->asSet()"
									]
									parameters += ExternalJavaActionParameter.create [
										name = "scope"
										value = "model, edit, editor, tests"
									]
								]
							]
						]
					]
				]
				pages += PageDescription.create [
					name = "execution_page"
					labelExpression = "Execution"
					semanticCandidateExpression = "var:self"
					preconditionExpression = "aql:self.eContainerOrSelf(ecore::EPackage).isConfiguredForALE()"
					groups += GroupDescription.ref("EcoretoolsViewExtension")[ (it as ViewExtensionDescription).categories.head.groups.atIdentifiedElement("execution_body") ]
					groups += GroupDescription.ref("EcoretoolsViewExtension")[ (it as ViewExtensionDescription).categories.head.groups.atIdentifiedElement("execution_imports") ]
				]
				groups += GroupDescription.create [
					name = "default rules"
					labelExpression = "aql:input.emfEditServices(self).getText()"
					semanticCandidateExpression = "aql:self.removeSemanticElementsToHide(input.getAllSemanticElements(),input.context().semanticDecorator())"
					preconditionExpression = ""
					controls += DynamicMappingForDescription.create [
						name = "sirius_default_rules_structural_features_for"
						iterator = "eStructuralFeature"
						iterableExpression = "aql:self.removeFeaturesToHide(input.emfEditServices(self).getEStructuralFeatures())"
						ifs += DynamicMappingIfDescription.create [
							name = "sirius_default_rules_mono_string_if"
							predicateExpression = "aql:input.emfEditServices(self).needsTextWidget(eStructuralFeature) and not input.emfEditServices(self).isMultiline(eStructuralFeature)"
							widget = TextDescription.create [
								name = "sirius_default_rules_mono_string"
								labelExpression = "aql:input.emfEditServices(self).getText(eStructuralFeature)+':'"
								helpExpression = "aql:input.emfEditServices(self).getDescription(eStructuralFeature)"
								isEnabledExpression = "aql:eStructuralFeature.changeable"
								valueExpression = "aql:if eStructuralFeature.name = 'upperBound' and self.oclIsKindOf(ecore::ETypedElement) then self.upperBoundDisplay() else self.eGet(eStructuralFeature.name) endif"
								initialOperation = InitialOperation.create [
									firstModelOperations = ChangeContext.create [
										browseExpression = "var:self"
										subModelOperations += Switch.create [
											cases += Case.create [
												conditionExpression = "aql:eStructuralFeature.name = 'upperBound' and self.oclIsKindOf(ecore::ETypedElement)"
												subModelOperations += ChangeContext.create [
													browseExpression = "aql:self.setUpperBound(newValue)"
												]
											]
											^default = Default.create [
												subModelOperations += ChangeContext.create [
													browseExpression = "aql:input.emfEditServices(self).setValue(eStructuralFeature, newValue)"
												]
											]
										]
									]
								]
								conditionalStyles += TextWidgetConditionalStyle.create [
									preconditionExpression = "aql:eStructuralFeature.lowerBound==1"
									style = TextWidgetStyle.create [
										labelFontFormat += FontFormat.BOLD_LITERAL
									]
								]
							]
						]
						ifs += DynamicMappingIfDescription.create [
							name = "sirius_default_rules_multi_string_if"
							predicateExpression = "aql:input.emfEditServices(self).needsTextWidget(eStructuralFeature) and input.emfEditServices(self).isMultiline(eStructuralFeature)"
							widget = TextAreaDescription.create [
								name = "sirius_default_rules_multi_string"
								labelExpression = "aql:input.emfEditServices(self).getText(eStructuralFeature)+':'"
								helpExpression = "aql:input.emfEditServices(self).getDescription(eStructuralFeature)"
								isEnabledExpression = "aql:eStructuralFeature.changeable"
								valueExpression = "aql:self.eGet(eStructuralFeature.name)"
								initialOperation = InitialOperation.create [
									firstModelOperations = ChangeContext.create [
										browseExpression = "aql:input.emfEditServices(self).setValue(eStructuralFeature, newValue)"
									]
								]
								conditionalStyles += TextWidgetConditionalStyle.create [
									preconditionExpression = "aql:eStructuralFeature.lowerBound==1"
									style = TextWidgetStyle.create [
										labelFontFormat += FontFormat.BOLD_LITERAL
									]
								]
							]
						]
						ifs += DynamicMappingIfDescription.create [
							name = "sirius_default_rules_mono_boolean"
							predicateExpression = "aql:input.emfEditServices(self).needsCheckboxWidget(eStructuralFeature)"
							widget = CheckboxDescription.create [
								name = "sirius_default_rules_mono_boolean"
								labelExpression = "aql:input.emfEditServices(self).getText(eStructuralFeature)"
								helpExpression = "aql:input.emfEditServices(self).getDescription(eStructuralFeature)"
								isEnabledExpression = "aql:eStructuralFeature.changeable"
								valueExpression = "aql:self.eGet(eStructuralFeature.name)"
								initialOperation = InitialOperation.create [
									firstModelOperations = ChangeContext.create [
										browseExpression = "aql:input.emfEditServices(self).setValue(eStructuralFeature, newValue)"
									]
								]
								conditionalStyles += CheckboxWidgetConditionalStyle.create [
									preconditionExpression = "aql:eStructuralFeature.lowerBound==1"
									style = CheckboxWidgetStyle.create [
										labelFontFormat += FontFormat.BOLD_LITERAL
									]
								]
							]
						]
						ifs += DynamicMappingIfDescription.create [
							name = "sirius_default_rules_enum_if"
							predicateExpression = "aql:eStructuralFeature.eType.oclIsKindOf(ecore::EEnum) and not(eStructuralFeature.many)"
							widget = RadioDescription.create [
								name = "sirius_default_rules_enum"
								labelExpression = "aql:input.emfEditServices(self).getText(eStructuralFeature)+':'"
								helpExpression = "aql:input.emfEditServices(self).getDescription(eStructuralFeature)"
								isEnabledExpression = "aql:eStructuralFeature.changeable"
								valueExpression = "aql:eStructuralFeature.eType.oclAsType(ecore::EEnum).getEEnumLiteralByLiteral(self.eGet(eStructuralFeature.name).toString())"
								candidatesExpression = "aql:eStructuralFeature.eType.oclAsType(ecore::EEnum).eLiterals"
								candidateDisplayExpression = "aql:candidate.name"
								numberOfColumns = 5
								initialOperation = InitialOperation.create [
									firstModelOperations = ChangeContext.create [
										browseExpression = "aql:input.emfEditServices(self).setValue(eStructuralFeature, newValue.instance)"
									]
								]
								conditionalStyles += RadioWidgetConditionalStyle.create [
									preconditionExpression = "aql:eStructuralFeature.lowerBound==1"
									style = RadioWidgetStyle.create [
										labelFontFormat += FontFormat.BOLD_LITERAL
									]
								]
							]
						]
						ifs += DynamicMappingIfDescription.create [
							name = "sirius_default_rules_eattribute_many_if"
							predicateExpression = "aql:eStructuralFeature.oclIsKindOf(ecore::EAttribute) and eStructuralFeature.many"
							widget = ListDescription.create [
								name = "sirius_default_rules_eattribute_many"
								labelExpression = "aql:input.emfEditServices(self).getText(eStructuralFeature)+':'"
								helpExpression = "aql:input.emfEditServices(self).getDescription(eStructuralFeature)"
								isEnabledExpression = "aql:eStructuralFeature.changeable"
								valueExpression = "aql:self.eGet(eStructuralFeature.name)"
								displayExpression = "var:value"
							]
						]
						ifs += DynamicMappingIfDescription.create [
							name = "sirius_default_rules_ereference_if"
							predicateExpression = "aql:eStructuralFeature.oclIsKindOf(ecore::EReference) and eStructuralFeature.many = true"
							widget = ExtReferenceDescription.create [
								name = "sirius_default_rules_ereference"
								labelExpression = "aql:input.emfEditServices(self).getText(eStructuralFeature)+':'"
								helpExpression = "aql:input.emfEditServices(self).getDescription(eStructuralFeature)"
								referenceNameExpression = "aql:eStructuralFeature.name"
							]
						]
						ifs += DynamicMappingIfDescription.create [
							name = "ecoretools_etype_ereference"
							predicateExpression = "aql:eStructuralFeature.oclIsKindOf(ecore::EReference) and eStructuralFeature.many = false"
							widget = LabelDescription.create [
								name = "etype label"
								labelExpression = "aql:input.emfEditServices(self).getText(eStructuralFeature)+':'"
								helpExpression = "aql:input.emfEditServices(self).getDescription(eStructuralFeature)"
								valueExpression = "aql:self.eGetMonoRef(eStructuralFeature)"
								displayExpression = "aql:if self.eGetMonoRef(eStructuralFeature) <> null then input.emfEditServices(self.eGetMonoRef(eStructuralFeature)).getText() else '' endif"
								actions += WidgetAction.create [
									labelExpression = "..."
									initialOperation = InitialOperation.create [
										firstModelOperations = ExternalJavaAction.create [
											name = "open select etype dialog"
											id = "org.eclipse.emf.ecoretools.design.action.openSelectModelElementID"
											parameters += ExternalJavaActionParameter.create [
												name = "message"
												value = "aql:'Select an ' + eStructuralFeature.eType.name +  ' for the ' + eStructuralFeature.name +  ' reference.'"
											]
											parameters += ExternalJavaActionParameter.create [
												name = "title"
												value = "aql:'Select ' + eStructuralFeature.eType.name "
											]
											parameters += ExternalJavaActionParameter.create [
												name = "candidates"
												value = "aql:input.emfEditServices(self).getChoiceOfValues(eStructuralFeature)"
											]
											parameters += ExternalJavaActionParameter.create [
												name = "feature"
												value = "var:eStructuralFeature"
											]
											parameters += ExternalJavaActionParameter.create [
												name = "host"
												value = "var:self"
											]
										]
									]
								]
								actions += WidgetAction.create [
									labelExpression = "∅"
									initialOperation = InitialOperation.create [
										firstModelOperations = ChangeContext.create [
											browseExpression = "var:self"
											subModelOperations += ChangeContext.create [
												browseExpression = "aql:input.emfEditServices(self).setValue(eStructuralFeature, null)"
											]
										]
									]
								]
							]
						]
					]
					style = GroupStyle.create [
						barStyle = TitleBarStyle.NO_TITLE
						toggleStyle = ToggleStyle.NONE
						expandedByDefault = true
					]
					conditionalStyles += GroupConditionalStyle.create [
						preconditionExpression = "aql:self.removeSemanticElementsToHide(input.getAllSemanticElements(),input.context().semanticDecorator())->size() > 1"
						style = GroupStyle.create [
							toggleStyle = ToggleStyle.NONE
							expandedByDefault = true
						]
					]
				]
				groups += GroupDescription.create [
					name = "genmodel opposite instance"
					labelExpression = "aql:self.eClass().name"
					semanticCandidateExpression = "aql:self.eInverse()->select( g | g.eClass().ePackage.nsURI->includes('http://www.eclipse.org/emf/2002/GenModel'))->asSet()"
					preconditionExpression = ""
					extends = GroupDescription.ref("EcoretoolsViewExtension")[ (it as ViewExtensionDescription).categories.head.groups.atIdentifiedElement("default rules") ]
					style = GroupStyle.create [
						expandedByDefault = true
					]
				]
				groups += GroupDescription.create [
					name = "documentation"
					labelExpression = "Documentation"
					domainClass = "ecore::EModelElement"
					controls += ContainerDescription.create [
						name = "documentation_container"
						controls += TextAreaDescription.create [
							name = "doc_area"
							lineCount = 16
							valueExpression = "aql:self.getVisibleDocAnnotations().value"
							initialOperation = InitialOperation.create [
								firstModelOperations = ChangeContext.create [
									browseExpression = "aql:self.setDocAnnotation(newValue)"
								]
							]
						]
					]
					style = GroupStyle.create [
						barStyle = TitleBarStyle.NO_TITLE
						toggleStyle = ToggleStyle.NONE
						expandedByDefault = true
					]
				]
				groups += GroupDescription.create [
					name = "generation_navigation"
					semanticCandidateExpression = "aql:self.eInverse()->select( g | g.eClass().ePackage.nsURI->includes('http://www.eclipse.org/emf/2002/GenModel'))->asSet()"
					controls += ContainerDescription.create [
						name = "generation_navigation_container"
						controls += HyperlinkDescription.create [
							name = "goto sourcecode"
							isEnabledExpression = "aql:self.isJavaFileGenerated()"
							valueExpression = "aql:self"
							displayExpression = "aql:if self.isJavaFileGenerated() then 'Open Java Implementation' else '' endif"
							initialOperation = InitialOperation.create [
								firstModelOperations = ExternalJavaAction.create [
									name = "open java editor"
									id = "org.eclipse.emf.ecoretools.design.action.openFileInEditorID"
									parameters += ExternalJavaActionParameter.create [
										name = "path"
										value = "aql:self.getJavaImplementationPath()"
									]
								]
							]
						]
					]
					style = GroupStyle.create [
						barStyle = TitleBarStyle.NO_TITLE
						toggleStyle = ToggleStyle.NONE
						expandedByDefault = true
					]
				]
				groups += GroupDescription.create [
					name = "genmodel_directories"
					labelExpression = "Directories"
					domainClass = "genmodel.GenModel"
					semanticCandidateExpression = "aql:(OrderedSet{self} + self.eInverse()  + self.eInverse().eContainer()- self.eContents()- OrderedSet{self.eContainer()})->select(e | e.eClass().ePackage.nsURI->includes('http://www.eclipse.org/emf/2002/GenModel'))->asSet()"
					controls += TextDescription.create [
						name = "modelDirectory"
						labelExpression = "Model"
						valueExpression = "aql:self.modelDirectory"
						initialOperation = InitialOperation.create [
							firstModelOperations = SetValue.create [
								featureName = "modelDirectory"
								valueExpression = "var:newValue"
							]
						]
					]
					controls += TextDescription.create [
						name = "editDirectory"
						labelExpression = "Edit"
						valueExpression = "feature:editDirectory"
						initialOperation = InitialOperation.create [
							firstModelOperations = SetValue.create [
								featureName = "editDirectory"
								valueExpression = "var:newValue"
							]
						]
					]
					controls += TextDescription.create [
						name = "editorDirectory"
						labelExpression = "Editor"
						valueExpression = "feature:editorDirectory"
						initialOperation = InitialOperation.create [
							firstModelOperations = SetValue.create [
								featureName = "editorDirectory"
								valueExpression = "var:newValue"
							]
						]
					]
					style = GroupStyle.create [
						barStyle = TitleBarStyle.SHORT_TITLE_BAR
						expandedByDefault = true
					]
				]
				groups += GroupDescription.create [
					name = "egeneric supertypes-TBD"
					labelExpression = "aql:'EGenericType : ' + input.emfEditServices(self).getText()"
					domainClass = "ecore::EGenericType"
					semanticCandidateExpression = "aql: input.getSemanticElement()->filter(ecore::EClass).eGenericSuperTypes"
					preconditionExpression = "aql:false and self.oclIsKindOf(ecore::EClass)"
					controls += LabelDescription.create [
						name = "etypeparameter label"
						labelExpression = "EType Parameter:"
						valueExpression = "aql:self.eTypeArguments->first().eTypeParameter"
						displayExpression = "aql:self.eTypeArguments->first().eTypeParameter.name"
						actions += WidgetAction.create [
							labelExpression = "..."
							initialOperation = InitialOperation.create [
								firstModelOperations = Let.create [
									variableName = "eStructuralFeature"
									valueExpression = "aql:self.eClass().getEStructuralFeature('eTypeParameter')"
									subModelOperations += ExternalJavaAction.create [
										name = "open select etype dialog"
										id = "org.eclipse.emf.ecoretools.design.action.openSelectModelElementID"
										parameters += ExternalJavaActionParameter.create [
											name = "message"
											value = "aql:'Select an ' + eStructuralFeature.eType.name +  ' for the ' + eStructuralFeature.name +  ' reference.'"
										]
										parameters += ExternalJavaActionParameter.create [
											name = "title"
											value = "aql:'Select ' + eStructuralFeature.eType.name "
										]
										parameters += ExternalJavaActionParameter.create [
											name = "candidates"
											value = "aql:input.emfEditServices(self).getChoiceOfValues(eStructuralFeature)"
										]
										parameters += ExternalJavaActionParameter.create [
											name = "feature"
											value = "var:eStructuralFeature"
										]
										parameters += ExternalJavaActionParameter.create [
											name = "host"
											value = "var:self"
										]
									]
								]
							]
						]
					]
					controls += LabelDescription.create [
						name = "EClassifier label"
						labelExpression = "Classifier:"
						valueExpression = "aql:self.eTypeArguments->at(2).eClassifier"
						displayExpression = "aql:self.eTypeArguments->at(2).eClassifier.name"
						actions += WidgetAction.create [
							labelExpression = "..."
							initialOperation = InitialOperation.create [
								firstModelOperations = Let.create [
									variableName = "eStructuralFeature"
									valueExpression = "aql:self.eClass().getEStructuralFeature('eClassifier')"
									subModelOperations += ExternalJavaAction.create [
										name = "open select etype dialog"
										id = "org.eclipse.emf.ecoretools.design.action.openSelectModelElementID"
										parameters += ExternalJavaActionParameter.create [
											name = "message"
											value = "aql:'Select an ' + eStructuralFeature.eType.name +  ' for the ' + eStructuralFeature.name +  ' reference.'"
										]
										parameters += ExternalJavaActionParameter.create [
											name = "title"
											value = "aql:'Select ' + eStructuralFeature.eType.name "
										]
										parameters += ExternalJavaActionParameter.create [
											name = "candidates"
											value = "aql:input.emfEditServices(self).getChoiceOfValues(eStructuralFeature)"
										]
										parameters += ExternalJavaActionParameter.create [
											name = "feature"
											value = "var:eStructuralFeature"
										]
										parameters += ExternalJavaActionParameter.create [
											name = "host"
											value = "var:self"
										]
									]
								]
							]
						]
					]
				]
				groups += GroupDescription.create [
					name = "genmodel root"
					labelExpression = "aql:self.eClass().name"
					semanticCandidateExpression = "aql:self->select(e | e.oclIsKindOf(ecore::EPackage)).eInverse()->select( g | g.eClass().ePackage.nsURI->includes('http://www.eclipse.org/emf/2002/GenModel')).eContainer(genmodel::GenModel)->asSet()"
					preconditionExpression = ""
					extends = GroupDescription.ref("EcoretoolsViewExtension")[ (it as ViewExtensionDescription).categories.head.groups.atIdentifiedElement("default rules") ]
					style = GroupStyle.create [
						expandedByDefault = true
					]
				]
				groups += GroupDescription.create [
					name = "execution_body"
					labelExpression = "aql:self.getExecutableName()"
					semanticCandidateExpression = "aql:OrderedSet{self}->filter(ecore::EClassifier).getAllExecutables()"
					controls += ContainerDescription.create [
						name = "container_execution_body"
						controls += TextAreaDescription.create [
							name = "executable_body"
							lineCount = 14
							valueExpression = "aql:self.getExecutableBody()"
							initialOperation = InitialOperation.create [
								firstModelOperations = ChangeContext.create [
									browseExpression = "var:self"
									subModelOperations += ChangeContext.create [
										browseExpression = "aql:self.setExecutableBody(newValue)"
									]
								]
							]
						]
					]
					validationSet = GroupValidationSetDescription.create [
						semanticValidationRules += SemanticValidationRule.create [
							name = "isValidSyntax"
							level = ERROR_LEVEL.ERROR_LITERAL
							message = "Syntax error in body"
							targetClass = "EObject"
							audits += RuleAudit.create [
								auditExpression = "aql:self.isValidBody()"
							]
						]
					]
					style = GroupStyle.create [
						barStyle = TitleBarStyle.NO_TITLE
						toggleStyle = ToggleStyle.NONE
						expandedByDefault = true
					]
				]
				groups += GroupDescription.create [
					name = "execution_imports"
					labelExpression = "Imports"
					domainClass = "ecore::EModelElement"
					semanticCandidateExpression = "aql:OrderedSet{self}->filter(ecore::EPackage)->select(p | p.getJavaImports()->size() > 0)"
					controls += ButtonDescription.create [
						name = "execution_button_addimport"
						buttonLabelExpression = "Add New Import"
						initialOperation = InitialOperation.create [
							firstModelOperations = ChangeContext.create [
								browseExpression = "var:self"
							]
						]
					]
					controls += ContainerDescription.create [
						name = "execution_imports_container"
						controls += DynamicMappingForDescription.create [
							name = "iterate over imports"
							iterator = "jImport"
							iterableExpression = "aql:self.getJavaImports()"
							ifs += DynamicMappingIfDescription.create [
								name = "true"
								predicateExpression = "aql:true"
								widget = TextDescription.create [
									name = "java_import"
									labelExpression = "Qualified Class Name: "
									valueExpression = "aql:jImport.getQualifiedName()"
									initialOperation = InitialOperation.create [
										firstModelOperations = ChangeContext.create [
											browseExpression = "aql:jImport.setQualifiedName(newValue)"
										]
									]
								]
							]
							ifs += DynamicMappingIfDescription.create [
								name = "true"
								predicateExpression = "aql:true"
								widget = ButtonDescription.create [
									name = "execution_remove_import"
									buttonLabelExpression = "Remove Import"
									initialOperation = InitialOperation.create [
										firstModelOperations = ChangeContext.create [
											browseExpression = "var:jImport"
											subModelOperations += RemoveElement.create
										]
									]
								]
							]
						]
						layout = FillLayoutDescription.create [
							orientation = FILL_LAYOUT_ORIENTATION.HORIZONTAL
						]
					]
					style = GroupStyle.create [
						expandedByDefault = true
					]
				]
				groups += GroupDescription.create [
					name = "eoperation parameters dynamic mapping"
					labelExpression = "Parameters"
					domainClass = "ecore::EOperation"
					semanticCandidateExpression = "var:self"
					controls += ContainerDescription.create [
						name = "parameters_container"
						controls += DynamicMappingForDescription.create [
							name = "foreach parameter"
							iterator = "self"
							iterableExpression = "aql:self.eParameters"
							forceRefresh = true
							ifs += DynamicMappingIfDescription.create [
								name = "always true"
								predicateExpression = "aql:true"
								widget = TextDescription.create [
									name = "param_name"
									labelExpression = "Name: "
									valueExpression = "aql:self.name"
									initialOperation = InitialOperation.create [
										firstModelOperations = ChangeContext.create [
											browseExpression = "var:self"
											subModelOperations += SetValue.create [
												featureName = "name"
												valueExpression = "var:newValue"
											]
										]
									]
									style = TextWidgetStyle.create [
										labelFontSizeExpression = "8"
										labelFontFormat += FontFormat.ITALIC_LITERAL
									]
								]
							]
							ifs += DynamicMappingIfDescription.create [
								name = "always true"
								predicateExpression = "aql:true"
								widget = LabelDescription.create [
									name = "etype label"
									labelExpression = "EType: "
									valueExpression = "aql:self.eGet('eType')"
									displayExpression = "aql:self.eGet('eType').name"
									style = LabelWidgetStyle.create [
										labelFontSizeExpression = "8"
										labelFontFormat += FontFormat.ITALIC_LITERAL
									]
									actions += WidgetAction.create [
										labelExpression = "..."
										initialOperation = InitialOperation.create [
											firstModelOperations = ExternalJavaAction.create [
												name = "open select etype dialog"
												id = "org.eclipse.emf.ecoretools.design.action.openSelectModelElementID"
												parameters += ExternalJavaActionParameter.create [
													name = "message"
													value = "aql:'Select an EClass for the eType reference.'"
												]
												parameters += ExternalJavaActionParameter.create [
													name = "title"
													value = "aql:'Select EClass'"
												]
												parameters += ExternalJavaActionParameter.create [
													name = "candidates"
													value = "aql:input.emfEditServices(self).getChoiceOfValues(self.eClass().getEStructuralFeature('eType'))"
												]
												parameters += ExternalJavaActionParameter.create [
													name = "feature"
													value = "aql:self.eClass().getEStructuralFeature('eType')"
												]
												parameters += ExternalJavaActionParameter.create [
													name = "host"
													value = "var:self"
												]
											]
										]
									]
									actions += WidgetAction.create [
										labelExpression = "∅"
										initialOperation = InitialOperation.create [
											firstModelOperations = ChangeContext.create [
												browseExpression = "var:self"
												subModelOperations += SetValue.create [
													featureName = "eType"
													valueExpression = "aql:null"
												]
											]
										]
									]
								]
							]
							ifs += DynamicMappingIfDescription.create [
								name = "always true"
								predicateExpression = "aql:true"
								widget = ButtonDescription.create [
									name = "up"
									isEnabledExpression = "aql:self.precedingSiblings()->filter(ecore::EParameter)->size() > 0"
									imageExpression = "/org.eclipse.emf.ecoretools.design/icons/full/etools16/up.gif"
									initialOperation = InitialOperation.create [
										firstModelOperations = ChangeContext.create [
											browseExpression = "var:self"
											subModelOperations += ChangeContext.create [
												browseExpression = "aql:self.moveUpInContainer()"
											]
										]
									]
								]
							]
							ifs += DynamicMappingIfDescription.create [
								name = "always true"
								predicateExpression = "aql:true"
								widget = ButtonDescription.create [
									name = "down"
									isEnabledExpression = "aql:self.precedingSiblings()->filter(ecore::EParameter)->size() +1 < self.eContainer(ecore::EOperation).eParameters->size()"
									imageExpression = "/org.eclipse.emf.ecoretools.design/icons/full/etools16/down.gif"
									initialOperation = InitialOperation.create [
										firstModelOperations = ChangeContext.create [
											browseExpression = "var:self"
											subModelOperations += ChangeContext.create [
												browseExpression = "aql:self.moveDownInContainer()"
											]
										]
									]
								]
							]
							ifs += DynamicMappingIfDescription.create [
								name = "always true"
								predicateExpression = "aql:true"
								widget = ButtonDescription.create [
									name = "del"
									imageExpression = "/org.eclipse.emf.ecoretools.design/icons/full/etools16/unset.gif"
									initialOperation = InitialOperation.create [
										firstModelOperations = ChangeContext.create [
											browseExpression = "var:self"
											subModelOperations += RemoveElement.create
										]
									]
								]
							]
						]
						layout = GridLayoutDescription.create [
							numberOfColumns = 5
						]
					]
					controls += DynamicMappingForDescription.create [
						name = "dummy_workaround_bug515586"
						iterator = "d"
						iterableExpression = "aql:self"
						forceRefresh = true
						ifs += DynamicMappingIfDescription.create [
							name = "always false"
							predicateExpression = "aql:false"
							widget = TextDescription.create [
								name = "dummy"
								initialOperation = InitialOperation.create [
									firstModelOperations = ChangeContext.create [
										browseExpression = "var:self"
									]
								]
							]
						]
					]
					style = GroupStyle.create [
						expandedByDefault = true
					]
					actions += ToolbarAction.create [
						tooltipExpression = "Add New Parameter"
						imageExpression = "/org.eclipse.emf.ecore.edit/icons/full/ctool16/CreateEOperation_eParameters_EParameter.gif"
						initialOperation = InitialOperation.create [
							firstModelOperations = ChangeContext.create [
								browseExpression = "var:self"
								subModelOperations += CreateInstance.create [
									typeName = "ecore::EParameter"
									referenceName = "eParameters"
									subModelOperations += SetValue.create [
										featureName = "name"
										valueExpression = "aql:'param' + self.eContainer().eContents()->filter(ecore::EParameter)->size()"
									]
								]
							]
						]
					]
				]
				groups += GroupDescription.create [
					name = "eannotation dynamic"
					labelExpression = "aql:'EAnnotation ' + self.source"
					domainClass = "ecore::EAnnotation"
					semanticCandidateExpression = "aql:input.getSemanticElement()->filter(ecore::EModelElement).eAnnotations"
					controls += TextDescription.create [
						name = "source"
						labelExpression = "Source:"
						helpExpression = "aql:input.emfEditServices(self).getDescription(self.eClass().getEStructuralFeature('source'))"
						valueExpression = "aql:self.source"
						initialOperation = InitialOperation.create [
							firstModelOperations = ChangeContext.create [
								browseExpression = "var:self"
								subModelOperations += SetValue.create [
									featureName = "source"
									valueExpression = "var:newValue"
								]
							]
						]
					]
					controls += ExtReferenceDescription.create [
						name = "references ref"
						labelExpression = "aql:input.emfEditServices(self).getText(self.eClass().getEStructuralFeature('references'))+':'"
						helpExpression = "aql:input.emfEditServices(self).getDescription(self.eClass().getEStructuralFeature('references'))"
						referenceNameExpression = "references"
						referenceOwnerExpression = "aql:self"
					]
					controls += ContainerDescription.create [
						name = "eannota_buttons"
						controls += ButtonDescription.create [
							name = "eannotation_add_entry"
							buttonLabelExpression = "Add Entry"
							initialOperation = InitialOperation.create [
								firstModelOperations = ChangeContext.create [
									browseExpression = "var:self"
									subModelOperations += CreateInstance.create [
										typeName = "ecore.EStringToStringMapEntry"
										referenceName = "details"
									]
								]
							]
						]
					]
					controls += ContainerDescription.create [
						name = "eannotation_conainer_entries"
						controls += DynamicMappingForDescription.create [
							name = "iterate over entries"
							iterator = "self"
							iterableExpression = "aql:self.details"
							forceRefresh = true
							ifs += DynamicMappingIfDescription.create [
								name = "always_true"
								predicateExpression = "aql:true"
								widget = TextDescription.create [
									name = "detail_key"
									labelExpression = "Key:"
									valueExpression = "aql:self.key"
									initialOperation = InitialOperation.create [
										firstModelOperations = ChangeContext.create [
											browseExpression = "var:self"
											subModelOperations += SetValue.create [
												featureName = "key"
												valueExpression = "var:newValue"
											]
										]
									]
								]
							]
							ifs += DynamicMappingIfDescription.create [
								name = "always_true"
								predicateExpression = "aql:true"
								widget = TextDescription.create [
									name = "detail_value"
									labelExpression = "Value:"
									valueExpression = "aql:self.value"
									initialOperation = InitialOperation.create [
										firstModelOperations = ChangeContext.create [
											browseExpression = "var:self"
											subModelOperations += SetValue.create [
												featureName = "value"
												valueExpression = "var:newValue"
											]
										]
									]
								]
							]
							ifs += DynamicMappingIfDescription.create [
								name = "always_true"
								predicateExpression = "aql:true"
								widget = ButtonDescription.create [
									name = "del"
									helpExpression = "Delete the entry"
									imageExpression = "/org.eclipse.emf.ecoretools.design/icons/full/etools16/unset.gif"
									initialOperation = InitialOperation.create [
										firstModelOperations = ChangeContext.create [
											browseExpression = "var:self"
											subModelOperations += RemoveElement.create
										]
									]
								]
							]
						]
						layout = GridLayoutDescription.create [
							numberOfColumns = 3
						]
					]
					controls += DynamicMappingForDescription.create [
						name = "dummy_workaround_bug515586"
						iterator = "d"
						iterableExpression = "aql:self"
						forceRefresh = true
						ifs += DynamicMappingIfDescription.create [
							name = "always false"
							predicateExpression = "aql:false"
							widget = TextDescription.create [
								name = "dummy_text"
								initialOperation = InitialOperation.create [
									firstModelOperations = ChangeContext.create [
										browseExpression = "var:self"
									]
								]
							]
						]
					]
					style = GroupStyle.create [
						toggleStyle = ToggleStyle.TREE_NODE
						expandedByDefault = true
					]
					actions += ToolbarAction.create [
						tooltipExpression = "Delete EAnnotation"
						imageExpression = "/org.eclipse.emf.ecoretools.design/icons/full/etools16/unset.gif"
						initialOperation = InitialOperation.create [
							firstModelOperations = ChangeContext.create [
								browseExpression = "var:self"
								subModelOperations += RemoveElement.create
							]
						]
					]
				]
			]
		]
	}

	def <T> T extraRef(Class<T> type, String key) {
		context.extraRef(type, key)
	}
	
}
