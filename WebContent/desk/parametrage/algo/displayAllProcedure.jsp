<%@ include file="../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.algorithm.*,java.util.*" %>
<% 
	String sTitle = "Process List";
	Vector<Procedure> vItems = Procedure.getAllStaticMemory();
	
	String sPageUseCaseId = "IHM-DESK-ALGO-1";
	String sPageUseCaseIdAjouter = "IHM-DESK-ALGO-2";
%>
<%@ include file="../../include/checkHabilitationPage.jspf" %>
<script type="text/javascript" src="<%= rootPath %>dwr/interface/Procedure.js" ></script>
<script type="text/javascript" >
function displayProcedure(id) {
	location.href = "<%=response.encodeURL("displayProcedure.jsp?id=")%>"+id;
}
function addProcedure() {
	location.href = "<%=response.encodeURL("displayProcedure.jsp")%>";
}
function deleteProcedure(id) {
	if(confirm("Do you want to delete this process ?" )){
         Procedure.removeFromId(id, function() { 
                window.location.reload(true);
         });
    }
}
</script>
</head>
<body>
<%@ include file="../../../include/new_style/headerFiche.jspf" %>
<div style="padding:15px">
	<div style="height:2em">
		<% if(sessionUserHabilitation.isHabilitate(sPageUseCaseIdAjouter)){ %>
		<a href="javascript:void(null)" onclick="addProcedure();return false" style="float:left">Ajouter une procédure</a>
		<% } %>
		<span style="float:right"><%= vItems.size() %> procédure<%= ((vItems.size()>1)?"s":"") %></span>
	</div>
	<div class="dataGridHolder">
	<table class="dataGrid fullWidth">
		<tr class="header">
			<td>Procédure</td>
			<td>Commentaire</td>
			<td width="100px"></td>
			<td width="20px"></td>
		</tr>
<%
for (int i=0; i < vItems.size(); i++) {
	Procedure proc = vItems.get(i);
%>
		<tr class="line<%=i%2%>">
	    	<td><%=proc.getLibelle()%></td>
	    	<td><%=proc.getCommentaire()%></td>
	    	<td><a href="javascript:void(null)" onclick="javascript:displayProcedure('<%=proc.getId()%>');return false">Voir la procédure</a></td>
	    	<td><img onclick="javascript:deleteProcedure('<%=proc.getId()%>');" src="<%=rootPath%>images/icons/cross.gif" class="pointer"/></td>
	  	</tr>
<%
}
%>
	</table>
	</div>	
	
</div> <!-- end fiche -->
<%@ include file="../../../include/new_style/footerFiche.jspf" %>
</body>
</html>