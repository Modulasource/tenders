
<%@page import="org.coin.bean.ws.AddressBookWebService"%><%@page import="org.coin.bean.ws.PersonnePhysiqueWebService"%>
<%@page import="modula.graphic.Icone"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.mail.mailtype.MailUser"%>
<%@page import="org.coin.mail.Courrier"%>
<%@page import="org.coin.db.CoinDatabaseLoadException"%>
<%@ page import="org.coin.fr.bean.*,org.coin.bean.*, org.coin.fr.bean.mail.*" %>
<%@ page import="mt.modula.bean.mail.*" %>
<%@ include file="/publisher_traitement/public/include/beanSessionUser.jspf" %>
<%@ include file="/publisher_traitement/public/include/beanCandidat.jspf" %> 
<%@ include file="/include/publisherType.jspf" %>
<%
	String rootPath = request.getContextPath()+"/";
	String sPageUseCaseId = "IHM-PUBLI-3";	
	
	boolean bEnvoiMail = false;
	boolean bCompteCandidat = true;
	String sMailPersonne = request.getParameter("sMailPersonne");

    User user = null;
    try {
        user = User.getUserFromLogin(sMailPersonne);
    }catch (CoinDatabaseLoadException e) {
    }
    Connection conn = ConnectionManager.getConnection();

    
	if (user != null)
	{
		try{
			
			if( user.getIdUserType() != UserType.TYPE_CANDIDAT)
			{
				bCompteCandidat = false;
				throw new Exception("Le mot de passe ne peut être changé que pour un compte candidat");
			}
			
			bCompteCandidat = true;
			String newMdp = Password.calcPassword(8, Password.CHARSET_NUM +Password.CHARSET_TINY);
			PersonnePhysique personne = PersonnePhysique.getPersonnePhysique(user.getIdIndividual(), false, conn);
			user.sNewPassword = newMdp;
			user.setPassword(MD5.getEncodedString(newMdp));
			
			/* on force le passage du compte en valide */
			user.setIdUserStatus(UserStatus.VALIDE);
			
			user.store();
			
			/**
	         * Web Service
	         */
	        if(AddressBookWebService.isActivated(conn))
	        {
	            try{
	                PersonnePhysiqueWebService wsPP = AddressBookWebService.newInstancePersonnePhysiqueWebService(conn);
	                if(wsPP.isSynchronized(personne,conn))
	                {
	                    wsPP.synchroStore(personne, organisation, user, conn);
	                }
	            } catch(Exception e ) {
	                e.printStackTrace();                    
	            }
	        }
			
			//MAIL

		    Courrier courrier = MailUser.prepareMailNewPassword(
		            MailConstant.MAIL_PUBLISHER_NEW_MDP,
		            personne, 
		            newMdp, 
		            PersonnePhysique.getPersonnePhysique(
		            		User.getUser( User.ID_CRON_USER).getIdIndividual(), false, conn),
		            PersonnePhysiqueCivilite.getAllStatic(false, conn),  
		            false,
		            conn);


		    MailModula mail = new MailModula();
		    
		    if (courrier.send(mail,conn)) bEnvoiMail = true;
            
			
			
			
			
		} catch(Exception e){
			bEnvoiMail = false;
		}
	}
	   
    ConnectionManager.closeConnection(conn);

	String sTitle = "Envoi du mot de passe";
	String sMessTitle = "Envoi du mot de passe";
	String sMess="";
	String sUrlIcone = "";
	if (bEnvoiMail)
	{
		sUrlIcone = Icone.ICONE_SUCCES;
		sMess = "Votre mot de passe a &eacute;t&eacute; modifi&eacute;.<br />"+
						"Vous allez recevoir un email contenant votre nouveau mot de passe.<br /><br />";
	}
	else{
		sUrlIcone = Icone.ICONE_ERROR;
		sMess = "Votre mot de passe n'a pu &ecirc;tre modifi&eacute; ou envoy&eacute;.<br />"
			+ "Nous vous conseillons de recommencer la procédure.<br /><br />"
			+ (bCompteCandidat?"":"Ce compte n'est pas un compte candidat. Veuillez contacter la hotline pour plus d'information.<br/><br/>")
			+ "<a href='" + response.encodeURL (rootPath+"publisher_portail/public/oublierMDPForm.jsp")
				+ "' >Retour au formulaire</a>";
	}

	session.setAttribute("sessionPageTitre", sTitle);
	session.setAttribute("sessionMessageTitre", "");
	session.setAttribute("sessionMessageLibelle", sMess);
	session.setAttribute("sessionMessageUrlIcone", sUrlIcone);

	response.sendRedirect( response.encodeURL(rootPath + "include/afficherMessagePublisher.jsp")  );		

%>