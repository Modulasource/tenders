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
	String sUrlRedirect ="afficherTousPublication.jsp?foo=1";
	
	if(request.getParameter("sUrlRedirect") != null)
	{
		sUrlRedirect = request.getParameter("sUrlRedirect");
	}
	String sAction = request.getParameter("sAction");
	
	Publication publi = Publication.getPublication(Integer.parseInt(request.getParameter("iIdPublication")));
	sSubmitButtonName = "Modifier";
	
	%>
	<form action="none" method="post" >
	<table class="pave" summary="none">
		<tr>
			<td class="pave_titre_gauche" colspan="2">Publication</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<%@ include file="pave/pavePublication.jspf" %>
		<tr><td colspan="2">&nbsp;</td></tr>
	</table>
		
	<input type="button" value="<%= sSubmitButtonName %>" onclick="Redirect('<%=
		response.encodeURL( 
			rootPath + "desk/export/publication/modifierPublicationForm.jsp?sAction=store&amp;iIdPublication="
			+ publi.getIdPublication()
			+ "&amp;sUrlRedirect=" + sUrlRedirect) %>')" />
	<input type="button" value="Retour" onclick="Redirect('<%=
		response.encodeURL( sUrlRedirect ) %>')" />
	</form>
</body>
</html>
