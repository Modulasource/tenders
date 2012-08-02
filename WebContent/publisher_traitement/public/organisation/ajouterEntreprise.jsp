<%@page import="org.coin.bean.ws.AddressBookWebService"%>
<%@page import="org.coin.db.CoinDatabaseLoadException"%>
<%@page import="org.coin.bean.conf.Configuration"%>
<%@page import="mt.modula.affaire.cpf.CodeCpfGroup"%>
<%@page import="org.coin.bean.ws.PersonnePhysiqueWebService"%>
<%@page import="org.coin.bean.ws.OrganisationWebService"%>
<%@page import="modula.graphic.Icone"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="org.coin.mail.mailtype.MailUser"%>

<%@ page import="java.net.*,java.sql.*,org.coin.security.*,org.coin.bean.*,org.coin.fr.bean.mail.*,org.coin.fr.bean.*,org.coin.util.*" %> 
<%@ page import="mt.modula.bean.mail.*,org.coin.mail.*" %> 
<%@ include file="/include/beanSessionUser.jspf" %>
<%@ include file="/include/publisherType.jspf" %>
<%
	String sTitle = "Inscription d'une entreprise"; 
	String rootPath = request.getContextPath()+"/";
	String sFormPrefix = "";
	String sMessTitle = "";
	String sMess = "";
	String sUrlIcone = "";	
	
	Organisation organisation = null;
	Adresse adresseOrganisation = null;
	PersonnePhysique gerant = null; 
	Adresse adresseGerant = null;
	String mdp = "";
	User user = null;	
    Connection conn = ConnectionManager.getConnection();
	
	boolean bCreateInDatabase = true;
    boolean bRedirectUrl = true;
	
    String sRefExtPrefix = Configuration.getConfigurationValueMemory(
    		"publisher.portail.subscription.addressbook.refext.prefix","");
    /**
     * TODO_AG
     */
    //bCreateInDatabase = false;
    //bRedirectUrl = false;
    
    
    
    
	try
	{
		//ENTREPRISE
		organisation = new Organisation();
		organisation.setFromFormInscription(request,sFormPrefix);
	
		adresseOrganisation = new Adresse();
		adresseOrganisation.setFromForm(request, "organisation_adresse_");
 		if(bCreateInDatabase) adresseOrganisation.create();
		
		organisation.setIdAdresse(adresseOrganisation.getIdAdresse());
		if(bCreateInDatabase) organisation.create(conn);
		if(bCreateInDatabase) organisation.setCompetence(request, sFormPrefix);
			

		
		
        //GERANT
		gerant = new PersonnePhysique();
		gerant.setFromForm(request, sFormPrefix);
		gerant.setIdOrganisation(organisation.getIdOrganisation());
		
		adresseGerant = new Adresse();
		adresseGerant.setFromForm(request, "organisation_adresse_");
        if(bCreateInDatabase) adresseGerant.create(conn);
		
		gerant.setIdAdresse(adresseGerant.getIdAdresse());
		if(bCreateInDatabase) gerant.create(conn);
		
		organisation.setIdCreateur(gerant.getIdPersonnePhysique());
		if(bCreateInDatabase) organisation.store(conn);

		
		
	    /**
         * EVOL bug #2250
         */
	    if(!sRefExtPrefix.equals("")) {
	    	//System.out.println("sRefExtPrefix : " + sRefExtPrefix);
	    	
            organisation.setReferenceExterneAP(sRefExtPrefix + organisation.getId());
            organisation.setReferenceExterne(sRefExtPrefix + organisation.getId());
            organisation.setMailOrganisation(gerant.getEmail());
            organisation.setTelephone(gerant.getTel());
            organisation.store(conn);
            
            gerant.setReferenceExterne(sRefExtPrefix + gerant.getId());
            gerant.store(conn);
	    }

	    
		
		//COMPTE UTILISATEUR
		mdp = Password.calcPassword(8, Password.CHARSET_NUM + Password.CHARSET_TINY);
		user = new User(gerant.getEmail(),
						MD5.getEncodedString(mdp),
						UserType.TYPE_CANDIDAT,
						UserStatus.EN_ATTENTE_DE_VALIDATION,
						gerant.getIdPersonnePhysique(),
						"");
		
		if(bCreateInDatabase) user.create(conn);
		user.setKey(Password.computeCryptogramMD5(Integer.toString(user.getIdUser())));
		if(bCreateInDatabase) user.store(conn);
		
		
		
		if(bCreateInDatabase) 
		{
			/**
			 * Web Service part
			 * here is only OrganisationType.TYPE_CANDIDAT
			 */
			if(AddressBookWebService.isActivatedForOrganisationType(
					OrganisationType.TYPE_CANDIDAT,
					conn))
			{
				try{
					OrganisationWebService wsOrga = AddressBookWebService.newInstanceOrganisationWebService(conn);
					wsOrga.synchroCreate(organisation, conn);
			        
					/**
					 * need to wait because the Alice Web Service is asynchronous 
					 */
					Thread.sleep(1000);
					
					PersonnePhysiqueWebService wsPP = AddressBookWebService.newInstancePersonnePhysiqueWebService(conn);
	                wsPP.synchroCreate(gerant, organisation, conn);
				} catch(Exception e ) {
				    e.printStackTrace();					
				}
			}
		}
		
		
		
		
	} catch(Exception e) {
		e.printStackTrace();
		if(organisation != null)
			organisation.removeWithObjectAttached();

		sMessTitle = "Problème lors de l'inscription de l'entreprise";
		sMess = "<br />"
				+ "Un problème est survenu durant la procédure d'inscription de votre entreprise.<br /><br />"
				+ "<a href='"+ response.encodeURL(rootPath + sPublisherPath)+"'>Retour &agrave; l'accueil</a>";
		sUrlIcone = modula.graphic.Icone.ICONE_ERROR;
		
		session.setAttribute("sessionPageTitre", sTitle);
		session.setAttribute("sessionMessageTitre", sMessTitle);
		session.setAttribute("sessionMessageLibelle", sMess);
		session.setAttribute("sessionMessageUrlIcone", sUrlIcone);
		
        ConnectionManager.closeConnection(conn);
        if(bRedirectUrl) response.sendRedirect( response.encodeURL(rootPath + "include/afficherMessagePublisher.jsp")  );
		return;
	}
	
	

  
    PersonnePhysique personneLogged =
        PersonnePhysique.getPersonnePhysique(
                User.getUser( User.ID_CRON_USER).getIdIndividual(), false, conn);

    
    
    /**
     * TODO_AG
     */
     if(false) {
    	 
    	 
    	 
	     try
	     {
	    	 new MailType().populateMemory();
	     
		     Courrier courrierTmp = MailUser.prepareCourrierPersonnePhysique(
		    		 MailConstant.MAIL_GERANT_PREINSCRIPTION,
		             gerant,
		             personneLogged,
		             false,
		             conn) ;
		     
		     String sPrefix = "";
		     courrierTmp = MailUser.populateCourrierOrganisation(courrierTmp, organisation);
		     courrierTmp = MailUser.populateCourrierAdresse(courrierTmp, adresseGerant,"<br/>", "", conn);
		     
		     
	         /**
	          * Dept
	          */
	         String sListDept = "";     
	         String [] sarrListDept = request.getParameterValues("listDepartement");
	         
		     if (sarrListDept != null) {
		    	 for(String sDeptSelected : sarrListDept )
		         {
		    		 Departement dept = Departement.getDepartementMemory(sDeptSelected, false);
		        	 sListDept += dept.getIdString() + " - " + dept.getName() + "<br/>\n";
		         }
		     }
	         courrierTmp.replaceAllMessageAndSubjectKeyWord("[" + sPrefix + "list_departement_selected]", sListDept);
		        
	        
	         
	         
	         /**
	          * Code Affiches
	          */
	         String sListCodeCpfGroup = "";     
	         String [] sarrListCodeCpfGroup = request.getParameterValues("listCodeCpfGroup");
	         
	         if (sarrListCodeCpfGroup != null) {
	             for(String sCodeCpfGroupSelected : sarrListCodeCpfGroup )
	             {
	            	 CodeCpfGroup codeCpfGroup 
	            	  = CodeCpfGroup.getCodeCpfGroupMemory(Integer.parseInt( sCodeCpfGroupSelected), false);
	                 
	            	 sListCodeCpfGroup 
	            	   += codeCpfGroup.getReferenceExterne() 
	            	   + " - " + codeCpfGroup.getName() + "<br/>\n";
	             }
	         }
	         courrierTmp.replaceAllMessageAndSubjectKeyWord("[" + sPrefix + "list_code_cpf_group_selected]", sListCodeCpfGroup);
	         
	         
	         new Configuration().populateMemory();
	         
	         String sTo = Configuration.getConfigurationValueMemory("modula.publisher.pre.subscription");
	         courrierTmp.setTo(sTo);
	         
	         
		     MailModula mail = new MailModula();
		     courrierTmp.send(mail,conn);
	     
		     
		     sMessTitle = "Succès de l'inscription de votre entreprise";
		     sMess = "Un email vient d'être adressé au service de veilles de "
		    	    + "marchés pour valider votre inscription.<br /><br />";
		     
		     sUrlIcone = Icone.ICONE_SUCCES; 
		     session.setAttribute("sessionPageTitre", sTitle);
		     session.setAttribute("sessionMessageTitre", sMessTitle);
		     session.setAttribute("sessionMessageLibelle", sMess);
		     session.setAttribute("sessionMessageUrlIcone", sUrlIcone);
		     
		     response.sendRedirect( response.encodeURL(rootPath + "include/afficherMessagePublisher.jsp")  );
	
		     
	     } catch(Exception e) {
	         e.printStackTrace();
	     }
         ConnectionManager.closeConnection(conn);
	     return ; 
     }
     
     
	 
	 /**
	  * Mail part
	  */
	try
	{

	    //MAIL
	    int iIdMailTypeInscription= MailConstant.MAIL_GERANT_INSCRIPTION;
	    int iIdMailTypeChgStatutCompte = MailConstant.MAIL_GERANT_INSCRIPTION;
	   
	    
	    
	    Courrier courrier = null;
	    try{
	    	
	        String sInstanceURL = "";
            sInstanceURL = HttpUtil.getUrlWithProtocolAndPortToExternalForm(request.getContextPath(), request);
	        
	    	courrier = MailUser.prepareMailActivationUser(
	    		iIdMailTypeInscription,
	            iIdMailTypeChgStatutCompte,
	            mdp,
	            gerant, 
	            user,
	            personneLogged, 
	            false,
	            sInstanceURL,
	            conn);
	    	
	    	
	    } catch (Exception e) {
	    	e.printStackTrace();
	    }
	
	    
	    MailModula mail = new MailModula();
	    courrier.send(mail,conn);
	    
	    
	} catch(Exception e) {
		e.printStackTrace();
		
		
		
		
		if(organisation != null)
			organisation.removeWithObjectAttached();

		sMessTitle = "Problème lors de l'inscription de l'entreprise";
		sMess = "<br />"
				+ "Un problème est survenu durant la procédure d'inscription de votre entreprise.<br /><br />"
				+ "<a href='"+ response.encodeURL(rootPath + sPublisherPath)+"'>Retour &agrave; l'accueil</a>";
		sUrlIcone = modula.graphic.Icone.ICONE_ERROR;
		
		session.setAttribute("sessionPageTitre", sTitle);
		session.setAttribute("sessionMessageTitre", sMessTitle);
		session.setAttribute("sessionMessageLibelle", sMess);
		session.setAttribute("sessionMessageUrlIcone", sUrlIcone);
		
	    ConnectionManager.closeConnection(conn);
		if(bRedirectUrl) response.sendRedirect( response.encodeURL(rootPath + "include/afficherMessagePublisher.jsp")  );
		return;
	}
    			
	
	
	sMessTitle = "Succès de l'inscription de votre entreprise";
	sMess = "La personne physique définie ("+ gerant.getPrenomNom() +
	") devient gérante de l'entreprise "+ organisation.getRaisonSociale()+"<br />"+
	"Un email vient de vous être adressé afin de valider votre compte utilisateur.<br /><br />";
	
	sUrlIcone = Icone.ICONE_SUCCES;	
	session.setAttribute("sessionPageTitre", sTitle);
	session.setAttribute("sessionMessageTitre", sMessTitle);
	session.setAttribute("sessionMessageLibelle", sMess);
	session.setAttribute("sessionMessageUrlIcone", sUrlIcone);
	
	
	
    ConnectionManager.closeConnection(conn);
	if(bRedirectUrl) response.sendRedirect( response.encodeURL(rootPath + "include/afficherMessagePublisher.jsp")  );
%>
