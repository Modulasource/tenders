
<%@ page import="modula.graphic.*,org.coin.bean.form.*,java.security.cert.*,java.io.*, java.util.*" %>
<%
	String sPageUseCaseId = "xxx";
	String sUseCaseIdBoutonCreateForm = "xxx";
	Vector<AutoForm> vItems = AutoForm.getAllStatic();
	String sTitle = "Liste des formulaires : <span class=\"altColor\">"+vItems.size()+"</span>"; 
 %>
<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@ include file="/desk/include/checkHabilitationPage.jspf" %>
<script type="text/javascript">
requireClass("org.coin.bean.form.AutoForm");
</script>
<script type="text/javascript" >
function displayForm(id) {
	location.href = "<%=response.encodeURL(rootPath+"desk/form/displayAutoForm.jsp?iIdAutoForm=")%>"+id;
}
function addForm() {
	location.href = "<%=response.encodeURL(rootPath+"desk/form/modifyAutoForm.jsp?sAction=create")%>";
}
function deleteForm(id) {
	if (confirm("Etes-vous sûr de vouloir effacer ce formulaire ?")) {
		location.href = "<%=response.encodeURL(rootPath+"desk/form/modifyAutoForm.jsp?sAction=remove&iIdAutoForm=")%>"+id;
	}
}
</script>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<div id="fiche">
	<%
	if( sessionUserHabilitation.isHabilitate(sUseCaseIdBoutonCreateForm))
	{
	%>
	<input type="button" value="Ajouter" onclick="addForm()" /><br/><br/>
	<%
	}
	%>
	<div class="dataGridHolder fullWidth">
	<table class="dataGrid fullWidth">
		<tr class="header">
			<td>Nom</td>
			<td>Libellé</td>
			<td width="100px"></td>
			<td width="20px"></td>
		</tr>
<%
	for (int i=0; i < vItems .size() ; i++)
	{
		AutoForm item = vItems.get(i);
		%>
		<tr class="line<%=i%2%>">
	    	<td><%=item.getName() %></td>
	    	<td><%=item.getCaption() %></td>
	    	<td><button onclick="javascript:displayForm('<%=item.getId() %>');">Voir le formulaire</button></td>
	    	<td><img onclick="javascript:deleteForm('<%=item.getId() %>');" src="<%=rootPath%>images/icons/cross.gif" style="cursor:pointer"/></td>
	  	</tr>
<%
}
%>
	</table>
	</div>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>