<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="java.sql.*" %>
<%@ page import="org.coin.util.*,modula.journal.*,modula.algorithme.*" %>
<%@ page import="java.util.*,modula.marche.*" %>
<%@ page import="mt.modula.bean.mail.*" %>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);

	String sTitle = "Envoi du mail aux candidats invités à présenter une offre";
	String sMess = "";
	String sMessTitle = "";
	String sUrlIcone = "";
	int iErreur = 0;
	Vector<MarcheLot> vLots = MarcheLot.getAllLotsConstituablesFromMarche(marche);
	Vector<MarcheLot> vLotsTotal = MarcheLot.getAllLotsFromMarche(iIdAffaire);
	
	int iIdNextPhaseEtapes = HttpUtil.parseInt("iIdNextPhaseEtapes", request,-1);
	
	String sAction = HttpUtil.parseStringBlank( "sAction", request);
	boolean bNegociation = HttpUtil.parseBoolean("bNegociation", request, false);
	String sMailObjet = request.getParameter("objet");
	
	String sMailMessageHTML = request.getParameter("contenuMail");
	
	sessionUserHabilitation.isHabilitateException("IHM-DESK-AFF-27");

	if(sAction.equals("storePlanning"))
	{
		Connection conn = ConnectionManager.getConnection();
		MarcheHttpTraitemenent.updatePlanningAndCandidature(marche, request, conn);
		response.sendRedirect( response.encodeRedirectURL("envoyerMailInvitationOffreForm.jsp?bNegociation="
				+bNegociation+"&iIdNextPhaseEtapes="+iIdNextPhaseEtapes+"&iIdAffaire=" + marche.getId()));
		ConnectionManager.closeConnection(conn);

		return;
	}

	MailCandidature mc = new MailCandidature();
		
	Connection conn = ConnectionManager.getConnection();
	try {
	 	mc.envoyerMailInvitationOffre(
				marche.getIdMarche(),
				sMailObjet,
				sMailMessageHTML,
				sMailMessageHTML,
				sessionUser,
				bNegociation,
				conn);
		
	} catch (Exception e) {
		e.printStackTrace();
	}
	
	ConnectionManager.closeConnection(conn);
%>
</head>
<body>
<%@ include file="/include/new_style/headerFichePopUp.jspf" %>
<br/>
<div style="padding:15px">
<%
	String sRedirectURL = rootPath+"desk/marche/algorithme/proposition/gestion/afficherEnveloppesA.jsp?iIdAffaire="+iIdAffaire;
	
	if(bNegociation)
	{
		marche = AlgorithmeModula.lancerNegociationFromAffaire(iIdAffaire);
		sRedirectURL = rootPath 
		   + "desk/marche/algorithme/affaire/poursuivreProcedure.jsp"
		   + "?sAction=next"
		   + "&iIdAffaire=" + marche.getId();
		Evenement.addEvenement(iIdAffaire ,"IHM-DESK-AFF-38", sessionUser.getIdUser(),"Début des negociations");
	}
	else
	{
		if(!marche.isMailInvitationPresenterOffreEnvoye(false))
		{
			marche.setIdAlgoPhaseEtapes(iIdNextPhaseEtapes);
	        marche.setMailInvitationPresenterOffreEnvoye(true);
		}
	}
	marche.store();

	if (mc.iErreur != 0)
	{
		sMessTitle = "Echec de l'étape";
		mc.sMess += "Echec du traitement des candidatures<br />";
		sUrlIcone = Icone.ICONE_ERROR;
	}
	else
	{
		Evenement.addEvenement(
				marche.getIdMarche(), 
				"IHM-DESK-AFF-27", 
				sessionUser.getIdUser(), 
				"Les candidats électroniques recevables ont reçus une invitation à présener une offre");
	
		sMessTitle = "Succès de l'étape";
		sUrlIcone = Icone.ICONE_SUCCES;
		mc.sMess += "Succès du traitement des candidatures<br />";
	}
%>
<%@ include file="/include/message.jspf" %>
<div style="text-align:center">
	<button type="button" 
		onclick="closeModalAndRedirectTabActive('<%= response.encodeURL(sRedirectURL) %>')" >Fermer la fenêtre</button>
</div>

</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>

</body>
<%@page import="modula.graphic.Icone"%>
<%@page import="modula.configuration.ModulaConfiguration"%>
<%@page import="org.coin.db.ConnectionManager"%>
</html>