<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@page import="modula.journal.Evenement"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.localization.Language"%>
<%@page import="org.coin.db.CoinDatabaseUtil"%>
<%@page import="modula.journal.TypeEvenement"%>
<%@page import="org.coin.db.CoinDatabaseWhereClause"%>
<%@page import="org.coin.util.CalendarUtil"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.util.Outils"%>
<%@page import="modula.journal.EvenementSeverite"%>
<%@page import="org.coin.security.PreventInjection"%>
<%@ page import="org.coin.autoform.component.*,org.coin.autoform.component.searchengine.*,org.coin.autoform.*,org.coin.fr.bean.*,java.util.*" %>
<%@ include file="include/localization.jspf" %>
<%
	long sStartTime = System.currentTimeMillis();
	String sPageUseCaseId = "IHM-DESK-EVT";
	
	int iType = HttpUtil.parseInt("sType",request,0);

	Evenement evtCtx = new Evenement();
	evtCtx.setAbstractBeanLocalization(sessionLanguage.getId());
	TypeEvenement typeEvtCtx = new TypeEvenement();
	typeEvtCtx.setAbstractBeanLocalization(sessionLanguage.getId());
	
	String sTitle = locTitle.getValue(1,"Evénements");
	String sTitleSingulier = locTitle.getValue(2,"Evénement");
	String sGenerate = AutoFormSearchEngine.getLocalizedLabel(AutoFormSearchEngine.LABEL_GENERATE,(int)sessionLanguage.getId());
	
	String[] tabSearch = {evtCtx.getIdReferenceObjetLabel(),
			evtCtx.getIdTypeEvenementLabel(),
			evtCtx.getCommentaireLibreLabel(),
			typeEvtCtx.getIdUseCaseLabel(),
			evtCtx.getExceptionLabel(),
			evtCtx.getDateDebutEvenementLabel(),
			AutoFormSearchEngine.getLocalizedLabel(AutoFormSearchEngine.LABEL_KEYWORD,(int)sessionLanguage.getId())};
	
	String[] tabHeader = {evtCtx.getDateDebutEvenementLabel(),
			evtCtx.getIdReferenceObjetLabel(),
			evtCtx.getIdTypeEvenementLabel(),
			evtCtx.getCommentaireLibreLabel(),
			typeEvtCtx.getHorodatageLabel(),
			typeEvtCtx.getIdUseCaseLabel(),
			evtCtx.getIdUserLabel(),
			evtCtx.getIdEvenementSeveriteLabel(),
			evtCtx.getExceptionLabel()};
	
	String[] tabSearchItems = {locTitle.getValue(3,"De toute sévérité"),
			locTitle.getValue(4,"Avec et Sans horodatage"),
			localizeButton.getValue(35,"Avec"),
			localizeButton.getValue(36,"Sans"),
			locTitle.getValue(5,"Avec et Sans exception"),
			localizeButton.getValue(35,"Avec"),
            localizeButton.getValue(36,"Sans"),
            localizeButton.getValue(37,"du"),
            localizeButton.getValue(38,"au")};
	
	String[] tabResults = {AutoFormSearchEngine.getLocalizedLabel(AutoFormSearchEngine.LABEL_LIMIT_RESULT_YES,(int)sessionLanguage.getId()),
			AutoFormSearchEngine.getLocalizedLabel(AutoFormSearchEngine.LABEL_LIMIT_RESULT_NO,(int)sessionLanguage.getId())};
	
	String sObjectTypeName = ObjectType.getLocalizedLabel(iType,sessionLanguage.getId());
	if(Outils.isNullOrBlank(sObjectTypeName))
		sObjectTypeName = "";
	
	String sIdObjet = HttpUtil.parseStringBlank("sIdObjet",request);
	String sReference = HttpUtil.parseStringBlank("sReference",request);
	String sConstraint = "";
	String sUrlObjet = "";
	String sUrlName = "";
	String sIconName = "";
	boolean bAfficherHeaderObjet = false;
	if (!Outils.isNullOrBlank(sIdObjet)){
		bAfficherHeaderObjet = true;
		if (!Outils.isNullOrBlank(sReference))
			sReference = " réf. " + sReference ;
		else
			sReference = " réf. interne " + sIdObjet ;
		
		switch(iType)
		{
		case ObjectType.AFFAIRE:
			sConstraint = "mar.id_marche=" + sIdObjet;
			sUrlObjet = rootPath+"desk/marche/algorithme/affaire/afficherAffaire.jsp?iIdAffaire=" + sIdObjet ;
			sUrlName = "Revenir à l'affaire";
			sIconName = "affair.png";
			break;
			
		case ObjectType.COMMISSION:
			sConstraint = "com.id_commission=" + sIdObjet;
			sUrlObjet = rootPath+"desk/commission/afficherCommission.jsp?iIdCommission=" + sIdObjet ;
			sUrlName = "Revenir à la commission";
			sIconName = "commission.png";
			break;
			
		case ObjectType.ORGANISATION:
			sConstraint = "org.id_organisation=" + sIdObjet;
			sUrlObjet = rootPath+"desk/organisation/afficherOrganisation.jsp?iIdOrganisation=" + sIdObjet ;
			sUrlName = "Revenir à l'organisation";
			sIconName = "home.png";
			break;
			
		case ObjectType.PERSONNE_PHYSIQUE:
			sConstraint = "pp.id_personne_physique=" + sIdObjet;
			sUrlObjet = rootPath+"desk/organisation/afficherPersonnePhysique.jsp?iIdPersonnePhysique=" + sIdObjet ;
			sUrlName = "Revenir à la personne physique";
			sIconName = "user_male.png";
			break;
			
		case ObjectType.PLANIFICATION:
		       sConstraint = "planif.id_planification=" + sIdObjet;
		       sUrlObjet = rootPath+"desk/VFR/planification/displayPlanification.jsp?lId=" + sIdObjet ;
		       sUrlName = "Back to planification";
		       //sIconName = "user_male.png";
		       break;
		       
		case ObjectType.VEHICLE:
		     sConstraint = "veh.id_vehicle=" + sIdObjet;
		     sUrlObjet = rootPath+"desk/VFR/vehicle/displayVehicle.jsp?lId=" + sIdObjet ;
		     sUrlName = "Back to vehicle";
		     //sIconName = "user_male.png";
		     break;
		     
		case ObjectType.CONTRACT:
			sConstraint = "con.id_contract=" + sIdObjet;
            sUrlObjet = rootPath+"desk/VFR/contract/displayContract.jsp?lId=" + sIdObjet ;
            sUrlName = "Back to contract";
            //sIconName = "user_male.png";
		     break;

		case ObjectType.PARAPH_FOLDER :
			sConstraint = "pf.id_paraph_folder=" + sIdObjet;
	        sUrlObjet = rootPath+"desk/paraph/folder/displayParaphFolder.jsp?lId=" + sIdObjet ;
	        sUrlName = "Back to paraph folder";
	        //sIconName = "user_male.png";
		     break;
		}
	}
	
	switch((int)sessionLanguage.getId()){
    case Language.LANG_ENGLISH:
        sTitle = sObjectTypeName+" "+sTitle+" "+sReference;
        sTitleSingulier = sObjectTypeName+" "+sTitle;
        break;
    default:
    	sTitle = sTitle+" "+sObjectTypeName+" "+sReference;
        sTitleSingulier = sTitle+" "+sObjectTypeName;
        break;
    }

	AutoFormSearchEngine afMoteur =
		new AutoFormSearchEngine(response,
								request.getSession(),
								rootPath,
								sTitle,
								"afficherTousEvenements.jsp",
								"evenement",
								"evt",
								sTitleSingulier,
								sTitle,
								"id_evenement",
								"lIdEvenement");
	
	
	//TODO: administrer ca
	

	afMoteur.addOtherTable("type_evenement type", "evt.id_type_evenement = type.id_type_evenement");
	afMoteur.addOtherTable("coin_user usr", "evt.id_coin_user = usr.id_coin_user");
	afMoteur.addOtherTable("personne_physique ppuser", "usr.id_individual = ppuser.id_personne_physique");
	afMoteur.addOtherTable("evenement_severite sev", "evt.id_evenement_severite = sev.id_evenement_severite");
	
	afMoteur.addClauseInvariante("type.id_type_objet_modula="+iType);
	afMoteur.addHiddenToForm("sType", Integer.toString(iType));
	afMoteur.addURLParameter("sType="+Long.toString(iType));
	
	if(!Outils.isNullOrBlank(sConstraint))
		afMoteur.addClauseInvariante(sConstraint);
	if(!Outils.isNullOrBlank(sIdObjet)){
		afMoteur.addHiddenToForm("sIdObjet", sIdObjet);
		afMoteur.addURLParameter("sIdObjet="+sIdObjet);
	}
	if(!Outils.isNullOrBlank(sReference)){
		afMoteur.addHiddenToForm("sReference", sReference);
		afMoteur.addURLParameter("sReference="+sReference);
	}
	
	String sRef = "'SYST'";
	boolean bUseRef = true;
	switch(iType)
	{
	case ObjectType.SYSTEME:
		sRef = "'SYST'";
		bUseRef = false;
		break;

	case ObjectType.AFFAIRE:
		afMoteur.addOtherTable("marche mar", "evt.id_reference_objet = mar.id_marche");
		sRef = "mar.reference";
		break;
		
	case ObjectType.COMMISSION:
		afMoteur.addOtherTable("commission com", "evt.id_reference_objet = com.id_commission");
		sRef = "com.nom";
		break;
		
	case ObjectType.ORGANISATION:
		afMoteur.addOtherTable("organisation org", "evt.id_reference_objet = org.id_organisation");
		sRef = "org.raison_sociale";
		break;
		
	case ObjectType.PERSONNE_PHYSIQUE:
		afMoteur.addOtherTable("personne_physique pp", "evt.id_reference_objet = pp.id_personne_physique");
		//sRef = "CONCAT(pp.prenom,' ', pp.nom)";
		sRef = CoinDatabaseUtil.getSqlConcatFunction("ppuser.prenom","ppuser.nom");
		break;
		
	case ObjectType.PLANIFICATION:
	      afMoteur.addOtherTable("planification planif", "evt.id_reference_objet = planif.id_planification");
	      sRef = "planif.reference";
	      break;
	      
	case ObjectType.VEHICLE:
	     afMoteur.addOtherTable("vehicle veh", "evt.id_reference_objet = veh.id_vehicle");
	     sRef = "veh.vehicle_number";
	     break;
	     
	case ObjectType.CONTRACT:
	     afMoteur.addOtherTable("contract con", "evt.id_reference_objet = con.id_contract");
	     sRef = "con.reference";
	     break;

	case ObjectType.PARAPH_FOLDER:
	     afMoteur.addOtherTable("paraph_folder pf", "evt.id_reference_objet = pf.id_paraph_folder");
	     sRef = "pf.reference";
	     break;
	}

	afMoteur.setSelectPart(
		    	CoinDatabaseUtil.getSqlStandardDateFunction("evt.date_debut_evenement") + " as date_debut,"
		     	//"DATE_FORMAT(evt.date_debut_evenement,'%d/%m/%y %Hh%i') AS date_debut, "
				+sRef+" as ref, type.libelle as ref_type, "
				+ " evt.commentaire_libre as comment, "
				+ " type.horodatage as horo,"
				+ " type.id_use_case as cu, "
				+ CoinDatabaseUtil.getSqlConcatFunction("ppuser.prenom","ppuser.nom") + " as usr,"
				//+ " CONCAT(ppuser.prenom,' ',ppuser.nom) as usr," 
				+ " sev.libelle as sev_libelle," 
				+ " evt.exception as exc");

	// définition de l'entête
	//afMoteur.setHeaderWithDotComaToResultCpt("Date début;Référence;Type;Commentaire;horodatage;CU;User;Sévérité;Exception;&nbsp");
	afMoteur.addHeaderToResultCpt(tabHeader[0],"evt.date_debut_evenement");
	afMoteur.addHeaderToResultCpt(tabHeader[1],"ref");
	afMoteur.addHeaderToResultCpt(tabHeader[2],"ref_type");
	afMoteur.addHeaderToResultCpt(tabHeader[3],"comment");
	afMoteur.addHeaderToResultCpt(tabHeader[4],"horo");
	afMoteur.addHeaderToResultCpt(tabHeader[5],"cu");
	afMoteur.addHeaderToResultCpt(tabHeader[6],"usr");
	if(sessionUserHabilitation.isDebugSession()){
		afMoteur.addHeaderToResultCpt(tabHeader[7],"sev_libelle");
		afMoteur.addHeaderToResultCpt(tabHeader[8],"exc");
	}
	if(sessionUserHabilitation.isSuperUser())
	{
		afMoteur.addHeaderToResultCpt("&nbsp;");
	}
	
	AutoFormSECptSearchByKeyWord afRechMotCle = new AutoFormSECptSearchByKeyWord("afRechMotCle");
	afRechMotCle.setLabelValueForSelect("");
	afRechMotCle.setLabelValueForInputText(" "+tabSearch[6]+" ");
	//afRechMotCle.setClassName("af_se_component");
	if(bUseRef) afRechMotCle.addItem(tabSearch[0], sRef,AutoFormSearchEngine.TYPE_VARCHAR);
	afRechMotCle.addItem(tabSearch[1], "type.libelle",AutoFormSearchEngine.TYPE_VARCHAR);
	afRechMotCle.addItem(tabSearch[2], "evt.commentaire_libre",AutoFormSearchEngine.TYPE_TEXT);
	afRechMotCle.addItem(tabSearch[3], "type.id_use_case");
	afRechMotCle.addItem(tabSearch[4], "evt.exception");
    afRechMotCle.addItem("Id interne", "evt.id_evenement",AutoFormSearchEngine.TYPE_VARCHAR);

	AutoFormSECptSearchByMultiKeyWord afMultiKeyWord = new AutoFormSECptSearchByMultiKeyWord("afMultiKeyWord");
	afMultiKeyWord.setClassName("af_se_component");
	afMultiKeyWord.setSearchInit(afRechMotCle);
	afMultiKeyWord.setRootPath(rootPath);
	afMoteur.addSEComponent(afMultiKeyWord);
	
	if(sessionUserHabilitation.isDebugSession()){
		AutoFormSECptSearchSelection afSelectionSev = new AutoFormSECptSearchSelection("afSelectionSev", "");
		afSelectionSev.addItem(tabSearchItems[0], "");
		afSelectionSev.setConditionAndBeans("evt.id_evenement_severite",(Vector)EvenementSeverite.getAllStaticMemory() );
		afSelectionSev.setInSearchBlock(true);
		afMoteur.addSEComponent(afSelectionSev);
	}
	
	AutoFormSECptSearchSelection afSelectionHoro = new AutoFormSECptSearchSelection("afSelectionHoro", "");
	afSelectionHoro.addItem(tabSearchItems[1], "");
	afSelectionHoro.addItem(tabSearchItems[2], "type.horodatage=1");
	afSelectionHoro.addItem(tabSearchItems[3], "type.horodatage=0");
	afSelectionHoro.setInSearchBlock(true);
	afMoteur.addSEComponent(afSelectionHoro);
	
	if(sessionUserHabilitation.isDebugSession()){
		AutoFormSECptSearchSelection afSelectionExc = new AutoFormSECptSearchSelection("afSelectionExc", "");
		afSelectionExc.addItem(tabSearchItems[4], "");
		afSelectionExc.addItem(tabSearchItems[5], "evt.exception is not null");
		afSelectionExc.addItem(tabSearchItems[6], "evt.exception is null");
		afSelectionExc.setInSearchBlock(true);
		afMoteur.addSEComponent(afSelectionExc);
	}
	
	AutoFormSEBetween afBetween = new AutoFormSEBetween("afBetween",tabSearch[5],"evt.date_debut_evenement");
	afBetween.setId("afBetween");
	AutoFormCptDate inf = new AutoFormCptDate(" "+tabSearchItems[7]+" ");
	inf.setId("inf");
	inf.setName("inf");
	afBetween.setAfCptBorneInf(inf);
	AutoFormCptDate sup = new AutoFormCptDate(" "+tabSearchItems[8]+" ");
	sup.setId("sup");
	sup.setName("sup");
	afBetween.setAfCptBorneSup(sup);
	afMoteur.addSEComponent(afBetween);
	
	// Initialisation des formulaires
	afMoteur.setFromForm(request, "");

	afMoteur.load();

	// Récupération des résultats
	Vector<Hashtable<String,String> >  vResults = afMoteur.getResults();

	/**
	 * Optimisation
	 */
	CoinDatabaseWhereClause wcEvenement = new CoinDatabaseWhereClause(CoinDatabaseWhereClause.ITEM_TYPE_INTEGER);

	for(int iLigne=0;iLigne<vResults.size();iLigne++){
		Hashtable hashResult =  vResults.get(iLigne);
        long lId = Long.parseLong((String) hashResult.get(afMoteur.getIdInTable()));
        wcEvenement.add(lId);
    }
	

    Vector<Evenement>  vEvenement
        = Evenement.getAllWithWhereAndOrderByClauseStatic(
              " WHERE " + wcEvenement.generateWhereClause("id_evenement"),
              "");


	   // Intégration des résultats dans les cellules des lignes
	for(int iLigne=0;iLigne<vResults.size();iLigne++){
		AutoFormSEMatrixListLine afLine = new AutoFormSEMatrixListLine(rootPath);
		Hashtable hashResult =  vResults.get(iLigne);
		long lId = Long.parseLong((String) hashResult.get(afMoteur.getIdInTable()));
		Evenement evt = Evenement.getEvenement((int)lId, vEvenement);
		
        //afLine.addCell((String) hashResult.get("date_debut"));
        afLine.addCell(CalendarUtil.getDateFormattee(evt.getDateDebutEvenement()));
		afLine.addCell((String) hashResult.get("ref"));
		afLine.addCell((String) hashResult.get("ref_type"));
		afLine.addCell( Outils.getTextToHtml((String)hashResult.get("comment")) + "<br/>"
				+ Outils.getTextToHtml( evt.getException()));
		try {
			afLine.addCell(((String) hashResult.get("horo")).equalsIgnoreCase("1")?tabResults[0]:tabResults[1]);
		}catch (Exception e) {
			afLine.addCell(tabResults[1]);
		}
		afLine.addCell((String)hashResult.get("cu"));
		afLine.addCell((String) hashResult.get("usr"));
		if(sessionUserHabilitation.isDebugSession()){
			afLine.addCell((String) hashResult.get("sev_libelle"));
			String sException = (String)hashResult.get("exc");
			if(!Outils.isNullOrBlank(sException)){
				afLine.addCell(tabResults[0]);
				String sToolTip = "Exception : "+(String) hashResult.get("exc");
				sToolTip = Outils.replaceDoubleCoteSlashes(PreventInjection.preventForJavascript(sToolTip));
				afLine.setOnMouseOver("new mt.component.ToolTip(this, '"+sToolTip+"')");
			}else{
				afLine.addCell(tabResults[1]);
			}
		}
		

		String sUrlDisplayEvt = rootPath 
				+ "desk/journal/afficherEvenement.jsp?"
				+ "iIdEvenement=" + lId
				+ "&"+afMoteur.getGeneratedParametersForURL();
		afLine.setURLToOpen(
				response.encodeURL(sUrlDisplayEvt));

		if(sessionUserHabilitation.isSuperUser())
		{
			afLine.setURLToRemove("javascript:removeEvent('"+lId+"');");
			afLine.setOnClickActivate(false);
		}
		
		afMoteur.addLineToResultCpt(afLine);
	}
	
	if(bAfficherHeaderObjet){
		afMoteur.addBoutonToBar(
					sUrlName,
					response.encodeURL(sUrlObjet),
					rootPath+"images/icons/36x36/" + sIconName);
	}

	//include file="../include/checkHabilitationPage.jspf"
%>
<link rel="stylesheet" type="text/css" href="<%= rootPath %>include/component/calendar/calendar.css" media="screen" />
<script type="text/javascript" src="<%= rootPath %>include/component/calendar/calendar.js"></script>
<script type="text/javascript" >
function removeEvent(lId)
{
	if( !confirm("Voulez-vous vraiment supprimer cet événement ?") ) 
	{
		return;
	}
	Redirect('<%=
		response.encodeRedirectURL(
			"modifierEvenement.jsp?sAction=remove&"+afMoteur.getGeneratedParametersForURL()) %>&iIdEvenement=' + lId);
}
</script>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<div id="search" style="padding:15px">
	<%= afMoteur.getHTMLBody() %>
	<%
	long sEndTime = System.currentTimeMillis();
	%>
	<%= sGenerate +" "+ (sEndTime - sStartTime) + " ms"  %>
</div>

<table>
<tr class="liste0" onmouseover="new mt.component.ToolTip(this, 'Exception : \' You have near \'null ');" >
<td></td>
</tr>
</table>

<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>
