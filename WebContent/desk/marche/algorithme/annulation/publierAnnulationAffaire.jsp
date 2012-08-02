<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="modula.marche.*,modula.*,org.coin.fr.bean.*" %>
<%@ page import="mt.modula.bean.mail.*,org.coin.mail.*" %>
<%

	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);

	String sTitle = "Publier l'annulation de l'affaire";
	Connection conn = ConnectionManager.getConnection();

	String sMess="";
	marche.setAnnulationAffairePubliee(true);
	marche.store(conn);
	
	MailCandidature mc = new MailCandidature();
	mc.prevenirPublicationAnnulationAffaire(
			marche.getIdMarche(),
			request.getParameterValues("selection"),
			request.getParameter("objet"),
			"",
			request.getParameter("contenuMail"),
			sessionUser, 
			conn);
	
	
	ConnectionManager.closeConnection(conn);

%>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<div style="padding:15px">
<%
	String sMessTitle = "";
	String sUrlIcone = "";
	if(mc.iErreur==0){
		sMessTitle = "Succ&egrave;s";
		sMess += "Les supports de publication ont tous été prévenus de l'annulation de l'affaire.";
		sUrlIcone = Icone.ICONE_SUCCES;	
	}
	else{
		sMessTitle = "Erreur !";
		sMess += "Tous les supports de publication n'ont pas été prévenus de l'annulation de l'affaire.";
		sUrlIcone = Icone.ICONE_ERROR;	
	}
%>
<%@ include file="/include/message.jspf" %>
<br />
<script type="text/javascript" src="<%= rootPath %>include/redirection.js"></script>

<script type="text/javascript">
function closeModalFrame()
{

	parent.redirectParentTabActive(
	'<%= 
		response.encodeURL(rootPath 
                + "desk/marche/algorithme/annulation/annulerAffaireForm.jsp"
                + "?iIdAffaire="+iIdAffaire)  %>');

   try {new parent.Control.Modal.close();}
   catch(e) { Control.Modal.close();}
}

</script>
<div style="text-align:center">
<button type="button"
	onclick="closeModalFrame()">
	Retour</button>
</div>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
<%@page import="modula.graphic.Icone"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.db.ConnectionManager"%>
</html>