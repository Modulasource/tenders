<%@ include file="../../include/new_style/headerDesk.jspf" %>
<%
	String sTitle = "Test CRL";
 %>
</head>

<body>
<%@ include file="../../include/new_style/headerFiche.jspf" %>

<form name="crl" action="<%= response.encodeURL("testerCRL.jsp") %>" method="post" enctype="multipart/form-data" >

<table class="pave" summary="none">
	<tr>
		<td class="pave_titre_gauche" colspan="2">Test de liste de révocation : </td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Liste de r&eacute;vocation (.crl) : </td>
		<td class="pave_cellule_droite"><input size="100" type="file" name="sFilePath" />
		</td>
	</tr>
</table>
<br />
<button type="submit" >Tester</button>
</form>
<%@ include file="../../include/new_style/footerFiche.jspf" %>

</body>
</html>
