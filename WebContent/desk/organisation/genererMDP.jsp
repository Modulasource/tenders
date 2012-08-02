
<%@page import="mt.common.addressbook.habilitation.AddressBookHabilitation"%>
<%@page import="org.coin.bean.ws.AddressBookWebService"%><%@page import="org.coin.bean.ws.PersonnePhysiqueWebService"%>
<%@page import="java.util.Vector"%>
<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@ include file="pave/localizationObject.jspf" %>
<%@ page import="org.coin.security.*,java.sql.*,org.coin.fr.bean.mail.*,org.coin.fr.bean.*,org.coin.bean.*" %>
<%@ page import="mt.modula.bean.mail.*,org.coin.mail.*" %> 
<%@page import="org.coin.mail.mailtype.MailUser"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="modula.journal.Evenement"%>
<%@page import="modula.graphic.Icone"%>
<%@page import="modula.OrganisationTypeModula"%>
<%
	
	String sTitle = "";
	String sMessTitle = "Succès !";
	String sMess = "";
	String sUrlIcone = Icone.ICONE_SUCCES;
	Connection conn = ConnectionManager.getConnection();
	
	int iIdUser = Integer.parseInt(request.getParameter("iIdUser")); ;
	User user = User.getUser(iIdUser,conn);
	PersonnePhysique personne = PersonnePhysique.getPersonnePhysique(user.getIdIndividual(), false, conn);
	personne.setAbstractBeanLocalization(sessionLanguage);
	
	Organisation organisation = Organisation.getOrganisation(personne.getIdOrganisation(), false, conn);
	PersonnePhysique personneLoguee = PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual());
	String sPersonneCiviliteNomPrenom = personne.getCivilitePrenomNom(conn);
	sMess = "Le compte utilisateur de "+sPersonneCiviliteNomPrenom;
	boolean bUserDesk = OrganisationTypeModula.isUserDesk(organisation);
		
	String sPageUseCaseId = AddressBookHabilitation.getUseCaseForGeneratePassword(organisation);
    sessionUserHabilitation.isHabilitateException(sPageUseCaseId , conn);

	sTitle = "Génération d'un mot de passe";
	
	sMess = locMessage.getValue(41,"Vous venez de générer un nouveau mot de passe avec succès. Cette personne va recevoir un mail avec son nouveau mot de passe.");
	 	

	/*String mdp = Password.calcPassword(8,
			org.coin.security.Password.CHARSET_NUM 
			+ org.coin.security.Password.CHARSET_TINY);*/
	String mdp = Password.getSyllabicPassword(2, 2);
	user.sNewPassword = mdp;
	user.setPassword(MD5.getEncodedString(mdp));
	user.store(conn);
	
	//MAIL
	PersonnePhysiqueCivilite civilitePersonne = new PersonnePhysiqueCivilite();
	civilitePersonne.setAbstractBeanLocalizationAndConnexion(personne);
	civilitePersonne.bUseHttpPrevent=false;
	Vector<PersonnePhysiqueCivilite> vCivilite = civilitePersonne.getAll(conn);
	
	Courrier courrier = MailUser.prepareMailNewPassword(
			MailConstant.MAIL_DESK_GENERER_MPD,
			personne, 
			mdp, 
			personneLoguee, 
			vCivilite,  
			bUserDesk,
			conn);


	MailModula mail = new MailModula();
	courrier.send(mail,conn);

	Evenement.addEvenementPersonnePhysiqueOptional(sPageUseCaseId, sessionUser.getIdUser() ,personne, organisation );

	/**
     * Web Service
     */
    if(AddressBookWebService.isActivated(conn))
	{
	    try{
	        PersonnePhysiqueWebService wsPP = AddressBookWebService.newInstancePersonnePhysiqueWebService(conn);
	        if(wsPP.isSynchronized(personne, conn)){
	        	user.sNewPassword = mdp;
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
						+personne.getIdPersonnePhysique()
						+ "&sMessage=" + sMess)) ;
		
%>
