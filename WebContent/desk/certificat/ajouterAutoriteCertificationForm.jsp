<%@ include file="../../include/new_style/headerDesk.jspf" %>
<%
	String sTitle = "Ajout d'autorité de certification";
 %>
</head>
<body>
<%@ include file="../../include/new_style/headerFiche.jspf" %>
<form name="cert" action="<%= response.encodeURL("modifierAutoriteCertification.jsp") %>" method="post" enctype="multipart/form-data" >
<br/>
<table class="pave" summary="none">
	<tr>
		<td class="pave_titre_gauche" colspan="2">Ajout d'autorité de certification</td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Fichier Certificat (.crt) : </td>
		<td class="pave_cellule_droite"><input size="100" type="file" name="sFilePath" />
		</td>
	</tr>
</table>
<br />

<button type="submit" >Ajouter</button>
<button type="button" onclick="Redirect('<%= 
	response.encodeURL("afficherToutesAutoriteCertification.jsp" ) 
	%>')" >Annuler</button>
</form>
<%@ include file="../../include/new_style/footerFiche.jspf" %>

</body>
</html>
