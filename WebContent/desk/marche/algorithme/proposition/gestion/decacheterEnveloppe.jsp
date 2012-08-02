<%@page import="modula.candidature.Enveloppe"%>
<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@page import="org.coin.util.HttpUtil"%>

<%@ page import="modula.marche.*" %>
<%@ page import="modula.journal.*" %>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);

	int iTypeEnveloppe = HttpUtil.parseInt("iTypeEnveloppe",request);
	int iIdNextPhaseEtapes = HttpUtil.parseInt("iIdNextPhaseEtapes", request,-1);
	
	String sAction = HttpUtil.parseStringBlank("sAction", request);
	if(sAction.equalsIgnoreCase("anonyme"))
	{
		String sUrlTraitement = HttpUtil.parseStringBlank("sUrlTraitement", request);
		int iAnonyme = HttpUtil.parseInt("iAnonyme", request, -1) ;
		
		if(iAnonyme == 1)
			marche.setEnveloppesCAnonyme(true);
		else
			marche.setEnveloppesCAnonyme(false);
		marche.store();
			
		response.sendRedirect( 
				response.encodeRedirectURL("decacheterEnveloppeForm.jsp"
				+"?nonce=" + System.currentTimeMillis()
				+ "&iIdAffaire=" + marche.getId()
                + "&sUrlTraitement="+sUrlTraitement
				+" &iIdNextPhaseEtapes="+iIdNextPhaseEtapes
				+" &bAfficheDecachetage=true"
				+ "&iTypeEnveloppe="+iTypeEnveloppe
				+ "&#ancreHP"));
		return ;
	}

	String sPageUseCaseId = "";
	String sEvt = "";
	switch(iTypeEnveloppe){
	case Enveloppe.TYPE_ENVELOPPE_A:
		sPageUseCaseId = "IHM-DESK-AFF-12";
		marche.setEnveloppesADecachetees(true);
		sEvt = "Fin de décachetage des enveloppes A";
		break;
	case Enveloppe.TYPE_ENVELOPPE_B:
		sPageUseCaseId = "IHM-DESK-AFF-15";
		marche.setEnveloppesCAnonyme(false);
		marche.setEnveloppesBDecachetees(true);
		marche.setMailInvitationPresenterOffreEnvoye(false);
		sEvt = "Fin de décachetage des enveloppes B";
		break;
	case Enveloppe.TYPE_ENVELOPPE_C:
		sPageUseCaseId = "IHM-DESK-AFF-15";
		marche.setEnveloppesCDecachetees(true);
		marche.setMailInvitationPresenterOffreEnvoye(false);
		sEvt = "Fin de décachetage des enveloppes de prestation (C)";
		break;
	}

	if(!sPageUseCaseId.equalsIgnoreCase(""))
		sessionUserHabilitation.isHabilitateException(sPageUseCaseId);

	marche.setIdAlgoPhaseEtapes(iIdNextPhaseEtapes);
	marche.store();

	Evenement.addEvenement(marche.getIdMarche(), sPageUseCaseId, sessionUser.getIdUser(),sEvt);

	response.sendRedirect( 
			response.encodeRedirectURL("decacheterEnveloppeForm.jsp"
			+"?nonce=" + System.currentTimeMillis() 
			+ "&iIdAffaire=" + marche.getId()
            + "&iTypeEnveloppe="+iTypeEnveloppe
			+ "&#ancreHP"));
%>