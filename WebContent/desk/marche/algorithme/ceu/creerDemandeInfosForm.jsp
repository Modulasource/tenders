<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@ page import="modula.marche.*, org.coin.fr.bean.*, modula.candidature.*" %>
<%

	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);

	int iIdEnveloppe = Integer.parseInt(request.getParameter("id"));
	String sTypeEnveloppe = request.getParameter("type");

	int iIdLot = -1;
	if (request.getParameter("iIdLot") != null)
		iIdLot = Integer.parseInt(request.getParameter("iIdLot"));

	EnveloppeA enveloppeA = null;
	EnveloppeB enveloppeB = null;
	Candidature candidature = null;

	if (sTypeEnveloppe.equalsIgnoreCase("A"))
	{
		enveloppeA = EnveloppeA.getEnveloppeA(iIdEnveloppe);
		candidature = Candidature.getCandidature(enveloppeA.getIdCandidature());
	}
	if (sTypeEnveloppe.equalsIgnoreCase("B"))
	{
		enveloppeB = EnveloppeB.getEnveloppeB(iIdEnveloppe);
		candidature = Candidature.getCandidature(enveloppeB.getIdCandidature());
	}

	PersonnePhysique candidat = PersonnePhysique.getPersonnePhysique(candidature.getIdPersonnePhysique());
	Organisation organisation = Organisation.getOrganisation(candidat.getIdOrganisation());
	String sTitle = "Demande d'informations complémentaires à " + organisation.getRaisonSociale();
	String sFormPrefix = "";
%>
<script src="<%= rootPath %>include/verification.js"></script>
<script type="text/javascript">
function checkForm()
{
	var form = document.formulaire;
	var item = form.elements["sDemandeInfo"];
	if (isNull(item.value))
	{
		alert("Veuillez spécifier les informations complémentaires.");
		item.focus();
        return false;
	}
	
	return true;
}
</script>
</head>
<body>
<div style="padding:15px">
<form action="<%= response.encodeURL("creerDemandeInfos.jsp") %>" method="post"  name="formulaire" onsubmit="return checkForm();">
<input type="hidden" name="<%= sFormPrefix %>sTypeEnveloppe" value="<%= sTypeEnveloppe %>" />
<input type="hidden" name="<%= sFormPrefix %>iIdEnveloppe" value="<%= iIdEnveloppe %>" />
<input type="hidden" name="iIdLot" value="<%= iIdLot %>" />
<p class="mention">
Vous allez demander des informations complémentaires concernant la candidature de <%= candidat.getCivilitePrenomNom() %>
pour <%= organisation.getRaisonSociale() %>.<br />
Rappel : Toutes les demandes d'informations complémentaires seront envoyées par le syst&egrave;me en même temps à tous les candidats.
</p>
<table class="pave" summary="none">
	<tr>
		<td class="pave_titre_gauche" colspan="2">Définition des informations complémentaires</td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr>
		<td class="pave_cellule_gauche">
			Informations complémentaires demandées* :
		</td>
		<td class="pave_cellule_droite">
			<textarea name="<%=sFormPrefix %>sDemandeInfo" cols="100" rows="4"></textarea>
		</td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
</table>
<br />
<div style="text-align:center">
	<button type="submit" name="submit">Confirmer la demande</button>
	<button type="button" name="Annuler" onclick="location.href='<%= response.encodeURL(rootPath 
			+ "desk/marche/algorithme/proposition/gestion/ouvrirEnveloppeA.jsp?iIdCandidature="
			+candidature.getIdCandidature() +"&amp;iIdLot="+iIdLot )%>'">Revenir à la candidature</button>
</div>
</form>
</div>
</body>
</html>