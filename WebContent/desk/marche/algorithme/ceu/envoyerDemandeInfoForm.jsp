<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@ page import="modula.marche.*, modula.candidature.*, java.util.*, org.coin.fr.bean.*" %>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);

	String sFormPrefix = "";
	int iIdLot = Integer.parseInt(request.getParameter("iIdLot"));
	
	Vector vDemandes = DemandeInfoComplementaire.getAllDemandeEnCoursEnveloppeAFromMarche(marche.getIdMarche());

%>
<script type="text/javascript" src="<%= rootPath %>include/verification.js" ></script>
<script type="text/javascript" src="<%= rootPath %>include/date.js" ></script>
<link rel="stylesheet" type="text/css" href="<%= rootPath %>include/component/calendar/calendar.css" media="screen" />
<script type="text/javascript" src="<%= rootPath %>include/component/calendar/calendar.js"></script>
<script type="text/javascript">
function checkForm()
{
	var form = document.formulaire;
	var item = form.elements["<%= sFormPrefix %>tsDateDebutRemise"];
	if (isNull(item.value))
	{
		alert("Veuillez spécifier la date de début de la période de remise.");
		item.focus();
        return false;
	}
	else {
		if(!checkDate(item.value))
		{
			alert("Veuillez vérifier le format de la date de début de la période de remise.");
			item.focus();
			return false;
		}
	}
	
	item = form.elements["<%= sFormPrefix %>tsHeureDebutRemise"];
	if (isNull(item.value))
	{
		if(!checkHeure(item.value))
		{
			alert("Veuillez remplir l'heure de début de la période de remise.");
			item.focus();
			return false;
		}
	}
	else{
		if(!checkHeure(item.value))
		{
			alert("Veuillez vérifier le format de l'heure de début de la période de remise.");
			item.focus();
			return false;
		}
	}
	
	item = form.elements["<%= sFormPrefix %>tsDateFinRemise"];
	if (isNull(item.value))
	{
		alert("Veuillez spécifier la date de fin de la période de remise.");
		item.focus();
        return false;
	}
	else {
		if(!checkDate(item.value))
		{
			alert("Veuillez vérifier le format de la date de fin de la période de remise.");
			item.focus();
			return false;
		}
	}
	
	item = form.elements["<%= sFormPrefix %>tsHeureFinRemise"];
	if (isNull(item.value))
	{
		if(!checkHeure(item.value))
		{
			alert("Veuillez remplir l'heure de fin de la période de remise.");
			item.focus();
			return false;
		}
	}
	else{
		if(!checkHeure(item.value))
		{
			alert("Veuillez vérifier le format de l'heure de fin de la période de remise.");
			item.focus();
			return false;
		}
	}
	
	return true;
}
</script>
</head>
<body>
<div style="padding:15px">
<%
if(vDemandes.size()>0){
%>
	<table class="pave" >
		<tr>
			<td class="pave_titre_gauche" colspan="2">Listes des candidatures auxquelles seront adressées une demande d'informations complémentaires</td>
		</tr>
		<tr>
			<td colspan="2">
				<table class="liste" >
					<tr>
						<th>Soumissionnaire</th>
						<th>Organisation</th>
						<th>&nbsp;</th>
					</tr>
<%
for (int i = 0; i < vDemandes.size(); i++)
{
	int j = i % 2;
	DemandeInfoComplementaire demande = (DemandeInfoComplementaire)vDemandes.get(i);
	Candidature candidature = Candidature.getCandidature(EnveloppeA.getEnveloppeA(demande.getIdEnveloppe()).getIdCandidature());
	PersonnePhysique candidat = PersonnePhysique.getPersonnePhysique(candidature.getIdPersonnePhysique());
	Organisation organisation = Organisation.getOrganisation(candidature.getIdOrganisation());
%>
					<tr class="liste<%=j%>" onmouseover="className='liste_over'" onmouseout="className='liste<%=j%>'"> 
						<td>
						<%= candidat.getCivilitePrenomNom() %>
						</td>
						<td>
						<%= organisation.getRaisonSociale() %>
						</td>
						<td>
						&nbsp;
						</td>
					</tr>
<%
}
%>
				</table>
			</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
	</table>
	<br />
	<!-- /Liste des demandes d'infos complémentaires -->
	<form action="<%= response.encodeURL("envoyerDemandeInfo.jsp") %>" method="post"  name="formulaire" onsubmit="return checkForm();">
	<input type="hidden" name="iIdLot" value="<%= iIdLot %>" />
	<p class="mention">
	La date d'envoi des emails de demandes d'informations complémentaires sera la date de début de la période de remise spécifiée.<br />
	Rappel : Le délai maximum autorisé pour la période de remise des pièces complémentaires est de 10 jours.
	</p>
	<table class="pave" summary="none">
		<tr>
			<td class="pave_titre_gauche" colspan="2">Définition de la période de remise</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
			<td class="pave_cellule_gauche">
				Date de début de la période de remise* :
			</td>
			<td class="pave_cellule_droite">
				<input type="text" name="<%= sFormPrefix %>tsDateDebutRemise" size="15" maxlength="10" 
				class="dataType-date"
				value="" />&nbsp;
				<strong>Heure :</strong>&nbsp;
				<input type="text" name="<%=sFormPrefix %>tsHeureDebutRemise" size="5" maxlength="5" value="17:00" />&nbsp; 
			</td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">
				Date de fin de la période de remise* :
			</td>
			<td class="pave_cellule_droite">
				<input type="text" name="<%= sFormPrefix %>tsDateFinRemise" size="15" maxlength="10" 
				class="dataType-date"
				value=""/>&nbsp;
				<strong>Heure :</strong>&nbsp;
				<input type="text" name="<%=sFormPrefix %>tsHeureFinRemise" size="5" maxlength="5" value="17:00" />&nbsp; 
			</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
	</table>
	<br />
	<div style="text-align:center">
		<button type="submit" name="submit" >Envoyer les demandes d'informations complémentaires</button>
	</div>
	</form>
<%
}else{
%>
Vous n'avez aucune demande d'informations complémentaires à envoyer.
<%} %>
</div>
</body>
</html>