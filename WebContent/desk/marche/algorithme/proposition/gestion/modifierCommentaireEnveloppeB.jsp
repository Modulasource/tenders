<%@ include file="../../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.fr.bean.*, org.coin.util.*, modula.candidature.*" %>
<%@ page import="modula.journal.*" %>
<%
	int iIdCandidature = HttpUtil.parseInt("iIdCandidature",request);
	int iIdLot = HttpUtil.parseInt("iIdLot",request);
	String sReponse = HttpUtil.parseString("reponse",request,"");
	int iIdEnveloppe = HttpUtil.parseInt("iIdEnveloppe",request);
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));

	String sPageUseCaseId = "";
	sPageUseCaseId = "IHM-DESK-AFF-38";
	Enveloppe eEnveloppe = null;
	eEnveloppe = EnveloppeB.getEnveloppeB(iIdEnveloppe);
	String sTypeDossier = "";
	sTypeDossier = "l'offre";
		
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
	
	eEnveloppe.setReponse(sReponse);
	eEnveloppe.store();
	
	Candidature candidature = Candidature.getCandidature(iIdCandidature);
	PersonnePhysique candidat = PersonnePhysique.getPersonnePhysique(candidature.getIdPersonnePhysique());	
	
	Evenement.addEvenement(candidature.getIdMarche(),"IHM-DESK-AFF-82",sessionUser.getIdUser(),"Insertion d'un commentaire pour "+sTypeDossier+" de "+candidat.getCivilitePrenomNom());
	
	response.sendRedirect(response.encodeURL(
			"modifierCommentaireEnveloppeBForm.jsp?bCommentaireEnregistre="+true
			+"&iIdLot="+iIdLot
			+"&iIdCandidature="+iIdCandidature
			+"&iIdAffaire="+iIdAffaire));
%>

