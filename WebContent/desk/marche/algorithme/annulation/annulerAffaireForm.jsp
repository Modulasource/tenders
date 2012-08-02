<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="modula.marche.*"%>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);

	String sTitleSansSuite = "Déclarer l'affaire sans suite";
	String sTitle = "Annuler l'affaire";
	String sMention = "Attention les pièces du DCE que vous avez peut-être déposé sur le serveur seront supprimées.";
	String sMentionSansSuite = "Vous allez déclarer cette affaire sans suite,  vous devez publier l'annulation de l'affaire puis prévenir les candidats de cette annulation.<br />"+
	"Pendant 15 jours votre afffaire resera en ligne sur votre portail portant la mention <i>affaire déclarée sans suite</i> ";
	String sPageUseCaseId = "IHM-DESK-AFF-32";
	
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId );
	boolean bPublicationAnnulationAffaire = marche.isAnnulationAffairePubliee(false);
	boolean bCandidatsPrevenusAnnulationAffaire = marche.isCandidatsPrevenusAnnulationAffaire(false);
	boolean bAffaireValide = marche.isAffaireValidee(false);
	String sHeadTitre = "";
	if (bAffaireValide) {sHeadTitre = sTitleSansSuite;sMention = sMentionSansSuite;}
	else sHeadTitre = sTitle;
	boolean bAfficherPoursuivreProcedure = false;

%>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<div style="padding:15px">
<%@ include file="/include/new_style/headerAffaireOnlyButtonDisplayAffaire.jspf" %>
<p class="mention"><%= sMention %></p>
<%
if(bAffaireValide)
{
%>
<table class="pave" >
	<tr>
		<td colspan="2" class="pave_titre_gauche">Statut de l'annulation de l'affaire</td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Annulation de l'affaire publiée: </td>
		<td class="pave_cellule_droite"><%= (bPublicationAnnulationAffaire ? "Oui" : "Non") %>&nbsp;&nbsp;&nbsp;
		<%
		if(!bPublicationAnnulationAffaire)
		{
		%>
		<button type="button"
			onclick="javascript:openModal('<%= response.encodeURL(rootPath 
					+ "desk/marche/algorithme/annulation/publierAnnulationAffaireForm.jsp?iIdAffaire="+iIdAffaire) 
					%>','Publications','700px','550px');">
			Publier l'annulation de l'affaire</button>
		<%
		}
		%>
		</td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Candidats prévenus de l'annulation de l'affaire: </td>
		<td class="pave_cellule_droite"><%= (bCandidatsPrevenusAnnulationAffaire ? "Oui" : "Non") %>&nbsp;&nbsp;&nbsp;
		<%
		if(!bCandidatsPrevenusAnnulationAffaire)
		{
		%>
		<button type="button"
			onclick="javascript:openModal('<%= response.encodeURL(rootPath 
					+ "desk/marche/algorithme/annulation/prevenirCandidatsAnnulationAffaireForm.jsp?iIdAffaire="+iIdAffaire) 
					%>','Candidats','700px','550px')">
			Prévenir les candidats de l'annulation
			</button>	
		<%
		}
		%>
		</td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
</table>
<br />
<div style="text-align:center">
<%
if((bCandidatsPrevenusAnnulationAffaire && bPublicationAnnulationAffaire) || !bAffaireValide)
	{
%>
<div style="text-align:center">
	<button type="button"
	onclick="Redirect('<%= 
		response.encodeURL(rootPath + "desk/marche/algorithme/annulation/annulerMarche.jsp"
				+ "?iIdAffaire="+iIdAffaire) %>')">
	Annuler et archiver l'affaire
	</button>
</div>
<%
	}
%>
</div>
<%
}
else{
%>
<br />
<div style="text-align:center">
	<button type="button"
		onclick="Redirect('<%= response.encodeURL(rootPath + "desk/marche/algorithme/annulation/annulerMarche.jsp?iIdAffaire="+iIdAffaire) %>')">
		Supprimer l'affaire
		</button>
</div>
<%
	}
%>
<br/>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>