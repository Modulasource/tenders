<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@ page import="modula.marche.*,modula.candidature.*, java.util.*" %>
<%
	boolean bCommentaireEnregistre = HttpUtil.parseBoolean("bCommentaireEnregistre", request, false);

	int iIdCandidature = HttpUtil.parseInt("iIdCandidature",request);
	Candidature candidature = Candidature.getCandidature(iIdCandidature);
	
	int iIdLot = HttpUtil.parseInt("iIdLot",request);
	MarcheLot lot = MarcheLot.getMarcheLot(iIdLot);
	
	int iTypeEnveloppe = HttpUtil.parseInt("iTypeEnveloppe",request);
	String sPageUseCaseId = "";
	Vector vEnveloppes = null;
	switch(iTypeEnveloppe){
	case Enveloppe.TYPE_ENVELOPPE_A:
		sPageUseCaseId = "IHM-DESK-AFF-37";
		vEnveloppes = EnveloppeA.getAllEnveloppeAFromCandidature(candidature.getIdCandidature());
		break;
	case Enveloppe.TYPE_ENVELOPPE_B:
		sPageUseCaseId = "IHM-DESK-AFF-38";
		vEnveloppes = EnveloppeB.getAllEnveloppeBFromCandidatureAndLotAndValidite(candidature.getIdCandidature(), iIdLot,lot.getIdValiditeEnveloppeBCourante());
		break;
	case Enveloppe.TYPE_ENVELOPPE_C:
		sPageUseCaseId = "IHM-DESK-AFF-38";
		vEnveloppes = EnveloppeC.getAllEnveloppeCFromCandidatureAndLotAndValidite(candidature.getIdCandidature(), iIdLot,lot.getIdValiditeEnveloppeBCourante());
		break;
	}
	
	if(!sPageUseCaseId.equalsIgnoreCase(""))
		sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
	
	
%>
<script type="text/javascript">
onPageLoad = function(){
	if(<%= bCommentaireEnregistre %>){
		$("mention").innerHTML = "Commentaire enregistré";
	}
}
</script>
</head>
<body>
<div style="padding:15px">
<div class="mention_altColor" id="mention"></div>
<br/>
<%
if(vEnveloppes != null && vEnveloppes.size()==1)
{
	Enveloppe eEnveloppe = (Enveloppe)vEnveloppes.firstElement();
%>
<form action="<%= response.encodeURL("modifierCommentaireEnveloppe.jsp") %>" method="post"  name="formulaire">
<input type="hidden" name="iIdEnveloppe" value="<%= eEnveloppe.getIdEnveloppe()%>" />
<input type="hidden" name="iIdLot" value="<%= iIdLot %>" />
<input type="hidden" name="iIdCandidature" value="<%= iIdCandidature %>" />
<input type="hidden" name="iTypeEnveloppe" value="<%= iTypeEnveloppe %>" />
<table class="pave" summary="none">
	<tr>
		<td class="pave_titre_gauche">Votre Commentaire</td>
	</tr>
	<tr>
		<td style="font-weight:bold;text-align:center">
		Ces commentaires ne seront pas transmis au candidat. Ils feront l&rsquo;objet d&rsquo;une 
		écriture dans le journal des événements de votre affaire.
		</td>
	</tr>
	<tr>
		<td align="center">
		<textarea name="reponse" rows="5" cols="100"><%= 
			(!eEnveloppe.getReponse().equals("") ? eEnveloppe.getReponse() : "") %></textarea>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
</table>
<br />
<div style="text-align:center">
	<button type="submit" name="submit" >Enregistrer le commentaire</button>
</div>
</form>
<%
}
%>
</div>
</body>
<%@page import="org.coin.util.HttpUtil"%>
</html>