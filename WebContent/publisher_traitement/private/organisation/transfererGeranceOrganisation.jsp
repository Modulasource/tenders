
<%@ page import="java.sql.*,modula.configuration.*,org.coin.util.*,org.coin.db.*,org.coin.security.*,java.net.*,javax.naming.*,javax.mail.*,org.coin.fr.bean.*,modula.*,org.coin.bean.*,org.coin.fr.bean.mail.*, java.util.*" %>
<%@ include file="../../../publisher_traitement/public/include/beanSessionUser.jspf" %>
<%@ include file="../../../publisher_traitement/public/include/beanCandidat.jspf" %> 
<%@ include file="../../../include/publisherType.jspf" %> 
<%
	String sTitle = "Transférer la gérance de l'organisation";
	String rootPath = request.getContextPath()+"/";
	String sFormPrefix = "";
	String sMessTitle = "";
	String sMess = "";
	String sUrlIcone = "";	
	
	
	PersonnePhysique ppNouveauGerant = null;
	if (organisation.getIdCreateur() == candidat.getIdPersonnePhysique()){
		try 
		{
			String sGerant = request.getParameter("choixMembre");
			ppNouveauGerant = PersonnePhysique.getPersonnePhysique(Integer.parseInt(
                    SecureString.getSessionPlainString(
                            sGerant,session)));
			organisation.setIdCreateur((int)ppNouveauGerant.getId());
            organisation.store();
		} 
		catch (Exception e) 
		{
			ppNouveauGerant = null;
		}
	}
	else{
		ppNouveauGerant = null;
	}
	
	if(ppNouveauGerant == null){
		sMessTitle = "Problème lors du transfert de la gérance";
		sMess = "<br />"
				+ "Un problème est survenu durant la procédure de transfert de gérance de votre entreprise.<br /><br />"
				+ "<a href='"+ response.encodeURL(rootPath + sPublisherPath + "/private/organisation/afficherOrganisattion.jsp")+"'>Retour au profil de votre entreprise</a>";
		sUrlIcone = modula.graphic.Icone.ICONE_ERROR;
		
		session.setAttribute("sessionPageTitre", sTitle);
		session.setAttribute("sessionMessageTitre", sMessTitle);
		session.setAttribute("sessionMessageLibelle", sMess);
		session.setAttribute("sessionMessageUrlIcone", sUrlIcone);
		
		response.sendRedirect( response.encodeURL(rootPath + "include/afficherMessagePublisher.jsp")  );
		return;
	}
	
	sMessTitle = "Succès du transfert de gérance";
	sMess = "La personne physique d&eacute;finie ("+ppNouveauGerant.getCivilitePrenomNom()+
	") devient gérant de l'entreprise "+ organisation.getRaisonSociale()+".<br /><br />"+
	"<a href='"+ response.encodeURL(rootPath + sPublisherPath + "/private/organisation/afficherOrganisation.jsp")+"'>Retour au profil de votre entreprise</a>";
	sUrlIcone = modula.graphic.Icone.ICONE_SUCCES;	

	session.setAttribute("sessionPageTitre", sTitle);
	session.setAttribute("sessionMessageTitre", sMessTitle);
	session.setAttribute("sessionMessageLibelle", sMess);
	session.setAttribute("sessionMessageUrlIcone", sUrlIcone);
	
	response.sendRedirect( response.encodeURL(rootPath + "include/afficherMessagePublisher.jsp")  );
%>