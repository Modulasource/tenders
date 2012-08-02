<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="modula.marche.*, org.coin.fr.bean.*, modula.candidature.*, java.util.*" %>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);

	String sHost = request.getServerName();
	int iPort = request.getServerPort();
	String sContext = request.getContextPath();
	boolean bCommentaireEnregistre =  HttpUtil.parseBoolean("bCommentaireEnregistre", request, false);
	int iIdCandidature = Integer.parseInt(request.getParameter("iIdCandidature"));
	int iIdNextPhaseEtapes = HttpUtil.parseInt("iIdNextPhaseEtapes", request,-1);
	int iIdLot = Integer.parseInt(request.getParameter("iIdLot"));
	MarcheLot lot = MarcheLot.getMarcheLot(iIdLot);
	Candidature candidature = Candidature.getCandidature(iIdCandidature);
	Organisation organisationCDT = Organisation.getOrganisation(candidature.getIdOrganisation());

	String sTitle = "Ouverture de l'offre de : "+organisationCDT.getRaisonSociale();
	boolean bIsAnonyme = marche.isEnveloppesBAnonyme(false);
	
	if(bIsAnonyme)
		sTitle = "Ouverture de l'offre ORG"+organisationCDT.getId();
	
	sessionUserHabilitation.isHabilitateException("IHM-DESK-AFF-38");
%>
</head>
<body
<%
	if(bCommentaireEnregistre)
	{
%>
onload="alert('Commentaire enregistré!');"
<%
	}	
%>
>
<%@ include file="/include/new_style/headerFichePopUp.jspf" %>
<br/>
<div style="padding:15px">
<%
	Vector vEnveloppes = EnveloppeB.getAllEnveloppeBFromCandidatureAndLotAndValidite(candidature.getIdCandidature(), iIdLot,lot.getIdValiditeEnveloppeBCourante());
	if(vEnveloppes != null && vEnveloppes.size() == 1)
	{
		EnveloppeB eEnveloppe = (EnveloppeB)vEnveloppes.firstElement();
%>
<form action="<%= response.encodeURL("modifierCommentaireEnveloppeB.jsp") %>" method="post"  name="formulaire">
<input type="hidden" name="iIdEnveloppe" value="<%= eEnveloppe.getIdEnveloppe()%>" />
<input type="hidden" name="iIdNextPhaseEtapes" value="<%= iIdNextPhaseEtapes %>" />
<input type="hidden" name="iIdLot" value="<%= iIdLot %>" />
<input type="hidden" name="iIdCandidature" value="<%= iIdCandidature %>" />
<input type="hidden" name="iIdAffaire" value="<%= iIdAffaire %>" />
<br />
<table class="pave" >
	<tr>
		<td class="pave_titre_gauche">Votre Commentaire</td>
	</tr>
	<tr>
		<td style="font-weight:bold;text-align:center">
		Ces commentaires ne seront pas transmis au candidat. Ils feront l'objet d&rsquo;une 
		écriture dans le journal des événements de votre affaire.
		</td>
	</tr>
	<tr>
		<td align="center">
		<textarea name="reponse" rows="5" cols="100"><%= (!eEnveloppe.getReponse().equals("")
				? eEnveloppe.getReponse() : "") %></textarea>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
</table>
<br />
<%
	String sRedirectURL = response.encodeURL(rootPath + "desk/marche/algorithme/proposition/gestion/afficherLotsEtEnveloppesB.jsp?iIdOnglet="
			+MarcheLot.getMarcheLot(iIdLot).getNumero()
			+"&iIdLot="+iIdLot+"&iIdNextPhaseEtapes="+ iIdNextPhaseEtapes
			+"&iIdAffaire="+iIdAffaire);
%>
<div style="text-align:center">
	<button type="button" name="valider" onclick="closeModalAndRedirectTabActive('<%= sRedirectURL	%>')" >Fermer la fenêtre</button>
	<button type="submit" name="submit" >Enregistrer le commentaire</button>
</div>
</form>
<%
}
%>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
<%@page import="org.coin.util.HttpUtil"%>
</html>