<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="modula.commission.*,modula.marche.*"%>
<%
	String sTitle = "Suppression d'une commission";
	int iIdMembre = Integer.parseInt(request.getParameter("iIdCommissionMembre"));

	CommissionMembre membre = new CommissionMembre(iIdMembre);
	membre.load();
	
	String sMessTitle = "Attention !";
	String sMess = "Vous allez supprimer un membre, en cons&eacute;quence ce membre ne pourra plus acc&eacute;der &agrave; la commission " + Commission.getNomCommission(membre.getIdCommission()) +".";
	String sUrlIcone = modula.graphic.Icone.ICONE_WARNING; 
	
%>
</head>
<body>
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<form name="formulaire" method="post" action="<%= response.encodeURL("supprimerCommissionMembre.jsp") %>" >
<input type="hidden" name="iIdCommissionMembre" value="<%= iIdMembre %>" />
<%@ include file="../../include/message.jspf" %>
	<div style="text-align:center">
		<button type="submit" >Supprimer</button>
		&nbsp;
		<button type="button" 
			onclick="Redirect('<%=response.encodeRedirectURL(
				rootPath+"desk/commission/afficherCommissionMembre.jsp?iIdCommissionMembre="+iIdMembre) 
				%>')" >Annuler</button>
	</div>
</form>

<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>
</html>