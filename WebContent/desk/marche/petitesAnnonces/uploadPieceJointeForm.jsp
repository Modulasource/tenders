<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@ page import="modula.marche.*" %>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);

	String sTitle = "Téléchargement de la pièce jointe";
%>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>

<form name="uploadPieceJointe" method="post" 
    action="<%=response.encodeURL("uploadPieceJointe.jsp?iIdAffaire=" + marche.getId()  )%>"
	enctype="multipart/form-data" >
<br/><br/><br />
<table class="pave" style="text-align:center" >
	<tr>
	<td>
		<input type="file" name="pieceJointePath" value="" />&nbsp;&nbsp;
	</td>
	</tr>
	<tr>
	<td>
		<input type="checkbox" name="bIsDCEDisponible" <%= 
		marche.isDCEDisponible(false)?"checked='checked'":"" 
		%> /> est un DCE<br/>
		<button type="submit" >Télécharger</button>
	</td>
	</tr>
</table>
</form>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>
