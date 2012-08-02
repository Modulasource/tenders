<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.fr.bean.*,modula.commission.*,java.util.*"%>
<%@ include file="../include/beanSessionIdCommission.jspf" %>
<%
	String sTitle = "Affectation d'un membre";
	
	String sPageUseCaseId = "IHM-DESK-COM-006";
%>
<script type="text/javascript" src="<%= rootPath %>include/cacherDivision.js"></script>
<%@include file="pave/ajouterCommissionMembreForm.jspf" %>
</head>
<body onload="cacherToutesDiv();">
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<form action="<%= response.encodeURL("ajouterCommissionMembre.jsp") %>" method="post" name="form1" onsubmit="javascript:return checkIdPersonnePhysique()">
<table class="pave" summary="none">
	<tr>
		<td class="pave_titre_gauche" colspan="2">Membre à affecter</td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Membre :</td>
		<td class="pave_cellule_droite">
			<select name="iIdPersonnePhysique" size="1">
<%
	Vector vPersonnes = PersonnePhysique.getAllFromIdOrganisation(commission.getIdOrganisation());
	Vector vConsultants = PersonnePhysique.getAllWithOrganisationType(OrganisationType.TYPE_CONSULTANT,"");
		
	if ((vPersonnes.size()+vConsultants.size()) == 0)
	{
		response.sendRedirect(response.encodeRedirectURL("errorAdmin.jsp?idError=1"));
		return;
	}
	
	for (int i = 0; i < vPersonnes.size(); i++)
	{
		PersonnePhysique personne = (PersonnePhysique ) vPersonnes.get(i);
		if (!CommissionMembre.isMembre(commission.getIdCommission(), personne.getIdPersonnePhysique()))
		{
%>
	<option value="<%= personne.getIdPersonnePhysique() %>"><%= personne.getNom() + " " + personne.getPrenom() %></option>
<%		}
	}
	
	for (int i = 0; i < vConsultants.size(); i++)
	{
		PersonnePhysique personne = (PersonnePhysique ) vConsultants.get(i);
		if (!CommissionMembre.isMembre(commission.getIdCommission(), personne.getIdPersonnePhysique()))
		{
%>
			<option value="<%= personne.getIdPersonnePhysique() %>"><%= personne.getNom() + " " + personne.getPrenom() %></option>
<%		}
	}
%>
			</select>	
		</td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
</table>
<br />
<table class="pave" summary="none">
	<tr>
		<td class="pave_titre_gauche" colspan="2">Commission affectée</td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Commission :</td>
		<td class="pave_cellule_droite">
			<input type="hidden" name="iIdCommission" value="<%= commission.getIdCommission() %>" />
						<%= commission.getNom() %>
		</td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
</table>
<br />
<table class="pave" summary="none">
	<tr>
		<td class="pave_titre_gauche" colspan="2">Définir le rôle du membre </td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Rôle du membre :</td>
		<td class="pave_cellule_droite">
			<select name="iIdMembreRole" size="1" onChange="checkIdMembreRole();">
<%
	Vector vMembreRole = MembreRole.getAllMembreRole();
	boolean bHasPresident = CommissionMembre.isMembreParticulierExiste(iIdCommission, CommissionMembre.COMMISSION_MEMBRE_ID_ROLE_PRESIDENT);
	boolean bHasSecretaire = CommissionMembre.isMembreParticulierExiste(iIdCommission, CommissionMembre.COMMISSION_MEMBRE_ID_ROLE_SECRETAIRE);
	boolean bDisplayRole;
	 
	for (int i = 0; i < vMembreRole.size(); i++) {
		MembreRole role = (MembreRole) vMembreRole.get(i) ;
		bDisplayRole = true;
		switch ((int)role.getId()) 
		{
		case CommissionMembre.COMMISSION_MEMBRE_ID_ROLE_PRESIDENT:
			if(bHasPresident) bDisplayRole = false;
			break;

		case CommissionMembre.COMMISSION_MEMBRE_ID_ROLE_SECRETAIRE :
			if(bHasSecretaire ) bDisplayRole = false;
			break;
		}
		if(bDisplayRole )		
		{
%>	<option value="<%=role.getId() %>" > <%=role.getName() %></option>
<%	
		}
	}
%>
			</select>
		</td>
	</tr>
	<tr id="divSecretaire">
		<td class="pave_cellule_gauche">Fonctions du rôle :</td>
		<td class="pave_cellule_droite">En désignant le secrétaire de la commission, vous désignez la personne physique qui aura la délégation de la signature et du décachetage des offres.</td>
	</tr>
	<tr id="divPresident">
		<td class="pave_cellule_gauche">Fonctions du rôle :</td>
		<td class="pave_cellule_droite">Vous allez désigner ce membre comme président de la commission. Il doit être équipé d'un certificat électronique pour décacheter les offres des candidats.</td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Qualification :</td>
		<td class="pave_cellule_droite"><input type="text" name="sQualification" /></td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Qualité :</td>
		<td class="pave_cellule_droite"><input type="text" name="sQualite" /></td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Appellation :</td>
		<td class="pave_cellule_droite"><input type="text" name="sAppellation" /></td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Profil :</td>
		<td class="pave_cellule_droite"><input type="text" name="sProfil" /></td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Type de membre :</td>
		<td class="pave_cellule_droite"><input type="text" name="sMembreType" /></td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
</table>
<br />
	<div style="text-align:center">
		<input type="submit" name="submit" value="Affecter" />
		&nbsp;<input type="reset" name="RAZ" value="Annuler" 
		onclick="Redirect('<%= response.encodeRedirectURL(rootPath +"desk/commission/afficherCommission.jsp?iIdCommission="+iIdCommission) %>')" />
	</div>
</form>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>
</html>