<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.*,java.util.*,modula.graphic.*" %>
<% String sTitle = "Afficher tous les r�les";
	Vector vRole = Role.getAllRole();
	String sPageUseCaseId = "IHM-DESK-PARAM-HAB-3";
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);

%>
</head>
<body>
<%@ include file="../../../../../include/new_style/headerFiche.jspf" %>
<br/>
<div style="padding:15px">

	<table class="menu" cellspacing="2" summary="Menu"> 
	<tr>
		<th>
			<a href="<%= response.encodeRedirectURL("modifierRoleNameForm.jsp?sAction=create") %>">
			<img src="<%=rootPath+ Icone.ICONE_PLUS %>"  
				onmouseover="src='<%=rootPath+ Icone.ICONE_PLUS_OVER %>'" 
				onmouseout="src='<%=rootPath+ Icone.ICONE_PLUS %>'" 
				alt="Ajouter un r�le" title="Ajouter un r�le" />
			</a>
		</th>
		<td>&nbsp;</td>
	</tr>
	</table>
	<br />

	<table class="pave" summary="none">
		<tr>
			<td class="pave_titre_gauche">Liste des r�les</td>
<%
	if(vRole.size() > 1){
%>
			<td class="pave_titre_droite"><%= vRole.size() %> r�les</td>
<%
	}
	else {
		if(vRole.size() == 0) {
%>
			<td class="pave_titre_droite">Pas de r�les</td>
<%
		}
		else {
%>
			<td class="pave_titre_droite">1 r�le</td>
<%
		}
	}
%>
		</tr>
		<tr>
			<td colspan="2">
				<table class="liste" summary="none">
					<tr>
						<th>R�les</th>
						<th>&nbsp;</th>
					</tr>
<%
for (int i=0; i < vRole.size(); i++)
{
	Role role = (Role) vRole.get(i);
	String sUrlTarget = response.encodeURL("modifierRoleForm.jsp?iIdRole="+role.getId()) ;
%>
				 	<tr class="liste<%=i%2%>" 
				 		onmouseover="className='liste_over'" 
				 		onmouseout="className='liste<%=i%2%>'" 
				 		onclick="Redirect('<%=sUrlTarget %>')">
				  		<td width="50%"><%=role.getName()    %></td>
				    	<td width="50%" style="text-align:right"><a href="<%=sUrlTarget %>" >
				    		<img src="<%= rootPath + modula.graphic.Icone.ICONE_FICHIER_DEFAULT %>" width="21" height="21"  /></a>
				    	</td>
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
