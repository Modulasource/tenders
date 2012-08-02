<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@ page import="org.coin.util.*,modula.journal.*,modula.algorithme.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="modula.marche.*" %>
<%@ page import="mt.modula.bean.mail.*,org.coin.util.*" %>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);
	String sAction = HttpUtil.parseStringBlank("sAction", request);
	int iIdNextPhaseEtapes = HttpUtil.parseInt("iIdNextPhaseEtapes",request, -1);
	boolean bNegociation = false;
	String sTitle = "";
	String sMess = "";
	String sMessTitle = "";
	String sUrlIcone = "";
	int iErreur = 0;
	String sRedirectURL = rootPath + "desk/marche/algorithme/proposition/gestion/afficherEnveloppesA.jsp?iIdAffaire="+ iIdAffaire;
	
	if (sAction.equalsIgnoreCase("rec") && !marche.isMailInvitationPresenterOffreEnvoye(false)) 
	{
		marche.setIdAlgoPhaseEtapes(iIdNextPhaseEtapes);
		marche.setMailInvitationPresenterOffreEnvoye(true);
		sessionUserHabilitation.isHabilitateException("IHM-DESK-AFF-27");
		bNegociation = HttpUtil.parseBoolean("bNegociation", request,false);
		sTitle = "Ne pas envoyer mail aux candidats recevables";
		marche.store();
		
		if (bNegociation) {
			marche = AlgorithmeModula.lancerNegociationFromAffaire(iIdAffaire);
			sRedirectURL = rootPath
					+ "desk/marche/algorithme/affaire/poursuivreProcedure.jsp"
					+ "?sAction=next" + "&iIdAffaire="
					+ marche.getId();
			Evenement.addEvenement(iIdAffaire, "IHM-DESK-AFF-38",
					sessionUser.getIdUser(),
					"Début des negociations");
		} else {
			Evenement.addEvenement(
							marche.getIdMarche(),
							"IHM-DESK-AFF-27",
							sessionUser.getIdUser(),
							"Les candidats électroniques recevables ne peuvent plus être prévenus par mails");
		}
	}
	
	if (sAction.equalsIgnoreCase("nonRec") && !marche.isCandidatsNonRecevablesNotifies(false))
	{
		marche.setIdAlgoPhaseEtapes(iIdNextPhaseEtapes);
		marche.setCandidatsNonRecevablesNotifies(true);
		sessionUserHabilitation.isHabilitateException("IHM-DESK-AFF-14");
		sTitle = "Ne pas envoyer mail aux candidats non recevables";
		marche.store();
		Evenement.addEvenement(
				marche.getIdMarche(),
				"IHM-DESK-AFF-58",
				sessionUser.getIdUser(),
				"Les candidats électroniques non-recevables ne peuvent plus être prévenus par mails");	
	}
	
	sMessTitle = "Succès de l'étape";
	sUrlIcone = Icone.ICONE_SUCCES;
	sMess += "Succès du traitement des candidatures<br />";
%>
</head>
<body>
<%@ include file="/include/new_style/headerFichePopUp.jspf" %>
<br/>
<div style="padding:15px">
<%@ include file="/include/message.jspf" %>
<div style="text-align:center">
	<button type="button" class="disableOnClick"
		onclick="closeModalAndRedirectTabActive('<%=response.encodeURL(sRedirectURL)%>')" >Fermer la fenêtre</button>
</div>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="modula.journal.Evenement"%>
<%@page import="modula.graphic.Icone"%>
</html>