<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.security.*" %>
<%
	String sTitle = "Test Antivirus";
	
	String sMention = "Cet outil est un anti-virus.<br /><br />";
	sMention += "Il vous permet de tester si vos fichiers contiennent un virus ou non.<br /><br />";
	sMention += "Vous pouvez tester des fichiers binaires, des fichiers zippés, des e-mails entiers ou tout autre fichier que vous souhaitez vérifier.<br /><br />";

	String sClamAVVersion = "";
	try{sClamAVVersion = ClamAV.getVersion();}
	catch(Exception e){}
%>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<br />
<form name="scan" method="post" action="<%=response.encodeURL("scan.jsp")%>" enctype="multipart/form-data" >
<table class="pave" style="text-align:center" >
	<tr>
		<td class="pave_titre_gauche"><%= sTitle %></td>
		<td class="pave_titre_droite"><%= sClamAVVersion %></td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr><td class="mention" colspan="2"><%= sMention %></td></tr>
	<tr><td colspan="2"><input type="file" name="sFilePath" value="" size="50" /></td></tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr><td colspan="2"><button type="submit" >Scanner</button></td></tr>
	<tr><td colspan="2">&nbsp;</td></tr>
</table>
</form>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>