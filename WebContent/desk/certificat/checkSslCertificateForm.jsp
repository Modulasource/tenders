<%@ include file="../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.security.*" %>
<%
	String sTitle = "Test Chaine HTTPS";

	String sArgs = HttpUtil.parseStringBlank("sUrlToTest", request);
	ByteArrayOutputStream baos = new ByteArrayOutputStream();
	if(!sArgs.equals(""))
	{
		String[] args = sArgs.split(" ");
		PrintStream ps = new PrintStream((ByteArrayOutputStream)baos);
		InstallCert.checkSsl(args, ps, true, true);
	}
	
%>
</head>
<body>
<%@ include file="../../include/new_style/headerFiche.jspf" %>
<br />
<form method="post" action="<%=response.encodeURL("checkSslCertificateForm.jsp")%>" >
<table class="pave" style="text-align:center" >
	<tr>
		<td class="pave_titre_gauche">Tester chaine SSL</td>
		<td class="pave_titre_droite">&nbsp;</td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr>
		<td class="pave_cellule_gauche">Nom du serveur</td>
		<td class="pave_cellule_droite">
		<input type="text" name="sUrlToTest" value="<%= request.getServerName() 
		%>" size="80" /></td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr><td colspan="2">Résultat</td></tr>
	<tr><td colspan="2" class="pave_cellule_droite"><%= Outils.getTextToHtml( baos.toString()) %></td></tr>
	<tr><td colspan="2">&nbsp;</td></tr>
</table>

<div align="center">
	<button type="submit" >Tester</button>
</div>

<div align="center">
pour plus d'information : <a href="http://blogs.sun.com/andreas/entry/no_more_unable_to_find">cliquer ici</a>
</div>

</form>
<%@ include file="../../include/new_style/footerFiche.jspf" %>
</body>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="java.io.PrintStream"%>
<%@page import="java.io.ByteArrayOutputStream"%>
</html>