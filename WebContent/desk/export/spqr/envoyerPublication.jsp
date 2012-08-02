<%@ include file="../../../include/headerXML.jspf" %>

<%@ page import="modula.ws.xmedia.publissimo.*,java.sql.*,org.coin.fr.bean.mail.*,org.coin.fr.bean.export.*,org.coin.util.*" %>
<%@ page import="java.io.*,java.util.*,modula.*, modula.marche.*,org.coin.fr.bean.*,modula.algorithme.*,modula.commission.*" %>
<%@ include file="../../../include/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath()+"/";
	String sTitle = "Envoyer une publication"; 
	int iIdPublicationSpqr = Integer.parseInt(request.getParameter("iIdPublicationSpqr"));
	PublicationSpqr publication = PublicationSpqr.getPublicationSpqr(iIdPublicationSpqr);
	publication.publish();  
%>
<%@ include file="../../include/headerDesk.jspf" %>
</head>
<div class="titre_page">Envoi de la publication</div>
<table class="pave" summary="none">
	<tr>
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

<%@ include file="../../include/footerDesk.jspf" %>