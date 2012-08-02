<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@page import="modula.configuration.ModulaConfiguration"%>
<%@page import="modula.applet.*"%>
<%@ page import="org.coin.fr.bean.*,modula.configuration.*,modula.applet.util.*,org.coin.util.*,java.net.*,org.coin.util.treeview.*,modula.algorithme.*,modula.*,java.text.*,modula.marche.*, modula.candidature.*, java.util.*,org.coin.bean.*" %>
<%

	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);

	int iTypeEnveloppe = HttpUtil.parseInt("iTypeEnveloppe",request);;
	int iIdNextPhaseEtapes = HttpUtil.parseInt("iIdNextPhaseEtapes", request,-1);
	String sUrlTraitement = HttpUtil.parseStringBlank("sUrlTraitement", request);

	session.setAttribute("iTypeEnveloppe",iTypeEnveloppe);	
	
	PersonnePhysique responsable = null;
	try{responsable = marche.getResponsable(iTypeEnveloppe);}
	catch(Exception e){	/*le responsable n'a pas été défini")*/}
	
	PersonnePhysique delegue = null;
	try{delegue = marche.getDelegue(iTypeEnveloppe);}
	catch(Exception e){/*le delegue n'a pas été défini")*/}
		
	URL oURLImage = null;
	URL oURLServlet = null;
	URL oURLTraitement = null;
	
	oURLImage = HttpUtil.getUrlWithProtocolAndPort(
				rootPath+"images/icones/",
				request); 
	oURLServlet = HttpUtil.getUrlWithProtocolAndPort(
				rootPath,
				request); 

	String sURL[] = Outils.parserChaineVersString(response.encodeURL(oURLServlet.toString()),";");
	
	String sSessionId = "";
	if(Outils.parserChaineVersString(response.encodeURL(oURLServlet.toString()),";") != null) sSessionId = ";"+sURL[1];
	

	oURLTraitement = HttpUtil.getUrlWithProtocolAndPort(
				rootPath+sUrlTraitement,
				request); 
		
	
	String sVaultPath = "";
	try	{sVaultPath = MarcheParametre.getMarcheParametreValue(iIdAffaire,"vault.path");}
	catch(Exception e){sVaultPath = "";}
	
	String sPageUseCaseId = "";
	String sTitle = "";
	boolean bEnveloppesDecachetees = false;
	boolean bAddCandPapier = false;
	String sTitleCandidature = "";
	String sTypeEnveloppe = "";
	long lIdInfoBulle = 0;
	int iIdValidite = 0;
	boolean bAfficheDecachetage = true;
	
	switch(iTypeEnveloppe){
	case Enveloppe.TYPE_ENVELOPPE_A:
		sPageUseCaseId = "IHM-DESK-AFF-12";
		sTitle = "Décachetage des candidatures de l'affaire réf. " + marche.getReference();
		bEnveloppesDecachetees = marche.isEnveloppesADecachetees(false);
		sTitleCandidature = "Candidatures valides";
		sTypeEnveloppe = "A";
		lIdInfoBulle = InfosBullesConstant.OUVERTURE_ENVELOPPE_A;
		bAddCandPapier = HttpUtil.parseBoolean("bAddCandPapier", request, true) ;
		bAfficheDecachetage = true;
		break;
	case Enveloppe.TYPE_ENVELOPPE_B:
		sPageUseCaseId = "IHM-DESK-AFF-15";
		sTitle = "Décachetage des offres de l'affaire réf. " + marche.getReference();
		bEnveloppesDecachetees = marche.isEnveloppesBDecachetees(false);
		
		MarcheLot lot = MarcheLot.getAllLotsConstituablesFromMarche(marche).firstElement();
		iIdValidite = lot.getIdValiditeEnveloppeBCourante();
		boolean bIsFirstValidite = Validite.isFirstValiditeFromAffaire(iIdValidite,iIdAffaire);
		boolean bIsContainsEnveloppeCManagement = AffaireProcedure.isContainsEnveloppeCManagement(marche.getIdAlgoAffaireProcedure());
		if(bIsFirstValidite)
		{
			sTitleCandidature = "Candidatures recevables";
			if(bIsContainsEnveloppeCManagement)
				sTitleCandidature = "Candidatures retenues";
		}
		else sTitleCandidature = "Candidatures retenues pour négociation";
		sTypeEnveloppe = "B";
		lIdInfoBulle = InfosBullesConstant.VIRUS;
		bAddCandPapier = false;
		bAfficheDecachetage = true;
		break;
	case Enveloppe.TYPE_ENVELOPPE_C:
		sPageUseCaseId = "IHM-DESK-AFF-15";
		sTitle = "Décachetage des offres de l'affaire réf. " + marche.getReference();
		bEnveloppesDecachetees = marche.isEnveloppesCDecachetees(false);
		
		lot = MarcheLot.getAllLotsConstituablesFromMarche(marche).firstElement();
		iIdValidite = lot.getIdValiditeEnveloppeBCourante();
		bIsFirstValidite = Validite.isFirstValiditeFromAffaire(iIdValidite,iIdAffaire);
		sTitleCandidature = bIsFirstValidite?"Candidatures recevables":"Candidatures retenues pour négociation";
		sTypeEnveloppe = "C";
		lIdInfoBulle = InfosBullesConstant.VIRUS;
		bAddCandPapier = false;
		bAfficheDecachetage = HttpUtil.parseBoolean("bAfficheDecachetage", request, false) ;
		break;
	}

	if(!sPageUseCaseId.equalsIgnoreCase(""))
		sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
%>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<br/>
<div style="padding:15px">
<%@ include file="/include/new_style/headerAffaireOnlyButtonDisplayAffaire.jspf" %>
<%
if(bEnveloppesDecachetees)
{
%>
<br/>
<div style="text-align:center">
	<table class="pave" style="width: 100%;" align="center">
		<tr>
			<td class="pave_titre_gauche" colspan="2">Décachetage</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
		<td class="message_icone"><img src="<%= rootPath %>images/icones/succes.gif" alt="Icone"></td>
		<td style="text-align: left;">Le décachetage a été réalisé avec succès.
		</td>
		</tr>
	</table>
</div>
<%
} else if(bAddCandPapier){
%>
<br/>
<div style="text-align:center">
	<table class="pave" style="width: 100%;" align="center">
		<tr>
			<td class="pave_titre_gauche" colspan="2">Candidatures Papiers</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
		<td class="message_icone"><img src="<%= rootPath %>images/icones/warning.gif" alt="Icone"></td>
		<td style="text-align: left;">Attention après avoir décacheté les plis, vous ne 
		pourrez plus ajouter de candidature papier.</td>
		</tr>
		<tr><td colspan="2">
			<button type="button" 
			value="" 
			onclick="Redirect('<%= response.encodeURL(rootPath 
				+ "desk/marche/algorithme/proposition/candidature/modifyCandidatureForm.jsp?iIdAffaire=" 
				+ marche.getId()) %>')" >Ajouter une candidature papier</button>
		</td></tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr><td colspan="2" style="font-size:14pt">
			<button type="button" 
			onclick="Redirect('<%= 
				response.encodeURL("decacheterEnveloppeForm.jsp"
						+ "&iIdAffaire=" + marche.getId()
						+ "&iTypeEnveloppe=" + iTypeEnveloppe
						+ "&iIdNextPhaseEtapes=" + iIdNextPhaseEtapes
						+ "&sUrlTraitement=" + sUrlTraitement
						+ "&bAddCandPapier=false"  ) 
					%>');" >Le cas échéant, la liste des candidatures papiers est complète. L'ouverture des plis peut débuter.</button>
		</td></tr>
		<tr><td colspan="2">&nbsp;</td></tr>
	</table>
	
</div>
<%
}
%>

<%
if(!bEnveloppesDecachetees && !bAfficheDecachetage )
{
%>
<form name="formulaire" id="formulaire" method="post" action="<%= response.encodeURL("decacheterEnveloppe.jsp") %>" >
<input type="hidden" name="iIdNextPhaseEtapes" value="<%= iIdNextPhaseEtapes %>" />
<input type="hidden" name="sUrlTraitement" value="<%= sUrlTraitement %>" />
<input type="hidden" name="sAction" value="anonyme" />
<input type="hidden" name="iTypeEnveloppe" value="<%= iTypeEnveloppe %>" />
<table class="pave" > 
	<tr>
		<td class="pave_titre_gauche">Option d'Anonymat</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td><img src="<%=rootPath + Icone.ICONE_WARNING %>" style="vertical-align:middle" alt="Warning"/>
		Souhaitez-vous traiter les candidatures suivantes de façon anonyme?</td>
	</tr>
	<tr>
		<td>
		<input type="radio" name="iAnonyme" value="1" />Oui&nbsp;&nbsp;
		<input type="radio" name="iAnonyme" value="2" checked="checked" />Non
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td><input type="submit" name="valider" value="Valider mon choix" /></td>
	</tr>
	<tr><td>&nbsp;</td></tr>
</table>
</form>
<%
}else{
	if(!bAddCandPapier)
	{
%>
<br />
<div id="divDecachetage">
<table class="pave" summary="none"> 
	<tr>
		<td class="pave_titre_gauche"><%= sTitleCandidature %></td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td class="mention">Si vous souhaitez décacheter toutes ou certaines candidatures reçues hors délai, il vous suffit de les cocher</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
	  	<td width="100%" height="100%" align="center">
		<applet code="modula.applet.AppletDecachetageEnveloppe.class" width="550" height="<%= bEnveloppesDecachetees?"300":"470" %>" 
		  archive="<%= rootPath + "include/jar/" + AppletConstitutionEnveloppe.APPLET_VERSION  %>"> 
		<param name="iIdMarche" value="<%= iIdAffaire %>" >
		<param name="iIdValidite" value="<%= iIdValidite %>" >
		<param name="iIdNextPhaseEtapes" value="<%= iIdNextPhaseEtapes %>" > 
		<param name="sUrlTraitement" value="<%= oURLTraitement.toString() %>" > 
		<param name="bIsDecachete" value="<%= bEnveloppesDecachetees %>">
		<param name="sTypeEnveloppe" value="<%= sTypeEnveloppe %>" >
		<param name="sPathServlet" value="<%= oURLServlet.toString() %>">
		<param name="sPathImage" value="<%= oURLImage.toString() %>">
		<param name="sSessionId" value="<%= sSessionId %>">
		<param name="iTypeApplet" value="<%= AppletConstant.APPLET_DECACHETAGE_ENVELOPPE %>">
		<param name="bSimulate" value="<%= Configuration.getConfigurationValueMemory(ModulaConfiguration.MODULA_APPLET_SIMULATE) %>">
		<param name="sMailResponsable" value="<%= (responsable != null ? responsable.getEmail():"") %>">
		<param name="sNomResponsable" value="<%= (responsable != null ? responsable.getNom():"") %>">
		<param name="sPrenomResponsable" value="<%= (responsable != null ? responsable.getPrenom():"") %>">
		<param name="sMailDelegue" value="<%= (delegue != null ? delegue.getEmail():"") %>">
		<param name="sNomDelegue" value="<%= (delegue != null ? delegue.getNom():"") %>">
		<param name="sPrenomDelegue" value="<%= (delegue != null ? delegue.getPrenom():"") %>">
		<param name="bAuthentificationUser" value="<%= Configuration.getConfigurationValueMemory(ModulaConfiguration.MODULA_SECURITE_AUTHENTIFICATION_UTILISATEUR) %>">
		<param name="bACValidation" value="<%= Configuration.getConfigurationValueMemory(ModulaConfiguration.UNSEALING_USE_CERTIFICATE_CHAIN) %>">
		<param name="vault.path" value="<%= sVaultPath %>">
		<param name="bAVActive" value="<%= Configuration.getConfigurationValueMemory(ModulaConfiguration.MODULA_SECURITE_AV) %>">
		</applet>
  		</td>
	</tr>
</table>
</div>
<br/>
<%
	}
}
if(bEnveloppesDecachetees)
{
%>
<div style="text-align:center">
	<button type="button" 
		name="poursuivre" 
		onclick="Redirect('<%= response.encodeURL(rootPath 
				+ "desk/marche/algorithme/affaire/poursuivreProcedure.jsp"
				+ "?sAction=next"
				+ "&iIdAffaire=" + marche.getId()) 
				%>')" >Poursuivre la procédure</button>
		<%= InfosBulles.getModal(lIdInfoBulle,rootPath) %>
</div>
<%
}
%>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>

</html>