<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="modula.commission.*" %>
<%@ include file="../include/beanSessionIdCommission.jspf" %>
<%
	String sTitle = "Suppression d'une commission";
	String sPageUseCaseId = "IHM-DESK-COM-005";
%>
</head>
<body>
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<form name="formulaire" method="post" action="<%= response.encodeURL("supprimerCommission.jsp") %>" >
<input type="hidden" name="iIdCommission" value="<%= commission.getIdCommission() %>" />
<%
	String sMessTitle = "Attention !";
	String sMess = "Vous allez supprimer une commission";
	String sUrlIcone = modula.graphic.Icone.ICONE_WARNING;	
%>
<%@ include file="../../include/message.jspf" %>
	<div style="text-align:center">
		<button type="submit" name="submit" ><%= localizeButton.getValueDelete()  %></button>
		&nbsp;
		<button type="button" name="RAZ" 
			onclick="Redirect('<%=response.encodeRedirectURL(
				rootPath+"desk/commission/afficherCommission.jsp?iIdCommission="
						+commission.getIdCommission()) %>')" ><%= localizeButton.getValueCancel() %></button>
	</div>
</form>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>
</html>