<%@ include file="../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.fr.bean.export.*" %>
<%
	String sTitle = "Envoyer une publication"; 
	int iIdPublication = Integer.parseInt(request.getParameter("iIdPublication"));
	Publication publication = Publication.getPublication(iIdPublication);
	publication.publish(sessionUser,request);
%>
</head>
<body>
<%@ include file="../../include/new_style/headerFiche.jspf" %>
<br/>
<div style="padding:15px">
<table class="pave" summary="none">
	<tr>-
		<td class="pave_titre_gauche" colspan="2">Envoi de la publication</td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche" style="vertical-align:middle">
		<img src="<%=rootPath + modula.graphic.Icone.ICONE_SUCCES %>" style="vertical-align:middle"  >
		</td>
		<td class="pave_cellule_droite" style="vertical-align:middle">
			La publication a été envoyée.
		</td>
	</tr>
</table>
</div>
<%@ include file="../../../include/new_style/footerFiche.jspf" %>
</body>
</html>
