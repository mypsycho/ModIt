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

class equinoxeComposantsMetier_Definition {
  val EqxModelDesign context
  val extension EModIt factory

  new(EqxModelDesign parent) {
    this.context = parent
    this.factory = parent.factory
  }

  def content() {
    "equinoxeComposantsMetier_Definition".alias(Category.create[
      name = "equinoxeComposantsMetier_Definition"
      groups += GroupDescription.create[
        name = "AbstractBoAttribute_Conception_Group"
        domainClass = "equinoxeComposantsMetier.AbstractBoAttribute"
        controls += TextDescription.create[
          name = "AbstractBoAttribute_colonne_Txt"
          labelExpression = "aql:self.getFeatureLabel('colonne')"
          helpExpression = "Identification de la colonne � laquelle est rattach�e la donn�e (persistance physique).\nPour indiquer plusieurs colonnes, les s�parer par le caract�re '|' (pipe)."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:colonne"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('colonne',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "AbstractBoAttribute_referenceDma_Txt"
          labelExpression = "aql:self.getFeatureLabel('referenceDma')"
          helpExpression = "R�f�rence � la Documentation M�tier d'un Attribut. C'est le code de la rubrique PAC dans le dictionnaire de donn�es PAC.\nPour indiquer plusieurs r�f�rences, les s�parer par le caract�re '|' (pipe)."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:referenceDma"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('referenceDma',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "AbstractBoAttribute_table_Txt"
          labelExpression = "aql:self.getFeatureLabel('table')"
          helpExpression = "Identification de la table � laquelle est rattach�e la donn�e (persistance physique).\nPour indiquer plusieurs tables, les s�parer par le caract�re '|' (pipe)."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:table"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('table',newValue)"
            ]
          ]
        ]
        controls += EqxHyperlinkDescription.create[
          name = "AbstractBoAttribute_type_Ref"
          labelExpression = "aql:self.getFeatureLabel('type')"
          helpExpression = "Type de l'attribut d'objet m�tier."
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
        controls += SelectDescription.create[
          name = "AbstractBoAttribute_visibility_Enum"
          labelExpression = "aql:self.getFeatureLabel('visibility')"
          helpExpression = "Visibilit� de l'attribut :"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:visibility"
          candidatesExpression = "aql:equinoxeCore::EVisibilityFeature.eLiterals->collect(e|e.instance)"
          candidateDisplayExpression = "aql:candidate.toString()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('visibility',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "AbstractBoAttribute_Generation_Group"
        domainClass = "equinoxeComposantsMetier.AbstractBoAttribute"
        controls += TextDescription.create[
          name = "AbstractBoAttribute_jdbcRowName_Txt"
          labelExpression = "aql:self.getFeatureLabel('jdbcRowName')"
          helpExpression = "Pour la g�n�ration JDBC : sur la table correspondant � l'objet m�tier, nom de la colonne correspondant � l'attribut. Si cette propri�t� reste vide, le nom de la colonne est le nom de l'attribut."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:jdbcRowName"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('jdbcRowName',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "AbstractBoViewAttribute_Conception_Group"
        domainClass = "equinoxeComposantsMetier.AbstractBoViewAttribute"
        controls += TextDescription.create[
          name = "AbstractBoViewAttribute_documentationReference_Txt"
          labelExpression = "aql:self.getFeatureLabel('documentationReference')"
          helpExpression = "R�f�rence � la Documentation M�tier d'un Attribut ou d'une class. C'est le code de la rubrique PAC dans le dictionnaire de donn�es PAC."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:documentationReference"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('documentationReference',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "AbstractBusinessComponent_Generation_Group"
        domainClass = "equinoxeComposantsMetier.AbstractBusinessComponent"
        controls += CheckboxDescription.create[
          name = "AbstractBusinessComponent_jdbcGeneration_Check"
          labelExpression = "aql:self.getFeatureLabel('jdbcGeneration')"
          helpExpression = ""
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:jdbcGeneration"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('jdbcGeneration',newValue)"
            ]
          ]
        ]
        controls += CheckboxDescription.create[
          name = "AbstractBusinessComponent_momGeneration_Check"
          labelExpression = "aql:self.getFeatureLabel('momGeneration')"
          helpExpression = ""
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:momGeneration"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('momGeneration',newValue)"
            ]
          ]
        ]
        controls += CheckboxDescription.create[
          name = "AbstractBusinessComponent_sqljGeneration_Check"
          labelExpression = "aql:self.getFeatureLabel('sqljGeneration')"
          helpExpression = ""
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:sqljGeneration"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('sqljGeneration',newValue)"
            ]
          ]
        ]
        controls += CheckboxDescription.create[
          name = "AbstractBusinessComponent_legacyEjb_Check"
          labelExpression = "aql:self.getFeatureLabel('legacyEjb')"
          helpExpression = ""
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:legacyEjb"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('legacyEjb',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "AbstractBusinessComponentInterface_Conception_Group"
        domainClass = "equinoxeComposantsMetier.AbstractBusinessComponentInterface"
        controls += EqxHyperlinkDescription.create[
          name = "AbstractBusinessComponentInterface_superType_Ref"
          labelExpression = "aql:self.getFeatureLabel('superType')"
          helpExpression = "Lien d'h�ritage du l'interface"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:superType"
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
                browseExpression = "aql:self.eqxSetFromTreeView('superType')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('superType')"
              ]
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "AbstractBusinessComponentRealization_Conception_Group"
        domainClass = "equinoxeComposantsMetier.AbstractBusinessComponentRealization"
        controls += ListDescription.create[
          name = "AbstractBusinessComponentRealization_implementedInterfaces_Ref"
          labelExpression = "aql:self.getFeatureLabel('implementedInterfaces')"
          helpExpression = "Interfaces de conception impl�ment�es par la Facade.\nAttention : les interfaces m�tier du composant r�alis�es par la Facade se mod�lisent sur le package parent."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:implementedInterfaces"
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
                browseExpression = "aql:self.eqxAddFromTreeView('implementedInterfaces',true)"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxRemove('implementedInterfaces',selection)"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Monter"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.performMoveCommandUp('implementedInterfaces',selection)"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Descendre"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.performMoveCommandDown('implementedInterfaces',selection)"
              ]
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "AbstractBusinessObject_Conception_Group"
        domainClass = "equinoxeComposantsMetier.AbstractBusinessObject"
        controls += CheckboxDescription.create[
          name = "AbstractBusinessObject_abstraite_Check"
          labelExpression = "aql:self.getFeatureLabel('abstraite')"
          helpExpression = "Indique si cet objet m�tier est abstrait."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:abstraite"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('abstraite',newValue)"
            ]
          ]
        ]
        controls += TextAreaDescription.create[
          name = "AbstractBusinessObject_checkValidity_TxtArea"
          labelExpression = "aql:self.getFeatureLabel('checkValidity')"
          helpExpression = "Description textuelle des r�gles de validation."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:checkValidity"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('checkValidity',newValue)"
            ]
          ]
        ]
        controls += ListDescription.create[
          name = "AbstractBusinessObject_erreursLeveesParLInvariant_Ref"
          labelExpression = "aql:self.getFeatureLabel('erreursLeveesParLInvariant')"
          helpExpression = "Erreurs fonctionnelles lev�es par la m�thode de validation de l'invariant fonctionnel du BO. Les erreurs fonctionnelles doivent �tre des erreurs fonctionnelles publiques du composant."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:erreursLeveesParLInvariant"
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
                browseExpression = "aql:self.eqxAddFromTreeView('erreursLeveesParLInvariant',true)"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxRemove('erreursLeveesParLInvariant',selection)"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Monter"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.performMoveCommandUp('erreursLeveesParLInvariant',selection)"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Descendre"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.performMoveCommandDown('erreursLeveesParLInvariant',selection)"
              ]
            ]
          ]
        ]
        controls += ListDescription.create[
          name = "AbstractBusinessObject_implementeLesInterfaces_Ref"
          labelExpression = "aql:self.getFeatureLabel('implementeLesInterfaces')"
          helpExpression = "Interfaces de conception impl�ment�es par l'objet m�tier."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:implementeLesInterfaces"
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
                browseExpression = "aql:self.eqxAddFromTreeView('implementeLesInterfaces',true)"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxRemove('implementeLesInterfaces',selection)"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Monter"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.performMoveCommandUp('implementeLesInterfaces',selection)"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Descendre"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.performMoveCommandDown('implementeLesInterfaces',selection)"
              ]
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "AbstractBusinessObject_referenceDmc_Txt"
          labelExpression = "aql:self.getFeatureLabel('referenceDmc')"
          helpExpression = "R�f�rence � la Documentation M�tier d'une Classe. C'est le nom de la classe de donn�e dans le MCD MEGA."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:referenceDmc"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('referenceDmc',newValue)"
            ]
          ]
        ]
        controls += EqxHyperlinkDescription.create[
          name = "AbstractBusinessObject_defaultView_Ref"
          labelExpression = "aql:self.getFeatureLabel('defaultView')"
          helpExpression = ""
          isEnabledExpression = "aql:false"
          valueExpression = "feature:defaultView"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
        ]
        controls += ListDescription.create[
          name = "AbstractBusinessObject_referencedViews_Ref"
          labelExpression = "aql:self.getFeatureLabel('referencedViews')"
          helpExpression = ""
          isEnabledExpression = "aql:false"
          valueExpression = "feature:referencedViews"
          displayExpression = "aql:value.getEqxLabel()"
          onClickOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerViewDoubleClick(onClickEventKind)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "AbstractComponent_Conception_Group"
        domainClass = "equinoxeComposantsMetier.AbstractComponent"
        controls += TextDescription.create[
          name = "AbstractComponent_codeObjetMetier_Txt"
          labelExpression = "aql:self.getFeatureLabel('codeObjetMetier')"
          helpExpression = "Trigramme identifiant le composant m�tier. La liste de ces codes sera donn�e par les urbanistes."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:codeObjetMetier"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('codeObjetMetier',newValue)"
            ]
          ]
          style = TextWidgetStyle.create[
            labelFontFormat += org.eclipse.sirius.viewpoint.FontFormat.getByName("bold")
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "BasicTypeBAttribute_Conception_Group"
        domainClass = "equinoxeComposantsMetier.BasicTypeBAttribute"
        controls += EqxHyperlinkDescription.create[
          name = "BasicTypeBAttribute_type_Ref"
          labelExpression = "aql:self.getFeatureLabel('type')"
          helpExpression = "Type de l'attribut"
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
        name = "BoAttribute_Conception_Group"
        domainClass = "equinoxeComposantsMetier.BoAttribute"
        controls += CheckboxDescription.create[
          name = "BoAttribute_identifier_Check"
          labelExpression = "aql:self.getFeatureLabel('identifier')"
          helpExpression = "Attribut constituant l'identifiant du BO.\nNote: La vue par d�faut de ce BO doit �tre �ditable pour pouvoir modifier cette propri�t�."
          isEnabledExpression = "aql:self.isBoAttributeIdentifierEditable()"
          valueExpression = "feature:identifier"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('identifier',newValue)"
            ]
          ]
        ]
        controls += CheckboxDescription.create[
          name = "BoAttribute_modifiable_Check"
          labelExpression = "aql:self.getFeatureLabel('modifiable')"
          helpExpression = "Indique si l'attribut est modifiable au sein du composant.\nUn attribut modifiable peut �tre modifi� au sein du composant sans contr�le autre que le contr�le de validit� sur l'objet m�tier.\nUn attribut non modifiable ne pourra �tre modifi� qu'� travers des \"business methods\" de l'objet m�tier, qui pourront impl�menter des contr�les suppl�mentaires sur la modification de l'attribut."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:modifiable"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('modifiable',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "BoBoAttribute_Conception_Group"
        domainClass = "equinoxeComposantsMetier.BoBoAttribute"
        controls += EqxHyperlinkDescription.create[
          name = "BoBoAttribute_associatedBO_Ref"
          labelExpression = "aql:self.getFeatureLabel('associatedBO')"
          helpExpression = ""
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:associatedBO"
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
                browseExpression = "aql:self.eqxSetFromTreeView('associatedBO')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('associatedBO')"
              ]
            ]
          ]
        ]
        controls += EqxHyperlinkDescription.create[
          name = "BoBoAttribute_opposite_Ref"
          labelExpression = "aql:self.getFeatureLabel('opposite')"
          helpExpression = ""
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:opposite"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          style = HyperlinkWidgetStyle.create
          actions += WidgetAction.create[
            labelExpression = "..."
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxSetFromTreeView('opposite')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('opposite')"
              ]
            ]
          ]
        ]
        controls += CheckboxDescription.create[
          name = "BoBoAttribute_modifiable_Check"
          labelExpression = "aql:self.getFeatureLabel('modifiable')"
          helpExpression = ""
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:modifiable"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('modifiable',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "BoBoAttribute_referenceDMR_Txt"
          labelExpression = "aql:self.getFeatureLabel('referenceDMR')"
          helpExpression = ""
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:referenceDMR"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('referenceDMR',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "BoBoAttribute_table_Txt"
          labelExpression = "aql:self.getFeatureLabel('table')"
          helpExpression = ""
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:table"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('table',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "BoBoAttribute_colonne_Txt"
          labelExpression = "aql:self.getFeatureLabel('colonne')"
          helpExpression = ""
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:colonne"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('colonne',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "BoBoAttribute_Generation_Group"
        domainClass = "equinoxeComposantsMetier.BoBoAttribute"
        controls += CheckboxDescription.create[
          name = "BoBoAttribute_generate_multiple_finder_Check"
          labelExpression = "aql:self.getFeatureLabel('generate_multiple_finder')"
          helpExpression = ""
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:generate_multiple_finder"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('generate_multiple_finder',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "BoBoAttribute_service_id_Txt"
          labelExpression = "aql:self.getFeatureLabel('service_id')"
          helpExpression = ""
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:service_id"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('service_id',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "BoBoAttribute_queue_Txt"
          labelExpression = "aql:self.getFeatureLabel('queue')"
          helpExpression = ""
          isEnabledExpression = "aql:self.isNotReadOnlyElement() and not self.componentUseJmsConfiguration()"
          valueExpression = "feature:queue"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('queue',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "BoBoAttribute_SendQueue_Txt"
          labelExpression = "aql:self.getFeatureLabel('SendQueue')"
          helpExpression = ""
          isEnabledExpression = "aql:self.isNotReadOnlyElement() and self.componentUseJmsConfiguration()"
          valueExpression = "feature:SendQueue"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('SendQueue',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "BoBoAttribute_ReplyQueue_Txt"
          labelExpression = "aql:self.getFeatureLabel('ReplyQueue')"
          helpExpression = ""
          isEnabledExpression = "aql:self.isNotReadOnlyElement() and self.componentUseJmsConfiguration()"
          valueExpression = "feature:ReplyQueue"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('ReplyQueue',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "BoBoAttribute_version_Txt"
          labelExpression = "aql:self.getFeatureLabel('version')"
          helpExpression = ""
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:version"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('version',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "BoBoAttribute_priority_Txt"
          labelExpression = "aql:self.getFeatureLabel('priority')"
          helpExpression = ""
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:priority"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('priority',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "BoGroup_Conception_Group"
        domainClass = "equinoxeComposantsMetier.BoGroup"
        controls += TextDescription.create[
          name = "BoGroup_codeObjetMetier_Txt"
          labelExpression = "aql:self.getFeatureLabel('codeObjetMetier')"
          helpExpression = "Trigramme identifiant l'Objet M�tier de mani�re unique dans le Composant."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:codeObjetMetier"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('codeObjetMetier',newValue)"
            ]
          ]
          style = TextWidgetStyle.create[
            labelFontFormat += org.eclipse.sirius.viewpoint.FontFormat.getByName("bold")
          ]
        ]
        controls += CheckboxDescription.create[
          name = "BoGroup_isAccessor_Check"
          labelExpression = "aql:self.getFeatureLabel('isAccessor')"
          helpExpression = "Indique si les m�thodes CRUD sur le BO r�pondent � la d�finition d'un accesseur."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:isAccessor"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('isAccessor',newValue)"
            ]
          ]
        ]
        controls += CheckboxDescription.create[
          name = "BoGroup_serverCacheStrategy_Check"
          labelExpression = "aql:self.getFeatureLabel('serverCacheStrategy')"
          helpExpression = "Indique si une strat�gie de cache serveur doit �tre adopt�e pour le BO."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:serverCacheStrategy"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('serverCacheStrategy',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "BoMethod_Conception_Group"
        domainClass = "equinoxeComposantsMetier.BoMethod"
        controls += EqxHyperlinkDescription.create[
          name = "AbstractExtendedReturningMethod_returnType_Ref"
          labelExpression = "aql:self.getFeatureLabel('returnType')"
          helpExpression = "Type de retour de la m�thode."
          isEnabledExpression = "aql:self.isNotReadOnlyElement() and self.type != equinoxeComposantsMetier::EboMethodType::finder and self.type != equinoxeComposantsMetier::EboMethodType::multiIdFinder and self.type != equinoxeComposantsMetier::EboMethodType::multiForeignKeyFinder"
          valueExpression = "feature:returnType"
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
                browseExpression = "aql:self.eqxSetFromTreeView('returnType')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('returnType')"
              ]
            ]
          ]
        ]
        controls += SelectDescription.create[
          name = "BoMethod_type_Enum"
          labelExpression = "aql:self.getFeatureLabel('type')"
          helpExpression = "Type de m�thode :"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:type"
          candidatesExpression = "aql:equinoxeComposantsMetier::EboMethodType.eLiterals->collect(e|e.instance)"
          candidateDisplayExpression = "aql:candidate.toString()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('type',newValue)"
            ]
          ]
        ]
        controls += SelectDescription.create[
          name = "BoMethod_visibility_Enum"
          labelExpression = "aql:self.getFeatureLabel('visibility')"
          helpExpression = "Visibilit� (Java) de la m�thode."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:visibility"
          candidatesExpression = "aql:equinoxeCore::EVisibilityFeature.eLiterals->collect(e|e.instance)"
          candidateDisplayExpression = "aql:candidate.toString()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('visibility',newValue)"
            ]
          ]
        ]
        controls += CheckboxDescription.create[
          name = "BoMethod_isAccessor_Check"
          labelExpression = "aql:self.getFeatureLabel('isAccessor')"
          helpExpression = "Puor une requ�te uniquement : indique si la requ�te correspond � la d�finition d'un accesseur.\nPour chaque objet m�tier, une liste r�duite d'accesseurs est d�finie, afin de r�pondre � la question 'comment faire pour acc�der - en lecture / en �criture - � telle ou telle donn�e ?' (cf. FC-APEx2-OD)."
          isEnabledExpression = "aql:self.isNotReadOnlyElement() and self.type != equinoxeComposantsMetier::EboMethodType::businessMethod"
          valueExpression = "feature:isAccessor"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('isAccessor',newValue)"
            ]
          ]
        ]
        controls += ListDescription.create[
          name = "AbstractErrorRaisingMethod_possibleErrors_Ref"
          labelExpression = "aql:self.getFeatureLabel('possibleErrors')"
          helpExpression = ""
          isEnabledExpression = "aql:self.isNotReadOnlyElement() and self.type = equinoxeComposantsMetier::EboMethodType::businessMethod"
          valueExpression = "feature:possibleErrors"
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
                browseExpression = "aql:self.eqxAddFromTreeView('possibleErrors',true)"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxRemove('possibleErrors',selection)"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Monter"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.performMoveCommandUp('possibleErrors',selection)"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Descendre"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.performMoveCommandDown('possibleErrors',selection)"
              ]
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "BoMethod_Generation_Group"
        domainClass = "equinoxeComposantsMetier.BoMethod"
        controls += SelectDescription.create[
          name = "BoMethod_conversionMode_Enum"
          labelExpression = "aql:self.getFeatureLabel('conversionMode')"
          helpExpression = ""
          isEnabledExpression = "aql:self.isNotReadOnlyElement() and self.type != equinoxeComposantsMetier::EboMethodType::businessMethod"
          valueExpression = "feature:conversionMode"
          candidatesExpression = "aql:equinoxeCore::EConversionMode.eLiterals->collect(e|e.instance)"
          candidateDisplayExpression = "aql:candidate.toString()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('conversionMode',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "BoMethod_multiplicity_Txt"
          labelExpression = "aql:self.getFeatureLabel('multiplicity')"
          helpExpression = "Multiplicit� MOM maximum en sortie."
          isEnabledExpression = "aql:self.isNotReadOnlyElement() and self.type != equinoxeComposantsMetier::EboMethodType::finder and self.type != equinoxeComposantsMetier::EboMethodType::businessMethod"
          valueExpression = "feature:multiplicity"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('multiplicity',newValue)"
            ]
          ]
        ]
        controls += CheckboxDescription.create[
          name = "BoMethod_pagedInput_Check"
          labelExpression = "aql:self.getFeatureLabel('pagedInput')"
          helpExpression = "Indique si la requ�te est pagin�e en entr�e."
          isEnabledExpression = "aql:self.isNotReadOnlyElement() and self.type = equinoxeComposantsMetier::EboMethodType::pagedQuery"
          valueExpression = "feature:pagedInput"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('pagedInput',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "BoMethod_pagedInputSize_Txt"
          labelExpression = "aql:self.getFeatureLabel('pagedInputSize')"
          helpExpression = "Taille d'une page de param�tre en entr�e, si la requ�te est pagin�e en entr�e."
          isEnabledExpression = "aql:self.isNotReadOnlyElement() and self.type = equinoxeComposantsMetier::EboMethodType::pagedQuery"
          valueExpression = "feature:pagedInputSize"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('pagedInputSize',newValue)"
            ]
          ]
        ]
        controls += CheckboxDescription.create[
          name = "BoMethod_pagedOutput_Check"
          labelExpression = "aql:self.getFeatureLabel('pagedOutput')"
          helpExpression = "Indique si la requ�te est pagin�e en sortie.\nCette information est � sp�cifier sous l'assistant DA, � travers le type du service."
          isEnabledExpression = "aql:false"
          valueExpression = "feature:pagedOutput"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('pagedOutput',newValue)"
            ]
          ]
          style = CheckboxWidgetStyle.create[
            labelFontFormat += org.eclipse.sirius.viewpoint.FontFormat.getByName("italic")
            labelForegroundColor = (extras.get("Color#gray") as SystemColor)
          ]
        ]
        controls += TextDescription.create[
          name = "BoMethod_paginationKeyName_Txt"
          labelExpression = "aql:self.getFeatureLabel('paginationKeyName')"
          helpExpression = "Nom de la cl� de reprise COBOL, si le service est pagin� en sortie."
          isEnabledExpression = "aql:self.isNotReadOnlyElement() and (self.type = equinoxeComposantsMetier::EboMethodType::query or self.type = equinoxeComposantsMetier::EboMethodType::finder)"
          valueExpression = "feature:paginationKeyName"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('paginationKeyName',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "BoMethod_paginationKeySize_Txt"
          labelExpression = "aql:self.getFeatureLabel('paginationKeySize')"
          helpExpression = "Taille de la cl� de reprise COBOL, si le service est pagin� en sortie."
          isEnabledExpression = "aql:self.isNotReadOnlyElement() and (self.type = equinoxeComposantsMetier::EboMethodType::query or self.type = equinoxeComposantsMetier::EboMethodType::finder)"
          valueExpression = "feature:paginationKeySize"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('paginationKeySize',newValue)"
            ]
          ]
        ]
        controls += EqxHyperlinkDescription.create[
          name = "BoMethod_parametrePagineEnEntree_Ref"
          labelExpression = "aql:self.getFeatureLabel('parametrePagineEnEntree')"
          helpExpression = "Param�tre pagin� en entr�e, si la requ�te est pagin�e en entr�e. \nCe param�tre doit �tre une collection de vues ou une collection de formats."
          isEnabledExpression = "aql:self.isNotReadOnlyElement() and self.type = equinoxeComposantsMetier::EboMethodType::pagedQuery"
          valueExpression = "feature:parametrePagineEnEntree"
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
                browseExpression = "aql:self.eqxSetFromListView('parametrePagineEnEntree')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('parametrePagineEnEntree')"
              ]
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "BoMethod_priority_Txt"
          labelExpression = "aql:self.getFeatureLabel('priority')"
          helpExpression = "Priorit� du programme COBOL sur le mainframe appel� par la requ�te.\nLaisser vide dans la plupart des cas."
          isEnabledExpression = "aql:self.isNotReadOnlyElement() and self.type != equinoxeComposantsMetier::EboMethodType::businessMethod"
          valueExpression = "feature:priority"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('priority',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "BoMethod_programid_Txt"
          labelExpression = "aql:self.getFeatureLabel('programid')"
          helpExpression = "Identifiant du programme COBOL sur le mainframe appel� par la requ�te."
          isEnabledExpression = "aql:self.isNotReadOnlyElement() and self.type != equinoxeComposantsMetier::EboMethodType::businessMethod"
          valueExpression = "feature:programid"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('programid',newValue)"
            ]
          ]
          conditionalStyles += TextWidgetConditionalStyle.create[
            preconditionExpression = "aql:self.type != equinoxeComposantsMetier::EboMethodType::businessMethod"
            style = TextWidgetStyle.create[
              labelFontFormat += org.eclipse.sirius.viewpoint.FontFormat.getByName("bold")
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "BoMethod_queueName_Txt"
          labelExpression = "aql:self.getFeatureLabel('queueName')"
          helpExpression = "Si on n'utilise pas la configuration JMS : File d'attente MQSeries utilis�e par la requ�te pour acc�der au mainframe."
          isEnabledExpression = "aql:self.isNotReadOnlyElement() and self.type != equinoxeComposantsMetier::EboMethodType::businessMethod"
          valueExpression = "feature:queueName"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('queueName',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "BoMethod_replyQueue_Txt"
          labelExpression = "aql:self.getFeatureLabel('replyQueue')"
          helpExpression = "Si on utilise la configuration JMS : File de retour sp�cifique utilis�e par la requ�te pour acc�der au mainframe.\nDans le cas g�n�ral, � laisser vide pour utiliser la file de retour par d�faut d�finie au niveau du composant."
          isEnabledExpression = "aql:self.isNotReadOnlyElement() and self.type != equinoxeComposantsMetier::EboMethodType::businessMethod and self.componentUseJmsConfiguration()"
          valueExpression = "feature:replyQueue"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('replyQueue',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "BoMethod_sendQueue_Txt"
          labelExpression = "aql:self.getFeatureLabel('sendQueue')"
          helpExpression = "Si on utilise la configuration JMS : File d'envoi sp�cifique utilis�e par la requ�te pour acc�der au mainframe.\nDans le cas g�n�ral, � laisser vide pour utiliser la file d'envoi par d�faut d�finie au niveau du composant."
          isEnabledExpression = "aql:self.isNotReadOnlyElement() and self.type != equinoxeComposantsMetier::EboMethodType::businessMethod and self.componentUseJmsConfiguration()"
          valueExpression = "feature:sendQueue"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('sendQueue',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "BoMethod_version_Txt"
          labelExpression = "aql:self.getFeatureLabel('version')"
          helpExpression = "Version du programme COBOL sur le mainframe appel� par la requ�te."
          isEnabledExpression = "aql:self.isNotReadOnlyElement() and self.type != equinoxeComposantsMetier::EboMethodType::businessMethod"
          valueExpression = "feature:version"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('version',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "BoView_Conception_Group"
        domainClass = "equinoxeComposantsMetier.BoView"
        controls += EqxHyperlinkDescription.create[
          name = "BoView_businessObject_Ref"
          labelExpression = "aql:self.getFeatureLabel('businessObject')"
          helpExpression = "Objet m�tier sur lequel porte la Vue.\nIl n'est pas possible de modifier cet objet m�tier. Pour cr�er une vue sur un objet m�tier donn�, cr�er la vue dans le package de cet objet m�tier."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:businessObject"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          style = HyperlinkWidgetStyle.create[
            labelFontFormat += org.eclipse.sirius.viewpoint.FontFormat.getByName("bold")
          ]
        ]
        controls += ListDescription.create[
          name = "BoView_implementeLesInterfaces_Ref"
          labelExpression = "aql:self.getFeatureLabel('implementeLesInterfaces')"
          helpExpression = "Interfaces de Conception impl�ment�es par la vue."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:implementeLesInterfaces"
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
                browseExpression = "aql:self.eqxAddFromTreeView('implementeLesInterfaces',true)"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxRemove('implementeLesInterfaces',selection)"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Monter"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.performMoveCommandUp('implementeLesInterfaces',selection)"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Descendre"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.performMoveCommandDown('implementeLesInterfaces',selection)"
              ]
            ]
          ]
        ]
        controls += CheckboxDescription.create[
          name = "BoView_isBdt_Check"
          labelExpression = "aql:self.getFeatureLabel('isBdt')"
          helpExpression = "Indique que la vue est un Business Data Types (ou Format M�tier Commun).\nLes BDT permettent d'avoir une repr�sentation unique d'un objet m�tier qui est partag�e par toutes les couches (CMR, CMT, CP, voire CD) afin de faciliter le travail de d�veloppement et de maintenance. Les BDT sont externalis�s par rapport aux CMR, et regroup�s au sein de GTC."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:isBdt"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('isBdt',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "BoView_referenceDmc_Txt"
          labelExpression = "aql:self.getFeatureLabel('referenceDmc')"
          helpExpression = "R�f�rence � la Documentation M�tier d'une Classe. C'est le nom de la classe de donn�e dans le MCD MEGA."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:referenceDmc"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('referenceDmc',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "BoViewAttribute_Conception_Group"
        domainClass = "equinoxeComposantsMetier.BoViewAttribute"
        controls += TextDescription.create[
          name = "BoViewAttribute_table_Txt"
          labelExpression = "aql:self.getFeatureLabel('table')"
          helpExpression = "Identification de la table � laquelle est rattach�e la donn�e (persistance physique)."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:table"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('table',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "BoViewAttribute_colonne_Txt"
          labelExpression = "aql:self.getFeatureLabel('colonne')"
          helpExpression = "Identification de la colonne � laquelle est rattach�e la donn�e (persistance physique)."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:colonne"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('colonne',newValue)"
            ]
          ]
        ]
        controls += EqxHyperlinkDescription.create[
          name = "BoViewAttribute_referencedAttribute_Ref"
          labelExpression = "aql:self.getFeatureLabel('referencedAttribute')"
          helpExpression = "Attribut d'objet m�tier repr�sent� par cet el�ment."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:referencedAttribute"
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
                browseExpression = "aql:self.eqxSetFromListView('referencedAttribute')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('referencedAttribute')"
              ]
            ]
          ]
        ]
        controls += EqxHyperlinkDescription.create[
          name = "BoViewAttribute_type_Ref"
          labelExpression = "aql:self.getFeatureLabel('type')"
          helpExpression = "Tye de l'attribut : il s'agit du type de l'attribut d'objet m�tier r�f�renc�."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:type"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          style = HyperlinkWidgetStyle.create[
            labelFontFormat += org.eclipse.sirius.viewpoint.FontFormat.getByName("italic")
            labelFontFormat += org.eclipse.sirius.viewpoint.FontFormat.getByName("bold")
            labelForegroundColor = (extras.get("Color#gray") as SystemColor)
          ]
        ]
        controls += CheckboxDescription.create[
          name = "BoViewAttribute_derived_Check"
          labelExpression = "aql:self.getFeatureLabel('derived')"
          helpExpression = "Indique qu'il s'agit d'un attribut calcul� (\"derived\")."
          isEnabledExpression = "aql:false"
          valueExpression = "feature:derived"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('derived',newValue)"
            ]
          ]
          style = CheckboxWidgetStyle.create[
            labelFontFormat += org.eclipse.sirius.viewpoint.FontFormat.getByName("italic")
            labelForegroundColor = (extras.get("Color#gray") as SystemColor)
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "BoViewBAttribute_Conception_Group"
        domainClass = "equinoxeComposantsMetier.BoViewBAttribute"
        controls += EqxHyperlinkDescription.create[
          name = "BoViewBAttribute_type_Ref"
          labelExpression = "aql:self.getFeatureLabel('type')"
          helpExpression = "Collection de Vue : vue simple qui type chaque item de la collection.\n R�f�rence de Vue : vue simple r�f�renc�e."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:type"
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
        name = "BoViewFAttribute_Conception_Group"
        domainClass = "equinoxeComposantsMetier.BoViewFAttribute"
        controls += EqxHyperlinkDescription.create[
          name = "BoViewFAttribute_type_Ref"
          labelExpression = "aql:self.getFeatureLabel('type')"
          helpExpression = ""
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
        controls += EqxHyperlinkDescription.create[
          name = "BoViewFAttribute_businessObject_Ref"
          labelExpression = "aql:self.getFeatureLabel('businessObject')"
          helpExpression = "Objet m�tier de la vue selectionn� dans le champ \"Type\""
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:businessObject"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          style = HyperlinkWidgetStyle.create[
            labelFontFormat += org.eclipse.sirius.viewpoint.FontFormat.getByName("italic")
            labelFontFormat += org.eclipse.sirius.viewpoint.FontFormat.getByName("bold")
            labelForegroundColor = (extras.get("Color#gray") as SystemColor)
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "Bsp_Conception_Group"
        domainClass = "equinoxeComposantsMetier.Bsp"
        controls += EqxHyperlinkDescription.create[
          name = "Bsp_superType_Ref"
          labelExpression = "aql:self.getFeatureLabel('superType')"
          helpExpression = "Feature that references the inheritance of this element"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:superType"
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
                browseExpression = "aql:self.eqxSetFromTreeView('superType')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('superType')"
              ]
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "Bsp_Generation_Group"
        domainClass = "equinoxeComposantsMetier.Bsp"
        controls += TextDescription.create[
          name = "Bsp_dsName_Txt"
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
        name = "BusinessInterfaceMethod_Conception_Group"
        domainClass = "equinoxeComposantsMetier.BusinessInterfaceMethod"
        controls += EqxHyperlinkDescription.create[
          name = "BusinessInterfaceMethod_type_Ref"
          labelExpression = "aql:self.getFeatureLabel('type')"
          helpExpression = ""
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
                browseExpression = "aql:self.eqxSetFromListView('type')"
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
        name = "BusinessInterfaceMethod_Generation_Group"
        domainClass = "equinoxeComposantsMetier.BusinessInterfaceMethod"
        controls += TextDescription.create[
          name = "BusinessInterfaceMethod_exceptions_Txt"
          labelExpression = "aql:self.getFeatureLabel('exceptions')"
          helpExpression = "Laisser ce champ vide."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:exceptions"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('exceptions',newValue)"
            ]
          ]
        ]
        controls += SelectDescription.create[
          name = "BusinessInterfaceMethod_transactionalMode_Enum"
          labelExpression = "aql:self.getFeatureLabel('transactionalMode')"
          helpExpression = "Indique si l'utilisation d'une transaction est requise lors de l'appel de la m�thode."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:transactionalMode"
          candidatesExpression = "aql:equinoxeCore::ETransactionalMode.eLiterals->collect(e|e.instance)"
          candidateDisplayExpression = "aql:candidate.toString()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('transactionalMode',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "BusinessObject_Conception_Group"
        domainClass = "equinoxeComposantsMetier.BusinessObject"
        controls += EqxHyperlinkDescription.create[
          name = "BusinessObject_superType_Ref"
          labelExpression = "aql:self.getFeatureLabel('superType')"
          helpExpression = "Lien d'h�ritage de cet �l�ment"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:superType"
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
                browseExpression = "aql:self.eqxSetFromTreeView('superType')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('superType')"
              ]
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "BusinessObject_Generation_Group"
        domainClass = "equinoxeComposantsMetier.BusinessObject"
        controls += SelectDescription.create[
          name = "BusinessObject_daoDataAccess_Enum"
          labelExpression = "aql:self.getFeatureLabel('daoDataAccess')"
          helpExpression = "Mode d'acc�s aux donn�es pour les services DAO (services CRUD et finders)."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:daoDataAccess"
          candidatesExpression = "aql:equinoxeComposantsMetier::EDataAccess.eLiterals->collect(e|e.instance)"
          candidateDisplayExpression = "aql:candidate.toString()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('daoDataAccess',newValue)"
            ]
          ]
        ]
        controls += SelectDescription.create[
          name = "BusinessObject_queryDataAccess_Enum"
          labelExpression = "aql:self.getFeatureLabel('queryDataAccess')"
          helpExpression = "Mode d'acc�s aux donn�es pour les queries (queries et paged queries)."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:queryDataAccess"
          candidatesExpression = "aql:equinoxeComposantsMetier::EDataAccess.eLiterals->collect(e|e.instance)"
          candidateDisplayExpression = "aql:candidate.toString()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('queryDataAccess',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "BusinessObject_createProgramId_Txt"
          labelExpression = "aql:self.getFeatureLabel('createProgramId')"
          helpExpression = "Identifiant du programme COBOL sur le mainframe appel� lors de la cr�ation du BO.\nCet identifiant est constitu� de la concat�nation de :\n- code composant\n- nom de la transaction host (anciennement Nom transaction)\n- nom du service �l�mentaire (anciennement Nom service)"
          isEnabledExpression = "aql:self.isNotReadOnlyElement() and self.daoDataAccess == equinoxeComposantsMetier::EDataAccess::mom"
          valueExpression = "feature:createProgramId"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('createProgramId',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "BusinessObject_createVersion_Txt"
          labelExpression = "aql:self.getFeatureLabel('createVersion')"
          helpExpression = "Version du service �l�mentaire pour la cr�ation du BO."
          isEnabledExpression = "aql:self.isNotReadOnlyElement() and self.daoDataAccess == equinoxeComposantsMetier::EDataAccess::mom"
          valueExpression = "feature:createVersion"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('createVersion',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "BusinessObject_createPriority_Txt"
          labelExpression = "aql:self.getFeatureLabel('createPriority')"
          helpExpression = "Priorit� du programme COBOL sur le mainframe appel� lors de la cr�ation du BO.\nLaisser vide dans la plupart des cas."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()  and self.daoDataAccess == equinoxeComposantsMetier::EDataAccess::mom"
          valueExpression = "feature:createPriority"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('createPriority',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "BusinessObject_readProgramid_Txt"
          labelExpression = "aql:self.getFeatureLabel('readProgramid')"
          helpExpression = "Identifiant du programme COBOL sur le mainframe appel� lors de la lecture du BO.\nCet identifiant est constitu� de la concat�nation de :\n- code composant\n- nom de la transaction host (anciennement Nom transaction)\n- nom du service �l�mentaire (anciennement Nom service)"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()  and self.daoDataAccess == equinoxeComposantsMetier::EDataAccess::mom"
          valueExpression = "feature:readProgramid"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('readProgramid',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "BusinessObject_readVersion_Txt"
          labelExpression = "aql:self.getFeatureLabel('readVersion')"
          helpExpression = "Version du service �l�mentaire pour la lecture du BO."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()  and self.daoDataAccess == equinoxeComposantsMetier::EDataAccess::mom"
          valueExpression = "feature:readVersion"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('readVersion',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "BusinessObject_readPriority_Txt"
          labelExpression = "aql:self.getFeatureLabel('readPriority')"
          helpExpression = "Priorit� du programme COBOL sur le mainframe appel� lors de la lecture du BO.\nLaisser vide dans la plupart des cas."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()  and self.daoDataAccess == equinoxeComposantsMetier::EDataAccess::mom"
          valueExpression = "feature:readPriority"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('readPriority',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "BusinessObject_updateProgramid_Txt"
          labelExpression = "aql:self.getFeatureLabel('updateProgramid')"
          helpExpression = "Identifiant du programme COBOL sur le mainframe appel� lors de la mise � jour du BO.\nCet identifiant est constitu� de la concat�nation de :\n- code composant\n- nom de la transaction host (anciennement Nom transaction)\n- nom du service �l�mentaire (anciennement Nom service)"
          isEnabledExpression = "aql:self.isNotReadOnlyElement() and self.daoDataAccess == equinoxeComposantsMetier::EDataAccess::mom"
          valueExpression = "feature:updateProgramid"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('updateProgramid',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "BusinessObject_updateVersion_Txt"
          labelExpression = "aql:self.getFeatureLabel('updateVersion')"
          helpExpression = "Version du service �l�mentaire pour la mise � jour du BO."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()  and self.daoDataAccess == equinoxeComposantsMetier::EDataAccess::mom"
          valueExpression = "feature:updateVersion"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('updateVersion',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "BusinessObject_updatePriority_Txt"
          labelExpression = "aql:self.getFeatureLabel('updatePriority')"
          helpExpression = "Priorit� du programme COBOL sur le mainframe appel� lors de la mise � jour du BO.\nLaisser vide dans la plupart des cas."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()  and self.daoDataAccess == equinoxeComposantsMetier::EDataAccess::mom"
          valueExpression = "feature:updatePriority"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('updatePriority',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "BusinessObject_programidDelete_Txt"
          labelExpression = "aql:self.getFeatureLabel('programidDelete')"
          helpExpression = "Identifiant du programme COBOL sur le mainframe appel� lors de la suppression du BO.\nCet identifiant est constitu� de la concat�nation de :\n- code composant\n- nom de la transaction host (anciennement Nom transaction)\n- nom du service �l�mentaire (anciennement Nom service)"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()  and self.daoDataAccess == equinoxeComposantsMetier::EDataAccess::mom"
          valueExpression = "feature:programidDelete"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('programidDelete',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "BusinessObject_deleteVersion_Txt"
          labelExpression = "aql:self.getFeatureLabel('deleteVersion')"
          helpExpression = "Version du service �l�mentaire pour la suppression du BO."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()  and self.daoDataAccess == equinoxeComposantsMetier::EDataAccess::mom"
          valueExpression = "feature:deleteVersion"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('deleteVersion',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "BusinessObject_deletePriority_Txt"
          labelExpression = "aql:self.getFeatureLabel('deletePriority')"
          helpExpression = "Priorit� du programme COBOL sur le mainframe appel� lors de la suppression du BO.\nLaisser vide dans la plupart des cas."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()  and self.daoDataAccess == equinoxeComposantsMetier::EDataAccess::mom"
          valueExpression = "feature:deletePriority"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('deletePriority',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "BusinessObject_sqljPriority_Txt"
          labelExpression = "aql:self.getFeatureLabel('sqljPriority')"
          helpExpression = "Pour SQLJ, priorit� de la mise � jour du BO (create, update, delete) lors de l'ex�cution de la transaction globale de mise � jour des BOs.\nLaisser vide pour la priorit� par d�faut (0)."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()   and self.daoDataAccess == equinoxeComposantsMetier::EDataAccess::sqlj"
          valueExpression = "feature:sqljPriority"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('sqljPriority',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "BusinessObject_dsName_Txt"
          labelExpression = "aql:self.getFeatureLabel('dsName')"
          helpExpression = "Pour JDBC et SQLJ, nom de la source de donn�e (ds_name)."
          isEnabledExpression = "aql:self.isNotReadOnlyElement() and ( self.daoDataAccess == equinoxeComposantsMetier::EDataAccess::sqlj or self.daoDataAccess == equinoxeComposantsMetier::EDataAccess::jdbc or self.queryDataAccess == equinoxeComposantsMetier::EDataAccess::sqlj or self.queryDataAccess == equinoxeComposantsMetier::EDataAccess::jdbc)"
          valueExpression = "feature:dsName"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('dsName',newValue)"
            ]
          ]
        ]
        controls += CheckboxDescription.create[
          name = "BusinessObject_ownSequence_Check"
          labelExpression = "aql:self.getFeatureLabel('ownSequence')"
          helpExpression = "G�n�ration de s�quence priv�e pour les identifiants techniques du BO."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:ownSequence"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('ownSequence',newValue)"
            ]
          ]
        ]
        controls += CheckboxDescription.create[
          name = "BusinessObject_oldBoRef_Check"
          labelExpression = "aql:self.getFeatureLabel('oldBoRef')"
          helpExpression = "Pour compatibilit� ascendante : une ancienne version du g�n�rateur de code g�n�rait par d�faut un pseudo BORef (cl�+timestamp) dans le loadOutputRecord. \n"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:oldBoRef"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('oldBoRef',newValue)"
            ]
          ]
        ]
        controls += CheckboxDescription.create[
          name = "BusinessObject_alternativeBoInheritance_Check"
          labelExpression = "aql:self.getFeatureLabel('alternativeBoInheritance')"
          helpExpression = "G�n�ration de l'impl�mentation alternative de l'h�ritage du BO : la modification du BO parent n'entraine pas la n�cessit� de reg�n�rer l'ensemble des BO enfants.\nCette capacit� est valable pour l'ensemble de la grappe de BO : elle doit �tre indiqu�e sur le BO au sommet de la grappe.\nCette capacit� est valable uniquement pour une impl�mentation SQLJ."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:alternativeBoInheritance"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('alternativeBoInheritance',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "BusinessObject_sendQueue_Txt"
          labelExpression = "aql:self.getFeatureLabel('sendQueue')"
          helpExpression = "Si on utilise la configuration JMS : File d'envoi sp�cifique utilis�e par la requ�te pour la lecture du BO.\nDans le cas g�n�ral, � laisser vide pour utiliser la file d'envoi par d�faut d�finie au niveau du composant."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()  and self.daoDataAccess == equinoxeComposantsMetier::EDataAccess::mom"
          valueExpression = "feature:sendQueue"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('sendQueue',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "BusinessObject_luwSendQueue_Txt"
          labelExpression = "aql:self.getFeatureLabel('luwSendQueue')"
          helpExpression = "Si on utilise la configuration JMS : File d'envoi sp�cifique utilis�e par la requ�te pour la cr�ation, la mise � jour et la suppression du BO.\nDans le cas g�n�ral, � laisser vide pour utiliser la file d'envoi par d�faut d�finie au niveau du composant."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()  and self.daoDataAccess == equinoxeComposantsMetier::EDataAccess::mom"
          valueExpression = "feature:luwSendQueue"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('luwSendQueue',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "BusinessObject_replyQueue_Txt"
          labelExpression = "aql:self.getFeatureLabel('replyQueue')"
          helpExpression = "Si on utilise la configuration JMS : File de retour sp�cifique utilis�e par la requ�te pour la cr�ation, la lecture, la mise � jour et la suppression du BO.\nDans le cas g�n�ral, � laisser vide pour utiliser la file de retour par d�faut d�finie au niveau du composant."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()  and self.daoDataAccess == equinoxeComposantsMetier::EDataAccess::mom"
          valueExpression = "feature:replyQueue"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('replyQueue',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "BusinessObject_createQueue_Txt"
          labelExpression = "aql:self.getFeatureLabel('createQueue')"
          helpExpression = "Si on n'utilise pas la configuration JMS : File d'attente MQSeries utilis�e pour la cr�ation du BO."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()  and self.daoDataAccess == equinoxeComposantsMetier::EDataAccess::mom"
          valueExpression = "feature:createQueue"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('createQueue',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "BusinessObject_deleteQueue_Txt"
          labelExpression = "aql:self.getFeatureLabel('deleteQueue')"
          helpExpression = "Si on n'utilise pas la configuration JMS : File d'attente MQSeries utilis�e pour la suppression du BO."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()  and self.daoDataAccess == equinoxeComposantsMetier::EDataAccess::mom"
          valueExpression = "feature:deleteQueue"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('deleteQueue',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "BusinessObject_readQueue_Txt"
          labelExpression = "aql:self.getFeatureLabel('readQueue')"
          helpExpression = "Si on n'utilise pas la configuration JMS : File d'attente MQSeries utilis�e pour la lecture du BO."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()  and self.daoDataAccess == equinoxeComposantsMetier::EDataAccess::mom"
          valueExpression = "feature:readQueue"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('readQueue',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "BusinessObject_updateQueue_Txt"
          labelExpression = "aql:self.getFeatureLabel('updateQueue')"
          helpExpression = "Si on n'utilise pas la configuration JMS : File d'attente MQSeries utilis�e pour la mise � jour du BO."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()  and self.daoDataAccess == equinoxeComposantsMetier::EDataAccess::mom"
          valueExpression = "feature:updateQueue"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('updateQueue',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "BusinessServiceProviderMethod_Conception_Group"
        domainClass = "equinoxeComposantsMetier.BusinessServiceProviderMethod"
        controls += SelectDescription.create[
          name = "BusinessServiceProviderMethod_visibility_Enum"
          labelExpression = "aql:self.getFeatureLabel('visibility')"
          helpExpression = "Visibilit� (Java) de la m�thode."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:visibility"
          candidatesExpression = "aql:equinoxeCore::EVisibilityFeature.eLiterals->collect(e|e.instance)"
          candidateDisplayExpression = "aql:candidate.toString()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('visibility',newValue)"
            ]
          ]
        ]
        controls += EqxHyperlinkDescription.create[
          name = "BusinessServiceProviderMethod_initMethod_Ref"
          labelExpression = "aql:self.getFeatureLabel('initMethod')"
          helpExpression = ""
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:initMethod"
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
                browseExpression = "aql:self.eqxSetFromTreeView('initMethod')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('initMethod')"
              ]
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "BusinessServiceProviderMethod_Generation_Group"
        domainClass = "equinoxeComposantsMetier.BusinessServiceProviderMethod"
        controls += TextDescription.create[
          name = "BusinessServiceProviderMethod_exceptions_Txt"
          labelExpression = "aql:self.getFeatureLabel('exceptions')"
          helpExpression = "Laisser ce champ vide."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:exceptions"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('exceptions',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "CMR_Generation_Group"
        domainClass = "equinoxeComposantsMetier.CMR"
        controls += CheckboxDescription.create[
          name = "CMR_useJmsConfiguration_Check"
          labelExpression = "aql:self.getFeatureLabel('useJmsConfiguration')"
          helpExpression = "Utiliser la configuration JMS pour le composant.\nSi la configuration JMS est utilis�e, elle doit l'�tre pour tous les composants du projet.\n"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:useJmsConfiguration"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('useJmsConfiguration',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "CMR_sendQueue_Txt"
          labelExpression = "aql:self.getFeatureLabel('sendQueue')"
          helpExpression = "File d'envoi par d�faut pour tous les services de lecture du composant, si on utilise la configuration JMS."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:sendQueue"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('sendQueue',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "CMR_luwSendQueue_Txt"
          labelExpression = "aql:self.getFeatureLabel('luwSendQueue')"
          helpExpression = "File d'envoi par d�faut pour tous les services LUW (mise � jour) du composant, si on utilise la configuration JMS."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:luwSendQueue"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('luwSendQueue',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "CMR_replyQueue_Txt"
          labelExpression = "aql:self.getFeatureLabel('replyQueue')"
          helpExpression = "File de retour par d�faut pour tous les services du composant, si on utilise la configuration JMS."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:replyQueue"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('replyQueue',newValue)"
            ]
          ]
        ]
        controls += SelectDescription.create[
          name = "CMR_conversionMode_Enum"
          labelExpression = "aql:self.getFeatureLabel('conversionMode')"
          helpExpression = "Valeur par d�faut pour le mode de conversion � l'encodage des donn�es MOM sur le composant. Lorsqu'on laisse la valeur par d�faut, la valeur par d�faut pour l'application est utilis�e."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:conversionMode"
          candidatesExpression = "aql:equinoxeCore::EConversionMode.eLiterals->collect(e|e.instance)"
          candidateDisplayExpression = "aql:candidate.toString()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('conversionMode',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "CMT_Conception_Group"
        domainClass = "equinoxeComposantsMetier.CMT"
        controls += SelectDescription.create[
          name = "CMT_level_Enum"
          labelExpression = "aql:self.getFeatureLabel('level')"
          helpExpression = "Caract�rise le niveau du CMT."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:level"
          candidatesExpression = "aql:equinoxeComposantsMetier::EnumCmtLevel.eLiterals->collect(e|e.instance)"
          candidateDisplayExpression = "aql:candidate.toString()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('level',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "CaConnector_Generation_Group"
        domainClass = "equinoxeComposantsMetier.CaConnector"
        controls += TextDescription.create[
          name = "CaConnector_connectorId_Txt"
          labelExpression = "aql:self.getFeatureLabel('connectorId')"
          helpExpression = "Identifiant du connecteur d�fini au niveau du Proxy."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:connectorId"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('connectorId',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "CmteCollectorClass_Conception_Group"
        domainClass = "equinoxeComposantsMetier.CmteCollectorClass"
        controls += ListDescription.create[
          name = "CmteCollectorClass_implementeLesInterfaces_Ref"
          labelExpression = "aql:self.getFeatureLabel('implementeLesInterfaces')"
          helpExpression = "Interfaces de conception impl�ment�es par le collecteur."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:implementeLesInterfaces"
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
                browseExpression = "aql:self.eqxAddFromTreeView('implementeLesInterfaces',true)"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxRemove('implementeLesInterfaces',selection)"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Monter"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.performMoveCommandUp('implementeLesInterfaces',selection)"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Descendre"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.performMoveCommandDown('implementeLesInterfaces',selection)"
              ]
            ]
          ]
        ]
        controls += EqxHyperlinkDescription.create[
          name = "CmteCollectorClass_superType_Ref"
          labelExpression = "aql:self.getFeatureLabel('superType')"
          helpExpression = "Lien d'h�ritage de l'�l�ment"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:superType"
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
                browseExpression = "aql:self.eqxSetFromTreeView('superType')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('superType')"
              ]
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "CmteCollectorMethod_Conception_Group"
        domainClass = "equinoxeComposantsMetier.CmteCollectorMethod"
        controls += EqxHyperlinkDescription.create[
          name = "CmteCollectorMethod_collectedFormat_Ref"
          labelExpression = "aql:self.getFeatureLabel('collectedFormat')"
          helpExpression = "Format qui va accueillir les donn�es collect�es par la m�thode."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:collectedFormat"
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
                browseExpression = "aql:self.eqxSetFromTreeView('collectedFormat')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('collectedFormat')"
              ]
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "CmteCollectorMethod_dataIdentifier_Txt"
          labelExpression = "aql:self.getFeatureLabel('dataIdentifier')"
          helpExpression = "Identifiant utilis� dans le dictionnaire de donn�e"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:dataIdentifier"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('dataIdentifier',newValue)"
            ]
          ]
        ]
        controls += TextDescription.create[
          name = "CmteCollectorMethod_dataName_Txt"
          labelExpression = "aql:self.getFeatureLabel('dataName')"
          helpExpression = "Nom associ�e � la donn�e collect�e et permettant de diff�rencier un m�me format (ex: Client) utilis� par deux m�thodes de collecte (ex: collectEmprunteur() collectCoEmprunteur() ).\nCe nom sert � initialiser le nom de la m�thode qui n'est pas en saisie libre."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:dataName"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('dataName',newValue)"
            ]
          ]
          style = TextWidgetStyle.create[
            labelFontFormat += org.eclipse.sirius.viewpoint.FontFormat.getByName("bold")
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "CmteCollectorRef_Conception_Group"
        domainClass = "equinoxeComposantsMetier.CmteCollectorRef"
        controls += EqxHyperlinkDescription.create[
          name = "CmteCollectorRef_collecteurUtilise_Ref"
          labelExpression = "aql:self.getFeatureLabel('collecteurUtilise')"
          helpExpression = "D�finition du collecteur utilis�."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:collecteurUtilise"
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
                browseExpression = "aql:self.eqxSetFromTreeView('collecteurUtilise')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('collecteurUtilise')"
              ]
            ]
          ]
        ]
        controls += CustomDescription.create[
          name = "CmteCollectorRef_rang_Eqx_Spinner"
          labelExpression = "aql:self.getFeatureLabel('rang')"
          helpExpression = "Rang du Collecteur utilis�."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          customExpressions += CustomExpression.create[
            name = "valueExpression"
            customExpression = "feature:rang"
          ]
          customExpressions += CustomExpression.create[
            name = "valueSetter"
            customExpression = "aql:self.eqxPut('rang',newValue)"
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "CmteDocTypeTech_Conception_Group"
        domainClass = "equinoxeComposantsMetier.CmteDocTypeTech"
        controls += TextDescription.create[
          name = "CmteDocTypeTech_intitule_Txt"
          labelExpression = "aql:self.getFeatureLabel('intitule')"
          helpExpression = "Intitul� du Document"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:intitule"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('intitule',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "CmteFacadePackage_Conception_Group"
        domainClass = "equinoxeComposantsMetier.CmteFacadePackage"
        controls += EqxHyperlinkDescription.create[
          name = "CmteFacadePackage_realisationDe_Ref"
          labelExpression = "aql:self.getFeatureLabel('realisationDe')"
          helpExpression = "La Facade principale r�alise l'interface principale du CMTE."
          isEnabledExpression = "aql:false"
          valueExpression = "feature:realisationDe"
          displayExpression = "aql:value.getEqxLabel()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:selection.selectInEqxExplorerView()"
            ]
          ]
          style = HyperlinkWidgetStyle.create[
            labelFontFormat += org.eclipse.sirius.viewpoint.FontFormat.getByName("italic")
            labelFontFormat += org.eclipse.sirius.viewpoint.FontFormat.getByName("bold")
            labelForegroundColor = (extras.get("Color#gray") as SystemColor)
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "CmteInterfacePackage_Generation_Group"
        domainClass = "equinoxeComposantsMetier.CmteInterfacePackage"
        controls += SelectDescription.create[
          name = "CmteInterfacePackage_proxyImplementationStrategy_Enum"
          labelExpression = "aql:self.getFeatureLabel('proxyImplementationStrategy')"
          helpExpression = ""
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:proxyImplementationStrategy"
          candidatesExpression = "aql:equinoxeComposantsMetier::EnumProxyImplementationStrategy.eLiterals->collect(e|e.instance)"
          candidateDisplayExpression = "aql:candidate.toString()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('proxyImplementationStrategy',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "ComputedBoAttribute_Conception_Group"
        domainClass = "equinoxeComposantsMetier.ComputedBoAttribute"
        controls += ListDescription.create[
          name = "ComputedBoAttribute_attributsIntervenants_Ref"
          labelExpression = "aql:self.getFeatureLabel('attributsIntervenants')"
          helpExpression = "Liste des attributs intervenants dans le calcul de la valeur de cet attribut."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:attributsIntervenants"
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
                browseExpression = "aql:self.eqxAddFromTreeView('attributsIntervenants',true)"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxRemove('attributsIntervenants',selection)"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Monter"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.performMoveCommandUp('attributsIntervenants',selection)"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Descendre"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.performMoveCommandDown('attributsIntervenants',selection)"
              ]
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "ConnectorMethod_Conception_Group"
        domainClass = "equinoxeComposantsMetier.ConnectorMethod"
        controls += SelectDescription.create[
          name = "ConnectorMethod_emissionMode_Enum"
          labelExpression = "aql:self.getFeatureLabel('emissionMode')"
          helpExpression = ""
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:emissionMode"
          candidatesExpression = "aql:equinoxeComposantsMetier::EnumConnectorMethodModeEmission.eLiterals->collect(e|e.instance)"
          candidateDisplayExpression = "aql:candidate.toString()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('emissionMode',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "ConnectorMethod_Generation_Group"
        domainClass = "equinoxeComposantsMetier.ConnectorMethod"
        controls += TextDescription.create[
          name = "ConnectorMethod_remoteServiceName_Txt"
          labelExpression = "aql:self.getFeatureLabel('remoteServiceName')"
          helpExpression = "Nom du service distant auquel se connecte cette m�thode. Par d�faut, il s'agit du nom de la m�thode."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:remoteServiceName"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('remoteServiceName',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "FacadeMethod_Conception_Group"
        domainClass = "equinoxeComposantsMetier.FacadeMethod"
        controls += SelectDescription.create[
          name = "FacadeMethod_visibility_Enum"
          labelExpression = "aql:self.getFeatureLabel('visibility')"
          helpExpression = "Visibilit� (Java) de la m�thode."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:visibility"
          candidatesExpression = "aql:equinoxeCore::EVisibilityFeature.eLiterals->collect(e|e.instance)"
          candidateDisplayExpression = "aql:candidate.toString()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('visibility',newValue)"
            ]
          ]
        ]
        controls += ListDescription.create[
          name = "FacadeMethod_possibleErrors_Ref"
          labelExpression = "aql:self.getFeatureLabel('possibleErrors')"
          helpExpression = "Erreurs fonctionnelles qui peuvent �tre renvoy�es par la m�thode de Facade. Les erreurs disponibles sont les erreurs fonctionnelles du composant (publiques ou internes) ou des erreurs fonctionnelles de l'interface d'un composant dont d�pend le composant."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:possibleErrors"
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
                browseExpression = "aql:self.eqxAddFromTreeView('possibleErrors',true)"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxRemove('possibleErrors',selection)"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Monter"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.performMoveCommandUp('possibleErrors',selection)"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Descendre"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.performMoveCommandDown('possibleErrors',selection)"
              ]
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "FacadeMethod_Generation_Group"
        domainClass = "equinoxeComposantsMetier.FacadeMethod"
        controls += CheckboxDescription.create[
          name = "FacadeMethod_throwsExceptions_Check"
          labelExpression = "aql:self.getFeatureLabel('throwsExceptions')"
          helpExpression = "Indique que la m�thode peut lever des exceptions."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:throwsExceptions"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('throwsExceptions',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "FacadeRealization_Generation_Group"
        domainClass = "equinoxeComposantsMetier.FacadeRealization"
        controls += TextDescription.create[
          name = "FacadeRealization_dsName_Txt"
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
        name = "FacadeRealizationGroup_Conception_Group"
        domainClass = "equinoxeComposantsMetier.FacadeRealizationGroup"
        controls += ListDescription.create[
          name = "FacadeRealizationGroup_realizationOf_Ref"
          labelExpression = "aql:self.getFeatureLabel('realizationOf')"
          helpExpression = "Interfaces M�tier du Composant que r�alise la Facade. Ces interfaces doivent toutes �tre du m�me type (classiques ou WebService). Une interface requise doit �tre impl�ment�e par une interface m�tier du composant avant d'�tre � son tour r�alis�e par la Facade."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:realizationOf"
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
                browseExpression = "aql:self.eqxAddFromTreeView('realizationOf',true)"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxRemove('realizationOf',selection)"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Monter"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.performMoveCommandUp('realizationOf',selection)"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Descendre"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.performMoveCommandDown('realizationOf',selection)"
              ]
            ]
          ]
        ]
        controls += CheckboxDescription.create[
          name = "FacadeRealizationGroup_remoteAccess_Check"
          labelExpression = "aql:self.getFeatureLabel('remoteAccess')"
          helpExpression = ""
          isEnabledExpression = "aql:false"
          valueExpression = "feature:remoteAccess"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('remoteAccess',newValue)"
            ]
          ]
          style = CheckboxWidgetStyle.create[
            labelFontFormat += org.eclipse.sirius.viewpoint.FontFormat.getByName("italic")
            labelForegroundColor = (extras.get("Color#gray") as SystemColor)
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "InterfaceCm_Generation_Group"
        domainClass = "equinoxeComposantsMetier.InterfaceCm"
        controls += SelectDescription.create[
          name = "InterfaceCm_proxyImplementationStrategy_Enum"
          labelExpression = "aql:self.getFeatureLabel('proxyImplementationStrategy')"
          helpExpression = "Strat�gie d'impl�mentation de l'interface."
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:proxyImplementationStrategy"
          candidatesExpression = "aql:equinoxeComposantsMetier::EnumProxyImplementationStrategy.eLiterals->collect(e|e.instance)"
          candidateDisplayExpression = "aql:candidate.toString()"
          initialOperation = InitialOperation.create[
            firstModelOperations = ChangeContext.create[
              browseExpression = "aql:self.eqxPut('proxyImplementationStrategy',newValue)"
            ]
          ]
        ]
      ]
      groups += GroupDescription.create[
        name = "RelatedBO_Conception_Group"
        domainClass = "equinoxeComposantsMetier.RelatedBO"
        controls += EqxHyperlinkDescription.create[
          name = "RelatedBO_superType_Ref"
          labelExpression = "aql:self.getFeatureLabel('superType')"
          helpExpression = "Lien d'h�ritage de cet �l�ment"
          isEnabledExpression = "aql:self.isNotReadOnlyElement()"
          valueExpression = "feature:superType"
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
                browseExpression = "aql:self.eqxSetFromTreeView('superType')"
              ]
            ]
          ]
          actions += WidgetAction.create[
            labelExpression = "Retirer"
            initialOperation = InitialOperation.create[
              firstModelOperations = ChangeContext.create[
                browseExpression = "aql:self.eqxUnset('superType')"
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
