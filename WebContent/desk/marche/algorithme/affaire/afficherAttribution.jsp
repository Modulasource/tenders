<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@ page import="org.json.*,java.sql.*,org.coin.fr.bean.*,org.coin.util.*,java.util.*,modula.algorithme.*, modula.*, modula.marche.*,modula.candidature.*, modula.marche.cpv.*,modula.commission.*, org.coin.util.treeview.*,java.text.*,org.coin.bean.*" %>
<%@ include file="/desk/include/useBoamp17.jspf" %>
<%
	long lStartTime = System.currentTimeMillis();

	String sSelected ;
	String sUrlCancel = "";
	String sTitle = null;
	String sFormPrefix = "";
	String sAction = HttpUtil.parseStringBlank("sAction", request);
	String sReference = "";
	String sObjet = "";
	int iIdCommission;
	int iIdNextPhaseEtapes = HttpUtil.parseInt("iIdNextPhaseEtapes", request, -1);
	int iIdOnglet = HttpUtil.parseInt("iIdOnglet", request, Onglet.ONGLET_ATTRIBUTION_TITULAIRES);
	
	boolean bErrorJustifNegoc = HttpUtil.parseBoolean("bErrorJustifNegoc", request, false);
	
	int iIdAffaire = -1;
	Marche marche = null;
	boolean bShowForm = false;
	boolean bIsOngletInstancie = false;
	boolean bShowValidationButton = true;
	String sPageUseCaseId = "IHM-DESK-AFF-4";
	boolean bStartWithAATR = false;
	String sPaveAcheteurPublicTitre;
	String sPaveTypeAcheteurPublicTitre;
	Adresse adresse = null;
	Pays pays = null;
	String sPage="";
	String sRedirection;
	String sPaveAdresseTitre = "Adresse";

	String sIdAffaire = null;
	sIdAffaire = request.getParameter("iIdAffaire");
	iIdAffaire = Integer.parseInt(sIdAffaire );
	marche = Marche.getMarche(iIdAffaire );

	%><%@ include file="/desk/include/typeForm.jspf" %><%
	
	MarcheType oMarcheType = null;
	try{
		oMarcheType = MarcheType.getMarcheType( marche.getIdMarcheType() ); 
	}
	catch(CoinDatabaseLoadException e){
		oMarcheType = new MarcheType();
	}

	/**
	 * permet de savoir si l'affaire a commencé sur un AAPC ou un AATR
	 */
	AffaireProcedure proc = AffaireProcedure.getAffaireProcedureMemory(marche.getIdAlgoAffaireProcedure());
	if(proc.getIdPhaseDemarrage() == Phase.PHASE_CREATION_AATR)
	{
		bStartWithAATR = true;
		iIdOnglet = HttpUtil.parseInt("iIdOnglet", request, Onglet.ONGLET_ATTRIBUTION_OBJET);
	}
	
	session.setAttribute("sessionIdAffaire",  "" + marche.getIdMarche()) ;
	session.setAttribute( "sessionPageAffaire", marche ) ;
	
	int iIdPRM = -1;
	if (request.getParameter("iIdPRM") != null)
	{
		iIdPRM = Integer.parseInt(request.getParameter("iIdPRM"));
	}
	else
	{
	    Vector<Correspondant> vCorrespondantPRM = Correspondant.getAllCorrespondantFromTypeAndReferenceObjetAndFonction(ObjectType.AFFAIRE,marche.getIdMarche(),PersonnePhysiqueFonction.PRM);
	    if(vCorrespondantPRM.size() == 1)
			iIdPRM = vCorrespondantPRM.firstElement().getIdPersonnePhysique();
	}

	AvisAttribution avisAttribution = null;
	try
	{
		avisAttribution = AvisAttribution.getAvisAttributionFromMarche(marche.getIdMarche());
	}
	catch(CoinDatabaseLoadException e)
	{
		avisAttribution = new AvisAttribution();
		avisAttribution.setIdMarche(marche.getIdMarche());
		avisAttribution.setLectureSeule(false);
		avisAttribution.setDateCreation(new Timestamp(System.currentTimeMillis())); 
		avisAttribution.create();
		
		marche.setAffaireAATR(true);
		marche.setAffaireAAPC(false);
		if(!bStartWithAATR)
		{
			int iIdAlgoProcedure = AffaireProcedure.getAffaireProcedureMemory(marche.getIdAlgoAffaireProcedure()).getIdProcedure();
			marche.setIdAlgoPhaseEtapes(AlgorithmeModula.getFirstPhaseEtapesAATRInProcedure(iIdAlgoProcedure).getId());
		}
		marche.store();
	}
	
	boolean bIsContainsCandidatureManagement = AffaireProcedure.isContainsCandidatureManagement(marche.getIdAlgoAffaireProcedure());
	boolean bAATRAutomatique = avisAttribution.isAATRAutomatique(true);

	Vector<MarcheLot> vLots = MarcheLot.getAllLotsFromMarche(marche.getIdMarche());
	Vector<MarcheLot> vLotsAttribues = MarcheLot.getAllLotsAttribuesFromMarche(iIdAffaire);
	Vector<MarcheLot> vLotsInfructueux = MarcheLot.getAllLotsInfructueuxFromMarche(iIdAffaire);
	int iNbLots = vLots.size();
	
	String sActionRectificatif = HttpUtil.parseStringBlank("sActionRectificatif", request);
	int iIdAvisRectificatif = HttpUtil.parseInt("iIdAvisRectificatif", request, -1 );
	int iIdTypeProcedure = AffaireProcedure.getTypeProcedure(marche.getIdAlgoAffaireProcedure());
	Commission commission = Commission.getCommission(marche.getIdCommission());
	Organisation oOrganisation = Organisation.getOrganisation(commission.getIdOrganisation());
	int iTypeAcheteurPublic = oOrganisation.getIdTypeAcheteurPublic();
	Vector vPersonnes = PersonnePhysique.getAllFromIdOrganisation(oOrganisation.getIdOrganisation());
	
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId); 	
	sTitle = marche.getTitle();
	
	Onglet.sNotCurrentTabStyle = " class='onglet_non_selectionne' "; 
	Onglet.sCurrentTabStyle =  " class='onglet_selectionne' ";
	Onglet.sNotCurrentTabStyleInCreation = " class='onglet_non_selectionne' ";
	Onglet.sCurrentTabStyleInCreation =  " class='onglet_selectionne' ";
	Onglet.sEnddingTabStyle =  " class='onglet_vide_dernier' ";

	Vector<Onglet> vOnglets = new Vector<Onglet>();
	vOnglets.add( new Onglet(Onglet.ONGLET_ATTRIBUTION_OBJET, false, "Objet", "afficherAttribution.jsp?iIdOnglet="+Onglet.ONGLET_ATTRIBUTION_OBJET,!bStartWithAATR) ); 
	vOnglets.add( new Onglet(Onglet.ONGLET_ATTRIBUTION_CRITERES, false, "Critères", "afficherAttribution.jsp?iIdOnglet="+Onglet.ONGLET_ATTRIBUTION_CRITERES,!bStartWithAATR) ); 
	vOnglets.add( new Onglet(Onglet.ONGLET_ATTRIBUTION_LOTS, false, "Lots", "afficherAttribution.jsp?iIdOnglet="+Onglet.ONGLET_ATTRIBUTION_LOTS,!bStartWithAATR) ); 
	vOnglets.add( new Onglet(Onglet.ONGLET_ATTRIBUTION_ORGANISME, false, "Organisme", "afficherAttribution.jsp?iIdOnglet="+Onglet.ONGLET_ATTRIBUTION_ORGANISME,!bStartWithAATR) ); 
	vOnglets.add( new Onglet(Onglet.ONGLET_ATTRIBUTION_TITULAIRES, false, "Titulaires", "afficherAttribution.jsp?iIdOnglet="+Onglet.ONGLET_ATTRIBUTION_TITULAIRES) ); 
	vOnglets.add( new Onglet(Onglet.ONGLET_ATTRIBUTION_RENSEIGNEMENTS_PUBLICATION, false, "Renseignements Publication", "afficherAttribution.jsp?iIdOnglet="+Onglet.ONGLET_ATTRIBUTION_RENSEIGNEMENTS_PUBLICATION) ); 
	vOnglets.add( new Onglet(Onglet.ONGLET_ATTRIBUTION_RENSEIGNEMENTS_COMPLEMENTAIRES, false, "Renseignements complémentaires", "afficherAttribution.jsp?iIdOnglet="+Onglet.ONGLET_ATTRIBUTION_RENSEIGNEMENTS_COMPLEMENTAIRES) ); 
	vOnglets.add( new Onglet(Onglet.ONGLET_ATTRIBUTION_RECTIFICATIF, false, "Avis Rectificatifs", "afficherAttribution.jsp?iIdOnglet="+Onglet.ONGLET_ATTRIBUTION_RECTIFICATIF, true) ); 
	vOnglets.add( new Onglet(Onglet.ONGLET_ATTRIBUTION_JUSTIFICATIF_NEGOCIE, false, "Annexe I", "afficherAttribution.jsp?iIdOnglet="+Onglet.ONGLET_ATTRIBUTION_JUSTIFICATIF_NEGOCIE,true) ); 
    vOnglets.add( new Onglet(Onglet.ONGLET_ATTRIBUTION_JOUE, false, "JOUE", "afficherAttribution.jsp?iIdOnglet=" + Onglet.ONGLET_ATTRIBUTION_JOUE, !bUseFormNS));  
	Onglet onglet = vOnglets.get(iIdOnglet);
	onglet.bIsCurrent = true;
	
	bIsOngletInstancie = avisAttribution.isOngletInstancie(onglet.iId);
	boolean bAATRPubliee = avisAttribution.isAATRPublieSurPublisher(false); 
	
	Vector<AvisRectificatif> vAvisRectificatif 
		= AvisRectificatif.getAllAvisRectificatifWithType(iIdAffaire,AvisRectificatifType.TYPE_AATR);
	if(sessionUserHabilitation.isHabilitate("IHM-DESK-AFF-RECT-2")
	&&  bAATRPubliee && vAvisRectificatif != null && vAvisRectificatif.size()>0)
	{
		Onglet ongletRect = vOnglets.get(Onglet.ONGLET_ATTRIBUTION_RECTIFICATIF);
		ongletRect.bHidden = false;
	}
	if (iIdTypeProcedure == AffaireProcedure.TYPE_PROCEDURE_NEGOCIE) {
		Onglet ongletJustificatifNegocie = vOnglets.get(Onglet.ONGLET_ATTRIBUTION_JUSTIFICATIF_NEGOCIE); 
		ongletJustificatifNegocie.bHidden = false;
	}

	boolean bLectureSeule = avisAttribution.isLectureSeule(false);
	if(!bIsOngletInstancie && !bLectureSeule) sAction = "store";
	boolean bIsRectification = avisAttribution.isAATREnCoursDeRectification(false);
	
	//ONGLET CRITERES
	AutoFormCptDoubleMultiSelect afIdArticleSelection = null;
	AutoFormCptSelect afIdMarchePassation = null;
	AutoFormCptSelect afIdProcedure = null;
	AutoFormCptBlock afBlockTypeAvis = null;
	AutoFormCptBlock afBlockProcedure = null;
	AutoFormCptBlock afBlockPub = null;
	AutoFormCptInputRadioSet afTypePublication = null;
	MarcheProcedure marProc =  null;
    AutoFormCptSelect afProcedureSimpleEnveloppe = null;

	try {
		marProc = MarcheProcedure.getFromMarche(marche.getIdMarche());
	} catch (Exception e) {
		marProc = new MarcheProcedure();
	}
	
	
	if(iIdOnglet == Onglet.ONGLET_ATTRIBUTION_CRITERES){
		
	    %><%@ include file="pave/blocAutoformAffaire.jspf" %><%
	}
	
%>
<link rel="stylesheet" type="text/css" href="<%= rootPath %>include/component/calendar/calendar.css" media="screen" />
<script type="text/javascript" src="<%= rootPath %>include/component/calendar/calendar.js"></script>
<%
	if(sAction.equals("store") )
	{
		JSONArray jTypeForm = BoampFormulaireType.getJSONArray();
		JSONArray jPass = MarchePassation.getJSONArray(false);
		JSONArray jNiveau = AffaireProcedureType.getJSONArray(false);
		JSONArray jLois = ArticleLoi.getJSONArrayEtatValide(false);
		JSONArray jProc = AffaireProcedure.getJSONArray(sessionUserHabilitation);
%> 
<%@ include file="pave/checkOngletsAATR.jspf" %>


<script type="text/javascript" src="<%= rootPath %>dwr/interface/PersonnePhysiqueModula.js" ></script>
<script type="text/javascript" src="<%= rootPath %>dwr/interface/CodeNuts.js" ></script>
<script type="text/javascript" src="<%= rootPath %>dwr/interface/AutoFormCptDoubleMultiSelect.js" ></script>
<script type="text/javascript" src="<%= rootPath %>dwr/interface/CodeCpfSwitcher.js" ></script>
<script type="text/javascript" src="<%= rootPath %>dwr/interface/BoampCPFMotCle.js" ></script>
<script type="text/javascript" src="<%= rootPath %>dwr/util.js" ></script>
<script type="text/javascript" src="<%= rootPath %>include/AjaxComboList.js?v=<%= JavascriptVersion.AJAX_COMBO_LIST_JS %>"></script>
<script type="text/javascript">
function DWR_updateCorrespondant(idCombobox, sFormPrefix)
{

	var form2 = $("formulaire");
	form2[sFormPrefix + "nom"].value = "";
	form2[sFormPrefix + "tel"].value = "";
	form2[sFormPrefix + "poste"].value = "";
	form2[sFormPrefix + "fax"].value = "";
	form2[sFormPrefix + "fax"].value = "";
	form2[sFormPrefix + "email"].value = "";
	form2[sFormPrefix + "site_web"].value = "";
	$(sFormPrefix + "OrganisationRaisonSociale").innerHTML = "";
	$(sFormPrefix + "sAllAdresseString").innerHTML = "";

	var idPP = $(idCombobox).value;
	if(parseInt(idPP) < 1) 
	{
		alert("attention plus de sélection. Si le bouton 'effacer' est présent il faut cliquer dessus pour supprimer définitivement la sélection!");
		return ;
	}

	PersonnePhysiqueModula.getJSONObjectWithObjectAttached(
		idPP,
		function (s) {
			var obj = s.evalJSON();
			var form = $("formulaire");
			form[sFormPrefix + "nom"].value = obj.sPersonnePhysiqueCiviliteName + " " + obj.sNom + " " + obj.sPrenom;
			form[sFormPrefix + "tel"].value = obj.sTel;
			form[sFormPrefix + "poste"].value = obj.sPoste;
			form[sFormPrefix + "fax"].value = obj.sFax;
			form[sFormPrefix + "fax"].value = obj.sFax;
			form[sFormPrefix + "email"].value = obj.sEmail;
			form[sFormPrefix + "site_web"].value = obj.sSiteWeb;
			$(sFormPrefix + "OrganisationRaisonSociale").innerHTML = obj.sOrganisationRaisonSociale;
			$(sFormPrefix + "sAllAdresseString").innerHTML = obj.sAllAdresseString.replace(/\n/gi,"<br/>");
		}
		);
}
</script>
<%
	} // ENDIF if(sAction.equals("store") )
	  
%>
<script type="text/javascript">
function isProcedureSelect(iIdProcedure)
{
	if(iIdProcedure == 0 || iIdProcedure == 46  || iIdProcedure == 27)
	{
		alert("Vous devez sélectionner le mode de passation avant! (onglet criteres)");
		return false ;
	}
	else
		return true ;
}
</script>
<script type="text/javascript">
var rootPath = "<%=rootPath%>";
mt.config.enableAutoRoundPave = false;
</script>

<style type="text/css">
<!--
#lIdMarcheVolumeType{

	background-color:#FFE3E3;/*FFEAA9*/
	border: 1px solid #CC0000/*FFD75F*/;
/**
  @see class on desk.css : <%= CSS.DESIGN_CSS_MANDATORY_CLASS %> ;
  */
}
-->
</style>

</head>
<%
	boolean bOnLoad = false;
	if(sAction.equals("store") ) 
	{
		bShowForm = true;
		bOnLoad = true;
	}
	if(iIdOnglet == Onglet.ONGLET_ATTRIBUTION_RECTIFICATIF)	{
		bShowForm = false;
		bShowValidationButton = false;
	}
	boolean bAfficherPoursuivreProcedure = true;
%>
<body <%= bOnLoad?"onload='onAfterPageLoading()'":"" %>>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<%@ include file="/include/new_style/headerAffaire.jspf" %>
<p style="text-align:center" class="mention">
 	Date de création : <%= CalendarUtil.getDateFormatteeNeant( avisAttribution.getDateCreation() ) %>&nbsp;&nbsp;&nbsp;
 	Dernière modification : <%= CalendarUtil.getDateFormatteeNeant( avisAttribution.getDateModification() ) %>
</p>
<p style="text-align:center" class="mention">
Selon l'article 80 du code des marchés publics, pour les marchés à procédure formalisée, l'avis d'attribution 
doit être envoyé pour publication dans un délai de trente jours à compter de la notification du marché, 
dans les organes de publication ayant assuré la publication de l'avis d'appel public à la concurrence.
</p>
<% 	if(bIsRectification )
	{
 %><div class="avertissementRouge">ATTENTION : AVIS D'ATTRIBUTION EN COURS DE RECTIFICATION !</div>
 <%} %>
<div class="tabFrame">
<div class="tabs">
<%
	for (int i = 0; i < vOnglets.size(); i++) 
	{
		onglet = vOnglets.get(i);
		if(!onglet.bHidden) {
			try {
				String sImageInCreation = "" ;
				bIsOngletInstancie = avisAttribution.isOngletInstancie(onglet.iId);
				String sOnClick = "";
				
				if(!bIsOngletInstancie)
					sImageInCreation = "<span style='color:#F00;font-weight:bold;font-size:12px'> ! </span>";
				%>
				<div <%= (onglet.bIsCurrent?"class=\"active\"":"") %>
					onclick="javascript:location.href='<%= response.encodeURL(onglet.sTargetUrl +"&amp;iIdAffaire="+marche.getIdMarche())%>';">
					<%= onglet.sLibelle %><%= sImageInCreation %>
				</div><%	
			} 
			catch (Exception e) 
			{
				e.printStackTrace();
			}
		}
	}
%>
</div>
<div class="tabContent">
<%
if(bShowForm && !bLectureSeule)
{ 
%>
					<form action="<%= response.encodeURL("modifierAttribution.jsp") %>" method="post" id="formulaire" name="formulaire">
<%
}
if (bShowValidationButton )
{
%>
					<%@ include file="pave/paveBoutonValidationAATR.jspf" %>
					<br />
<%
}

request.setAttribute("marche", marche);	
request.setAttribute("organisation", oOrganisation);	
request.setAttribute("afBlockTypeAvis", afBlockTypeAvis);
request.setAttribute("afBlockProcedure", afBlockProcedure);
request.setAttribute("afProcedureSimpleEnveloppe", afProcedureSimpleEnveloppe);
request.setAttribute("marProc", marProc);
%>
<%
if( iIdOnglet == Onglet.ONGLET_ATTRIBUTION_OBJET )
{
	sFormPrefix = "";
	if(sAction.equals("store") )
	{ 
		%><div><%
	%>
	<jsp:include page="pave/ongletObjetForm.jsp" flush="false" /> <% 
	}
	else 
	{ 
		%>
		<jsp:include page="pave/ongletObjet.jsp" flush="false" /><%
	}	
	%></div><%
}

if( iIdOnglet == Onglet.ONGLET_ATTRIBUTION_CRITERES )
{
	%><div><%
	sFormPrefix = "";
		
	String sPaveCritereTitre = "Critères d'attribution";
	if(sAction.equals("store") )
	{
	sPageUseCaseId = "IHM-DESK-AFF-CRE-3"; 
	%>
	<%@ include file="/desk/include/checkHabilitationPage.jspf" %>
	<%@ include file="pave/ongletCriteresForm.jspf" %> <% }
	else 
	{ %><%@ include file="pave/ongletCriteres.jspf" %> <% }
	%></div><%
}

if( iIdOnglet == Onglet.ONGLET_ATTRIBUTION_LOTS )
{
	%><div><%
	sFormPrefix = "";
	if(sAction.equals("store") )
	{
	sPageUseCaseId = "IHM-DESK-AFF-CRE-4"; 
	String sHiddenRedirectURL = "afficherAttribution.jsp?iIdOnglet="+iIdOnglet+"&iIdAffaire="+iIdAffaire+"&sAction=store";	
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
	%>
	<jsp:include page="pave/ongletLotsForm.jsp" flush="false"  >
			<jsp:param name="sHiddenRedirectURL" value="<%= sHiddenRedirectURL %>" /> 
			<jsp:param name="bIsRectification" value="<%= bIsRectification %>" /> 
		</jsp:include>
	<%
	}	
	else 
	{ %><jsp:include page="pave/ongletLots.jsp" flush="false"  /><%
	}	
	%></div><%
}

if( iIdOnglet == Onglet.ONGLET_ATTRIBUTION_ORGANISME )
{
	%><div><%
	sFormPrefix = "";
	if(sAction.equals("store") )
	{ %><%@ include file="pave/ongletOrganismeAATRForm.jspf" %><% }
	else 
	{ %><%@ include file="pave/ongletOrganismeAATR.jspf" %><%}
	%></div><%
}

// FLON le travail est fait à moitié ...
if( iIdOnglet == Onglet.ONGLET_ATTRIBUTION_TITULAIRES )
{
	%><div><%
	sFormPrefix = "";
	if(sAction.equals("store") )
	{

		if(!bIsContainsCandidatureManagement)
		{
			%><%@ include file="pave/paveAttributionLotsForm.jspf" %><%
		}
		%><%@ include file="pave/ongletTitulairesForm.jspf" %><% 
	}
	else 
	{
		if(!bIsContainsCandidatureManagement)
		{
			%><%@ include file="pave/paveAttributionLots.jspf" %><%
		}
		%><%@ include file="pave/ongletTitulaires.jspf" %><%
	}
	%></div><%
}

// FLON le travail est fait à moitié ...
if( iIdOnglet == Onglet.ONGLET_ATTRIBUTION_RENSEIGNEMENTS_PUBLICATION )
{
	%><div><%
	sFormPrefix = "";
	
	try {
		marProc = MarcheProcedure.getFromMarche(marche.getIdMarche());
	} catch (Exception e) {
		marProc = new MarcheProcedure();
	}
	
	if(sAction.equals("store") )
	{
		%><%@ include file="pave/ongletRensPublicationsForm.jspf" %><%
		if(marProc.getIdBoampFormulaireType() == BoampFormulaireType.TYPE_MAPA)
		{
			HtmlBeanTableTrPave hbFormulaire = new HtmlBeanTableTrPave();
			hbFormulaire.bIsForm = true;
			%><br /><%@ include file="pave/paveIndexationForm.jspf" %><%
		}
	}
	else 
	{
		%><%@ include file="pave/ongletRensPublications.jspf" %><%
		if(marProc.getIdBoampFormulaireType() == BoampFormulaireType.TYPE_MAPA)
		{
			%><br /><%@ include file="pave/paveIndexation.jspf" %><%
		}
	}
	%></div><%
}

// FLON le travail est fait à moitié ...
if( iIdOnglet == Onglet.ONGLET_ATTRIBUTION_RENSEIGNEMENTS_COMPLEMENTAIRES )
{
	%><div><%
	sFormPrefix = "";
	if(sAction.equals("store"))
	{
%>
<%@ include file="pave/ongletRenseignementsForm.jspf" %><% }
	else
	{
%>
<%@ include file="pave/ongletRenseignements.jspf" %>
<%
	}
	%></div><%
}
if( iIdOnglet == Onglet.ONGLET_ATTRIBUTION_RECTIFICATIF) 
{
	%><div><%
	if(sActionRectificatif.equals(""))
	{
%>
		<jsp:include page="../avis_rectificatif/afficherTousAvisRectificatif.jsp" flush="true">
			<jsp:param name="iIdAffaire" value="<%= marche.getIdMarche() %>" /> 
			<jsp:param name="sActionRectificatif" value="<%= sActionRectificatif %>" /> 
			<jsp:param name="iIdOnglet" value="<%= iIdOnglet %>" /> 
			<jsp:param name="iIdAvisRectificatif" value="<%= iIdAvisRectificatif %>" /> 
		</jsp:include>
<%
	}
	else if ((sActionRectificatif.equalsIgnoreCase("createForm")) || (sActionRectificatif.equalsIgnoreCase("store")) || (sActionRectificatif.equalsIgnoreCase("create")))
	{
%>
	<jsp:include page="../avis_rectificatif/modifierAvisRectificatifForm.jsp" flush="true">
		<jsp:param name="iIdAffaire" value="<%= marche.getIdMarche() %>" />
		<jsp:param name="sActionRectificatif" value="<%= sActionRectificatif %>" />
		<jsp:param name="iIdOnglet" value="<%= iIdOnglet %>" />
		<jsp:param name="iIdAvisRectificatif" value="<%= iIdAvisRectificatif %>" /> 
		<jsp:param name="iTypeAvisRectificatif" value="2" /> 
	</jsp:include>
<%
	}
	else if (sActionRectificatif.equalsIgnoreCase("show"))
	{
	
%>
	<jsp:include page="../avis_rectificatif/afficherAvisRectificatif.jsp" flush="true">
		<jsp:param name="iIdAffaire" value="<%= marche.getIdMarche() %>" />
		<jsp:param name="sActionRectificatif" value="<%= sActionRectificatif %>" />
		<jsp:param name="iIdOnglet" value="<%= iIdOnglet %>" />
		<jsp:param name="iIdAvisRectificatif" value="<%= iIdAvisRectificatif %>" /> 
		<jsp:param name="iTypeAvisRectificatif" value="2" /> 
	</jsp:include>
<%
	}
	%></div><%
}
if( iIdOnglet == Onglet.ONGLET_ATTRIBUTION_JUSTIFICATIF_NEGOCIE) 
{
	%><div><%
	if(sAction.equals("store"))
	{
%>
<%@ include file="pave/ongletAATRJustifNegocieForm.jspf" %>
<%
	}
	else{
%>
<%@ include file="pave/ongletAATRJustifNegocie.jspf" %>
<%		
	}
	%></div><%
}


if( iIdOnglet == Onglet.ONGLET_ATTRIBUTION_JOUE)
{
    %><%@ include file="pave/ongletJoue.jspf" %><%
}


if(sAction.equals("store") )
{
	if (bShowValidationButton )
	{
%>
	<br />
	<%@ include file="pave/paveBoutonValidationAATR.jspf" %>
	<br />
<%
	}
	if(bShowForm )
	{
%>
	</form>
<%
	}
}
%>
</div>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
<%
if(sessionUserHabilitation.isSuperUser())
{
	long lStopTime = System.currentTimeMillis();
	%>généré en <%= lStopTime- lStartTime%> ms<% 	
}
%>
</body>
<%@page import="org.coin.autoform.component.*"%>
<%@page import="org.coin.bean.question.QuestionAnswer"%>
<%@page import="org.coin.bean.html.HtmlBeanTableTrPave"%>

</html>
