<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="java.sql.*,org.coin.fr.bean.*,modula.marche.*, modula.candidature.*,java.text.*, java.util.*,modula.algorithme.*,modula.*" %>
<%
	PersonnePhysique candidat 
		= PersonnePhysique.getPersonnePhysique(
				Integer.parseInt(request.getParameter("iIdPersonnePhysique")));
	Organisation organisation = Organisation.getOrganisation(candidat.getIdOrganisation());
		
	PersonnePhysique user = PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual());
	Organisation organisationUser = Organisation.getOrganisation(user.getIdOrganisation());
	
	boolean bAnonyme = false;
	if(request.getParameter("bAnonyme") != null)
		bAnonyme = Boolean.parseBoolean(request.getParameter("bAnonyme"));
	
	
	String sTitle = "Liste des candidatures de "+candidat.getCivilitePrenomNom();

	if(bAnonyme)
		sTitle = "Liste des candidatures";

%>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<table class="menu" cellspacing="2" >
	<%
	if(sessionUserHabilitation.isHabilitate("IHM-DESK-PERS-CDT-012"))
	{
	%>
	<tr>
		<th>
			<a href="<%= response.encodeURL("choisirMarche.jsp?iIdPersonnePhysique=" 
					+ candidat.getIdPersonnePhysique()) %>">
			<img src="../../images/icones/add_marche.gif"  
				alt="Créer une candidature" 
				title="Créer une candidature" 
				 />
			</a>
		</th>
		<td>&nbsp;</td>
	</tr>
	<%
	}
	%>
</table>
<br />
<!-- /Boutons Modifier / Supprimer -->

<%
Vector<Candidature> vCandidatures = null;
if(sessionUserHabilitation.isHabilitate("IHM-DESK-PERS-CDT-011"))
{
	/* on affiche toutes les candidatures du candidat */
	vCandidatures = Candidature.getAllCandidatureFromUser(candidat.getIdPersonnePhysique());
}
else if(sessionUserHabilitation.isHabilitate("IHM-DESK-PERS-CDT-018"))
{
	/* on affiche uniquement les candidatures du candidat de mon organisme AP*/
	vCandidatures 
		= Candidature.getAllCandidatureFromUserAndOrganisationAP(
				candidat.getIdPersonnePhysique(),
				organisationUser.getIdOrganisation());
}
if(vCandidatures != null)
{
			%>
			<table class="pave" summary="none">
				<tr>
					<td class="pave_titre_gauche">Liste des candidatures </td>
					<%
						if(vCandidatures.size() >1){
					%>
								<td class="pave_titre_droite"><%=vCandidatures.size()%> candidatures</td>
					<%
						}
						else{
							if(vCandidatures.size()==1){
					%>
								<td class="pave_titre_droite">1 candidature</td>
					<%
							}
							else{
					%>
								<td class="pave_titre_droite">Pas de candidature</td>
					<%
							}
						}
					%>
				</tr>
				<tr>
					<td colspan="2">
						<table class="liste" style="width:100%" summary="none">
							<tr>
								<th>Référence</th>
								<th>Désignation</th>
								<th>Date de clôture</th>
								<th>Phase</th>
							</tr>
						
			<%
	
	for (int i = 0; i < vCandidatures.size() ; i++)
	{
		int j=i%2;
		Candidature candidature = vCandidatures.get(i);
		
		Marche marche = Marche.getMarche(candidature.getIdMarche());
%>
				<tr class="liste<%=j%>" onmouseover="className='liste_over'" onmouseout="className='liste<%=j%>'" onclick="Redirect('<%= response.encodeURL("afficherCandidature.jsp?iIdPersonnePhysique=" + candidature.getIdPersonnePhysique() +"&amp;iIdMarche="+marche.getIdMarche()+"&amp;bAnonyme="+bAnonyme) %>')" style="text-align:left"> <!--  onclick="#" -->
					<td><%= marche.getReference() %></td>
					<td><%= marche.getObjet() %></td>
					<td>
					<%
						Vector<Validite> vValiditesEnveloppeB = Validite.getAllValiditeEnveloppeBFromAffaire(marche.getIdMarche());
						Validite oLastValiditeB = null;
						Timestamp tsDateCloture = null;
						if(vValiditesEnveloppeB != null)
						{
							if(vValiditesEnveloppeB.size() > 0)
							{
								oLastValiditeB = vValiditesEnveloppeB.lastElement();
								tsDateCloture = oLastValiditeB.getDateFin();
							}
						}
					if(tsDateCloture == null) 
					{%>
					<%="Indéfinie"%>
					<% 
					}
					else
					{%>
					<%= org.coin.util.CalendarUtil.getDateFormattee(tsDateCloture)%>
					<%}%>
					</td>
					<%
						PhaseEtapes oPhaseEtapes = PhaseEtapes.getPhaseEtapesMemory(marche.getIdAlgoPhaseEtapes());
						PhaseProcedure oPhaseProcedure = PhaseProcedure.getPhaseProcedureMemory(oPhaseEtapes.getIdAlgoPhaseProcedure());
						String sPhase = Phase.getPhaseNameMemory(oPhaseProcedure.getIdAlgoPhase());
					%>
					<td>
					<%= (sPhase != null)? sPhase :"Indéfini"%>
					</td>
				</tr>
<%
	}
%>
			</table>
		</td>
	</tr>
</table>
<%
}
%>
<%@ include file="/include/new_style/footerFiche.jspf" %>

</body>
</html>