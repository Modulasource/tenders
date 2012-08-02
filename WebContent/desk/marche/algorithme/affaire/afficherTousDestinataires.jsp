<%@ include file="../../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.fr.bean.*,java.util.*,org.coin.fr.bean.mail.*" %>
<%
	int iIdMailing = Integer.parseInt(request.getParameter("iIdMailing"));
	String sTitle = "Afficher les destinataires de l'envoi ";

	Vector<Organisation> vOrganisationsSelected 
		= MailingDestinataire.getAllOrganisationsAvecAuMoinsUnePersonnePhysiqueSelectedOuOrganisationSelected(iIdMailing);
	
	boolean  bReadOnly = false;
	
	
%>
<script src="<%= rootPath %>include/redirection.js" type="text/javascript"></script>
<script src="<%= rootPath %>include/popup.js" type="text/javascript"></script>
</head>
<body>
<%@ include file="../../../../../include/new_style/headerFichePopUp.jspf" %>
<br/>
<div style="padding:15px">
<%@ include file="pave/paveDestinataires.jspf" %>

</div>
<%@ include file="../../../../../include/new_style/footerFiche.jspf" %>
</body>
</html>