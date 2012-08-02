<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.fr.bean.*,modula.commission.*,java.util.*, modula.marche.*"%>
<%@ include file="../include/beanSessionIdCommission.jspf" %>
<%
	String sPageUseCaseId = "IHM-DESK-COM-003";
	String sUseCaseIdBoutonModifierCommission = "IHM-DESK-COM-004";
	String sUseCaseIdBoutonSupprimerCommission = "IHM-DESK-COM-005";
	String sUseCaseIdBoutonAjouterCommissionMembre = "IHM-DESK-COM-006";
	String sUseCaseIdBoutonAfficherEvtCommission = "";
	String sUseCaseIdBoutonAfficherAffaireCommission = "IHM-DESK-COM-013";

	if(!sessionUserHabilitation.isHabilitate(sPageUseCaseId))
	{
		sPageUseCaseId = "IHM-DESK-COM-14";
	}

	if(!sessionUserHabilitation.isHabilitate(sUseCaseIdBoutonModifierCommission))
	{
		sUseCaseIdBoutonModifierCommission = "IHM-DESK-COM-16";
	}

	if(!sessionUserHabilitation.isHabilitate(sUseCaseIdBoutonSupprimerCommission))
	{
		sUseCaseIdBoutonSupprimerCommission = "IHM-DESK-COM-17";
	}
			
	String sTitle = "Information de la commission selectionnée";
	boolean bReadOnly = true;
	boolean bDisplayForm = true;
	String sFormPrefix = "";
	
	Organisation organisation = Organisation.getOrganisation(commission.getIdOrganisation());
	Vector<Organisation> vOrganisations = Organisation.getAllOrganisationsWithIdType(OrganisationType.TYPE_ACHETEUR_PUBLIC );
%>
</head>
<body>
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
	<table class="menu" cellspacing="2" summary="menu">
		<tr>
			<th>
				<a href="<%= response.encodeURL(rootPath + "desk/organisation/afficherOrganisation.jsp?iIdOrganisation=" + commission.getIdOrganisation()) %>">
				<img src="<%= rootPath+"images/icons/36x36/home.png"%>" 
				alt="Afficher l'organisation" 
				title="Afficher l'organisation" 
				onmouseover="" 
				onmouseout="" /></a>
			</th>
		
<%
	if( sessionUserHabilitation.isHabilitate(sUseCaseIdBoutonModifierCommission))
	{
%>
			<th>
				<a href="<%= response.encodeURL(rootPath + "desk/commission/modifierCommissionForm.jsp?iIdCommission=" + commission.getIdCommission()) %>">
				<img src="../../images/icones/store-commission.gif" alt="Modifier la commission" title="Modifier la commission" 
				onmouseover="" 
				onmouseout="" /></a>
			</th>
<%
	}
	if( sessionUserHabilitation.isHabilitate(sUseCaseIdBoutonSupprimerCommission))
	{
%>
			<th>
				<a href="<%= response.encodeURL(rootPath + "desk/commission/supprimerCommissionForm.jsp?iIdCommission=" + commission.getIdCommission()) %>">
				<img src="../../images/icones/del-commission.gif" alt="Supprimer la commission" title="Supprimer la commission" 
				onmouseover="" 
				onmouseout=""  /></a>
			</th>
<%
	}
	if( sessionUserHabilitation.isHabilitate(sUseCaseIdBoutonAjouterCommissionMembre))
	{
%>
			<th>
				<a href="<%= response.encodeURL(rootPath + "desk/commission/ajouterCommissionMembreForm.jsp?iIdCommission=" + commission.getIdCommission()) %>">
				<img src="../../images/icones/add-membre.gif" alt="Ajouter un membre" title="Ajouter un membre" 
				onmouseover="" 
				onmouseout=""  />
				</a>
			</th>
<%
	}
	if( sessionUserHabilitation.isHabilitate(sUseCaseIdBoutonAfficherEvtCommission))
	{
%>
			<th>
				<a href="<%= response.encodeURL(rootPath + "desk/journal/afficherEvenementCommission.jsp?iIdCommission="+ commission.getIdCommission()) %>">
				<img src="<%= rootPath %>images/icones/journal-d-evenements.gif" alt="Afficher les événements de la commission" title="Afficher les événements de la commission" 
				onmouseover="" 
				onmouseout=""  />
				</a>
			</th>
<%
	}
	if( sessionUserHabilitation.isHabilitate(sUseCaseIdBoutonAfficherAffaireCommission))
	{
%>
			<th>
				<a href="<%= response.encodeURL(
						rootPath + "desk/marche/algorithme/affaire/afficherToutesAffaires.jsp?iIdCommission=" 
								+ commission.getIdCommission() ) %>">
				<img src="../../images/icones/liste_marche.gif" alt="Afficher les affaires" title="Afficher les affaires" 
				onmouseover="" 
				onmouseout=""  />
				</a>
			</th>
<%
	}
%>
			<td>&nbsp;</td>
		</tr>
	</table>
<br />
<%@ include file="pave/paveCommissionInfos.jspf" %>
<br />
<%@ include file="pave/pavePresidenceCommission.jspf" %>
<br />
<%@ include file="pave/paveMembresDeliberatifsCommission.jspf" %>
<br />
<%@ include file="pave/paveMembresConsultatifsCommission.jspf" %>
<br />	
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>
</html>