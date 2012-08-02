
<%@page import="modula.marche.joue.MarcheJoueFormulaire"%>
<%@page import="modula.marche.joue.JoueFormulaire"%><%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.*,org.coin.fr.bean.export.*,java.sql.*,java.io.*,org.coin.util.*" %>
<%@ page import="java.util.*, modula.*, modula.marche.*" %>
<%
	int iIdAffaire = HttpUtil.parseInt("iIdAffaire", request, 0);
	Marche marche = Marche.getMarche(iIdAffaire);

	int iIdOnglet = HttpUtil.parseInt("iIdOnglet", request, 0);
	int iIdAvisRectificatif = HttpUtil.parseInt("iIdAvisRectificatif", request, -1);
	
	String sRedirect = "afficherAffaire";
	boolean bIsAATR = false;
	AvisAttribution avisAttrib = null;
	if(marche.isAffaireAATR(false))
	{
		sRedirect = "afficherAttribution";
		bIsAATR = true;
		avisAttrib = AvisAttribution.getAvisAttributionFromMarche(iIdAffaire);
	}
	
	Validite oValiditeAvis = null;
	try
	{
		if(bIsAATR)
			oValiditeAvis = Validite.getValidite(ObjectType.AATR,iIdAffaire);
		else
			oValiditeAvis = Validite.getValidite(ObjectType.AAPC,iIdAffaire);
	}
	catch(Exception e){}
	
	String sActionRectificatif = HttpUtil.parseString("sActionRectificatif", request, "");
	
	boolean bFormJOUE = HttpUtil.parseBoolean("bFormJOUE", request, false);
	
	if(sActionRectificatif.equals("create"))
	{	
		int iTypeAvisRectificatif = Integer.parseInt(request.getParameter("iTypeAvisRectificatif"));
		
		String sTypeAvis = "AAPC";
		if(iTypeAvisRectificatif == AvisRectificatifType.TYPE_AATR)
			sTypeAvis = "AATR";
		
		/* CREATION DE L'AVIS */
		AvisRectificatif avis = new AvisRectificatif();
		avis.setIdMarche(iIdAffaire);
		avis.setIdAvisRectificatifType(iTypeAvisRectificatif);
		avis.setDescriptionType(AvisRectificatif.FORMAT_TEXTE_LIBRE);
		avis.create();
	
		/* CREATION DE LA VALIDITE */
		Validite validite = new Validite();
		validite.setIdTypeObjetModula(ObjectType.AVIS_RECTIFICATIF);
		validite.setIdReferenceObjet(avis.getIdAvisRectificatif());
		validite.setDateDebut( new Timestamp(System.currentTimeMillis()));
		if(oValiditeAvis != null)
			validite.setDateFin(oValiditeAvis.getDateFin());
		else
			validite.setDateFin( new Timestamp(validite.getDateDebut().getTime() + 1000 * 3600 * 24 * 15));
		validite.create();
		
		boolean bAvisAutomatique = true;
		if(bIsAATR)
			bAvisAutomatique = avisAttrib.isAATRAutomatique(true);
		else
			bAvisAutomatique = marche.isAAPCAutomatique(true);
		
		

		/* CREATION DE L'ANCIEN AVIS */
		AncienAvis ancienAvis = new AncienAvis();
		ancienAvis.setIdAvisRectificatif(avis.getIdAvisRectificatif());
		ancienAvis.setDate(avis.getDateCreation());
		
		/* 
	     * Soit on est automatique est c'est les données renseignées dans les champs qui priment
		 * soit on est en manuel c'est le document joint qui priment et qu'il faut archiver
		 */
		if(bAvisAutomatique)			
		{
			try {ancienAvis.generatePDF();} 
			catch (Exception e) { e.printStackTrace();	}
			
			String sFilenameAvis 
				= sTypeAvis+"_" + CalendarUtil.getDateFormattee(new java.sql.Timestamp(System.currentTimeMillis() )) + ".pdf";
			sFilenameAvis.replaceAll(" ", "_");
			ancienAvis.setAncienAvisFilename(sFilenameAvis );
		}
		else
		{
			InputStream isAvis = null;
			String sAvis = null;
			if(bIsAATR)
			{
				isAvis = AvisAttribution.getAATRFromIdAatr(avisAttrib.getIdAvisAttribution());
				sAvis = avisAttrib.getNomAATR();
			}
			else
			{
				isAvis = Marche.getAAPC(marche.getIdMarche());
				sAvis = marche.getNomAAPC();
			}
			ancienAvis.setAncienAvisFile(isAvis);
			ancienAvis.setAncienAvisFilename(sAvis);
		}
		ancienAvis.create();
		ancienAvis.storeAncienAvisFile();
		
		/* MAJ DES STATUTS DU MARCHE */
		if(bIsAATR)
		{
			avisAttrib.setAATREnCoursDeRectification(true);
			avisAttrib.store();
		}
		else
		{
			marche.setAffaireEnCoursDeRectification(true);
			marche.store();
		}
		
		/* INSCRIPTION DANS LE JOURNAL */
		modula.journal.Evenement.addEvenement(avis.getIdMarche(), "IHM-DESK-AFF-RECT-2", sessionUser.getIdUser(), "" );
 
		/* REDIRECTION VERS LE FORMULAIRE */
		response.sendRedirect(
			response.encodeRedirectURL(
				rootPath + "desk/marche/algorithme/affaire/"+sRedirect+".jsp?iIdAffaire="+iIdAffaire
					+"&iIdOnglet="+iIdOnglet
					+"&sActionRectificatif=store"
					+"&iIdAvisRectificatif="+avis.getIdAvisRectificatif()
					+"&bCreationArec=true"
					+"&none="+System.currentTimeMillis()+"&#ancreHP"));
		return ;
	}
	
	if(sActionRectificatif.equals("remove"))
	{
		AvisRectificatif avis = AvisRectificatif.getAvisRectificatif (iIdAvisRectificatif );
		avis.removeWithObjectAttached();
		
		/* MAJ DES STATUTS DU MARCHE */
		if(bIsAATR)
		{
			avisAttrib.setAATREnCoursDeRectification(false);
			avisAttrib.setLectureSeule(true);
			avisAttrib.store();
		}
		else
		{
			marche.setAffaireEnCoursDeRectification(false);
			marche.setLectureSeule(true);
			marche.store();
		}
		
		modula.journal.Evenement.addEvenement(avis.getIdMarche(), "IHM-DESK-AFF-RECT-4", sessionUser.getIdUser(), "" );
		response.sendRedirect( 
			response.encodeRedirectURL(rootPath + "desk/marche/algorithme/affaire/"+sRedirect+".jsp?iIdAffaire=" + avis.getIdMarche() 
				+ "&iIdOnglet=0#ancreHP")); 
		return;
	}

	if(sActionRectificatif.equals("store"))
	{
        AvisRectificatif avis = AvisRectificatif.getAvisRectificatif (iIdAvisRectificatif );
        
        if(!avis.isAvisValide(false)) {
            Vector<MarcheJoueFormulaire> vJoueForm = MarcheJoueFormulaire.getAllFromIdMarche(marche.getId());
            if(vJoueForm.size() > 0) {
	            if(request.getParameter("bSendArecToJoue") != null) {
	                MarcheJoueFormulaire mjf = vJoueForm.firstElement(); 
	                mjf.setIdJoueFormulaire(14);
	                mjf.store();
	            } else {
	                if(vJoueForm != null) {
	                    MarcheJoueFormulaire mjf = vJoueForm.firstElement(); 
	                    if(mjf.getIdJoueFormulaire() == 14) {
	                        mjf.setIdJoueFormulaire(2);
	                        mjf.store();
	                    }
	                }   
	            }
            }
        }
        
        boolean bRectifFormJoueCompleted = true;
		if(!bFormJOUE) {
			/* MAJ DE L'AVIS */
			avis.setFromForm(request, "");
			avis.store();
	
			/* MAJ DE LA VALIDITE */
			Validite validite = Validite.getValidite(ObjectType.AVIS_RECTIFICATIF, avis.getIdAvisRectificatif());
			validite.setFromForm(request, "");
			if(oValiditeAvis != null)
				validite.setDateFin(oValiditeAvis.getDateFin());
			else
				validite.setDateFin( new Timestamp(validite.getDateDebut().getTime() + 1000 * 3600 * 24 * 15));
			validite.store();
		
			/* MAJ DES RUBRIQUES (SPECIFIQUE BOAMP) */
			boolean bExistPublicationBOAMP = false;
			try
			{
				int iTypePublication = PublicationType.TYPE_AAPC;
				if(avis.getIdAvisRectificatifType() == AvisRectificatifType.TYPE_AATR)
					iTypePublication = PublicationType.TYPE_AATR;
				
				Vector<PublicationBoamp> vPublicationBOAMP = PublicationBoamp.getAllPublicationBoampFromAffaire(iTypePublication,iIdAffaire);
				if(vPublicationBOAMP != null && vPublicationBOAMP.size()>0)
					bExistPublicationBOAMP = true;
			}
			catch(Exception e){}
			
			if(bExistPublicationBOAMP)
			{
				Vector<AvisRectificatifRubrique> vRubriques 
					= AvisRectificatifRubrique.getAllAvisRectificatifRubriqueForIdAvisRectificatif(avis.getIdAvisRectificatif());
				for(int i=0; i < vRubriques.size(); i++)
				{
					AvisRectificatifRubrique rubrique = vRubriques.get(i);
					rubrique.setFromForm(request, "id" + rubrique.getIdAvisRectificatifRubrique() + "_");
					rubrique.store();
				}
			}
	
	
			modula.journal.Evenement.addEvenement(avis.getIdMarche(), "IHM-DESK-AFF-RECT-3", sessionUser.getIdUser(), "" );
        } else {
        	Vector<AvisRectificatifRubrique> vRubriquesJoue
        	   = AvisRectificatifRubrique.getAllArecRubriqueForIdArecAndRubriqueType(
        			   avis.getIdAvisRectificatif(),
        			   AvisRectificatifRubrique.RUBRIQUE_TYPE_JOUE);
        	for(AvisRectificatifRubrique arr : vRubriquesJoue) arr.remove();
        	Vector<String> vRubriqueJOUE = new Vector<String>();
        	vRubriqueJOUE.add(request.getParameter(AvisRectificatifRubriqueJoue.RUBRIQUE_JOUE_AVIS_IMPLIQUE));
        	vRubriqueJOUE.add(request.getParameter(AvisRectificatifRubriqueJoue.RUBRIQUE_JOUE_MODIFICATION));
        	vRubriqueJOUE.add(request.getParameter(AvisRectificatifRubriqueJoue.RUBRIQUE_JOUE_MODIF_LOCALISATION));
        	
        	        	
        	AvisRectificatifRubrique avisRectifRubrique;
        	for(String sRubriqueJOUE : vRubriqueJOUE) {
        		if(sRubriqueJOUE == null) {
        			bRectifFormJoueCompleted = false;
        		} else {
	        		avisRectifRubrique = new AvisRectificatifRubrique();
	        		boolean bRubriqueRenseignee = avisRectifRubrique.setFromFormJOUE(request, sRubriqueJOUE, avis.getIdAvisRectificatif());
	        		if(!bRubriqueRenseignee) bRectifFormJoueCompleted = false;
        		}
        	}
        }
		response.sendRedirect( 
			response.encodeRedirectURL(
				rootPath + "desk/marche/algorithme/affaire/"+sRedirect+".jsp?iIdAffaire="+iIdAffaire
				+"&iIdOnglet="+iIdOnglet
				+"&sActionRectificatif=show"
				+"&iIdAvisRectificatif="+avis.getIdAvisRectificatif()
				+"&bRectifFormJoueCompleted="+bRectifFormJoueCompleted
				+"&none="+System.currentTimeMillis()+"&#ancreHP"));
				
		return;
	}
%>