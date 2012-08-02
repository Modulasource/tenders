<%@ include file="../../../../../include/headerXML.jspf" %>

<%@ page import="org.coin.fr.bean.export.*,java.io.*,modula.candidature.*, java.util.*" %>
<%
	String sTitle = "Afficher export";
	String rootPath = request.getContextPath()+"/";
	String sSubmitButtonName = "";
%>
<%@ include file="../../include/headerDesk.jspf" %>
</head>
<body>
<%
	String sUrlRedirect ="afficherToutesPublicationsJoue.jsp?foo=1";
	
	if(request.getParameter("sUrlRedirect") != null)
	{
		sUrlRedirect = request.getParameter("sUrlRedirect");
	}
	String sAction = request.getParameter("sAction");
	
	PublicationJoue publi = PublicationJoue.getPublicationJoue(Integer.parseInt(request.getParameter("iIdPublicationJoue")));
	sSubmitButtonName = "Modifier";
	
	
	%>
	<form name="formulaire" action="<%= response.encodeURL( "modifierPublicationJoue.jsp?sAction=" + sAction ) %>" method="post" >
	<input type="hidden" name="sUrlRedirect" value="<%= sUrlRedirect%>" />
	<table class="pave" summary="none">
		<tr>
			<td class="pave_titre_gauche" colspan="2">Publication</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<%@ include file="pave/pavePublicationJoueForm.jspf" %>
		<tr><td colspan="2">&nbsp;</td></tr>
	</table>
		
	<input type="submit" />
	<input type="button" value="Retour" onclick="Redirect('<%=
		response.encodeURL( sUrlRedirect ) %>')" />
	</form>
</body>
</html>
