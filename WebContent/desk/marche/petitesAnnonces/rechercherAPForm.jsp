<%@ include file="../../../include/headerXML.jspf" %>

<%@ page import="modula.fqr.*,java.sql.*,org.coin.fr.bean.*,modula.candidature.*,org.coin.util.*,java.util.*, modula.*, modula.marche.*,modula.commission.*, org.coin.util.treeview.*,java.text.*" %>
<%@ include file="../../include/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath()+"/";
	String sTitle = "Rechercher un acheteur public"; 
	String sPageUseCaseId = "IHM-DESK-ORG-PRM-001";
	int iIdOrganisationType = OrganisationType.TYPE_ACHETEUR_PUBLIC ;
	String sAction = request.getParameter("sAction");
	if(sAction == null)	{ sAction = "";	}
	
	String sRaisonSociale = request.getParameter("sRaisonSociale");
	String sUseCaseIdBoutonAjouterOrganisation = "IHM-DESK-ORG-PRM-003";
%>
<%@ include file="../../include/checkHabilitationPage.jspf" %> 
<%@ include file="../../include/headerDesk.jspf" %> 
<script type="text/javascript" src="<%= rootPath %>include/cacherDivision.js" ></script>
<script type="text/javascript" src="<%= rootPath %>include/verification.js" ></script>
<script type="text/javascript" src="<%= rootPath %>include/bascule.js" ></script>
<script type="text/javascript" src="<%= rootPath %>include/date.js"></script>
<script type="text/javascript" src="<%= rootPath %>include/fonctions.js"></script>
<script type="text/javascript" src="<%= rootPath %>include/calendar.js"></script>
<script type="text/javascript" src="<%= rootPath %>include/cryptage.js"></script>
<script type="text/javascript" src="<%= rootPath %>include/calendrier.js"></script>
<script type="text/javascript" src="<%= rootPath %>include/overlib_mini.js"></script>
<script type="text/javascript">
function valider(iIdOrganisation,sOrganisationName){
	opener.document.formulaire.iIdOrganisation.value = iIdOrganisation;
	opener.document.formulaire.sOrganisationName.value = sOrganisationName;
	setTimeout("self.close();",500);
	opener.changeCommission(iIdOrganisation);
}  
</script>
</head>
<body> 
<div class="titre_page"><%= sTitle %></div>
<table class="menu" cellspacing="2" summary="menu">
	<tr>

<%
	if( sessionUserHabilitation.isHabilitate(sUseCaseIdBoutonAjouterOrganisation ))
	{
%>
		<th>
			<a href="<%= response.encodeURL("rechercherAPForm.jsp?sAction=createPA") %>">
			<img src="../../../images/icones/add-org-Acheteur%20public.gif" 
				 
				onmouseover="this.src='../../../images/icones/add-org-Acheteur%20public_over.gif'" 
				onmouseout="this.src='../../../images/icones/add-org-Acheteur%20public.gif'" 
				alt="Inscrire un organisme Acheteur Public" 
				title="Inscrire un organisme Acheteur Public" />
			&nbsp;
			</a>
		</th>
<%
	}
%>		<td>&nbsp;</td>
	</tr>
</table>
<br />
<%@ include file="pave/paveSearchEngineAcheteursPublics.jspf" %>
<%@ include file="../../../include/paveSearchEngineForm.jspf" %>
<%
	if(sAction.equals("createPA"))	
	{
%>
	<table class="pave" ">
		<tr>
			<td class="pave_cellule_droite" colspan="2"> 
			<iframe style="border:0;height:400px;width:730px"  src="<%= 
				response.encodeURL(
						rootPath 
						+ "desk/organisation/ajouterOrganisationForm.jsp?iIdOrganisationType=" 
						+ OrganisationType.TYPE_ACHETEUR_PUBLIC) %>"></iframe>
			</td>
		</tr>
	</table>
<%
		
	}
	else
	{
%>
	<table class="pave" summary="none">
		<tr>
			<td class="pave_titre_gauche"> Liste des organismes - </td>
<%
	if(recherche.getNbResultats()>1){
%>
			<td class="pave_titre_droite"><%= recherche.getNbResultats() %> organismes</td>
<%
	}
	else{
		if(recherche.getNbResultats()==1){
%>
			<td class="pave_titre_droite">1 organisme</td>
<%
		}
		else{
%>
			<td class="pave_titre_droite">Pas d'organisme</td>
<%
		}
	}
%>
		</tr>
		<tr>
			<td colspan="2">
				<table class="liste" >
					<%= recherche.getHeaderFields(response, rootPath) %>
<%
	int j;
	for (int i = 0; i < vOrganisations.size(); i++)	{
		Organisation organisation = Organisation.getOrganisation(Integer.parseInt((String) vOrganisations.get(i)));
		Adresse adresseOrganisation = Adresse.getAdresse(organisation.getIdAdresse());
		j = i % 2;
%>
<%@ include file="pave/paveListItemOrganisation.jspf" %> 
<%
	}
%>
					</table>
				</td>
			</tr>
		</table>
<% } %>
<%@include file="../../include/footerDesk.jspf" %>
</body>
</html>
