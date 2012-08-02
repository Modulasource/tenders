<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.*,java.util.*" %>
<% String sTitle = "Afficher tous les utilisateurs"; 
	Vector vUsers = User.getAllStatic();
	String sGroupeName = ""; 
	Group group ;
	String sUseCaseIdAfficherDroits = "IHM-DESK-PARAM-HAB-1";
	String sPageUseCaseId  = sUseCaseIdAfficherDroits;
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);

%>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<br/>
<div style="padding:15px">

	<table class="pave" > 
		<tr>
			<td class="pave_titre_gauche"> Liste des utilisateurs </td>
<%
	if(vUsers.size() > 1){
%>
			<td class="pave_titre_droite"><%= vUsers.size() %> utilisateurs</td>
<%
	}
	else {
		if(vUsers.size() == 0) {
%>
			<td class="pave_titre_droite">Pas d'utilisateurs</td>
<%
		}
		else {
%>
			<td class="pave_titre_droite">1 utilisateur</td>
<%
		}
	}
%>
		</tr>
		<tr>
			<td colspan="2">
				<table class="liste" >
					<tr>
						<th>Login utilisateur</th>
						<th>Groupes</th>
						<th>&nbsp;</th>
					</tr>
<%

for (int i=0; i < vUsers.size(); i++)
{
	User user = (User) vUsers.get(i);
	Vector<Group> vGroup = UserGroup.getAllGroup(user.getIdUser() );
	sGroupeName = "";
	for (int j=0; j < vGroup.size(); j++)
	{
		group = vGroup.get(j);
		sGroupeName += group.getName() + ", ";
	}
%>
				  	<tr class="liste<%=i%2%>" onmouseover="className='liste_over'" onmouseout="className='liste<%=i%2%>'" onclick="Redirect('<%=response.encodeRedirectURL("afficherUtilisateurGroupe.jsp?iIdUser="+user.getIdUser() ) %>')">
				    	<td width="30%"><%=user.getLogin()  %></td>
				    	<td width="50%"><%=sGroupeName  %></td>
				    	<td width="20%" style="text-align:right"><a href="<%= response.encodeRedirectURL("afficherUtilisateurGroupe.jsp?iIdUser=" + user.getIdUser() ) %>" ><img src="<%= rootPath + modula.graphic.Icone.ICONE_FICHIER_DEFAULT %>" width="21" height="21"  /></a></td>
				  	</tr>
<%
}
%>
				</table>
			</td>
		</tr>
	</table>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>

</body>
</html>
