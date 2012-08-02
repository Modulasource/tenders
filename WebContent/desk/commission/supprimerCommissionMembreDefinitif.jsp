<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="java.util.*,org.coin.fr.bean.*,org.coin.bean.*,modula.commission.*" %>
<%
	String sTitle = "Supprimer définitivement le membre indiqué";
%>
</head>
<body>
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<%
	int iIdMembre = -1;
	try {
		iIdMembre = Integer.parseInt(request.getParameter("iIdCommissionMembre"));
		
	} catch (Exception e) {
	}

	if (iIdMembre == -1)
	{
%>
<form action="<%= response.encodeURL("supprimerMembreDefinitif.jsp") %>" method="post" name="form1">
<p><img src="img/warning.gif"  alt="" style="vertical-align:middle;width:21";height:19"><span class="red"> Attention :</span><br />
<strong>
Vous allez supprimer définitivement un membre :<br />
- Il n'aura plus accès au Desk Modula <br />
- Il n'aura plus accès aux différentes commission dont il était membre 
</strong>
</p>
<table style="width:70%">
	<tr>
		<td width="1" height="1" bgcolor="#000000"><img src="img/spacer.gif" width="1" height="1" alt=""></td>
		<td height="1" bgcolor="#000000"><img src="img/spacer.gif" width="1" height="1" alt=""></td>
		<td width="1" height="1" bgcolor="#000000"><img src="img/spacer.gif" width="1" height="1" alt=""></td>
	</tr>
	<tr>
		<td width="1" bgcolor="#000000"><img src="img/spacer.gif" width="1" height="1" alt=""></td>
		<td bgcolor="#EEEEEE" align="center" background="img/bg_head.gif">
			<table cellpadding="3">
				<tr> 
					<td style="vertical-align:top;font-weight:bold">Membre à supprimer</td>
					<td style="vertical-align:top;text-align:right">&nbsp;</td>
				</tr>
			</table>
		</td>
		<td width="1" bgcolor="#000000"><img src="img/spacer.gif" width="1" height="1" alt=""></td>
	</tr>
	<tr>
		<td width="1" height="1" bgcolor="#000000"><img src="img/spacer.gif" width="1" height="1" alt=""></td>
		<td height="1" bgcolor="#000000"><img src="img/spacer.gif" width="1" height="1" alt=""></td>
		<td width="1" height="1" bgcolor="#000000"><img src="img/spacer.gif" width="1" height="1" alt=""></td>
	</tr>
	<tr>
		<td width="1" bgcolor="#000000"><img src="img/spacer.gif" width="1" height="1" alt=""></td>
		<td bgcolor="#EEEEEE" style="text-align:center">
			<table cellpadding="3">
				<tr> 
					<td style="text-align:right;font-weight:bold">Membre :</td>
					<td style="vertical-align:middle">
						<select name="idMembre" size="1">
<%
		Vector vMembreTab = CommissionMembre.getAll();
	
		if (vMembreTab.size()!= 0)
		{
			for (int i = 0; i < vMembreTab.size(); i++) {
			CommissionMembre membre = (CommissionMembre) vMembreTab.get(i);
			PersonnePhysique personne = PersonnePhysique.getPersonnePhysique(membre.getIdPersonnePhysique());

%>
							<option value="<%= membre.getIdCommissionMembre() %>"> 
							<%= personne.getNom() + " " + personne.getPrenom() %>
<%		
			}
		}
		else
		{
			try{
				response.sendRedirect(response.encodeRedirectURL("errorAdmin.jsp?idError=1"));
			}
			catch(java.io.IOException ioe){}
		}
%>
						</select>
					</td>
				</tr>
			</table>
		</td>
		<td width="1" bgcolor="#000000"><img src="img/spacer.gif" width="1" height="1" alt=""></td>
	</tr>
	<tr>
		<td width="1" height="1" bgcolor="#000000"><img src="img/spacer.gif" width="1" height="1" alt=""></td>
		<td height="1" bgcolor="#000000"><img src="img/spacer.gif" width="1" height="1" alt=""></td>
		<td width="1" height="1" bgcolor="#000000"><img src="img/spacer.gif" width="1" height="1" alt=""></td>
	</tr>
</table>
<!-- /Moteur de recherche -->
<input type='submit' name='submit' value='Supprimer' />
<input type='reset' name='RAZ' value='Annuler' />
</form>
<%
	}
	else
	{
		CommissionMembre membre = CommissionMembre.getCommissionMembre(iIdMembre);
		int iIdPersonnePhysique = membre.getIdPersonnePhysique();
		
		Vector vMembresASupprimer = 
			CommissionMembre.getAllMembreParIdPersonne(iIdPersonnePhysique);
			
		CommissionMembre membreASupprimer = (CommissionMembre) vMembresASupprimer.firstElement();
		PersonnePhysique personneASupprimer = PersonnePhysique.getPersonnePhysique (membreASupprimer.getIdPersonnePhysique());
		Adresse adresseASupprimer = Adresse.getAdresse(personneASupprimer.getIdAdresse());
		User userASupprimer = User.getUserFromIdIndividual(personneASupprimer.getIdPersonnePhysique() );
		
		adresseASupprimer.remove();
		userASupprimer.remove();
		personneASupprimer.remove();
		int i = 0;
		for(i = 0; i < vMembresASupprimer.size(); i++)
		{
			CommissionMembre mbr = (CommissionMembre) vMembresASupprimer.get(i);
			mbr.remove();
		}
		response.sendRedirect(response.encodeRedirectURL("afficherTousCommissionMembre.jsp"));
	}
%>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>
</html>