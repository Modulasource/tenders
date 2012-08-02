
<%@page import="org.coin.bean.boamp.BoampCPFItem"%>
<%@page import="org.coin.db.CoinDatabaseException"%>
<%@page import="modula.marche.Marche"%>
<%@page import="modula.commission.Commission"%>
<%@page import="org.coin.util.Outils"%>
<%@page import="org.coin.security.PreventInjection"%>
<%@page import="org.coin.util.XMLEntities"%>
<%@page import="org.coin.util.WindowsEntities"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="modula.journal.Evenement"%>

<%@ page import="org.coin.fr.bean.export.*, modula.*,java.sql.*,java.util.*, modula.algorithme.*, org.coin.fr.bean.*,org.coin.bean.*" %>
<%@ include file="/include/beanSessionUser.jspf" %>
<%

	Marche marche = null;
	try{
		marche = Marche.getMarche(HttpUtil.parseInt("iIdAffaire", request));
	} catch (CoinDatabaseException e ) {}


	String sTitle = "Résultat de la création de l'affaire";
	String rootPath = request.getContextPath()+"/";
	String sFormPrefix = "";
	int iIdOnglet= HttpUtil.parseInt("iIdOnglet", request, 0);
	String sAction = HttpUtil.parseStringBlank("sAction", request);
	
	// la valeur sera mise à jour si l'on arrive jusqu'au marche.store();
	//marche.setDateModification(new Timestamp(System.currentTimeMillis()));

	try {
		marche.setOngletInstancie(iIdOnglet , true);
	} catch (Exception e) {
		// TODO : Pourquoi un affichage de l'erreur, c'est normal ou non ?
		//e.printStackTrace();
	}
	
	if(sAction.equals("remove"))
	{ 
		String sPageUseCaseId = "IHM-DESK-PA-4";
		sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
		sTitle = "Suppression de la petite annonce";
		String sMessTitle = "";
		String sMess = "";
		String sUrlIcone = "";
		String sUrlRedirect = "";
		sMessTitle = "Succ&egrave;s de l'&eacute;tape";
		sMess = "Votre petite annonce a été supprimée.";
		sUrlIcone = modula.graphic.Icone.ICONE_SUCCES;
		sUrlRedirect = rootPath+"desk/marche/petitesAnnonces/afficherToutesPetitesAnnonces.jsp#ancreHP";
		
		int iIdOrganisation = marche.getIdOrganisationFromMarche();
		
		
		session.setAttribute("sessionPageTitre", sTitle);
		session.setAttribute("sessionMessageTitre", sMessTitle);
		session.setAttribute("sessionMessageLibelle", sMess);
		session.setAttribute("sessionMessageUrlIcone", sUrlIcone);
		session.setAttribute("sessionMessageUrlRedirect", sUrlRedirect);
		marche.removeWithObjectAttached();
		
		sUrlRedirect = rootPath+"include/afficherMessageDesk.jsp";
        
		
		if(HttpUtil.parseStringBlank("sPageRedirect", request).equals("prepareAvisRecapitulatif"))
		{
			sUrlRedirect = rootPath+"desk/marche/avis_recap/prepareAvisRecapitulatif.jsp"
					+ "?lId=" + iIdOrganisation
					+ "&iIdAffaire=" + marche.getIdMarche();
		}
		
		response.sendRedirect(
				response.encodeRedirectURL(
						sUrlRedirect
						));
		return;
	}
	
	if(sAction.equals("create"))
	{	
		String sReference = request.getParameter("sReference");
		String sObjet = request.getParameter("sObjet");
		marche = new Marche();
		marche.setIdCommission(Integer.parseInt(request.getParameter("iIdCommission")));
		marche.setIdCreateur(sessionUser.getIdIndividual());
		/* initialisation des status */
		try{
			int iTypeAnnonce = Integer.parseInt(request.getParameter("typeAnnonce"));
			switch(iTypeAnnonce){
			case 1:
				marche.setAffaireAAPC(true);
				marche.setAffaireAATR(false);
				break;
			case 2:
				marche.setAffaireAAPC(false);
				marche.setAffaireAATR(true);
				break;
			case 3:
				marche.setAffaireAAPC(false);
				marche.setAffaireAATR(true);
				marche.setRecapAATR(true);
				break;
			}
		}catch(Exception e){}

		if (request.getParameter("isGrouped").equals("1")) marche.setPAGrouped(true); else marche.setPAGrouped(false);
		
		marche.setLectureSeule(false);
		marche.setCandidaturesCloses(false);
		marche.setAffairePublieeSurPublisher(false);
		marche.setOffresCloses(false);
		marche.setAffaireCloturee(false);
		marche.setAffaireValidee(false);
		marche.setAAPCAutomatique(false);
		marche.setPetiteAnnonceFormat("libre");
		marche.setIdAlgoAffaireProcedure(AffaireProcedure.AFFAIRE_PROCEDURE_PETITE_ANNONCE);
		PhaseEtapes oPhaseEtapes 
			= AlgorithmeModula.getFirstPhaseEtapesInProcedure(
					AffaireProcedure.getAffaireProcedureMemory(
							marche.getIdAlgoAffaireProcedure()).getIdProcedure());
		try
		{
			marche.setIdAlgoPhaseEtapes(oPhaseEtapes.getId());
		}
		catch(Exception e)
		{
			System.out.println("Exception > importerFichierPetitesAnnonces.jsp: "+e.getMessage());
		}
		try 
		{
			if ((request.getParameter("iIdMarchePassation") !="")&&(request.getParameter("iIdMarchePassation")!=null)){
				marche.setPetiteAnnoncePassation(Integer.parseInt(request.getParameter("iIdMarchePassation")));
			}
		} catch (Exception e) {}

		marche.setDateCreation(new Timestamp(System.currentTimeMillis())); 
		marche.setDateModification(new Timestamp(System.currentTimeMillis()));
		
		
		marche.create();
		Validite oValiditeMarche = new Validite();
		oValiditeMarche.setIdTypeObjetModula(ObjectType.AFFAIRE);
		oValiditeMarche.setIdReferenceObjet(marche.getIdMarche());
		oValiditeMarche.setDateDebut(new Timestamp(System.currentTimeMillis()));
		oValiditeMarche.create();
		try{
			Organisation organisation = null;
			try{
				organisation = Organisation.getOrganisation(PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual()).getIdOrganisation());
			}
			catch(Exception e){System.out.println("La personne loguée n'a pas d'organisme");}
			if ((organisation!=null)
				&&(organisation.getIdOrganisationType()== OrganisationType.TYPE_PUBLICATION)
				&&(organisation.isClientSPQR()))
			{
				Export exportAFF = new Export(); 
				exportAFF.setName(organisation.getRaisonSociale());
				exportAFF.setDateCreation(new Timestamp(System.currentTimeMillis()));
				exportAFF.setIdTypeObjetSource(ObjectType.AFFAIRE);
				exportAFF.setIdTypeObjetDestination(ObjectType.ORGANISATION);
				exportAFF.setIdObjetReferenceSource(marche.getIdMarche());
				exportAFF.setIdObjetReferenceDestination(organisation.getIdOrganisation());
				exportAFF.setIdExportSens(Export.SENS_EXPORT);
				exportAFF.create();
			
				PublicationSpqr publication = new PublicationSpqr();
				publication.setIdTypeObjet(ObjectType.AFFAIRE);
				publication.setIdReferenceObjet(marche.getIdMarche());
				publication.setIdExport(exportAFF.getIdExport());
				publication.setIdPublicationType(PublicationType.TYPE_PETITE_ANNONCE);
				publication.setIdPublicationEtat(PublicationEtat.ETAT_A_ENVOYER);
				publication.normalize(); 
				publication.create();
			}
			else{
				System.out.println("La personne n'appartient pas à un Organisme de publication au SPQR");
			}
		}catch(Exception e){
			e.printStackTrace();
		 }
		response.sendRedirect( response.encodeRedirectURL("afficherPetiteAnnonce.jsp"
				+"?iIdOnglet=" + iIdOnglet 
				+ "&iIdAffaire=" + marche.getIdMarche()
				+"&nonce=" + System.currentTimeMillis() 
				+"&#ancreHP"));
	
		return;
	}
	

	if(sAction.equals("storeNoForm"))
	{
		String sPageUseCaseId = "IHM-DESK-PA-3";
		sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
		// met à jour uniquement la date de derniere modif et le fait que l'on est passé dans l'onglet
		modula.journal.Evenement.addEvenement(marche.getIdMarche(),"IHM-DESK-PA-3", sessionUser.getIdUser(),"");
		marche.store();
		response.sendRedirect( response.encodeRedirectURL("afficherPetiteAnnonce.jsp"
				+ "?iIdOnglet=" + iIdOnglet 
				+ "&iIdAffaire=" + marche.getIdMarche()
				+"&nonce=" + System.currentTimeMillis() 
				+"&#ancreHP"));
		return;
	}
	
	if(!sAction.equals("store"))
	{
		response.sendRedirect( response.encodeRedirectURL("afficherPetiteAnnonce.jsp"
				+ "?iIdOnglet=" + iIdOnglet 
				+ "&iIdAffaire=" + marche.getIdMarche()
				+"&nonce=" + System.currentTimeMillis() 
				+"&#ancreHP"));
		
		return;
	}
	
	/**
	 * store part
	 */

	String sPageUseCaseId = "IHM-DESK-PA-3";
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);

	marche.setFromFormPaveObjetMarche(request,"");
	if (request.getParameter(sFormPrefix + "sReferenceExterne") != null)
		marche.setReferenceExterne(request.getParameter(sFormPrefix + "sReferenceExterne"));
	try {
		if (!request.getParameter("idTypeDetaille").equalsIgnoreCase("")&&(request.getParameter("idTypeDetaille")!=null)){
			marche.setFromFormPaveTypeMarche(request,"");
		}else{
			marche.setIdMarcheType(0);
		}
		
		if (!request.getParameter("iIdMarchePassation").equalsIgnoreCase("")&&(request.getParameter("iIdMarchePassation")!=null)){
			marche.setPetiteAnnoncePassation(Integer.parseInt(request.getParameter("iIdMarchePassation")));
		}else{
			marche.setPetiteAnnoncePassation(0);
		}
	} catch (Exception e) {}
	
	try {
		if(!request.getParameter("iIdSecteurActivite").equals("") && (request.getParameter("iIdSecteurActivite")!=null)) {
			BoampCPFItem.removeAllFromOwnerObject(TypeObjetModula.AFFAIRE, marche.getIdMarche());
			BoampCPFItem boampCpfItem = new BoampCPFItem();
			boampCpfItem.setIdOwnerTypeObject(TypeObjetModula.AFFAIRE);
			boampCpfItem.setIdOwnedObjet(Integer.parseInt(request.getParameter("iIdSecteurActivite")));
			boampCpfItem.setIdOwnerReferenceObject(marche.getIdMarche());
			boampCpfItem.create();
		}
	} catch(Exception e) {}
	
	String sPetiteAnnonceTexteLibre = request.getParameter(sFormPrefix + "sPetiteAnnonceTexteLibre");
	
	sPetiteAnnonceTexteLibre = XMLEntities.cleanUpXMLEntities(sPetiteAnnonceTexteLibre);
	sPetiteAnnonceTexteLibre = PreventInjection.preventStore(sPetiteAnnonceTexteLibre);
	sPetiteAnnonceTexteLibre = Outils.replaceAll(sPetiteAnnonceTexteLibre, "\\\'", "'");
	//sPetiteAnnonceTexteLibre = WindowsEntities.cleanUpWindowsEntities(sPetiteAnnonceTexteLibre);
	//sPetiteAnnonceTexteLibre = new String(request.getParameter(sFormPrefix + "sPetiteAnnonceTexteLibre").getBytes("ISO-8859-15"));
	//sPetiteAnnonceTexteLibre = org.coin.util.Outils.replaceAll(sPetiteAnnonceTexteLibre ,"&#146;","&#39;");
	sPetiteAnnonceTexteLibre = Outils.replaceAll(sPetiteAnnonceTexteLibre ,"?","&#63;");

	marche.setDCEDisponible(HttpUtil.parseBooleanCheckbox("bIsDCEDisponible", request, false));
	
	marche.setPetiteAnnonceTexteLibre(sPetiteAnnonceTexteLibre);
	marche.store();
	
	try{
		if (request.getParameter("isGrouped").equals("1")) marche.setPAGrouped(true); else marche.setPAGrouped(false);
	}catch(Exception e){}
	Vector<Validite> vValiditesAnnonce = Validite.getAllValiditeAffaireFromAffaire(marche.getIdMarche());
	Validite oValiditeAnnonce = null;
	
	if( (vValiditesAnnonce == null) 
	 || (vValiditesAnnonce.size() == 0) )
	{
		oValiditeAnnonce = new Validite();
		oValiditeAnnonce.setIdTypeObjetModula(ObjectType.AFFAIRE);
		oValiditeAnnonce.setIdReferenceObjet(marche.getIdMarche());
		oValiditeAnnonce.create();
	}
	else
	{
		oValiditeAnnonce = vValiditesAnnonce.firstElement();
	}
	
	
	if ( (request.getParameter(sFormPrefix + "tsDateValiditeDebut") != null)
		&& (request.getParameter(sFormPrefix + "tsHeureValiditeDebut") != null))
		oValiditeAnnonce.setDateDebut(org.coin.util.CalendarUtil.getConversionTimestamp(
								request.getParameter(sFormPrefix + "tsDateValiditeDebut")
								+ " " + request.getParameter(sFormPrefix + "tsHeureValiditeDebut")));

	if ( (request.getParameter(sFormPrefix + "tsDateValiditeFin") != null)
			&& (request.getParameter(sFormPrefix + "tsHeureValiditeFin") != null))
			oValiditeAnnonce.setDateFin(org.coin.util.CalendarUtil.getConversionTimestamp(
									request.getParameter(sFormPrefix + "tsDateValiditeFin")
									+ " " + request.getParameter(sFormPrefix + "tsHeureValiditeFin")));
									
	oValiditeAnnonce.store();

	try{
		marche.setIdCommission(Integer.parseInt(request.getParameter("iIdCommission")));
	} catch(Exception e){}
	marche.store();
	String sCodeSupportSPQR = "";
	try{
		sCodeSupportSPQR = request.getParameter("sCodeSupportSPQR");
	}catch(Exception e){}

	Organisation organisation = null;
	try{
		organisation = Organisation.getAllOrganisationPublicationFromOrganisationParametreAndValue("export.spqr.referenceclient", sCodeSupportSPQR).firstElement();
	}catch(Exception e){}
	if(!sCodeSupportSPQR.equalsIgnoreCase("")&&organisation!=null){
		try{
			Vector<Publication> vPublications = Publication.getAllPublicationFromMarcheAndEtat(marche.getIdMarche(), PublicationEtat.ETAT_A_ENVOYER);
			if (vPublications.size()>0){
				for(int j=0;j<vPublications.size();j++){
					Publication publication = vPublications.get(j);
					try{
						PublicationSpqr publicationSpqr = PublicationSpqr.getPublicationSpqrFromPublication(publication.getIdPublication());
						publicationSpqr.setCorpsPDF(marche.getPetiteAnnonceTexteLibre());
						publicationSpqr.normalize();
						publicationSpqr.store();
						Export export = Export.getExport(publicationSpqr.getIdExport());
						export.setIdObjetReferenceDestination(organisation.getIdOrganisation());
						export.store();
					}catch(Exception e){
						e.printStackTrace();
					}
				}
			}
			else{
				Export exportAFF = new Export(); 
				exportAFF.setName(organisation.getRaisonSociale());
				exportAFF.setDateCreation(new Timestamp(System.currentTimeMillis()));
				exportAFF.setIdTypeObjetSource(ObjectType.AFFAIRE);
				exportAFF.setIdTypeObjetDestination(ObjectType.ORGANISATION);
				exportAFF.setIdObjetReferenceSource(marche.getIdMarche());
				exportAFF.setIdObjetReferenceDestination(organisation.getIdOrganisation());
				exportAFF.setIdExportSens(Export.SENS_EXPORT);
				exportAFF.create();
				PublicationSpqr publicationSPQR = new PublicationSpqr();
				publicationSPQR.setIdTypeObjet(ObjectType.AFFAIRE);
				publicationSPQR.setIdReferenceObjet(marche.getIdMarche());
				publicationSPQR.setIdExport(exportAFF.getIdExport());
				publicationSPQR.setIdPublicationType(PublicationType.TYPE_PETITE_ANNONCE);
				publicationSPQR.setIdPublicationEtat(PublicationEtat.ETAT_A_ENVOYER);
				publicationSPQR.setCorpsPDF(marche.getPetiteAnnonceTexteLibre());
				publicationSPQR.normalize(); 
				publicationSPQR.create();
				System.out.println("Une publication SPQR a été créée, "+organisation.getRaisonSociale()+" est le client");
			}
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	Evenement.addEvenement(marche.getIdMarche(), "IHM-DESK-PA-3", sessionUser.getIdUser(),"");

	response.sendRedirect( response.encodeRedirectURL("afficherPetiteAnnonce.jsp"
			+ "?iIdOnglet=" + iIdOnglet 
			+ "&iIdAffaire=" + marche.getIdMarche()
			+"&nonce=" + System.currentTimeMillis() 
			+"&#ancreHP"));
%>
