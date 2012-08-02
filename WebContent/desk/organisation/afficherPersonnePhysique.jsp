<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@ page import="org.coin.util.*,org.coin.bean.document.*,org.coin.bean.editorial.*,org.coin.bean.html.*,modula.commission.*,org.coin.fr.bean.*" %>
<%@ page import="modula.marche.*,modula.graphic.*,java.sql.*,java.util.*,org.coin.bean.*,modula.*" %>
<%@page import="org.coin.localization.Language"%>
<%@page import="org.coin.localization.Localize"%>
<%@page import="org.coin.localization.LocalizationConstant"%>
<%@page import="org.coin.bean.pki.certificate.PkiCertificate"%>
<%@page import="org.coin.bean.pki.certificate.PkiCertificateType"%>
<%@page import="org.coin.bean.pki.PkiConstant"%>
<%@page import="org.coin.bean.geo.util.GeoCenter"%>
<%@page import="mt.modula.JavascriptVersionModula"%>
<%@page import="mt.common.addressbook.habilitation.DisplayIndividualHabilitation"%>
<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="org.coin.bean.geo.Town"%>
<%@page import="org.coin.bean.geo.util.GeoMap"%>
<%@page import="javax.naming.Context"%>
<%@page import="javax.naming.ldap.LdapContext"%>
<%@page import="javax.naming.directory.SearchControls"%>
<%@page import="javax.naming.NamingEnumeration"%>
<%@page import="javax.naming.directory.SearchResult"%>
<%@page import="javax.naming.ldap.InitialLdapContext"%>
<%@page import="javax.naming.directory.Attribute"%>
<%@page import="javax.naming.directory.Attributes"%>
<%@page import="org.coin.ldap.LdapConnection"%>
<%@ include file="pave/localizationObject.jspf" %>
<%
	String sFormPrefix = "";
	Connection conn = ConnectionManager.getConnection();
	request.setAttribute("conn", conn);
	boolean bUseGeoloc = Configuration.isEnabledMemory("design.desk.organisation.geoloc", false) ;
	boolean bUseZipCodeTownSync = Configuration.isEnabledMemory("design.desk.organisation.zipcode.town.sync", false) ;


	int iIdPersonne = -1;
	try {
		iIdPersonne = Integer.parseInt(request.getParameter("iIdPersonnePhysique"));
	} 
	catch (Exception e) {
		try {
			iIdPersonne = Integer.parseInt(request.getParameter("iIdReferenceObjet"));
		} 
		catch (Exception ee) 
		{
			iIdPersonne = Integer.parseInt(request.getParameter("iIdObjetReferenceSource"));
		}
	}
	
	String sAction = HttpUtil.parseStringBlank("sAction", request);
	int iIdOnglet = HttpUtil.parseInt("iIdOnglet", request , 0);
	String sMessage = HttpUtil.parseStringBlank("sMessage", request);
	PersonnePhysique personne = PersonnePhysique.getPersonnePhysique(iIdPersonne);
	personne.setAbstractBeanLocalization(sessionLanguage);

	User userPersonne = null;
	try{
		userPersonne = User.getUserFromIdIndividual(iIdPersonne);
		userPersonne.setAbstractBeanLocalization(personne);
	}
	catch(Exception e){}
	
	Organisation organisation = Organisation.getOrganisation(personne.getIdOrganisation());
	organisation.setAbstractBeanLocalization(sessionLanguage);
	PersonnePhysique personneLogue = PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual() );
	
	Adresse adresse = new Adresse();
	try{adresse = Adresse.getAdresse(personne.getIdAdresse());}
	catch(Exception e){}
	adresse.setAbstractBeanLocalization(personne) ;
	
	Pays pays = null;
	try{pays = Pays.getPays(adresse.getIdPays());}
	catch(Exception e){pays = new Pays();}
	pays.setAbstractBeanLocalization(personne) ;
	
	Pays nationalite = null;
	try{nationalite = Pays.getPays(personne.getIdNationalite() );}
	catch(Exception e){nationalite = new Pays();}
	nationalite.setAbstractBeanLocalization(personne) ;

	
 	OrganisationType orgType = OrganisationType.getOrganisationType(organisation.getIdOrganisationType());
	orgType.setAbstractBeanLocalization(personne) ;
	String sOrganisationTypeName = orgType.getName();
	

	CoinUserAccessModuleType accessType = null;
	try {
		if(userPersonne != null && userPersonne.getIdCoinUserAccessModuleType()>0)
		{
			accessType 
				= CoinUserAccessModuleType
					.getCoinUserAccessModuleTypeMemory(
						userPersonne.getIdCoinUserAccessModuleType());
		} else {
			accessType = new CoinUserAccessModuleType();
		}
	} catch (CoinDatabaseLoadException e ){
		accessType = new CoinUserAccessModuleType();
	}catch (SQLException se ){
		/** no user acces module in db */
		accessType = new CoinUserAccessModuleType();
	}

	
	/**
	 * Set attributes
	 */
	
	request.setAttribute("personne", personne);
	request.setAttribute("organisation", organisation);
	request.setAttribute("localizeButton", localizeButton);
	request.setAttribute("sAction",  sAction);

	
	
	/**
     * Use localization
     */
	String sBlocNameAdministativeData = locTabs.getValue(1,"Données administratives") ;
 	String sTabNameIdentity = locTabs.getValue(2,"Coordonnées");
 	String sTabNameAdress = locTabs.getValue(3,"Adresse");
	String sTabNameOrganization = locTabs.getValue(16,"Organisation");
	String sTabNameCommission = locTabs.getValue(5,"Commission");
	String sTabNameCertificate = locTabs.getValue(17,"Certificats");
	String sTabNameTransfert =  locTabs.getValue(9,"Transfert");
	String sTabNameUserAccount = locTabs.getValue(18,"Compte utilisateur");
	String sTabNameSynchroAnnonce = locTabs.getValue(19,"Synchro Annonces");
	String sTabNameUtility = locTabs.getValue(20,"Utilitaires");
	String sTabNameGED = locTabs.getValue(12,"GED");
	String sTabNameAideRedac = locTabs.getValue(13,"Aides rédactionnelles");
 	String sTabNameParameter = locTabs.getValue(10,"Paramètres");
	String sTabNameGraphicCharter = locTabs.getValue(8,"Charte graphique");
	String sTabNameSignatureScannee = locTabs.getValue(31,"Signature numérique");
	String sTabNameClasseur = locTabs.getValue(24,"Classeur");
	String sTabNamePropiete = locTabs.getValue(25,"propriété");
	String sTabNameDelegation = locTabs.getValue(26,"Délégation");
	String sTabNameLDAP = locTabs.getValue(27,"LDAP");
	String sTabNameNotifications = locTabs.getValue (32, "My notifications");
	//String sTabNameMyCircuits = locTabs.getValue (33, "Mes circuits");
	String sTabNameParaphFolderTemplate = locTabs.getValue (34, "Circuits");
	String sTabNameAutoReload = locTitle.getValue(46,"Rafraichissement automatique");

	String sMyIdentityCardLabel = locTitle.getValue(29,"Ma fiche d'identité");
	String sIdentityCardOfLabel = locTitle.getValue(30,"Fiche d'identité de");

	String sBlocNamePersonnePhysique = sBlocNameAdministativeData;
	String sPaveAdresseTitre = sTabNameAdress;// or sBlocNameAdresse 
	String sBlocNameUserAccount = sTabNameUserAccount;

	
    
    DisplayIndividualHabilitation dih = new DisplayIndividualHabilitation();
    dih.update(personne, organisation, personneLogue);
    
    String sPageUseCaseId = dih.sPageUseCaseId;
    String sModifyAccountUseCaseId = dih.sModifyAccountUseCaseId;
    String sUseCaseIdBoutonModifierPersonne = dih.sUseCaseIdBoutonModifierPersonne;
    String sUseCaseIdBoutonSupprimerPersonne = dih.sUseCaseIdBoutonSupprimerPersonne;
    String sUseCaseIdBoutonListeCandidature = dih.sUseCaseIdBoutonListeCandidature;
    String sUseCaseIdBoutonListeCandidatureAP = dih.sUseCaseIdBoutonListeCandidatureAP;
    String sUseCaseIdBoutonGenererMotDePasse = dih.sUseCaseIdBoutonGenererMotDePasse;
    String sUseCaseIdBoutonModifierMotDePasse = dih.sUseCaseIdBoutonModifierMotDePasse;
    String sUseCaseIdBoutonGenererVCard = dih.sUseCaseIdBoutonGenererVCard;
    String sUseCaseIdBoutonActiverCompte = dih.sUseCaseIdBoutonActiverCompte;
    String sUseCaseIdBoutonDesactiverCompte = dih.sUseCaseIdBoutonDesactiverCompte;
    String sUseCaseIdBoutonAfficherJournalEvt = dih.sUseCaseIdBoutonAfficherJournalEvt;
    String sUseCaseIdAfficherDroits = dih.sUseCaseIdAfficherDroits;
    String sUseCaseIdBoutonAjouterDocument = dih.sUseCaseIdBoutonAjouterDocument;
    String sUseCaseIdBoutonAfficherDocument = dih.sUseCaseIdBoutonAfficherDocument;
    String sUseCaseIdBoutonAjouterEditorial = dih.sUseCaseIdBoutonAjouterEditorial;
    String sUseCaseIdBoutonAfficherEditorial = dih.sUseCaseIdBoutonAfficherEditorial;
    String sUseCaseIdBoutonAdminParaph = dih.sUseCaseIdBoutonAdminParaph;
    
    
 
    /**
     * to studi more for intergation in DisplayIndividualHabilitation ...
     */
    if( (personne.getId() == personneLogue.getId() )
    && (!sessionUserHabilitation.isHabilitate(sUseCaseIdAfficherDroits) ) )
    {
        sUseCaseIdAfficherDroits = "IHM-DESK-PERS-20";
    }
    
    String sTitle = "";
    if(sessionUser.getIdIndividual() == personne.getIdPersonnePhysique())
        sTitle = sMyIdentityCardLabel;
    else
        sTitle = sIdentityCardOfLabel + " <span class='altColor'>"+personne.getNomPrenom() 
        	+" ("+sOrganisationTypeName+")</span>";

	Onglet.sNotCurrentTabStyle = " class='onglet_non_selectionne' "; 
	Onglet.sCurrentTabStyle =  " class='onglet_selectionne' ";
	Onglet.sNotCurrentTabStyleInCreation = " class='onglet_non_selectionne' ";
	Onglet.sCurrentTabStyleInCreation =  " class='onglet_selectionne' ";
	Onglet.sEnddingTabStyle =  " class='onglet_vide_dernier' ";

	String sURLParam = "&iIdPersonnePhysique="+personne.getId()+"&nonce=" + System.currentTimeMillis();
	Vector<Onglet> vOnglets = new Vector<Onglet>();
	vOnglets.add( new Onglet(Onglet.ONGLET_PERSONNE_PHYSIQUE_DONNEES_ADMINISTRATIVES, false, (dih.bGroupPersoData?sTabNameIdentity:sBlocNameAdministativeData), response.encodeURL("afficherPersonnePhysique.jsp?iIdOnglet="+Onglet.ONGLET_PERSONNE_PHYSIQUE_DONNEES_ADMINISTRATIVES+sURLParam)) ); 
	vOnglets.add( new Onglet(Onglet.ONGLET_PERSONNE_PHYSIQUE_ADRESSE, false, sTabNameAdress, response.encodeURL("afficherPersonnePhysique.jsp?iIdOnglet="+Onglet.ONGLET_PERSONNE_PHYSIQUE_ADRESSE+sURLParam),dih.bGroupPersoData) ); 
	vOnglets.add( new Onglet(Onglet.ONGLET_PERSONNE_PHYSIQUE_ORGANISATION, false, sTabNameOrganization, response.encodeURL("afficherPersonnePhysique.jsp?iIdOnglet="+Onglet.ONGLET_PERSONNE_PHYSIQUE_ORGANISATION+sURLParam), dih.bGroupPersoData , true)); 
	
	vOnglets.add( new Onglet(Onglet.ONGLET_PERSONNE_PHYSIQUE_COMMISSION, false, sTabNameCommission, response.encodeURL("afficherPersonnePhysique.jsp?iIdOnglet="+Onglet.ONGLET_PERSONNE_PHYSIQUE_COMMISSION+sURLParam), true) ); 
	vOnglets.add( new Onglet(Onglet.ONGLET_PERSONNE_PHYSIQUE_CERTIFICATS, false, sTabNameCertificate, response.encodeURL("afficherPersonnePhysique.jsp?iIdOnglet="+Onglet.ONGLET_PERSONNE_PHYSIQUE_CERTIFICATS+sURLParam)) ); 
	vOnglets.add( new Onglet(Onglet.ONGLET_PERSONNE_PHYSIQUE_EXPORT, false, sTabNameTransfert, response.encodeURL("afficherPersonnePhysique.jsp?iIdOnglet="+Onglet.ONGLET_PERSONNE_PHYSIQUE_EXPORT+sURLParam)) ); 
	vOnglets.add( new Onglet(Onglet.ONGLET_PERSONNE_PHYSIQUE_COMPTE_UTILISATEUR, false, sTabNameUserAccount, response.encodeURL("afficherPersonnePhysique.jsp?iIdOnglet="+Onglet.ONGLET_PERSONNE_PHYSIQUE_COMPTE_UTILISATEUR+sURLParam)) ); 
	vOnglets.add( new Onglet(Onglet.ONGLET_PERSONNE_PHYSIQUE_SYNCHRO_ANNONCES, false, sTabNameSynchroAnnonce, response.encodeURL("afficherPersonnePhysique.jsp?iIdOnglet="+Onglet.ONGLET_PERSONNE_PHYSIQUE_SYNCHRO_ANNONCES+sURLParam), true) ); 
	vOnglets.add( new Onglet(Onglet.ONGLET_PERSONNE_PHYSIQUE_UTILITAIRES, false, sTabNameUtility, response.encodeURL("afficherPersonnePhysique.jsp?iIdOnglet="+Onglet.ONGLET_PERSONNE_PHYSIQUE_UTILITAIRES+sURLParam), true) ); 
	vOnglets.add( new Onglet(Onglet.ONGLET_PERSONNE_PHYSIQUE_GED, false, sTabNameGED, response.encodeURL("afficherPersonnePhysique.jsp?iIdOnglet="+Onglet.ONGLET_PERSONNE_PHYSIQUE_GED+sURLParam), true) ); 
	vOnglets.add( new Onglet(Onglet.ONGLET_PERSONNE_PHYSIQUE_AR, false, sTabNameAideRedac, response.encodeURL("afficherPersonnePhysique.jsp?iIdOnglet="+Onglet.ONGLET_PERSONNE_PHYSIQUE_AR+sURLParam), true) ); 
	vOnglets.add( new Onglet(Onglet.ONGLET_PERSONNE_PHYSIQUE_PARAMETRE, false, sTabNameParameter, response.encodeURL("afficherPersonnePhysique.jsp?iIdOnglet="+Onglet.ONGLET_PERSONNE_PHYSIQUE_PARAMETRE+sURLParam), !sessionUserHabilitation.isSuperUser()) ); 
	vOnglets.add( new Onglet(Onglet.ONGLET_PERSONNE_PHYSIQUE_CHARTE_GRAPHIQUE, false, sTabNameGraphicCharter, response.encodeURL("afficherPersonnePhysique.jsp?iIdOnglet="+Onglet.ONGLET_PERSONNE_PHYSIQUE_CHARTE_GRAPHIQUE+sURLParam),false,dih.bGroupAdminData) );
	vOnglets.add( new Onglet(Onglet.ONGLET_PERSONNE_PHYSIQUE_SCANNED_SIGNATURE, false, sTabNameSignatureScannee, response.encodeURL("afficherPersonnePhysique.jsp?iIdOnglet="+Onglet.ONGLET_PERSONNE_PHYSIQUE_SCANNED_SIGNATURE+sURLParam),false,dih.bGroupAdminData) );
	vOnglets.add( new Onglet(Onglet.ONGLET_PERSONNE_PHYSIQUE_DELEGATION, false, sTabNameDelegation, response.encodeURL("afficherPersonnePhysique.jsp?iIdOnglet="+Onglet.ONGLET_PERSONNE_PHYSIQUE_DELEGATION+sURLParam),false) );
	
	vOnglets.add( new Onglet(Onglet.ONGLET_PERSONNE_PHYSIQUE_BINDER, false, sTabNameClasseur, response.encodeURL("afficherPersonnePhysique.jsp?iIdOnglet="+Onglet.ONGLET_PERSONNE_PHYSIQUE_BINDER+sURLParam), false));
	vOnglets.add( new Onglet(Onglet.ONGLET_PERSONNE_PHYSIQUE_OWNER, false, sTabNamePropiete, response.encodeURL("afficherPersonnePhysique.jsp?iIdOnglet="+Onglet.ONGLET_PERSONNE_PHYSIQUE_OWNER+sURLParam), false));
	vOnglets.add( new Onglet(Onglet.ONGLET_PERSONNE_PHYSIQUE_LDAP, false, sTabNameLDAP, response.encodeURL("afficherPersonnePhysique.jsp?iIdOnglet="+Onglet.ONGLET_PERSONNE_PHYSIQUE_LDAP+sURLParam), true));
	vOnglets.add( new Onglet(Onglet.ONGLET_PERSONNE_PHYSIQUE_PARAPH_FOLDER, false, "Dossiers parapheur", response.encodeURL("afficherPersonnePhysique.jsp?iIdOnglet="+Onglet.ONGLET_PERSONNE_PHYSIQUE_PARAPH_FOLDER+sURLParam), true));
	vOnglets.add( new Onglet(Onglet.ONGLET_PERSONNE_PHYSIQUE_PARAPH_FOLDER_TEMPLATE, false, sTabNameParaphFolderTemplate, response.encodeURL("afficherPersonnePhysique.jsp?iIdOnglet="+Onglet.ONGLET_PERSONNE_PHYSIQUE_PARAPH_FOLDER_TEMPLATE+sURLParam), true));
	
	vOnglets.add( new Onglet(Onglet.ONGLET_PERSONNE_PHYSIQUE_NOTIFICATION, false, sTabNameNotifications, response.encodeURL("afficherPersonnePhysique.jsp?iIdOnglet="+Onglet.ONGLET_PERSONNE_PHYSIQUE_NOTIFICATION+sURLParam), true));
	vOnglets.add( new Onglet(Onglet.ONGLET_PERSONNE_PHYSIQUE_AUTO_RELOAD, false, sTabNameAutoReload, response.encodeURL("afficherPersonnePhysique.jsp?iIdOnglet="+Onglet.ONGLET_PERSONNE_PHYSIQUE_AUTO_RELOAD+sURLParam), true));
	
	Onglet onglet = Onglet.getOnglet(vOnglets,iIdOnglet);
    onglet.bIsCurrent = true;
	
	Onglet ongletCom = Onglet.getOnglet(vOnglets,Onglet.ONGLET_PERSONNE_PHYSIQUE_COMMISSION);
    Onglet ongletSynch = Onglet.getOnglet(vOnglets,Onglet.ONGLET_PERSONNE_PHYSIQUE_SYNCHRO_ANNONCES);
    Onglet ongletUtil = Onglet.getOnglet(vOnglets,Onglet.ONGLET_PERSONNE_PHYSIQUE_UTILITAIRES);
    Onglet ongletCertif = Onglet.getOnglet(vOnglets,Onglet.ONGLET_PERSONNE_PHYSIQUE_CERTIFICATS);
    Onglet ongletTranf = Onglet.getOnglet(vOnglets,Onglet.ONGLET_PERSONNE_PHYSIQUE_EXPORT);
    Onglet ongletGED = Onglet.getOnglet(vOnglets,Onglet.ONGLET_PERSONNE_PHYSIQUE_GED);
    Onglet ongletAR = Onglet.getOnglet(vOnglets,Onglet.ONGLET_PERSONNE_PHYSIQUE_AR);
    Onglet ongletUserAccount = Onglet.getOnglet(vOnglets,Onglet.ONGLET_PERSONNE_PHYSIQUE_COMPTE_UTILISATEUR);
    Onglet ongletDelegation = Onglet.getOnglet(vOnglets,Onglet.ONGLET_PERSONNE_PHYSIQUE_DELEGATION);
	Onglet ongletBinder = Onglet.getOnglet(vOnglets,Onglet.ONGLET_PERSONNE_PHYSIQUE_BINDER);
	Onglet ongletOwner = Onglet.getOnglet(vOnglets,Onglet.ONGLET_PERSONNE_PHYSIQUE_OWNER);
	Onglet ongletLdap = Onglet.getOnglet(vOnglets,Onglet.ONGLET_PERSONNE_PHYSIQUE_LDAP);
	Onglet ongletGraphicChart = Onglet.getOnglet(vOnglets,Onglet.ONGLET_PERSONNE_PHYSIQUE_CHARTE_GRAPHIQUE);
	Onglet ongletScannedSignature = Onglet.getOnglet(vOnglets,Onglet.ONGLET_PERSONNE_PHYSIQUE_SCANNED_SIGNATURE);
	Onglet ongletParaphFolder = Onglet.getOnglet(vOnglets,Onglet.ONGLET_PERSONNE_PHYSIQUE_PARAPH_FOLDER);
	Onglet ongletParaphFolderUserDefined = Onglet.getOnglet(vOnglets,Onglet.ONGLET_PERSONNE_PHYSIQUE_PARAPH_FOLDER_TEMPLATE);
	Onglet ongletNotification = Onglet.getOnglet(vOnglets,Onglet.ONGLET_PERSONNE_PHYSIQUE_NOTIFICATION);
	Onglet ongletAutoReload = Onglet.getOnglet(vOnglets,Onglet.ONGLET_PERSONNE_PHYSIQUE_AUTO_RELOAD);
	 
	
	if(organisation.getIdOrganisationType() == OrganisationType.TYPE_ACHETEUR_PUBLIC
	|| organisation.getIdOrganisationType() == OrganisationType.TYPE_ADMINISTRATEUR) 
	{
		if(sessionUserHabilitation.isSuperUser() ) {
			ongletLdap.bHidden = false;
		}
	}

	if(sessionUserHabilitation.isSuperUser() ) {
		dih.bDisplayExternalReference = true;
	}

	
	switch(organisation.getIdOrganisationType()){
	
	case OrganisationType.TYPE_ACHETEUR_PUBLIC:
        ongletCom.bHidden = false; 
        break;
        
    case OrganisationType.TYPE_ANNONCEUR:
        ongletSynch.bHidden = false; 
        ongletUtil.bHidden = false; 
        break;
        
    case OrganisationType.TYPE_EXTERNAL:
    case OrganisationType.TYPE_EXTERNAL_CASUAL:
		ongletParaphFolder.bHidden = false;
		dih.bDisplayExternalReference = true;
	case OrganisationType.TYPE_FOURNISSEUR:
    case OrganisationType.TYPE_BUSINESS_UNIT:
    case OrganisationType.TYPE_CLIENT:
    case OrganisationType.TYPE_TRAIN_CUSTOMER:
    case OrganisationType.TYPE_HEAD_QUARTER:
    	sUseCaseIdBoutonAjouterDocument = "";
        sUseCaseIdBoutonAfficherDocument = "";
        sUseCaseIdBoutonAjouterEditorial = "";
        sUseCaseIdBoutonAfficherEditorial = "";
        sUseCaseIdBoutonAdminParaph = "";
        ongletCertif.bHidden = true; 
        ongletTranf.bHidden = true; 
        ongletGED.bHidden = true; 
		ongletAR.bHidden = true;
		ongletDelegation.bHidden = true;
		ongletBinder.bHidden = true;
		ongletOwner.bHidden = true;
        break;
    }
	
	if(!sessionUserHabilitation.isHabilitate(sUseCaseIdBoutonActiverCompte))
	{
		ongletUserAccount.bHidden = true; 
	}

	
	if(sessionUserHabilitation.isHabilitate(sUseCaseIdBoutonAfficherDocument))
	{
		ongletGED.bHidden = false; 
	}
	
	if(sessionUserHabilitation.isHabilitate(sUseCaseIdBoutonAfficherEditorial))
	{
		ongletAR.bHidden = false; 
	}
	
	if(!sessionUserHabilitation.isHabilitate("IHM-DESK-PARAM-HAB-DELEG-1")
	&& !sessionUserHabilitation.isHabilitate("IHM-DESK-PARAM-HAB-DELEG-2")
	&& !sessionUserHabilitation.isHabilitate("IHM-DESK-PARAM-HAB-DELEG-6")
	&& !sessionUserHabilitation.isHabilitate("IHM-DESK-PARAM-HAB-DELEG-7"))
	{
		ongletDelegation.bHidden = true; 
	}
	
	
	if(!sessionUserHabilitation.isSuperUser() && sAction.equals("store") ) { dih.bDisplayOwner = false; }
	
	String sTheme = Theme.getTheme();
	if(sTheme.equalsIgnoreCase("veolia")){
		ongletCertif.bHidden = true; 
		ongletGED.bHidden = true; 
		ongletAR.bHidden = true;
		ongletDelegation.bHidden = true;
		sUseCaseIdBoutonAjouterDocument = "";
        sUseCaseIdBoutonAfficherDocument = "";
        sUseCaseIdBoutonAjouterEditorial = "";
        sUseCaseIdBoutonAfficherEditorial = "";
        sUseCaseIdBoutonAdminParaph = "";
        if(ongletBinder!=null) ongletBinder.bHidden = true; 
        dih.bDisplayOwner = false;
		ongletOwner.bHidden = true;
		ongletLdap.bHidden = true;
		ongletScannedSignature.bHidden = true;
	}
	
	/** Parapheur Tabs && Buttons **/
	if (sTheme.equalsIgnoreCase("paraph") || sPersonParamDeskDesignType.equals("outlook")){
	    sUseCaseIdBoutonListeCandidature = "";
	    sUseCaseIdBoutonListeCandidatureAP = "";
	    sUseCaseIdBoutonAjouterDocument = "";
	    sUseCaseIdBoutonAfficherDocument = "";
	    sUseCaseIdBoutonAjouterEditorial = "";
	    sUseCaseIdBoutonAfficherEditorial = "";
	    
	    if (ongletAR != null) ongletAR.bHidden = true;
	    if (ongletCom != null) ongletCom.bHidden = true;
	    if (ongletTranf != null) ongletTranf.bHidden = true;
	    
	    if(!sessionUserHabilitation.isSuperUser()){
			dih.bDisplayOwner = false;

			if(ongletCertif!=null) ongletCertif.bHidden = true; 
			if(ongletBinder!=null) ongletBinder.bHidden = true;
			if(ongletOwner!=null) ongletOwner.bHidden = true;
			if(ongletGraphicChart!=null) ongletGraphicChart.bHidden = true;
			if(ongletScannedSignature!=null) ongletScannedSignature.bHidden = true;
			if(ongletParaphFolderUserDefined!=null) ongletParaphFolderUserDefined.bHidden = false;
			if(ongletNotification!=null) ongletNotification.bHidden = false;		
			if(ongletAutoReload!=null) ongletAutoReload.bHidden = false;
			
			/**
			 * is the user connected ?
			 */
			if(ongletUserAccount != null
			&& (personne.getId() == personneLogue.getId())) {
				ongletUserAccount.bHidden = false;
				if( iIdOnglet == Onglet.ONGLET_PERSONNE_PHYSIQUE_COMPTE_UTILISATEUR)
				{
					dih.bDisplayFullTabUserAccount = false;
					if(sAction.equals("store"))	
					{
						dih.bDisplayFormButton = true;
						dih.bForceModifyPassword = true;
					}
					else
					{
						dih.bDisplayButtonModify = true;
					}
				}
			}
			if(organisation.getIdOrganisationType() ==  OrganisationType.TYPE_ACHETEUR_PUBLIC) {
				dih.bDisplayButtonDisplayOrganization = false;
			}
			
			sUseCaseIdBoutonModifierPersonne= "";
			sUseCaseIdBoutonGenererMotDePasse = "";
			sUseCaseIdBoutonGenererVCard = "";
		}
	}
	
	

	
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId );
%>
<script type="text/javascript" src="<%= rootPath %>dwr/interface/PersonnePhysique.js"></script>
<script type="text/javascript" src="<%= rootPath %>include/verification.js" ></script>
<script type="text/javascript" src="<%= rootPath %>dwr/interface/CheckAjaxVerifField.js"></script>
<script type="text/javascript" src="<%= rootPath %>include/AjaxVerifField.js?v=<%= JavascriptVersionModula.VERIF_FIELD %>" ></script>
<script type="text/javascript" src="<%= rootPath %>include/AjaxComboList.js?v=<%= JavascriptVersion.AJAX_COMBO_LIST_JS %>"></script>
<link rel="stylesheet" type="text/css" href="<%=rootPath %>include/component/calendar/calendar.css" media="screen" />
<script type="text/javascript" src="<%= rootPath %>include/component/calendar/calendar.js"></script>
<script type="text/javascript">

var rootPath = "<%=rootPath%>";

mt.config.enableAutoRoundPave = false;
<% 
	if(userPersonne!=null)
	{
%>
function regeneratePassword()
{
    if(confirm("<%= locMessage.getValue(27,"Do you want regenerate password ?")%>")){
         doUrl('<%= 
         	response.encodeURL(rootPath + "desk/organisation/genererMDP.jsp?iIdUser=" + userPersonne.getIdUser())
			%>');
     }
}

function changeAccountStatus()
{
    if(confirm("<%= locMessage.getValue(28,"Do you want change account status ?") %>")){
         doUrl('<%= 
        		 response.encodeURL(rootPath + "desk/organisation/activerCompte.jsp?iIdUser=" + userPersonne.getIdUser())
				//response.encodeURL(rootPath + "desk/organisation/genererMDP.jsp?iIdUser=" + userPersonne.getIdUser())
			%>');
     }
}
<%
	}
%>
</script>

<%
if(sAction.equals("store"))	
{
%>
<%@ include file="pave/modifierPersonnePhysique.jspf" %>
<%
}

%>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<br/>
<%@include file="pave/paveHeaderPersonnePhysique.jspf" %>	
<br/>
<div class="tabFrame">
<%= Onglet.getAllTabsHtmlDesk(vOnglets) %>
<div class="tabContent">
<%

	if(sessionUserHabilitation.isHabilitate(sUseCaseIdBoutonModifierPersonne)
	 /** or controls if it the owner */
	|| personne.isOwnerIndividual(sessionUser.getIdIndividual())
	/** business rule #2607 : if he is the creator of the organization he can modify the person */
	|| organisation.getIdCreateur() == sessionUser.getIdIndividual()
	)
	{
		if(( iIdOnglet == Onglet.ONGLET_PERSONNE_PHYSIQUE_DONNEES_ADMINISTRATIVES)
		|| ( iIdOnglet == Onglet.ONGLET_PERSONNE_PHYSIQUE_ADRESSE)
		|| ( iIdOnglet == Onglet.ONGLET_PERSONNE_PHYSIQUE_COMPTE_UTILISATEUR)
		)
		{
			if(sAction.equals("store"))	
			{
				dih.bDisplayFormButton = true;
			}
			else
			{
				dih.bDisplayButtonModify = true;
			}
		}
	}
	

    /**
     * TODO_AG :
     * RG1 : ne pas enlever tant que les WS Alice ne sont pas activés
     * RG2 : sauf pour les entreprises n'ayant pas de ref ext
     */
    if(dih.bDisplayButtonModify
    && !Configuration.isEnabledMemory("desk.addressbook.update", true))
    {
        /**
         * Hide the button
         */
         dih.bDisplayButtonModify = false;
        
        if(organisation.getIdOrganisationType() == OrganisationType.TYPE_CANDIDAT)
        {
            if(personne.getReferenceExterne() == null
            || personne.getReferenceExterne().equals(""))
            {
                /**
                 * No synchronization expected, allow modification
                 */
                 dih.bDisplayButtonModify = true;
            }
        }

        /**
         * always ok for the super user
         */
        if(sessionUserHabilitation.isSuperUser() )
        {
        	dih.bDisplayButtonModify = true;
        }
    }   
    

	
	if( dih.bDisplayButtonModify)
	{
	%>
	<div align="right" >
	<button 
		type="button" 
		onclick="<%= response.encodeURL(
			"Redirect('afficherPersonnePhysique.jsp?iIdPersonnePhysique=" + personne.getIdPersonnePhysique()) 
			+ "&iIdOnglet=" + iIdOnglet 
			+ "&sAction=store" %>');"><%= localizeButton.getValueModify() %></button>
	</div>
	<br/>
<%
	}
	
	HtmlBeanTableTrPave hbFormulaire = new HtmlBeanTableTrPave();
	hbFormulaire.bIsForm = false;
	
	if( dih.bDisplayFormButton)
	{
		hbFormulaire.bIsForm = true;
		
%>
	<form action="<%= response.encodeURL("modifierPersonnePhysique.jsp")%>"
		 method="post" 
		 name="formulaire" 
		 id="formulaire" 
		 onsubmit="return checkForm();">
	<div align="right" >
	<input type="hidden" name="sAction" value="store" />
	<input type="hidden" name="iIdOnglet" value="<%= iIdOnglet  %>" />
	<input type="hidden" name="iIdPersonnePhysique" value="<%= personne.getIdPersonnePhysique() %>" />
	
	<button type="submit"><%= localizeButton.getValueSubmit() %></button>
	</div>
	<br/>
	<a name="ancreError"></a>
	<div class="rouge" style="text-align:left" id="divError"></div>
<%
	}

	if(!sMessage.equalsIgnoreCase(""))
	{
	%>
	<div class="rouge" style="text-align:left" id="message"><%= sMessage %></div>
	<br />
	<%
	}

	
	
	
	
	
	if( iIdOnglet == Onglet.ONGLET_PERSONNE_PHYSIQUE_DONNEES_ADMINISTRATIVES)
	{
		boolean bDisplayNationality= Configuration.isTrueMemory("system.addressbook.person.nationality.display", true);
		%><div><%
		if(sAction.equals("store"))
		{
			%>
			<%@ include file="pave/pavePersonnePhysiqueInfosForm.jspf" %><%
			if(dih.bGroupPersoData){
	           %><br/><%@ include file="pave/paveAdresseForm.jspf" %><%
	        }
		}
		else
		{
			%><%@ include file="pave/pavePersonnePhysiqueInfos.jspf" %><%
	        if(dih.bGroupPersoData){
	           %><br/><%@ include file="pave/paveAdresse.jspf" %><%
	         }
		}
		%></div><%
	}
	
	
	
	if( iIdOnglet == Onglet.ONGLET_PERSONNE_PHYSIQUE_BINDER)
	{
		String sUrlRedirect = rootPath + "desk/organisation/afficherPersonnePhysique.jsp?iIdOnglet="+iIdOnglet;
		int iIdObjetReferenceSource = personne.getIdPersonnePhysique();
		long lIdReferenceObjectOwner =  personne.getIdPersonnePhysique();
	%>
	<div>	
<!-- 	
		file="../paraph/folder/binder/displayAllBinder.jsp"
 -->			
	</div>
	<%
	}
	
	
	
	
	
	
	
	
	if( iIdOnglet == Onglet.ONGLET_PERSONNE_PHYSIQUE_ADRESSE)
	{
%><%@ include file="pave/blocGeoLocAddressBook.jspf" %><%
		
%><div><%
		if(sAction.equals("store"))
		{
			if(sessionUserHabilitation.isSuperUser() && bUseZipCodeTownSync )
			{
%><%@ include file="/desk/organisation/pave/blocZipCodeAndTownSyncForAddressBloc.jspf" %><%
			}
%><%@ include file="pave/paveAdresseForm.jspf" %><%
%><%@ include file="pave/blocGeoLocAddressBookFeatureForm.jspf" %><%

		}
		else
		{
%><%@ include file="pave/paveAdresse.jspf" %><%
%><%@ include file="pave/blocGeoLocAddressBookFeature.jspf" %><%
		}
%><%@ include file="pave/blocGeoLocAddressBookMap.jspf" %><%

	}
	
	
	
	


	if( iIdOnglet == Onglet.ONGLET_PERSONNE_PHYSIQUE_COMMISSION)
	{
%>
<jsp:include page="bloc/individual/blocDisplayIndividualCommission.jsp"></jsp:include>		
<%
	}
	
	
	
	
	
	if( iIdOnglet == Onglet.ONGLET_PERSONNE_PHYSIQUE_CERTIFICATS)
	{
%>
<jsp:include page="bloc/individual/blocDisplayIndividualCertificate.jsp"></jsp:include>		
<%
    }
	
	
	
	
	
	
	if( iIdOnglet == Onglet.ONGLET_PERSONNE_PHYSIQUE_EXPORT)
	{
		request.setAttribute("locBloc", locBloc);
		request.setAttribute("locAddressBookButton", locAddressBookButton);
%>
<jsp:include page="bloc/individual/blocDisplayIndividualExport.jsp">
<jsp:param value="<%= iIdOnglet %>" name="iIdOnglet" />
</jsp:include>		
<%
	}
	
	
	if( iIdOnglet == Onglet.ONGLET_PERSONNE_PHYSIQUE_PARAMETRE)
	{
%>
<jsp:include page="bloc/individual/blocDisplayIndividualParameter.jsp">
<jsp:param value="<%= iIdOnglet %>" name="iIdOnglet" />
</jsp:include>		
<%
	}
	
	
	
	
	
 	if(iIdOnglet == Onglet.ONGLET_PERSONNE_PHYSIQUE_CHARTE_GRAPHIQUE){
 		%>
 		<div>
 		<%
 		String sUrlRedirect = rootPath + "desk/organisation/afficherPersonnePhysique.jsp?iIdOnglet="+iIdOnglet;
		%>
			<br />
			<jsp:include page="../multimedia/pave/paveAfficherTousMultimedia.jsp" flush="true" >
					<jsp:param name="sUrlRedirect" value="<%= sUrlRedirect %>" /> 
					<jsp:param name="iIdReferenceObjet" value="<%= 	personne.getId() %>" /> 
					<jsp:param name="iIdTypeObjet" value="<%= ObjectType.PERSONNE_PHYSIQUE %>" /> 
			</jsp:include>
		</div>
		<%
 	}

 	
 	
 	if(iIdOnglet == Onglet.ONGLET_PERSONNE_PHYSIQUE_SCANNED_SIGNATURE){
 		%>
 		<div>
 		<%
 		String sUrlRedirect = rootPath + "desk/organisation/afficherPersonnePhysique.jsp?iIdOnglet="+iIdOnglet;
		%>
			<br />
			<jsp:include page="../multimedia/pave/paveAfficherTousSignature.jsp" flush="true" >
					<jsp:param name="sUrlRedirect" value="<%= sUrlRedirect %>" /> 
					<jsp:param name="iIdReferenceObjet" value="<%= 	personne.getId() %>" /> 
					<jsp:param name="iIdTypeObjet" value="<%= ObjectType.PERSONNE_PHYSIQUE %>" /> 
			</jsp:include>
		</div>
		<%
 	}	
 	
	
	
	if(iIdOnglet == Onglet.ONGLET_PERSONNE_PHYSIQUE_COMPTE_UTILISATEUR)
	{
		%><div><%
		if(sAction.equals("store"))
		{
			%><%@ include file="pave/paveCompteUtilisateurForm.jspf" %><%
		}
		else
		{
			%><%@ include file="pave/paveCompteUtilisateur.jspf" %><%
		}
		%></div><%
	}
	
	
	


	
 	if( iIdOnglet == Onglet.ONGLET_PERSONNE_PHYSIQUE_GED)
	{
%>
<jsp:include page="bloc/individual/blocDisplayIndividualGed.jsp">
<jsp:param value="<%= iIdPersonne %>" name="iIdPersonne"/>
</jsp:include>
<%
	}
 	
 	
 	
 	
 	if( iIdOnglet == Onglet.ONGLET_PERSONNE_PHYSIQUE_AR)
	{
%>
<jsp:include page="bloc/individual/blocDisplayIndividualEditorialHelp.jsp">
<jsp:param value="<%= iIdPersonne %>" name="iIdPersonne"/>
</jsp:include>
<%
	}
 	
 	
 	
 	
	if( iIdOnglet == Onglet.ONGLET_PERSONNE_PHYSIQUE_DELEGATION)
	{
 		%><div><%
 		Vector<Delegation> vDelegation = new Vector<Delegation>();
 		if(sessionUserHabilitation.isHabilitate("IHM-DESK-PARAM-HAB-DELEG-1")
 		|| sessionUserHabilitation.isHabilitate("IHM-DESK-PARAM-HAB-DELEG-2")
 		|| (sessionUserHabilitation.isHabilitate("IHM-DESK-PARAM-HAB-DELEG-6") && sessionUserHabilitation.isHabilitate("IHM-DESK-PARAM-HAB-DELEG-7")) ){
 			vDelegation
			= Delegation.getAllFromPersonnePhysique(personne.getId());
 		}else if(sessionUserHabilitation.isHabilitate("IHM-DESK-PARAM-HAB-DELEG-6")){
 			vDelegation
			= Delegation.getAllFromDelegate(personne.getId());
 		}else if(sessionUserHabilitation.isHabilitate("IHM-DESK-PARAM-HAB-DELEG-7")){
 			vDelegation
			= Delegation.getAllFromOwner(personne.getId());
 		}
 		
 		if(sessionUserHabilitation.isHabilitate("IHM-DESK-PARAM-HAB-DELEG-3")
 		|| sessionUserHabilitation.isHabilitate("IHM-DESK-PARAM-HAB-DELEG-12")
 		|| sessionUserHabilitation.isHabilitate("IHM-DESK-PARAM-HAB-DELEG-13")){
		%>
		<div align="right" >
		<button 
		onclick="javascript:displayDelegation('<%= response.encodeURL( rootPath+
		"desk/organisation/delegation/modifyDelegationForm.jsp?sAction=create"
		+ "&lIdPersonnePhysiqueOwner=" + personne.getIdPersonnePhysique() ) %>')" >
		<%=locAddressBookButton.getValue (40, "Ajouter une délégation") %></button>
		</div>
		<br />
		<%} %>
		<%@ include file="delegation/ongletListDelegation.jspf" %>
		</div><%
	}
	
	
 	if( iIdOnglet == Onglet.ONGLET_PERSONNE_PHYSIQUE_OWNER)
	{
%>
<jsp:include page="bloc/blocDisplayAllIndividualOwned.jsp">
<jsp:param value="<%= iIdOnglet %>" name="iIdOnglet" />
</jsp:include>
<%
	}


 	
 	
 	if( iIdOnglet == Onglet.ONGLET_PERSONNE_PHYSIQUE_PARAPH_FOLDER_TEMPLATE)
	{
%>
	<jsp:include page="/desk/organisation/bloc/individual/blocDisplayIndividualParaphFolderTemplate.jsp">
	<jsp:param value="<%= iIdOnglet %>" name="iIdOnglet" />
	</jsp:include>
<%
	}
 	
 	
 	if( iIdOnglet == Onglet.ONGLET_PERSONNE_PHYSIQUE_LDAP)
	{
 		
 		try {
			String ldapURL = OrganisationParametre.getOrganisationParametreValue(organisation.getIdOrganisation(), "ldap.url");
			String adminName = OrganisationParametre.getOrganisationParametreValue(organisation.getIdOrganisation(), "ldap.admin.username");
			String adminPassword = OrganisationParametre.getOrganisationParametreValue(organisation.getIdOrganisation(), "ldap.admin.password");
			String searchBase =  OrganisationParametre.getOrganisationParametreValue(organisation.getIdOrganisation(), "ldap.search.base");
	
			
			searchBase = 
				PersonnePhysiqueParametre.getPersonnePhysiqueParametreValue(
						personne.getIdPersonnePhysique(), 
						"ldap.cn")
				+ "," + searchBase;
			
			Hashtable env = LdapConnection.getEnv(ldapURL, adminName, adminPassword);

		
			LdapContext ctx = new InitialLdapContext(env,null);
			SearchControls searchCtls = new SearchControls();
			searchCtls.setSearchScope(SearchControls.SUBTREE_SCOPE);
			String searchFilter = "(objectClass=*)";

			String sActionLdap = HttpUtil.parseStringBlank("sActionLdap", request);

			String sTestLogon = "";
			boolean bTestLogonOk = false;
			if(sActionLdap.equals("testPassword")){
				bTestLogonOk = LdapConnection.logon(
						ldapURL, 
						searchBase, 
						HttpUtil.parseStringBlank("testLdapPassword", request));
				
				if(bTestLogonOk) {
					sTestLogon = "Résultat : OK";
				} else{
					sTestLogon = "Résultat : mot de passe incorrect";
				}
			}
%>
<div>
<form action="<%= 
	response.encodeURL(
				rootPath + "desk/organisation/afficherPersonnePhysique.jsp"
				+ "?iIdPersonnePhysique=" + personne.getId()
				+ "&iIdOnglet=" + Onglet.ONGLET_PERSONNE_PHYSIQUE_LDAP
				+ "&sActionLdap=testPassword") 
	%>" method="post" >
<input type="password" name="testLdapPassword" /> <button type="submit" ><%=locAddressBookButton.getValue(38,"Tester mot de passe") %></button> 
<%= sTestLogon %>
</form>
</div>
<br/>
Search base : <%= searchBase %>	<br/><br/>

<%			
			NamingEnumeration answer = ctx.search(searchBase, searchFilter, searchCtls);
			int indexSR = 0;

			while (answer.hasMoreElements()) {
				SearchResult sr = (SearchResult)answer.next();
				indexSR++;
%>
<div id="user_name_<%= indexSR %>" onclick="Element.toggle('user_<%= indexSR %>');" style="cursor: pointer;">
<b><%= searchBase +  sr.getName() %></b>
</div>
<div id="user_<%= indexSR %>" style="display: none;" >
<%						
				Attributes attrs = sr.getAttributes();
				if (attrs != null) {

					try {
						for (NamingEnumeration ae = attrs.getAll();ae.hasMore();) {
							Attribute attr = (Attribute)ae.next();
%>
<%= attr.getID() %> : 
<%							
							for (NamingEnumeration e = attr.getAll();e.hasMore();) {
								Object o = e.next();
%>
								<%= o.toString() %>								
<%
							}
%>
<br/>
<%
						}

					}	 
					catch (Exception e)	{
						e.printStackTrace();
%>
<%= e.getMessage() %>
<%
					}
				
				}
%>
</div>
<%				
			}
			
			ctx.close();
 
		} 
		
		catch (Exception e) {
			e.printStackTrace();
		}
	}
 	
 	if( iIdOnglet == Onglet.ONGLET_PERSONNE_PHYSIQUE_NOTIFICATION){
%>
 	<jsp:include page="pave/ongletNotification.jsp">
 		<jsp:param name="lIdPersonne" value="<%=personne.getId() %>" />
 		<jsp:param name="iIdOnglet" value="<%=iIdOnglet%>" />
 	</jsp:include>
<%
 	}
 	
 	if( iIdOnglet == Onglet.ONGLET_PERSONNE_PHYSIQUE_AUTO_RELOAD){
 		%>
 		 	<jsp:include page="pave/ongletAutoReload.jsp">
 		 		<jsp:param name="lIdPersonne" value="<%=personne.getId() %>" />
 		 		<jsp:param name="iIdOnglet" value="<%=iIdOnglet%>" />
 		 	</jsp:include>
 		<%
 	}
 	
 	
	if( dih.bDisplayFormButton)
	{
%>
</form>
<%
	}
%>
</div>
</div>
<%
	ConnectionManager.closeConnection(conn);
%>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>