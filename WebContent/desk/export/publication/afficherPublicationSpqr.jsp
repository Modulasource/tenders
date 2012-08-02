<%@ include file="../../../../../include/headerXML.jspf" %>

<%@ page import="org.coin.fr.bean.export.*,java.io.*,modula.candidature.*, java.util.*" %>
<%
	String sTitle = "Afficher export";
	String rootPath = request.getContextPath()+"/";
	String sSubmitButtonName = "";
	int iIdOnglet = Integer.parseInt(request.getParameter("iIdOnglet"));
%>
<%@ include file="../../include/headerDesk.jspf" %>
</head>
<body>
<%
PublicationSpqr publi = PublicationSpqr.getPublicationSpqr(Integer.parseInt(request.getParameter("iIdPublicationSpqr")));
sSubmitButtonName = "Modifier";
String sUrlRedirect = rootPath+"desk/marche/algorithme/affaire/afficherToutesPublications.jsp?iIdAffaire="+publi.getIdReferenceObjet()
+"&iIdOnglet="+iIdOnglet;
	
	if(request.getParameter("sUrlRedirect") != null)
	{
		sUrlRedirect = request.getParameter("sUrlRedirect");
	}
	String sAction = request.getParameter("sAction");
	
	%>
	<form action="none" method="post" >
	<table class="pave" summary="none">
		<tr>
			<td class="pave_titre_gauche" colspan="2">Publication</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<%@ include file="pave/pavePublicationSpqr.jspf" %>
		<tr><td colspan="2">&nbsp;</td></tr>
	</table>
		<br />
	<input type="button" value="<%= sSubmitButtonName %>" onclick="Redirect('<%=
		response.encodeURL( 
			rootPath + "desk/export/publication/modifierPublicationSpqrForm.jsp?sAction=store&amp;iIdPublicationSpqr="
			+ publi.getIdPublicationSpqr()
			+ "&amp;sUrlRedirect=" + sUrlRedirect) %>')" />
	<input type="button" value="Retour" onclick="Redirect('<%=
		response.encodeURL( sUrlRedirect ) %>')" />
	</form><br />
</body>
</html>