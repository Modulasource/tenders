<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.*,java.util.*,modula.graphic.*" %>
<% String sTitle = "Afficher tous les groupes"; 
	Vector vGroupes = Group.getAllGroup();
	String sPageUseCaseId = "IHM-DESK-PARAM-HAB-2";
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
%>
</head>
<body>
<%@ include file="../../../../../include/new_style/headerFiche.jspf" %>
<br/>
<div style="padding:15px">

	<table class="menu" cellspacing="2" summary="menu">
	<tr>
		<th><a href="<%= response.encodeRedirectURL("modifierGroupeForm.jsp?sAction=create") %>">
			<img src="<%=rootPath+ Icone.ICONE_PLUS %>"  
				alt="Ajouter un rôle" title="Ajouter un rôle" />
			</a>
		</th>
		<td>&nbsp;</td>
	</tr>
	</table>
	<br />

	<table class="pave" summary="none">
		<tr>
			<td class="pave_titre_gauche">Liste des groupes</td>
<%
	if(vGroupes.size() > 1){
%>
			<td class="pave_titre_droite"><%= vGroupes.size() %> groupes</td>
<%
	}
	else {
		if(vGroupes.size() == 0) {
%>
			<td class="pave_titre_droite">Pas de groupes</td>
<%
		}
		else {
%>
			<td class="pave_titre_droite">1 groupe</td>
<%
		}
	}
%>
		</tr>
		<tr>
			<td colspan="2">
				<table class="liste" summary="none">
					<tr>
						<th>Groupes</th>
						<th>&nbsp;</th>
					</tr>
				<!-- Affichage des utilisateurs -->
<%
for (int i=0; i < vGroupes.size(); i++)
{
	Group groupe = (Group) vGroupes.get(i);
%>
				  	<tr class="liste<%=i%2%>" onmouseover="className='liste_over'" onmouseout="className='liste<%=i%2%>'" onclick="Redirect('<%=response.encodeRedirectURL("afficherGroupe.jsp?iIdGroup="+groupe.getId())  %>')">
				    	<td><%=groupe.getName()    %></td>
				    	<td style="width:5%;text-align:right"><a href="<%=response.encodeURL("afficherGroupe.jsp?iIdGroup="+groupe.getId())  %>" >
						<img src="<%=rootPath+modula.graphic.Icone.ICONE_FICHIER_DEFAULT %>" width="21" height="21"  alt="<%= localizeButton.getValueDisplay() %>" title="<%= localizeButton.getValueDisplay() %>"/>
				    	</a></td>
				  	</tr>
<%
}
%>

				</table>
			</td>
		</tr>
	</table>
</div>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>

</body>
</html>
