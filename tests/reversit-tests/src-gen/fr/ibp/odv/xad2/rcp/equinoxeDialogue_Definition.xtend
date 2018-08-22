package fr.ibp.odv.xad2.rcp

import fr.ibp.odv.xad2.rcp.properties.ext.sirius.eqxSiriusProperties.EqxHyperlinkDescription
import java.util.Map
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.sirius.properties.Category
import org.eclipse.sirius.properties.CheckboxDescription
import org.eclipse.sirius.properties.CheckboxWidgetStyle
import org.eclipse.sirius.properties.CustomDescription
import org.eclipse.sirius.properties.CustomExpression
import org.eclipse.sirius.properties.GroupDescription
import org.eclipse.sirius.properties.HyperlinkWidgetStyle
import org.eclipse.sirius.properties.ListDescription
import org.eclipse.sirius.properties.SelectDescription
import org.eclipse.sirius.properties.SelectWidgetConditionalStyle
import org.eclipse.sirius.properties.SelectWidgetStyle
import org.eclipse.sirius.properties.TextAreaDescription
import org.eclipse.sirius.properties.TextDescription
import org.eclipse.sirius.properties.TextWidgetConditionalStyle
import org.eclipse.sirius.properties.TextWidgetStyle
import org.eclipse.sirius.properties.WidgetAction
import org.eclipse.sirius.viewpoint.description.Environment
import org.eclipse.sirius.viewpoint.description.SystemColor
import org.eclipse.sirius.viewpoint.description.tool.ChangeContext
import org.eclipse.sirius.viewpoint.description.tool.InitialOperation
import org.mypsycho.emf.modit.EModIt

class equinoxeDialogue_Definition {
  val EqxModelDesign context
  val extension EModIt factory

  new(EqxModelDesign parent) {
    this.context = parent
    this.factory = parent.factory
  }

  def content() {
    "equinoxeDialogue_Definition".alias(Category.create[
      name = "equinoxeDialogue_Definition"
      groups += GroupDescription.create[
        name = "AWADialogFormats_Conception_Group"
        domainClass = "equinoxeDialogue.AWADialogFormats"
        controls += EqxHyperlinkDescription.create[
          name = "AWADialogFormats_inputFormat_Ref"
          labelExpression = "aql:self.getFeatureLabel('inputFormat')"
          helpExpression = ""
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:inputFormat"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          style = HyperlinkWidgetStyle.create[
            labelFontFormat += org.eclipse.sirius.viewpoint.FontFormat.getByName("bold")
          ]
          actions += WidgetAction.create[
            labelExpression = "..."
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxSetFromListView('inputFormat')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('inputFormat')"
              ]
            ]
          ]
        ]
        controls += EqxHyperlinkDescription.create[
          name = "AWADialogFormats_outputFormat_Ref"
          labelExpression = "aql:self.getFeatureLabel('outputFormat')"
          helpExpression = ""
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:outputFormat"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          style = HyperlinkWidgetStyle.create[
            labelFontFormat += org.eclipse.sirius.viewpoint.FontFormat.getByName("bold")
          ]
          actions += WidgetAction.create[
            labelExpression = "..."
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxSetFromListView('outputFormat')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('outputFormat')"
              ]
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "AbstractCboDisplayer_Conception_Group"
        domainClass = "equinoxeDialogue.AbstractCboDisplayer"
        controls += EqxHyperlinkDescription.create[
          name = "AbstractCboDisplayer_cboCode_Ref"
          labelExpression = "aql:self.getFeatureLabel('cboCode')"
          helpExpression = "Code object (CBO code) dont la liste de codes affiche les valeurs."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:cboCode"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "..."
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxSetFromTreeView('cboCode')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('cboCode')"
              ]
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "AbstractCboDisplayer_specificLabel_Txt"
          labelExpression = "aql:self.getFeatureLabel('specificLabel')"
          helpExpression = "Propri�t� sp�cifique du CBO utilis�e pour afficher un �l�ment de la liste."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:specificLabel"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('specificLabel',newValue)"
            ]
          ]
          conditionalStyles += TextWidgetConditionalStyle.create[
            preconditionExpression = "aql:self.standardLabel = equinoxeDialogue::EnumCboLabel::_Undefined"
            style = TextWidgetStyle.create[
              labelFontFormat += org.eclipse.sirius.viewpoint.FontFormat.getByName("bold")
            ]
          ]
        ]
        controls += SelectDescription.create[
          name = "AbstractCboDisplayer_standardLabel_Enum"
          labelExpression = "aql:self.getFeatureLabel('standardLabel')"
          helpExpression = "Propri�t� standard du CBO utilis�e pour afficher un �l�ment de la liste."
          isEnabledExpression = "aql:self.isNotReadOnlyElement() and (self.specificLabel = '' or self.specificLabel = null)"
          valueExpression = "feature:standardLabel"
          candidatesExpression = "aql:equinoxeDialogue::EnumCboLabel.eLiterals->collect(e|e.instance)"
          candidateDisplayExpression = "aql:candidate.toString()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('standardLabel',newValue)"
            ]
          ]
          conditionalStyles += SelectWidgetConditionalStyle.create[
            preconditionExpression = "aql:self.specificLabel = '' or self.specificLabel = null"
            style = SelectWidgetStyle.create[
              labelFontFormat += org.eclipse.sirius.viewpoint.FontFormat.getByName("bold")
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "AbstractDocList_Conception_Group"
        domainClass = "equinoxeDialogue.AbstractDocList"
        controls += SelectDescription.create[
          name = "AbstractDocList_realisation_Enum"
          labelExpression = "aql:self.getFeatureLabel('realisation')"
          helpExpression = ""
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:realisation"
          candidatesExpression = "aql:equinoxeDialogue::EnumListRealisation.eLiterals->collect(e|e.instance)"
          candidateDisplayExpression = "aql:candidate.toString()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('realisation',newValue)"
            ]
          ]
        ]
        controls += SelectDescription.create[
          name = "AbstractDocList_selectionMode_Enum"
          labelExpression = "aql:self.getFeatureLabel('selectionMode')"
          helpExpression = "Mode de s�lection dans la liste.\nMULTIPLE_SELECTION est disponible uniquement quand la r�alisation est \"listBox\" et que l'�cran se situe sur le canal INTERNET.\nNO_SELECTION est disponible uniquement si le nombre de lignes visibles est sup�rieur � 1.\nValeurs possibles :"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:selectionMode"
          candidatesExpression = "aql:self.getAbstractDocListSelectionModeCandidate()"
          candidateDisplayExpression = "aql:candidate.toString()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('selectionMode',newValue)"
            ]
          ]
        ]
        controls += EqxHyperlinkDescription.create[
          name = "AbstractDocList_targetedWidget_Ref"
          labelExpression = "aql:self.getFeatureLabel('targetedWidget')"
          helpExpression = "Pour un filtre de bloc uniquement : tableau graphique contenu dans le bloc sur lequel s'applique le filtre de bloc. La mod�lisation de la colonne de tableau sur laquelle s'applique le filtre n'est pas n�cessaire."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:targetedWidget"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "..."
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxSetFromTreeView('targetedWidget')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('targetedWidget')"
              ]
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "AbstractDocList_Affichage_Group"
        domainClass = "equinoxeDialogue.AbstractDocList"
        controls += SelectDescription.create[
          name = "AbstractDocList_orientation_Enum"
          labelExpression = "aql:self.getFeatureLabel('orientation')"
          helpExpression = "Orientation des boutons radios (vertical par d�faut ou horizontal). Editable seulement pour une r�alisation de type 'radios'."
          isEnabledExpression = "aql:self.isNotReadOnlyElement() and self.realisation = equinoxeDialogue::EnumListRealisation::radios"
          valueExpression = "feature:orientation"
          candidatesExpression = "aql:equinoxeDialogue::EnumOrientation.eLiterals->collect(e|e.instance)"
          candidateDisplayExpression = "aql:candidate.toString()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('orientation',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "AbstractStateMachine_Conception_Group"
        domainClass = "equinoxeDialogue.AbstractStateMachine"
        controls += TextAreaDescription.create[
          name = "AbstractStateMachine_initialization_TxtArea"
          labelExpression = "aql:self.getFeatureLabel('initialization')"
          helpExpression = "Description des initialisations avant le d�roulement de la proc�dure. Notamment les traitements d'initialisation du contexte."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:initialization"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('initialization',newValue)"
            ]
          ]
        ]
        controls += TextAreaDescription.create[
          name = "AbstractStateMachine_finalization_TxtArea"
          labelExpression = "aql:self.getFeatureLabel('finalization')"
          helpExpression = "D�crire les finalisations avant de quitter la proc�dure."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:finalization"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('finalization',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "AbstractTransition_Conception_Group"
        domainClass = "equinoxeDialogue.AbstractTransition"
        controls += EqxHyperlinkDescription.create[
          name = "AbstractTransition_target_Ref"
          labelExpression = "Etat cible"
          helpExpression = ""
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:target"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          style = HyperlinkWidgetStyle.create[
            labelFontFormat += org.eclipse.sirius.viewpoint.FontFormat.getByName("bold")
          ]
          actions += WidgetAction.create[
            labelExpression = "..."
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxSetFromListView('target')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('target')"
              ]
            ]
          ]
        ]
        controls += TextAreaDescription.create[
          name = "AbstractTransition_condition_TxtArea"
          labelExpression = "Condition"
          helpExpression = ""
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:condition"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('condition',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "AbstractUIComponent_Conception_Group"
        domainClass = "equinoxeDialogue.AbstractUIComponent"
        controls += TextDescription.create[
          name = "AbstractUIComponent_codeAction_Txt"
          labelExpression = "aql:self.getFeatureLabel('codeAction')"
          helpExpression = "El�ment du nom du composant.
          Le nom du CP/CD est construit sur le mod�le [Code Objet Bancaire][Code action]_[Num�ro]"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:codeAction"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('codeAction',newValue)"
            ]
          ]
          style = TextWidgetStyle.create[
            labelFontFormat += org.eclipse.sirius.viewpoint.FontFormat.getByName("bold")
          ]
        ]
        controls += TextDescription.create[
          name = "AbstractUIComponent_numeroSequentiel_Txt"
          labelExpression = "aql:self.getFeatureLabel('numeroSequentiel')"
          helpExpression = "El�ment du nom du composant (facultatif).\nLe nom du CD est construit sur le mod�le [Code Objet Bancaire][Code action]_[Num�ro]"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:numeroSequentiel"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('numeroSequentiel',newValue)"
            ]
          ]
        ]
        controls += CheckboxDescription.create[
          name = "AbstractUIComponent_isDynamic_Check"
          labelExpression = "aql:self.getFeatureLabel('isDynamic')"
          helpExpression = "Indique que le composant est dynamique : il s'interface entre une proc�dure appelante et les sous-proc�dures (composants concrets) que celle-ci doit appeler, d�l�guant les appels de la proc�dure appelante � l'un ou l'autre des composants concrets."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:isDynamic"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('isDynamic',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "AbstractUIRealization_Conception_Group"
        domainClass = "equinoxeDialogue.AbstractUIRealization"
        controls += SelectDescription.create[
          name = "AbstractUIRealization_media_Enum"
          labelExpression = "aql:self.getFeatureLabel('media')"
          helpExpression = "Champ obligatoire, le media utilis� :"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:media"
          candidatesExpression = "aql:equinoxeDialogue::EnumMedia.eLiterals->collect(e|e.instance)"
          candidateDisplayExpression = "aql:candidate.toString()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('media',newValue)"
            ]
          ]
        ]
        controls += SelectDescription.create[
          name = "AbstractUIRealization_canal_Enum"
          labelExpression = "aql:self.getFeatureLabel('canal')"
          helpExpression = "Le canal associ� � la r�alisation.\nLe canal s�lectionn� influe sur les composants graphiques qui peuvent �tre mod�lis�s dans les �crans de la r�alisation.\nValeurs possibles :"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:canal"
          candidatesExpression = "aql:equinoxeDialogue::EnumCanal.eLiterals->collect(e|e.instance)"
          candidateDisplayExpression = "aql:candidate.toString()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('canal',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "AbstractUIRealization_bank_Txt"
          labelExpression = "aql:self.getFeatureLabel('bank')"
          helpExpression = "Le nom de la banque qui introduit une particularit�, � l'origine de cette r�alisation. Dans la plupart des cas, aucune sp�cificit� en terme de rendu des �crans n'est introduite par la banque. En g�n�ral, il ne sera donc pas utile de renseigner ce param�tre.\nExemples :"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:bank"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('bank',newValue)"
            ]
          ]
        ]
        controls += SelectDescription.create[
          name = "AbstractUIRealization_lang_Enum"
          labelExpression = "aql:self.getFeatureLabel('lang')"
          helpExpression = "Code de la langue qui introduit une particularit�, � l'origine de cette r�alisation. Par d�faut, la langue impl�ment�e est le fran�ais. Avant que des d�veloppements n'aient lieu dans une langue diff�rente, il n'est pas n�cessaire de remplir ce s�lecteur."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:lang"
          candidatesExpression = "aql:equinoxeDialogue::EnumLang.eLiterals->collect(e|e.instance)"
          candidateDisplayExpression = "aql:candidate.toString()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('lang',newValue)"
            ]
          ]
        ]
        controls += SelectDescription.create[
          name = "AbstractUIRealization_country_Enum"
          labelExpression = "aql:self.getFeatureLabel('country')"
          helpExpression = "Code du pays qui introduit une particularit�, � l'origine de cette r�alisation. Par d�faut le pays impl�ment� est la France. Avant que des d�veloppements n'aient lieu pour un pays diff�rent, il n'est pas n�cessaire de remplir ce s�lecteur."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:country"
          candidatesExpression = "aql:equinoxeDialogue::EnumCountry.eLiterals->collect(e|e.instance)"
          candidateDisplayExpression = "aql:candidate.toString()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('country',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "AbstractUIRealization_moreSelectors_Txt"
          labelExpression = "aql:self.getFeatureLabel('moreSelectors')"
          helpExpression = "Crit�res suppl�mentaires permettant de cr�er une R�alisation pour un Canal de diffusion tr�s cibl�.\nS�parer les crit�res par un caract�re \"_\"."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:moreSelectors"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('moreSelectors',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "AwaDialogComponent_Conception_Group"
        domainClass = "equinoxeDialogue.AwaDialogComponent"
        controls += TextDescription.create[
          name = "AwaDialogComponent_webAppId_Txt"
          labelExpression = "aql:self.getFeatureLabel('webAppId')"
          helpExpression = "Identifiant de l'application � appeler."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:webAppId"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('webAppId',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "AwaDialogComponent_webAppTaskId_Txt"
          labelExpression = "aql:self.getFeatureLabel('webAppTaskId')"
          helpExpression = "Identifiant de la t�che associ�e."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:webAppTaskId"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('webAppTaskId',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DataPath_Conception_Group"
        domainClass = "equinoxeDialogue.DataPath"
        controls += EqxHyperlinkDescription.create[
          name = "DataPath_segments_Ref"
          labelExpression = "aql:self.getFeatureLabel('segments')"
          helpExpression = "Source of the data.\n This can either be an AbstractFormat (for example the ContextFormat or the ESFormat) or another SourceDataPath. In this case this SourceDataPath is relative to the source DataPath"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "aql:self"
          displayExpression = "aql:value.getDataPathLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectDataInEqxExplorerView()"
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "..."
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.setDataPathSegments()"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Vider"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.clearDataPath()"
                subModelOperations += ChangeContext.create[
                  browseExpression = "aql:self.eqxUnset('source')"
                ]
              ]
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DialogComponent_Generation_Group"
        domainClass = "equinoxeDialogue.DialogComponent"
        controls += CheckboxDescription.create[
          name = "DialogComponent_generateLabels_Check"
          labelExpression = "aql:self.getFeatureLabel('generateLabels')"
          helpExpression = "G�n�ration standard (dont acc�s aux donn�es mod�lis�es)"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:generateLabels"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('generateLabels',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DialogInterface_Conception_Group"
        domainClass = "equinoxeDialogue.DialogInterface"
        controls += EqxHyperlinkDescription.create[
          name = "DialogInterface_formatEs_Ref"
          labelExpression = "aql:self.getFeatureLabel('formatEs')"
          helpExpression = "Format d'entr�e/sortie."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:formatEs"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          style = HyperlinkWidgetStyle.create[
            labelFontFormat += org.eclipse.sirius.viewpoint.FontFormat.getByName("bold")
          ]
          actions += WidgetAction.create[
            labelExpression = "..."
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxSetFromListView('formatEs')"
              ]
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DialogScreen_Conception_Group"
        domainClass = "equinoxeDialogue.DialogScreen"
        controls += EqxHyperlinkDescription.create[
          name = "DialogScreen_fieldToFocus_Ref"
          labelExpression = "aql:self.getFeatureLabel('fieldToFocus')"
          helpExpression = "Zone de donn�e de l'�cran qui re�oit le focus � l'initialisation de la page."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:fieldToFocus"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "..."
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxSetFromTreeView('fieldToFocus')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('fieldToFocus')"
              ]
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "DialogScreen_script_Txt"
          labelExpression = "aql:self.getFeatureLabel('script')"
          helpExpression = "Liste de fichiers Javascript inclus dans cet �cran. Les noms de fichiers (avec chemin relatif si n�cessaire) sont s�par�s par des \";\". Exemple : /ibp/js/fichier1.js;/ibp/js/fichier2.js\nCette liste est r�f�renc�e dans la JSP associ�e � l'�cran."
          isEnabledExpression = "aql:self.isNotReadOnlyElement() and not self.isInInternetContext()"
          valueExpression = "feature:script"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('script',newValue)"
            ]
          ]
        ]
        controls += CheckboxDescription.create[
          name = "DialogScreen_screenFocusStrategy_Check"
          labelExpression = "aql:self.getFeatureLabel('screenFocusStrategy')"
          helpExpression = "Indique qu'il n'y a pas de gestion de focus � l'initialisation de la page. Sinon, le premier champ s�lectionnable de l'�cran re�oit le focus."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:screenFocusStrategy"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('screenFocusStrategy',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DialogScreen_Affichage_Group"
        domainClass = "equinoxeDialogue.DialogScreen"
        controls += TextDescription.create[
          name = "DialogScreen_defaultActionWidth_Txt"
          labelExpression = "aql:self.getFeatureLabel('defaultActionWidth')"
          helpExpression = "La largeur par d�faut appliqu�e � tous les boutons de l'�cran s'ils ne d�finissent pas leur largeur respective."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:defaultActionWidth"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('defaultActionWidth',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "DialogScreen_headerHeight_Txt"
          labelExpression = "aql:self.getFeatureLabel('headerHeight')"
          helpExpression = "La hauteur du bandeau d'ent�te en pixel ou en pourcentage."
          isEnabledExpression = "aql:self.isNotReadOnlyElement() and self.headerType <> equinoxeDialogue::EnumHeaderType::sansBandeau"
          valueExpression = "feature:headerHeight"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('headerHeight',newValue)"
            ]
          ]
        ]
        controls += SelectDescription.create[
          name = "DialogScreen_headerType_Enum"
          labelExpression = "aql:self.getFeatureLabel('headerType')"
          helpExpression = "Type de bandeau d'ent�te utilis�"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:headerType"
          candidatesExpression = "aql:equinoxeDialogue::EnumHeaderType.eLiterals->collect(e|e.instance)"
          candidateDisplayExpression = "aql:candidate.toString()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('headerType',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocAbstractButton_Affichage_Group"
        domainClass = "equinoxeDialogue.DocAbstractButton"
        controls += CustomDescription.create[
          name = "DocAbstractButton_tabIndex_Eqx_Spinner"
          labelExpression = "aql:self.getFeatureLabel('tabIndex')"
          helpExpression = "Ordre de tabulation du composant interactif dans l'�cran. Cet ordre offre un acc�s par touche clavier au champ."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          customExpressions += CustomExpression.create[
            name = "valueExpression"
            customExpression = "feature:tabIndex"
          ]
          customExpressions += CustomExpression.create[
            name = "valueSetter"
            customExpression = "aql:self.eqxPut('tabIndex',newValue)"
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocAbstractClassifiable_Conception_Group"
        domainClass = "equinoxeDialogue.DocAbstractClassifiable"
        controls += CheckboxDescription.create[
          name = "DocAbstractClassifiable_classified_Check"
          labelExpression = "aql:self.getFeatureLabel('classified')"
          helpExpression = "Indique si la colonne est confidentielle. Si tel est le cas, l'�l�ment sera cach� lors de l'activation du mode discret. Disponible sur le canal AGENCE uniquement."
          isEnabledExpression = "aql:self.isNotReadOnlyElement() and not self.isInInternetContext()"
          valueExpression = "feature:classified"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('classified',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocAbstractDisableable_Conception_Group"
        domainClass = "equinoxeDialogue.DocAbstractDisableable"
        controls += CheckboxDescription.create[
          name = "DocAbstractDisableable_disabled_Check"
          labelExpression = "aql:self.getFeatureLabel('disabled')"
          helpExpression = "Flag indiquant si le composant interactif est inactif (\" gris� \") ou non. Un �l�ment rendu inactif interrompt toute interactivit� avec l'utilisateur.Un �l�ment d'�cran peut �tre rendu de nouveau actif par script client, une fois l'�cran pr�sent� � l'utilisateur.Cette capacit� ne doit pas �tre confondue avec celle qui permet d'afficher le champ sous la forme d'un label (mode d'acc�s lecture seule) ou d'un compsoant interactif selon le mode d'acc�s � l'�cran. Un champ rendu inactif doit pouvoir redevenir actif suite � une manipulation particuli�re de la part de l'utilisateur."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:disabled"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('disabled',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocAbstractField_Conception_Group"
        domainClass = "equinoxeDialogue.DocAbstractField"
        controls += EqxHyperlinkDescription.create[
          name = "DocAbstractField_blocCibleDeLaLegende_Ref"
          labelExpression = "aql:self.getFeatureLabel('blocCibleDeLaLegende')"
          helpExpression = "Bloc cible, dans lequel s'affiche la l�gende associ�e � ce champ. Laisser vide pour utiliser le bloc par d�faut : en bas du bloc de niveau 0 de l'�cran.\nDisponible uniquement sur le canal INTERNET."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:blocCibleDeLaLegende"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "..."
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxSetFromTreeView('blocCibleDeLaLegende')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('blocCibleDeLaLegende')"
              ]
            ]
          ]
        ]
        controls += CustomDescription.create[
          name = "DocAbstractField_visibleLines_Eqx_Spinner"
          labelExpression = "aql:self.getFeatureLabel('visibleLines')"
          helpExpression = "nombre de lignes visibles (textBox)"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          customExpressions += CustomExpression.create[
            name = "valueExpression"
            customExpression = "feature:visibleLines"
          ]
          customExpressions += CustomExpression.create[
            name = "valueSetter"
            customExpression = "aql:self.eqxPut('visibleLines',newValue)"
          ]
        ]
        controls += TextDescription.create[
          name = "DocAbstractField_visibleCharacters_Txt"
          labelExpression = "aql:self.getFeatureLabel('visibleCharacters')"
          helpExpression = "Largeur du champ de donn�e en nombre de caract�res"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:visibleCharacters"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('visibleCharacters',newValue)"
            ]
          ]
        ]
        controls += CheckboxDescription.create[
          name = "DocAbstractField_modifOnClient_Check"
          labelExpression = "aql:self.getFeatureLabel('modifOnClient')"
          helpExpression = "Permet d'indiquer au serveur que ce champ peut �tre modifier sur le client"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:modifOnClient"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('modifOnClient',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocAbstractField_Affichage_Group"
        domainClass = "equinoxeDialogue.DocAbstractField"
        controls += CustomDescription.create[
          name = "DocAbstractField_tabIndex_Eqx_Spinner"
          labelExpression = "aql:self.getFeatureLabel('tabIndex')"
          helpExpression = "Ordre de tabulation du composant interactif dans l'�cran. Cet ordre offre un acc�s par touche clavier au champ."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          customExpressions += CustomExpression.create[
            name = "valueExpression"
            customExpression = "feature:tabIndex"
          ]
          customExpressions += CustomExpression.create[
            name = "valueSetter"
            customExpression = "aql:self.eqxPut('tabIndex',newValue)"
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocAbstractHideable_Conception_Group"
        domainClass = "equinoxeDialogue.DocAbstractHideable"
        controls += CheckboxDescription.create[
          name = "DocAbstractHideable_visible_Check"
          labelExpression = "aql:self.getFeatureLabel('visible')"
          helpExpression = "Indique si la colonne est visible ou non lors de la pr�sentation de l'�cran � l'utilisateur."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:visible"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('visible',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocAbstractHigh_Affichage_Group"
        domainClass = "equinoxeDialogue.DocAbstractHigh"
        controls += TextDescription.create[
          name = "DocAbstractHigh_height_Txt"
          labelExpression = "aql:self.getFeatureLabel('height')"
          helpExpression = "Hauteur allou�e � la zone d'assistance."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:height"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('height',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocAbstractLabeled_Affichage_Group"
        domainClass = "equinoxeDialogue.DocAbstractLabeled"
        controls += EqxHyperlinkDescription.create[
          name = "DocAbstractLabeled_labelAlign_Ref"
          labelExpression = "aql:self.getFeatureLabel('labelAlign')"
          helpExpression = "Politique d'alignement des �tiquettes des champs de la colonne"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:labelAlign"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "..."
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxSetFromListView('labelAlign')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('labelAlign')"
              ]
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "DocAbstractLabeled_labelWidth_Txt"
          labelExpression = "aql:self.getFeatureLabel('labelWidth')"
          helpExpression = "Largeur occup�e par les �tiquettes de champs dans les cellules de cet �l�ment de pr�sentation"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:labelWidth"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('labelWidth',newValue)"
            ]
          ]
        ]
        controls += EqxHyperlinkDescription.create[
          name = "DocAbstractLabeled_seContentAlign_Ref"
          labelExpression = "aql:self.getFeatureLabel('seContentAlign')"
          helpExpression = "Alignement � appliquer par d�faut � tous les widgets"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:seContentAlign"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "..."
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxSetFromListView('seContentAlign')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('seContentAlign')"
              ]
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocAbstractMessage_Affichage_Group"
        domainClass = "equinoxeDialogue.DocAbstractMessage"
        controls += TextDescription.create[
          name = "DocAbstractMessage_nbVisibleChars_Txt"
          labelExpression = "aql:self.getFeatureLabel('nbVisibleChars')"
          helpExpression = "Longueur maximum du message � afficher. Si le message est plus long que width, il sera tronqu� et des points de suspension permettront d'indiquer que la valeur compl�te sera visible en info-bulle\n"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:nbVisibleChars"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('nbVisibleChars',newValue)"
            ]
          ]
        ]
        controls += SelectDescription.create[
          name = "DocAbstractMessage_style_Enum"
          labelExpression = "aql:self.getFeatureLabel('style')"
          helpExpression = "Style du texte affich�"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:style"
          candidatesExpression = "aql:equinoxeDialogue::EnumMsgStyle.eLiterals->collect(e|e.instance)"
          candidateDisplayExpression = "aql:candidate.toString()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('style',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocAbstractTable_Conception_Group"
        domainClass = "equinoxeDialogue.DocAbstractTable"
        controls += CheckboxDescription.create[
          name = "DocAbstractTable_disableSelectionPredicate_Check"
          labelExpression = "aql:self.getFeatureLabel('disableSelectionPredicate')"
          helpExpression = "Indique la prise en compte d'un pr�dicat permettant la d�sactivation de la s�lection de certaines lignes de tableau. Le pr�dicat doit renvoyer true si l'on d�sire d�sactiver la s�lection d'une ligne donn�e.\nLe code du pr�dicat sera �crit en Java entre balises utilisateur dans une m�thode d�di�e au pr�dicat."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:disableSelectionPredicate"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('disableSelectionPredicate',newValue)"
            ]
          ]
        ]
        controls += SelectDescription.create[
          name = "DocAbstractTable_selectionMode_Enum"
          labelExpression = "aql:self.getFeatureLabel('selectionMode')"
          helpExpression = "Mode de s�lection des lignes du tableau :"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:selectionMode"
          candidatesExpression = "aql:equinoxeDialogue::EnumSelectionMode.eLiterals->collect(e|e.instance)"
          candidateDisplayExpression = "aql:candidate.toString()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('selectionMode',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocAbstractTable_Affichage_Group"
        domainClass = "equinoxeDialogue.DocAbstractTable"
        controls += EqxHyperlinkDescription.create[
          name = "DocAbstractTable_verticalAlign_Ref"
          labelExpression = "aql:self.getFeatureLabel('verticalAlign')"
          helpExpression = "Alignement vertical des cellules du tableau :"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:verticalAlign"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "..."
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxSetFromListView('verticalAlign')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('verticalAlign')"
              ]
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocAbstractTableColumn_Conception_Group"
        domainClass = "equinoxeDialogue.DocAbstractTableColumn"
        controls += CheckboxDescription.create[
          name = "DocAbstractTableColumn_isMonoUnit_Check"
          labelExpression = "aql:self.getFeatureLabel('isMonoUnit')"
          helpExpression = "Indique si les valeurs affich�es dans la colonne du tableau sont mono unit�s :\n Si true affichage entre parenth�se de l'unit� (dans le titre du tableau)\n Si non sp�cifi� (ou false) pas de traitement particulier de l'ent�te de colonne.\n"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:isMonoUnit"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('isMonoUnit',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocAbstractTableColumn_Affichage_Group"
        domainClass = "equinoxeDialogue.DocAbstractTableColumn"
        controls += EqxHyperlinkDescription.create[
          name = "DocAbstractTableColumn_contentAlign_Ref"
          labelExpression = "aql:self.getFeatureLabel('contentAlign')"
          helpExpression = "L'alignement du titre de l'�l�ment colonne."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:contentAlign"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "..."
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxSetFromListView('contentAlign')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('contentAlign')"
              ]
            ]
          ]
        ]
        controls += EqxHyperlinkDescription.create[
          name = "DocAbstractTableColumn_titleAlign_Ref"
          labelExpression = "aql:self.getFeatureLabel('titleAlign')"
          helpExpression = "L'alignement du titre de la colonne :"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:titleAlign"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "..."
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxSetFromListView('titleAlign')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('titleAlign')"
              ]
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocAbstractTableFooterCell_Affichage_Group"
        domainClass = "equinoxeDialogue.DocAbstractTableFooterCell"
        controls += EqxHyperlinkDescription.create[
          name = "DocAbstractTableFooterCell_align_Ref"
          labelExpression = "aql:self.getFeatureLabel('align')"
          helpExpression = "Alignement du pied de colonne :"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:align"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "..."
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxSetFromListView('align')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('align')"
              ]
            ]
          ]
        ]
        controls += SelectDescription.create[
          name = "DocAbstractTableFooterCell_style_Enum"
          labelExpression = "aql:self.getFeatureLabel('style')"
          helpExpression = "Style du pied de colonne :"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:style"
          candidatesExpression = "aql:equinoxeDialogue::EnumFooterCellStyle.eLiterals->collect(e|e.instance)"
          candidateDisplayExpression = "aql:candidate.toString()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('style',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocAbstractWide_Affichage_Group"
        domainClass = "equinoxeDialogue.DocAbstractWide"
        controls += TextDescription.create[
          name = "DocAbstractWide_width_Txt"
          labelExpression = "aql:self.getFeatureLabel('width')"
          helpExpression = "La largeur de la colonne en pixel ou en pourcentage par rapport � la largeur du tableau (ex : 80% : dans ce cas, la somme totale des colonnes d'un tableau doit �tre �gale � 100%)."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:width"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('width',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocAction_Conception_Group"
        domainClass = "equinoxeDialogue.DocAction"
        controls += CheckboxDescription.create[
          name = "DocAction_checkAlerts_Check"
          labelExpression = "aql:self.getFeatureLabel('checkAlerts')"
          helpExpression = "Indique si l'action d�clenche les contr�les et l'affichage des messages d'alerte de fin de PF."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:checkAlerts"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('checkAlerts',newValue)"
            ]
          ]
        ]
        controls += CheckboxDescription.create[
          name = "DocAction_refreshAjaxSc_Check"
          labelExpression = "aql:self.getFeatureLabel('refreshAjaxSc')"
          helpExpression = "Indique que lors de son d�clenchement, le bouton d'action ex�cute les �ventuelles screen commands d�finies dans le mod�le d'�cran sans pour autant rafra�chir l'ensemble des composants de la page."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:refreshAjaxSc"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('refreshAjaxSc',newValue)"
            ]
          ]
        ]
        controls += CheckboxDescription.create[
          name = "DocAction_default_Check"
          labelExpression = "aql:self.getFeatureLabel('default')"
          helpExpression = "Flag indiquant si la touche return active ce composant d'action"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:default"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('default',newValue)"
            ]
          ]
        ]
        controls += SelectDescription.create[
          name = "DocAction_validationStrategy_Enum"
          labelExpression = "aql:self.getFeatureLabel('validationStrategy')"
          helpExpression = "Indique la strat�gie de validation des donn�es captur�es dans l'�cran, sur le d�clenchement de l'action."
          isEnabledExpression = "aql:self.isNotReadOnlyElement() and not self.isCancelAction()"
          valueExpression = "feature:validationStrategy"
          candidatesExpression = "aql:equinoxeDialogue::EnumValidationStrategy.eLiterals->collect(e|e.instance)"
          candidateDisplayExpression = "aql:candidate.toString()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('validationStrategy',newValue)"
            ]
          ]
        ]
        controls += EqxHyperlinkDescription.create[
          name = "DocAction_dialogAction_Ref"
          labelExpression = "aql:self.getFeatureLabel('dialogAction')"
          helpExpression = "Le nom de l'�v�nement PAF permettant de d�clencher une transition de carte de Dialogue/Proc�dure.\nSont disponibles les actions standard de l'�cran, les actions de dialogue et les actions de fin de dialogue.\nA laisser vide pour que le bouton d'action fasse office d'�v�nement (en conservant le m�me rendu)."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:dialogAction"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "..."
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxSetFromListView('dialogAction')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('dialogAction')"
              ]
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "DocAction_confirmFunction_Txt"
          labelExpression = "aql:self.getFeatureLabel('confirmFunction')"
          helpExpression = "Si ce bouton d�clenche un message de confirmation, nom de la fonction qui conditionne l'affichage du message de confirmation."
          isEnabledExpression = "aql:self.isNotReadOnlyElement() and self.confirmation != null"
          valueExpression = "feature:confirmFunction"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('confirmFunction',newValue)"
            ]
          ]
        ]
        controls += SelectDescription.create[
          name = "DocAction_type_Enum"
          labelExpression = "aql:self.getFeatureLabel('type')"
          helpExpression = "Sur le canal INTERNET uniquement : type de bouton, qui permet de modifier sa repr�sentation graphique :"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:type"
          candidatesExpression = "aql:equinoxeDialogue::EnumTypeBouton.eLiterals->collect(e|e.instance)"
          candidateDisplayExpression = "aql:candidate.toString()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('type',newValue)"
            ]
          ]
        ]
        controls += ListDescription.create[
          name = "DocAction_widgetsARafraichirIntranet_Ref"
          labelExpression = "aql:self.getFeatureLabel('widgetsARafraichirIntranet')"
          helpExpression = "Liste des �l�ments d'�cran � rafra�chir lors du d�clenchement de l'action.\nCette capacit� n'a de sens que lorsque l'�v�nement PAF associ� retourne le m�me �cran.\nDisponible uniquement sur le canal AGENCE."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:widgetsARafraichirIntranet"
          displayExpression = "aql:value.getEqxLabel()"
          onClickOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerViewDoubleClick(onClickEventKind)"
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Ajouter"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxAddFromTreeView('widgetsARafraichirIntranet',true)"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxRemove('widgetsARafraichirIntranet',selection)"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Monter"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.performMoveCommandUp('widgetsARafraichirIntranet',selection)"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Descendre"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.performMoveCommandDown('widgetsARafraichirIntranet',selection)"
              ]
            ]
          ]
        ]
        controls += CheckboxDescription.create[
          name = "DocAction_withConfirmation_Check"
          labelExpression = "aql:self.getFeatureLabel('withConfirmation')"
          helpExpression = "Indique si ce bouton d�clenche un message de confirmation, dans ce cas il faut renseigner le sous-objet MessageKey \"confirmation\" avec le message de confirmation que l'on veut afficher."
          isEnabledExpression = "aql:false"
          valueExpression = "feature:withConfirmation"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('withConfirmation',newValue)"
            ]
          ]
          style = CheckboxWidgetStyle.create[
            labelFontFormat += org.eclipse.sirius.viewpoint.FontFormat.getByName("italic")
            labelForegroundColor = (extras.get("Color#gray") as SystemColor)
          ]
        ]
        controls += CheckboxDescription.create[
          name = "DocAction_withImage_Check"
          labelExpression = "aql:self.getFeatureLabel('withImage')"
          helpExpression = "Indique si une image est associ�e � ce bouton d'action. Dans ce cas, il faut renseigner le sous-objet MessageKey \"image\" avec la cl� d'internationalisation de l'URI sp�cifiant la source de l'image ins�r�e."
          isEnabledExpression = "aql:false"
          valueExpression = "feature:withImage"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('withImage',newValue)"
            ]
          ]
          style = CheckboxWidgetStyle.create[
            labelFontFormat += org.eclipse.sirius.viewpoint.FontFormat.getByName("italic")
            labelForegroundColor = (extras.get("Color#gray") as SystemColor)
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocAction_Affichage_Group"
        domainClass = "equinoxeDialogue.DocAction"
        controls += TextDescription.create[
          name = "DocAction_buttonWidth_Txt"
          labelExpression = "aql:self.getFeatureLabel('buttonWidth')"
          helpExpression = "Largeur du bouton en pixel (si non pr�cis�e la taille utilis�e est celle pr�cis�e au niveau de l'�cran \"Largeur par d�faut des boutons\")"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:buttonWidth"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('buttonWidth',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocBannerModel_Affichage_Group"
        domainClass = "equinoxeDialogue.DocBannerModel"
        controls += EqxHyperlinkDescription.create[
          name = "DocBannerModel_position_Ref"
          labelExpression = "aql:self.getFeatureLabel('position')"
          helpExpression = ""
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:position"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "..."
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxSetFromListView('position')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('position')"
              ]
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocBloc_Affichage_Group"
        domainClass = "equinoxeDialogue.DocBloc"
        controls += SelectDescription.create[
          name = "DocBloc_style_Enum"
          labelExpression = "aql:self.getFeatureLabel('style')"
          helpExpression = "Le style graphique du bloc de donn�e."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:style"
          candidatesExpression = "aql:equinoxeDialogue::EnumStyleBloc.eLiterals->collect(e|e.instance)"
          candidateDisplayExpression = "aql:candidate.toString()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('style',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "DocAbstractHigh_height_DocBloc_Txt"
          labelExpression = "aql:self.getFeatureLabel('height')"
          helpExpression = "Hauteur allou�e � la zone d'assistance."
          isEnabledExpression = "aql:self.isNotReadOnlyElement() and self.isInInternetContext() and (self.style = equinoxeDialogue::EnumStyleBloc::blocLevel1 or self.style =equinoxeDialogue::EnumStyleBloc::blocLevel2)"
          valueExpression = "feature:height"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('height',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocButtonGroup_Affichage_Group"
        domainClass = "equinoxeDialogue.DocButtonGroup"
        controls += TextDescription.create[
          name = "DocButtonGroup_buttonWidth_Txt"
          labelExpression = "aql:self.getFeatureLabel('buttonWidth')"
          helpExpression = "Largeur du bouton en pixel (si non pr�cis�e la taille utilis�e est celle pr�cis�e au niveau de l'�cran \"Largeur par d�faut des boutons\")."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:buttonWidth"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('buttonWidth',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "DocButtonGroup_groupWidth_Txt"
          labelExpression = "aql:self.getFeatureLabel('groupWidth')"
          helpExpression = "Largeur du groupe d'actions en pixel (c'est-�-dire de la layer portant la liste des actions)."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:groupWidth"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('groupWidth',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocCodeFilter_Conception_Group"
        domainClass = "equinoxeDialogue.DocCodeFilter"
        controls += EqxHyperlinkDescription.create[
          name = "DocCodeFilter_cboAttribute_Ref"
          labelExpression = "aql:self.getFeatureLabel('cboAttribute')"
          helpExpression = "L'attribut du CBO sur lequel le filtre s'applique."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:cboAttribute"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          style = HyperlinkWidgetStyle.create[
            labelFontFormat += org.eclipse.sirius.viewpoint.FontFormat.getByName("bold")
          ]
          actions += WidgetAction.create[
            labelExpression = "..."
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxSetFromListView('cboAttribute')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('cboAttribute')"
              ]
            ]
          ]
        ]
        controls += EqxHyperlinkDescription.create[
          name = "DocCodeFilter_filterCriteria_Ref"
          labelExpression = "aql:self.getFeatureLabel('filterCriteria')"
          helpExpression = "Le crit�re utilis� par ce filtre, s�lectionn� parmi les crit�res d�finis sur l'Objet Filtre."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:filterCriteria"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          style = HyperlinkWidgetStyle.create[
            labelFontFormat += org.eclipse.sirius.viewpoint.FontFormat.getByName("bold")
          ]
          actions += WidgetAction.create[
            labelExpression = "..."
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxSetFromTreeView('filterCriteria')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('filterCriteria')"
              ]
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocColumn_Affichage_Group"
        domainClass = "equinoxeDialogue.DocColumn"
        controls += CheckboxDescription.create[
          name = "DocColumn_forceDefaultHeight_Check"
          labelExpression = "aql:self.getFeatureLabel('forceDefaultHeight')"
          helpExpression = "Sp�cifie si les widget doivent respecter une hauteur standard (pour des question d'alignement).\n"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:forceDefaultHeight"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('forceDefaultHeight',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocCompositeField_Conception_Group"
        domainClass = "equinoxeDialogue.DocCompositeField"
        controls += CheckboxDescription.create[
          name = "DocCompositeField_withAutoTab_Check"
          labelExpression = "aql:self.getFeatureLabel('withAutoTab')"
          helpExpression = "Indique l'activation de la tabulation automatique : lorsque la taille maximale de la saisie est atteinte, tabule automatiquement sur le champ suivant."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:withAutoTab"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('withAutoTab',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocConfirmationModel_Conception_Group"
        domainClass = "equinoxeDialogue.DocConfirmationModel"
        controls += EqxHyperlinkDescription.create[
          name = "DocConfirmationModel_noAction_Ref"
          labelExpression = "aql:self.getFeatureLabel('noAction')"
          helpExpression = "Ev�nement PAF d�clench� sur l'activation du bouton NON de la popup de confirmation. Utiliser 'Aucune action' pour ne d�clencher aucun �v�nement pour ce bouton."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:noAction"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "..."
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxSetFromListView('noAction')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Aucune action"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('noAction')"
              ]
            ]
          ]
        ]
        controls += EqxHyperlinkDescription.create[
          name = "DocConfirmationModel_yesAction_Ref"
          labelExpression = "aql:self.getFeatureLabel('yesAction')"
          helpExpression = "Ev�nement PAF d�clench� sur l'activation du bouton OUI de la popup de confirmation. Utiliser 'Aucune action' pour ne d�clencher aucun �v�nement pour ce bouton."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:yesAction"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "..."
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxSetFromListView('yesAction')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Aucune action"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('yesAction')"
              ]
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocConversionRule_Conception_Group"
        domainClass = "equinoxeDialogue.DocConversionRule"
        controls += EqxHyperlinkDescription.create[
          name = "DocConversionRule_rule_Ref"
          labelExpression = "aql:self.getFeatureLabel('rule')"
          helpExpression = "Nom du convertisseur � appliquer (d�fini sur le type de la donn�e cibl�e). "
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:rule"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          style = HyperlinkWidgetStyle.create[
            labelFontFormat += org.eclipse.sirius.viewpoint.FontFormat.getByName("bold")
          ]
          actions += WidgetAction.create[
            labelExpression = "..."
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxSetFromListView('rule')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('rule')"
              ]
            ]
          ]
        ]
        controls += EqxHyperlinkDescription.create[
          name = "DocConversionRule_patternKey_Ref"
          labelExpression = "aql:self.getFeatureLabel('patternKey')"
          helpExpression = "Nom du patron de formatage � appliquer (patternKey). Il est d�fini sur le type de la donn�e cibl�e. "
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:patternKey"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "..."
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxSetFromListView('patternKey')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('patternKey')"
              ]
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocCrAttribute_Conception_Group"
        domainClass = "equinoxeDialogue.DocCrAttribute"
        controls += EqxHyperlinkDescription.create[
          name = "DocCrAttribute_dynamicAttribute_Ref"
          labelExpression = "aql:self.getFeatureLabel('dynamicAttribute')"
          helpExpression = "L'attribut dynamique du convertisseur r�f�rence par l'attribut."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:dynamicAttribute"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          style = HyperlinkWidgetStyle.create[
            labelFontFormat += org.eclipse.sirius.viewpoint.FontFormat.getByName("bold")
          ]
          actions += WidgetAction.create[
            labelExpression = "..."
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxSetFromListView('dynamicAttribute')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('dynamicAttribute')"
              ]
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocCrAttributeProperty_Conception_Group"
        domainClass = "equinoxeDialogue.DocCrAttributeProperty"
        controls += TextDescription.create[
          name = "DocCrAttributeProperty_propertyName_Txt"
          labelExpression = "aql:self.getFeatureLabel('propertyName')"
          helpExpression = "Nom de la propri�t� de CBO.\n \n <nomAttribut> : si Utilisation d'une constante est False\n <nom interface>.<nom de constante> : si Utilisation d'une constante est True\n"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:propertyName"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('propertyName',newValue)"
            ]
          ]
          style = TextWidgetStyle.create[
            labelFontFormat += org.eclipse.sirius.viewpoint.FontFormat.getByName("bold")
          ]
        ]
        controls += CheckboxDescription.create[
          name = "DocCrAttributeProperty_valueIsConstant_Check"
          labelExpression = "aql:self.getFeatureLabel('valueIsConstant')"
          helpExpression = "Pr�cise si le nom de la propri�t� est directement saisie dans l'assistant ou si la saisie correspond � une constante (<nom interface>.<nom de constante>) d�finissant le nom de cette propri�t�."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:valueIsConstant"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('valueIsConstant',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocCrAttributeRule_Conception_Group"
        domainClass = "equinoxeDialogue.DocCrAttributeRule"
        controls += TextDescription.create[
          name = "DocCrAttributeRule_conversionPattern_Txt"
          labelExpression = "aql:self.getFeatureLabel('conversionPattern')"
          helpExpression = "Le nom du patron de conversion : utiliser la syntaxe <nom interface>.<nom de constante>.\nEx : DefaultPattern.LOWERCASE"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:conversionPattern"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('conversionPattern',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "DocCrAttributeRule_conversionRule_Txt"
          labelExpression = "aql:self.getFeatureLabel('conversionRule')"
          helpExpression = "Le nom du convertisseur : utiliser la syntaxe <nom interface>.<nom de constante>.\nEx : DefaultConverter.STRING"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:conversionRule"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('conversionRule',newValue)"
            ]
          ]
          style = TextWidgetStyle.create[
            labelFontFormat += org.eclipse.sirius.viewpoint.FontFormat.getByName("bold")
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocCrAttributeStatic_Conception_Group"
        domainClass = "equinoxeDialogue.DocCrAttributeStatic"
        controls += TextDescription.create[
          name = "DocCrAttributeStatic_staticValue_Txt"
          labelExpression = "aql:self.getFeatureLabel('staticValue')"
          helpExpression = "Valeur statique de l'attribut."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:staticValue"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('staticValue',newValue)"
            ]
          ]
          style = TextWidgetStyle.create[
            labelFontFormat += org.eclipse.sirius.viewpoint.FontFormat.getByName("bold")
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocDisplayModeC_Conception_Group"
        domainClass = "equinoxeDialogue.DocDisplayModeC"
        controls += EqxHyperlinkDescription.create[
          name = "DocDisplayModeC_screenDisplayMode_Ref"
          labelExpression = "aql:self.getFeatureLabel('screenDisplayMode')"
          helpExpression = "3 modes d'affichage disponibles: CREATE pour une cr�ation de nouvelles donn�es, UPDATE pour une de mise � jour, et INSPECT pour la consultation de donn�es existantes"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:screenDisplayMode"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          style = HyperlinkWidgetStyle.create[
            labelFontFormat += org.eclipse.sirius.viewpoint.FontFormat.getByName("bold")
          ]
          actions += WidgetAction.create[
            labelExpression = "..."
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxSetFromListView('screenDisplayMode')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('screenDisplayMode')"
              ]
            ]
          ]
        ]
        controls += EqxHyperlinkDescription.create[
          name = "DocDisplayModeC_widgetDisplayMode_Internet_Ref"
          labelExpression = "aql:self.getFeatureLabel('widgetDisplayMode')"
          helpExpression = "Le mode d'affichage du widget peut �tre l'un des modes pr�d�finis: EDIT, INSPECT, INVISIBLE ou HIDDEN, ou bien �tre un mode contextuel. Dans ce dernier cas le mode est port� par la donn�e d�finie sur le mode d'affichage contextuel."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:widgetDisplayMode"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "..."
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.setWidgetDisplayModeInInternetContext()"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Mode Contextuel"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.useDisplayModeContextualValue()"
              ]
            ]
          ]
        ]
        controls += EqxHyperlinkDescription.create[
          name = "DocDisplayModeC_widgetDisplayMode_Agence_Ref"
          labelExpression = "aql:self.getFeatureLabel('widgetDisplayMode')"
          helpExpression = "Le mode d'affichage du widget peut �tre l'un des modes pr�d�finis: EDIT, INSPECT, INVISIBLE ou HIDDEN"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:widgetDisplayMode"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "..."
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxSetFromListView('widgetDisplayMode')"
              ]
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocDocViewer_Conception_Group"
        domainClass = "equinoxeDialogue.DocDocViewer"
        controls += EqxHyperlinkDescription.create[
          name = "DocDocViewer_docType_Ref"
          labelExpression = "aql:self.getFeatureLabel('docType')"
          helpExpression = "Type de document affich� :"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:docType"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          style = HyperlinkWidgetStyle.create[
            labelFontFormat += org.eclipse.sirius.viewpoint.FontFormat.getByName("bold")
          ]
          actions += WidgetAction.create[
            labelExpression = "..."
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxSetFromListView('docType')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('docType')"
              ]
            ]
          ]
        ]
        controls += EqxHyperlinkDescription.create[
          name = "DocDocViewer_source_Ref"
          labelExpression = "aql:self.getFeatureLabel('source')"
          helpExpression = "Origine du document � afficher :"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:source"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          style = HyperlinkWidgetStyle.create[
            labelFontFormat += org.eclipse.sirius.viewpoint.FontFormat.getByName("bold")
          ]
          actions += WidgetAction.create[
            labelExpression = "..."
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxSetFromListView('source')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('source')"
              ]
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocElement_Conception_Group"
        domainClass = "equinoxeDialogue.DocElement"
        controls += TextDescription.create[
          name = "DocElement_shortId_Txt"
          labelExpression = "aql:self.getFeatureLabel('shortId')"
          helpExpression = "Identifiant du widget. Unique au sein de la page du composant graphique."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:shortId"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('shortId',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocElement_Documentation_Group"
        domainClass = "equinoxeDialogue.DocElement"
        controls += TextDescription.create[
          name = "DocElement_dmxId_Txt"
          labelExpression = "aql:self.getFeatureLabel('dmxId')"
          helpExpression = ""
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:dmxId"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('dmxId',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocEvent_Conception_Group"
        domainClass = "equinoxeDialogue.DocEvent"
        controls += EqxHyperlinkDescription.create[
          name = "DocEvent_event_Ref"
          labelExpression = "aql:self.getFeatureLabel('event')"
          helpExpression = ""
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:event"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          style = HyperlinkWidgetStyle.create[
            labelFontFormat += org.eclipse.sirius.viewpoint.FontFormat.getByName("bold")
          ]
          actions += WidgetAction.create[
            labelExpression = "..."
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxSetFromListView('event')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('event')"
              ]
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "DocEvent_functionCall_Txt"
          labelExpression = "aql:self.getFeatureLabel('functionCall')"
          helpExpression = "Le nom de la fonction Javascript d�clench�e par cet �v�nement."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:functionCall"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('functionCall',newValue)"
            ]
          ]
        ]
        controls += SelectDescription.create[
          name = "DocEvent_process_Enum"
          labelExpression = "aql:self.getFeatureLabel('process')"
          helpExpression = "Permet de sp�cifier si la fonction Javascript d�clench�e par cet �v�nement doit �tre ex�cut�e :\n"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:process"
          candidatesExpression = "aql:equinoxeDialogue::EnumEventProcess.eLiterals->collect(e|e.instance)"
          candidateDisplayExpression = "aql:candidate.toString()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('process',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocField_Conception_Group"
        domainClass = "equinoxeDialogue.DocField"
        controls += CheckboxDescription.create[
          name = "DocField_isPassword_Check"
          labelExpression = "aql:self.getFeatureLabel('isPassword')"
          helpExpression = "Indique que la saisie est masqu�e (comme dans le cas d'une mot de passe)."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:isPassword"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('isPassword',newValue)"
            ]
          ]
        ]
        controls += CheckboxDescription.create[
          name = "DocField_withAutoTab_Check"
          labelExpression = "aql:self.getFeatureLabel('withAutoTab')"
          helpExpression = "Indique l'activation de la tabulation automatique : lorsque la taille maximale de la saisie est atteinte, tabule automatiquement sur le champ suivant."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:withAutoTab"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('withAutoTab',newValue)"
            ]
          ]
        ]
        controls += CheckboxDescription.create[
          name = "DocField_withInputWizard_Check"
          labelExpression = "aql:self.getFeatureLabel('withInputWizard')"
          helpExpression = "Pour le canal Agence uniquement : indique qu'un assistant permet de saisir la donn�e � afficher/capturer sur la zone de donn�e."
          isEnabledExpression = "aql:false"
          valueExpression = "feature:withInputWizard"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('withInputWizard',newValue)"
            ]
          ]
          style = CheckboxWidgetStyle.create[
            labelFontFormat += org.eclipse.sirius.viewpoint.FontFormat.getByName("italic")
            labelForegroundColor = (extras.get("Color#gray") as SystemColor)
          ]
        ]
        controls += TextDescription.create[
          name = "DocField_pivot_Txt"
          labelExpression = "aql:self.getFeatureLabel('pivot')"
          helpExpression = "Si le label correspond � un champ de saisie de date et que \"Couleur en fonction de la valeur\" est coch�, permet d'indiquer si la date doit �tre affich�e avec une couleur sp�cifique selon qu'elle est ant�rieure ou post�rieure � la date pivot pr�cis�e (uniquement en mode INSPECT).\nSi la valeur est laiss�e vide, la date pivot est la date courante."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:pivot"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('pivot',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocGrid_Conception_Group"
        domainClass = "equinoxeDialogue.DocGrid"
        controls += CustomDescription.create[
          name = "DocGrid_cols_Eqx_Spinner"
          labelExpression = "aql:self.getFeatureLabel('cols')"
          helpExpression = "Nombre de colonnes de la grille"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          customExpressions += CustomExpression.create[
            name = "valueExpression"
            customExpression = "feature:cols"
          ]
          customExpressions += CustomExpression.create[
            name = "valueSetter"
            customExpression = "aql:self.eqxPut('cols',newValue)"
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocGrid_Affichage_Group"
        domainClass = "equinoxeDialogue.DocGrid"
        controls += CheckboxDescription.create[
          name = "DocGrid_forceDefaultHeight_Check"
          labelExpression = "aql:self.getFeatureLabel('forceDefaultHeight')"
          helpExpression = "Sp�cifie si les widget doivent respecter une hauteur standard (pour des question d'alignement).\n"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:forceDefaultHeight"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('forceDefaultHeight',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocInfoBloc_Conception_Group"
        domainClass = "equinoxeDialogue.DocInfoBloc"
        controls += CheckboxDescription.create[
          name = "DocInfoBloc_specificJsp_Check"
          labelExpression = "aql:self.getFeatureLabel('specificJsp')"
          helpExpression = "Indique si le bloc correspond � une unit� de d�coupage JSP : le bloc est alors d�fini au sein d'une JSP s�par�e."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:specificJsp"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('specificJsp',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocInputWizard_Conception_Group"
        domainClass = "equinoxeDialogue.DocInputWizard"
        controls += TextDescription.create[
          name = "DocInputWizard_taskOid_Txt"
          labelExpression = "aql:self.getFeatureLabel('taskOid')"
          helpExpression = "Identifiant de la t�che(proc�dure) g�rant l'assistance � la saisie."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:taskOid"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('taskOid',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocLabel_Conception_Group"
        domainClass = "equinoxeDialogue.DocLabel"
        controls += SelectDescription.create[
          name = "DocLabel_realisation_Enum"
          labelExpression = "aql:self.getFeatureLabel('realisation')"
          helpExpression = ""
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:realisation"
          candidatesExpression = "aql:equinoxeDialogue::EnumFieldRealisation.eLiterals->collect(e|e.instance)"
          candidateDisplayExpression = "aql:candidate.toString()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('realisation',newValue)"
            ]
          ]
        ]
        controls += EqxHyperlinkDescription.create[
          name = "DocLabel_cboAttribute_Ref"
          labelExpression = "aql:self.getFeatureLabel('cboAttribute')"
          helpExpression = "L'attribut de CBO qui sera utilis� par ce widget. Utilisable uniquement si la donn�e est de type CBO."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:cboAttribute"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "..."
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxSetFromListView('cboAttribute')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('cboAttribute')"
              ]
            ]
          ]
        ]
        controls += CustomDescription.create[
          name = "DocLabel_cols_Eqx_Spinner"
          labelExpression = "aql:self.getFeatureLabel('cols')"
          helpExpression = "Nombre de colonnes visibles (r�alisation textBox uniquement)"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          customExpressions += CustomExpression.create[
            name = "valueExpression"
            customExpression = "feature:cols"
          ]
          customExpressions += CustomExpression.create[
            name = "valueSetter"
            customExpression = "aql:self.eqxPut('cols',newValue)"
          ]
        ]
        controls += CheckboxDescription.create[
          name = "DocLabel_useColorRange_Check"
          labelExpression = "aql:self.getFeatureLabel('useColorRange')"
          helpExpression = "Applique une couleur en fonction de la valeur affich�e. Les couleurs sont sp�cifi�es dans le param�trage pour des plages de valeurs."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:useColorRange"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('useColorRange',newValue)"
            ]
          ]
        ]
        controls += SelectDescription.create[
          name = "DocLabel_unitDisplayMode_Enum"
          labelExpression = "aql:self.getFeatureLabel('unitDisplayMode')"
          helpExpression = "Si le label correspond � un champ de saisie de nombre, permet de sp�cifier le mode d'acc�s � la zone dynamique repr�sentant l'unit� associ�e au nombre, lorsque le champ est en mode d'acc�s EDIT.\nLe mode d'acc�s est par d�faut INSPECT (label par d�faut).\nSi l'unit� est modifiable, elle le sera au travers d'une liste d�roulante contenant toutes les valeurs du CodeObject sp�cifi� dans l'unit� du CBO. \n"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:unitDisplayMode"
          candidatesExpression = "aql:equinoxeDialogue::EnumFieldDisplayMode.eLiterals->collect(e|e.instance)"
          candidateDisplayExpression = "aql:candidate.toString()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('unitDisplayMode',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocList_Conception_Group"
        domainClass = "equinoxeDialogue.DocList"
        controls += CheckboxDescription.create[
          name = "DocList_areRadioButtonsDynamicallyDeactivated_Check"
          labelExpression = "aql:self.getFeatureLabel('areRadioButtonsDynamicallyDeactivated')"
          helpExpression = "Si une repr�sentation graphique sous forme de boutons radio est sp�cifi�e pour la liste, indique l'activation de la capacit� de d�sactiver les radios boutons dynamiquement au chargement de l'�cran."
          isEnabledExpression = "aql:self.isNotReadOnlyElement() and self.realisation = equinoxeDialogue::EnumListRealisation::radios"
          valueExpression = "feature:areRadioButtonsDynamicallyDeactivated"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('areRadioButtonsDynamicallyDeactivated',newValue)"
            ]
          ]
        ]
        controls += SelectDescription.create[
          name = "DocList_conversionRulePerimeter_Enum"
          labelExpression = "aql:self.getFeatureLabel('conversionRulePerimeter')"
          helpExpression = "P�rim�tre de la r�gle de conversion :"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:conversionRulePerimeter"
          candidatesExpression = "aql:equinoxeDialogue::EnumListRgConvPerimeter.eLiterals->collect(e|e.instance)"
          candidateDisplayExpression = "aql:candidate.toString()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('conversionRulePerimeter',newValue)"
            ]
          ]
        ]
        controls += CheckboxDescription.create[
          name = "DocList_isActionList_Check"
          labelExpression = "aql:self.getFeatureLabel('isActionList')"
          helpExpression = "Indique que la liste repr�sente une liste d'actions : quand une valeur est s�lectionn�e, ex�cute l'action correspondant � la s�lection.\nDans ce cas :\nSous donn�e, indiquer un ActionFormat R�utilis� de multiplicit� 0..n : liste des identifiants des actions de la liste.\nSous s�lection - donn�e, indiquer un ActionFormat R�utilis� de multiplicit� 0..1 : identifiant de l'action s�lectionn�e.\nidentifiant - donn�e et label - donn�e sont inutilis�s.\nLa r�alisation est forc�ment listBox.\nLe nombre de lignes visibles vaut 1.\nLe mode de s�lection est ACTIVE_SELECTION.\nAvec action de s�lection n'est pas disponible.\nLa r�gle de conversion n'est pas n�cessaire.\nLes modes d'affichage disponibles sont uniquement EDIT et INVISIBLE."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:isActionList"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('isActionList',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocListAction_Conception_Group"
        domainClass = "equinoxeDialogue.DocListAction"
        controls += EqxHyperlinkDescription.create[
          name = "DocListAction_dialogAction_Ref"
          labelExpression = "aql:self.getFeatureLabel('dialogAction')"
          helpExpression = "Le nom de l'�v�nement PAF permettant de d�clencher une transition de carte de Dialogue/Proc�dure.\nSont disponibles les actions standard de l'�cran, les actions de dialogue et les actions de fin de dialogue."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:dialogAction"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "..."
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxSetFromListView('dialogAction')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('dialogAction')"
              ]
            ]
          ]
        ]
        controls += SelectDescription.create[
          name = "DocListAction_validationStrategy_Enum"
          labelExpression = "aql:self.getFeatureLabel('validationStrategy')"
          helpExpression = "Indique la strat�gie de validation des donn�es captur�es dans l'�cran, sur le d�clenchement de l'action."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:validationStrategy"
          candidatesExpression = "aql:equinoxeDialogue::EnumValidationStrategy.eLiterals->collect(e|e.instance)"
          candidateDisplayExpression = "aql:candidate.toString()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('validationStrategy',newValue)"
            ]
          ]
        ]
        controls += CheckboxDescription.create[
          name = "DocListAction_withConfirmation_Check"
          labelExpression = "aql:self.getFeatureLabel('withConfirmation')"
          helpExpression = "Indique si ce bouton d�clenche un message de confirmation, dans ce cas il faut renseigner le sous-objet MessageKey \"confirmation\" avec le message de confirmation que l'on veut afficher."
          isEnabledExpression = "aql:false"
          valueExpression = "feature:withConfirmation"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('withConfirmation',newValue)"
            ]
          ]
          style = CheckboxWidgetStyle.create[
            labelFontFormat += org.eclipse.sirius.viewpoint.FontFormat.getByName("italic")
            labelForegroundColor = (extras.get("Color#gray") as SystemColor)
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocMailto_Affichage_Group"
        domainClass = "equinoxeDialogue.DocMailto"
        controls += SelectDescription.create[
          name = "DocMailto_style_Enum"
          labelExpression = "aql:self.getFeatureLabel('style')"
          helpExpression = "Style du texte affich�"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:style"
          candidatesExpression = "aql:equinoxeDialogue::EnumMsgStyle.eLiterals->collect(e|e.instance)"
          candidateDisplayExpression = "aql:candidate.toString()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('style',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocMessage_Conception_Group"
        domainClass = "equinoxeDialogue.DocMessage"
        controls += EqxHyperlinkDescription.create[
          name = "DocMessage_targetedDocBloc_Ref"
          labelExpression = "aql:self.getFeatureLabel('targetedDocBloc')"
          helpExpression = "Bloc cible, dans lequel s'affiche la l�gende associ�e � ce champ. Laisser vide pour utiliser le bloc par d�faut : en bas du bloc de niveau 0 de l'�cran.\nDisponible uniquement sur le canal INTERNET."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()  and self.isInInternetContext()"
          valueExpression = "feature:targetedDocBloc"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "..."
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxSetFromTreeView('targetedDocBloc')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('targetedDocBloc')"
              ]
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocMsgKey_Conception_Group"
        domainClass = "equinoxeDialogue.DocMsgKey"
        controls += TextDescription.create[
          name = "DocMsgKey_domaine_Txt"
          labelExpression = "aql:self.getFeatureLabel('domaine')"
          helpExpression = "Domaine dans lequel chercher le message en fonction de la clef."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:domaine"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('domaine',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "DocMsgKey_key_Txt"
          labelExpression = "aql:self.getFeatureLabel('key')"
          helpExpression = "clef utilis�e dans le fichier de propri�t�s"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:key"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('key',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "DocMsgKey_value_Txt"
          labelExpression = "aql:self.getFeatureLabel('value')"
          helpExpression = "champ permettant de stocker la valeur � associer � la clef."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:value"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('value',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocParameter_Conception_Group"
        domainClass = "equinoxeDialogue.DocParameter"
        controls += CheckboxDescription.create[
          name = "DocParameter_useInterface_Check"
          labelExpression = "aql:self.getFeatureLabel('useInterface')"
          helpExpression = "Utilise l'interface du bouton d'action de t�che pour d�finir le param�tre."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:useInterface"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('useInterface',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocRuleEnumAttribute_Conception_Group"
        domainClass = "equinoxeDialogue.DocRuleEnumAttribute"
        controls += EqxHyperlinkDescription.create[
          name = "DocRuleEnumAttribute_validatorAttribute_Ref"
          labelExpression = "aql:self.getFeatureLabel('validatorAttribute')"
          helpExpression = ""
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:validatorAttribute"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          style = HyperlinkWidgetStyle.create[
            labelFontFormat += org.eclipse.sirius.viewpoint.FontFormat.getByName("bold")
          ]
          actions += WidgetAction.create[
            labelExpression = "..."
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxSetFromListView('validatorAttribute')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('validatorAttribute')"
              ]
            ]
          ]
        ]
        controls += EqxHyperlinkDescription.create[
          name = "DocRuleEnumAttribute_value_Ref"
          labelExpression = "aql:self.getFeatureLabel('value')"
          helpExpression = ""
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:value"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          style = HyperlinkWidgetStyle.create[
            labelFontFormat += org.eclipse.sirius.viewpoint.FontFormat.getByName("bold")
          ]
          actions += WidgetAction.create[
            labelExpression = "..."
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxSetFromListView('value')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('value')"
              ]
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocRuleIntegerAttribute_Conception_Group"
        domainClass = "equinoxeDialogue.DocRuleIntegerAttribute"
        controls += EqxHyperlinkDescription.create[
          name = "DocRuleIntegerAttribute_validatorAttribute_Ref"
          labelExpression = "aql:self.getFeatureLabel('validatorAttribute')"
          helpExpression = ""
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:validatorAttribute"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          style = HyperlinkWidgetStyle.create[
            labelFontFormat += org.eclipse.sirius.viewpoint.FontFormat.getByName("bold")
          ]
          actions += WidgetAction.create[
            labelExpression = "..."
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxSetFromListView('validatorAttribute')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('validatorAttribute')"
              ]
            ]
          ]
        ]
        controls += CustomDescription.create[
          name = "DocRuleIntegerAttribute_value_Eqx_Spinner"
          labelExpression = "aql:self.getFeatureLabel('value')"
          helpExpression = "Valeur de type Entier du param�tre."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          customExpressions += CustomExpression.create[
            name = "valueExpression"
            customExpression = "feature:value"
          ]
          customExpressions += CustomExpression.create[
            name = "valueSetter"
            customExpression = "aql:self.eqxPut('value',newValue)"
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocRuleRegexpAttribute_Conception_Group"
        domainClass = "equinoxeDialogue.DocRuleRegexpAttribute"
        controls += EqxHyperlinkDescription.create[
          name = "DocRuleRegexpAttribute_validatorAttribute_Ref"
          labelExpression = "aql:self.getFeatureLabel('validatorAttribute')"
          helpExpression = ""
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:validatorAttribute"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          style = HyperlinkWidgetStyle.create[
            labelFontFormat += org.eclipse.sirius.viewpoint.FontFormat.getByName("bold")
          ]
          actions += WidgetAction.create[
            labelExpression = "..."
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxSetFromListView('validatorAttribute')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('validatorAttribute')"
              ]
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "DocRuleRegexpAttribute_value_Txt"
          labelExpression = "aql:self.getFeatureLabel('value')"
          helpExpression = "Valeur de type expression r�guli�re du param�tre."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:value"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('value',newValue)"
            ]
          ]
          style = TextWidgetStyle.create[
            labelFontFormat += org.eclipse.sirius.viewpoint.FontFormat.getByName("bold")
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocRuleStringAttribute_Conception_Group"
        domainClass = "equinoxeDialogue.DocRuleStringAttribute"
        controls += EqxHyperlinkDescription.create[
          name = "DocRuleStringAttribute_validatorAttribute_Ref"
          labelExpression = "aql:self.getFeatureLabel('validatorAttribute')"
          helpExpression = ""
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:validatorAttribute"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          style = HyperlinkWidgetStyle.create[
            labelFontFormat += org.eclipse.sirius.viewpoint.FontFormat.getByName("bold")
          ]
          actions += WidgetAction.create[
            labelExpression = "..."
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxSetFromListView('validatorAttribute')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('validatorAttribute')"
              ]
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "DocRuleStringAttribute_value_Txt"
          labelExpression = "aql:self.getFeatureLabel('value')"
          helpExpression = "Valeur de type cha�ne de caract�res du param�tre."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:value"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('value',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocScreenItem_Affichage_Group"
        domainClass = "equinoxeDialogue.DocScreenItem"
        controls += CustomDescription.create[
          name = "DocScreenItem_colSpan_Eqx_Spinner"
          labelExpression = "aql:self.getFeatureLabel('colSpan')"
          helpExpression = "Nombre de colonnes occup�es par le widget lorsque celui-ci fait partie d'une grille ou d'une ligne de pr�sentation. Ce nombre ne doit pas �tre sup�rieur au nombre de colonnes de son parent."
          isEnabledExpression = "aql:self.isNotReadOnlyElement() and self.isColSpanEditable()"
          customExpressions += CustomExpression.create[
            name = "valueExpression"
            customExpression = "feature:colSpan"
          ]
          customExpressions += CustomExpression.create[
            name = "valueSetter"
            customExpression = "aql:self.eqxPut('colSpan',newValue)"
          ]
        ]
        controls += EqxHyperlinkDescription.create[
          name = "DocScreenItem_seContentAlign_Ref"
          labelExpression = "aql:self.getFeatureLabel('seContentAlign')"
          helpExpression = "Alignement � appliquer au widget lorsque celui-ci fait partie d'une grille ou d'une ligne de pr�sentation et qu'il occupe plusieurs colonnes (Nombre de colonnes occup�es)."
          isEnabledExpression = "aql:self.isNotReadOnlyElement() and self.isColSpanEditable() and self.colSpan > 1"
          valueExpression = "feature:seContentAlign"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "..."
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxSetFromListView('seContentAlign')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('seContentAlign')"
              ]
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocSigningBloc_Affichage_Group"
        domainClass = "equinoxeDialogue.DocSigningBloc"
        controls += SelectDescription.create[
          name = "DocBloc_style_Enum"
          labelExpression = "aql:self.getFeatureLabel('style')"
          helpExpression = "Le style graphique du bloc de donn�e."
          isEnabledExpression = "aql:false"
          valueExpression = "feature:style"
          candidatesExpression = "aql:equinoxeDialogue::EnumStyleBloc.eLiterals->collect(e|e.instance)"
          candidateDisplayExpression = "aql:candidate.toString()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('style',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocSimpleItem_Affichage_Group"
        domainClass = "equinoxeDialogue.DocSimpleItem"
        controls += EqxHyperlinkDescription.create[
          name = "DocSimpleItem_labelPosition_Ref"
          labelExpression = "aql:self.getFeatureLabel('labelPosition')"
          helpExpression = "Alignement de l'�tiquette :"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:labelPosition"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "..."
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxSetFromListView('labelPosition')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('labelPosition')"
              ]
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocSortingRule_Conception_Group"
        domainClass = "equinoxeDialogue.DocSortingRule"
        controls += CheckboxDescription.create[
          name = "DocSortingRule_caseSensitive_Check"
          labelExpression = "aql:self.getFeatureLabel('caseSensitive')"
          helpExpression = "Indique si la casse est prise en compte dans la relation d'ordre."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:caseSensitive"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('caseSensitive',newValue)"
            ]
          ]
        ]
        controls += CheckboxDescription.create[
          name = "DocSortingRule_diacriticsSensitive_Check"
          labelExpression = "aql:self.getFeatureLabel('diacriticsSensitive')"
          helpExpression = "Indique si les accents doivent �tres pris en compte dans la relation d'ordre."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:diacriticsSensitive"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('diacriticsSensitive',newValue)"
            ]
          ]
        ]
        controls += CheckboxDescription.create[
          name = "DocSortingRule_simpleQuoteSensitive_Check"
          labelExpression = "aql:self.getFeatureLabel('simpleQuoteSensitive')"
          helpExpression = "Indique si les apostrophes doivent �tres prises en compte dans la relation d'ordre."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:simpleQuoteSensitive"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('simpleQuoteSensitive',newValue)"
            ]
          ]
        ]
        controls += CheckboxDescription.create[
          name = "DocSortingRule_spacesSensitive_Check"
          labelExpression = "aql:self.getFeatureLabel('spacesSensitive')"
          helpExpression = "Indique si les espaces de d�but et de fin sont pris en compte dans la relation d'ordre."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:spacesSensitive"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('spacesSensitive',newValue)"
            ]
          ]
        ]
        controls += SelectDescription.create[
          name = "DocSortingRule_sortOrder_Enum"
          labelExpression = "aql:self.getFeatureLabel('sortOrder')"
          helpExpression = "Pour un crit�re de tri uniquement."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:sortOrder"
          candidatesExpression = "aql:equinoxeDialogue::EnumSortingRule.eLiterals->collect(e|e.instance)"
          candidateDisplayExpression = "aql:candidate.toString()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('sortOrder',newValue)"
            ]
          ]
        ]
        controls += EqxHyperlinkDescription.create[
          name = "DocSortingRule_sAppliqueSurLaDonnee_Ref"
          labelExpression = "aql:self.getFeatureLabel('sAppliqueSurLaDonnee')"
          helpExpression = "Donn�e sur laquelle s'applique la relation d'ordre. Pour un crit�re de tri uniquement."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:sAppliqueSurLaDonnee"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "..."
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxSetFromTreeView('sAppliqueSurLaDonnee')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('sAppliqueSurLaDonnee')"
              ]
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocStartTaskAction_Conception_Group"
        domainClass = "equinoxeDialogue.DocStartTaskAction"
        controls += EqxHyperlinkDescription.create[
          name = "DocStartTaskAction_actionTarget_Ref"
          labelExpression = "aql:self.getFeatureLabel('actionTarget')"
          helpExpression = "Identifiant de la fen�tre cible charg�e d'afficher le r�sultat de la requ�te.\n ActionTarget.NEW pour afficher le r�sultat dans une nouvelle fen�tre sans nom. [Identifiant de fen�tre] pour afficher le r�sultat dans une fen�tre ayant un identifiant commen�ant par un caract�re alphab�tique (a-zA-Z) et ne comportant aucun espace. L'identification d'une fen�tre permet d'afficher syst�matiquement le r�sultat dans la m�me fen�tre contrairement � l'action ActionTarget.NEW qui d�clenchera, � chaque clic, l'ouverture d'une nouvelle fen�tre."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:actionTarget"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          style = HyperlinkWidgetStyle.create[
            labelFontFormat += org.eclipse.sirius.viewpoint.FontFormat.getByName("bold")
          ]
          actions += WidgetAction.create[
            labelExpression = "..."
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxSetFromListView('actionTarget')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('actionTarget')"
              ]
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocStaticValue_Conception_Group"
        domainClass = "equinoxeDialogue.DocStaticValue"
        controls += TextDescription.create[
          name = "DocStaticValue_value_Txt"
          labelExpression = "aql:self.getFeatureLabel('value')"
          helpExpression = ""
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:value"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('value',newValue)"
            ]
          ]
          style = TextWidgetStyle.create[
            labelFontFormat += org.eclipse.sirius.viewpoint.FontFormat.getByName("bold")
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocStructElement_Conception_Group"
        domainClass = "equinoxeDialogue.DocStructElement"
        controls += CheckboxDescription.create[
          name = "DocStructElement_separator_Check"
          labelExpression = "aql:self.getFeatureLabel('separator')"
          helpExpression = "Sp�cifie la pr�sence d'un s�parateur (ligne verticale) de colonne"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:separator"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('separator',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocStructElement_Affichage_Group"
        domainClass = "equinoxeDialogue.DocStructElement"
        controls += CheckboxDescription.create[
          name = "DocStructElement_justified_Check"
          labelExpression = "aql:self.getFeatureLabel('justified')"
          helpExpression = "Permet de sp�cifier si les widgets doivent �tre espac�s en occupant un maximum de place ou non. Les widgets seront espac�s si cet attribut est valu� � \"true\". Il peut �tre utilis� et valu� � \"false\" pour placer un bouton � c�t� d'un champ de saisie"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:justified"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('justified',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocTab_Conception_Group"
        domainClass = "equinoxeDialogue.DocTab"
        controls += CheckboxDescription.create[
          name = "DocTab_default_Check"
          labelExpression = "aql:self.getFeatureLabel('default')"
          helpExpression = "Flag indiquant si la page d'onglet est celle affich�e par d�faut pour un bloc � onglets."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:default"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('default',newValue)"
            ]
          ]
        ]
        controls += EqxHyperlinkDescription.create[
          name = "DocTab_zoneDeDonneeRecevantLeFocus_Ref"
          labelExpression = "aql:self.getFeatureLabel('zoneDeDonneeRecevantLeFocus')"
          helpExpression = "Permet de sp�cifier sur quel �l�ment doit se placer le focus sur la s�lection de la page d'onglet."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:zoneDeDonneeRecevantLeFocus"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "..."
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxSetFromTreeView('zoneDeDonneeRecevantLeFocus')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('zoneDeDonneeRecevantLeFocus')"
              ]
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocTabbedBloc_Conception_Group"
        domainClass = "equinoxeDialogue.DocTabbedBloc"
        controls += EqxHyperlinkDescription.create[
          name = "DocTabbedBloc_tabbingMode_Ref"
          labelExpression = "aql:self.getFeatureLabel('tabbingMode')"
          helpExpression = ""
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:tabbingMode"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "..."
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxSetFromListView('tabbingMode')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('tabbingMode')"
              ]
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocTable_Conception_Group"
        domainClass = "equinoxeDialogue.DocTable"
        controls += CheckboxDescription.create[
          name = "DocTable_forceBottomEmptyLines_Check"
          labelExpression = "aql:self.getFeatureLabel('forceBottomEmptyLines')"
          helpExpression = "Permet d'indiquer si le tableau doit comporter des \" lignes vides \" apr�s les lignes de donn�es de mani�re � occuper au maximum la hauteur sp�cifi�e par l'attribut \" height \".(forceBottomEmptyLines)"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:forceBottomEmptyLines"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('forceBottomEmptyLines',newValue)"
            ]
          ]
        ]
        controls += SelectDescription.create[
          name = "DocTable_pagerMode_Enum"
          labelExpression = "aql:self.getFeatureLabel('pagerMode')"
          helpExpression = "Indique si le tableau doit paginer les donn�es qu'il pr�sente."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:pagerMode"
          candidatesExpression = "aql:equinoxeDialogue::EnumPagerMode.eLiterals->collect(e|e.instance)"
          candidateDisplayExpression = "aql:candidate.toString()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('pagerMode',newValue)"
            ]
          ]
        ]
        controls += CustomDescription.create[
          name = "DocTable_pagerSize_Eqx_Spinner"
          labelExpression = "aql:self.getFeatureLabel('pagerSize')"
          helpExpression = "si la Pagination est activ�e, taille des pages."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          customExpressions += CustomExpression.create[
            name = "valueExpression"
            customExpression = "feature:pagerSize"
          ]
          customExpressions += CustomExpression.create[
            name = "valueSetter"
            customExpression = "aql:self.eqxPut('pagerSize',newValue)"
          ]
        ]
        controls += SelectDescription.create[
          name = "DocTable_pagerValidationStrategy_Enum"
          labelExpression = "aql:self.getFeatureLabel('pagerValidationStrategy')"
          helpExpression = "Indique la strat�gie de validation des donn�es captur�es dans l'�cran, sur la pagination."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:pagerValidationStrategy"
          candidatesExpression = "aql:equinoxeDialogue::EnumValidationStrategy.eLiterals->collect(e|e.instance)"
          candidateDisplayExpression = "aql:candidate.toString()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('pagerValidationStrategy',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocTableColumn_Conception_Group"
        domainClass = "equinoxeDialogue.DocTableColumn"
        controls += SelectDescription.create[
          name = "DocTableColumn_contentOrientation_Enum"
          labelExpression = "aql:self.getFeatureLabel('contentOrientation')"
          helpExpression = "Orientation du contenu des cellules de la colonne :"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:contentOrientation"
          candidatesExpression = "aql:equinoxeDialogue::EnumOrientation.eLiterals->collect(e|e.instance)"
          candidateDisplayExpression = "aql:candidate.toString()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('contentOrientation',newValue)"
            ]
          ]
        ]
        controls += SelectDescription.create[
          name = "DocTableColumn_contentStyle_Enum"
          labelExpression = "aql:self.getFeatureLabel('contentStyle')"
          helpExpression = "Permet de sp�cifier un style de titre pour la premiere cellule d'une ligne (disponible uniquement sur le canal AGENCE) :"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:contentStyle"
          candidatesExpression = "aql:equinoxeDialogue::EnumContentStyle.eLiterals->collect(e|e.instance)"
          candidateDisplayExpression = "aql:candidate.toString()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('contentStyle',newValue)"
            ]
          ]
        ]
        controls += CheckboxDescription.create[
          name = "DocTableColumn_repeatable_Check"
          labelExpression = "aql:self.getFeatureLabel('repeatable')"
          helpExpression = "Flag indiquant si une m�me donn�e pr�sente dans plusieurs lignes qui se suivent sera r�p�t�e ou non. \nSi la colonne utilise la r�p�tition des lignes identiques (valeur true), toutes les donn�es de la colonne sont affich�es.\nSinon, la donn�e est affich�e pour la premi�re ligne puis cach�e (cellule vide) pour les lignes qui suivent jusqu'� la prochaine ligne pr�sentant une donn�e diff�rente."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:repeatable"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('repeatable',newValue)"
            ]
          ]
        ]
        controls += SelectDescription.create[
          name = "DocTableColumn_sortingMode_Enum"
          labelExpression = "aql:self.getFeatureLabel('sortingMode')"
          helpExpression = "Modalit� de tri de la collection du tableau. Permet de sp�cifier sur quelles colonnes (i.e property) la collection du tableau est triable mais �galement de marquer la colonne ainsi que l'ordre de tri (ascendant/descendant) sur laquelle est tri�e la collection du tableau au d�part (premier affichage)."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:sortingMode"
          candidatesExpression = "aql:equinoxeDialogue::EnumSortingMode.eLiterals->collect(e|e.instance)"
          candidateDisplayExpression = "aql:candidate.toString()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('sortingMode',newValue)"
            ]
          ]
        ]
        controls += SelectDescription.create[
          name = "DocTableColumn_sortingModeInitial_Enum"
          labelExpression = "aql:self.getFeatureLabel('sortingModeInitial')"
          helpExpression = "Quand le mode de tri n'est pas UNSORTABLE, indique le sens initial du tri de la colonne."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:sortingModeInitial"
          candidatesExpression = "aql:equinoxeDialogue::EnumSortingModeInitial.eLiterals->collect(e|e.instance)"
          candidateDisplayExpression = "aql:candidate.toString()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('sortingModeInitial',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocTableTree_Affichage_Group"
        domainClass = "equinoxeDialogue.DocTableTree"
        controls += CheckboxDescription.create[
          name = "DocTableTree_expandable_Check"
          labelExpression = "aql:self.getFeatureLabel('expandable')"
          helpExpression = "Indique si la r�pr�sentation de l'arbre doit �tre escamotable."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:expandable"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('expandable',newValue)"
            ]
          ]
        ]
        controls += CheckboxDescription.create[
          name = "DocTableTree_initiallyExpanded_Check"
          labelExpression = "aql:self.getFeatureLabel('initiallyExpanded')"
          helpExpression = "Indique si le tableau-arbre est d�pli� au premier affichage."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:initiallyExpanded"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('initiallyExpanded',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocTableTreeLevel_Conception_Group"
        domainClass = "equinoxeDialogue.DocTableTreeLevel"
        controls += SelectDescription.create[
          name = "DocTableTreeLevel_deferredExpandMode_Enum"
          labelExpression = "aql:self.getFeatureLabel('deferredExpandMode')"
          helpExpression = "Indique si le mode de chargement du noeud au d�pliage (ouverture) est activ� (\"DeferredExpandMode\").\nDisponible uniquement sur le niveau 2."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:deferredExpandMode"
          candidatesExpression = "aql:equinoxeDialogue::EnumDeferredExpandMode.eLiterals->collect(e|e.instance)"
          candidateDisplayExpression = "aql:candidate.toString()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('deferredExpandMode',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocTopic_Conception_Group"
        domainClass = "equinoxeDialogue.DocTopic"
        controls += EqxHyperlinkDescription.create[
          name = "DocTopic_canal_Ref"
          labelExpression = "aql:self.getFeatureLabel('canal')"
          helpExpression = "Type d'aide en ligne.\nDans un GTC : nom du canal d'aide en ligne g�n�rique.\nSur un �cran : les types disponibles sont l'ensemble des canaux g�n�riques mod�lis�s dans les GTC dont d�pend le composant h�bergeant l'�cran, ainsi que les canaux standards suivants :"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:canal"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          style = HyperlinkWidgetStyle.create[
            labelFontFormat += org.eclipse.sirius.viewpoint.FontFormat.getByName("bold")
          ]
          actions += WidgetAction.create[
            labelExpression = "..."
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxSetFromListView('canal')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('canal')"
              ]
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "DocTopic_taskId_Txt"
          labelExpression = "aql:self.getFeatureLabel('taskId')"
          helpExpression = "Sur un �cran uniquement : identifiant de la t�che qui sera ex�cut�e lors de l'utilisation du canal d'aide dans la page applicative du bouton d'aide."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:taskId"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('taskId',newValue)"
            ]
          ]
          style = TextWidgetStyle.create[
            labelFontFormat += org.eclipse.sirius.viewpoint.FontFormat.getByName("bold")
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocTopic_Affichage_Group"
        domainClass = "equinoxeDialogue.DocTopic"
        controls += TextDescription.create[
          name = "DocTopic_height_Txt"
          labelExpression = "aql:self.getFeatureLabel('height')"
          helpExpression = "Sur un �cran uniquement : Hauteur de la fen�tre cliente ouverte lors de l'invocation d'un bouton d'aide."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:height"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('height',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "DocTopic_width_Txt"
          labelExpression = "aql:self.getFeatureLabel('width')"
          helpExpression = "Sur un �cran uniquement : Largeur de la fen�tre cliente ouverte lors de l'invocation d'un bouton d'aide."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:width"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('width',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocTopicAction_Conception_Group"
        domainClass = "equinoxeDialogue.DocTopicAction"
        controls += EqxHyperlinkDescription.create[
          name = "DocTopicAction_canal_Ref"
          labelExpression = "aql:self.getFeatureLabel('canal')"
          helpExpression = "Type d'aide associ�e au bouton (correspond � un canal d'aide)."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:canal"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          style = HyperlinkWidgetStyle.create[
            labelFontFormat += org.eclipse.sirius.viewpoint.FontFormat.getByName("bold")
          ]
          actions += WidgetAction.create[
            labelExpression = "..."
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxSetFromListView('canal')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('canal')"
              ]
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocTopicMapping_Conception_Group"
        domainClass = "equinoxeDialogue.DocTopicMapping"
        controls += EqxHyperlinkDescription.create[
          name = "DocTopicMapping_dataId_Ref"
          labelExpression = "aql:self.getFeatureLabel('dataId')"
          helpExpression = "Type d'identifiant de la donn�e."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:dataId"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          style = HyperlinkWidgetStyle.create[
            labelFontFormat += org.eclipse.sirius.viewpoint.FontFormat.getByName("bold")
          ]
          actions += WidgetAction.create[
            labelExpression = "..."
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxSetFromListView('dataId')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('dataId')"
              ]
            ]
          ]
        ]
        controls += EqxHyperlinkDescription.create[
          name = "DocTopicMapping_champFournissantLaDonnee_Ref"
          labelExpression = "aql:self.getFeatureLabel('champFournissantLaDonnee')"
          helpExpression = "Widget de l'�cran fournissant la donn�e � publier sur le canal d'aide."
          isEnabledExpression = "aql:self.isNotReadOnlyElement() and self.donneeContextuelle = null"
          valueExpression = "feature:champFournissantLaDonnee"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "..."
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxSetFromTreeView('champFournissantLaDonnee')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('champFournissantLaDonnee')"
              ]
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocValidationRule_Conception_Group"
        domainClass = "equinoxeDialogue.DocValidationRule"
        controls += TextDescription.create[
          name = "DocValidationRule_cboPropertyName_Txt"
          labelExpression = "aql:self.getFeatureLabel('cboPropertyName')"
          helpExpression = "Le nom de l'attribut du CBO sur lequel appliquer la r�gle de validation.\nA pr�ciser dans le cas d'une utilisation avec un CBO.\nDans ce champ il est possible de sp�cifier le nom de l'attribut :\n \n une constante : saisir .\n directement le nom : saisir le nom entre double-quote\n"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:cboPropertyName"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('cboPropertyName',newValue)"
            ]
          ]
        ]
        controls += EqxHyperlinkDescription.create[
          name = "DocValidationRule_rule_Ref"
          labelExpression = "aql:self.getFeatureLabel('rule')"
          helpExpression = "Nom du validateur � appeler."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:rule"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          style = HyperlinkWidgetStyle.create[
            labelFontFormat += org.eclipse.sirius.viewpoint.FontFormat.getByName("bold")
          ]
          actions += WidgetAction.create[
            labelExpression = "..."
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxSetFromTreeView('rule')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('rule')"
              ]
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocWebAppPanel_Conception_Group"
        domainClass = "equinoxeDialogue.DocWebAppPanel"
        controls += SelectDescription.create[
          name = "DocWebAppPanel_defaultDisplayMode_Enum"
          labelExpression = "aql:self.getFeatureLabel('defaultDisplayMode')"
          helpExpression = "Indique le mode d'affichage par d�faut de ce composant pour chacun des modes d'affichage de l'�cran."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:defaultDisplayMode"
          candidatesExpression = "aql:equinoxeDialogue::EnumActionDisplayMode.eLiterals->collect(e|e.instance)"
          candidateDisplayExpression = "aql:candidate.toString()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('defaultDisplayMode',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "DocWebAppPanel_webAppId_Txt"
          labelExpression = "aql:self.getFeatureLabel('webAppId')"
          helpExpression = "Identifiant de l'application � int�grer au sein du composant graphique."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:webAppId"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('webAppId',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "DocWebAppPanel_webAppTaskId_Txt"
          labelExpression = "aql:self.getFeatureLabel('webAppTaskId')"
          helpExpression = "Identifiant de la t�che associ�e."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:webAppTaskId"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('webAppTaskId',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "DocWidgetRef_Conception_Group"
        domainClass = "equinoxeDialogue.DocWidgetRef"
        controls += EqxHyperlinkDescription.create[
          name = "DocWidgetRef_widgetReference_Ref"
          labelExpression = "aql:self.getFeatureLabel('widgetReference')"
          helpExpression = "Widget qui porte la valeur pour le param�tre de message."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:widgetReference"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          style = HyperlinkWidgetStyle.create[
            labelFontFormat += org.eclipse.sirius.viewpoint.FontFormat.getByName("bold")
          ]
          actions += WidgetAction.create[
            labelExpression = "..."
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxSetFromTreeView('widgetReference')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('widgetReference')"
              ]
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "EventTransition_Conception_Group"
        domainClass = "equinoxeDialogue.EventTransition"
        controls += EqxHyperlinkDescription.create[
          name = "EventTransition_event_Ref"
          labelExpression = "Ev�nement"
          helpExpression = ""
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:event"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          style = HyperlinkWidgetStyle.create[
            labelFontFormat += org.eclipse.sirius.viewpoint.FontFormat.getByName("bold")
          ]
          actions += WidgetAction.create[
            labelExpression = "..."
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxSetFromListView('event')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('event')"
              ]
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "ScreenMapState_Conception_Group"
        domainClass = "equinoxeDialogue.ScreenMapState"
        controls += SelectDescription.create[
          name = "ScreenMapState_accessMode_Enum"
          labelExpression = "aql:self.getFeatureLabel('accessMode')"
          helpExpression = "Mode d'acc�s � l'�cran :"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:accessMode"
          candidatesExpression = "aql:equinoxeDialogue::EnumScreenDisplayMode.eLiterals->collect(e|e.instance)"
          candidateDisplayExpression = "aql:candidate.toString()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('accessMode',newValue)"
            ]
          ]
        ]
        controls += EqxHyperlinkDescription.create[
          name = "ScreenMapState_screen_Ref"
          labelExpression = "aql:self.getFeatureLabel('screen')"
          helpExpression = "Ecran affich� par cette �tape."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:screen"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          style = HyperlinkWidgetStyle.create[
            labelFontFormat += org.eclipse.sirius.viewpoint.FontFormat.getByName("bold")
          ]
          actions += WidgetAction.create[
            labelExpression = "..."
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxSetFromTreeView('screen')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('screen')"
              ]
            ]
          ]
        ]
      ]
    ])
  }
  
  def getExtras() {
    context.extras
  }

  def <T extends org.eclipse.sirius.viewpoint.description.IdentifiedElement> at(Iterable<T> values, Object key) {
    context.at(values, key) as T // Xtend inference fails?
  }

}
