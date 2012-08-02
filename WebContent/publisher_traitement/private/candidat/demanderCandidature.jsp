<%@page import="modula.graphic.Icone"%>
<%@ include file="../../../include/new_style/headerPublisher.jspf" %>
<%@ page import="java.util.*,modula.algorithme.*,org.coin.fr.bean.*,org.coin.bean.*,modula.marche.*" %>
<%@ page import="modula.candidature.*" %> 
<%@ include file="../../../publisher_traitement/public/include/beanCandidat.jspf" %> 
<%
	String sTitle = "Se porter candidat";

	int iIdMarche = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdMarche);
	

	String sMessTitle = "Vous avez demandé à candidater";
	String sUrlIcone = rootPath+modula.graphic.Icone.ICONE_SUCCES;	
	String sMess = "Vous pouvez retirer le DCE en cliquant dans la rubrique 'Mes dossiers', sur l'affaire concernée";
	PersonnePhysique personne = PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual());
		
	
	if (!Candidature.isDoublonCandidature(
			personne.getIdPersonnePhysique(), 
			personne.getIdOrganisation(), 
			marche.getIdMarche()))
	{
	    
		String sGroup = UserConstant.USER_GROUP_NAME_GESTIONNAIRE_CARNET_ADRESSES;
		Vector vGestionnairesCarnetAdresses = UserGroup.getAllUser(sGroup);
        
	    Candidature candidature = Candidature.createNewCandidature(
        		marche,
        		candidat.getIdPersonnePhysique(),
        		organisation.getIdOrganisation());

		int iNbCandidatures = 0;
		try{
			iNbCandidatures = (Integer)session.getAttribute("iNbCandidatures");
		} catch (Exception e) {}
		session.setAttribute("iNbCandidatures",(iNbCandidatures+1));

		String sCand = SecureString.getSessionSecureString(Long.toString(candidature.getIdCandidature()),session);
		
		String sUrlRedir
		  = rootPath + "publisher_portail/private/candidat/consulterDossier.jsp?cand="
		   + sCand+"&iIdOnglet=1" ;
		    
		response.sendRedirect(
			response.encodeRedirectURL(sUrlRedir) );
	
		return;
	}
 	// La candidature demandée est un doublon
	sMess = "Votre demande de retrait du DCE ne peut être satisfaite pour deux raisons possibles :"
			+ "<ul><li>Vous avez déjà fait une demande de retrait et elle est en cours de traitement."
			+ " Veuillez vérifier vos dossiers en cours.</li>"
			+ "<li>Une personne de votre entreprise a déjà entamé une demande de candidature."
			+ " Une double candidature pour une même entreprise n'est pas admise.</li></ul>";
	sUrlIcone = Icone.ICONE_ERROR;

	session.setAttribute("sessionPageTitre", sTitle);
	session.setAttribute("sessionMessageTitre", sMessTitle);
	session.setAttribute("sessionMessageLibelle", sMess);
	session.setAttribute("sessionMessageUrlIcone", sUrlIcone);

	response.sendRedirect( response.encodeURL(rootPath + "include/afficherMessagePublisher.jsp")  );		
%>
