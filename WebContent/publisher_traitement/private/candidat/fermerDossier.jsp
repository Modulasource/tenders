
<%@ page import="org.coin.fr.bean.*,modula.*,modula.marche.*, modula.candidature.*,java.util.*,modula.algorithme.*,java.sql.*" %>
<%@ page import="mt.modula.bean.mail.*,org.coin.mail.*" %>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="modula.journal.Evenement"%>
<%@page import="modula.graphic.Icone"%>
<%@ include file="../../public/include/beanSessionUser.jspf" %>
<%@ include file="../../public/include/beanCandidat.jspf" %> 
<%@ include file="../../../include/publisherType.jspf" %>
<%
	String rootPath = request.getContextPath()+"/";
	boolean bHorsDelaisB = false;
	boolean bHorsDelaisA = false;
	boolean bHorsDelaisC = false;
	
	String sCand = request.getParameter("cand");
	Candidature candidature = Candidature.getCandidature(Integer.parseInt(
            SecureString.getSessionPlainString(
            sCand,session)));

	if (candidature == null)
	{
		%><html><body>Dossier inconnu</body></html><% 
		return;	
	}
	
	boolean bAddEvenementA = false;
	boolean bAddEvenementB = false;
	boolean bAddEvenementC = false;
	
	int iIdPhaseEtapesCourante = -1;
	PhaseEtapes oPhaseEtapes = null;
	PersonnePhysique oCandidat = PersonnePhysique.getPersonnePhysique(candidature.getIdPersonnePhysique());
	Marche marche = Marche.getMarche(candidature.getIdMarche()); 
	Vector<MarcheLot> vLots = MarcheLot.getAllLotsConstituablesFromMarche(marche);
	
	boolean bIsContainsEnveloppeAManagement = AffaireProcedure.isContainsEnveloppeAManagement(marche.getIdAlgoAffaireProcedure());
	boolean bIsContainsEnveloppeCManagement = AffaireProcedure.isContainsEnveloppeCManagement(marche.getIdAlgoAffaireProcedure());
	boolean bIsForcedNegociationManagement = AffaireProcedure.isForcedNegociationManagement(marche.getIdAlgoAffaireProcedure());
	
	Timestamp dateDuJour = new Timestamp(System.currentTimeMillis());
	Timestamp tsDateFinUrgence = null;
	
	boolean bIsConstitutionEnveloppeAAutorisee = candidature.isConstitutionEnveloppeAAutorisee(false);
	boolean bIsConstitutionEnveloppeBAutorisee =candidature.isConstitutionEnveloppeBAutorisee(false);
	boolean bIsConstitutionEnveloppeCAutorisee = candidature.isConstitutionEnveloppeCAutorisee(false);
	
	if(bIsConstitutionEnveloppeAAutorisee && bIsContainsEnveloppeAManagement)
	{
		/* Récupération de l'enveloppe A */
		Vector vEnveloppesA = EnveloppeA.getAllEnveloppeAFromCandidature(candidature.getIdCandidature());
		EnveloppeA eEnveloppeA = (EnveloppeA)vEnveloppesA.firstElement();
	
		/* /Récupération des enveloppes A */
		
		/* Traitement de l'enveloppe A*/
		Timestamp tsDateFinEnveloppeA = null;
		Vector<Validite> vValiditeEnveloppeA = Validite.getAllValiditeEnveloppeAFromAffaire(marche.getIdMarche());
		if(vValiditeEnveloppeA != null)
		{
			if(vValiditeEnveloppeA.size() == 1)
			{
				Validite oValiditeEnveloppeA = vValiditeEnveloppeA.firstElement();
				tsDateFinEnveloppeA = oValiditeEnveloppeA.getDateFin();
				tsDateFinUrgence = new Timestamp(tsDateFinEnveloppeA.getTime()+marche.getDelaiUrgence()*60*60*1000);
			}
		}
		
		
		iIdPhaseEtapesCourante = candidature.getIdAlgoPhaseEtapes();
		oPhaseEtapes = AlgorithmeModula.getNextPhaseEtapesInProcedure(iIdPhaseEtapesCourante);
		
		
		boolean bIsCandidaturesCloses = marche.isCandidaturesCloses(false);
		boolean bIsEnveloppeACachetee = eEnveloppeA.isCachetee(false);
		 
		if(tsDateFinUrgence != null && tsDateFinEnveloppeA != null)
		{
			if ( !bIsEnveloppeACachetee 
				&& ( !bIsCandidaturesCloses || (bIsCandidaturesCloses && dateDuJour.before(tsDateFinUrgence)) ) ) 
			{
				eEnveloppeA.setDateFermeture(dateDuJour);
				eEnveloppeA.setCachetee(true);
				if(dateDuJour.after(tsDateFinEnveloppeA))
					bHorsDelaisA = true;
				eEnveloppeA.setHorsDelais(bHorsDelaisA);
				eEnveloppeA.store();
				
				candidature.setEnveloppeAConstituee(true);
				candidature.setIdAlgoPhaseEtapes(oPhaseEtapes.getId());
				candidature.store();
				
				bAddEvenementA = true;
			}
		}
		/* /Traitement de l'enveloppe A*/
	}
	
	if(oPhaseEtapes == null)
	{
		/**
		* provient de candidature.getIdAlgoPhaseEtapes();
		*/
		PhaseEtapes peCandidature = PhaseEtapes.getPhaseEtapes(candidature.getIdAlgoPhaseEtapes());
		Etape etape = Etape.getEtape(peCandidature.getIdAlgoEtape());
		String sException = "Exception : oPhaseEtapes=null pour iIdPhaseEtapesCourante=" 
			+ iIdPhaseEtapesCourante + " etape=" + etape.getName();
		System.out.println(sException);
		//throw new ServletException(sException);
	}

	if(bIsConstitutionEnveloppeBAutorisee || bIsConstitutionEnveloppeCAutorisee)
	{
		for(int i=0;i<vLots.size();i++)
		{
			MarcheLot lot = vLots.get(i);
			Timestamp tsDateFinEnveloppeB = null;
			tsDateFinUrgence = null;
			boolean bTraitementLot = true;					
			
			if( AffaireProcedure.getTypeProcedure(marche.getIdAlgoAffaireProcedure()) 
			!= AffaireProcedure.TYPE_PROCEDURE_OUVERTE || bIsForcedNegociationManagement)
			{
				if( ( !Validite.isFirstValiditeFromAffaire(lot.getIdValiditeEnveloppeBCourante(),marche.getIdMarche()) )
				&& ( (AffaireProcedure.getTypeProcedure(marche.getIdAlgoAffaireProcedure()) == AffaireProcedure.TYPE_PROCEDURE_NEGOCIE)||bIsForcedNegociationManagement) )
				{
					try
					{
						Validite oValiditePrec = Validite.getPrecValiditeEnveloppeBFromLot(lot.getIdMarcheLot());
						Vector<EnveloppeB> vEnvBPrecedente = EnveloppeB.getAllEnveloppeBFromCandidatureAndLotAndValidite(candidature.getIdCandidature(),lot.getIdMarcheLot(),oValiditePrec.getIdValidite());
						if(vEnvBPrecedente != null && vEnvBPrecedente.size()==1)
						{
							try{bTraitementLot = vEnvBPrecedente.firstElement().isRetenue();}
							catch(Exception e){}
						}
						else
						{
							bTraitementLot = false;
						}
					}
					catch(Exception e){}
				}
				else if( ( Validite.isFirstValiditeFromAffaire(lot.getIdValiditeEnveloppeBCourante(),marche.getIdMarche()) )
						&& ( (AffaireProcedure.getTypeProcedure(marche.getIdAlgoAffaireProcedure()) == AffaireProcedure.TYPE_PROCEDURE_NEGOCIE) || bIsForcedNegociationManagement)
						&& !bIsContainsEnveloppeAManagement)
				{
					bTraitementLot = true;
				}
				else
				{
					Vector<EnveloppeALot> vEnvALot = EnveloppeALot.getAllEnveloppeALotFromCandidatureAndLot(candidature.getIdCandidature(),lot.getIdMarcheLot());
					if(vEnvALot != null && vEnvALot.size()==1)
					{
						EnveloppeALot envALot = vEnvALot.firstElement();
						try{bTraitementLot = envALot.isRecevable();}
						catch(Exception e){}
					}
					else
					{
						bTraitementLot = false;
					}
				}
			}
			
			if(bTraitementLot)
			{
				Validite oValiditeEnveloppeB = Validite.getValidite(lot.getIdValiditeEnveloppeBCourante());
			
				if(oValiditeEnveloppeB != null)
				{
					if(oValiditeEnveloppeB.getDateFin() != null)
					{
						tsDateFinEnveloppeB = new Timestamp(oValiditeEnveloppeB.getDateFin().getTime() + marche.getTimingDoubleEnvoi()*60*60*1000);
						tsDateFinUrgence = new Timestamp(tsDateFinEnveloppeB.getTime()+marche.getDelaiUrgence()*60*60*1000);
					}
					
					boolean bIsOffresCloses = marche.isOffresCloses(false);
	
					if(bIsConstitutionEnveloppeBAutorisee)
					{
						Vector<EnveloppeB> vEnveloppesB 
							= EnveloppeB.getAllEnveloppeBNonCacheteeFromCandidatureAndLotAndValidite(
									candidature.getIdCandidature(), 
									lot.getIdMarcheLot(), 
									oValiditeEnveloppeB.getIdValidite());
	
						/* Traitement des enveloppes B*/
						if(tsDateFinUrgence != null && tsDateFinEnveloppeB != null)
						{
							if (!bIsOffresCloses || (bIsOffresCloses && dateDuJour.before(tsDateFinUrgence))) 
							{
								
								for(int j=0;j<vEnveloppesB.size();j++)
								{
								
									EnveloppeB eEnveloppeB = vEnveloppesB.get(j);
									eEnveloppeB.setDateFermeture(dateDuJour);
									eEnveloppeB.setCachetee(true);
									if(dateDuJour.after(tsDateFinEnveloppeB))
										bHorsDelaisB = true;
									eEnveloppeB.setHorsDelais(bHorsDelaisB);
									eEnveloppeB.setIdValidite(lot.getIdValiditeEnveloppeBCourante());
									eEnveloppeB.store();
								}
						
								iIdPhaseEtapesCourante = candidature.getIdAlgoPhaseEtapes();
								oPhaseEtapes = AlgorithmeModula.getNextPhaseEtapesInProcedure(iIdPhaseEtapesCourante);

								candidature.setEnveloppeBConstituee(true);
								if(oPhaseEtapes != null) candidature.setIdAlgoPhaseEtapes(oPhaseEtapes.getId());
								candidature.store();	
								bAddEvenementB = true;
							}
						}
					}
	
					if(bIsConstitutionEnveloppeCAutorisee && bIsContainsEnveloppeCManagement && Validite.isMarcheInFirstValidite(marche.getIdMarche()))
					{
						Vector<EnveloppeC> vEnveloppesC = EnveloppeC.getAllEnveloppeCNonCacheteeFromCandidatureAndLotAndValidite(candidature.getIdCandidature(), lot.getIdMarcheLot(), oValiditeEnveloppeB.getIdValidite());
			
						/* Traitement des enveloppes C*/
						if(tsDateFinUrgence != null && tsDateFinEnveloppeB != null)
						{
							if (!bIsOffresCloses || (bIsOffresCloses && dateDuJour.before(tsDateFinUrgence))) 
							{
								for(int j=0;j<vEnveloppesC.size();j++)
								{
									EnveloppeC eEnveloppeC = vEnveloppesC.get(j);
									eEnveloppeC.setDateFermeture(dateDuJour);
									eEnveloppeC.setCachetee(true);
									if(dateDuJour.after(tsDateFinEnveloppeB))
										bHorsDelaisC = true;
									eEnveloppeC.setHorsDelais(bHorsDelaisC);
									eEnveloppeC.setIdValidite(lot.getIdValiditeEnveloppeBCourante());
									eEnveloppeC.store();
								}
						
								iIdPhaseEtapesCourante = candidature.getIdAlgoPhaseEtapes();
								oPhaseEtapes = AlgorithmeModula.getNextPhaseEtapesInProcedure(iIdPhaseEtapesCourante);
								
								candidature.setEnveloppeCConstituee(true);
								candidature.setIdAlgoPhaseEtapes(oPhaseEtapes.getId());
								candidature.store();
								bAddEvenementC = true;
							}
						}
					}
					/* /Traitement des enveloppes C*/
				}
			}
		}
	}
	
	boolean bIsEnveloppeBConstituee = candidature.isEnveloppeBConstituee(false);
	boolean bIsEnveloppeAConstituee = candidature.isEnveloppeAConstituee(false);
	boolean bIsEnveloppeCConstituee = candidature.isEnveloppeCConstituee(false);

	boolean bValide = false;
	switch(AffaireProcedure.getTypeProcedure(marche.getIdAlgoAffaireProcedure()))
	{
		case AffaireProcedure.TYPE_PROCEDURE_OUVERTE:
			if( ((bIsContainsEnveloppeAManagement && bIsEnveloppeAConstituee) || (!bIsContainsEnveloppeAManagement))
				&& ((bIsContainsEnveloppeCManagement && bIsEnveloppeCConstituee) || (!bIsContainsEnveloppeCManagement))
				&& bIsEnveloppeBConstituee) 
				bValide = true;
			break;
			
		case AffaireProcedure.TYPE_PROCEDURE_RESTREINTE:
			if(bIsEnveloppeAConstituee) 
				bValide = true;
			break;
			
		case AffaireProcedure.TYPE_PROCEDURE_NEGOCIE:
			if(bIsEnveloppeAConstituee) 
				bValide = true;
			break;
	}

	if(bValide)
	{
		candidature.setDossierCachete(true);
		candidature.setValide(true);
		candidature.store();
	}
	boolean bEnvoiCandidat = false;
	
	/*
	 * Il ne faut pas envoyer les mail systématiquement
	 * on les envoie que si le candidat a bel et bien cacheté son dossier
	 */
	if(bValide){
		Connection conn = ConnectionManager.getConnection();
		// ON ENVOIE LE MAIL DE NOTIFICATION DE FERMETURE DU DOSSIER
		Courrier courrier = MailCandidature.prepareMailMarche(
				marche.getIdMarche(),
				candidat.getIdPersonnePhysique(),
				sessionUser.getIdIndividual(),
				sessionUser.getIdUser(),
				conn);
		
		MailModula mail = new MailModula();
		if(courrier.send(mail, conn))
		{
			bEnvoiCandidat = true;
		}
			
		// MAIL de fermeture du dossier aux membres de l'organisation AP qui le souhaitent
		MailCandidature.prepareAndSendMailAlertCandidatureClose(
				marche.getIdMarche(),
				sessionUser.getIdIndividual(),
				sessionUser.getIdUser(),
				candidat.getIdPersonnePhysique(),
				conn);
		
		ConnectionManager.closeConnection(conn);
	}
	
	String sTitle = "Fermeture du dossier";
	String sMessTitle = "";
	String sMess = "";
	String sUrlIcone = "";
	if (bEnvoiCandidat)
	{
		if((bAddEvenementA)&&(bAddEvenementB)&&(!bIsContainsEnveloppeCManagement || (bIsContainsEnveloppeCManagement && bAddEvenementC))) Evenement.addEvenement(marche.getIdMarche(), "IHM-PUBLI-AFF-16", sessionUser.getIdUser(), "Cachetage du dossier de "+oCandidat.getPrenomNom()+" du marché ref."+marche.getReference() );
		else if(bAddEvenementB || bAddEvenementC) Evenement.addEvenement(marche.getIdMarche(), "IHM-PUBLI-AFF-8", sessionUser.getIdUser(), "Cachetage des offres de "+oCandidat.getPrenomNom() +" du marché ref."+marche.getReference() );
		else if(bAddEvenementA) Evenement.addEvenement(marche.getIdMarche(), "IHM-PUBLI-AFF-7", sessionUser.getIdUser(),"Cachetage de la candidature de "+oCandidat.getPrenomNom() + " du marché ref."+marche.getReference());
		
		sUrlIcone = modula.graphic.Icone.ICONE_SUCCES;
		sMessTitle = "Succ&egrave;s de la fermeture de votre dossier";
		sMess = "Votre dossier a bien été fermé, vous ne pouvez donc plus le modifier.<br />";
		
		if(bHorsDelaisA || bHorsDelaisB || bHorsDelaisC) sMess += "<br />Cependant ";
		if(bHorsDelaisA && (bHorsDelaisB || bHorsDelaisC) ) sMess += "votre candidature et votre offre ont été cachetées hors delais. Leur ";
		else if(bHorsDelaisA) sMess += "votre candidature a été cachetée hors delais. Son ";
		else if(bHorsDelaisB || bHorsDelaisC) sMess += "votre offre a été cachetée hors delais. Son ";
		if(bHorsDelaisA || bHorsDelaisB || bHorsDelaisC) sMess += "acceptation dépendra du libre arbitre de l'acheteur public.<br /><br />";
		
		sMess += "Un email de confirmation vous a été envoyé.<br /><br />";
	}
	else {
		sUrlIcone = Icone.ICONE_ERROR;
		sMessTitle = "Succ&egrave;s de la fermeture de votre dossier";
		if (!bEnvoiCandidat) sMess = "Echec de l'envoi des emails de notification.<br /><br />";
		
		if(!bValide){
		    /* message d'erreur en cas de non validation du dossier de candidature */
			sMessTitle = "Impossible de proc&eacute;der &agrave; la fermeture de votre dossier";
			sMess = "Toutes les enveloppes n'ont pu être cachetées car le temps imparti est dépassé.<br/>Votre dossier va donc être considéré comme invalide.<br /><br />";
		}
	}
	sMess += "<button onclick=javascript:Redirect('"
		+ response.encodeURL(rootPath + sPublisherPath
		+ "/private/candidat/consulterDossier.jsp?cand="
		+ sCand + "&amp;iIdOnglet=2"
		+ "&amp;nonce="+System.currentTimeMillis()) 
		+ "') type='button' >Retour au dossier</button>";
	
	session.setAttribute("sessionPageTitre", sTitle);
	session.setAttribute("sessionMessageTitre", sMessTitle);
	session.setAttribute("sessionMessageLibelle", sMess);
	session.setAttribute("sessionMessageUrlIcone", sUrlIcone);

	response.sendRedirect( response.encodeURL(rootPath + "include/afficherMessagePublisher.jsp#anchor_top")  );		
%>