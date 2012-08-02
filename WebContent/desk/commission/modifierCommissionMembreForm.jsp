<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.fr.bean.*,modula.commission.*,java.util.*"%>
<%@ include file="../include/beanSessionIdCommission.jspf" %>
<%
	String sTitle = "Modification du rôle d'un membre dans une commission";

	int iIdCommissionMembre = Integer.parseInt(request.getParameter("iIdCommissionMembre"));
	CommissionMembre membre = CommissionMembre.getCommissionMembre(iIdCommissionMembre);
	PersonnePhysique personne = PersonnePhysique.getPersonnePhysique(membre.getIdPersonnePhysique());
%>
</head>
<body>
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<form action="<%= response.encodeURL("modifierCommissionMembre.jsp") %>" method="post" name="form1">
<input type="hidden" name="iIdCommissionMembre" value="<%= membre.getIdCommissionMembre() %>" />
<input type="hidden" name="iIdPersonnePhysique" value="<%= personne.getIdPersonnePhysique() %>" />
<input type="hidden" name="iIdCommission" value="<%= membre.getIdCommission() %>" />
<table class="pave" summary="none">
	<tr>
		<td class="pave_titre_gauche" colspan="2">Membre à affecter</td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Commission :</td>
		<td class="pave_cellule_droite"><%= commission.getNom() %></td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Membre :</td>
		<td class="pave_cellule_droite"><%= personne.getPrenom() + " " + personne.getNom() %></td>
	</tr>
</table>
<br />
<table class="pave" summary="none">
	<tr>
		<td class="pave_titre_gauche" colspan="2">Définir le nouveau rôle du membre</td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Rôle du membre :</td>
		<td class="pave_cellule_droite">
			<select name="iIdMembreRole" size="1">
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
			if( bHasPresident && (!membre.isPresident()) ) bDisplayRole = false;
			break;

		case CommissionMembre.COMMISSION_MEMBRE_ID_ROLE_SECRETAIRE :
			if( bHasSecretaire && (!membre.isSecretaire()) ) bDisplayRole = false;
			break;
		}
		if(bDisplayRole )		
		{
%>	<option value="<%=role.getId() %>" <% if (membre.getIdMembreRole() == role.getId()) out.print("selected='selected'");%>> <%=role.getName() %></option>
<%	
		}
	}
%>				
			</select>
		</td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Qualification :</td>
		<td class="pave_cellule_droite">
			<input type="text" name="sQualification" value="<%= membre.getQualification() %>" />
		</td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Qualité :</td>
		<td class="pave_cellule_droite">
			<input type="text" name="sQualite" value="<%= membre.getQualite() %>" />
		</td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Appellation :</td>
		<td class="pave_cellule_droite">
			<input type="text" name="sAppellation" value="<%= membre.getAppellation() %>" />
		</td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Profil :</td>
		<td class="pave_cellule_droite">
			<input type="text" name="sProfil" value="<%= membre.getProfil() %>"  />
		</td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Type de membre :</td>
		<td class="pave_cellule_droite">
			<input type="text" name="sMembreType" value="<%= membre.getMembreType() %>" />
		</td>
	</tr>
</table>

	<br />
	<div style="text-align:center">
		<input type="submit" name="submit" value="Modifier" />
		&nbsp;<input type="reset" name="RAZ" value="Annuler" 
		onclick="Redirect('<%= response.encodeRedirectURL("afficherCommissionMembre.jsp?iIdCommissionMembre="+ membre.getIdCommissionMembre())%>')" />
	</div>
</form>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>
</html>