
<%@page import="modula.marche.joue.MarcheJoueInfo"%>
<%@page import="mt.modula.affaire.param.MarcheVolume"%>
<%@page import="mt.modula.affaire.param.MarcheVolumeType"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="org.coin.db.CoinDatabaseLoadException"%><%@page import="mt.modula.affaire.type.MarcheTypeExtension"%>
<%@page import="mt.modula.affaire.publication.PublicationUtil"%>
<%@page import="modula.journal.Evenement"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="modula.Validite"%>
<%@page import="org.coin.bean.conf.Configuration"%>
<%@page import="org.coin.bean.boamp.BoampException"%>
<%@page import="modula.marche.correspondant.CorrespondantMarche"%>
<%@page import="modula.marche.joue.MarcheJoueFormulaire"%>
<%@page import="modula.marche.justification.*"%>
<%@page import="modula.marche.geo.MarcheCodeNuts"%>
<%@ page import="modula.configuration.*,java.sql.*,modula.marche.*,java.util.*,modula.algorithme.*,org.coin.fr.bean.*,modula.graphic.*,org.coin.bean.*" %>
<%@ include file="/include/beanSessionUser.jspf" %>
<%
	String sAction = request.getParameter("sAction");
	Marche marche = null;
	if(!sAction.equals("create"))
	{
		int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	    marche = Marche.getMarche(iIdAffaire);
	}
%>
<%@ include file="/desk/include/useBoamp17.jspf" %>
<%@ include file="/desk/include/typeForm.jspf" %>
<%
	
	String sTitle = "Résultat de la création de l'affaire";
	String rootPath = request.getContextPath()+"/";
	String sFormPrefix = "";

	int iIdOnglet = HttpUtil.parseInt("iIdOnglet", request, 0);
	Connection conn = ConnectionManager.getConnection();
    
	boolean bIsContainsAAPCPublicity = true;
	boolean bIsContainsEnveloppeAManagement = true;
	boolean bIsContainsCandidatureManagement = true;
	boolean bForcedNegociation = false;
	boolean bIsLinkedPublicityAndCandidature = true;
	boolean bIsRectification =  false;

	int iIdTypeProcedure = -1;
	if(marche != null)
	{
		
		//PROCEDURE
		bIsContainsAAPCPublicity = AffaireProcedure.isContainsAAPCPublicity(marche.getIdAlgoAffaireProcedure());
		bIsContainsEnveloppeAManagement = AffaireProcedure.isContainsEnveloppeAManagement(marche.getIdAlgoAffaireProcedure());
		bIsContainsCandidatureManagement = AffaireProcedure.isContainsCandidatureManagement(marche.getIdAlgoAffaireProcedure());
		bIsLinkedPublicityAndCandidature = AffaireProcedure.isPublicityAndCandidatureLinked(marche.getIdAlgoAffaireProcedure());
		
		iIdTypeProcedure = AffaireProcedure.getTypeProcedure(marche.getIdAlgoAffaireProcedure());
		
		/* exception pour les proc qui font intervenir une phase de négociation dans une procédure non négociée */
		bForcedNegociation = AffaireProcedure.isForcedNegociationManagement(marche.getIdAlgoAffaireProcedure());
		
		// la valeur sera mise à jour si l'on arrive jusqu'au marche.store();
		marche.setDateModification(new Timestamp(System.currentTimeMillis()));
		try 
		{
			marche.setOngletInstancie(iIdOnglet , true);
		} 
		catch (Exception e) {}
		
		bIsRectification =  marche.isAffaireEnCoursDeRectification(false);	
	}
	
	if(sAction.equals("create"))
	{
		String sReference = request.getParameter("sReference");
		String sObjet = request.getParameter("sObjet");
		int iIdCommission = Integer.parseInt(request.getParameter("iIdCommission"));
		marche = new Marche();
		marche.setIdCommission(iIdCommission);
		marche.setReference(sReference);
		marche.setObjet(sObjet);
		marche.setIdCreateur(sessionUser.getIdIndividual());
		
		/* initialisation des status */
		marche.setDelaiUrgence(Integer.parseInt(Configuration.getConfigurationValueMemory(ModulaConfiguration.MODULA_MARCHE_DELAI_URGENCE_DEFAUT)));
		marche.initNewMarche();			
		marche.setFromFormPaveProcedure(request,sFormPrefix);
		marche.create(conn);
			
		Validite oValiditeMarche = new Validite();
		oValiditeMarche.setIdTypeObjetModula(ObjectType.AFFAIRE);
		oValiditeMarche.setIdReferenceObjet(marche.getIdMarche());
		oValiditeMarche.setDateDebut(new Timestamp(System.currentTimeMillis()));
		oValiditeMarche.create(conn);
		
		int iIdPhase = 0;
		String sRedirectURL = "afficherAffaire.jsp";
		String sEvenement = "Creation d'une affaire";
		marche.setAffaireAAPC(true);
		marche.setIdAlgoAffaireProcedure(AffaireProcedure.AFFAIRE_PROCEDURE_INDEFINI_AAPC);
		
		
		AffaireProcedure affProc = AffaireProcedure.getAffaireProcedureMemory(marche.getIdAlgoAffaireProcedure());
        
		if(!bUseBoamp17){
			iIdPhase = Integer.parseInt(request.getParameter("iIdPhase"));
		}else{
			MarcheProcedure proc = new MarcheProcedure();
			proc.setIdMarche(marche.getId());
			proc.setFromForm(request,sFormPrefix);
			proc.create(conn);
			
			marche.storeFromFormPaveProcedure(request, sFormPrefix);
			affProc = AffaireProcedure.getAffaireProcedureMemory(marche.getIdAlgoAffaireProcedure());
			
			iIdPhase = affProc.getIdPhaseDemarrage();
			sEvenement += " (traitement: " +AffaireProcedureType.getAffaireProcedureTypeNameMemory(affProc.getIdType())+") ";
		}

		switch(iIdPhase)
		{
			case Phase.PHASE_CREATION:
				marche.setAffaireAAPC(true);
				if(!bUseBoamp17)
					marche.setIdAlgoAffaireProcedure(AffaireProcedure.AFFAIRE_PROCEDURE_INDEFINI_AAPC);
				sEvenement += " en phase AAPC";
				break;
				
			case Phase.PHASE_CREATION_AATR:
				marche.setAffaireAATR(true);
				if(!bUseBoamp17)
					marche.setIdAlgoAffaireProcedure(AffaireProcedure.AFFAIRE_PROCEDURE_INDEFINI_AATR);
				sRedirectURL = "afficherAttribution.jsp";
				sEvenement += " en phase AATR";
				break;
		}
		iIdTypeProcedure = AffaireProcedure.getTypeProcedure(marche.getIdAlgoAffaireProcedure());
		bForcedNegociation = AffaireProcedure.isForcedNegociationManagement(marche.getIdAlgoAffaireProcedure());
		
		int iIdAffMarco =  HttpUtil.parseInt("iIdAffaireMarco" , request, -1);
		if ( (iIdAffMarco != -1) )
		{
			marche.storeFromMarcoImport(iIdAffMarco);
		}
		
		Vector<MarcheLot> vlots = MarcheLot.getAllLotsFromMarche(marche.getIdMarche());
		for(int i =0;i<vlots.size();i++)
		{
			MarcheLot oMarcheLot = vlots.get(i);
			oMarcheLot.setAttribue(false);
			
			if(iIdTypeProcedure == AffaireProcedure.TYPE_PROCEDURE_NEGOCIE || bForcedNegociation) 
				oMarcheLot.setEnCoursDeNegociation(true);	
			else 
				oMarcheLot.setEnCoursDeNegociation(false);
			
			oMarcheLot.store(conn);
		}
		
		
		/**
		* Traitement des exports des publications officielles
		*/
		marche.updateExportPublicationsOfficielles(request,"");
		PublicationUtil.updateAllPublication(marche, request);
		
		/**
		 * only fr the AOO 
		 */
		 
		int iIdPassation 
         = AffaireProcedure
             .getAffaireProcedureMemory(
            		 affProc.getId(),
                     false,
                     conn).getIdMarchePassation();
		
		if(iIdPassation == MarchePassation.APPEL_OFFRES_OUVERT )
		{
	        MarcheParametre.updateParam(marche, "iIdProcedureSimpleEnveloppe", request);
		} 
		
		
		/**
		 * MarcheVolumeType
		 */
		long lIdMarcheVolumeType = HttpUtil.parseLong("lIdMarcheVolumeType", request);
		MarcheVolume.updateMarcheVolumeFromIdMarche(marche.getId(), lIdMarcheVolumeType);
	
		Evenement.addEvenement(
				marche.getIdMarche(), 
				"IHM-DESK-AFF-1", 
				sessionUser.getIdUser(), 
				sEvenement );
		
		response.sendRedirect( 
			response.encodeRedirectURL(sRedirectURL+"?iIdOnglet=" + iIdOnglet 
			+ "&iIdAffaire=" + marche.getIdMarche()
			+"&nonce=" + System.currentTimeMillis() 
			+"&#ancreHP"));
		
		
		ConnectionManager.closeConnection(conn);
		return;
	}

	if(sAction.equals("storeNoForm"))
	{
		modula.journal.Evenement.addEvenement(marche.getIdMarche(), "IHM-DESK-AFF-51", sessionUser.getIdUser(), "");
		marche.store(conn);
		
		response.sendRedirect( 
			response.encodeRedirectURL("afficherAffaire.jsp?iIdOnglet=" + iIdOnglet 
				+ "&iIdAffaire=" + marche.getIdMarche()
			+"&nonce=" + System.currentTimeMillis() 
			+"&#ancreHP" ));
			
		ConnectionManager.closeConnection(conn);
		return;
	}
	
	if(!sAction.equals("store"))
	{
		response.sendRedirect( 
			response.encodeRedirectURL("afficherAffaire.jsp?iIdOnglet=" + iIdOnglet 
					+ "&iIdAffaire=" + marche.getIdMarche()
					+"&nonce=" + System.currentTimeMillis() 
					+"&#ancreHP") );
		
		ConnectionManager.closeConnection(conn);
		return;
	
	}

	
	// ici on est en traitement du Store uniquement
	
	if(iIdOnglet == Onglet.ONGLET_AFFAIRE_OBJET)
	{
		marche.setFromFormPaveObjetMarche(request,"");
		marche.setFromFormPaveTypeMarche(request,"");
		marche.setFromFormPaveLieux(request, "");

        MarcheTypeExtension.updateTypeMarcheExtension(marche.getId(),marche.getIdMarcheType(),request,"");
        
		MarcheAdresse.updateAll(marche, bUseBoamp17, bUseFormNS, request);
		
		/* Création des compétences du marché */
		marche.setFromFormPaveCPF(request,"");
			
		// BOAMP17
		// Pavé activité pouvoir adjudicateur 
		if(bUseBoamp17 && (bUseFormNS || bUseFormUE))
		{
			MarcheActiviteAdjudicateurSelected.updateAll(marche.getId(), request);
			MarcheCodeNuts.updateAll(marche,request);
		}
		
		/* TRAITEMENT DES CODE NUTS */
		if(bUseFormNS || bUseFormUE)
		{	
			MarcheCPVObjet.updateAll(marche,request);
			MarcheJoueInfo.updateAll(marche,request);
		}
		
	    /**
         * MarcheVolumeType
         */
        long lIdMarcheVolumeType = HttpUtil.parseLong("lIdMarcheVolumeType", request);
        MarcheVolume.updateMarcheVolumeFromIdMarche(marche.getId(), lIdMarcheVolumeType);

		
		marche.store(conn);
	}
	
	if(iIdOnglet == Onglet.ONGLET_AFFAIRE_CARACTERISTIQUES)
	{
		marche.setFromFormPaveCaracPrincipales(request, "");
		marche.store(conn);

		if(bUseBoamp17 && (bUseFormNS || bUseFormUE) ) {
			MarcheCaracteristique.updateAll(marche.getId(), request);
		}	
	}
	
	if(iIdOnglet == Onglet.ONGLET_AFFAIRE_CONDITIONS)
	{
		marche.setFromFormPaveConditions(request, sFormPrefix);
		Langue.updateAll(marche, request);
			
		
		MarcheSystemeQualification.updateAll(marche.getId(), request);
		MarcheJustificationSelected.updateAll(marche.getId(), request);
		MarcheConditionParticipation.updateAll(marche.getId(), request); 
		MarcheJoueInfo.updateAll(marche,request);
		MarcheNombreCandidat.updateAll(marche.getId(), request);
		MarcheConditionRelative.updateAll(marche.getId(), request);
		MarcheJustificationCommentaire.updateAll(marche.getId(), request);
		MarcheJustificationAutreRenseignement.updateAll(marche.getId(), request);
	
		marche.store(conn);
	}
	
	
	
	if(iIdOnglet == Onglet.ONGLET_AFFAIRE_CRITERES)
	{
		marche.storeFromFormPaveProcedure(request, sFormPrefix);
		marche.storeFromFormPaveCriteres(request,sFormPrefix);
		MarcheProcedure.updateAll(marche.getId(), sFormPrefix, request);
		marche.store();
		
		if(bUseBoamp17)
		{
			MarcheEnchereElectronique.updateAll(marche.getId(), request);
		}
		
		
	    /**
         * only fr the AOO 
         */
         if(!bIsRectification){
	        AffaireProcedure affProc = AffaireProcedure.getAffaireProcedureMemory(marche.getIdAlgoAffaireProcedure());
	         
	        int iIdPassation 
	         = AffaireProcedure
	             .getAffaireProcedureMemory(
	                     affProc.getId(),
	                     false,
	                     conn).getIdMarchePassation();
	        
	        if(iIdPassation == MarchePassation.APPEL_OFFRES_OUVERT )
	        {
	            MarcheParametre.updateParam(marche, "iIdProcedureSimpleEnveloppe", request);
	        } else {
	        	/**
	        	 * need to remove it
	        	 */
	        	MarcheParametre.removeParam(marche, "iIdProcedureSimpleEnveloppe");
	        }
         }
	}
		
	if(iIdOnglet == Onglet.ONGLET_AFFAIRE_AUTRES)
	{
		marche.setFromFormPaveRenseignements(request, "");
		marche.setFromFormPaveRenseignementsDce(request, "");
		marche.setFromFormPaveRecompense(request, "");
		marche.setFromFormPavePiecesDemandees(request, "");
		marche.setFromFormPaveAutresRenseignements(request, "");
		marche.setFromFormPaveAutresRenseignementsDce(request, "");
		marche.store(conn);
		
		
		if(bUseBoamp17)
		{
			MarcheAccordCadre.updateAll(marche.getId(), request);
			MarcheAutreRenseignement.updateAll(marche.getId(), request);
			if(bUseFormMAPA)
			{
				MarcheIndexation.updateAll(marche.getId(), request);
			}
			
			if(bUseFormNS || bUseFormUE)
			{
				MarcheProcedureRecours.updateAll(marche.getId(), request);
			}			
		}		
	}
	
	if(iIdOnglet == Onglet.ONGLET_AFFAIRE_PLANNING)
	{
		/* Définition des informations du pavé Procedure */
		 if(!bIsRectification){
			try{
				//marche.updateExportPublicationsOfficielles(request,"");
				/* en avis recif on désactive le pave pub officielle */
				marche.setFromFormPavePublicationsOfficielles(request, ""); 
			} catch (BoampException e) {
				throw new ServletException(e.getMessage());
			}
		 }
		
		//marche.setFromFormPavePublicationsOfficielles(request, ""); 
		marche.setFromFormPaveDelais(request, "");
		marche.setFromFormPaveDureeMarche(request, "");
		marche.setFromFormPavePlanningPrevisionnel(request, "");
		
		if(!bIsRectification){
			marche.setFromFormPavePublications(request, "");
		}
		
		marche.store(conn);

		MarcheValidite.updateAll(
	    		marche,
	    		iIdTypeProcedure,
				bIsContainsEnveloppeAManagement,
	    		bIsContainsAAPCPublicity,
	    		bForcedNegociation,
	    		bIsLinkedPublicityAndCandidature,
	    		request) ;

		MarcheLot.updateAllValidite(marche);
		
		
		/* DELAI URGENCE */
		if(bIsContainsCandidatureManagement)
		{
			marche.setDelaiUrgence(Integer.parseInt(request.getParameter("iDelaiUrgence")));
		}
		else
		{
			marche.setDelaiUrgence(0);
		}
		
		marche.store(conn);
		
		if(!bIsRectification){
			PublicationUtil.updateAllPublication(marche, request);
		}
	}
		
	if(iIdOnglet == Onglet.ONGLET_AFFAIRE_LOTS)
	{
		marche.setFromFormPaveGestionLots(request,"");
		marche.store(conn);
		
		
		String sHiddenRedirectURL = "";
		if(request.getParameter("sHiddenRedirectURL") != null)
			sHiddenRedirectURL = org.coin.security.PreventInjection
				.preventStore(request.getParameter("sHiddenRedirectURL"));
					

		MarcheLot.updateAll(marche, iIdTypeProcedure, bForcedNegociation,request);			
	
		if(sHiddenRedirectURL.equalsIgnoreCase(""))
		{
			response.sendRedirect( 
				response.encodeRedirectURL(
					"afficherAffaire.jsp?iIdOnglet=" + iIdOnglet 
					+ "&iIdAffaire=" + marche.getIdMarche()
					+"&nonce=" + System.currentTimeMillis() 
					+"&#ancreHP") );
		
			return;
		}
		
		ConnectionManager.closeConnection(conn);
		response.sendRedirect(response.encodeRedirectURL(sHiddenRedirectURL));
		return;
		
	}
	
	if(iIdOnglet == Onglet.ONGLET_AFFAIRE_ORGANISME)
	{
		CorrespondantMarche.updateAll(marche,bUseBoamp17,request,response);
		MarcheJoueInfo.updateAll(marche,request);
		marche.store(conn);
	}
		
	
	if(iIdOnglet == Onglet.ONGLET_AFFAIRE_ANNULATION)
	{
		marche.setMotifAnnulation(request.getParameter( "sMotifAnnulation"));
		marche.store(conn);
	}
	
	if( iIdOnglet == Onglet.ONGLET_AFFAIRE_JOUE)
	{
		MarcheJoueFormulaire.removeAllFromIdMarche(marche.getId());
		MarcheJoueFormulaire.updateAll(marche.getId(), request);
		MarchePublicationJoue.updateAll(marche.getId(), request);
		AvisRectificatifRubrique.updateRubriqueJoue(marche.getIdMarche(), request);
		marche.store(conn);
	}
	
	
	if(iIdOnglet == Onglet.ONGLET_AFFAIRE_DCE)
	{
		// on a bien modifié le DCE
		marche.store(conn);
	}

	response.sendRedirect( response.encodeRedirectURL("afficherAffaire.jsp?iIdOnglet=" + iIdOnglet 
		+ "&iIdAffaire=" + marche.getIdMarche()
		+"&nonce=" + System.currentTimeMillis() + "&#ancreHP"));


	
	ConnectionManager.closeConnection(conn);

%>