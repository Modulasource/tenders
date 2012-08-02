<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@ page import="java.util.*" %>
<% 
	String sTitle = "Liste des avertissements (juridiques, utilisateurs, etc)"; 
	Vector<InfosBulles> vItem = InfosBulles.getAllStaticMemory(false);
	String sPageUseCaseId = "xxx";
%>

<script type="text/javascript">
function displayItem(id) {
	var sUrl = "<%=
		response.encodeURL(
				rootPath
				+"desk/parametrage/affaire/info_bulles/modifyInfoBullesForm.jsp")%>?sAction=store&lId="+id;

	location.href = sUrl;
}
</script>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<div style="padding:15px">
	<div class="right">
	<button type="button" onclick="javascript:doUrl('<%=
		response.encodeURL(
				rootPath
				+"desk/parametrage/affaire/info_bulles/modifyInfoBullesForm.jsp?sAction=create") %>');" />Ajouter</button>
	</div>
	<br />
	<div class="dataGridHolder fullWidth">
		<table class="dataGrid fullWidth">
		<tr class="header">
			<td>ID</td>
		    <td>Contenu</td>
		</tr>
		<%
		for (int i=0; i < vItem.size(); i++) {
			InfosBulles item = vItem.get(i);
		%>
		    <tr class="liste<%=i%2%>" 
		        onmouseover="className='liste_over'" 
		        onmouseout="className='liste<%=i%2%>'" 
		        onclick="javascript:displayItem(<%= item.getId() %>);">
		        <td style="width:5%"><%= item.getId() %></td>
		        <td style="width:90%"><%= Outils.tronquerChaineParMot(item.getName(),200)  %></td>
		    </tr>
		<%
		}
		%>
		</table>
	</div>	
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
<%@page import="org.coin.util.InfosBulles"%>
<%@page import="org.coin.util.Outils"%>
</html>
