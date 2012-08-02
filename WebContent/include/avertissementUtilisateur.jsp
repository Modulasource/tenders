<%@ include file="headerXML.jspf" %>

<%@ page import="org.coin.util.*" %>
<%@ include file="../desk/include/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath()+"/";
	int idInfosBulle = Integer.parseInt(request.getParameter("id"));
	String sTitle = "Avertissement Utilisateur "+idInfosBulle;
%>
<%@ include file="../desk/include/headerDesk.jspf" %>
</head>
<body>
<span class="titre_page" style="padding-left:10px;padding-right:10px;">
	<%= sTitle %>
</span>&nbsp;&nbsp;
<img style="text-align:right;vertical-align:middle" src="<%=rootPath+modula.graphic.Icone.ICONE_AU%>" alt="<%=sTitle%>" /><br />
<br />
<div align="left" style="font-weight:bold">
<br /><br />
<%=Outils.replaceAll(InfosBulles.getInfosBullesContenuWeb(idInfosBulle,false,rootPath),"\n","<br />") %>
</div>
<br /><br />
<form action="#">
<input type="button" value="Fermer" onclick="window.close();" />
</form>
</body>
</html>
