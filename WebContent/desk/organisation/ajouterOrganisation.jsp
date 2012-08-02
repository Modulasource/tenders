<%@page import="modula.journal.Evenement"%>
<%@page import="org.coin.fr.bean.mail.MailConstant"%>
<%@page import="mt.modula.bean.mail.MailModula"%>
<%@page import="org.coin.security.Password"%>
<%@page import="org.coin.bean.UserStatus"%>
<%@page import="org.coin.bean.UserType"%>
<%@page import="org.coin.security.MD5"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.fr.bean.OrganisationType"%>
<%@page import="org.coin.bean.User"%>
<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%@page import="org.coin.fr.bean.Adresse"%>
<%@page import="org.coin.fr.bean.Organisation"%>
<%@page import="java.sql.Connection"%>
<%@page import="mt.common.addressbook.AddressBookException"%>
<%@page import="org.coin.db.CoinDatabaseException"%>
<%@page import="org.coin.bean.pki.certificate.PkiCertificateGenerator"%>
<%@page import="org.coin.bean.pki.certificate.PkiCertificate"%>
<%@page import="org.coin.bean.pki.PkiConstant"%>
<%@page import="mt.common.addressbook.habilitation.AddressBookHabilitation"%>
<%@page import="org.coin.bean.ws.AddressBookWebService"%>
<%@page import="org.coin.bean.ws.ConfigurationWebService"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="org.coin.bean.ws.PersonnePhysiqueWebService"%>
<%@page import="modula.commission.Commission"%>
<%@page import="org.coin.bean.ws.OrganisationWebService"%>
<%@page import="org.coin.bean.conf.Configuration"%>
<%@ include file="/desk/include/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath()+"/";
	String sFormPrefix = "";
	String sTitle = "Formulaire d'inscription d'une organisation";

    Connection conn = ConnectionManager.getConnection();

	Organisation organisation = new Organisation();
	Adresse adresseOrganisation = null;
	PersonnePhysique gerant = null;
	Adresse adresseGerant = null;
	String mdp = "";
	User user = null;	
	int iCreateModel = 0;
	
	int iIdOrganisationType = -1;
	if(request.getParameter(sFormPrefix+"iIdOrganisationType") != null){
		iIdOrganisationType = Integer.parseInt(request.getParameter(sFormPrefix+"iIdOrganisationType"));
		organisation.setIdOrganisationType(iIdOrganisationType);
	}

	
	String sPageUseCaseId =  AddressBookHabilitation.getUseCaseForCreateOrganization(iIdOrganisationType);
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId, conn);

try
{
	int iSynchronize = HttpUtil.parseInt(sFormPrefix+"synchronize",request,0);
	
	//ENTREPRISE
	organisation = new Organisation();
	organisation.setFromFormInscription(request,sFormPrefix);
	organisation.setIdCreateur(sessionUser.getIdIndividual());
	
	switch(iIdOrganisationType){
	case OrganisationType.TYPE_TRAIN_CUSTOMER:
	case OrganisationType.TYPE_CLIENT:
		organisation.setCreateOrganizationCheckDuplicate(false);
		break;
	}
	
	
	adresseOrganisation = new Adresse();
	adresseOrganisation.setFromForm(request,"");
	adresseOrganisation.create(conn);
	
	organisation.setIdAdresse(adresseOrganisation.getIdAdresse());
	organisation.create(conn);
	
	int iCreateGommission = HttpUtil.parseInt(sFormPrefix+"createCommission",request,-1);
    //COMMISSION
    if(iCreateGommission == 1)
    {
    	Commission com = new Commission();
    	com.setIdOrganisation((int)organisation.getId());
    	com.setNom(HttpUtil.parseStringBlank("sCommission",request));
    	com.create(conn);
    }
    
    /** WS SYNCHRO */
    if(iSynchronize==1)
    {
        if(AddressBookWebService.isActivated(conn))
        {
	    	OrganisationWebService wsOrga = AddressBookWebService.newInstanceOrganisationWebService(conn);
	        wsOrga.synchroCreate(organisation, conn);
        }        
    }
    
    
    
    
    
	int iCreateGerant = HttpUtil.parseInt(sFormPrefix+"createGerant",request,-1);
	//GERANT
	if(iCreateGerant == 1)
	{
		gerant = new PersonnePhysique();
		gerant.setFromForm(request, sFormPrefix);
		gerant.setIdOrganisation(organisation.getIdOrganisation());
		
		int iAlertMail = -1; 
		if(request.getParameter(sFormPrefix+"alertMail") != null)
			iAlertMail = Integer.parseInt(request.getParameter(sFormPrefix+"alertMail"));
		if(iAlertMail ==1) gerant.setAlerteMail(true); 
		
		int iCreateUser = -1;
		if(request.getParameter(sFormPrefix+"createUser") != null)
			iCreateUser = Integer.parseInt(request.getParameter(sFormPrefix+"createUser"));
		
		int iCreateUserCertificate = -1;
		if(request.getParameter(sFormPrefix+"createUserCertificate") != null)
			iCreateUserCertificate = Integer.parseInt(request.getParameter(sFormPrefix+"createUserCertificate"));
		
		adresseGerant = new Adresse();
		adresseGerant.create(conn);
		
		gerant.setIdAdresse(adresseGerant.getIdAdresse());
		gerant.create(conn);
		
		organisation.setIdCreateur(gerant.getIdPersonnePhysique());
		organisation.store(conn);
		
		if(iCreateUserCertificate == 1)
		{
			long lIdDN = Configuration.getLongValueMemory(
					"pki.certificate.dn.intermediate", 
					PkiConstant.DN_INTERMEDIATE_PARAPH);
		
            PkiCertificate pkiCertificate = PkiCertificateGenerator.generateCertificateFromPersonne(
            		gerant.getId(), 
                    lIdDN, 
                    conn);
		}
		
		
		if(iCreateUser == 1)
		{
			//COMPTE UTILISATEUR
			//mdp = Password.calcPassword(8,Password.CHARSET_NUM + Password.CHARSET_TINY);
			mdp = Password.getSyllabicPassword(2, 2);
			user = new User(gerant.getEmail(),
							MD5.getEncodedString(mdp),
							UserType.getIdUserTypeFromOrganisationType(organisation.getIdOrganisationType()),
							UserStatus.INVALIDE,
							gerant.getIdPersonnePhysique()
							,"");
			user.create(conn);
			
			int iActivateUser = -1;
			if(request.getParameter(sFormPrefix+"activateUser") != null)
				iActivateUser = Integer.parseInt(request.getParameter(sFormPrefix+"activateUser"));
			
			if(iActivateUser == 1)
			{
				user.setIdUserStatus(UserStatus.EN_ATTENTE_DE_VALIDATION);
				user.setKey(Password.computeCryptogramMD5(Integer.toString(user.getIdUser())));
				user.store(conn);
				
				//MAIL
				MailModula mail = new MailModula();
				User.sendMailActivationUserFromDeskOrganisation(
						user,
						gerant,
						organisation,
						MailConstant.MAIL_DESK_INSCRIPTION_PERSONNE,
						mail,
						request, 
						conn);
				
			}
		}
		
        /**
         * Web Service
         */
		if(iSynchronize == 1)
		{
		     if(AddressBookWebService.isActivated(conn))
		     {
			    try{
			        PersonnePhysiqueWebService wsPP = AddressBookWebService.newInstancePersonnePhysiqueWebService(conn);
			        wsPP.synchroCreate(gerant, organisation, conn);
			    } catch (Exception e) {
			        e.printStackTrace();
			    }
		     }

		}
	}
	
	try { Evenement.addEvenement(organisation.getIdOrganisation(), sPageUseCaseId, sessionUser.getIdUser(), "" );	}
	catch(Exception e){}
	
	response.sendRedirect(response.encodeRedirectURL("afficherOrganisation.jsp?iIdOrganisation=" + organisation.getIdOrganisation()));
}
catch(Exception e)
{
	e.printStackTrace();
	if(organisation != null){
		organisation.removeWithObjectAttached();
	}

	String sExceptionMessage = AddressBookException.parseException(e,sessionLanguage);
	
	String sMessTitle = "Problème lors de l'inscription de l'entreprise";
	String sMess = "<br />"
			+ "Un problème est survenu durant la procédure d'inscription de votre entreprise.<br />";
	sMess += "Erreur : "+sExceptionMessage;
	String sUrlIcone = modula.graphic.Icone.ICONE_ERROR;
	String sUrlRedirect = rootPath + "desk/organisation/ajouterOrganisationForm.jsp?iIdOrganisationType="+iIdOrganisationType;
	session.setAttribute("sessionPageTitre", sTitle);
	session.setAttribute("sessionMessageTitre", sMessTitle);
	session.setAttribute("sessionMessageLibelle", sMess);
	session.setAttribute("sessionMessageUrlIcone", sUrlIcone);
	session.setAttribute("sessionMessageUrlRedirect", sUrlRedirect);
	
	response.sendRedirect( response.encodeURL(rootPath + "include/afficherMessageDesk.jsp")  );
}

ConnectionManager.closeConnection(conn);
%>
