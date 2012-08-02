<%@ include file="/include/headerXML.jspf" %>
<%@ page import="org.coin.fr.bean.*" %>

<%@ include file="/desk/include/beanSessionUser.jspf" %>
<%
	String sTitle = "Téléchargement du logo de l'organisation";
	String rootPath = request.getContextPath()+"/";
	int iIdOrganisation = Integer.parseInt(request.getParameter("iIdOrganisation"));
	Organisation organisation = Organisation.getOrganisation(iIdOrganisation);
%>
<%@ include file="/desk/include/headerDesk.jspf" %>
</head>
<body>
<form name="uploadLogo" method="post" action="<%=response.encodeURL("uploadLogo.jsp?iIdOrganisation="+iIdOrganisation)%>"
				enctype="multipart/form-data" >
<br/>
<div class="titre_page">Chargement du logo</div><br />
<table class="pave" style="text-align:center" >
	<tr><td>&nbsp;</td></tr>
	<tr>
	<td>
		<input type="file" name="logoPath" value="" />
	</td>
	</tr>
	<tr>
	<td colspan="2">
		&nbsp;<input type="submit" value="Télécharger" />&nbsp;
	</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
</table>
</form>
</body>
</html>
