<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="java.util.*, modula.algorithme.*" %>
<% 
	String sTitle = "Afficher tous les Procédures"; 
	Vector vProcedures = Procedure.getAllStaticMemory();
%>
</head>
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<body>
	<table class="menu" cellspacing="2" summary="menu">
		<tr>
			<th>
				<a href="<%= response.encodeURL("modifierProcedureInfosForm.jsp?sAction=create")%>">
				<img src="<%= rootPath %>images/icones/ajouter-procedure.gif"  alt="Ajouter une procédure" title="Ajouter une procédure" onmouseover="this.src='<%= rootPath %>images/icones/ajouter-procedure-on.gif'" onmouseout="this.src='<%= rootPath %>images/icones/ajouter-procedure.gif'" />
				</a>
			</th>
			<td>&nbsp;</td>
		</tr>
	</table>

	<br />
	
	<table class="pave" summary="none">
		<tr>
			<td class="pave_titre_gauche"> Liste des procedures </td>
<%
	if(vProcedures.size() > 1){
%>
			<td class="pave_titre_droite"><%= vProcedures.size() %> Procedures</td>
<%
	}
	else {
		if(vProcedures.size() == 0) {
%>
			<td class="pave_titre_droite">Pas de procedure</td>
<%
		}
		else {
%>
			<td class="pave_titre_droite">1 procedure</td>
<%
		}
	}
%>
		</tr>
		<tr>
			<td colspan="2">
				<table class="liste" summary="none">
					<tr>
						<th>Libelle</th>
						<th>Verrouillé</th>
						<th>Commentaire</th>
						<th>&nbsp;</th>
					</tr>
<%

for (int i=0; i < vProcedures.size(); i++)
{
	Procedure procedure = (Procedure) vProcedures.get(i);
	String sCadenas = "";
	if( procedure.isVerrouille() ) 
	{
		sCadenas = "<img src='" + rootPath + "images/icones/cadenas.gif' />";
	}
%>
				  	<tr class="liste<%=i%2%>" onmouseover="className='liste_over'" 
				  		onmouseout="className='liste<%=i%2%>'" 
				  		onclick="Redirect('<%=response.encodeRedirectURL("afficherProcedure.jsp?iIdProcedure="+procedure.getId())  %>')">
				    	<td style="width:30%"><%=procedure.getLibelle()  %></td>
				    	<td style="width:10%"><%= sCadenas  %></td>
				    	<td style="width:55%"><%=procedure.getCommentaire()  %></td>
				    	<td style="width:5%;text-align:right">
				    	<a href="<%=response.encodeURL("afficherProcedure.jsp?iIdProcedure="+procedure.getId())  %>" >
						<img src="<%=rootPath+modula.graphic.Icone.ICONE_FICHIER_DEFAULT %>" width="21" height="21"  alt="Afficher" title="Afficher"/>
				    	</a>
				    	</td>
				  	</tr>
<%
}
%>
				</table>
			</td>
		</tr>
	</table>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>
</html>
