
<%@ page import="modula.marche.*,modula.algorithme.*, org.coin.util.*" %>
<%@ include file="/include/beanSessionUser.jspf" %>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);

	String rootPath = request.getContextPath()+"/";
	String sTitle = "Retrait de la petite annonce";
	String sMessTitle = "";
	String sMess = "";
	String sUrlIcone = "";
	String sUrlRedirect = "";
	marche.setLectureSeule(false);
	marche.setAffaireValidee(false);
	marche.setAffaireEnvoyeePublisher(false);
	marche.setAffairePublieeSurPublisher(false);
	marche.setAAPCEnLigne(false);
	marche.setAATREnLigne(false);
	marche.store();

	sMessTitle = "Succ&egrave;s de l'&eacute;tape";
	sMess = "Votre petite annonce a été retirée du site Internet.";
	sUrlIcone = modula.graphic.Icone.ICONE_SUCCES;
	sUrlRedirect = rootPath+"desk/marche/petitesAnnonces/afficherToutesPetitesAnnonces.jsp";
	
	session.setAttribute("sessionPageTitre", sTitle);
	session.setAttribute("sessionMessageTitre", sMessTitle);
	session.setAttribute("sessionMessageLibelle", sMess);
	session.setAttribute("sessionMessageUrlIcone", sUrlIcone);
	session.setAttribute("sessionMessageUrlRedirect", sUrlRedirect);
	response.sendRedirect(response.encodeRedirectURL(rootPath+"include/afficherMessageDesk.jsp"));
	
%>
