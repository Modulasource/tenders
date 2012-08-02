<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.conf.*,java.util.*" %>
<%@page import="org.coin.bean.html.HtmlBeanTableTrPave"%>
<% 
	String sTitle = "Liste des groupes de compétences spécifiques (CPF)"; 
	Vector<CodeCpfGroup> vItem = CodeCpfGroup.getAllStaticMemory(true);
	String sPageUseCaseId = "xxx";
%>

<script type="text/javascript">
function displayItem(id) {
	var sUrl = "<%=
		response.encodeURL(
				rootPath
				+"desk/parametrage/affaire/cpf/modifyCPFGroupForm.jsp")%>?sAction=store&lId="+id;

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
				+"desk/parametrage/affaire/cpf/modifyCPFGroupForm.jsp?sAction=create") %>');" />Ajouter</button>
	</div>
	<br />
	<div class="dataGridHolder fullWidth">
		<table class="dataGrid fullWidth">
		<tr class="header">
			<td>ID</td>
		    <td>Nom </td>
			<td>Codes CPF</td>

		</tr>
		<%
		for (int i=0; i < vItem.size(); i++) {
			CodeCpfGroup item = vItem.get(i);
		%>
		    <tr class="liste<%=i%2%>" 
		        onmouseover="className='liste_over'" 
		        onmouseout="className='liste<%=i%2%>'" 
		        onclick="javascript:displayItem(<%= item.getId() %>);">
		        <td style="width:5%"><%= item.getId() %></td>
		        <td style="width:30%"><%= item.getName() %></td>
				<td style="width:30%">
				<%
				Vector<BoampCPF> vCPF = CodeCpfGroupItem.getAllBoampCPFFromGroup(item.getId());
				for(BoampCPF cpf : vCPF){
				%>
				<%= cpf.getName() %><br/>
				<%}%>
				</td>
		    </tr>
		<%
		}
		%>
		</table>
	</div>	
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
<%@page import="modula.marche.MarchePieceJointeType"%>
<%@page import="mt.modula.affaire.cpf.CodeCpfGroup"%>

<%@page import="mt.modula.affaire.cpf.CodeCpfGroupItem"%>
<%@page import="org.coin.bean.boamp.BoampCPF"%></html>
