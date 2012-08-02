
<%@page import="org.coin.security.PreventInjection"%>
<%@page import="mt.common.addressbook.AddressBookOwner"%>
<%@page import="mt.common.addressbook.habilitation.AddressBookHabilitation"%>
<%@page import="org.coin.bean.ws.AddressBookWebService"%>
<%@page import="org.coin.bean.conf.Configuration"%>
<%@page import="org.coin.bean.ws.ConfigurationWebService"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="org.coin.bean.ws.OrganisationWebService"%>
<%@page import="modula.marche.MarcheActiviteAdjudicateur"%>
<%@page import="java.util.Enumeration"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="modula.marche.MarcheActiviteAdjudicateurSelected"%>
<%@ page import="org.coin.fr.bean.*,modula.*,org.coin.util.*,modula.graphic.*" %>
<%@ page import="modula.journal.*" %> 
<%@ include file="/desk/include/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath()+"/";
	Connection conn = ConnectionManager.getConnection();
	session.setAttribute("conn", conn);
	
	int iIdOrganisation = -1;
	Organisation organisation = null;
	try
	{
		iIdOrganisation = Integer.parseInt(request.getParameter("iIdOrganisation"));
		organisation = Organisation.getOrganisation(iIdOrganisation, false, conn);
	}
	catch(Exception e){}
	
	int iIdOnglet = -1;
	try{iIdOnglet = Integer.parseInt(request.getParameter("iIdOnglet"));}
	catch(Exception e){}
	

	PersonnePhysique personActor 
		= PersonnePhysique.getPersonnePhysique(
				sessionUser.getIdIndividual(), false, conn);

	/**
	 * habilitations
	 */
	String sPageUseCaseId = AddressBookHabilitation.getUseCaseForModifyOrganization(organisation, personActor);
	boolean bHab = sessionUserHabilitation.isHabilitate(sPageUseCaseId );
	if(!bHab 
	&& organisation.isOwnerIndividual(sessionUser.getIdIndividual() ) )
	{
		sPageUseCaseId = "IHM-DESK-ORG-14";
	}
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId , conn);

	boolean bGroupAdminData = false; 
	boolean bGroupPersoData = false;
	switch(organisation.getIdOrganisationType() )
	{
        case OrganisationType.TYPE_BUSINESS_UNIT:
        	bGroupAdminData = true;
        	bGroupPersoData = true;
            break;
        case OrganisationType.TYPE_CLIENT:
        	bGroupAdminData = true;
        	bGroupPersoData = true;
            break;
        case OrganisationType.TYPE_TRAIN_CUSTOMER:
            bGroupAdminData = true;
            bGroupPersoData = true;
            break;
        case OrganisationType.TYPE_FOURNISSEUR:
        	bGroupAdminData = true;
        	bGroupPersoData = true;
            break;
        case OrganisationType.TYPE_HEAD_QUARTER:
            bGroupAdminData = true;
            bGroupPersoData = true;
            break;
      	case OrganisationType.TYPE_EXTERNAL_COMPANY:
            bGroupAdminData = true;
            bGroupPersoData = true;
            break;
      	case OrganisationType.TYPE_EXTERNAL:
            bGroupAdminData = true;
            bGroupPersoData = true;
            break;
        case OrganisationType.TYPE_EXTERNAL_CASUAL:
            bGroupAdminData = true;
            bGroupPersoData = true;
            break;
       	case OrganisationType.TYPE_LEASING_COMPANY:
            bGroupAdminData = true;
            bGroupPersoData = true;
            break;
       	case OrganisationType.TYPE_MAINTENANCE_COMPANY:
            bGroupAdminData = true;
            bGroupPersoData = true;
            break;
    }
	

	if( iIdOnglet == Onglet.ONGLET_ORGANISATION_DONNEES_ADMINISTRATIVES)
	{
		String sIdPays = Pays.FRANCE;
		try{
			Adresse adresse = Adresse.getAdresse(organisation.getIdAdresse(), true, conn);
			sIdPays = adresse.getIdPays();
		}catch(Exception e){sIdPays = Pays.FRANCE;}
		if(Outils.isNullOrBlank(sIdPays)) sIdPays = Pays.FRANCE;
		
		organisation.setFromFormDonneesAdministratives(request,sIdPays, "");
		/**
		 * unselect part
		 */
		
		int iIdCategorieJuridique = HttpUtil.parseInt("iIdCategorieJuridique", request, 0) ;
		int iIdCodeNaf = HttpUtil.parseInt("iIdCodeNaf", request, 0) ;
		organisation.setIdCodeNaf(iIdCodeNaf);
		//organisation.setIdCategorieJuridique(iIdCategorieJuridique);
		
		organisation.setRaisonSociale(PreventInjection.preventStore(organisation.getRaisonSociale()));
				
		organisation.store(conn);
		
		try {
			MarcheActiviteAdjudicateurSelected.removeAllFromIdOrganisation(organisation.getId());
			MarcheActiviteAdjudicateurSelected maas 
				= new MarcheActiviteAdjudicateurSelected();
			maas.setIdReferenceObjet(organisation.getId());
			maas.setIdTypeObjet(ObjectType.ORGANISATION);
			
			Enumeration enumMAAEntiteAdjudicatrice = request.getParameterNames();
			while(enumMAAEntiteAdjudicatrice.hasMoreElements()) 
			{
				String key = (String)enumMAAEntiteAdjudicatrice.nextElement();
				if(key.startsWith("cbMarcheActiviteAdjudicateurSelected") )
				{
					String[] splitKey = key.split("_");
					maas.setIdMarcheActiviteAdjudicateur(Long.parseLong(splitKey[1]));
					maas.create(conn);
				}
			}
			
			String sMAAEntiteAdjudicatriceAutre = request.getParameter("sMAAEntiteAdjudicatriceAutre");
			maas.setIdMarcheActiviteAdjudicateur(MarcheActiviteAdjudicateur.ID_POUVOIR_ADJUDICATEUR_AUTRE);
			maas.setAutre(sMAAEntiteAdjudicatriceAutre );
			maas.create(conn);
		} catch (Exception e) {
			//e.printStackTrace();
		}
		if(bGroupPersoData)
			iIdOnglet = Onglet.ONGLET_ORGANISATION_COORDONNEES;
	}

	if( iIdOnglet == Onglet.ONGLET_ORGANISATION_COORDONNEES)
	{
		organisation.setFromFormCoordonnees(request, "");
		organisation.store(conn);
		
	    if(bGroupPersoData)
	    	iIdOnglet = Onglet.ONGLET_ORGANISATION_ADRESSE;
	}

	if( iIdOnglet == Onglet.ONGLET_ORGANISATION_ADRESSE)
	{
		Adresse adresse = Adresse.getAdresse(organisation.getIdAdresse(), true, conn);
		adresse.setFromForm(request, "");
		adresse.store(conn); 
		
		if(bGroupPersoData)
            iIdOnglet = Onglet.ONGLET_ORGANISATION_DONNEES_ADMINISTRATIVES;
	}
	
	if(iIdOnglet == Onglet.ONGLET_ORGANISATION_ADMIN && bGroupAdminData){
		iIdOnglet = Onglet.ONGLET_ORGANISATION_INFORMATION_PUBLICATION;
	}

	if( iIdOnglet == Onglet.ONGLET_ORGANISATION_INFORMATION_PUBLICATION)
	{
		int iCompteBOAMP = HttpUtil.parseInt("BOAMP_bCompteBOAMP",request,0);
		        		
		if(iCompteBOAMP == 1){			

			String sTvaIntra = HttpUtil.parseString("sTvaIntra", request, "");
			organisation.setTvaIntra(sTvaIntra);
	        organisation.setFromFormUpdateBoampInfo(request, "");
	        int iIdOrganisationClasseProfit = HttpUtil.parseInt("iIdOrganisationClasseProfit", request, 0);
	        organisation.setIdOrganisationClasseProfit(iIdOrganisationClasseProfit);
	        organisation.store();
			
			try{
			    BOAMPProperties boampProperties = BOAMPProperties.getBOAMPPropertiesFromOrganisation(organisation.getIdOrganisation());
				boampProperties.setIdOrganisation(organisation.getIdOrganisation());
				boampProperties.setFromForm(request, "BOAMP_");
				boampProperties.store(conn);
				Adresse adresseExpedition = Adresse.getAdresse(boampProperties.getIdAdresseExpedition(), false,  conn);
				adresseExpedition.setFromForm(request, "BOAMP_adresse_expedition_");
				adresseExpedition.store(conn);
				
				Adresse adresseFacturation = Adresse.getAdresse(boampProperties.getIdAdresseFacturation(), false,  conn);
				adresseFacturation.setFromForm(request, "BOAMP_adresse_facturation_");
				adresseFacturation.store(conn);
				
			}catch(Exception e){
				Adresse adresseFacturation = new Adresse();
				adresseFacturation.setFromForm(request, "BOAMP_adresse_facturation_");
				adresseFacturation.create(conn);
				Adresse adresseExpedition = new Adresse();
				adresseExpedition.setFromForm(request, "BOAMP_adresse_expedition_");
				adresseExpedition.create(conn);
				BOAMPProperties boampProperties = new BOAMPProperties();
				boampProperties.setFromForm(request, "BOAMP_");
				boampProperties.setIdOrganisation(organisation.getIdOrganisation());
				boampProperties.setIdAdresseExpedition(adresseExpedition.getIdAdresse());
				boampProperties.setIdAdresseFacturation(adresseFacturation.getIdAdresse()); 
				boampProperties.create(conn);
			}
		}
		else{
			try{
			    BOAMPProperties boampProperties = BOAMPProperties.getBOAMPPropertiesFromOrganisation(organisation.getIdOrganisation());
				boampProperties.remove(conn);
			}catch(Exception e){}
		}
		
		if(bGroupAdminData)
            iIdOnglet = Onglet.ONGLET_ORGANISATION_CHARTE_GRAPHIQUE;
	}
	if( iIdOnglet == Onglet.ONGLET_ORGANISATION_CHARTE_GRAPHIQUE){
		OrganisationGraphisme graphisme = null;
		try{
			graphisme = OrganisationGraphisme.getAllFromOrganisation(organisation.getIdOrganisation()).firstElement();
			graphisme.setFromForm(request,"");
			graphisme.store(conn);
		}catch(Exception e){
			graphisme = new OrganisationGraphisme();
			graphisme.setIdOrganisation(organisation.getIdOrganisation());
			graphisme.setFromForm(request,"");
			graphisme.create(conn);
		}
		
		if(bGroupAdminData)
            iIdOnglet = Onglet.ONGLET_ORGANISATION_ADMIN;
	}
	
	if( iIdOnglet == Onglet.ONGLET_ORGANISATION_OWNER){
		long own_lIdObjectTypeOwned = HttpUtil.parseLong("own_lIdObjectTypeOwned", request);
		long own_lIdObjectReferenceOwned = HttpUtil.parseLong("own_lIdObjectReferenceOwned", request);
		
		AddressBookOwner.linkObject(
				own_lIdObjectTypeOwned, 
				own_lIdObjectReferenceOwned,
				organisation,
				conn);
	}
	
	
	
	/**
     * Web Service
     */
    if(AddressBookWebService.isActivated(conn))
    {
	    try{
	        OrganisationWebService wsOrga = AddressBookWebService.newInstanceOrganisationWebService(conn);
	        if(wsOrga.isSynchronized(organisation, conn)){
	            wsOrga.synchroStore(organisation, conn);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
    }    

	try
	{
		Evenement.addEvenement(organisation.getIdOrganisation(), sPageUseCaseId, sessionUser.getIdUser(), "" );
	}
	catch(Exception e){}

	response.sendRedirect(
		response.encodeRedirectURL("afficherOrganisation.jsp?iIdOrganisation=" 
			+ organisation.getIdOrganisation()
			+ "&iIdOnglet=" + iIdOnglet));

    ConnectionManager.closeConnection(conn);

%>