<%@ include file="../../include/new_style/headerDesk.jspf" %>
<%
	String sTitle = "Tester certificat";
 %>
</head>

<body>
<%@ include file="../../include/new_style/headerFiche.jspf" %>
<form name="cert" action="<%= response.encodeURL("testerCertificat.jsp") %>" method="post" enctype="multipart/form-data" >

<table class="pave" summary="none">
	<tr>
		<td class="pave_titre_gauche" colspan="2">Test de certificat Minefi : </td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Fichier Certificat (.crt) : </td>
		<td class="pave_cellule_droite"><input size="100" type="file" name="sFilePath" />
		</td>
	</tr>
</table>
<br />

<button type="submit" >Tester</button>
<button type="button" onclick="Redirect('<%= 
	response.encodeURL("afficherToutesAutoriteCertification.jsp" ) 
	%>')" >Annuler</button>
<%@ include file="../../include/new_style/footerFiche.jspf" %>

</form>
</body>
</html>
