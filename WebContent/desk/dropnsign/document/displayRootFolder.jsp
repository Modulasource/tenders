<%@page import="org.coin.util.HttpUtil"%>
<%@page import="java.util.Vector"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.bean.ged.GedFolder"%>
<%@include file="/include/new_style/headerDeskUtf8.jspf" %>
<script type="text/javascript">
function createNewFolder()
{
	doUrl("<%= response.encodeURL(rootPath 
			+ "desk/dropnsign/document/modifyFolderForm.jsp" 
			+ "?sAction=create") %>");
}
</script>

</head>
<body>
<%
	long lIdParentFolder = HttpUtil.parseLong("lIdParentFolder", request, 0);
%>
<button onclick="createNewFolder()" >Ajouter un dossier</button><br/>
<jsp:include page="/desk/dropnsign/document/bloc/blocListFolders.jsp">
<jsp:param name="lIdParentFolder" value="<%= lIdParentFolder %>" />
</jsp:include>
</body>
</html>