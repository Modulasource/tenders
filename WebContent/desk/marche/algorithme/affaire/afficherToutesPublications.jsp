<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@ page import="org.coin.fr.bean.*" %>
<%@ page import="org.coin.fr.bean.export.*,modula.marche.*" %>
<%@ page import="modula.graphic.*" %>
<%
	int iIdAffaire;
	String sIdAffaire;
	String sPageUseCaseId = "IHM-DESK-AFF-xx";
	String sTitle; 
	String sHeadTitre = "";
	boolean bAfficherPoursuivreProcedure = false;
	String sUrlTraitement;
	Marche marche;

	int iIdNextPhaseEtapes;
	String sIsProcedureLineaire;
	 
	int iIdOnglet;
	
	int iIdTypeAvisToGenerate;
	int iIdAvisRectificatif;
	
	Commission commission;
	Vector<Organisation> vOrganisationsPublication;
	
	boolean bBOAMPPoursuivreProcedure;
   
	Vector<Onglet> vOnglets;
        
    boolean bBOAMPReadyToSend;
	boolean bBOAMPSelected;
	boolean bShowBoutonPoursuivre;
	boolean bIsErreurEmetteur;
	
	int iNumOnglet;
	
	HtmlPublication htmlPublication = new HtmlPublication(request, response);
	
	htmlPublication.isButtonDisplayable();
	
	marche = htmlPublication.marche;
	iIdAffaire = htmlPublication.iIdAffaire;
	sIdAffaire = htmlPublication.sIdAffaire;
	sTitle = htmlPublication.sTitle;
	bBOAMPPoursuivreProcedure = htmlPublication.bBOAMPPoursuivreProcedure;
	sUrlTraitement = htmlPublication.sUrlTraitement;
	iIdNextPhaseEtapes = htmlPublication.iIdNextPhaseEtapes;
	sIsProcedureLineaire = htmlPublication.sIsProcedureLineaire;
	iIdOnglet = htmlPublication.iIdOnglet;
	iIdTypeAvisToGenerate = htmlPublication.iIdTypeAvisToGenerate;
	iIdAvisRectificatif = htmlPublication.iIdAvisRectificatif;
	commission = htmlPublication.commission;
	vOrganisationsPublication = htmlPublication.vOrganisationsPublication;
	vOnglets = htmlPublication.vOnglets;
	bBOAMPReadyToSend = htmlPublication.bBOAMPReadyToSend;
	bBOAMPSelected = htmlPublication.bBOAMPSelected;
	bShowBoutonPoursuivre = htmlPublication.bShowBoutonPoursuivre;
	bIsErreurEmetteur = htmlPublication.bIsErreurEmetteur;
	
	Onglet onglet = vOnglets.get(iIdOnglet);
	onglet.bIsCurrent = true;
	
	iNumOnglet = htmlPublication.iNumOnglet;
	
	
	
	if(marche.isAffaireValidee(false)
	&& !marche.isAffaireEnvoyeeAutresSupportsPublication(false))
	{
		/**
		 * bug #2288 AG Etape 2 : Point 3.2 Evol / date mise en ligne et parution
		 */
		Timestamp tsDateEnvoiPublication = new Timestamp(System.currentTimeMillis()); 
		MarcheParametre.updateParam(
				 marche, 
				 "aapc.date.envoi.publication",
				 CalendarUtil.getXmlDatetimeFormat(tsDateEnvoiPublication));
	}
%>
<script type="text/javascript" src="<%=rootPath%>include/fonctions.js"></script>
<%@ include file="pave/checkPublications.jspf" %>  
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
<script type="text/javascript">
/** 
 * Ajouté à la main pour ne pas avoir d'erreur lors du chargement de la page.
 */
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

function confirmAndSend(sMessage,sUrl)
{
	if(!confirm(sMessage))
		return false;

	Redirect(sUrl);
	return true;
}

function confirmAndRemove(sUrl)
{
	return confirmAndSend("Etes vous sûr de vouloir supprimer ?",sUrl);
}


</script>
</head>
<body onload="javascript:onAfterPageLoading()" >
<%@ include file="/include/new_style/headerFiche.jspf" %>
<%
if(sIsProcedureLineaire == null || (sIsProcedureLineaire != null 
		&& !sIsProcedureLineaire.equalsIgnoreCase("rectificatif")))
{
%>
<%@ include file="/include/new_style/headerSelectAndValidPublication.jspf" %>
<%
}
%>
<br/>
<div class="tabFrame">
<div class="tabs">
	<%
	for (int i = 0; i < vOnglets.size(); i++) 
	{
		onglet = vOnglets.get(i);	
		try {
			String sImageInCreation = "" ;
			String sOnClick = "";
			
			String sStyle="";
			if(onglet.bHidden){
				sStyle = "style='display:none'";
				if(onglet.sLibelle.equals("Pousuivre la procédure")) sStyle = "style='display:none;background-color:#AAF242;color:#124D85'";
			} else if((i == iNumOnglet) && (onglet.sLibelle.equals("Pousuivre la procédure"))){
				sStyle = "style='background-color:#AAF242;color:#124D85'";
			}
			
			%><div <%= (onglet.bIsCurrent?"class=\"active\"":"") %>
				<%= sStyle %>
				<%= ((i == iNumOnglet) && (onglet.sLibelle.equals("Pousuivre la procédure")))?"id='tabPoursuivre'":"" %>
				onclick="javascript:location.href='<%= response.encodeURL(onglet.sTargetUrl 
					+"&iIdAffaire="+marche.getIdMarche()
					+"&nonce=" + System.currentTimeMillis())%>';">
				<%= onglet.sLibelle %><%= sImageInCreation %></div>
			<%	
		} 
		catch (Exception e) {
			e.printStackTrace();
		}
	}
	%>
</div>
<div class="tabContent">

<%
	if(iIdOnglet == Onglet.ONGLET_GESTION_PUBLICATIONS) {
%>
<div>
<jsp:include page="pave/ongletGestionPublications.jsp" flush="false" >
	<jsp:param name="iIdAffaire" value="<%= marche.getIdMarche() %>" /> 
</jsp:include>
</div>
<%
	} else if((iIdOnglet == iNumOnglet) && (onglet.sLibelle.equals("Pousuivre la procédure"))) {
%>
		<div>
		<jsp:include page="pave/ongletPoursuivreProcedure.jsp" flush="false" >
			<jsp:param name="iIdAffaire" value="<%= marche.getIdMarche() %>" /> 
		</jsp:include>
		</div>
<%
	} else {
		Export exportAff = Export.getExport(Integer.parseInt(request.getParameter("iIdExport")));
		
		Vector<Export> vExportOrg 
			= Export.getAllExportFromSourceAndDestination(
					exportAff.getIdObjetReferenceDestination(),
					ObjectType.ORGANISATION,
					exportAff.getIdObjetReferenceDestination(),
					ObjectType.ORGANISATION);
	
		for(int l=0;l<vExportOrg.size();l++){
			%><div><%
			Export export = vExportOrg.get(l);
			String sIsHidden = "";
		try {
			sIsHidden = ExportParametre.getExportParametreValue(export.getIdExport(), "export.hidden");  
		}
		catch(Exception e){}
		if(!sIsHidden.equalsIgnoreCase("true")){

		
		Organisation organisation 
			= Organisation.getOrganisation(export.getIdObjetReferenceDestination());

		String sExportModeName = "";
		
		try {
			ExportMode.getExportModeNameMemory(export.getIdExportMode());
		} catch (Exception e) {
			sExportModeName = "inconnu";
			System.out.println("ERROR : ExportMode inconnu : " 
					+ export.getIdExportMode() 
					+ " de l'export d'id : " 
					+ export.getId() + 
					", il faut paramétrer l'export dans l'onglet de l'organisme de presse : "
					+ organisation.getRaisonSociale() + "(" + organisation.getId() + ")");
			// TODO ajouter un evenement de type Warning
			//Evenement.addEvenement();
		}
%>
	<jsp:include page="modifyPublication.jsp" flush="false" >
		<jsp:param name="iIdAffaire" value="<%= marche.getIdMarche() %>" /> 
		<jsp:param name="export" value="<%= exportAff.getIdExport() %>" /> 
		<jsp:param name="iIdPublicationType" value="<%= iIdTypeAvisToGenerate %>" /> 
		<jsp:param name="sIsProcedureLineaire" value="<%= sIsProcedureLineaire %>" />
		<jsp:param name="sUrlTraitement" value="<%= sUrlTraitement %>" />
		<jsp:param name="sIdAffaire" value="<%= sIdAffaire %>" />
		<jsp:param name="iIdNextPhaseEtapes" value="<%= iIdNextPhaseEtapes %>" />
		<jsp:param name="iIdOnglet" value="<%= iIdOnglet %>" />
		<jsp:param name="iIdTypeAvisToGenerate" value="<%= iIdTypeAvisToGenerate %>" />
		<jsp:param name="iIdAvisRectificatif" value="<%= iIdAvisRectificatif %>" />
	</jsp:include>
<%
			}
		}
		int iIdOrganisationBoamp = PublicationBoamp.getIdOrganisationBoampOptional();
		
		if(iIdOrganisationBoamp == Organisation.getOrganisation(
				exportAff.getIdObjetReferenceDestination()).getIdOrganisation())
		{
%>
		<%@ include file="/desk/export/boamp/pave/paveSuiviPublication.jspf" %>
		</div>
<%
		}
	} 
%>
</div>
</div>
<%
	if(
		(!sIsProcedureLineaire.equals("false"))
		// dans le cas d'un avis rectificatif on affiche tjs le bouton
		||  sIsProcedureLineaire.equalsIgnoreCase("rectificatif") )
	{
%>
	<form 
        name="formPoursuivre"
        id="formPoursuivre" 
        method="post" 
        action="<%= response.encodeURL(rootPath
        		+ sUrlTraitement 
        		+ "#ancreHP") %>"/>
	<input type="hidden" name="iIdNextPhaseEtapes" value="<%= iIdNextPhaseEtapes %>" />
	<input type="hidden" name="sIsProcedureLineaire" value="<%= sIsProcedureLineaire %>" />
	<input type="hidden" name="iIdAvisRectificatif" value="<%= iIdAvisRectificatif %>" />
	
<%
	if(bShowBoutonPoursuivre) {
%>

	<!-- 
	<div class="center" id="poursuivreProcedure">
		<button type="submit" 
			onclick="return checkBoxPoursuivre()" >Valider l'envoi des publications (Poursuivre la procédure)</button>
	</div>
	 -->
	<%	
		}
		else{
			if(bBOAMPSelected && !bBOAMPReadyToSend)
			{
%>
			<div class="center" id="poursuivreProcedure">
				La publication au BOAMP doit être validée pour poursuivre la procédure.
			</div>				
<% 			}
			if(sessionUserHabilitation.isSuperUser())
			{
				%>
				<br />
			<div class="center" id="poursuivreProcedure">
				<button type="submit">Valider l'envoi des publications <br/>(Forcer en tant que Super Admin)
			    </button>
			</div>
<%				
			}
		}
	}
%>
	</form>
<br />
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
<%@page import="org.coin.util.HttpUtil"%>

<%@page import="mt.modula.html.HtmlPublication"%>
<%@page import="java.sql.Timestamp"%></html>