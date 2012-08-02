<%@ include file="../../../include/headerXML.jspf" %>

<%@ page import="org.coin.fr.bean.*,org.coin.bean.*,org.coin.fr.bean.*,modula.*,java.io.*,modula.graphic.*" %>
<%@ include file="../../include/beanSessionUser.jspf" %>
<%
	String sTitle = "Edition de la feuille de style";
	String rootPath = request.getContextPath()+"/";
	int iIdOrganisation = Integer.parseInt(request.getParameter("iIdOrganisation"));
	OrganisationGraphisme graphisme = null;
	Multimedia css = null;
	try{
		graphisme = OrganisationGraphisme.getAllFromOrganisation(iIdOrganisation).firstElement();
		css = Multimedia.getMultimedia(graphisme.getIdCSS());
		
	}catch(Exception e){
		graphisme = new OrganisationGraphisme();
		css = new Multimedia();
	}
	
%>
<%@ include file="../../include/headerDesk.jspf" %>
</head>
<body>
<div class="titre_page"><%= sTitle %></div>
<form name="formulaire" method="post" action="<%=response.encodeURL("modifierOrganisationGraphisme.jsp?idOrganisationGraphisme="+graphisme.getId()) %>">
<table class="pave">
	<tr>
		<td class="pave_titre_gauche" colspan="2"><%=css.getFileName() %></td>
	</tr>
	<tr>
		<td class="pave_cellule_droite" colspan="2">
			<textarea style="width:100%;height:450px;" name="cssContent"><%= css.getTextContent() %></textarea> 
		</td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="2" style="text-align:center">
			<input type="submit" value="Modifier" />
		</td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
</table>
</form>
<%@ include file="../../include/footerDesk.jspf" %>
</body>
</html>