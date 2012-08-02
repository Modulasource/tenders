
<%@page import="org.coin.bean.ws.AddressBookWebService"%>
<%@page import="org.coin.mail.mailtype.MailUser"%><%@page import="org.coin.bean.ws.OrganisationWebService"%>
<%@page import="org.coin.bean.ws.PersonnePhysiqueWebService"%>
<%@page import="org.coin.bean.conf.Configuration"%>

<%@ page import="java.sql.*,modula.configuration.*,org.coin.util.*,org.coin.db.*,org.coin.security.*,java.net.*,javax.naming.*,javax.mail.*,org.coin.fr.bean.*,modula.*,org.coin.bean.*,org.coin.fr.bean.mail.*, java.util.*" %>
<%@ page import="mt.modula.bean.mail.*,org.coin.mail.*" %> 
<%@ include file="/publisher_traitement/public/include/beanSessionUser.jspf" %>
<%@ include file="/publisher_traitement/public/include/beanCandidat.jspf" %> 
<%@ include file="/include/publisherType.jspf" %> 
<%
	String sTitle ="Ajout d'une personne à l'organisation "+organisation.getRaisonSociale();
	String rootPath = request.getContextPath()+"/";
	String sFormPrefix = "";
	String sMessTitle = "";
	String sMess = "";
	String sUrlIcone = "";	
	
	PersonnePhysique personne = null;
	Adresse adresse = null;
	String mdp = "";
	User user = null;
    Connection conn = ConnectionManager.getConnection();
	
	try
	{
		personne = new PersonnePhysique();
		personne.setFromForm(request, sFormPrefix);
		personne.setIdOrganisation(organisation.getIdOrganisation());
		
		adresse = new Adresse();
		adresse.setFromForm(request, sFormPrefix);
		adresse.create(conn);
		
		personne.setIdAdresse(adresse.getIdAdresse());
		personne.create(conn);
		
		//COMPTE UTILISATEUR
		mdp = Password.calcPassword(8, org.coin.security.Password.CHARSET_NUM + org.coin.security.Password.CHARSET_TINY);
		user = new User(personne.getEmail(),
						MD5.getEncodedString(mdp),
						UserType.TYPE_CANDIDAT,
						UserStatus.EN_ATTENTE_DE_VALIDATION,
						personne.getIdPersonnePhysique()
						,"");
		user.create(conn);
		user.setKey(Password.computeCryptogramMD5(Integer.toString(user.getIdUser())));
		user.store(conn);
	
		
		
		/**
	     * Web Service
	     */
	    if(AddressBookWebService.isActivated(conn))
	    {
	        try{
	        	OrganisationWebService wsOrga = AddressBookWebService.newInstanceOrganisationWebService(conn);
                PersonnePhysiqueWebService wsPP = AddressBookWebService.newInstancePersonnePhysiqueWebService(conn);
	            if(wsOrga.isSynchronized(organisation,conn))
	            {
	            	/**
	            	 * TODO why not the user bean ??
	            	 */
	                wsPP.synchroCreate(personne, organisation, /*user,*/ conn);
	            }
	        } catch(Exception e ) {
	            e.printStackTrace();                    
	        }
	    }
		
	}
	catch(Exception e)
	{
		if(personne != null)
			personne.removeWithObjectAttached();

		sMessTitle = "Problème lors de l'ajout de la personne";
		sMess = "<br />"
				+ "Un problème est survenu durant la procédure d'ajout d'une personne à votre entreprise.<br /><br />"
				+ "<a href='"+ response.encodeURL(rootPath + sPublisherPath + "/private/organisation/afficherOrganisattion.jsp?iIdOnglet="+modula.graphic.Onglet.ONGLET_ORGANISATION_PERSONNES)+"'>Retour au profil de votre entreprise</a>";
		sUrlIcone = modula.graphic.Icone.ICONE_ERROR;
		
		session.setAttribute("sessionPageTitre", sTitle);
		session.setAttribute("sessionMessageTitre", sMessTitle);
		session.setAttribute("sessionMessageLibelle", sMess);
		session.setAttribute("sessionMessageUrlIcone", sUrlIcone);
		
	    ConnectionManager.closeConnection(conn);
		response.sendRedirect( response.encodeURL(rootPath + "include/afficherMessagePublisher.jsp")  );
		return;
	}
	
	Courrier courrier = MailUser.newCourrierInscriptionUser(
			personne, 
			organisation, 
			user,
			"create",
			request,
			conn);
	
	MailModula mail = new MailModula();
	mail.computeFromCourrier(courrier);
	if(mail.send()){
		courrier.setSend(true);
		courrier.setDateEnvoiEffectif(new Timestamp(System.currentTimeMillis()));
		courrier.store();
	}
			
	sMessTitle = "Succès de l'ajout de "+personne.getCivilitePrenomNom();
	sMess = "La personne physique d&eacute;finie ("+personne.getCivilitePrenomNom()+
	") devient membre de l'entreprise "+ organisation.getRaisonSociale()+".<br />"+
	"Un email vient d'être adressé à cette personne afin de valider son compte utilisateur.<br /><br />"+
	"<a href='"+ response.encodeURL(rootPath + sPublisherPath + "/private/organisation/afficherOrganisation.jsp?iIdOnglet="+modula.graphic.Onglet.ONGLET_ORGANISATION_PERSONNES)+"'>Retour au profil de votre entreprise</a>";
	sUrlIcone = modula.graphic.Icone.ICONE_SUCCES;	

	session.setAttribute("sessionPageTitre", sTitle);
	session.setAttribute("sessionMessageTitre", sMessTitle);
	session.setAttribute("sessionMessageLibelle", sMess);
	session.setAttribute("sessionMessageUrlIcone", sUrlIcone);
	
    ConnectionManager.closeConnection(conn);
	response.sendRedirect( response.encodeURL(rootPath + "include/afficherMessagePublisher.jsp")  );
%>