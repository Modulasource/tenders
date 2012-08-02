<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="modula.graphic.*,modula.candidature.*,org.coin.fr.bean.*,org.coin.util.*,java.util.*, java.sql.*, modula.algorithme.*, modula.*, modula.marche.*"%>
<%
	String sAction = HttpUtil.parseStringBlank("sAction",request);	
	boolean bAnonyme = HttpUtil.parseBoolean("bAnonyme",request, false);
	
	int iIdPersonnePhysique = Integer.parseInt(request.getParameter("iIdPersonnePhysique"));
	PersonnePhysique candidat = PersonnePhysique.getPersonnePhysique(iIdPersonnePhysique);
	int iIdMarche = Integer.parseInt(request.getParameter("iIdMarche"));
	Marche marche = Marche.getMarche(iIdMarche);
	int iIdAffaire = iIdMarche;
	Vector<MarcheLot> vLotsTotal = MarcheLot.getAllLotsFromMarche(marche.getIdMarche());
    Vector<MarcheLot> vLots = MarcheLot.getAllLotsConstituablesFromMarche(marche,vLotsTotal);
	Candidature candidature = Candidature.getCandidature(iIdMarche,iIdPersonnePhysique);
	boolean bIsCandidaturePapier = false;
	boolean bIsCandidatureIndefini = false;
	String sFormatCandidature = "Indéfini";
	boolean bIsDCEPapier = false;
	boolean bIsDCEIndefini = false;
	String sFormatDCE = "Indéfini";
	if(candidature != null)
	{
		try	{
			/**
			 * Il faut garder les 3 possibilités
			 */ 
			bIsCandidaturePapier = candidature.isCandidaturePapier();
			if(bIsCandidaturePapier) sFormatCandidature = "Papier";
			else sFormatCandidature = "Electronique";
		}
		catch(Exception e){
			sFormatCandidature = "Indéfini";
			bIsCandidatureIndefini = true;
		}
		
		try	{
			/**
			 * Il faut garder les 3 possibilités
			 */ 
			bIsDCEPapier = candidature.isDCEPapier();
			if(bIsDCEPapier) sFormatDCE = "Papier";
			else sFormatDCE = "Electronique";
		} catch(Exception e){
			sFormatDCE = "Indéfini";
			bIsDCEIndefini = true;
		}
	}
	else
	{
		bIsDCEIndefini = true;
		bIsCandidatureIndefini = true;
	}

	PersonnePhysique personne = PersonnePhysique.getPersonnePhysique(iIdPersonnePhysique);
	String sTitle = "Candidature de "+ personne.getPrenomNom() +" pour le marché réf. "+marche.getReference();
	if(bAnonyme)
		sTitle = "Candidature ORG"+ personne.getIdOrganisation() +" pour le marché réf. "+marche.getReference();
	//PROCEDURE
	boolean bIsContainsAAPCPublicity = AffaireProcedure.isContainsAAPCPublicity(marche.getIdAlgoAffaireProcedure());
	boolean bIsContainsEnveloppeAManagement = AffaireProcedure.isContainsEnveloppeAManagement(marche.getIdAlgoAffaireProcedure());
	boolean bIsContainsCandidatureManagement = AffaireProcedure.isContainsCandidatureManagement(marche.getIdAlgoAffaireProcedure());
	boolean bIsForcedNegociationManagement = AffaireProcedure.isForcedNegociationManagement(marche.getIdAlgoAffaireProcedure());
	int iIdTypeProcedure = AffaireProcedure.getTypeProcedure(marche.getIdAlgoAffaireProcedure());
	
%>
<link rel="stylesheet" type="text/css" href="<%= rootPath %>include/component/calendar/calendar.css" media="screen" />
<script type="text/javascript" src="<%= rootPath %>include/component/calendar/calendar.js"></script>

<script type="text/javascript">
<!--
var rootPath = "<%= rootPath %>";

<% 
	if(candidature != null)
	{
%>
function supprimerCandidature(btn)
{
	if(!confirm("Etes vous sur de supprimer cette candidature ?"))
	{
		return;
	}
	btn.disabled=true;
	window.location.href = "<%= response.encodeURL("modifierCandidature.jsp?lIdCandidature=" + candidature.getId()) %>";
	return true;
}

<%
	}
%>
//-->
</script>

<script type="text/javascript" src="<%= rootPath %>include/calendar.js" ></script>
<script type="text/javascript" src="<%= rootPath %>include/date.js" ></script>
<script type="text/javascript" src="<%= rootPath %>include/verification.js" ></script>
<script type="text/javascript" src="<%= rootPath %>include/checkbox.js"></script>
<script type="text/javascript" src="<%= rootPath %>include/cacherDivision.js"></script>
<%@include file="pave/afficherCandidature.jspf" %> 
</head>
<body onload="onAfterPageLoading();">
<%@ include file="/include/new_style/headerFiche.jspf" %>
<br/>
<div style="padding:15px">
<%@ include file="../include/headerCandidature.jspf" %>
<br />
<table class="pave">
	<tr>
		<td class="pave_titre_gauche" colspan="2">Description du marché</td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche" >Référence :</td>
		<td class="pave_cellule_droite" ><%= marche.getReference() %></td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche" >Objet :</td>
		<td class="pave_cellule_droite" ><%= marche.getObjet() %></td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
<%
	
	if(vLotsTotal.size()>1)
	{
		// Marché allotit
		for(int i =0 ; i < vLotsTotal.size();i++)
		{
			MarcheLot lot = (MarcheLot ) vLotsTotal.get(i);
%>
	<tr>
		<td class="pave_cellule_gauche" >Lot <%= lot.getNumero() %> :</td>
		<td class="pave_cellule_droite" ><%= 
			lot.getReference() 
			+ " / " +  lot.getDesignationReduite() %></td>
	</tr>

<%
		}
	} else {
		%>
		<tr>
			<td class="pave_cellule_gauche" ></td>
			<td class="pave_cellule_droite" >Marché non allotit</td>
		</tr>

	<%
		
	}


%>
</table>
<br />
<%
String sPaveDelaisValiditeTitre = "Rappel du planning du marché réf."+marche.getReference();
%>
<%@ include file="/desk/marche/algorithme/affaire/pave/pavePlanning.jspf" %>
<br />
<%
if(sAction.equalsIgnoreCase("store"))
{
%>
<%@ include file="pave/candidaturePapierJS.jspf" %>
<%
}
	String sPaveEnregistrementPlisTitre 
		= "Enregistrement des plis de "+ personne.getCivilitePrenomNom() 
		+ " pour le marché réf."+marche.getReference();
	if(bAnonyme)
		sPaveEnregistrementPlisTitre = "Enregistrement des plis";
	
	String sFormPrefix = "";
	
	String sTitreEnveloppeA = "";
	String sTitreEnveloppeB = "";
	int iAfficherPeriodesB = 0;
	iShowRowB = 0;
	String sPostComplement = "";
	Vector<EnveloppeB> vEnveloppesB = null;
	Vector<EnveloppeALot> vEnveloppesALot = null;
	Vector<EnveloppeA> vEnveloppesA = null;
	Timestamp tsDateRetraitDCE = null;
	Timestamp tsDateEnveloppeAFin = null;

	Vector<Validite> vValiditeEnveloppesB = Validite.getAllValiditeEnveloppeBFromAffaire(iIdAffaire);
	
	if(candidature != null)
	{
		tsDateRetraitDCE = candidature.getDateRetraitDCE();
		vEnveloppesA = EnveloppeA.getAllEnveloppeAFromCandidature(candidature.getIdCandidature());
	
		if(vEnveloppesA.size() == 1)
		{
			EnveloppeA enveloppeA = vEnveloppesA.firstElement();
			tsDateEnveloppeAFin = enveloppeA.getDateFermeture();
			
			vEnveloppesALot = EnveloppeALot.getAllEnveloppeALotFromEnveloppeA(enveloppeA.getIdEnveloppe());
		}
	}

	switch(iIdTypeProcedure)
	{
		case AffaireProcedure.TYPE_PROCEDURE_OUVERTE:
			sTitreEnveloppeA = "Réception de l'offre : ";
			iAfficherPeriodesB = 0;
			break;
			
		case AffaireProcedure.TYPE_PROCEDURE_RESTREINTE:
			sTitreEnveloppeA = "Réception de la candidature : ";
			iAfficherPeriodesB = 1;
			sTitreEnveloppeB = "Réception de l'offre : ";
			break;
			
		case AffaireProcedure.TYPE_PROCEDURE_NEGOCIE:
			sTitreEnveloppeA = "Réception de la candidature :";
			iAfficherPeriodesB = 2;
			break;	
	}
	
	if(bIsForcedNegociationManagement) 
	{
		bInvitationOffre = true;
		iAfficherPeriodesB = 2;
		sTitreEnveloppeB = "Réception de l'offre : ";
		/** si on force les négociation et qu'on est en procédure ouverte on affiche pas la premiere */
		if(iIdTypeProcedure == AffaireProcedure.TYPE_PROCEDURE_OUVERTE && bIsContainsEnveloppeAManagement)
			iShowRowB = 1;
	}

	if(sAction.equalsIgnoreCase("store"))
	{
%>
<form action="<%=response.encodeURL("modifierCandidaturePapier.jsp#ancreHP")%>" method="post"  name="formulaire" onSubmit="return checkDates();">
<%@ include file="pave/paveEnregistrementPlisPapierForm.jspf" %>
<br />
<input type="hidden" value="<%=iIdPersonnePhysique%>" name="iIdPersonnePhysique" />
<input type="hidden" value="<%=iIdMarche%>" name="iIdMarche" />
<input type="hidden" value="<%= Boolean.toString(bAnonyme) %>" name="bAnonyme" />

<div align="center">
<button type="submit" >Valider</button>
</div>
</form>
<%
	}
	else
	{
%>
<form action="<%=response.encodeURL("afficherCandidature.jsp")%>" method="post"  name="formulaire">
<%@ include file="pave/paveEnregistrementPlisPapier.jspf" %>
<br />
<input type="hidden" value="<%=iIdPersonnePhysique%>" name="iIdPersonnePhysique" />
<input type="hidden" value="<%=iIdMarche%>" name="iIdMarche" />
<input type="hidden" value="<%= Boolean.toString(bAnonyme) %>" name="bAnonyme" />
<input type="hidden" value="store" name="sAction" />


<div align="center">
<button type="submit" ><%= (candidature != null)?"Modifier":"Créer" %><br/> la candidature</button>
<button type="button" value="" 	
	onclick="Redirect('<%= 
		response.encodeURL("afficherPersonnePhysique.jsp?iIdPersonnePhysique="
				+candidat.getIdPersonnePhysique() +"&#ancreHP") 
		%>')" >Afficher le profil de <br/><%= candidat.getCivilitePrenomNomFonction() %></button>

<%
	if(	(candidature != null) && sessionUserHabilitation.isSuperUser())
	{
%><button type="button" onclick="javascript:supprimerCandidature(this)">Supprimer<br/> la candidature</button> 
	fonction superadmin pour les candidatures papiers et électroniques.
<%
	}
%>
</div>
</form>
<%
	}
%>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>

</body>
</html>