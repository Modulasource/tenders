<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="modula.ws.marco.*" %>
<% String sTitle = "Afficher la liste des exports de MARCO" ;%>
</head>
<body>
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<pre>
<%
	String sDataXml;
	
	int id = Integer.parseInt(request.getParameter("id"));
	
	ExportMarco export = new ExportMarco(id);
	export.load();

	sDataXml = export.getExport() ;
	out.write(org.coin.util.Outils.getTextToHtml(sDataXml)) ;
		
%>
</pre>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>
</html>
