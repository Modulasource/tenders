<%@page import="mt.common.addressbook.AddressBookUtil"%>
<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@page import="org.apache.commons.collections.CollectionUtils"%>
<%@page import="org.coin.bean.organigram.Organigram"%>
<%@page import="org.coin.bean.organigram.OrganigramNode"%>
<%@page import="org.coin.bean.organigram.OrganigramNodeType"%>
<%@page import="org.coin.bean.document.*,org.coin.bean.editorial.*,org.coin.bean.html.*,modula.graphic.*,org.coin.fr.bean.*,modula.commission.*,org.coin.util.*,modula.marche.*,org.coin.bean.*" %>
<%@page import="org.coin.bean.boamp.BoampCPFItem"%>
<%@page import="org.coin.bean.conf.TreeviewNode"%>
<%@page import="org.coin.bean.conf.TreeviewParsing"%>
<%@page import="org.coin.bean.geo.util.GeoCenter"%>
<%@page import="mt.modula.JavascriptVersionModula"%>
<%@page import="mt.common.addressbook.habilitation.DisplayOrganizationHabilitation"%>
<%@page import="mt.common.addressbook.ldap.AddressBookLdapConnector"%>
<%@page import="org.coin.fr.bean.export.ExportAddressBookXls"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.util.Collection"%>
<%@page import="java.util.Collections"%>
<%@page import="javax.naming.ldap.LdapContext"%>
<%@page import="javax.naming.ldap.InitialLdapContext"%>
<%@page import="javax.naming.Context"%>
<%@page import="java.util.Hashtable"%>
<%@page import="javax.naming.NamingEnumeration"%>
<%@page import="javax.naming.directory.SearchControls"%>
<%@page import="javax.naming.directory.SearchResult"%>
<%@page import="javax.naming.directory.Attributes"%>
<%@page import="javax.naming.directory.Attribute"%>
<%@page import="org.coin.ldap.LdapConnection"%>
<%@ include file="pave/localizationObject.jspf" %>
<%
	String sTitle = "Informations sur l'organisme";
	String sFormPrefix = "";
	String sAction = HttpUtil.parseStringBlank("sAction", request);
	int iIdOnglet = HttpUtil.parseInt("iIdOnglet", request , 0);
	String sMessage = HttpUtil.parseStringBlank("sMessage", request);
	Connection conn = ConnectionManager.getConnection();
	request.setAttribute("conn", conn);
	String sTheme = Theme.getTheme();
	
	int iIdOrganisation = -1;
	try{
		iIdOrganisation = Integer.parseInt(request.getParameter("iIdOrganisation"));
	} catch (Exception e)
	{
		try {iIdOrganisation = Integer.parseInt(request.getParameter("iIdReferenceObjet"));
		}
		catch (Exception ee) 
		{
			iIdOrganisation = Integer.parseInt(request.getParameter("iIdObjetReferenceSource"));
		}
	}
	
	Organisation organisation = Organisation.getOrganisation(iIdOrganisation);
	organisation.setAbstractBeanLocalization(sessionLanguage);

	request.setAttribute("organisation", organisation);
	request.setAttribute("localizeButton",  localizeButton);
	request.setAttribute("sAction",  sAction);

	Adresse adresse = null;
	Pays pays = null;
	try {
		adresse = Adresse.getAdresse(organisation.getIdAdresse());
		pays = Pays.getPays(adresse.getIdPays());
	} catch(Exception e){
		adresse = new Adresse();
		pays = new Pays();
	}
	
	adresse.setAbstractBeanLocalization(organisation);
	pays.setAbstractBeanLocalization(organisation);
	request.setAttribute("adresse", adresse);
	request.setAttribute("pays", pays);

	
	boolean bUseGeoloc = Configuration.isEnabledMemory("design.desk.organisation.geoloc", false) ;
	boolean bUseZipCodeTownSync = Configuration.isEnabledMemory("design.desk.organisation.zipcode.town.sync", false) ;

	
	String sOrganisationTypeName = OrganisationType.getOrganisationTypeName(organisation.getIdOrganisationType());
	
	

    PersonnePhysique personneUser = PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual() );
    
	DisplayOrganizationHabilitation doh = new DisplayOrganizationHabilitation();
	request.setAttribute("doh", doh);
	doh.sTitle = sTitle;
	doh.update(organisation, personneUser, sessionUserHabilitation);
	
	
	

	String sPageUseCaseId = doh.sPageUseCaseId;
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId );
	
	
	
	String sUseCaseIdBoutonModifierOrganisation = doh.sUseCaseIdBoutonModifierOrganisation;
	String sUseCaseIdBoutonSupprimerOrganisation = doh.sUseCaseIdBoutonSupprimerOrganisation;
	String sUseCaseIdBoutonAjouterPersonne = doh.sUseCaseIdBoutonAjouterPersonne;
	String sUseCaseIdBoutonAjouterGerant = doh.sUseCaseIdBoutonAjouterGerant;
	String sUseCaseIdBoutonTransfererGerance = doh.sUseCaseIdBoutonTransfererGerance;
	String sUseCaseIdBoutonAjouterActionManuelle = doh.sUseCaseIdBoutonAjouterActionManuelle;
	String sUseCaseIdBoutonAfficherJournalEvt = doh.sUseCaseIdBoutonAfficherJournalEvt;
	String sUseCaseIdBoutonAjouterCommission = doh.sUseCaseIdBoutonAjouterCommission;
	String sUseCaseIdBoutonAfficherExport = doh.sUseCaseIdBoutonAfficherExport;
	String sUseCaseIdBoutonAjouterLogo = doh.sUseCaseIdBoutonAjouterLogo;
	String sUseCaseIdBoutonAjouterDocument = doh.sUseCaseIdBoutonAjouterDocument;
	String sUseCaseIdBoutonAfficherDocument = doh.sUseCaseIdBoutonAfficherDocument;
	String sUseCaseIdBoutonAjouterEditorial = doh.sUseCaseIdBoutonAjouterEditorial;
	String sUseCaseIdBoutonAfficherEditorial = doh.sUseCaseIdBoutonAfficherEditorial;
	String sUseCaseIdBoutonAfficherCharteGraphique = doh.sUseCaseIdBoutonAfficherCharteGraphique;
	String sUseCaseIdBoutonAfficherOngletAdministration = doh.sUseCaseIdBoutonAfficherOngletAdministration;
	String sUseCaseIdBoutonAdminParaph = doh.sUseCaseIdBoutonAdminParaph;
	String sUseCaseIdButtonPrepareSummaryNotice = doh.sUseCaseIdButtonPrepareSummaryNotice;

	sTitle = doh.sTitle;
	
	
	String sTabNameAdministativeData = locTabs.getValue(1,"Données administratives") ;
 	String sTabNameIdentity = locTabs.getValue(2,"Coordonnées");
 	String sTabNameAdress = locTabs.getValue(3,"Adresse");
 	String sTabNameCollaborator = locTabs.getValue(4,"Personnes");
 	String sTabNameCommission = locTabs.getValue(5,"Commission");
 	String sTabNameAdministration = locTabs.getValue(6,"Administration");
 	String sTabNamePublicationData = locTabs.getValue(7,"Informations Publication");
 	String sTabNameGraphicCharter = locTabs.getValue(8,"Charte graphique");
 	String sTabNameTransfert = locTabs.getValue(9,"Transfert");
 	String sTabNameParameter = locTabs.getValue(10,"Paramètres");
	String sTabNameOpportunity = locTabs.getValue(11,"Affaires");
	String sTabNameGED = locTabs.getValue(12,"GED");
	String sTabNameAideRedac = locTabs.getValue(13,"Aides rédactionnelles");
	String sTabNameClasseurs = locTabs.getValue(28,"Classeurs");
	String sTabNameProprietes = locTabs.getValue(29,"Propriétés");
	String sTabNameLDAP = locTabs.getValue(27,"LDAP");
	String sTabNamePA = locTabs.getValue(30,"P. A.");
	String sBlocNameAddress = locBloc.getValue(3, "Adresse générale");
	

	
	sTitle = locTitle.getValue(1,"Organisme");
	
	
	/**
	 * Tabs
	 */
    sTitle = sTitle + " : <span class='altColor'>"+organisation.getRaisonSociale() +"</span>";
	
	
	Onglet.sNotCurrentTabStyle = " class='onglet_non_selectionne' "; 
	Onglet.sCurrentTabStyle =  " class='onglet_selectionne' ";
	Onglet.sNotCurrentTabStyleInCreation = " class='onglet_non_selectionne' ";
	Onglet.sCurrentTabStyleInCreation =  " class='onglet_selectionne' ";
	Onglet.sEnddingTabStyle =  " class='onglet_vide_dernier' ";

	String sURLParam = "&iIdOrganisation="+organisation.getIdOrganisation()+"&nonce=" + System.currentTimeMillis();
	
	Vector<Onglet> vOnglets = new Vector<Onglet>();
	vOnglets.add( new Onglet(Onglet.ONGLET_ORGANISATION_DONNEES_ADMINISTRATIVES, false, (doh.bGroupPersoData?sTabNameIdentity:sTabNameAdministativeData), response.encodeURL("afficherOrganisation.jsp?iIdOnglet="+Onglet.ONGLET_ORGANISATION_DONNEES_ADMINISTRATIVES+sURLParam)) ); 
	vOnglets.add( new Onglet(Onglet.ONGLET_ORGANISATION_COORDONNEES, false, sTabNameIdentity, response.encodeURL("afficherOrganisation.jsp?iIdOnglet="+Onglet.ONGLET_ORGANISATION_COORDONNEES+sURLParam),doh.bGroupPersoData) ); 
	vOnglets.add( new Onglet(Onglet.ONGLET_ORGANISATION_ADRESSE, false, sTabNameAdress, response.encodeURL("afficherOrganisation.jsp?iIdOnglet="+Onglet.ONGLET_ORGANISATION_ADRESSE+sURLParam),doh.bGroupPersoData) ); 
	vOnglets.add( new Onglet(Onglet.ONGLET_ORGANISATION_PERSONNES, false, sTabNameCollaborator, response.encodeURL("afficherOrganisation.jsp?iIdOnglet="+Onglet.ONGLET_ORGANISATION_PERSONNES+sURLParam)) ); 
	vOnglets.add( new Onglet(Onglet.ONGLET_ORGANISATION_COMMISSIONS, false, sTabNameCommission, response.encodeURL("afficherOrganisation.jsp?iIdOnglet="+Onglet.ONGLET_ORGANISATION_COMMISSIONS+sURLParam), true) ); 
	
	vOnglets.add( new Onglet(Onglet.ONGLET_ORGANISATION_ADMIN, false, sTabNameAdministration, response.encodeURL("afficherOrganisation.jsp?iIdOnglet="+Onglet.ONGLET_ORGANISATION_ADMIN+sURLParam), !doh.bGroupAdminData) );
	
	vOnglets.add( new Onglet(Onglet.ONGLET_ORGANISATION_INFORMATION_PUBLICATION, false, sTabNamePublicationData, response.encodeURL("afficherOrganisation.jsp?iIdOnglet="+Onglet.ONGLET_ORGANISATION_INFORMATION_PUBLICATION+sURLParam),false,doh.bGroupAdminData) );
	vOnglets.add( new Onglet(Onglet.ONGLET_ORGANISATION_CHARTE_GRAPHIQUE, false, sTabNameGraphicCharter, response.encodeURL("afficherOrganisation.jsp?iIdOnglet="+Onglet.ONGLET_ORGANISATION_CHARTE_GRAPHIQUE+sURLParam),false,doh.bGroupAdminData) );
	vOnglets.add( new Onglet(Onglet.ONGLET_ORGANISATION_EXPORTS, false, sTabNameTransfert, response.encodeURL("afficherOrganisation.jsp?iIdOnglet="+Onglet.ONGLET_ORGANISATION_EXPORTS+sURLParam),false,doh.bGroupAdminData) ); 
	vOnglets.add( new Onglet(Onglet.ONGLET_ORGANISATION_PARAMETRES, false, sTabNameParameter, response.encodeURL("afficherOrganisation.jsp?iIdOnglet="+Onglet.ONGLET_ORGANISATION_PARAMETRES+sURLParam),false,doh.bGroupAdminData) ); 
	
	vOnglets.add( new Onglet(Onglet.ONGLET_ORGANISATION_AFFAIRES, false, sTabNameOpportunity, response.encodeURL("afficherOrganisation.jsp?iIdOnglet="+Onglet.ONGLET_ORGANISATION_AFFAIRES+sURLParam), true) ); 
    vOnglets.add( new Onglet(Onglet.ONGLET_ORGANISATION_AFFAIRE_PETITE_ANNONCE, false, sTabNamePA, response.encodeURL("afficherOrganisation.jsp?iIdOnglet="+Onglet.ONGLET_ORGANISATION_AFFAIRE_PETITE_ANNONCE+sURLParam), true) ); 
//	vOnglets.add( new Onglet(Onglet.ONGLET_ORGANISATION_GED, false, sTabNameGED, response.encodeURL("afficherOrganisation.jsp?iIdOnglet="+Onglet.ONGLET_ORGANISATION_GED+sURLParam), true) ); 
//	vOnglets.add( new Onglet(Onglet.ONGLET_ORGANISATION_AR, false, sTabNameAideRedac, response.encodeURL("afficherOrganisation.jsp?iIdOnglet="+Onglet.ONGLET_ORGANISATION_AR+sURLParam), true) );
	
	AddressBookUtil.createOrganizationTab(vOnglets,response,sURLParam,locTabs);
	
	if (sessionUserHabilitation.isSuperUser() && false)
	{
		vOnglets.add( new Onglet(Onglet.ONGLET_ORGANISATION_GROUP, false, locTabs.getValue(22,"Groupes"), response.encodeURL("afficherOrganisation.jsp?iIdOnglet="+Onglet.ONGLET_ORGANISATION_GROUP+sURLParam), false));
		vOnglets.add( new Onglet(Onglet.ONGLET_ORGANISATION_ORGANIGRAM, false, locTabs.getValue(23,"Organigramme"), response.encodeURL("afficherOrganisation.jsp?iIdOnglet="+Onglet.ONGLET_ORGANISATION_ORGANIGRAM+sURLParam), false));
	}

	if(organisation.getIdOrganisationType() == OrganisationType.TYPE_ACHETEUR_PUBLIC)
	{
		if (sessionUserHabilitation.isSuperUser()
		 /** or controls if it the owner */
		|| organisation.isOwnerIndividual(sessionUser.getIdIndividual())
		|| organisation.getIdCreateur() == sessionUser.getIdIndividual())
		{
			vOnglets.add( new Onglet(Onglet.ONGLET_ORGANISATION_SERVICE, false, locTabs.getValue(21,"Services adm."), response.encodeURL("afficherOrganisation.jsp?iIdOnglet="+Onglet.ONGLET_ORGANISATION_SERVICE+sURLParam), false ));
		}
	}
	vOnglets.add( new Onglet(Onglet.ONGLET_ORGANISATION_BINDER, false, sTabNameClasseurs, response.encodeURL("afficherOrganisation.jsp?iIdOnglet="+Onglet.ONGLET_ORGANISATION_BINDER+sURLParam), false));
	vOnglets.add( new Onglet(Onglet.ONGLET_ORGANISATION_OWNER, false, sTabNameProprietes, response.encodeURL("afficherOrganisation.jsp?iIdOnglet="+Onglet.ONGLET_ORGANISATION_OWNER+sURLParam), true));
	vOnglets.add( new Onglet(Onglet.ONGLET_ORGANISATION_LDAP, false, sTabNameLDAP, response.encodeURL("afficherOrganisation.jsp?iIdOnglet="+Onglet.ONGLET_ORGANISATION_LDAP+sURLParam), true));
	
	Onglet onglet = Onglet.getOnglet(vOnglets,iIdOnglet);
	onglet.bIsCurrent = true;
	
	Onglet ongletInfoPub = Onglet.getOnglet(vOnglets,Onglet.ONGLET_ORGANISATION_INFORMATION_PUBLICATION );
	Onglet ongletTransf =  Onglet.getOnglet(vOnglets,Onglet.ONGLET_ORGANISATION_EXPORTS );
    Onglet ongletParam =  Onglet.getOnglet(vOnglets,Onglet.ONGLET_ORGANISATION_PARAMETRES );
    Onglet ongletPP =  Onglet.getOnglet(vOnglets,Onglet.ONGLET_ORGANISATION_PERSONNES );
    Onglet ongletCharteGraph =  Onglet.getOnglet(vOnglets,Onglet.ONGLET_ORGANISATION_CHARTE_GRAPHIQUE ); 
    Onglet ongletBinder = Onglet.getOnglet(vOnglets,Onglet.ONGLET_ORGANISATION_BINDER);
    Onglet ongletOwner = Onglet.getOnglet(vOnglets,Onglet.ONGLET_ORGANISATION_OWNER);
    Onglet ongletLdap = Onglet.getOnglet(vOnglets,Onglet.ONGLET_ORGANISATION_LDAP);
    Onglet ongletCom = Onglet.getOnglet(vOnglets,Onglet.ONGLET_ORGANISATION_COMMISSIONS);
    Onglet ongletAffaires = Onglet.getOnglet(vOnglets,Onglet.ONGLET_ORGANISATION_AFFAIRES);
    Onglet ongletPA = Onglet.getOnglet(vOnglets,Onglet.ONGLET_ORGANISATION_AFFAIRE_PETITE_ANNONCE);
    
    request.setAttribute("vOnglets", vOnglets); 

    
	
	if(sessionUserHabilitation.isSuperUser() ) {
		doh.bDisplayExternalReference = true;
	}
    
	if(organisation.getIdOrganisationType() == OrganisationType.TYPE_ACHETEUR_PUBLIC
	|| organisation.getIdOrganisationType() == OrganisationType.TYPE_ADMINISTRATEUR) 
	{
		if(sessionUserHabilitation.isSuperUser() ) {
			ongletLdap.bHidden = false;
		}
	}
	
	if(organisation.getIdOrganisationType() == OrganisationType.TYPE_ACHETEUR_PUBLIC) 
	{
		if(sessionUserHabilitation.isSuperUser() ) {
			Onglet ongletAP =  Onglet.getOnglet(vOnglets,Onglet.ONGLET_ORGANISATION_AFFAIRES );
			ongletAP.bHidden = false; 
		}
		
	    ongletPA.bHidden = false; 
	    ongletOwner.bHidden = false;
	}
	
	AddressBookUtil.organizeOrganizationTab(vOnglets,organisation,sessionUserHabilitation,doh, sTheme);
    
    
    if(organisation.getIdOrganisationType() == OrganisationType.TYPE_EXTERNAL
    || organisation.getIdOrganisationType() == OrganisationType.TYPE_EXTERNAL_CASUAL) 
    {
    	ongletInfoPub.bHidden = true; 
        ongletTransf.bHidden = true; 
        ongletParam.bHidden = true; 
        ongletPP.bHidden = false; 
        if(ongletBinder!=null) ongletBinder.bHidden = true; 
        doh.bDisplayExternalReference = true;
    }
    
    if(organisation.getIdOrganisationType() == OrganisationType.TYPE_ADMINISTRATEUR) 
    {
    	sUseCaseIdBoutonAfficherExport = "";
		sUseCaseIdBoutonAjouterDocument = "";
		sUseCaseIdBoutonAfficherDocument = "";
		sUseCaseIdBoutonAjouterEditorial = "";
		sUseCaseIdBoutonAfficherEditorial = "";
		sUseCaseIdBoutonAfficherCharteGraphique = "IHM-DESK-CG-002";  	
		ongletTransf.bHidden = false; 
	   	ongletInfoPub.bHidden = true; 
	}
	
	if(((organisation.getIdOrganisationType() == OrganisationType.TYPE_ACHETEUR_PUBLIC) 
	 || (organisation.getIdOrganisationType() == OrganisationType.TYPE_PUBLICATION))
		&&(sessionUserHabilitation.isHabilitate(sUseCaseIdBoutonAfficherCharteGraphique)))
	{
		ongletCharteGraph.bHidden = false; 
	}

	if ((organisation.getIdOrganisationType() == OrganisationType.TYPE_ACHETEUR_PUBLIC)
	 || (organisation.getIdOrganisationType() == OrganisationType.TYPE_CONSULTANT))
	{
		Onglet ongletAP = Onglet.getOnglet(vOnglets,Onglet.ONGLET_ORGANISATION_COMMISSIONS);
		ongletAP.bHidden = false; 
	}
	
	try{
		if(sessionUserHabilitation.isHabilitate(sUseCaseIdBoutonAfficherDocument))
		{
			Onglet ongletGED = Onglet.getOnglet(vOnglets,Onglet.ONGLET_ORGANISATION_GED);
			ongletGED.bHidden = false; 
		}
		
	    if(sessionUserHabilitation.isHabilitate(sUseCaseIdBoutonAfficherDocument))
	    {
	        Onglet ongletGED = Onglet.getOnglet(vOnglets,Onglet.ONGLET_ORGANISATION_GED);
	        ongletGED.bHidden = false; 
	    }
	} catch (Exception e){}
	
	if(!sessionUserHabilitation.isHabilitate(sUseCaseIdBoutonAfficherCharteGraphique))
	{
        ongletCharteGraph.bHidden = true; 
	}
	
	

	     
	if(!sessionUserHabilitation.isHabilitate(sUseCaseIdBoutonAfficherOngletAdministration))
	{
		Onglet.getOnglet(vOnglets,Onglet.ONGLET_ORGANISATION_ADMIN ).bHidden=true;
	}

	if(!sessionUserHabilitation.isSuperUser() && sAction.equals("store") ) { doh.bDisplayOwner = false; }
	
	/** Parapheur Tabs && Buttons **/
	if (sTheme.equalsIgnoreCase("paraph") || sPersonParamDeskDesignType.equals("outlook")){
		if (ongletInfoPub != null) ongletInfoPub.bHidden = true;
		if (ongletTransf != null) ongletTransf.bHidden = true;
		if (ongletCom != null) ongletCom.bHidden = true;
		if (ongletTransf != null) ongletTransf.bHidden = true;
		if (ongletAffaires != null) ongletAffaires.bHidden = true;
		if (ongletPA != null) ongletPA.bHidden = true;
		
		sUseCaseIdBoutonAjouterGerant = "";
		sUseCaseIdBoutonTransfererGerance = "";
		sUseCaseIdBoutonAjouterActionManuelle = "";
		sUseCaseIdBoutonAjouterCommission = "";
		sUseCaseIdBoutonAfficherExport = "";
		sUseCaseIdBoutonAjouterLogo = "";
		sUseCaseIdBoutonAjouterDocument = "";
		sUseCaseIdBoutonAfficherDocument = "";
		sUseCaseIdBoutonAjouterEditorial = "";
		sUseCaseIdBoutonAfficherEditorial = "";
		sUseCaseIdBoutonAfficherCharteGraphique = "";
		sUseCaseIdBoutonAfficherOngletAdministration = "";
		sUseCaseIdButtonPrepareSummaryNotice = "";

		/** Final users **/
		if (!sessionUserHabilitation.isSuperUser()){
			doh.bDisplayTypeActivity = false;
			
			if(ongletBinder!=null) ongletBinder.bHidden = true;
			if(ongletOwner!=null) ongletOwner.bHidden = true;
			if(ongletParam!=null) ongletParam.bHidden = true;
		}
	}

  	if( (ongletInfoPub == null || ongletInfoPub.bHidden)
  	&& ( ongletTransf == null || ongletTransf.bHidden)
  	&& (ongletParam == null || ongletParam.bHidden)
  	&& (ongletCharteGraph == null || ongletCharteGraph.bHidden) ){
  		Onglet.getOnglet(vOnglets,Onglet.ONGLET_ORGANISATION_ADMIN ).bHidden=true;
  	}
  	
	
	HtmlBeanTableTrPave hbFormulaire = new HtmlBeanTableTrPave();
	hbFormulaire.bIsForm = false;
	request.setAttribute("hbFormulaire", hbFormulaire);
%>
<script type="text/javascript" src="<%= rootPath + "include/js/desk/organisation/paveAdresse.js" %>" ></script>
<script type="text/javascript" src="<%= rootPath %>include/verification.js"></script>
<script type="text/javascript" src="<%= rootPath %>include/bascule.js" ></script>
<script type="text/javascript" src="<%= rootPath %>dwr/interface/CheckAjaxVerifField.js?v=<%= JavascriptVersionModula.VERIF_FIELD %>"></script>
<script type="text/javascript" src="<%= rootPath %>include/AjaxVerifField.js" ></script>
<script type="text/javascript" src="<%= rootPath %>include/AjaxComboList.js?v=<%= JavascriptVersion.AJAX_COMBO_LIST_JS %>"></script>
<%
	if(sAction.equals("store"))	
	{
%>
<script type="text/javascript">
<%@ include file="pave/modifierOrganisation.jspf" %>
</script>
<%
	}
%>
<script type="text/javascript">
    mt.config.enableAutoRoundPave = false;
	function onAfterPageLoading(){		
	<%
		if( iIdOnglet == Onglet.ONGLET_ORGANISATION_INFORMATION_PUBLICATION) {
			
		}
		else if (iIdOnglet == Onglet.ONGLET_ORGANISATION_DONNEES_ADMINISTRATIVES
				&& sAction.equals("store") && !doh.bHideDetailedData){
		%>
	   new AjaxComboList("iIdCategorieJuridique", "getCategorieJuridique");
	   new AjaxComboList("iIdCodeNaf", "getCodeNaf");
		<%
		}
	%>
	}

	function importPersonListFromExcelFile()
	{
		doUrl("<%=
			response.encodeURL( 
					rootPath + "desk/organisation/sync/syncPersonForm.jsp" 
					+ "?lIdOrganization=" + organisation.getId())
		%>");
	}
	
	
	function exportPersonListInExcelFile()
	{
<%
	    Localize locMessageLang = new Localize(
	    sessionLanguage.getId(),
	    LocalizationConstant.CAPTION_CATEGORY_LOGON_PAGE_MESSAGE);
%>
	    var title = "<%= localizeButton.getValueExport() %>";
	    var content = "";
	    content += '<div style="text-align:center;margin-top:5px;"><%= locMessageLang.getValue(3,"Langue") %> :&nbsp;'+ 
	        '<input type="hidden" name="langFileModal" id="langFileModal" value="<%= sessionLanguage.getId()%>" />'+
	        '<span id="langListModal" style="cursor:pointer" onclick="onClickSelectFlagModal(this);">'+
	            '<img border="0" src="<%= rootPath %>images/flags/<%= sessionLanguage.getShortLabel() %>.gif" />'+ 
	            '<span class="langNameModal"> <%= sessionLanguage.getName()  %></span>'+
	        '</span>'+
	        '<div id="langComboModal" style="width:100px;margin:0 auto;padding:2px;display:none;border: 1px solid #C2CCE0;background : #FFFFFF;">'+
	            '<table>'+
	            <%
	            Vector<Language> vLangPossible = Language.getAllStaticMemory();
	            for (Language langSelected : vLangPossible)
	            {
	                if(!Configuration.getConfigurationValueMemory("server.language.list", "")
	                        .contains(langSelected.getShortLabel()))
	                {
	                    continue;
	                }
	                langSelected.setAbstractBeanLocalization(langSelected.getId());
	            %>
	               '<tr id="langModal<%= langSelected.getId() %>" onclick="onClickSelectFlagModal(this)" style="cursor:pointer">'+
	                    '<td style="vertical-align:middle">'+
	                    '<img border="0" src="<%= rootPath %>images/flags/<%= langSelected.getShortLabel()%>.gif" />'+
	                    '</td>'+
	                    '<td style="text-align:left;vertical-align:middle">&nbsp;'+
	                    '<span class="langNameModal" id="<%= langSelected.getId() %>" > <%= langSelected.getName() %></span>'+
	                    '</td>'+
	                '</tr>'+
	            <%}%>
	            '</table>'+
	        '</div>'+ 
	        '</div>';   
	    var acceptTitle = "<%= localizeButton.getValueExport() %>";
	    acceptCallback = function(){
	        var langFile = "";
	        try{langFile = parent.document.getElementById("langFileModal").value;}
	        catch(e){langFile = document.getElementById("langFileModal").value;}
	        doUrl('<%= response.encodeURL(rootPath+"desk/AddressBookExportServlet?selected="+iIdOrganisation) %>&langFile='+langFile);
	        closeGlobalConfirm();
	    }
	    var refuseTitle = "<%=  localizeButton.getValueAbort()%>";
	    refuseCallback = function(){
	        closeGlobalConfirm();
	    }
	    openGlobalConfirm(title, content, acceptTitle, acceptCallback, refuseTitle, refuseCallback);        
	}
</script>
</head>
<body onload="onAfterPageLoading()">
<%@ include file="/include/new_style/headerFiche.jspf" %>
<br/>
<%@include file="pave/paveHeaderOrganisation.jspf" %>	
<br/>
<div class="tabFrame">
<%= Onglet.getAllTabsHtmlDesk(vOnglets) %>
<div class="tabContent">
<%	
	boolean bDisplayFormButton = false;
	boolean bDisplayButtonModify = false;
	if(sessionUserHabilitation.isHabilitate(sUseCaseIdBoutonModifierOrganisation)
	/** or controls if it the owner */
	|| organisation.isOwnerIndividual(sessionUser.getIdIndividual())
	|| organisation.getIdCreateur() == sessionUser.getIdIndividual()  )
	{
		if((iIdOnglet == Onglet.ONGLET_ORGANISATION_DONNEES_ADMINISTRATIVES )
		|| (iIdOnglet == Onglet.ONGLET_ORGANISATION_COORDONNEES)
		|| (iIdOnglet == Onglet.ONGLET_ORGANISATION_ADRESSE)
		|| (iIdOnglet == Onglet.ONGLET_ORGANISATION_INFORMATION_PUBLICATION)
		|| (iIdOnglet == Onglet.ONGLET_ORGANISATION_CHARTE_GRAPHIQUE)
		|| (iIdOnglet == Onglet.ONGLET_ORGANISATION_ADMIN)
		)
		{
			if(sAction.equals("store"))	
			{
				bDisplayFormButton = true;
			}
			else
			{
				bDisplayButtonModify = true;
			}
		}
	}
	
    /**
     * TODO_AG :
     * RG1 : ne pas enlever tant que les WS Alice ne sont pas activés
     * RG2 : sauf pour les entreprises n'ayant pas de ref ext
     */
    if(bDisplayButtonModify
    && !Configuration.isEnabledMemory("desk.addressbook.update", true))
    {
    	/**
    	 * Hide the button
    	 */
        bDisplayButtonModify = false;
    	
    	if(organisation.getIdOrganisationType() == OrganisationType.TYPE_CANDIDAT)
    	{
    	    if(organisation.getReferenceExterne() == null
    	    || organisation.getReferenceExterne().equals(""))
    	    {
    	    	/**
    	    	 * No synchronization expected, allow modification
    	    	 */
    	    	bDisplayButtonModify = true;
    	    }
    	}

    	/**
    	 * always ok for the super user
    	 */
    	if(sessionUserHabilitation.isSuperUser() )
        {
            bDisplayButtonModify = true;
        }
    }   
	
	
	if( bDisplayButtonModify)
	{
%>
	<div align="right" >
	<button 
		type="button"
		onclick="<%= response.encodeURL(
			"Redirect('afficherOrganisation.jsp?iIdOrganisation=" + organisation.getIdOrganisation()) 
			+ "&iIdOnglet=" + iIdOnglet 
			+ "&sAction=store" %>');"><%= localizeButton.getValueModify() %></button>
	</div>
	<br/>
<%
	}
	

	
	
	
	if( bDisplayFormButton)
	{
		hbFormulaire.bIsForm = true;
%>
	<form action="<%= response.encodeURL("modifierOrganisation.jsp")
		%>" method="post" name="formulaire" id="formulaire" onsubmit="return checkForm();">
	<div align="right" >
	<input type="hidden" name="sAction" value="store" />
	<input type="hidden" name="iIdOnglet" value="<%= iIdOnglet  %>" />
	<input type="hidden" name="iIdOrganisation" value="<%= organisation.getIdOrganisation() %>" />
	
	<button type="submit"><%= localizeButton.getValueSubmit() %></button>
	</div>
	<br/>
	<a name="ancreError"></a>
	<div class="rouge" style="text-align:left" id="divError"></div>
<%
	}
	if(!sMessage.equalsIgnoreCase(""))
	{
%>
<div class="rouge" style="text-align:left" id="message"><%= sMessage %></div>
<br />
<%
	}
	
	
	
	if( iIdOnglet == Onglet.ONGLET_ORGANISATION_DONNEES_ADMINISTRATIVES)
	{
%>
<jsp:include page="bloc/blocDisplayOrganizationAdminData.jsp">
<jsp:param value="<%= iIdOnglet %>" name="iIdOnglet" />
</jsp:include>
<%	
	} 
	
	
	

	if( iIdOnglet == Onglet.ONGLET_ORGANISATION_COORDONNEES)
	{
%>
<jsp:include page="bloc/blocDisplayOrganizationInformation.jsp">
<jsp:param value="<%= iIdOnglet %>" name="iIdOnglet" />
</jsp:include>
<%	
	}
	
	
	
	
	if( iIdOnglet == Onglet.ONGLET_ORGANISATION_BINDER)
	{
		String sUrlRedirect = rootPath + "desk/organisation/afficherOrganisation.jsp?iIdOnglet="+iIdOnglet;
		int iIdObjetReferenceSource = organisation.getIdOrganisation();
		long lIdReferenceObjectOwner =  organisation.getIdOrganisation();

		//file="../paraph/folder/binder/displayAllBinder.jsp"
	}

	
	
	
	
	

	
	if( iIdOnglet == Onglet.ONGLET_ORGANISATION_ADRESSE)
	{
		%><%@ include file="pave/blocGeoLocAddressBook.jspf" %><%


		%><div><%
		String sPaveAdresseTitre = sBlocNameAddress;
		if(sAction.equals("store"))
		{
			if(sessionUserHabilitation.isSuperUser() && bUseZipCodeTownSync )
			{
%><%@ include file="/desk/organisation/pave/blocZipCodeAndTownSyncForAddressBloc.jspf" %><%
			}
%><%@ include file="pave/paveAdresseForm.jspf" %><%
%><%@ include file="pave/blocGeoLocAddressBookFeatureForm.jspf" %><%
		}
		else
		{
%><%@ include file="pave/paveAdresse.jspf" %><%
%><%@ include file="pave/blocGeoLocAddressBookFeature.jspf" %><%
		}	
%><%@ include file="pave/blocGeoLocAddressBookMap.jspf" %><%

		%></div><%
	}
	
	
	
	
	
	
	if( iIdOnglet == Onglet.ONGLET_ORGANISATION_ADMIN) 
    {
%>
<jsp:include page="bloc/blocDisplayOrganizationAdmin.jsp">
<jsp:param value="<%= iIdOnglet %>" name="iIdOnglet" />
</jsp:include>
<%
    }

	
	
	
	
	
	if( iIdOnglet == Onglet.ONGLET_ORGANISATION_INFORMATION_PUBLICATION) 
	{
		if(sAction.equals("store"))
		{
			%><%@ include file="pave/paveOrganisationInfoPublicationsForm.jspf" %><%
		}
		else
		{
			%><%@ include file="pave/paveOrganisationInfoPublications.jspf" %><%
		}	
	}
	
	
	
	
	
	
	if( iIdOnglet == Onglet.ONGLET_ORGANISATION_PERSONNES)
	{
		if(OrganisationParametre.isEnabled(organisation.getId(), "addressbook.sync.excel", conn)){

		String sBtnValueExport = localizeButton.getValueExport() ;
		String sBtnValueExportEnabled = "";
		try{
			Multimedia m = ExportAddressBookXls.getAddressBookTemplate(conn);
		} catch (Exception e) {
			sBtnValueExport += "<br/>Error " + e.getMessage();
			sBtnValueExportEnabled = " disabled='disabled' ";
		}
%>
			<div style="text-align:center;margin-top:5px;">
				Synchronisation Excel :
				<button type="button" 
					<%= sBtnValueExportEnabled  %>
					onclick="javascript:exportPersonListInExcelFile()" ><%= sBtnValueExport %></button>
				<button type="button" 
					onclick="javascript:importPersonListFromExcelFile()" ><%= localizeButton.getValueImport() %></button>
			</div>
<%
		}

		if(doh.bDisplayIndividualPave){
			%><jsp:include page="bloc/blocDisplayOrganizationIndividualPave.jsp"></jsp:include><%
		}else{
			%><jsp:include page="bloc/blocDisplayOrganizationIndividual.jsp"></jsp:include><%
		}
		
	}

	
	
	
	
 	if( iIdOnglet == Onglet.ONGLET_ORGANISATION_COMMISSIONS)
	{
%><%@ include file="pave/ongletCommissions.jspf" %><%
	} 
 	
 	
 	
 	
 	
 	if( iIdOnglet == Onglet.ONGLET_ORGANISATION_DEPOTS)
    {
%>
<jsp:include page="bloc/blocDisplayOrganizationDepot.jsp"></jsp:include>
<%		
    } 
 	
 	
 	
 	

 	if( iIdOnglet == Onglet.ONGLET_ORGANISATION_EXPORTS)
	{
		String sUrlRedirect = rootPath + "desk/organisation/afficherOrganisation.jsp?iIdOnglet="+iIdOnglet;

%> 
	<div style="text-align:right">	
	<jsp:include page="/desk/export/pave/paveAfficherTousExport.jsp" flush="true" >
			<jsp:param name="bDisplaySourceReference" value="false" /> 
			<jsp:param name="sUrlRedirect" value="<%= sUrlRedirect %>" /> 
			<jsp:param name="iIdObjetReferenceSource" value="<%= 	organisation.getIdOrganisation() %>" /> 
			<jsp:param name="iIdTypeObjetSource" value="<%= ObjectType.ORGANISATION %>" /> 
	</jsp:include>
	</div>
<%
	
	}
 	
 	
 	
 	

 		
 	if( iIdOnglet == Onglet.ONGLET_ORGANISATION_PARAMETRES)
	{
%>
<jsp:include page="bloc/blocDisplayOrganizationParameter.jsp">
<jsp:param value="<%= iIdOnglet %>" name="iIdOnglet" />
</jsp:include>
<%	
	}

 	
 	
 	
	
 	if( iIdOnglet == Onglet.ONGLET_ORGANISATION_AFFAIRES)
	{
%>
<jsp:include page="/desk/marche/petitesAnnonces/pave/blocAllAffaire.jsp"></jsp:include>
<%
 	}

 	
 	
 	
 	
 	if( iIdOnglet == Onglet.ONGLET_ORGANISATION_AFFAIRE_PETITE_ANNONCE)
 	{
%>
<jsp:include page="/desk/marche/petitesAnnonces/pave/blocAllAffairePetiteAnnonce.jsp">
<jsp:param value="all" name="sAction"/>
</jsp:include>
<%
 	}
 	
 	
 	
 	
 	

 	if( iIdOnglet == Onglet.ONGLET_ORGANISATION_GED )
	{
%>
<jsp:include page="bloc/blocDisplayOrganizationGed.jsp">
<jsp:param value="<%= iIdOnglet %>" name="iIdOnglet" />
</jsp:include>
<%	
	}
 	
 	
 	
 	
 	
	if( iIdOnglet == Onglet.ONGLET_ORGANISATION_AR)
	{
%>
<jsp:include page="bloc/blocDisplayOrganizationEditorialHelp.jsp">
<jsp:param value="<%= iIdOnglet %>" name="iIdOnglet" />
</jsp:include>
<%			
	}
 	
 	
	
	
	
 	if(iIdOnglet == Onglet.ONGLET_ORGANISATION_CHARTE_GRAPHIQUE)
 	{
%>
<jsp:include page="bloc/blocDisplayOrganizationMultimedia.jsp">
<jsp:param value="<%= iIdOnglet %>" name="iIdOnglet" />
</jsp:include>
<%	
 	}
 	
 
 	
 	
 	if(iIdOnglet == Onglet.ONGLET_ORGANISATION_VEHICLE_MODEL)
 	{
%>
<jsp:include page="bloc/blocDisplayOrganizationVehicleModel.jsp">
<jsp:param value="<%= iIdOnglet %>" name="iIdOnglet" />
</jsp:include>
<%	
 	}
 	
 	
 	
 	

 	if( iIdOnglet == Onglet.ONGLET_ORGANISATION_SERVICE)
	{
%>
<jsp:include page="bloc/blocDisplayOrganizationService.jsp">
<jsp:param value="<%= iIdOnglet %>" name="iIdOnglet" />
</jsp:include>
<%	
	}

 	
 	
 	

 	if( iIdOnglet == Onglet.ONGLET_ORGANISATION_GROUP)
	{
%>
<jsp:include page="bloc/blocDisplayOrganizationGroup.jsp">
<jsp:param value="<%= iIdOnglet %>" name="iIdOnglet" />
</jsp:include>
<%

	} // end  







 	if( iIdOnglet == Onglet.ONGLET_ORGANISATION_ORGANIGRAM )
	{
%>
<jsp:include page="bloc/blocDisplayOrganizationOrganigram.jsp">
<jsp:param value="<%= iIdOnglet %>" name="iIdOnglet" />
</jsp:include>
<%
	}
	
	
	
	
 

 	if( iIdOnglet == Onglet.ONGLET_ORGANISATION_OWNER)
	{
 %>
<jsp:include page="bloc/blocDisplayAllOrganizationOwned.jsp">
<jsp:param value="<%= iIdOnglet %>" name="iIdOnglet" />
</jsp:include>
 <%
	}
 	
 	

 	if( iIdOnglet == Onglet.ONGLET_ORGANISATION_LDAP)
	{

		try {

			AddressBookLdapConnector ldapConn = new AddressBookLdapConnector(organisation);
			ldapConn .init(conn);
			
			
			//ldapConn.searchFilter = "(objectClass=user)";


%>
Search base : <%= ldapConn.searchBase %>	<br/><br/>
<%			
			NamingEnumeration answer = ldapConn.search();
			int indexSR = 0;
			while (answer.hasMoreElements()) {
				SearchResult sr = (SearchResult)answer.next();
				indexSR++;
%>
<div id="user_name_<%= indexSR %>" onclick="Element.toggle('user_<%= indexSR %>');" style="cursor: pointer;">
<b><%= sr.getName() %></b>
</div>
<div id="user_<%= indexSR %>" style="display: none;" >
<%						
				Attributes attrs = sr.getAttributes();
				if (attrs != null) {

					try {
						for (NamingEnumeration ae = attrs.getAll();ae.hasMore();) {
							Attribute attr = (Attribute)ae.next();
%>
<%= attr.getID() %> : 
<%							
							for (NamingEnumeration e = attr.getAll();e.hasMore();) {
								Object o = e.next();
%>
								<%= o.toString() %>								
<%
							}
%>
<br/>
<%
						}

					}	 
					catch (Exception e)	{
						e.printStackTrace();
					}
				
				}
%>
</div>
<%				
			}
			
			
 
		} 
		
		catch (Exception e) {
			e.printStackTrace();
%>
<%= e.getMessage() %>
<%
		}
	}
 	
	
 	
	if( bDisplayFormButton)
	{
%>
</form>
<%
	}
	
	ConnectionManager.closeConnection(conn);
%>
</div>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>