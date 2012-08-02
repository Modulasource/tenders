
<%@ page import="org.coin.fr.bean.*,modula.*,modula.candidature.*, java.sql.*" %>
<%@ include file="../../../publisher_traitement/public/include/beanSessionUser.jspf" %>
<%@ include file="../../../publisher_traitement/public/include/beanCandidat.jspf" %> 
<%@ include file="../../../include/publisherType.jspf" %>
<%
	String rootPath = request.getContextPath()+"/";
	DemandeInfoComplementaire demande = null;
	if (request.getParameter("iIdDemandeInfoComp") != null)
		demande = DemandeInfoComplementaire.getDemandeInfoComplementaire(Integer.parseInt(request.getParameter("iIdDemandeInfoComp")));
	
	demande.setDateFermetureRemise(new Timestamp(System.currentTimeMillis()));
	demande.setFlagFermetureRemise(true);
	demande.store();
	
	String sTitle = "Fermeture de votre dossier";	
	String sMessTitle = "";
	String sMess = "";
	String sUrlIcone ="";

	sUrlIcone = modula.graphic.Icone.ICONE_SUCCES;
	sMessTitle = "Succès de la fermeture de votre dossier";
	sMess ="Votre dossier a bien &eacute;t&eacute; ferm&eacute;, vous ne pouvez donc plus le modifier.<br />"+
		"Un email de confirmation vous a &eacute;t&eacute; envoy&eacute;"
		+"ainsi qu'au secr&eacute;taire de la commission afin de notifier cette"
		+"fermeture.<br /><br />"
		+ "<input onclick=javascript:RedirectURL('"
		+ response.encodeURL(rootPath + sPublisherPath
		+ "/private/candidat/consulterDossier.jsp?iIdOnglet=2&amp;cand="
		+ SecureString.getSessionSecureString(Long.toString(EnveloppeA.getEnveloppeA(demande.getIdEnveloppe()).getIdCandidature()),session) )
		+"') type='button' value='Retour au dossier'/>";

	session.setAttribute("sessionPageTitre", sTitle);
	session.setAttribute("sessionMessageTitre", sMessTitle);
	session.setAttribute("sessionMessageLibelle", sMess);
	session.setAttribute("sessionMessageUrlIcone", sUrlIcone);

	response.sendRedirect( response.encodeURL(rootPath + "include/afficherMessagePublisher.jsp")  );		
%>