
<%@page import="org.coin.db.CoinDatabaseLoadException"%>
<%@page import="mt.common.addressbook.AddressBookException"%>
<%@page import="org.coin.db.CoinDatabaseException"%>
<%@page import="java.security.cert.CertificateEncodingException"%>
<%@page import="org.coin.bean.pki.certificate.PkiCertificateGenerator"%>
<%@page import="org.coin.bean.pki.certificate.PkiCertificate"%>
<%@page import="org.coin.bean.pki.PkiConstant"%>
<%@page import="mt.common.addressbook.habilitation.AddressBookHabilitation"%>
<%@page import="org.coin.bean.ws.AddressBookWebService"%>
<%@page import="org.coin.bean.ws.ConfigurationWebService"%>
<%@page import="org.coin.bean.conf.Configuration"%>
<%@page import="org.coin.util.HttpUtil"%><%@page import="org.coin.bean.ws.OrganisationWebService"%>
<%@page import="org.coin.bean.ws.PersonnePhysiqueWebService"%>
<%@page import="org.coin.mail.mailtype.MailUser"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="modula.journal.Evenement"%>
<%@ page import="java.sql.*,org.coin.security.*,org.coin.fr.bean.*,org.coin.bean.*,org.coin.fr.bean.mail.*, modula.*" %>
<%@ page import="mt.modula.bean.mail.*,org.coin.mail.*" %> 
<%@ include file="../include/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath()+"/";
	String sFormPrefix = "";
	Connection conn = ConnectionManager.getConnection();

	int iIdOrganisation = -1;
	Organisation organisation = null;
	Adresse adresseOrganisation = new Adresse();
	PersonnePhysique personne = new PersonnePhysique();
	boolean createGerant = false;
	try
	{
		iIdOrganisation = Integer.parseInt(request.getParameter("iIdOrganisation"));
		organisation = Organisation.getOrganisation(iIdOrganisation);
		adresseOrganisation = Adresse.getAdresse(organisation.getIdAdresse());
	} 
	catch (Exception e){}
    String sTitle ="Ajout d'une personne à l'organisation "+organisation.getRaisonSociale();

    
    /**
     * habilitation
     */
	PersonnePhysique personActor = PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual());
	String sPageUseCaseId = AddressBookHabilitation.getUseCaseForCreateIndividual(organisation, personActor);
	String sCreateAccountUseCaseId = AddressBookHabilitation.getUseCaseForCreateUserAccount(organisation, personActor);
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId, conn);


	/**
	 * LDAP
	 */
    String sLdapAccountName = HttpUtil.parseStringBlank("sLdapAccountName", request);
	String sSamAccountName = HttpUtil.parseStringBlank("sSamAccountName", request);



try
{
	personne.setFromForm(request, "");
	personne.setIdOrganisation(organisation.getIdOrganisation());
	
	
	Adresse adresse = new Adresse();
	adresse = adresseOrganisation;
	adresse.setId(-1);
	adresse.create(conn);
	
	personne.setIdAdresse(adresse.getIdAdresse());
	personne.create(conn);
	
	String sEvenement = personne.getPrenom() + " " + personne.getNom() 
		+ " [" + personne.getEmail() + "] de " + organisation.getRaisonSociale();


	
	if(organisation.getIdCreateur()<=0)
	{
		organisation.setIdCreateur((int)personne.getId());
		organisation.store();
		createGerant = true;
		
		sEvenement = "Nouveau gérant de l'organisation : " + personne.getPrenom() + " " + personne.getNom() 
			+ " [" + personne.getEmail() + "] de " + organisation.getRaisonSociale();
	}
	
	 try{
		 Evenement.addEvenement(
		      personne.getIdPersonnePhysique(), 
		      sPageUseCaseId, 
		      sessionUser.getIdUser(),
		      sEvenement);
		 }catch(CoinDatabaseLoadException e){System.out.println(e.getMessage());/** type evt non défini */}
	
	int iCreateUser = -1;
	if(request.getParameter(sFormPrefix+"createUser") != null)
		iCreateUser = Integer.parseInt(request.getParameter(sFormPrefix+"createUser"));

	int iCreateUserCertificate = -1;
	if(request.getParameter(sFormPrefix+"createUserCertificate") != null)
		iCreateUserCertificate = Integer.parseInt(request.getParameter(sFormPrefix+"createUserCertificate"));
	
	if(iCreateUserCertificate == 1)
	{
		long lIdDN = Configuration.getLongValueMemory(
				"pki.certificate.dn.intermediate", 
				PkiConstant.DN_INTERMEDIATE_PARAPH);
        PkiCertificate pkiCertificate = PkiCertificateGenerator.generateCertificateFromPersonne(
        		personne.getId(), 
                lIdDN, 
                conn);
	}
	
	User user = null;
	
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

		
		int iActivateUser = HttpUtil.parseInt(sFormPrefix+"activateUser", request, -1);

		
		if(iActivateUser == 1)
		{
			if(!sLdapAccountName.equals(""))
			{
				/**
				 * its a LDAP account
				 */

				user.setIdUserStatus(UserStatus.VALIDE);
				user.setIdCoinUserAccessModuleType(CoinUserAccessModuleType.TYPE_LDAP);

				if(!sSamAccountName.equals(""))
				{
					user.setLogin(sSamAccountName);
				}
			} else {
			

				user.setIdUserStatus(UserStatus.INVALIDE);
				user.setKey(Password.computeCryptogramMD5(Integer.toString(user.getIdUser())));
				user.setIdCoinUserAccessModuleType(CoinUserAccessModuleType.TYPE_MODULA);
				
				int iIdMailTypeInscription= MailConstant.MAIL_DESK_INSCRIPTION_PERSONNE;
				int iIdMailTypeChgStatutCompte = MailConstant.MAIL_DESK_CHANGEMENT_STATUT_COMPTE;
			    String sInstanceURL = HttpUtil.getUrlWithProtocolAndPortToExternalForm(request.getContextPath(), request);
	
				PersonnePhysique personneLoguee 
				 = PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual(), false, conn);
				
				try{
				
					Courrier courrier = MailUser.prepareMailActivationUser(
							iIdMailTypeInscription,
							iIdMailTypeChgStatutCompte,
							mdp,
							personne, 
							user,
							personneLoguee, 
							OrganisationTypeModula.isUserDesk(organisation),
							sInstanceURL,
							conn);
					
					MailModula mail = new MailModula();
					courrier.send(mail,conn);
				}
				catch(Exception e){e.printStackTrace();}
				
			}
			user.store(conn);
		}
	}
	
	
	
	/**
     * Web Service
     */
    if(AddressBookWebService.isActivated(conn))
    {
	    try{
	        PersonnePhysiqueWebService wsPP = AddressBookWebService.newInstancePersonnePhysiqueWebService(conn);
	        OrganisationWebService wsOrga = AddressBookWebService.newInstanceOrganisationWebService(conn);
	        
	        if(wsOrga.isSynchronized(organisation, conn)){
	        	wsPP.synchroCreate(personne, organisation, conn);
	        }
	        
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
    }
	
	if(!sLdapAccountName .equals(""))
	{
		PersonnePhysiqueParametre.updateValue(personne.getId(), "ldap.cn", sLdapAccountName, conn);
		PersonnePhysiqueParametre.updateValue(personne.getId(), "ldap.name", sLdapAccountName, conn);
	}

    if(!sSamAccountName .equals(""))
    {
		PersonnePhysiqueParametre.updateValue(personne.getId(), "ldap.sAMAccountName", sSamAccountName, conn);
    }
    
	response.sendRedirect(response.encodeRedirectURL("afficherPersonnePhysique.jsp?iIdPersonnePhysique=" + personne.getIdPersonnePhysique()));
} catch(Exception e) {
	e.printStackTrace();
	if(personne != null)
	{
		personne.removeWithObjectAttached();
		if(createGerant)
		{
			organisation.setIdCreateur(0);
			organisation.store(conn);
		}
	}
	
	String sExceptionMessage = AddressBookException.parseException(e,sessionLanguage);

	String sMessTitle = "Problème lors de l'inscription de la personne ";
	String sMess = "<br />"
			+ "Un problème est survenu durant la procédure d'inscription de la personne.<br />\n" + sExceptionMessage;
	String sUrlIcone = modula.graphic.Icone.ICONE_ERROR;
	String sUrlRedirect = rootPath + "desk/organisation/afficherOrganisation.jsp?iIdOrganisation="+organisation.getIdOrganisation();
	session.setAttribute("sessionPageTitre", sTitle);
	session.setAttribute("sessionMessageTitre", sMessTitle);
	session.setAttribute("sessionMessageLibelle", sMess);
	session.setAttribute("sessionMessageUrlIcone", sUrlIcone);
	session.setAttribute("sessionMessageUrlRedirect", sUrlRedirect);
	
	response.sendRedirect( response.encodeURL(rootPath + "include/afficherMessageDesk.jsp")  );
}

ConnectionManager.closeConnection(conn);

%>
