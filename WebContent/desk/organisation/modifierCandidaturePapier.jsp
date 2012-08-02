<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="modula.journal.*,modula.graphic.*,modula.algorithme.*,org.coin.fr.bean.*,modula.*,modula.marche.*" %>
<%@ page import="modula.candidature.*" %>
<%
	String sMessage ="";
	String[] sSelectionLotsA = null;
	
	boolean bAnonyme = false;
	if(request.getParameter("bAnonyme") != null)
		bAnonyme = Boolean.parseBoolean(request.getParameter("bAnonyme"));
	
	Marche marche = Marche.getMarche(Integer.parseInt(request.getParameter("iIdMarche")));
	PersonnePhysique candidat = PersonnePhysique.getPersonnePhysique(Integer.parseInt(request.getParameter("iIdPersonnePhysique")));
	int iIdPersonnePhysique = candidat.getIdPersonnePhysique();
	Organisation organisation = Organisation.getOrganisation(candidat.getIdOrganisation());
	Vector<MarcheLot> vLotsConstituables = MarcheLot.getAllLotsConstituablesFromMarche(marche);
	
	String sTitle = "Dématérialiser la candidature de "+ candidat.getCivilitePrenomNom() +" pour le marché réf. "+marche.getReference();
	
	boolean bIsContainsEnveloppeAManagement = AffaireProcedure.isContainsEnveloppeAManagement(marche.getIdAlgoAffaireProcedure());
	boolean bIsContainsEnveloppeCManagement = AffaireProcedure.isContainsEnveloppeCManagement(marche.getIdAlgoAffaireProcedure());
	boolean bIsContainsAAPCPublicity = AffaireProcedure.isContainsAAPCPublicity(marche.getIdAlgoAffaireProcedure());
	boolean bIsForcedNegociationManagement = AffaireProcedure.isForcedNegociationManagement(marche.getIdAlgoAffaireProcedure());
	boolean bIsContainsCandidatureManagement = AffaireProcedure.isContainsCandidatureManagement(marche.getIdAlgoAffaireProcedure());
	int iTypeProcedure = AffaireProcedure.getTypeProcedure(marche.getIdAlgoAffaireProcedure());
	
	int iFormatDCE = 0;
	if(request.getParameter("formatDCE") != null)
	{
		iFormatDCE = Integer.parseInt(request.getParameter("formatDCE"));
	}
	
	int iFormatCandidature = 0;
	if(request.getParameter("formatCandidature") != null)
	{
		iFormatCandidature = Integer.parseInt(request.getParameter("formatCandidature"));
	}
	
	Timestamp tsDateRetraitDCE = null;
	if(request.getParameter("tsDateRetraitDCE") != null && request.getParameter("tsHeureRetraitDCE") != null)
	{
		tsDateRetraitDCE = CalendarUtil.getConversionTimestamp(
							request.getParameter("tsDateRetraitDCE")
							+ " " + request.getParameter("tsHeureRetraitDCE"));
	}

	Timestamp tsDateEnveloppeAFin = null;
	if(request.getParameter("tsDateEnveloppeAFin") != null && request.getParameter("tsHeureEnveloppeAFin") != null)
	{
		tsDateEnveloppeAFin = CalendarUtil.getConversionTimestamp(
							request.getParameter("tsDateEnveloppeAFin")
							+ " " + request.getParameter("tsHeureEnveloppeAFin"));
	}

	boolean bCandidatureExist = Candidature.isDoublonCandidature(candidat.getIdPersonnePhysique(), candidat.getIdOrganisation(), marche.getIdMarche());
	Candidature candidature = null;

	if (!bCandidatureExist)
	{
		candidature = new Candidature();
		candidature.setIdMarche(marche.getIdMarche());
		candidature.setIdPersonnePhysique(candidat.getIdPersonnePhysique());
		candidature.setIdOrganisation(organisation.getIdOrganisation());
		candidature.setClose(false);
		candidature.setDCERetire(false);
		candidature.setStatutDCE(0,false);
		candidature.setEnveloppeAConstituee(false);
		candidature.setDossierCachete(false);
		candidature.setEnveloppeBConstituee(false);
		if(bIsContainsEnveloppeCManagement)
			candidature.setEnveloppeCConstituee(false);
		
		int iIdAlgoProcedure = AffaireProcedure.getAffaireProcedureMemory(marche.getIdAlgoAffaireProcedure()).getIdProcedure();
		if( iIdAlgoProcedure  == 0 )
		{
			System.out.println("WARNING : l'algorithme n'a pas été trouvé");
		}
		candidature.setIdAlgoProcedure(iIdAlgoProcedure);
		
		PhaseEtapes oPhaseEtapes = AlgorithmeModula.getNextPhaseEtapesInProcedure(marche.getIdAlgoPhaseEtapes());
		if(oPhaseEtapes != null)
		{
			candidature.setIdAlgoPhaseEtapes(oPhaseEtapes.getId());
		}
		else
		{
			System.out.println("WARNING : l'étape n'a pas été trouvée");
		}
		candidature.create();
	}
	else
	{
		//EXCEPTION: creer lexception DoubleCandidature
		//2 membres dune meme organisation essaient de candidater pour un meme marche
		candidature = Candidature.getCandidature(marche.getIdMarche(),candidat.getIdPersonnePhysique());
	}
	
	if(candidature != null)
	{
		String sRef = "CDT"+candidature.getIdCandidature();
		if(bAnonyme)
			sRef = "CDT?/ORG"+candidat.getIdOrganisation();

		sMessage = "Votre demande de candidature à été prise en compte.<br />"
			+ "Identifiant de la candidature (à reporter sur le dossier papier) :<strong>"+sRef+"</strong>";
			
		Evenement.addEvenement(marche.getIdMarche(), "CU-CAND-005", sessionUser.getIdUser(),
				candidat.getCivilitePrenomNom()+
				" se porte candidat pour le marché ref."+marche.getReference() );
			
		/* RETRAIT DU DCE */
		if(iFormatDCE == 2)
		{	
			if(tsDateRetraitDCE != null && (candidature.getDateRetraitDCE() == null || candidature.getDateRetraitDCE().compareTo(tsDateRetraitDCE) != 0))
			{
				//TODO: selectionner les lots retirés
				candidature.setStatutDCE(0,true);
				candidature.setDCERetire(true);
				candidature.setDCEPapier(true);
				candidature.setDateRetraitDCE(tsDateRetraitDCE);
				candidature.store();
				Evenement.addEvenement(marche.getIdMarche(), "IHM-PUBLI-AFF-4", sessionUser.getIdUser(),
				candidat.getCivilitePrenomNom()+
				" a retiré le DCE au format papier pour le marché ref."+marche.getReference() );
			}
		}
		else if(iFormatDCE == 1)
		{
			candidature.setDCEPapier(false);
			candidature.store();
		}
		else
		{
			candidature.setDCEPapier(false);
			candidature.setDateRetraitDCE(null);
			candidature.setDCERetire(false);
			candidature.setStatutDCE(0,false);
			candidature.store();
		}
		
		/* /RETRAIT DU DCE */
		
		/* CONTACT DU CANDIDAT SI NO ENVELOPPE A MANAGEMENT*/
		if(!bIsContainsEnveloppeAManagement && !bIsContainsAAPCPublicity)
		{
			if(tsDateEnveloppeAFin != null)
			{
				Vector vEnveloppeA = EnveloppeA.getAllEnveloppeAFromCandidature(candidature.getIdCandidature());
				EnveloppeA oEnveloppeA = null;
				boolean bAddEvenementA = false;
					
				if(request.getParameter("selectionLotsA") != null)
					sSelectionLotsA = request.getParameter("selectionLotsA").split(",");
				
				if(vEnveloppeA == null || vEnveloppeA.size() == 0)
				{
					bAddEvenementA = true;
					oEnveloppeA = new EnveloppeA();
					oEnveloppeA.setIdCandidature(candidature.getIdCandidature());
					oEnveloppeA.setCachetee(true);
					oEnveloppeA.setDateFermeture(tsDateEnveloppeAFin);
					oEnveloppeA.setDateDecachetage(tsDateEnveloppeAFin);
					oEnveloppeA.create();
				}
				else
				{
					oEnveloppeA = (EnveloppeA)vEnveloppeA.firstElement();
					if(oEnveloppeA.getDateFermeture() == null || oEnveloppeA.getDateFermeture().compareTo(tsDateEnveloppeAFin) != 0)
					{
						oEnveloppeA.setDateFermeture(tsDateEnveloppeAFin);
						oEnveloppeA.setDateDecachetage(tsDateEnveloppeAFin);
						oEnveloppeA.setCachetee(true);
						oEnveloppeA.store();
						bAddEvenementA = true;
					}
					else
					{
						bAddEvenementA = false;
					}
				}
				if(sSelectionLotsA != null)
				{	
					for (int i = 0; i < sSelectionLotsA.length ; i++)
					{
						MarcheLot lot = MarcheLot.getMarcheLot(Integer.parseInt(sSelectionLotsA[i]));
						
						Vector<EnveloppeALot> vEnvALot = EnveloppeALot.getAllEnveloppeALotFromCandidatureAndLot(candidature.getIdCandidature(),lot.getIdMarcheLot());
						if(vEnvALot.size() == 0)
						{	
							EnveloppeALot envALot = new EnveloppeALot();
							envALot.setIdLot(lot.getIdMarcheLot());
							envALot.setIdEnveloppeA(oEnveloppeA.getIdEnveloppe());
							envALot.setRecevable(true);
							envALot.create();
						}
						
						if(!bIsContainsCandidatureManagement)
						{
							boolean bAddEvenementB = false;
							Vector vEnvB = EnveloppeB.getAllEnveloppesBFromCandidatureAndLot(candidature.getIdCandidature(),lot.getIdMarcheLot());
							if(vEnvB.size() == 1)
							{
								EnveloppeB oEnveloppeB = (EnveloppeB)vEnvB.firstElement();
								
								if(oEnveloppeB.getDateFermeture() == null || oEnveloppeB.getDateFermeture().compareTo(tsDateEnveloppeAFin) != 0)
								{
									oEnveloppeB.setCommentaire("Enveloppe Papier dématérialisée par le système Modula.<br />Identifiant de la candidature (à reporter sur le dossier papier) :<strong>CDT"+candidature.getIdCandidature()+"</strong>");
									oEnveloppeB.setCachetee(true);
									oEnveloppeB.setConforme(true);
									oEnveloppeB.setNotifieNonConforme(false);
									oEnveloppeB.setAttribuee(false);
									oEnveloppeB.setDateFermeture(tsDateEnveloppeAFin);
									oEnveloppeB.setIdValidite(lot.getIdValiditeEnveloppeBCourante());
									oEnveloppeB.store();
									bAddEvenementB = true;
								}
							}
							else
							{	
								EnveloppeB eEnveloppeB = new EnveloppeB();
								eEnveloppeB.setIdCandidature(candidature.getIdCandidature());
								eEnveloppeB.setIdLot(lot.getIdMarcheLot());
								eEnveloppeB.setCommentaire("Enveloppe Papier dématérialisée par le système Modula.<br />Identifiant de la candidature (à reporter sur le dossier papier) :<strong>CDT"+candidature.getIdCandidature()+"</strong>");
								eEnveloppeB.setCachetee(true);
								eEnveloppeB.setRetenue(true);
								eEnveloppeB.setConforme(true);
								eEnveloppeB.setNotifieNonConforme(false);
								eEnveloppeB.setAttribuee(false);
								eEnveloppeB.setDateFermeture(tsDateEnveloppeAFin);
								eEnveloppeB.setIdValidite(lot.getIdValiditeEnveloppeBCourante());
								eEnveloppeB.create();
								bAddEvenementB = true;
							}
							if(bAddEvenementB)
							{
								
								String sTypeOffre = "";
								if(bIsContainsEnveloppeCManagement && Validite.isFirstValiditeFromAffaire(lot.getIdValiditeEnveloppeBCourante(),marche.getIdMarche()))
									sTypeOffre = "de prix ";
								String sEvenement = "Cachetage de l'offre "+sTypeOffre+"papier de "+candidat.getPrenom()+" "+candidat.getNom();
								if(vLotsConstituables != null && vLotsConstituables.size() > 1) sEvenement += " pour le lot n°"+ lot.getNumero();
								sEvenement += " du marché ref."+marche.getReference();
								
								Evenement.addEvenement(marche.getIdMarche(), "IHM-PUBLI-AFF-8", sessionUser.getIdUser(),sEvenement);
								
								candidature.setEnveloppeBConstituee(true);
								candidature.setCandidaturePapier(true);
								candidature.setValide(true);
								candidature.store();
							}
						}
						
					}
					if(!bIsContainsCandidatureManagement)
					{
						for (int j = 0; j < vLotsConstituables.size() ; j++)
						{
							MarcheLot lot = vLotsConstituables.get(j);
							Vector<EnveloppeB> vEnvB = EnveloppeB.getAllEnveloppesBFromCandidatureAndLot(candidature.getIdCandidature(),lot.getIdMarcheLot());
							
							boolean bRemove = true;
							for (int k = 0; k < sSelectionLotsA.length ; k++)
							{
								if(lot.getIdMarcheLot() == Integer.parseInt(sSelectionLotsA[k]))
								{
									bRemove = false;
									break;
								}
							}
							
							if(bRemove && vEnvB != null && vEnvB.size()==1)
							{
								vEnvB.firstElement().remove();
							}
						}
					}
					for (int j = 0; j < vLotsConstituables.size() ; j++)
					{
						MarcheLot lot = vLotsConstituables.get(j);
						Vector<EnveloppeALot> vEnveloppeALot = EnveloppeALot.getAllEnveloppeALotFromCandidatureAndLot(candidature.getIdCandidature(),lot.getIdMarcheLot());
						
						boolean bRemove = true;
						for (int k = 0; k < sSelectionLotsA.length ; k++)
						{
							if(lot.getIdMarcheLot() == Integer.parseInt(sSelectionLotsA[k]))
							{
								bRemove = false;
								break;
							}
						}
						
						if(bRemove && vEnveloppeALot != null && vEnveloppeALot.size()==1)
						{
							vEnveloppeALot.firstElement().remove();
						}
					}
				}		
				if(bAddEvenementA)
				{
					candidature.setEnveloppeAConstituee(true);
					candidature.setValide(true);
					candidature.setDossierCachete(true);
					candidature.setValide(true);
					candidature.store();
				}
			}
		}
		/* CONTACT DU CANDIDAT SI NO ENVELOPPE A MANAGEMENT*/
		
		/* CANDIDATURE - ENVELOPPE A */
		if(iFormatCandidature == 1)
		{
			candidature.setCandidaturePapier(false);
			candidature.store();
		}
		else if(iFormatCandidature == 2)
		{
			if(tsDateEnveloppeAFin != null && bIsContainsEnveloppeAManagement)
			{
				Vector vEnveloppeA = EnveloppeA.getAllEnveloppeAFromCandidature(candidature.getIdCandidature());
				EnveloppeA oEnveloppeA = null;
				boolean bAddEvenementA = false;
				
				if(request.getParameter("selectionLotsA") != null)
					sSelectionLotsA = request.getParameter("selectionLotsA").split(",");
				
				if(vEnveloppeA == null || vEnveloppeA.size() == 0)
				{
					bAddEvenementA = true;
					oEnveloppeA = new EnveloppeA();
					oEnveloppeA.setIdCandidature(candidature.getIdCandidature());
					oEnveloppeA.setCommentaire("Enveloppe Papier dématérialisée par le système Modula.<br />Identifiant de la candidature (à reporter sur le dossier papier) :<strong>CDT"+candidature.getIdCandidature()+"</strong>");
					oEnveloppeA.setCachetee(true);
					oEnveloppeA.setDateFermeture(tsDateEnveloppeAFin);
					oEnveloppeA.create();
				}
				else
				{
					oEnveloppeA = (EnveloppeA)vEnveloppeA.firstElement();
					if(oEnveloppeA.getDateFermeture() == null || oEnveloppeA.getDateFermeture().compareTo(tsDateEnveloppeAFin) != 0)
					{
						oEnveloppeA.setDateFermeture(tsDateEnveloppeAFin);
						oEnveloppeA.setCommentaire("Enveloppe Papier dématérialisée par le système Modula.<br />Identifiant de la candidature (à reporter sur le dossier papier) :<strong>CDT"+candidature.getIdCandidature()+"</strong>");
						oEnveloppeA.setCachetee(true);
						oEnveloppeA.store();
						bAddEvenementA = true;
					}
					else
					{
						bAddEvenementA = false;
					}
				}
				
				if(sSelectionLotsA != null)
				{	
					for (int i = 0; i < sSelectionLotsA.length ; i++)
					{
						Vector<EnveloppeALot> vEnvALot = EnveloppeALot.getAllEnveloppeALotFromCandidatureAndLot(candidature.getIdCandidature(),Integer.parseInt(sSelectionLotsA[i]));
						if(vEnvALot.size() == 0)
						{	
							EnveloppeALot envALot = new EnveloppeALot();
							envALot.setIdLot(Integer.parseInt(sSelectionLotsA[i]));
							envALot.setIdEnveloppeA(oEnveloppeA.getIdEnveloppe());
							envALot.create();
						}
					}
					for (int j = 0; j < vLotsConstituables.size() ; j++)
					{
						MarcheLot lot = vLotsConstituables.get(j);
						Vector<EnveloppeALot> vEnveloppeALot = EnveloppeALot.getAllEnveloppeALotFromCandidatureAndLot(candidature.getIdCandidature(),lot.getIdMarcheLot());
						
						boolean bRemove = true;
						for (int k = 0; k < sSelectionLotsA.length ; k++)
						{
							if(lot.getIdMarcheLot() == Integer.parseInt(sSelectionLotsA[k]))
							{
								bRemove = false;
								break;
							}
						}
						
						if(bRemove && vEnveloppeALot != null && vEnveloppeALot.size()==1)
							vEnveloppeALot.firstElement().remove();
					}
				}
				
				if(bAddEvenementA)
				{
					candidature.setEnveloppeAConstituee(true);
					candidature.setCandidaturePapier(true);
					candidature.setValide(true);
					candidature.store();
					
					Timestamp tsDateFinValiditeEnveloppeA = null;
					Timestamp tsDateDebutValiditeEnveloppeA = null;
					Timestamp tsDateFinAHorsDelais = null;
					boolean bEnvAHorsDelais = false;
					Vector<Validite> vValiditeEnveloppeA = Validite.getAllValiditeEnveloppeAFromAffaire(marche.getIdMarche());
					
					if(vValiditeEnveloppeA != null && vValiditeEnveloppeA.size() == 1)
					{
						Validite oValidite = vValiditeEnveloppeA.firstElement();
						tsDateFinValiditeEnveloppeA = oValidite.getDateFin();
						tsDateDebutValiditeEnveloppeA = oValidite.getDateDebut();
						tsDateFinAHorsDelais = new Timestamp(tsDateFinValiditeEnveloppeA.getTime() + (marche.getDelaiUrgence()*60*60*1000));
						
						if(tsDateEnveloppeAFin.after(tsDateDebutValiditeEnveloppeA) && tsDateEnveloppeAFin.before(tsDateFinValiditeEnveloppeA))
							bEnvAHorsDelais = false;
						if(tsDateEnveloppeAFin.after(tsDateFinValiditeEnveloppeA) && tsDateEnveloppeAFin.before(tsDateFinAHorsDelais))
							bEnvAHorsDelais = true;
							
						oEnveloppeA.setHorsDelais(bEnvAHorsDelais);
						oEnveloppeA.store();
						
						String sEvenement = "Cachetage de la candidature papier de "+candidat.getCivilitePrenomNom();
						if(vLotsConstituables != null && vLotsConstituables.size() > 1) sEvenement += " pour les lots "+ request.getParameter("selectionLotsA").substring(0,request.getParameter("selectionLotsA").length()-1);
						sEvenement += " du marché ref."+marche.getReference();
						
						Evenement.addEvenement(marche.getIdMarche(), "IHM-PUBLI-AFF-7", sessionUser.getIdUser(),sEvenement);
					}
				}
			}
			
			/* /CANDIDATURE - ENVELOPPE A */
		
			/* CANDIDATURE - ENVELOPPE B */
			Vector<Validite> vValiditeEnveloppesB = Validite.getAllValiditeEnveloppeBFromAffaire(marche.getIdMarche());
			for(int i=0;i<vValiditeEnveloppesB.size();i++)
			{
				Validite oValidite = vValiditeEnveloppesB.get(i);
				
				String sFormPrefix = "enveloppeB_"+i+"_";
				
				String[] sSelectionLotsB = null;
				if(request.getParameter("selectionLotsB"+i) != null)
					sSelectionLotsB = request.getParameter("selectionLotsB"+i).split(",");

				Timestamp tsDateEnveloppeBFin = null;
				if(iTypeProcedure == AffaireProcedure.TYPE_PROCEDURE_OUVERTE
						&& Validite.isFirstValiditeFromAffaire(oValidite.getIdValidite(),marche.getIdMarche())
						&& bIsContainsEnveloppeAManagement)
				{
					tsDateEnveloppeBFin = tsDateEnveloppeAFin;
					sSelectionLotsB = sSelectionLotsA;
				}
				else if(request.getParameter(sFormPrefix+"tsDateEnveloppeBFin") != null && request.getParameter(sFormPrefix+"tsHeureEnveloppeBFin") != null)
				{
					tsDateEnveloppeBFin = CalendarUtil.getConversionTimestamp(
										request.getParameter(sFormPrefix+"tsDateEnveloppeBFin")
										+ " " + request.getParameter(sFormPrefix+"tsHeureEnveloppeBFin"));
				}
		
				if(tsDateEnveloppeBFin != null)
				{
					Timestamp tsDateFinValiditeEnveloppeB = new Timestamp(oValidite.getDateFin().getTime() + (marche.getTimingDoubleEnvoi()*60*60*100));
					Timestamp tsDateDebutValiditeEnveloppeB = oValidite.getDateDebut();
					Timestamp tsDateFinBHorsDelais = new Timestamp(tsDateFinValiditeEnveloppeB.getTime() + (marche.getDelaiUrgence()*60*60*100));
					boolean bEnvBHorsDelais = false;
					
					if(tsDateEnveloppeBFin.after(tsDateDebutValiditeEnveloppeB) && tsDateEnveloppeBFin.before(tsDateFinValiditeEnveloppeB))
						bEnvBHorsDelais = false;
					if(tsDateEnveloppeBFin.after(tsDateFinValiditeEnveloppeB) && tsDateEnveloppeBFin.before(tsDateFinBHorsDelais))
						bEnvBHorsDelais = true;
					
					if(sSelectionLotsB != null)
					{	
						for (int j = 0; j < sSelectionLotsB.length ; j++)
						{
							boolean bAddEvenementB = false;
							Vector vEnvB = EnveloppeB.getAllEnveloppeBFromCandidatureAndLotAndValidite(candidature.getIdCandidature(),Integer.parseInt(sSelectionLotsB[j]), oValidite.getIdValidite());
							if(vEnvB.size() == 1)
							{
								EnveloppeB oEnveloppeB = (EnveloppeB)vEnvB.firstElement();
								
								if(oEnveloppeB.getDateFermeture() == null || oEnveloppeB.getDateFermeture().compareTo(tsDateEnveloppeBFin) != 0)
								{
									oEnveloppeB.setCommentaire("Enveloppe Papier dématérialisée par le système Modula.<br />Identifiant de la candidature (à reporter sur le dossier papier) :<strong>CDT"+candidature.getIdCandidature()+"</strong>");
									oEnveloppeB.setCachetee(true);
									oEnveloppeB.setConforme(true);
									oEnveloppeB.setNotifieNonConforme(false);
									oEnveloppeB.setAttribuee(false);
									oEnveloppeB.setDateFermeture(tsDateEnveloppeBFin);
									oEnveloppeB.setHorsDelais(bEnvBHorsDelais);
									oEnveloppeB.setIdValidite(oValidite.getIdValidite());
									oEnveloppeB.store();
									bAddEvenementB = true;
								}
							}
							else
							{	
								EnveloppeB eEnveloppeB = new EnveloppeB();
								eEnveloppeB.setIdCandidature(candidature.getIdCandidature());
								eEnveloppeB.setIdLot(Integer.parseInt(sSelectionLotsB[j]));
								eEnveloppeB.setCommentaire("Enveloppe Papier dématérialisée par le système Modula.<br />Identifiant de la candidature (à reporter sur le dossier papier) :<strong>CDT"+candidature.getIdCandidature()+"</strong>");
								eEnveloppeB.setCachetee(true);
								eEnveloppeB.setRetenue(true);
								eEnveloppeB.setConforme(true);
								eEnveloppeB.setNotifieNonConforme(false);
								eEnveloppeB.setAttribuee(false);
								eEnveloppeB.setDateFermeture(tsDateEnveloppeBFin);
								eEnveloppeB.setHorsDelais(bEnvBHorsDelais);
								eEnveloppeB.setIdValidite(oValidite.getIdValidite());
								eEnveloppeB.create();
								bAddEvenementB = true;
							}
							if(bAddEvenementB)
							{
								
								String sTypeOffre = "";
								if(bIsContainsEnveloppeCManagement && Validite.isFirstValiditeFromAffaire(oValidite.getIdValidite(),marche.getIdMarche()))
									sTypeOffre = "de prix ";
								String sEvenement = "Cachetage de l'offre "+sTypeOffre+"papier de "+candidat.getPrenom()+" "+candidat.getNom();
								if(vLotsConstituables != null && vLotsConstituables.size() > 1) sEvenement += " pour le lot "+ sSelectionLotsB[j];
								sEvenement += " du marché ref."+marche.getReference();
								
								Evenement.addEvenement(marche.getIdMarche(), "IHM-PUBLI-AFF-8", sessionUser.getIdUser(),sEvenement);
								
								candidature.setEnveloppeBConstituee(true);
								candidature.setCandidaturePapier(true);
								candidature.setValide(true);
								candidature.store();
							}
							
							/* ENVELOPPE C MANAGEMENT */
							if(bIsContainsEnveloppeCManagement && Validite.isFirstValiditeFromAffaire(oValidite.getIdValidite(),marche.getIdMarche()))
							{
								boolean bAddEvenementC = false;
								Vector vEnvC = EnveloppeC.getAllEnveloppeCFromCandidatureAndLotAndValidite(candidature.getIdCandidature(),Integer.parseInt(sSelectionLotsB[j]), oValidite.getIdValidite());
								if(vEnvC.size() == 1)
								{
									EnveloppeC oEnveloppeC = (EnveloppeC)vEnvC.firstElement();
									
									if(oEnveloppeC.getDateFermeture() == null || oEnveloppeC.getDateFermeture().compareTo(tsDateEnveloppeBFin) != 0)
									{
										oEnveloppeC.setCommentaire("Enveloppe Papier dématérialisée par le système Modula.<br />Identifiant de la candidature (à reporter sur le dossier papier) :<strong>CDT"+candidature.getIdCandidature()+"</strong>");
										oEnveloppeC.setCachetee(true);
										oEnveloppeC.setConforme(true);
										oEnveloppeC.setNotifieNonConforme(false);
										oEnveloppeC.setDateFermeture(tsDateEnveloppeBFin);
										oEnveloppeC.setHorsDelais(bEnvBHorsDelais);
										oEnveloppeC.setIdValidite(oValidite.getIdValidite());
										oEnveloppeC.store();
										bAddEvenementC = true;
									}
								}
								else
								{	
									EnveloppeC eEnveloppeC = new EnveloppeC();
									eEnveloppeC.setIdCandidature(candidature.getIdCandidature());
									eEnveloppeC.setIdLot(Integer.parseInt(sSelectionLotsB[j]));
									eEnveloppeC.setCommentaire("Enveloppe Papier dématérialisée par le système Modula.<br />Identifiant de la candidature (à reporter sur le dossier papier) :<strong>CDT"+candidature.getIdCandidature()+"</strong>");
									eEnveloppeC.setCachetee(true);
									eEnveloppeC.setRetenue(true);
									eEnveloppeC.setConforme(true);
									eEnveloppeC.setNotifieNonConforme(false);
									eEnveloppeC.setDateFermeture(tsDateEnveloppeBFin);
									eEnveloppeC.setHorsDelais(bEnvBHorsDelais);
									eEnveloppeC.setIdValidite(oValidite.getIdValidite());
									eEnveloppeC.create();
									bAddEvenementC = true;
								}
								if(bAddEvenementC)
								{
									String sEvenement = "Cachetage de l'offre de prestation papier de "+candidat.getPrenom()+" "+candidat.getNom();
									if(vLotsConstituables != null && vLotsConstituables.size() > 1) sEvenement += " pour le lot "+ sSelectionLotsB[j];
									sEvenement += " du marché ref."+marche.getReference();
									
									Evenement.addEvenement(marche.getIdMarche(), "IHM-PUBLI-AFF-8", sessionUser.getIdUser(),sEvenement);
									
									candidature.setEnveloppeCConstituee(true);
									candidature.setCandidaturePapier(true);
									candidature.setValide(true);
									candidature.store();
								}
							}
						}
						
						for (int j = 0; j < vLotsConstituables.size() ; j++)
						{
							MarcheLot lot = vLotsConstituables.get(j);
							Vector<EnveloppeB> vEnvB = EnveloppeB.getAllEnveloppeBFromCandidatureAndLotAndValidite(candidature.getIdCandidature(),lot.getIdMarcheLot(), oValidite.getIdValidite());
							Vector<EnveloppeC> vEnvC = null;
							if(bIsContainsEnveloppeCManagement && Validite.isFirstValiditeFromAffaire(oValidite.getIdValidite(),marche.getIdMarche()))
								vEnvC = EnveloppeC.getAllEnveloppeCFromCandidatureAndLotAndValidite(candidature.getIdCandidature(),lot.getIdMarcheLot(), oValidite.getIdValidite());
								
							boolean bRemove = true;
							for (int k = 0; k < sSelectionLotsB.length ; k++)
							{
								if(lot.getIdMarcheLot() == Integer.parseInt(sSelectionLotsB[k]))
								{
									bRemove = false;
									break;
								}
							}
							
							if(bRemove && vEnvB != null && vEnvB.size()==1)
								vEnvB.firstElement().remove();
							
							if(bRemove && vEnvC != null && vEnvC.size()==1)
								vEnvC.firstElement().remove();
						}
					}
				}
			}
			/* /CANDIDATURE - ENVELOPPE B */
		}
		
		if(!bCandidatureExist) Evenement.addEvenement(marche.getIdMarche(), "IHM-DESK-PERS-CDT-012", sessionUser.getIdUser(),sTitle);
		
	}
	else
	{
		sMessage = "Votre demande de candidature n'à pas été prise en compte.<br />"
				+ "Cause: <strong>Une candidature existe déjà pour l'organisation "+organisation.getRaisonSociale()+"</strong>";
	}
	
	if(bAnonyme)
		sTitle = "Dématérialiser la candidature ORG"+ candidat.getIdOrganisation() +" pour le marché réf. "+marche.getReference();
	
	/** 
	* BATCH ENVELOPPE A LOT
	* @see mt.modula.batch.application.update.BatchUpdateEnveloppeALot
	*/
	BatchUpdateEnveloppeALot.updateEnveloppeALotMarcheUnique(marche.getIdMarche());
	
%>
</head>
<body>
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<br/>
<div style="padding:15px">
<%@ include file="../include/headerCandidature.jspf" %>
<br />
<table style="vertical-align:top" class="pave">
	<tr>
		<td class="pave_titre_gauche">Message : </td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td style="text-align:left">
		<%= sMessage %>
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
</table>
<br/>
<div align="center">
<button type="button" value="" 	
	onclick="Redirect('<%= 
		response.encodeURL(sTargetURLAffaire) 
		%>')" >Retour à l'affaire</button>
<button type="button" value="" 	
	onclick="Redirect('<%= 
		response.encodeURL(
				rootPath + "desk/marche/algorithme/affaire/afficherRegistre.jsp?sAction=create"
				+ "&iIdAffaire="+marche.getIdMarche()
			) 
		%>')" >Retour au registre de l'affaire</button>
<button type="button" value="" 	
	onclick="Redirect('<%= 
		response.encodeURL("afficherToutesCandidatures.jsp?iIdPersonnePhysique="
				+candidat.getIdPersonnePhysique()
				+"&bAnonyme="+bAnonyme+"&#ancreHP") 
		%>')" >Retour à la liste des candidatures de <br/><%= candidat.getCivilitePrenomNomFonction() %></button>
</div>
</div>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>

</body>
<%@page import="org.coin.util.CalendarUtil"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="mt.modula.batch.application.update.BatchUpdateEnveloppeALot"%>
</html>
