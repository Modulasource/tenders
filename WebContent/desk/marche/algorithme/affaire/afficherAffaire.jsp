<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@ page import="modula.fqr.*,java.sql.*,org.coin.fr.bean.*,org.coin.bean.boamp.*,modula.candidature.*,org.coin.util.*" %>
<%@ page import="java.util.*,modula.algorithme.*, modula.*, modula.marche.*,org.coin.fr.bean.export.*" %>
<%@ page import="modula.marche.cpv.*,modula.commission.*, org.coin.util.treeview.*,java.text.*, modula.graphic.*,modula.ws.boamp.*,org.coin.bean.*" %>
<%@page import="org.coin.autoform.component.*"%>
<%@page import="modula.marche.joue.JoueFormulaire"%>
<%@page import="org.coin.db.CoinDatabaseHtmlTraitment"%>
<%@page import="modula.marche.joue.MarcheJoueFormulaire"%>
<%@page import="modula.marche.correspondant.CorrespondantMarche"%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.coin.db.CoinDatabaseLoadException"%>
<%@page import="org.coin.bean.question.QuestionAnswer"%>
<%@page import="modula.marche.joue.MarcheJoueInfo"%>
<%@page import="mt.modula.html.HtmlTabCorrespondant"%>
<%@ include file="/desk/include/useBoamp17.jspf" %>
<%

	long lStartTime = System.currentTimeMillis();
	String sSelected ; 
	String sUrlCancel = ""; 
	String sTitle = null;
	String sPaveObjetMarcheTitre ;
	String sFormPrefix = ""; 
	String sPaveCompetenceTitre;
	String sPaveTypeMarcheTitre ;
	String sPaveNomenclatureTitre ;
	String sPaveLieuxTitre ;
	String sAction = HttpUtil.parseStringBlank("sAction", request);
	String sActionDCE = HttpUtil.parseStringBlank("sActionDCE", request);
	String sReference = "";
	String sObjet = "";
	int iIdAffaire;
	int iIdCommission;
	Marche marche = null;
	int iIdOnglet = HttpUtil.parseInt("iIdOnglet", request, 0);
	boolean bShowForm = false;
	boolean bShowValidationButton = true;
	String sPaveAcheteurPublicTitre;
	String sPavePersInfosAdmTitre;
	String sPavePersInfosTechTitre;
	String sPavePersInfosAdmEtTechTitre;
	String sPaveDocumentalisteTitre;
	String sPaveRecipiendaireTitre;
	String sPaveTypeAcheteurPublicTitre;
	String sPaveDeleguePRMTitre;
	String sPaveConsultantsTitre;
	String sPaveInformateurTitre;
	String sPaveSecretaireCAOTitre;
	String sRedirection;
	Adresse adresse = null;
	Pays pays = null;
	boolean bIsOngletInstancie;
	String sPaveAdresseTitre = "Adresse";
	String sPage="";
	String sPageUseCaseId = "IHM-DESK-AFF-4";

	String sIdAffaire = null;
	sIdAffaire = request.getParameter("iIdAffaire");
	iIdAffaire = Integer.parseInt(sIdAffaire );
	marche = Marche.getMarche(iIdAffaire );
	boolean bIsRectification =  marche.isAffaireEnCoursDeRectification(false);	

	%><%@ include file="/desk/include/typeForm.jspf" %><%

	/**
	 * Si on est sur cette page il y a forcément eu un AAPC 
 	 */
	
	boolean bStartWithAATR = false;
	/**
	 * pour lier l'AAPC à l'AATR s'il existe 
	 */
	AvisAttribution avisAttribution = null;
	try
	{
		avisAttribution = AvisAttribution.getAvisAttributionFromMarche(marche.getIdMarche());
	} catch(CoinDatabaseLoadException e){}

	Vector<MarcheLot> vLots = MarcheLot.getAllLotsFromMarche(marche.getIdMarche());
	/* Récupération de la commission */
	Commission commission = Commission.getCommission(marche.getIdCommission());

	Organisation organisation = Organisation.getOrganisation(commission.getIdOrganisation());
	int iTypeAcheteurPublic = organisation.getIdTypeAcheteurPublic();
	
	/* Récupération des des correspondants */
	HtmlTabCorrespondant tabCorrespondant = null;
	if( iIdOnglet == Onglet.ONGLET_AFFAIRE_ORGANISME )
	{
		tabCorrespondant = new HtmlTabCorrespondant(
				marche,
				bUseBoamp17,
				request,
				response
				);
		tabCorrespondant.addAllCorrespondantMarche();
	}
	
	String sActionRectificatif = HttpUtil.parseStringBlank("sActionRectificatif", request);
	int iIdAvisRectificatif = HttpUtil.parseInt("iIdAvisRectificatif", request, -1 );
	boolean bFormJOUE = HttpUtil.parseBoolean("bFormJOUE", request, false);
	boolean bRectifFormJoueCompleted = HttpUtil.parseBoolean("bRectifFormJoueCompleted", request, true);
    boolean bCreationArec = HttpUtil.parseBoolean("bCreationArec", request, false);
    
	session.setAttribute( "sessionIdAffaire",  "" + marche.getIdMarche() ) ;
	session.setAttribute( "sessionPageAffaire", marche ) ;
	
	//PROCEDURE
	boolean bIsContainsAAPCPublicity = AffaireProcedure.isContainsAAPCPublicity(marche.getIdAlgoAffaireProcedure());
	boolean bIsContainsEnveloppeAManagement = AffaireProcedure.isContainsEnveloppeAManagement(marche.getIdAlgoAffaireProcedure());
	boolean bIsContainsCandidatureManagement = AffaireProcedure.isContainsCandidatureManagement(marche.getIdAlgoAffaireProcedure());
	boolean bIsContainsDCEManagement = AffaireProcedure.isContainsDCEManagement(marche.getIdAlgoAffaireProcedure());
	boolean bIsForcedNegociationManagement = AffaireProcedure.isForcedNegociationManagement(marche.getIdAlgoAffaireProcedure());
	boolean bIsContainsEnveloppeCManagement = AffaireProcedure.isContainsEnveloppeCManagement(marche.getIdAlgoAffaireProcedure());
	boolean bIsLinkedPublicityAndCandidature = AffaireProcedure.isPublicityAndCandidatureLinked(marche.getIdAlgoAffaireProcedure());
	
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
	boolean bAffairePubliee = marche.isAffairePublieeSurPublisher(false);
		
	Onglet.sNotCurrentTabStyle = " class='onglet_non_selectionne' "; 
	Onglet.sCurrentTabStyle =  " class='onglet_selectionne' ";
	Onglet.sNotCurrentTabStyleInCreation = " class='onglet_non_selectionne' ";
	Onglet.sCurrentTabStyleInCreation =  " class='onglet_selectionne' ";
	Onglet.sEnddingTabStyle =  " class='onglet_vide_dernier' ";

	Vector<Onglet> vOnglets = new Vector<Onglet>();
	vOnglets.add( new Onglet(0, false, "Objet", "afficherAffaire.jsp?iIdOnglet=0") ); 
	vOnglets.add( new Onglet(1, false, "Carac. Prin.", "afficherAffaire.jsp?iIdOnglet=1") ); 
	vOnglets.add( new Onglet(2, false, "Conditions", "afficherAffaire.jsp?iIdOnglet=2") ); 
	vOnglets.add( new Onglet(3, false, "Critères", "afficherAffaire.jsp?iIdOnglet=3") ); 
	vOnglets.add( new Onglet(4, false, "Autres", "afficherAffaire.jsp?iIdOnglet=4") ); 
	vOnglets.add( new Onglet(5, false, "Lots", "afficherAffaire.jsp?iIdOnglet=5") ); 
	vOnglets.add( new Onglet(6, false, "Organisme", "afficherAffaire.jsp?iIdOnglet=6") ); 
	vOnglets.add( new Onglet(7, false, "DCE", "afficherAffaire.jsp?iIdOnglet=7") ); 
	vOnglets.add( new Onglet(8, false, "Planning", "afficherAffaire.jsp?iIdOnglet=8") ); 
	vOnglets.add( new Onglet(9, false, "Synchronisation", "afficherAffaire.jsp?iIdOnglet=9", true) ); 
	vOnglets.add( new Onglet(10, false, "Avis Rectificatifs", "afficherAffaire.jsp?iIdOnglet=10", true) ); 
	vOnglets.add( new Onglet(11, false, "Paramètres", "afficherAffaire.jsp?iIdOnglet=11", true) ); 
	vOnglets.add( new Onglet(12, false, "Annulation", "afficherAffaire.jsp?iIdOnglet=12", !marche.isAffaireAnnulee(false)) ); 
	vOnglets.add( new Onglet(13, false, "JOUE", "afficherAffaire.jsp?iIdOnglet=13", !bUseFormNS) ); 
	
	//FLON: IHM-DESK-AFF-RECT-2 pas le bon use-case
	if (marche.getIdMarcheSynchro() == modula.marche.MarcheSynchro.MARCO ) { // Marché Marco
		if(sessionUserHabilitation.isHabilitate("IHM-DESK-AFF-RECT-2") &&  bAffairePubliee)
		{
			Onglet ongletMarco = vOnglets.get(Onglet.ONGLET_AFFAIRE_EXPORT);
			ongletMarco.bHidden = false;
		}	
	}
	Vector<AvisRectificatif> vAvisRectificatif 
		= AvisRectificatif.getAllAvisRectificatifWithType(iIdAffaire,AvisRectificatifType.TYPE_AAPC);

	if(sessionUserHabilitation.isHabilitate("IHM-DESK-AFF-RECT-2") 
	&&  bAffairePubliee && vAvisRectificatif != null && vAvisRectificatif.size()>0)
	{
		Onglet ongletRect = vOnglets.get(Onglet.ONGLET_AFFAIRE_RECTIFICATIF);
		ongletRect.bHidden = false;
	}


	if(sessionUserHabilitation.isHabilitate("IHM-DESK-AFF-PARAM-xxx") )
	{
		Onglet ongletRect = vOnglets.get(Onglet.ONGLET_AFFAIRE_PARAMETRES);
		ongletRect.bHidden = false;
	}
	
	if(!bIsContainsDCEManagement)
	{
		Onglet ongletRect = vOnglets.get(Onglet.ONGLET_AFFAIRE_DCE);
		ongletRect.bHidden = true;
	}
	
	boolean bDCECorrupted = false;
	Vector<MarchePieceJointe> vPJCorrupted = MarchePieceJointe.getAllMarchePieceJointeCorruptedFromMarche(marche.getIdMarche(),false);
	if(vPJCorrupted.size()>0)
		bDCECorrupted = true;

	Onglet onglet = vOnglets.get(iIdOnglet);
	onglet.bIsCurrent = true;
	
	bIsOngletInstancie = marche.isOngletInstancie(onglet.iId);
	boolean bLectureSeule = marche.isLectureSeule(false);;
	boolean bDCEDisponible = marche.isDCEDisponible(true);   
	if(!bIsOngletInstancie && !bLectureSeule) sAction = "store";
	MarcheType oMarcheType = null;
	try{
		oMarcheType = MarcheType.getMarcheTypeMemory( marche.getIdMarcheType() ); 
	}
	catch(CoinDatabaseLoadException e){
		oMarcheType = new MarcheType();
	}
	
	boolean bAAPCAutomatique = marche.isAAPCAutomatique(false);
	
	//ONGLET CRITERES
	AutoFormCptDoubleMultiSelect afIdArticleSelection = null;
	AutoFormCptSelect afIdMarchePassation = null;
	AutoFormCptSelect afIdProcedure = null;
	AutoFormCptBlock afBlockTypeAvis = null;
	AutoFormCptBlock afBlockProcedure = null;
	AutoFormCptBlock afBlockPub = null;
	AutoFormCptInputRadioSet afTypePublication = null;
	MarcheProcedure marProc = new MarcheProcedure();
	//Vector<ArticleLoi> vArticleLoiMarche = null;
	AutoFormCptSelect afProcedureSimpleEnveloppe = null;
	 
	if(iIdOnglet == Onglet.ONGLET_AFFAIRE_CRITERES){
		try {
			marProc = MarcheProcedure.getFromMarche(marche.getIdMarche());
		} catch (Exception e) {}
		
		if(marProc == null)
			marProc = new MarcheProcedure();
		
		%><%@ include file="pave/blocAutoformAffaire.jspf" %><%
	}
		
	if(sAction.equals("store") )
	{
		JSONArray jTypeForm = BoampFormulaireType.getJSONArray();
		JSONArray jPass = MarchePassation.getJSONArray(false);
		JSONArray jNiveau = AffaireProcedureType.getJSONArray(false);
		JSONArray jLois = ArticleLoi.getJSONArrayEtatValide(false);
		JSONArray jProc = AffaireProcedure.getJSONArray(sessionUserHabilitation);
	
%>
<%@ include file="pave/checkOngletsAAPC.jspf" %>  
<script type="text/javascript" src="<%= rootPath %>dwr/interface/PersonnePhysiqueModula.js" ></script>
<script type="text/javascript" src="<%= rootPath %>dwr/interface/CodeNuts.js" ></script>
<script type="text/javascript" src="<%= rootPath %>dwr/interface/AutoFormCptDoubleMultiSelect.js" ></script>
<script type="text/javascript" src="<%= rootPath %>dwr/interface/BoampCPFMotCle.js" ></script>
<script type="text/javascript" src="<%= rootPath %>dwr/interface/CodeCpfSwitcher.js" ></script>

<script type="text/javascript" src="<%= rootPath %>include/AjaxComboList.js?v=<%= JavascriptVersion.AJAX_COMBO_LIST_JS %>"></script>
<script type="text/javascript" src="<%= rootPath %>include/fonctions.js"></script>
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
	try{ form2[sFormPrefix + "site_web"].value = ""; } catch(e) {}
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
	
		

	boolean bOnLoad = false;

	if(sAction.equals("store") 
	//|| iIdOnglet == Onglet.ONGLET_AFFAIRE_RECTIFICATIF 
	|| iIdOnglet == Onglet.ONGLET_AFFAIRE_EXPORT) 
	{
		bShowForm = true;
		if(iIdOnglet == Onglet.ONGLET_AFFAIRE_DCE) bShowForm = false;
		bOnLoad = true;
	}
	

	if ((iIdOnglet == Onglet.ONGLET_AFFAIRE_RECTIFICATIF) 
		|| (iIdOnglet == Onglet.ONGLET_AFFAIRE_PARAMETRES))
	{
		bShowForm = false;
		bShowValidationButton = false;
	}
	
	
	sTitle = marche.getTitle();
	boolean bAfficherPoursuivreProcedure = true;
%>
<link rel="stylesheet" type="text/css" href="<%= rootPath %>include/component/calendar/calendar.css" media="screen" />
<script type="text/javascript" src="<%= rootPath %>include/component/calendar/calendar.js"></script>
<script type="text/javascript">
var rootPath = "<%=rootPath%>";
mt.config.enableAutoRoundPave = false;
</script>
<script type="text/javascript">
function isProcedureSelect(iIdProcedure)
{
	if(iIdProcedure == 0 || iIdProcedure == 27)
	{
		alert("Vous devez sélectionner le mode de passation avant! (onglet criteres)");
		return false ;
	}
	else
		return true ;
}

</script>
<script type="text/javascript" src="<%= rootPath %>dwr/interface/Sticker.js" ></script>
<script type="text/javascript" src="<%= rootPath %>dwr/util.js" ></script>
 
 
<script type="text/javascript">

function displayInformationMessageBoamp()
{
	var sHTML = $('sInformationMessageBoamp').value;
    
    openModalMessageBoamp(null,"Information BOAMP", sHTML );
}


function openModalMessageBoamp(obj, sTitle, sHTML){
    var modal, div ;
    
    try{div = createModalMessageBoamp(obj,parent.document,sTitle, sHTML);}
    catch(e){div = createModalMessageBoamp(obj,document, sTitle, sHTML);}
    
    try {modal = new parent.Control.Modal(false,{contents: div});}
    catch(e) {modal = new Control.Modal(false,{contents: div});}

    modal.container.insert(div);
    modal.open();
}

function createModalMessageBoamp(obj, doc, sTitle, sHTML ){
    
    var modal_princ = doc.createElement("div");
    
    var divControls = doc.createElement("div");
    divControls.className = "modal_controls";
        
    var divTitle = doc.createElement("div");
    divTitle.className = "modal_title";
    divTitle.innerHTML = sTitle;
    
    
    var img = doc.createElement("img");
    img.style.position = "absolute";
    img.style.top = "3px";
    img.style.right = "3px";
    img.style.cursor = "pointer";
    img.src = "<%= rootPath %>images/icons/close.gif";
    img.onclick = function(){
        try {new parent.Control.Modal.close();}
        catch(e) { Control.Modal.close();}
    }
    
    divControls.appendChild(divTitle);
    divControls.appendChild(img);
    
    var divFrame = doc.createElement("div");
    divFrame.className = "modal_frame_principal";
    
    var divContent = doc.createElement("div");
    divContent.className = "modal_frame_content";
    divContent.style.height = "450px";
    divContent.style.overflow = "auto";
    divContent.innerHTML = sHTML;
    divFrame.appendChild(divContent);

    
    var divOptions = doc.createElement("div");
    divOptions.className = "modal_options";

    
    modal_princ.appendChild(divControls);
    modal_princ.appendChild(divFrame);
    modal_princ.appendChild(divOptions);
    modal_princ.style.width="800px";
    
    return modal_princ;
}


function createStickerMarche()
{
	// DO NOT REMOVE
}

Event.observe(window,"load",function(){
<%

	if( iIdOnglet == Onglet.ONGLET_AFFAIRE_PLANNING 
	&& (!sAction.equals("store") 
	||	(sAction.equals("store") && bIsRectification) ) 
	)
	{ 
%>
    try{
        $$(".organisationSelectedClass").each(function(item){
            item.disabled=true;
        });
        
    } catch(e){}

<%
	}
%>
});
</script >

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

<body <%= bOnLoad?"onload='onAfterPageLoading()'":"" %>>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<%@ include file="/include/new_style/headerAffaire.jspf" %>
<p style="text-align:center" class="mention">
 	Date de création : <%= CalendarUtil.getDateFormatteeNeant(marche.getDateCreation())  %>&nbsp;&nbsp;&nbsp;
 	Dernière modification : <%=CalendarUtil.getDateFormatteeNeant( marche.getDateModification())%>
</p>
<% 	if(bIsRectification)
	{
 %><div class="avertissementRouge">ATTENTION : AFFAIRE EN COURS DE RECTIFICATION !</div>
 <%} %>
<div class="tabFrame">
<%@ include file="pave/afficherOngletsAffaire.jspf" %>
<div class="tabContent">
<%
if(bShowForm )
{
%>
					<form 
						action="<%= response.encodeURL("modifierAffaire.jsp") %>" 
						method="post" 
						name="formulaire" 
						id="formulaire" 
						class="validate-fields" >
<%
}

if (bShowValidationButton )
{
%>
<div align="right" >
<%@ include file="pave/paveBoutonValidation.jspf" %>
</div>
<br />
<%
}

request.setAttribute("marche", marche);	
request.setAttribute("organisation", organisation);	
request.setAttribute("afBlockTypeAvis", afBlockTypeAvis);
request.setAttribute("afBlockProcedure", afBlockProcedure);
request.setAttribute("afProcedureSimpleEnveloppe", afProcedureSimpleEnveloppe);
request.setAttribute("marProc", marProc);

if( iIdOnglet == Onglet.ONGLET_AFFAIRE_OBJET )
{ 
	if(sAction.equals("store") )
	{ 
		
%>
	<div>
	<jsp:include page="pave/ongletObjetForm.jsp" flush="false" /> 
	</div>
<% 
	}
	else 
	{ 
%>
		<div>
		<jsp:include page="pave/ongletObjet.jsp" flush="false" />
		</div>
<%
	}	
}

if( iIdOnglet == Onglet.ONGLET_AFFAIRE_CARACTERISTIQUES )
{
	if(sAction.equals("store") )
	{ 
%>
	<div>
	<jsp:include page="pave/ongletCaracteristiquesPrincipalesForm.jsp" flush="false"  />
	</div>
<%
	}
	else 
	{ 
%>
	<div><jsp:include page="pave/ongletCaracteristiquesPrincipales.jsp" flush="false" />
	</div>
<%
	}
}
if( iIdOnglet == Onglet.ONGLET_AFFAIRE_CONDITIONS )
{
	if(sAction.equals("store") )
	{ 
%>
<div><jsp:include page="pave/ongletConditionsForm.jsp" flush="false"  />
</div>
<%
	}	else 
	{ 
%>
<div>
<jsp:include page="pave/ongletConditions.jsp" flush="false"  /> 
</div>
<%
	}
}
if( iIdOnglet == Onglet.ONGLET_AFFAIRE_CRITERES )
{
%>
	<div>
<%
	//String sPaveCritereTitre = "Critères d'attribution";
	if(sAction.equals("store") )
	{
	sPageUseCaseId = "IHM-DESK-AFF-CRE-3"; 
%>
	<%@ include file="/desk/include/checkHabilitationPage.jspf" %>
	<div>
	<jsp:include page="pave/ongletCriteresForm.jsp">
		<jsp:param name="bIsRectification" value="<%= bIsRectification %>" />
		<jsp:param name="bUseFormNS" value="<%= bUseFormNS %>" />
		<jsp:param name="bUseFormUE" value="<%= bUseFormUE %>" />
	</jsp:include>
	</div> 
<% 
	}
	else 
	{ 
%>
	<jsp:include page="pave/ongletCriteres.jsp">
		<jsp:param name="bUseFormNS" value="<%= bUseFormNS %>" />
		<jsp:param name="bUseFormUE" value="<%= bUseFormUE %>" />
	</jsp:include>
<% 
	}
%>
</div>
<%
}
if( iIdOnglet == Onglet.ONGLET_AFFAIRE_AUTRES )
{
%>
<div>
<%
	if(sAction.equals("store") )
	{ 
%>
<jsp:include page="pave/ongletAutresRenseignementsForm.jsp" flush="false" />
<%
	} else { 
%>
<jsp:include page="pave/ongletAutresRenseignements.jsp" flush="false"  />
<%
	}	
%>
</div>
<%
}

if( iIdOnglet == Onglet.ONGLET_AFFAIRE_PLANNING )
{
%>
<div>
<%
	if(sAction.equals("store") )
	{
%>
	<jsp:include page="pave/ongletPlaningForm.jsp" flush="false">
			<jsp:param name="sFormPrefix" value="<%= sFormPrefix %>" />
			<jsp:param name="sPageUseCaseId" value="<%= sPageUseCaseId %>" />
			<jsp:param name="bIsContainsAAPCPublicity" value="<%= bIsContainsAAPCPublicity %>" />
			<jsp:param name="bIsLinkedPublicityAndCandidature" value="<%= bIsLinkedPublicityAndCandidature %>" />
			<jsp:param name="bIsContainsEnveloppeAManagement" value="<%= bIsContainsEnveloppeAManagement %>" />
			<jsp:param name="bIsContainsCandidatureManagement" value="<%= bIsContainsCandidatureManagement %>" />
			<jsp:param name="bIsForcedNegociationManagement" value="<%= bIsForcedNegociationManagement %>" />
			<jsp:param name="bIsRectification" value="<%= bIsRectification %>" /> 
	</jsp:include>
<%  
	}
	else 
	{ 
%>
	<jsp:include page="pave/ongletPlaning.jsp"  flush="false">
		<jsp:param name="sFormPrefix" value="<%= sFormPrefix %>" />
		<jsp:param name="sPageUseCaseId" value="<%= sPageUseCaseId %>" />
		<jsp:param name="bIsContainsAAPCPublicity" value="<%= bIsContainsAAPCPublicity %>" />
		<jsp:param name="bIsLinkedPublicityAndCandidature" value="<%= bIsLinkedPublicityAndCandidature %>" />
		<jsp:param name="bIsContainsEnveloppeAManagement" value="<%= bIsContainsEnveloppeAManagement %>" />
		<jsp:param name="bIsContainsCandidatureManagement" value="<%= bIsContainsCandidatureManagement %>" />
		<jsp:param name="bIsForcedNegociationManagement" value="<%= bIsForcedNegociationManagement %>" />
	</jsp:include>
<%
	}
%>
</div>
<%
}
if( iIdOnglet == Onglet.ONGLET_AFFAIRE_LOTS )
{
%>
<div>
<%
	if(sAction.equals("store") )
	{
	String sHiddenRedirectURL = "afficherAffaire.jsp"
		+ "?iIdOnglet="+iIdOnglet
		+ "&iIdAffaire="+iIdAffaire
		+ "&sAction=store";	
	sPageUseCaseId = "IHM-DESK-AFF-CRE-4"; 
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
%>
		<jsp:include page="pave/ongletLotsForm.jsp" flush="false"  >
			<jsp:param name="sHiddenRedirectURL" value="<%= sHiddenRedirectURL %>" /> 
			<jsp:param name="bIsRectification" value="<%= bIsRectification %>" /> 
		</jsp:include><%
	}	
	else 
	{
%>
<jsp:include page="pave/ongletLots.jsp" flush="false"  />
<%
	}	
%>
</div>
<%
}

if( iIdOnglet == Onglet.ONGLET_AFFAIRE_ORGANISME )
{
%>
<jsp:include page="pave/ongletOrganisme.jsp" flush="false"  >
  <jsp:param name="sAction" value="<%= sAction %>" /> 
</jsp:include>
<%
}

if( iIdOnglet == Onglet.ONGLET_AFFAIRE_DCE)
{
%>
<div>
<%
	if(sAction.equals("store") )
	{
	   if(sActionDCE.equals("MultipleUL") )
	   {
%>
<%@ include file="pave/ongletDCEV2Form.jspf" %>
<%
	   } else { 
%>

	       <p class="mention" style="color:#F00">Attention, si vous passez par un proxy, 
            vous ne pouvez pas activer le téléchargement multiple
	       <br/><button onclick="Redirect('<%= response.encodeURL(
	    		   "afficherAffaire.jsp"
	    		            + "?iIdOnglet="+iIdOnglet
	    		            + "&iIdAffaire="+iIdAffaire
	    				    + "&sAction=store&sActionDCE=MultipleUL") %>')">Téléchargement multiple</button>
	       </p>
	       <br/>
 <%@ include file="pave/ongletDCEForm.jspf" %>
<%
	   } 
	}
	else 
	{ %><%@ include file="pave/ongletDCE.jspf" %><%}
	%></div><%
}

if( (iIdOnglet == Onglet.ONGLET_AFFAIRE_EXPORT) 
|| (iIdOnglet == Onglet.ONGLET_AFFAIRE_RECTIFICATIF))
{
%>
<div>
		<jsp:include page="pave/ongletOptions.jsp" flush="false" >
			<jsp:param name="sActionRectificatif" value="<%= sActionRectificatif %>" /> 
			<jsp:param name="iIdOnglet" value="<%= iIdOnglet %>" /> 
			<jsp:param name="iIdAvisRectificatif" value="<%= iIdAvisRectificatif %>" /> 
			<jsp:param name="iTypeAvisRectificatif" value="<%= AvisRectificatifType.TYPE_AAPC %>" />
			<jsp:param name="bFormJOUE" value="<%= bFormJOUE %>" />
			<jsp:param name="bRectifFormJoueCompleted" value="<%= bRectifFormJoueCompleted %>" />
            <jsp:param name="bCreationArec" value="<%= bCreationArec %>" />
		</jsp:include>
</div>
<%
}

if( iIdOnglet == Onglet.ONGLET_AFFAIRE_PARAMETRES )
{
	String sActionParam = "";
	
	if(request.getParameter("sActionParam") != null)
		sActionParam = request.getParameter("sActionParam");

	Vector<MarcheParametre> vParams = MarcheParametre.getAllFromIdMarche(marche.getIdMarche());
	request.setAttribute("vParams", vParams);
%>
<div>
<%
	if(sActionParam.equals("store"))		
	{
%>
	<jsp:include page="pave/ongletMarcheParametreForm.jsp" />
<%	}else{ %>
	<jsp:include page="pave/ongletMarcheParametre.jsp" />
<%	}
	%></div><%
}

if( iIdOnglet == Onglet.ONGLET_AFFAIRE_ANNULATION)
{
	%><div><%
	out.write( modula.marche.graphic.OngletAapcAnnulation.getHtml(marche, sAction)); 
	%></div><%
}





if( iIdOnglet == Onglet.ONGLET_AFFAIRE_JOUE)
{
%>
	<jsp:include page="pave/ongletJoue.jsp">
			<jsp:param name="bIsRectification" value="<%= bIsRectification %>" /> 
			<jsp:param name="sAction" value="<%= sAction %>" /> 
	</jsp:include>	
<%
}



//if(sAction.equals("store") )
{
	if (bShowValidationButton )
	{
%>
	<br />
	<div align="right" >
	<%@ include file="pave/paveBoutonValidation.jspf" %>
	</div>
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
</html>