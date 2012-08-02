<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="java.sql.*" %>
<%@ page import="modula.marche.*" %>
<%@ page import="mt.modula.bean.mail.*,org.coin.util.*" %>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);

	String sTitle = "Envoyer le mail aux candidats non recevables";
	String sMess = "";
	String sMessTitle = "";
	String sUrlIcone ="";
	int iErreur = 0;
	int iIdNextPhaseEtapes = HttpUtil.parseInt("iIdNextPhaseEtapes", request,-1);

	String objet = request.getParameter("objet");
	String contenuMail = request.getParameter("contenuMail");
	
	sessionUserHabilitation.isHabilitateException("IHM-DESK-AFF-14");
	
	Connection conn = ConnectionManager.getConnection();
	MailCandidature mc = new MailCandidature();
	mc.envoyerMailCandidatNonRecevable(
			marche.getIdMarche(),
			objet,
			contenuMail,
			contenuMail,
			sessionUser,
			conn);

	/* Mise à jour du statut du marché */
    if(!marche.isCandidatsNonRecevablesNotifies(false))
    {
	    marche.setCandidatsNonRecevablesNotifies(true);
		marche.setIdAlgoPhaseEtapes(iIdNextPhaseEtapes);
	    marche.store(conn);
    }
    sMess = mc.sMess;
	/* AFFICHAGE RESULTAT */
	Evenement.addEvenement(
			marche.getIdMarche(), 
			"IHM-DESK-AFF-58", 
			sessionUser.getIdUser(), 
			"Les candidats électroniques non-recevables ont été prévenus");
	sMessTitle = "Succès de l'étape";
	sUrlIcone = Icone.ICONE_SUCCES;
	sMess += "Succès du traitement des candidatures<br />";

	ConnectionManager.closeConnection(conn);
	
	String sURLRedirect = response.encodeURL(rootPath+"desk/marche/algorithme/proposition/gestion/afficherEnveloppesA.jsp?iIdAffaire="+iIdAffaire);
	
%>
</head>
<body>
<%@ include file="/include/new_style/headerFichePopUp.jspf" %>
<br/>
<div style="padding:15px">
<%@ include file="/include/message.jspf" %>
<div style="text-align:center">
	<button type="button" class="disableOnClick"
		onclick="closeModalAndRedirectTabActive('<%= sURLRedirect %>')" >Fermer la fenêtre</button>
</div>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="modula.journal.Evenement"%>
<%@page import="modula.graphic.Icone"%>
</html>