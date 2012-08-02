<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.fr.bean.*,modula.commission.*,java.util.*"%>
<jsp:useBean id="sessionIdCommission" scope="session" class="java.lang.String" />
<%
	String sTitle = "Afficher le membre";
%>
</head>
<body>
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<%
	int iIdMembre = Integer.parseInt(request.getParameter("iIdCommissionMembre"));
	
	CommissionMembre membre = CommissionMembre.getCommissionMembre(iIdMembre);
	Commission commission = Commission.getCommission(membre.getIdCommission());
	int iIdCommission = commission.getIdCommission();
	session.setAttribute( "sessionIdCommission",  "" + iIdCommission ) ;

	String sPageUseCaseId = "IHM-DESK-COM-007";
	String sIdUseCaseModifierMembre = "IHM-DESK-COM-008";
	String sIdUseCaseSupprimerMembre = "IHM-DESK-COM-009";
	if (membre.isPresident()) sIdUseCaseSupprimerMembre = "IHM-DESK-COM-010";
	else if (membre.isSecretaire()) sIdUseCaseSupprimerMembre = "IHM-DESK-COM-011";

	
	PersonnePhysique personne = PersonnePhysique.getPersonnePhysique (membre.getIdPersonnePhysique());
	Vector vParticipants = CommissionMembre.getAllMembreParIdPersonne(membre.getIdPersonnePhysique());
	String sIcone = "";
	switch (membre.getIdMembreRole()){
	case CommissionMembre.COMMISSION_MEMBRE_ID_ROLE_MEMBRE_DELIBERATIF:
			sIcone = "membredeliberatif";
			break;
	case CommissionMembre.COMMISSION_MEMBRE_ID_ROLE_MEMBRE_CONSULTATIF:
			sIcone = "membreconsultatif";
			break;
	case CommissionMembre.COMMISSION_MEMBRE_ID_ROLE_SECRETAIRE:
			sIcone = "secretaire";
			break;
	case CommissionMembre.COMMISSION_MEMBRE_ID_ROLE_PRESIDENT:
			sIcone = "president";
			break;
	default:  
		throw new Exception("membre.getIdMembreRole() inconnu : " + membre.getIdMembreRole());
	
	}

%>
	<table class="menu" summary="Menu">
		<tr>
<%
	if(sessionUserHabilitation.isHabilitate(sIdUseCaseModifierMembre) )
	{
 %>			<th>
				<a href="<%= response.encodeURL(rootPath + "desk/commission/modifierCommissionMembreForm.jsp?iIdCommissionMembre="+ membre.getIdCommissionMembre()) %>">
					<img src="<%= rootPath %>images/icones/store-<%=sIcone%>.gif" height="30" 
					 alt="Modifier" title="Modifier" 
					onmouseover="this.src='<%= rootPath %>images/icones/store-<%=sIcone%>_over.gif'" 
					onmouseout="this.src='<%= rootPath %>images/icones/store-<%=sIcone%>.gif'" />
				</a>
			</th>
<%
	}
	if(sessionUserHabilitation.isHabilitate(sIdUseCaseSupprimerMembre) )
	{
 %>
			<th>
				<a href="<%= response.encodeURL(rootPath + "desk/commission/supprimerCommissionMembreForm.jsp?iIdCommissionMembre=" + membre.getIdCommissionMembre()) %>">
				<img src="<%= rootPath %>images/icones/del-<%=sIcone%>.gif" height="30" 
				 alt="Supprimer" title="Supprimer" 
				onmouseover="this.src='<%= rootPath %>images/icones/del-<%=sIcone%>_over.gif'" 
				onmouseout="this.src='<%= rootPath %>images/icones/del-<%=sIcone%>.gif'" />
				</a>
			</th>
<%
	}
 %>
			<td>&nbsp;</td>
		</tr>
	</table>
	<br />
	<%@ include file="pave/paveCommissionMembreInfos.jspf" %>
	<br />

		<table class="pave" summary="none">
			<tr>
				<td class="pave_titre_gauche"> Personne Physique </td>
			</tr>
			<tr>
				<td>
					<table class="liste" summary="none">
<%
		Adresse adressePersonne = Adresse.getAdresse(personne.getIdAdresse());
		int j = 1;
%>
<%@ include file="../organisation/pave/paveListItemPersonnePhysiqueInOrganisation.jspf" %>
					</table>
				</td>
			</tr>
		</table>
	<br />
	<table class="pave" summary="none">
		<tr>
			<td class="pave_titre_gauche"> Commission associée </td>
		</tr>
		<tr>
			<td>
				<table class="liste" summary="none">
					<tr onmouseover="className='liste_over'" onmouseout="className='liste'" onclick="Redirect('<%=response.encodeRedirectURL("afficherCommission.jsp?iIdCommission="+commission.getIdCommission())%>')"> <!--  onclick="#" -->
					 	<td style="width:40%"><%= commission.getNom() %></td>
						<td style="width:40%"><%= commission.getCompetence() %></td>
						<td style="width:20%;text-align:right">
							<a href="<%=response.encodeURL("afficherCommission.jsp?iIdCommission="+commission.getIdCommission()) %>">
							<img src="<%=rootPath+modula.graphic.Icone.ICONE_FICHIER_DEFAULT %>" width="21" height="21"  alt="Afficher" title="Afficher"/></a>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>
</html>