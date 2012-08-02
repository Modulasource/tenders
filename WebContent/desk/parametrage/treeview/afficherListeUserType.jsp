<%@ include file="../../../include/headerXML.jspf" %>

<%  String sTitle = "HTML TreeView";
	String rootPath = request.getContextPath()+"/";
 %>
<%@ include file="../../include/headerDesk.jspf" %>
</head>
<body>
<br />
	<input type="button" name="Modifier Treeview" value="Modifier Treeview" 
		onclick="Redirect('<%= response.encodeURL("modifierTreeviewForm.jsp") %>')"/>

</body>
</html>