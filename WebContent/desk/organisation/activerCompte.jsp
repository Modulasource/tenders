<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@page import="org.coin.bean.ws.AddressBookWebService"%>
<%@page import="mt.common.addressbook.habilitation.AddressBookHabilitation"%>
<%@page import="org.coin.bean.ws.ConfigurationWebService"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.bean.ws.PersonnePhysiqueWebService"%>
<%@ page import="org.coin.security.*,java.sql.*,org.coin.fr.bean.mail.*,org.coin.fr.bean.*,org.coin.bean.*" %>
<%@ page import="mt.modula.bean.mail.*,org.coin.mail.*" %> 
<%@page import="org.coin.bean.conf.Configuration"%>
<%@page import="modula.graphic.Icone"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="org.coin.mail.mailtype.MailUser"%>
<%@page import="modula.OrganisationTypeModula"%>
<%@page import="modula.journal.Evenement"%>
<%
	String sTitle = "";
	String sMessTitle = "Succès !";
	String sMess = "";
	String sUrlIcone = Icone.ICONE_SUCCES;	
    Connection conn = ConnectionManager.getConnection();

	int iIdUser =-1 ;
	PersonnePhysique personne = null;
	User user = null;
	Organisation organisation = null;
	try
	{
		iIdUser = Integer.parseInt(request.getParameter("iIdUser"));
		user = User.getUser(iIdUser);
		personne = PersonnePhysique.getPersonnePhysique(user.getIdIndividual());
		organisation = Organisation.getOrganisation(personne.getIdOrganisation());
		sMess = "Le compte ";
	}
	catch(Exception e){}
	PersonnePhysique personneLogue = PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual(), false, conn );
	
	String sPageUseCaseId = "";
	if (user.getIdUserStatus() == UserStatus.INVALIDE)
	{
		sPageUseCaseId 
		  = AddressBookHabilitation.getUseCaseForUserActivation(
		personne,
		organisation,
		personneLogue);
		
		sTitle = "Activation ";
		sMess += " a bien été activé. ";
		sMess += "Un mail a été envoyé afin de confirmer la validation du compte.";
	}
	else
	{
		sPageUseCaseId 
        = AddressBookHabilitation.getUseCaseForUserDesactivation(
              personne,
              organisation,
              personneLogue);
		
		sTitle = "Désactivation ";
		sMess += " a bien été désactivé. ";
		sMess += "Un mail a été envoyé à l'utilisateur afin de préciser le nouveau statut du compte.";
	}
	
	personne.setAbstractBeanLocalization(sessionLanguage);
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId , conn);

	
	
	
	MailType mailType = null;
	String sObjet = "";
	String contenuMail = "";
	
	//String mdp = Password.calcPassword(8, Password.CHARSET_NUM + Password.CHARSET_TINY);
	String mdp = Password.getSyllabicPassword(2, 2);
	user.sNewPassword = mdp;
	user.setPassword(MD5.getEncodedString(mdp));


	//MAIL
	
	int iIdMailTypeInscription= MailConstant.MAIL_DESK_INSCRIPTION_PERSONNE;
	int iIdMailTypeChgStatutCompte = MailConstant.MAIL_DESK_CHANGEMENT_STATUT_COMPTE;
	
	
        
    String sInstanceURL = HttpUtil.getUrlWithProtocolAndPortToExternalForm(request.getContextPath(), request);
    
	PersonnePhysique personneLoguee = PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual());
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
	
	
	user.store(conn);
	Evenement.addEvenementPersonnePhysiqueOptional(sPageUseCaseId, sessionUser.getIdUser() ,personne, organisation );

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
    
    ConnectionManager.closeConnection(conn);    

	response.sendRedirect(
		response.encodeRedirectURL(
			rootPath + "desk/organisation/afficherPersonnePhysique.jsp?iIdPersonnePhysique="
					+ personne.getIdPersonnePhysique()
					+ "&sMessage=" + sMess) );
	
%>