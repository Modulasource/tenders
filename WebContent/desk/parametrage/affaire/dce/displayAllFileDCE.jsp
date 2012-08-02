<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.conf.*,java.util.*" %>
<%@page import="org.coin.bean.html.HtmlBeanTableTrPave"%>
<% 
	String sTitle = "Pièces jointe types du DCE"; 
		Vector<MarchePieceJointeType> vItem = MarchePieceJointeType.getAllStatic();
	
	
	String sPageUseCaseId = "xxx";
%>

<script type="text/javascript">


function doUrl(url)
{		
	window.location.href = url ;
}


function displayItem(id) {

	
	var sUrl = "<%=
		response.encodeURL(
				rootPath
				+"desk/parametrage/DCE/modifyFileDCEForm.jsp")%>?sAction=store&iIdType="+id;

	location.href = sUrl;
}


function fileDCE(id) {

	
	var sUrl = "<%=
		response.encodeURL(
				rootPath
				+"desk/parametrage/affaire/dce/modifyFileDCEForm.jsp")%>?sAction=store&iIdType="+id;
				
	location.href = sUrl;
}
</script>
</head>
<body>
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<div id="fiche">
	<div class="right">
	<input type="button" value="Ajouter" onclick="javascript:doUrl('<%=
		response.encodeURL(
				rootPath
				+"desk/parametrage/affaire/dce/modifyFileDCEForm.jsp?sAction=create") %>');" />
	</div><br />
	<div class="dataGridHolder fullWidth">
		<table class="pave" summary="none">
			<tr class="header">
				<td align="left" bgcolor="#D0D0D0" >Id</td>
				<td align="left" bgcolor="#D0D0D0">Type de document</td>
			</tr>
<%

for (int i=0; i < vItem.size(); i++) {
	MarchePieceJointeType item = vItem.get(i);

%>
					<tr class="liste<%=i%2%>" 
						onmouseover="className='liste_over'" 
						onmouseout="className='liste<%=i%2%>'" 
						onclick="javascript:fileDCE('<%= item.getIdType()  %>');">
				    	<td style="width:20%"><%= item.getIdType() %></td>
				    	<td style="width:20%"><%= item.getTypeDocument() %></td>

				    </tr>
<%
}
%>
				</table>
	</div>
	</div>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>
<%@page import="modula.marche.MarchePieceJointeType"%>
</html>
