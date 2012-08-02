<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="java.sql.*" %>
<%@ page import="modula.marche.*" %>
<%@ page import="mt.modula.bean.mail.*" %>
<%@page import="modula.graphic.Icone"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);


	String sTitle = "";
	String sMess = "";
	String sMessTitle = "";
	String sUrlIcone = "";
	String objet = request.getParameter("objet");
	String contenuMail = request.getParameter("contenuMail");

	Connection conn = ConnectionManager.getConnection();
	MailCandidature mc = new MailCandidature();
	mc.prevenirCandidatModificationDCE(
			marche.getIdMarche(),
			objet,
			contenuMail,
			contenuMail,
			sessionUser,
			conn);

	ConnectionManager.closeConnection(conn);
	
	if(mc.iErreur == 0)
	{
			sMessTitle = "Succès de l'étape";
			sUrlIcone = Icone.ICONE_SUCCES;
	}
	if(mc.iErreur > 0)
	{
			sMessTitle = "Echec de l'étape";
			sUrlIcone = Icone.ICONE_ERROR;
	}
	if(mc.iErreur == 0 && mc.vCandidatures.size() == 0)
	{
			sMessTitle = "Etape non effectuée";
			sMess = "Il n'y a aucun candidat à prevenir";
			sUrlIcone = Icone.ICONE_WARNING;
	}
	
	sMess = mc.sMess;
%>
</head>
<body>
<%@ include file="/include/new_style/headerFichePopUp.jspf" %>
<br/>
<div style="padding:15px">
<body>
<%@ include file="/include/message.jspf" %>
<div style="text-align:center">
	<button type="button" 
		onclick="redirectUrlAndClosePopup('<%= response.encodeURL(rootPath 
				+ "desk/marche/algorithme/affaire/modifierDCE.jsp?sAction=cloturer&iIdAffaire=" 
				+ marche.getIdMarche())%>')" >Retour à l'affaire</button>
</div>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>