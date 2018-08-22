package fr.ibp.odv.xad2.rcp

import fr.ibp.odv.xad2.rcp.properties.ext.sirius.eqxSiriusProperties.EqxHyperlinkDescription
import java.util.Map
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.sirius.properties.Category
import org.eclipse.sirius.properties.CheckboxDescription
import org.eclipse.sirius.properties.GroupDescription
import org.eclipse.sirius.properties.HyperlinkWidgetStyle
import org.eclipse.sirius.properties.ListDescription
import org.eclipse.sirius.properties.SelectDescription
import org.eclipse.sirius.properties.TextAreaDescription
import org.eclipse.sirius.properties.TextDescription
import org.eclipse.sirius.properties.TextWidgetStyle
import org.eclipse.sirius.properties.WidgetAction
import org.eclipse.sirius.viewpoint.description.tool.ChangeContext
import org.eclipse.sirius.viewpoint.description.tool.InitialOperation
import org.mypsycho.emf.modit.EModIt

class equinoxeProcedure_Definition {
  val EqxModelDesign context
  val extension EModIt factory

  new(EqxModelDesign parent) {
    this.context = parent
    this.factory = parent.factory
  }

  def content() {
    "equinoxeProcedure_Definition".alias(Category.create[
      name = "equinoxeProcedure_Definition"
      groups += GroupDescription.create[
        name = "AccessingProcessState_Conception_Group"
        domainClass = "equinoxeProcedure.AccessingProcessState"
        controls += SelectDescription.create[
          name = "AccessingProcessState_habilitationType_Enum"
          labelExpression = "aql:self.getFeatureLabel('habilitationType')"
          helpExpression = "Type d'habilitation n�cessaire pour pouvoir utiliser une �tape de la carte de proc�dure."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:habilitationType"
          candidatesExpression = "aql:equinoxeProcedure::EHabilitationType.eLiterals->collect(e|e.instance)"
          candidateDisplayExpression = "aql:candidate.toString()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('habilitationType',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "EditicState_Conception_Group"
        domainClass = "equinoxeProcedure.EditicState"
        controls += ListDescription.create[
          name = "EditicState_documents_Ref"
          labelExpression = "aql:self.getFeatureLabel('documents')"
          helpExpression = "R�f�rences des documents types � �diter."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:documents"
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
                browseExpression = "aql:self.eqxAddFromTreeView('documents',true)"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxRemove('documents',selection)"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Monter"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.performMoveCommandUp('documents',selection)"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Descendre"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.performMoveCommandDown('documents',selection)"
              ]
            ]
          ]
        ]
        controls += SelectDescription.create[
          name = "EditicState_editSubprocess_Enum"
          labelExpression = "aql:self.getFeatureLabel('editSubprocess')"
          helpExpression = ""
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:editSubprocess"
          candidatesExpression = "aql:equinoxeProcedure::EEditionType.eLiterals->collect(e|e.instance)"
          candidateDisplayExpression = "aql:candidate.toString()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('editSubprocess',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "IORuleState_Conception_Group"
        domainClass = "equinoxeProcedure.IORuleState"
        controls += TextAreaDescription.create[
          name = "IORuleState_inputRules_TxtArea"
          labelExpression = "aql:self.getFeatureLabel('inputRules')"
          helpExpression = "Description des manipulations des formats utilis�s lors d'appels de composants."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:inputRules"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('inputRules',newValue)"
            ]
          ]
        ]
        controls += TextAreaDescription.create[
          name = "IORuleState_outputRules_TxtArea"
          labelExpression = "aql:self.getFeatureLabel('outputRules')"
          helpExpression = "Description des manipulations des formats retourn�s par les composants appel�s."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:outputRules"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('outputRules',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "MessageState_Conception_Group"
        domainClass = "equinoxeProcedure.MessageState"
        controls += EqxHyperlinkDescription.create[
          name = "MessageState_inputFormat_Ref"
          labelExpression = "aql:self.getFeatureLabel('inputFormat')"
          helpExpression = "Message d'entr�e qui d�crit la structure de l'appel.\nIl s'agit d'un format, qui peut �tre localis� dans les formats publics ou priv�s du CP, les formats publics des composants d�pendants, ou bien dans les types communs."
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
                browseExpression = "aql:self.eqxSetFromTreeView('inputFormat')"
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
          name = "MessageState_outputFormat_Ref"
          labelExpression = "aql:self.getFeatureLabel('outputFormat')"
          helpExpression = "Message de sortie qui d�crit la structure retourn�e par la source.\nIl s'agit d'un format, qui peut �tre localis� dans les formats publics ou priv�s du CP, les formats publics des composants d�pendants, ou bien dans les types communs."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:outputFormat"
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
                browseExpression = "aql:self.eqxSetFromTreeView('outputFormat')"
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
        controls += EqxHyperlinkDescription.create[
          name = "MessageState_messageInterface_Ref"
          labelExpression = "aql:self.getFeatureLabel('messageInterface')"
          helpExpression = "Interface de message associ�e � l'appel."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:messageInterface"
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
                browseExpression = "aql:self.eqxSetFromListView('messageInterface')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('messageInterface')"
              ]
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "PafAdapter_Conception_Group"
        domainClass = "equinoxeProcedure.PafAdapter"
        controls += CheckboxDescription.create[
          name = "PafAdapter_manageSessionLifecycle_Check"
          labelExpression = "aql:self.getFeatureLabel('manageSessionLifecycle')"
          helpExpression = "Indique si l'adaptateur doit permettre de g�rer le cycle de vie de la session de travail dans laquelle s'ex�cute le composant."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:manageSessionLifecycle"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('manageSessionLifecycle',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "PafAdapter_Generation_Group"
        domainClass = "equinoxeProcedure.PafAdapter"
        controls += TextDescription.create[
          name = "PafAdapter_adapterId_Txt"
          labelExpression = "aql:self.getFeatureLabel('adapterId')"
          helpExpression = "Identifiant de l'adaptateur. \nCet identifiant est uniquement � renseigner s'il s'agit d'un adaptateur simple."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:adapterId"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('adapterId',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "PafAdapter_nextTaskId_Txt"
          labelExpression = "aql:self.getFeatureLabel('nextTaskId')"
          helpExpression = "ID de la t�che suivante, dans le cas o� il y a un cha�nage des t�ches."
          isEnabledExpression = "aql:self.isNotReadOnlyElement() and self.taskChaining"
          valueExpression = "feature:nextTaskId"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('nextTaskId',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "PafAdapter_parentClass_Txt"
          labelExpression = "aql:self.getFeatureLabel('parentClass')"
          helpExpression = "Nom Java long de la classe parente de la classe de l'adaptateur PAF. \nLaisser le champ vide pour utiliser la classe parente par d�faut."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:parentClass"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('parentClass',newValue)"
            ]
          ]
        ]
        controls += CheckboxDescription.create[
          name = "PafAdapter_publishData_Check"
          labelExpression = "aql:self.getFeatureLabel('publishData')"
          helpExpression = "Indique que les donn�es seront publi�es dans la session de travail"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:publishData"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('publishData',newValue)"
            ]
          ]
        ]
        controls += CheckboxDescription.create[
          name = "PafAdapter_taskChaining_Check"
          labelExpression = "aql:self.getFeatureLabel('taskChaining')"
          helpExpression = "Le cha�nage des t�ches est une capacit� permettant le lancement d'une t�che lorsque la t�che pr�c�dente est termin�e"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:taskChaining"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('taskChaining',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "PopixAttribute_Conception_Group"
        domainClass = "equinoxeProcedure.PopixAttribute"
        controls += TextDescription.create[
          name = "PopixAttribute_popixField_Txt"
          labelExpression = "aql:self.getFeatureLabel('popixField')"
          helpExpression = "Nom du Champ POPIX associ� � cette donn�e."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:popixField"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('popixField',newValue)"
            ]
          ]
          style = TextWidgetStyle.create[
            labelFontFormat += org.eclipse.sirius.viewpoint.FontFormat.getByName("bold")
          ]
        ]
        controls += EqxHyperlinkDescription.create[
          name = "PopixAttribute_type_Ref"
          labelExpression = "aql:self.getFeatureLabel('type')"
          helpExpression = "Type de l'�l�ment. Ce type est forc�ment un type de base."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:type"
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
                browseExpression = "aql:self.eqxSetFromTreeView('type')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('type')"
              ]
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "PopixState_Conception_Group"
        domainClass = "equinoxeProcedure.PopixState"
        controls += EqxHyperlinkDescription.create[
          name = "PopixState_popixTransaction_Ref"
          labelExpression = "aql:self.getFeatureLabel('popixTransaction')"
          helpExpression = "Transaction POPIX appel�e."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:popixTransaction"
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
                browseExpression = "aql:self.eqxSetFromListView('popixTransaction')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('popixTransaction')"
              ]
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "PopixTransaction_Conception_Group"
        domainClass = "equinoxeProcedure.PopixTransaction"
        controls += TextDescription.create[
          name = "PopixTransaction_transactionId_Txt"
          labelExpression = "aql:self.getFeatureLabel('transactionId')"
          helpExpression = "ID de la transation POPIX."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:transactionId"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('transactionId',newValue)"
            ]
          ]
          style = TextWidgetStyle.create[
            labelFontFormat += org.eclipse.sirius.viewpoint.FontFormat.getByName("bold")
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "PresentationState_Conception_Group"
        domainClass = "equinoxeProcedure.PresentationState"
        controls += EqxHyperlinkDescription.create[
          name = "PresentationState_dialog_Ref"
          labelExpression = "aql:self.getFeatureLabel('dialog')"
          helpExpression = "Composant Dialogue appel� lors de cette �tape.\nLe pr�sent Composant Proc�dure doit avoir une d�pendance vers le Composant Dialogue appel�."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:dialog"
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
                browseExpression = "aql:self.eqxSetFromTreeView('dialog')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('dialog')"
              ]
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "ProcessComponent_Conception_Group"
        domainClass = "equinoxeProcedure.ProcessComponent"
        controls += EqxHyperlinkDescription.create[
          name = "ProcessComponent_callingDynamicProcessComponent_Ref"
          labelExpression = "aql:self.getFeatureLabel('callingDynamicProcessComponent')"
          helpExpression = "Pour un composant concret : composant proc�dure dynamique en interface du pr�sent composant."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:callingDynamicProcessComponent"
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
                browseExpression = "aql:self.eqxSetFromListView('callingDynamicProcessComponent')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('callingDynamicProcessComponent')"
              ]
            ]
          ]
        ]
        controls += CheckboxDescription.create[
          name = "ProcessComponent_entryPoint_Check"
          labelExpression = "aql:self.getFeatureLabel('entryPoint')"
          helpExpression = "Indique si le Composant Proc�dure peut �tre appel� depuis le poste de travail."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:entryPoint"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('entryPoint',newValue)"
            ]
          ]
        ]
        controls += CheckboxDescription.create[
          name = "ProcessComponent_realizePf_Check"
          labelExpression = "aql:self.getFeatureLabel('realizePf')"
          helpExpression = "Indique que ce composant est la r�alisation d'une Proc�dure Fonctionnelle."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:realizePf"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('realizePf',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "ProcessComponent_Generation_Group"
        domainClass = "equinoxeProcedure.ProcessComponent"
        controls += TextDescription.create[
          name = "ProcessComponent_dsName_Txt"
          labelExpression = "aql:self.getFeatureLabel('dsName')"
          helpExpression = "Pour SQLJ, nom de la source de donn�e (ds_name)."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:dsName"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('dsName',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "ProcessInterface_Conception_Group"
        domainClass = "equinoxeProcedure.ProcessInterface"
        controls += EqxHyperlinkDescription.create[
          name = "ProcessInterface_inputFormat_Ref"
          labelExpression = "aql:self.getFeatureLabel('inputFormat')"
          helpExpression = "Format d'entr�e de la proc�dure : permet d'initialiser une proc�dure avec des donn�es particuli�res lors de son d�marrage (identification de l'agent, de l'�tablissement bancaire, du client courant, ...). C'est une sp�cialisation d'un format classique."
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
        ]
        controls += EqxHyperlinkDescription.create[
          name = "ProcessInterface_outputFormat_Ref"
          labelExpression = "aql:self.getFeatureLabel('outputFormat')"
          helpExpression = "Format de sortie de la proc�dure : utilis� lorsqu'une proc�dure est appel�e en tant que sous-proc�dure par une autre afin de retourner les informations captur�es par cette sous-proc�dure � la proc�dure appelante. C'est une sp�cialisation d'un format classique."
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
        ]
      ]
      groups += GroupDescription.create[
        name = "ProcessOperationState_Conception_Group"
        domainClass = "equinoxeProcedure.ProcessOperationState"
        controls += EqxHyperlinkDescription.create[
          name = "ProcessOperationState_processOperation_Ref"
          labelExpression = "aql:self.getFeatureLabel('processOperation')"
          helpExpression = "Champ obsol�te: la d�claration des Traitments n'est plus requise."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:processOperation"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          style = HyperlinkWidgetStyle.create[
            labelFontFormat += org.eclipse.sirius.viewpoint.FontFormat.getByName("strike_through")
          ]
          actions += WidgetAction.create[
            labelExpression = "..."
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxSetFromListView('processOperation')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('processOperation')"
              ]
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "ProcessScreenState_Conception_Group"
        domainClass = "equinoxeProcedure.ProcessScreenState"
        controls += EqxHyperlinkDescription.create[
          name = "ProcessScreenState_screen_Ref"
          labelExpression = "aql:self.getFeatureLabel('screen')"
          helpExpression = "Ecran affich� lors de cette �tape.\nL'�cran affich� doit se situer sur le pr�sent composant proc�dure."
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
      groups += GroupDescription.create[
        name = "ProcessTransition_Conception_Group"
        domainClass = "equinoxeProcedure.ProcessTransition"
        controls += ListDescription.create[
          name = "ProcessTransition_errors_Ref"
          labelExpression = "aql:self.getFeatureLabel('errors')"
          helpExpression = ""
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:errors"
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
                browseExpression = "aql:self.eqxAddFromListView('errors',true)"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxRemove('errors',selection)"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Monter"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.performMoveCommandUp('errors',selection)"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Descendre"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.performMoveCommandDown('errors',selection)"
              ]
            ]
          ]
        ]
        controls += EqxHyperlinkDescription.create[
          name = "ProcessTransition_exitAction_Ref"
          labelExpression = "aql:self.getFeatureLabel('exitAction')"
          helpExpression = ""
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:exitAction"
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
                browseExpression = "aql:self.eqxSetFromListView('exitAction')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('exitAction')"
              ]
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "ScreenDisplayModeState_Conception_Group"
        domainClass = "equinoxeProcedure.ScreenDisplayModeState"
        controls += SelectDescription.create[
          name = "ScreenDisplayModeState_accessMode_Enum"
          labelExpression = "aql:self.getFeatureLabel('accessMode')"
          helpExpression = "Mode d'acc�s � l'Ecran :"
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
      ]
      groups += GroupDescription.create[
        name = "SubProcessState_Conception_Group"
        domainClass = "equinoxeProcedure.SubProcessState"
        controls += EqxHyperlinkDescription.create[
          name = "SubProcessState_process_Ref"
          labelExpression = "aql:self.getFeatureLabel('process')"
          helpExpression = "Composant Proc�dure appel� lors de cette �tape.\nLe pr�sent Composant Proc�dure doit avoir une d�pendance vers le Composant Proc�dure appel�."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:process"
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
                browseExpression = "aql:self.eqxSetFromListView('process')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('process')"
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
