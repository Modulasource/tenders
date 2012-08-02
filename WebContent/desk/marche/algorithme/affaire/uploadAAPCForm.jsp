<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="modula.marche.*" %>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);
	String sTitle = "Téléchargement de l'AAPC";
%>
</head>
<body>
<%@ include file="/include/new_style/headerFichePopUp.jspf" %>
<br/>
<div style="padding:15px">
<form name="uploadAAPC" method="post" action="<%=
	response.encodeURL("uploadAAPC.jsp?iIdAffaire=" + iIdAffaire)%>"
				enctype="multipart/form-data" >
<br/><br/><br />

<table class="pave" style="text-align:center" >
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td>
			<input type="file" name="aapcPath" value="" />&nbsp;&nbsp;
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
<%@ include file="/include/new_style/footerFiche.jspf" %>

</body>
</html>
