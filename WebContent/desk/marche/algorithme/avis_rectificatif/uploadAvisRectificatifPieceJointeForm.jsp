<%@ include file="../../../../../include/new_style/headerDesk.jspf" %>

<%
	String sTitle = "Téléchargement de l'Avis rectificatif";
	int iIdAvisRectificatif = Integer.parseInt(request.getParameter("iIdAvisRectificatif"));
%>
</head>
<body>
<%@ include file="../../../../../include/new_style/headerFichePopUp.jspf" %>
<br/>
<div style="padding:15px">
<br/>
<form name="formulaire" method="post" action="<%=
	response.encodeURL("uploadAvisRectificatifPieceJointe.jsp?iIdAvisRectificatif=" + iIdAvisRectificatif)
		%>"	enctype="multipart/form-data" >
<br/>
<table class="pave" style="text-align:center" summary="upload d'une pièce jointe">
	<tr><td>&nbsp;</td></tr>
	<tr>
	<td>
		<input type="file" name="avisRectificatifPieceJointe" size="60" />&nbsp;&nbsp;
	</td>
	</tr>
	<tr>
	<td>
		<button type="submit" >Télécharger</button>&nbsp;
	</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
</table>
</form>
</div>
<%@ include file="../../../../../include/new_style/footerFiche.jspf" %>
</body>
</html>
