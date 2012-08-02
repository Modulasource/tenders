
<%@page import="modula.marche.joue.MarcheJoueInfo"%><%@page import="modula.marche.joue.MarcheJoueFormulaire"%>
<%@page import="org.coin.bean.boamp.BoampException"%>
<%@page import="org.coin.db.CoinDatabaseAbstractBean"%>
<%@page import="org.coin.fr.bean.export.PublicationBoamp"%>
<%@page import="modula.marche.geo.MarcheCodeNuts"%>

<%@ page import="modula.algorithme.*,modula.marche.cpv.*,org.coin.fr.bean.*,org.coin.bean.*, modula.candidature.*,org.coin.util.*,java.sql.*,modula.marche.*" %>
<%@ page import="java.util.*, modula.*,modula.graphic.*" %>
<%@ include file="/include/beanSessionUser.jspf" %>
<%@ include file="/desk/include/useBoamp17.jspf" %>
<%

	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);

	%><%@ include file="/desk/include/typeForm.jspf" %><%
	
	/**
	 * permet de savoir si l'affaire a commencé sur un AAPC ou un AATR
	 */
	boolean bStartWithAATR = false;
	
	AffaireProcedure proc = AffaireProcedure.getAffaireProcedureMemory(marche.getIdAlgoAffaireProcedure());
	if(proc.getIdPhaseDemarrage() == Phase.PHASE_CREATION_AATR)
	{
		bStartWithAATR = true;
	}
	
	String sTitle = "Résultat de la création de l'avis d'attribution";
	String rootPath = request.getContextPath()+"/";
	String sFormPrefix = "";
	int iIdOnglet = HttpUtil.parseInt("iIdOnglet", request, 0);
	String sAction = request.getParameter("sAction");
	
	String sAttribution = "";
	if(request.getParameter("sAttribution") != null)
		sAttribution = request.getParameter("sAttribution");
	
	Vector<MarcheLot> vLotsAttribues = MarcheLot.getAllLotsAttribuesFromMarche(marche.getIdMarche()); 
	Vector<MarcheLot> vLots = MarcheLot.getAllLotsFromMarche(marche.getIdMarche()); 
	
	AvisAttribution avis = AvisAttribution.getAvisAttributionFromMarche(marche.getIdMarche());
	avis.setDateModification(new Timestamp(System.currentTimeMillis()));
	try
	{
		avis.setOngletInstancie(iIdOnglet , true);
	}
	catch(Exception e){}

	int iIdTypeProcedure = AffaireProcedure.getTypeProcedure(marche.getIdAlgoAffaireProcedure());
	boolean bForcedNegociation = AffaireProcedure.isForcedNegociationManagement(marche.getIdAlgoAffaireProcedure());
	boolean bIsRectification =  marche.isAffaireEnCoursDeRectification(false);	
	
	if(sAttribution.equalsIgnoreCase("attribution"))
	{
		for (int i = 0; i < vLots.size(); i++)
		{
			MarcheLot lot = vLots.get(i);
			
			int iStatutLot = -1;
			if(request.getParameter(sFormPrefix+"selectStatut"+lot.getIdMarcheLot()) != null)
				iStatutLot = Integer.parseInt(request.getParameter(sFormPrefix+"selectStatut"+lot.getIdMarcheLot()));
			
			switch(iStatutLot)
			{
				case 0:
					lot.setInfructueux(true);
					lot.setAttribue(false);
					break;
				
				case 1:
					lot.setAttribue(true);
					lot.setInfructueux(false);
					int iIdCandidature = -1;
					if(request.getParameter(sFormPrefix+"iIdCandidature"+lot.getIdMarcheLot()) != null)
						iIdCandidature = Integer.parseInt(request.getParameter(sFormPrefix+"iIdCandidature"+lot.getIdMarcheLot()));
					if(iIdCandidature > 0)
					{
						Vector<EnveloppeB> vEnvBSupp = EnveloppeB.getAllEnveloppesBAttribueesDefinitifFromLotAndValidite(lot.getIdMarcheLot(),lot.getIdValiditeEnveloppeBCourante());
						for(int j=0;j<vEnvBSupp.size();j++)
						{
							EnveloppeB envB = vEnvBSupp.get(j);
							envB.setAttribueedefinitif(false);
							envB.setAttribuee(false);
							envB.store();
						}
						
						Vector<EnveloppeB> vEnvB = EnveloppeB.getAllEnveloppeBFromCandidatureAndLotAndValidite(iIdCandidature,lot.getIdMarcheLot(),lot.getIdValiditeEnveloppeBCourante());
						for(int j=0;j<vEnvB.size();j++)
						{
							EnveloppeB envB = vEnvB.get(j);
							envB.setAttribueedefinitif(true);
							envB.setAttribuee(true);
							envB.store();
						}
					}
					else
					{
						Vector<EnveloppeB> vEnvBSupp = EnveloppeB.getAllEnveloppesBAttribueesDefinitifFromLotAndValidite(lot.getIdMarcheLot(),lot.getIdValiditeEnveloppeBCourante());
						for(int j=0;j<vEnvBSupp.size();j++)
						{
							EnveloppeB envB = vEnvBSupp.get(j);
							envB.setAttribueedefinitif(false);
							envB.store();
						}
					}
					
					break;
			}
			
			if(iStatutLot != -1) lot.store();
		}
		response.sendRedirect(response.encodeRedirectURL("afficherAttribution.jsp?iIdOnglet=" + iIdOnglet + "&iIdAffaire=" + marche.getIdMarche()+"&sAction=store&#ancreHP"));
		return;
	}
	
	if(!sAction.equals("store"))
	{
		response.sendRedirect(response.encodeRedirectURL("afficherAttribution.jsp?iIdOnglet=" + iIdOnglet + "&iIdAffaire=" + marche.getIdMarche()+"&#ancreHP"));
		return;
	}
	String sPageUseCaseId = "IHM-DESK-AFF-26"; 
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId );

if(iIdOnglet == Onglet.ONGLET_ATTRIBUTION_OBJET)
{
	marche.setFromFormPaveObjetMarche(request,"");
	marche.setFromFormPaveTypeMarche(request,"");
	marche.setFromFormPaveLieux(request, "");
	
	MarcheJoueInfo.updateAll(marche,request);
	
	String sPrefixLieuExecution = "lieu_execution_";
	String sPrefixLieuLivraison = "lieu_livraison_";
	if(bUseBoamp17 && bUseFormNS){
		sPrefixLieuLivraison = sPrefixLieuExecution;
	}
	if (marche.getIdLieuExecution() <= 0)
	{
		// l'adresse n'existe pas
		Adresse adresseLieuExecution = new Adresse();
		adresseLieuExecution.setFromForm(request , sPrefixLieuExecution);
		adresseLieuExecution.create();
		marche.setIdLieuExecution( adresseLieuExecution.getIdAdresse() );
	}
	else
	{
		Adresse adresseLieuExecution = null;
		adresseLieuExecution = Adresse.getAdresse( marche.getIdLieuExecution() );
		adresseLieuExecution.setFromForm(request , sPrefixLieuExecution );
		adresseLieuExecution.store();
	}
	
	if (marche.getIdLieuLivraison() <= 0)
	{
		// l'adresse n'existe pas
		Adresse adresseLieuLivraison = new Adresse();
		adresseLieuLivraison.setFromForm(request , sPrefixLieuLivraison );
		adresseLieuLivraison.create();
		marche.setIdLieuLivraison( adresseLieuLivraison.getIdAdresse() );
	}
	else
	{
		Adresse adresseLieuLivraison = null;
		adresseLieuLivraison = Adresse.getAdresse( marche.getIdLieuLivraison() );
		adresseLieuLivraison.setFromForm(request , sPrefixLieuLivraison );
		adresseLieuLivraison.store();
	}
	/* Création des compétences du marché */
	marche.setFromFormPaveCPF(request,"");
	
//	 BOAMP17
	// Pavé activité pouvoir adjudicateur 
	if(bUseBoamp17)
	{
		MarcheActiviteAdjudicateurSelected.removeAllFromIdMarche(marche.getId());
		MarcheActiviteAdjudicateurSelected maas 
			= new MarcheActiviteAdjudicateurSelected();
		maas.setIdReferenceObjet(marche.getId());
		maas.setIdTypeObjet(ObjectType.AFFAIRE);
		
		Enumeration enumMAAEntiteAdjudicatrice = request.getParameterNames();
		while(enumMAAEntiteAdjudicatrice.hasMoreElements()) 
		{
			String key = (String)enumMAAEntiteAdjudicatrice.nextElement();
			if(key.startsWith("cbMarcheActiviteAdjudicateurSelected") )
			{
				String[] splitKey = key.split("_");
				maas.setIdMarcheActiviteAdjudicateur(Long.parseLong(splitKey[1]));
				maas.create();
			}
		}
		
		String sMAAEntiteAdjudicatriceAutre = request.getParameter("sMAAEntiteAdjudicatriceAutre");
		maas.setIdMarcheActiviteAdjudicateur(MarcheActiviteAdjudicateur.ID_POUVOIR_ADJUDICATEUR_AUTRE);
		maas.setAutre(sMAAEntiteAdjudicatriceAutre );
		maas.create();
		
	}
	// FIN Pavé activité pouvoir adjudicateur 
	
	/* TRAITEMENT DES CODE NUTS */
	
	MarcheCodeNuts marcheCodeNuts = new MarcheCodeNuts ();
	marcheCodeNuts.remove(" WHERE id_marche=" + marche.getId());
	marcheCodeNuts.setIdMarche(marche.getId());
	marcheCodeNuts.setIdCodeNuts(request.getParameter("sIdCodeNuts"));
	if(marcheCodeNuts.getIdCodeNuts() != null 
	&& !marcheCodeNuts.getIdCodeNuts().equals("")){
		marcheCodeNuts.create();
	} 
		
	/* TRAITEMENT DES NOMENCLATURES */
	/* Suppression des nomenclatures */
	/* Récupération de l'ancien MarcheCPVObjet */
	Vector vAncienCPVObjet = MarcheCPVObjet.getAllMarcheCPVObjetFromMarche(marche.getIdMarche());
	for (int k = 0; k < vAncienCPVObjet.size(); k++)
	{
		MarcheCPVObjet ancienCPVObjet = (MarcheCPVObjet)vAncienCPVObjet.get(k);
		Vector vAncienCPVDescripteur = CPVDescripteur.getAllCPVDescripteur(ancienCPVObjet.getIdMarcheCpvObjet());
		for (int i = 0; i < vAncienCPVDescripteur.size(); i++)
		{
			CPVDescripteur ancienCPVDescripteur = (CPVDescripteur)vAncienCPVDescripteur.get(i);
			Vector vAncienDescSupp = 
				CPVDescripteurSupplementaire
					.getAllCPVDescripteurSupplementaireFromDescripteur(
						ancienCPVDescripteur.getIdCpvDescripteur());
						
			for (int j = 0; j < vAncienDescSupp.size(); j++)
			{
				CPVDescripteurSupplementaire ancienDescSupp 
					= (CPVDescripteurSupplementaire)vAncienDescSupp.get(j);
				ancienDescSupp.remove();
			}
			ancienCPVDescripteur.remove();
		}
		ancienCPVObjet.remove();
	}
	
	/* Création des nomenclatures CPV */
	for(int i=0;i<4;i++)
	{
		String sFieldNameDescPrincipal
			= "sIdDescripteurPrincipal" + i;
			
		if (!Outils.isNullOrBlank(request.getParameter(sFieldNameDescPrincipal)) )
		{
			MarcheCPVObjet cpvObjetsup = new MarcheCPVObjet();
			cpvObjetsup.setIdMarche(marche.getIdMarche());
			cpvObjetsup.setCpvType(
				i==0?MarcheConstant.CPV_PRINCIPAL:MarcheConstant.CPV_SUPPLEMENTAIRE);
				
			cpvObjetsup.create();
			
			CPVDescripteur cpvDescripteur = new CPVDescripteur();
			cpvDescripteur.setCpvDescripteurType(MarcheConstant.CPV_PRINCIPAL);
			cpvDescripteur.setIdCpvPrincipal(request.getParameter(sFieldNameDescPrincipal));
			cpvDescripteur.setIdMarcheCpv(cpvObjetsup.getIdMarcheCpvObjet());
		
			cpvDescripteur.create();

			for (int j = 0; j < 3; j++)
			{
				String sFieldNameDescSupp
					= "iIdDescripteurSupp" + i + "_" + j ;
					
				if (!request.getParameter(sFieldNameDescSupp).equals(""))
				{
					CPVDescripteurSupplementaire cpvSupp = new CPVDescripteurSupplementaire();
					cpvSupp.setId(cpvDescripteur.getIdCpvDescripteur());
					cpvSupp.setName(request.getParameter(sFieldNameDescSupp));
					cpvSupp.create();
				}
			
			}
		}
	}
	avis.store();
	marche.store();
}
if(iIdOnglet == Onglet.ONGLET_ATTRIBUTION_CRITERES)
{
	marche.storeFromFormPaveProcedure(request, sFormPrefix);
	marche.storeFromFormPaveCriteres(request, sFormPrefix);
	MarcheProcedure.updateAll(marche.getId(), sFormPrefix, request);
	marche.store();
	
	if(bUseBoamp17)
	{
		MarcheEnchereElectronique.updateAll(marche.getId(), request);
	}
	
	avis.store();
}
if(iIdOnglet == Onglet.ONGLET_ATTRIBUTION_LOTS)
{
	marche.setFromFormPaveGestionLots(request,"");
	marche.store();
	
	int iLotissement = -1;
	if(request.getParameter("iLotissement") != null)
		iLotissement = Integer.parseInt(request.getParameter("iLotissement"));

	String sHiddenRedirectURL = "";
	if(request.getParameter("sHiddenRedirectURL") != null)
		sHiddenRedirectURL = org.coin.security.PreventInjection.preventStore(request.getParameter("sHiddenRedirectURL"));
		
	boolean bNego = false;
	if(iIdTypeProcedure == AffaireProcedure.TYPE_PROCEDURE_NEGOCIE || bForcedNegociation)
		bNego = true;
							
	// traitement des lots
	if(iLotissement == 2)
	{
		vLots = MarcheLot.getAllLotsFromMarche(marche.getIdMarche());
		
		if( (vLots == null) || (vLots.size() < 2) )
		{
			if(vLots != null)
			{
				// on supprime les lot 
				for (int i = 0; i < vLots.size(); i++) 
				{
					vLots.get(i).removeWithObjectAttached();
				}
			}
			
			// il n'y a pas encore de lot, il faut créer les deux premier
			MarcheLot lot1 = new MarcheLot ();
			MarcheLot lot2 = new MarcheLot ();

			lot1.setIdMarche( marche.getIdMarche() );
			lot1.setReference( "Lot 1" );
			lot1.setNumero(1);
			lot1.setEnCoursDeNegociation(bNego);
			lot1.setAttribue(false);
			lot1.create();

			lot2.setIdMarche( marche.getIdMarche() );
			lot2.setReference( "Lot 2" );
			lot2.setNumero(2);
			lot2.setAttribue(false);
			lot2.setEnCoursDeNegociation(bNego);
			lot2.create();
		}		
	}
	else
	{
		// on supprime les lots si besoin
		vLots = MarcheLot.getAllLotsFromMarche(marche.getIdMarche());
		if(vLots != null) 
		{
			if (vLots.size() != 1 )
			{
				// on a pas le compte au niveau des lots...
				for (int i = 0; i < vLots.size(); i++) 
				{
					vLots.get(i).removeWithObjectAttached();
				}
		
				// il n'y a pas encore de lot, il faut créer l'UNIQUE lot
				MarcheLot lot1 = new MarcheLot ();
				
				lot1.setIdMarche( marche.getIdMarche() );
				lot1.setReference( "Non Alloti" );
				lot1.setNumero(1);
				lot1.setEnCoursDeNegociation(bNego);
				lot1.create();
	
			}
		}		
		marche.setPresentationOffre(3);
		marche.store();		
	}
	try
	{
		vLots = MarcheLot.getAllLotsFromMarche(marche.getIdMarche());
		for(int i=0;i<vLots.size();i++)
		{
			MarcheLot lot = vLots.get(i);
			lot.setIdValiditeEnveloppeBCourante(Validite.getAllValiditeEnveloppeBFromAffaire(iIdAffaire).firstElement().getIdValidite());
			lot.store();
		}
	}
	catch(Exception e){}
	
	avis.store();
	if(sHiddenRedirectURL.equalsIgnoreCase(""))
	{
		response.sendRedirect( 
		response.encodeRedirectURL(
			"afficherAttribution.jsp?iIdOnglet=" + iIdOnglet 
			+ "&iIdAffaire=" + marche.getIdMarche()
			+"&nonce=" + System.currentTimeMillis() 
			+"&#ancreHP") );
			
		return;
	}
	
	response.sendRedirect(response.encodeRedirectURL(sHiddenRedirectURL));
	return;
}
if(iIdOnglet == Onglet.ONGLET_ATTRIBUTION_ORGANISME)
{
	/* Définition des informations du pavé Acheteur Public */
	if (request.getParameter("iIdPRM") != null
		&& Integer.parseInt(request.getParameter("iIdPRM")) > 0)
	{
		Vector<Correspondant> vCorrespondantPRM = Correspondant.getAllCorrespondantFromTypeAndReferenceObjetAndFonction(ObjectType.AFFAIRE,marche.getIdMarche(),PersonnePhysiqueFonction.PRM);
		Correspondant oCorrespondantPRM = null;
		CorrespondantInfo oCorrespondantPRMInfo = null;
    	if(vCorrespondantPRM.size() == 1)
    	{
			oCorrespondantPRM = vCorrespondantPRM.firstElement();
			oCorrespondantPRM.setIdPersonnePhysique(Integer.parseInt(request.getParameter("iIdPRM")));
			oCorrespondantPRM.store();
			oCorrespondantPRMInfo = CorrespondantInfo.getAllFromCorrespondant(oCorrespondantPRM.getIdCorrespondant()).firstElement();
			oCorrespondantPRMInfo.setFromForm(request,"PRM_");
			oCorrespondantPRMInfo.store();
		}
		else
		{
			oCorrespondantPRM = new Correspondant();
			oCorrespondantPRM.setIdPersonnePhysique(Integer.parseInt(request.getParameter("iIdPRM")));
			oCorrespondantPRM.setIdPersonnePhysiqueFonction(PersonnePhysiqueFonction.PRM);
			oCorrespondantPRM.setIdTypeObjet(ObjectType.AFFAIRE);
			oCorrespondantPRM.setIdReferenceObjet(marche.getIdMarche());
			oCorrespondantPRM.create();
			
			oCorrespondantPRMInfo = new CorrespondantInfo();
			oCorrespondantPRMInfo.setIdCorrespondant(oCorrespondantPRM.getIdCorrespondant());
			oCorrespondantPRMInfo.setFromForm(request,"PRM_");
			oCorrespondantPRMInfo.create();
		}
	}
	marche.store();
	avis.store();
}
if(iIdOnglet == Onglet.ONGLET_ATTRIBUTION_TITULAIRES)
{
	for (int i = 0; i < vLotsAttribues.size(); i++)
	{
		MarcheLot lot = vLotsAttribues.get(i);

		/* Récupération des informations du pavé Montant */
		sFormPrefix = "paveMontant" + i;
			
		if (request.getParameter(sFormPrefix + "iChoixMontant") != null)
		{
			switch(Integer.parseInt(request.getParameter(sFormPrefix + "iChoixMontant")))
			{
				case 1:  // Montant en valeur HT
					if (request.getParameter(sFormPrefix + "sMontant") != null)
						lot.setMontantLot(request.getParameter(sFormPrefix + "sMontant"));
						lot.setOffreBasse("");
						lot.setOffreHaute("");
					break;
				case 2:	// Offre la plus basse et la plus haute
					if (request.getParameter(sFormPrefix + "sOffreBasse") != null)
						lot.setOffreBasse(request.getParameter(sFormPrefix + "sOffreBasse"));
					if (request.getParameter(sFormPrefix + "sOffreHaute") != null)
						lot.setOffreHaute(request.getParameter(sFormPrefix + "sOffreHaute"));
					lot.setMontantLot("");
					break;
			}
		}
		/* /Récupération des informations du pavé Montant */
		
		/* Récupération des informations du pavé SousTraitance */
		sFormPrefix = "paveSousTraitance" + i;
		if (request.getParameter(sFormPrefix + "iSousTraitance") != null)
		{
			switch (Integer.parseInt(request.getParameter(sFormPrefix + "iSousTraitance")))
			{
				/* si il n'y a pas de sous traitance */
				case 2:
						lot.setPartSousTraitance("");
						lot.setTypeSousTraitance(0);
						lot.setSousTraite(false);
						break;
				/* sinon */
				case 1:
					if (request.getParameter(sFormPrefix + "iPartSousTraitance") != null)
					{
						switch (Integer.parseInt(request.getParameter(sFormPrefix + "iPartSousTraitance")))
						{
							case MarcheLot.PART_VALEUR:
								if (request.getParameter(sFormPrefix + "sValeur") != null)
									lot.setPartSousTraitance(request.getParameter(sFormPrefix + "sValeur"));
									lot.setTypeSousTraitance(MarcheLot.PART_VALEUR);
								break;
								
							case MarcheLot.PART_POURCENTAGE:
								if (request.getParameter(sFormPrefix + "sPourcentage") != null)
									lot.setPartSousTraitance(request.getParameter(sFormPrefix + "sPourcentage"));
									lot.setTypeSousTraitance(MarcheLot.PART_POURCENTAGE);
									break;
									
							case MarcheLot.REPONSE_INCONNUE:
								lot.setPartSousTraitance("");
								lot.setTypeSousTraitance(MarcheLot.REPONSE_INCONNUE);
								break;
						}
						lot.setSousTraite(true);
					}
					break;
				}
			}
			
		lot.store();
	}

	if (request.getParameter(sFormPrefix + "sMontantTotal") != null)
		avis.setMontantMarche(request.getParameter(sFormPrefix + "sMontantTotal"));

	modula.journal.Evenement.addEvenement(avis.getIdAvisAttribution(), "IHM-DESK-AFF-26", sessionUser.getIdUser(),"avis d'attribution du marché ref."+marche.getReference());
	avis.store();
}

if(iIdOnglet == Onglet.ONGLET_ATTRIBUTION_RENSEIGNEMENTS_PUBLICATION)
{
	sFormPrefix = "";
	
	/**
	* Traitement des exports des publications officielles
	*/
	if(!bIsRectification && bStartWithAATR){
		try{
			marche.updateExportPublicationsOfficielles(request,"");
		} catch (BoampException e) {
			throw new ServletException(e.getMessage());
		}
	}
	
	if (request.getParameter(sFormPrefix + "sPetiteAnnonceTexteLibre") != null)
		avis.setPetiteAnnonceTexteLibre(request.getParameter(sFormPrefix + "sPetiteAnnonceTexteLibre"));
	
	/* Récupération des infos concernant les rectifications */

	if (request.getParameter(sFormPrefix + "tsDatePublicationAATR") != null)
		avis.setDateEnvoiAvisAttribution(
			CalendarUtil.getConversionTimestamp(request.getParameter(sFormPrefix + "tsDatePublicationAATR") + " 00:00"));

	Vector<Validite> vValiditesAATR = Validite.getAllValiditeAATRFromAffaire(iIdAffaire);
	Validite oValiditeAATR = null;
	
	if(vValiditesAATR != null)
	{
		//System.out.println("vValiditesAATR size:"+vValiditesAATR.size());
		if(vValiditesAATR.size() == 0)
		{
			oValiditeAATR = new Validite();
			oValiditeAATR.create();
		}
		else if(vValiditesAATR.size() == 1)
		{
			oValiditeAATR = vValiditesAATR.firstElement();
		}
		else if(vValiditesAATR.size() > 1){
			oValiditeAATR = vValiditesAATR.firstElement();
			for(int iVal=1;iVal<vValiditesAATR.size();iVal++){
				new Validite().remove(vValiditesAATR.get(iVal).getId());
				//System.out.println("remove validite :"+vValiditesAATR.get(iVal).getId());
			}
		}
	}
	
	oValiditeAATR.setFromForm(request,"AATR_");
	int iDureePublication = Integer.parseInt(request.getParameter("AATR_sDureePublication"));

	
	long iTimeDebut = oValiditeAATR.getDateDebut().getTime();
	Timestamp tsDateFin = new Timestamp(iTimeDebut);
	tsDateFin.setTime(tsDateFin.getTime()+(iDureePublication*24*60*60*1000));
	oValiditeAATR.setDateFin(tsDateFin);
	oValiditeAATR.store();
	
	Vector<AvisRectificatif> vAvisRect = AvisRectificatif.getAllAvisRectificatifWithType(iIdAffaire,AvisRectificatifType.TYPE_AATR);
	for(int i=0;i<vAvisRect.size();i++)
	{
		Validite oValiditeRect = Validite.getValidite(ObjectType.AVIS_RECTIFICATIF,vAvisRect.get(i).getIdAvisRectificatif());
		oValiditeRect.setDateFin(oValiditeAATR.getDateFin());
		oValiditeRect.store();
	}
	
	String sAATRFormat="";
	sFormPrefix = "AATR_";
	if (request.getParameter(sFormPrefix + "sAATRFormat") != null)
		sAATRFormat = request.getParameter(sFormPrefix + "sAATRFormat");
	if( sAATRFormat.equals("automatique")) avis.setAATRAutomatique(true);
	else avis.setAATRAutomatique(false); 

	
	if(request.getParameter("bExportBoampDefined").equals("true"))
	{
		//sFormPrefix = "";
		
		PublicationBoamp publicationBoamp  
			= (PublicationBoamp)CoinDatabaseAbstractBean.getOrNewAbstractBean(
					Long.parseLong(request.getParameter("iIdPublication")), 
					new PublicationBoamp(), 
					true);
		
		publicationBoamp.setFromFormPhaseAATR(request, "");
		
		/*try {
	        publicationBoamp.setDateEnvoi(
	        		CalendarUtil.getConversionTimestamp(
	        				request.getParameter(sFormPrefix + "tsDateEnvoi"), "dd/MM/yyyy"));
		} catch (Exception e) {}
        publicationBoamp.setDateEnvoiEffective(publicationBoamp.getDateEnvoi());

		try {
	        publicationBoamp.setDatePublication(
	        		CalendarUtil.getConversionTimestamp(
	        				request.getParameter(sFormPrefix + "tsDatePublication"), "dd/MM/yyyy"));
		} catch (Exception e) {}
	    */
				
		publicationBoamp.store();
	    /*
		sFormPrefix = "marche_";
		try {
			marche.setDateEnvoiBOAMP(
	        		CalendarUtil.getConversionTimestamp(
	        				request.getParameter(sFormPrefix + "tsDateEnvoiBOAMP"), "dd/MM/yyyy"));
		} catch (Exception e) {}

		marche.setNumCommandeBOAMP(request.getParameter(sFormPrefix + "sNumCommandeBOAMP"));
		marche.setDepPublicationBOAMP(request.getParameter(sFormPrefix + "sDepPublicationBOAMP"));
		*/
		marche.store();
	
	
	}
	MarcheProcedure marProc = null;
	try {
		marProc = MarcheProcedure.getFromMarche(marche.getIdMarche());
	} catch (Exception e) {
		marProc = new MarcheProcedure();
	}
	
	if(marProc.getIdBoampFormulaireType() == BoampFormulaireType.TYPE_MAPA)
	{
		MarcheIndexation marcheIndexation = null;
		try {
			marcheIndexation  =  MarcheIndexation.getMarcheIndexationFromIdMarche(marche.getId());
		}catch (Exception e ) {
			marcheIndexation  = new MarcheIndexation();
			marcheIndexation.remove(" WHERE id_marche=" + marche.getId());
			marcheIndexation.setIdMarche(marche.getId());
			marcheIndexation.create();
		}	
		marcheIndexation.setFromForm(request, "MarcheIndexation_");
		marcheIndexation.store();
	}
	
	Vector<Validite> vValiditeAAPC = Validite.getAllValiditeAAPCFromAffaire(iIdAffaire);
	Validite oValiditePublication = null;
	if(vValiditeAAPC != null  && vValiditeAAPC.size() == 1)
	{
		oValiditePublication = vValiditeAAPC.firstElement();
		oValiditePublication.setFromForm(request,"AAPC_RELATIF_");
		oValiditePublication.store();
	}else {
		oValiditePublication = new Validite();
		oValiditePublication.setFromForm(request,"AAPC_RELATIF_");
		oValiditePublication.create();
	}

	modula.journal.Evenement.addEvenement(avis.getIdAvisAttribution(), "IHM-DESK-AFF-26", sessionUser.getIdUser(),"avis d'attribution du marché ref."+marche.getReference());
	avis.store();
}

if(iIdOnglet == Onglet.ONGLET_ATTRIBUTION_RENSEIGNEMENTS_COMPLEMENTAIRES)
{
	sFormPrefix = "";
	/* Récupération de la date d'attribution */
	if (request.getParameter(sFormPrefix + "tsDateAttribution") != null)
		avis.setDateAttributionMarche(CalendarUtil.getConversionTimestamp(
				request.getParameter(sFormPrefix + "tsDateAttribution") + " 00:00"));

	/* Récupération du nombre total d'offres reçues */
	if ( (request.getParameter(sFormPrefix + "iNbOffre") != null)
		&& (!request.getParameter(sFormPrefix + "iNbOffre").equalsIgnoreCase("")) )
		avis.setNbOffres(Integer.parseInt(request.getParameter(sFormPrefix + "iNbOffre")));

	/* Récupération des autres infos */
	if (request.getParameter(sFormPrefix + "sAutresInfosAATR") != null)
		avis.setAutresInfos(request.getParameter(sFormPrefix + "sAutresInfosAATR"));

	/* Récupération du nombre de participants */
	if ( (request.getParameter(sFormPrefix + "iNbParticipants") != null)
		&& (!request.getParameter(sFormPrefix + "iNbParticipants").equalsIgnoreCase("")) )
		avis.setNbParticipants(Integer.parseInt(request.getParameter(sFormPrefix + "iNbParticipants")));

	/* Récupération du nombre de participants étrangers */
	if ( (request.getParameter(sFormPrefix + "iNbParticipantsEtrangers") != null)
		&& (!request.getParameter(sFormPrefix + "iNbParticipantsEtrangers").equalsIgnoreCase("")) )
		avis.setNbParticipantsEtrangers(Integer.parseInt(request.getParameter(sFormPrefix + "iNbParticipantsEtrangers")));

	/* Récupération de la valeur de la prime attribuée */
	if (request.getParameter(sFormPrefix + "sPrimesAATR") != null)
		avis.setValeurPrime(request.getParameter(sFormPrefix + "sPrimesAATR"));

	modula.journal.Evenement.addEvenement(avis.getIdAvisAttribution(), "IHM-DESK-AFF-26", sessionUser.getIdUser(),"avis d'attribution du marché ref."+marche.getReference());
	avis.store();
}

if( iIdOnglet == Onglet.ONGLET_ATTRIBUTION_JUSTIFICATIF_NEGOCIE){
	
	boolean bIsAdjudicateur = false;
	boolean bIsAdjudicatrice = false;
	Enumeration enumRequestParam = request.getParameterNames();
    while(enumRequestParam.hasMoreElements()) 
    {
        String key = (String)enumRequestParam.nextElement();
        if(key.startsWith("choixJustif") )
        {
            String[] splitKey = key.split("_");
            int iIdJustif = Integer.parseInt(splitKey[1]);
            JustifMarcheNegocie justifMarche = JustifMarcheNegocie.getJustifMarcheNegocie(iIdJustif);
            if(justifMarche.getIdJustifNegocieType() == JustifNegocieType.POUVOIR_ADJUDICATEUR) {
            	bIsAdjudicateur = true;
            } else if(justifMarche.getIdJustifNegocieType() == JustifNegocieType.ENTITE_ADJUDICATRICE) {
            	bIsAdjudicatrice = true;
            }
        }
    }
    
    if(bIsAdjudicateur && bIsAdjudicatrice) {
    	response.sendRedirect(
                response.encodeRedirectURL(
                        "afficherAttribution.jsp?iIdOnglet=" + iIdOnglet 
                                + "&iIdAffaire=" + marche.getIdMarche()
                                + "&sAction=store"
                                + "&bErrorJustifNegoc=true"));
    	return;
    } else {
    	   MarcheJustifNegocie.updateAll(marche.getIdMarche(), request);
    }
}

if( iIdOnglet == Onglet.ONGLET_ATTRIBUTION_JOUE)
{
    MarcheJoueFormulaire.removeAllFromIdMarche(marche.getId());
    MarcheJoueFormulaire.updateAll(marche.getId(), request);
    MarchePublicationJoue.updateAll(marche.getId(), request);
    marche.store();
    /**
     * pour instancier l'onglet
     */
    avis.store();
}


	response.sendRedirect(
			response.encodeRedirectURL(
					"afficherAttribution.jsp?iIdOnglet=" + iIdOnglet 
							+ "&iIdAffaire=" + marche.getIdMarche()+"&#ancreHP"));

%>
