
<%@page import="modula.marche.Marche"%><%@page import="modula.graphic.Icone"%>

<%@ include file="/include/beanSessionUser.jspf" %>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);

	String rootPath = request.getContextPath()+"/";
	String sTitle = "Validation de la petite annonce";
	String sMessTitle = "";
	String sMess = "";
	String sUrlIcone = "";
	String sUrlRedirect = "";
	marche.setLectureSeule(true);
	marche.setAffaireValidee(true);
	marche.setAffaireEnvoyeePublisher(true);
	marche.store();

	sMessTitle = "Succès de l'étape";
	sMess = "Votre petite annonce a été validée.<br />"
	 + "Celle-ci sera visible sur le site Internet dès la date de publication.";
	sUrlIcone = Icone.ICONE_SUCCES;
	sUrlRedirect = rootPath+"desk/marche/petitesAnnonces/afficherToutesPetitesAnnonces.jsp";
	
	session.setAttribute("sessionPageTitre", sTitle);
	session.setAttribute("sessionMessageTitre", sMessTitle);
	session.setAttribute("sessionMessageLibelle", sMess);
	session.setAttribute("sessionMessageUrlIcone", sUrlIcone);
	session.setAttribute("sessionMessageUrlRedirect", sUrlRedirect);
	response.sendRedirect(response.encodeRedirectURL(rootPath+"include/afficherMessageDesk.jsp"));
%>
