<%@ include file="../../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.fr.bean.*, org.coin.util.*, modula.candidature.*" %>
<%@ page import="modula.journal.*" %>
<%
	int iIdCandidature = HttpUtil.parseInt("iIdCandidature",request);
	int iIdLot = HttpUtil.parseInt("iIdLot",request);
	String sReponse = HttpUtil.parseString("reponse",request,"");
	int iIdEnveloppe = HttpUtil.parseInt("iIdEnveloppe",request);
	int iTypeEnveloppe = HttpUtil.parseInt("iTypeEnveloppe",request);

	String sPageUseCaseId = "";
	Enveloppe eEnveloppe = null;
	String sTypeDossier = "";
	switch(iTypeEnveloppe){
	case Enveloppe.TYPE_ENVELOPPE_A:
		sPageUseCaseId = "IHM-DESK-AFF-37";
		eEnveloppe = EnveloppeA.getEnveloppeA(iIdEnveloppe);
		sTypeDossier = "la candidature";
		break;
	case Enveloppe.TYPE_ENVELOPPE_B:
		sPageUseCaseId = "IHM-DESK-AFF-38";
		eEnveloppe = EnveloppeB.getEnveloppeB(iIdEnveloppe);
		sTypeDossier = "l'offre";
		break;
	case Enveloppe.TYPE_ENVELOPPE_C:
		sPageUseCaseId = "IHM-DESK-AFF-38";
		eEnveloppe = EnveloppeC.getEnveloppeC(iIdEnveloppe);
		sTypeDossier = "l'offre";
		break;
	}
	
	if(!sPageUseCaseId.equalsIgnoreCase(""))
		sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
	
	eEnveloppe.setReponse(sReponse);
	eEnveloppe.store();
	
	Candidature candidature = Candidature.getCandidature(iIdCandidature);
	PersonnePhysique candidat = PersonnePhysique.getPersonnePhysique(candidature.getIdPersonnePhysique());	
	
	Evenement.addEvenement(candidature.getIdMarche(),"IHM-DESK-AFF-82",sessionUser.getIdUser(),"Insertion d'un commentaire pour "+sTypeDossier+" de "+candidat.getCivilitePrenomNom());
	
	response.sendRedirect(response.encodeURL(
			"modifierCommentaireEnveloppeForm.jsp?bCommentaireEnregistre="+true
			+"&iIdLot="+iIdLot
			+"&iIdCandidature="+iIdCandidature
			+"&iTypeEnveloppe="+iTypeEnveloppe));
%>

