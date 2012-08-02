
<%@page import="mt.common.addressbook.AddressBookOwner"%><%@page import="mt.common.addressbook.habilitation.AddressBookHabilitation"%>
<%@page import="org.coin.bean.ws.AddressBookWebService"%>
<%@page import="org.coin.bean.ws.ConfigurationWebService"%>
<%@page import="org.coin.bean.ws.OrganisationWebService"%>
<%@page import="org.coin.bean.ws.PersonnePhysiqueWebService"%>
<%@page import="org.coin.bean.pki.certificate.PkiCertificate"%>
<%@page import="org.coin.bean.pki.certificate.PkiCertificateGenerator"%>
<%@page import="org.coin.localization.Language"%>
<%@page import="java.sql.Connection"%>
<%@page import="modula.journal.Evenement"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="org.coin.mail.mailtype.MailUser"%>
<%@ page import="org.coin.security.*,org.coin.fr.bean.mail.*,org.coin.util.*,org.coin.fr.bean.*,modula.*,modula.graphic.*,org.coin.bean.*" %>
<%@ page import="mt.modula.bean.mail.*,org.coin.mail.*" %> 
<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@ include file="pave/localizationObject.jspf" %>
<%
	int iIdPersonne = Integer.parseInt(request.getParameter("iIdPersonnePhysique"));
	String sFormPrefix = "";
    Connection conn = ConnectionManager.getConnection();
    
	boolean bLinkEmailAndLogin = Configuration.isEnabledMemory("individual.email.link.logon", true);
	
	int iIdOnglet = HttpUtil.parseInt("iIdOnglet", request, 0) ;
	PersonnePhysique personne = PersonnePhysique.getPersonnePhysique(iIdPersonne);
	Organisation organisation = Organisation.getOrganisation(personne.getIdOrganisation());
	
	String sMessage = "";
	

	boolean bUserDesk = OrganisationTypeModula.isUserDesk(organisation);
	boolean bGroupAdminData = false; 
    boolean bGroupPersoData = false;

    String sLocalizedMessageEmailModificationSuccesfull = locMessage.getValue(34,"Changement de mail effectué avec succès");
    String sLocalizedMessageEmailSentToValidateAccount = " - "+ locMessage.getValue(35,"un mail a été envoyé pour valider le compte utilisateur");
    String sLocalizedMessagePasswordModificationSuccesfull  = locMessage.getValue(36,"Mot de passe mis à jour avec succès - un mail a été envoyé");
    String sLocalizedMessagePasswordModificationFailed  = locMessage.getValue(37,"Mot de passe non mis à jour - l'ancien mot de passe saisi est incorrect");
    String sLocalizedMessageLoginModificationSuccesfull = locMessage.getValue(38,"Changement de login effectué avec succès");
    String sLocalizedMessageLoginNotUpdated = locMessage.getValue(39,"Changement de login non effectué");
    String sLocalizedMessageAccountCreated = locMessage.getValue(40,"Compte Utilisateur créé avec succès");
    
    /**
     * Habilitations
     */
    PersonnePhysique personActor = PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual());
    String sPageUseCaseId = AddressBookHabilitation.getUseCaseForModifyIndividual(personne, organisation, personActor);
    String sCreateAccountUseCaseId = AddressBookHabilitation.getUseCaseForCreateUserAccount(organisation, personActor);
    String sModifyAccountUseCaseId = AddressBookHabilitation.getUseCaseForModifyUserAccount(organisation, personActor);
    
	switch(organisation.getIdOrganisationType() )
    {
    case OrganisationType.TYPE_BUSINESS_UNIT :
        bGroupPersoData = true;
        bGroupAdminData = true;
        break;
    case OrganisationType.TYPE_CLIENT:
        bGroupPersoData = true;
        bGroupAdminData = true;
        break;
    case OrganisationType.TYPE_TRAIN_CUSTOMER:
        bGroupPersoData = true;
        bGroupAdminData = true;
        break;
    case OrganisationType.TYPE_FOURNISSEUR:
        bGroupPersoData = true;
        bGroupAdminData = true;
        break;
    case OrganisationType.TYPE_HEAD_QUARTER:
        sModifyAccountUseCaseId = "IHM-DESK-PERS-HQ-11";
        bGroupPersoData = true;
        bGroupAdminData = true;
        break;
    }

	sessionUserHabilitation.isHabilitateException(sPageUseCaseId, conn);

	


	if( iIdOnglet == Onglet.ONGLET_PERSONNE_PHYSIQUE_DONNEES_ADMINISTRATIVES)
	{
		if(request.getParameter("sEmail") != null 
		&& !request.getParameter("sEmail").equalsIgnoreCase(personne.getEmail()))
		{
			String sEmail = request.getParameter("sEmail");
			User user = null;
			try{user = User.getUserFromIdIndividual(personne.getIdPersonnePhysique());}
			catch(Exception e)
			{
				personne.setEmail(sEmail);
			}
			
			try {
				if(user != null)
				{
					sMessage = sLocalizedMessageEmailModificationSuccesfull;
					
					// change uniquement si la table de configuration accepte le lien entre login et email
					// vrai par défaut

					if(bLinkEmailAndLogin )
					{
						if(user.getIdUserStatus() == UserStatus.VALIDE 
								|| user.getIdUserStatus() == UserStatus.EN_ATTENTE_DE_VALIDATION)
									sMessage += sLocalizedMessageEmailSentToValidateAccount;
						
						user.setAbstractBeanLocalization(sessionLanguage);	
						user.changeLoginFromForm(request,response,sEmail,MailConstant.MAIL_PUBLISHER_CHANGEMENT_LOGIN,new MailModula());
					}
					personne.load(conn);
				}
			}
			catch(Exception e){sMessage = e.getMessage();}
		}
		
		personne.setFromFormWithoutEmail(request, "");
		if(!bLinkEmailAndLogin )
			personne.setEmail(request.getParameter("sEmail"));
		personne.store(conn);
		
		if(bGroupPersoData)
            iIdOnglet = Onglet.ONGLET_PERSONNE_PHYSIQUE_ADRESSE;
	}
				
	if( iIdOnglet == Onglet.ONGLET_PERSONNE_PHYSIQUE_ADRESSE)
	{
		Adresse adresse = Adresse.getAdresse(personne.getIdAdresse(), true, conn);
		adresse.setFromForm(request, "");
		adresse.store(conn);
		
		if(bGroupPersoData)
            iIdOnglet = Onglet.ONGLET_PERSONNE_PHYSIQUE_DONNEES_ADMINISTRATIVES;
	}
	
	if( iIdOnglet == Onglet.ONGLET_PERSONNE_PHYSIQUE_CERTIFICATS)
	{
		String sAction = HttpUtil.parseStringBlank("sAction", request);
		if (sAction.equals("createCertificateAuto"))
		{
			long lIdDN = HttpUtil.parseLong("lIdPkiCertificateDnIssuer", request);
			
			try{
	            PkiCertificate pkiCertificate = PkiCertificateGenerator.generateCertificateFromPersonne(
	                    personne.getId(), 
	                    lIdDN, 
	                    conn);
			} catch(Exception e) {
				sMessage = e.getMessage();
			} 
		}
		
	}

	User user = null;
	if( iIdOnglet == Onglet.ONGLET_PERSONNE_PHYSIQUE_COMPTE_UTILISATEUR)
	{
		int iAlertMail = HttpUtil.parseInt(sFormPrefix+"alertMail", request, -1);
		if(iAlertMail ==1) personne.setAlerteMail(true); 
		else personne.setAlerteMail(false);
		personne.store(conn);
		try{user = User.getUserFromIdIndividual(personne.getIdPersonnePhysique());}
		catch(Exception e){}
		
		if(user != null)
		{
			user.setDateExpiration(
					CalendarUtil.getConversionTimestampDateOptional(
							request.getParameter("tsDateExpirationDate")));
			
			user.setIdCoinUserAccessModuleType(HttpUtil.parseLong("lIdCoinUserAccessModuleType", request, 0));
			user.store(conn);
			
			if(user.getIdUserStatus() == UserStatus.VALIDE)
			{
				String ancien = HttpUtil.parseStringBlank("ancien",request);
				String newMdp1 = HttpUtil.parseStringBlank("newMdp1",request);
				String newMdp2 = HttpUtil.parseStringBlank("newMdp2",request);
				
				boolean bEnableChangingPassword = false;
				// contrôles avant modif
				if (!ancien.equalsIgnoreCase("")
				&& !newMdp1.equalsIgnoreCase("")
				&& !newMdp2.equalsIgnoreCase("")
				&& MD5.getEncodedString(ancien).equals(user.getPassword()))
				{
					bEnableChangingPassword = true;
				}
				
				if(!sessionUserHabilitation.isSuperUser()
				&& !MD5.getEncodedString(ancien).equals(user.getPassword())){
					sMessage = sLocalizedMessagePasswordModificationFailed;
				}
				
				// pas de question à se poser pour le superuser
				if(sessionUserHabilitation.isSuperUser() 
				&& !newMdp1.equalsIgnoreCase("")
				&& !newMdp2.equalsIgnoreCase(""))
				{
					bEnableChangingPassword = true;
				}
				
				if (bEnableChangingPassword )
				{
					if (newMdp1.equals(newMdp2))
					{
						user.sNewPassword = newMdp1;
						
						String mdp = MD5.getEncodedString(newMdp1);
						user.setPassword(mdp);
						user.store(conn);
						
						//MAIL
						PersonnePhysique personneLoguee 
							= PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual());
					
						Courrier courrier = MailUser.prepareMailNewPassword(
							MailConstant.MAIL_PUBLISHER_CHANGEMENT_MDP,
							personne, 
							newMdp1, 
							personneLoguee, 
							bUserDesk,
							conn);
				
					
						MailModula mail = new MailModula();
						courrier.setTo(personne.getEmail());
						courrier.send(mail,conn);
						
						sMessage = sLocalizedMessagePasswordModificationSuccesfull;
					}
				}
			}
			
			if(request.getParameter("sLogin") != null && !request.getParameter("sLogin").equalsIgnoreCase(user.getLogin()))
			{
				String sEmail = request.getParameter("sLogin");
				try
				{
					try
					{
						sMessage = sLocalizedMessageLoginModificationSuccesfull;
						if(user.getIdUserStatus() == UserStatus.VALIDE
						|| user.getIdUserStatus() == UserStatus.EN_ATTENTE_DE_VALIDATION)
							sMessage += sLocalizedMessageEmailSentToValidateAccount;
						
						user.sNewLogin = sEmail;
						user.changeLoginFromForm(request,
								response,
								sEmail,
								MailConstant.MAIL_PUBLISHER_CHANGEMENT_LOGIN,
								new MailModula());
						
					}
					catch(Exception e){sMessage = e.getMessage();}
				}
				catch(Exception e){sMessage = sLocalizedMessageLoginNotUpdated;}
			}
			
			try
			{
				if(sessionUserHabilitation.isHabilitate(sModifyAccountUseCaseId)
				&& request.getParameter("iIdUserStatus") != null 
				&& Integer.parseInt(request.getParameter("iIdUserStatus")) != user.getIdUserStatus())
				{
					user.setIdUserStatus(Integer.parseInt(request.getParameter("iIdUserStatus")));
					user.store(conn);
				}
			}
			catch(Exception e){}
		}
		else
		{
			/**
			 * Ici on crée nouveau compte
			*/
			int iCreateUser = -1;
			if(request.getParameter(sFormPrefix+"createUser") != null)
				iCreateUser = Integer.parseInt(request.getParameter(sFormPrefix+"createUser"));

			if(iCreateUser == 1)
			{		
				
				//COMPTE UTILISATEUR
				//String mdp = Password.calcPassword(8,Password.CHARSET_NUM + Password.CHARSET_TINY);
				String mdp = Password.getSyllabicPassword(2, 2);
				user = new User(personne.getEmail(),
								MD5.getEncodedString(mdp),
								UserType.getIdUserTypeFromOrganisationType(organisation.getIdOrganisationType()),
								UserStatus.INVALIDE,
								personne.getIdPersonnePhysique()
								,"");
				user.create(conn);
				Evenement.addEvenementPersonnePhysiqueOptional(sCreateAccountUseCaseId, sessionUser.getIdUser() ,personne, organisation );
				
				
				sMessage = sLocalizedMessageAccountCreated;
				
				int iActivateUser = HttpUtil.parseInt("activateUser", request, -1) ;
				if(iActivateUser == 1)
				{
					user.setIdUserStatus(UserStatus.EN_ATTENTE_DE_VALIDATION);
					user.setKey(Password.computeCryptogramMD5(Integer.toString(user.getIdUser())));
					user.store(conn);
					
					String sInstanceURL = HttpUtil.getUrlWithProtocolAndPortToExternalForm(request.getContextPath(), request);

					PersonnePhysique personneLoguee = PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual(), false, conn);
					Courrier courrier = MailUser.prepareMailActivationUser(
							MailConstant.MAIL_DESK_INSCRIPTION_PERSONNE,
							MailConstant.MAIL_DESK_INSCRIPTION_PERSONNE,
							"",
							personne, 
							user,
							personneLoguee, 
							OrganisationTypeModula.isUserDesk(organisation),
							sInstanceURL,
							conn);
					
					MailModula mail = new MailModula();
					courrier.send(mail,conn);
					
					sMessage += sLocalizedMessageEmailSentToValidateAccount;
				}
			}
		}
	}
	
	
	
 	if( iIdOnglet == Onglet.ONGLET_PERSONNE_PHYSIQUE_OWNER)
	{
		long own_lIdObjectTypeOwned = HttpUtil.parseLong("own_lIdObjectTypeOwned", request);
		long own_lIdObjectReferenceOwned = HttpUtil.parseLong("own_lIdObjectReferenceOwned", request);
		
		AddressBookOwner.linkObject(
				own_lIdObjectTypeOwned, 
				own_lIdObjectReferenceOwned,
				personne,
				conn);
	}
 	
 	if( iIdOnglet == Onglet.ONGLET_PERSONNE_PHYSIQUE_AUTO_RELOAD)
 	{
 		String sReloadValue = request.getParameter("cbAutoReloadInverval");
 		
 		long lReloadValue = Long.parseLong(sReloadValue);
 		
 		if(lReloadValue>0)
 		{
 			PersonnePhysiqueParametre.updateValue (
 					(long)iIdPersonne,
 					PersonnePhysiqueParametre.PARAM_AUTO_RELOAD,
 					sReloadValue,
 					conn);
 		}
 		else
 		{
 			try{
 				PersonnePhysiqueParametre param = 
 	 				PersonnePhysiqueParametre.getPersonnePhysiqueParametre(
 	 						(long)iIdPersonne, 
 	 						PersonnePhysiqueParametre.PARAM_AUTO_RELOAD,
 	 						conn);
 	 			
 	 			param.remove(conn);
 			}
 			catch(Exception e){}
 		}
 		
 	}
	
	/**
     * Web Service
     */
    if(AddressBookWebService.isActivated(conn))
    {
	    try{
	        PersonnePhysiqueWebService wsPP = AddressBookWebService.newInstancePersonnePhysiqueWebService(conn);
	        if(wsPP.isSynchronized(personne, conn)){
	        	wsPP.synchroStore(personne, organisation, user, conn);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
    }	

	/**
	 * log event
	 */
	Evenement.addEvenementPersonnePhysiqueOptional(sPageUseCaseId, sessionUser.getIdUser() ,personne, organisation );

	response.sendRedirect(
		response.encodeRedirectURL(
			"afficherPersonnePhysique.jsp?iIdPersonnePhysique=" + iIdPersonne
			+ "&iIdOnglet="+ iIdOnglet
			+ "&sMessage=" + sMessage
			+ "&nonce=" + System.currentTimeMillis() ));

    ConnectionManager.closeConnection(conn);

%>