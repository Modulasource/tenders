<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="modula.algorithme.*,java.util.*,org.coin.util.*,modula.candidature.*,modula.marche.*" %>
<%@ page import="modula.journal.*" %>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);

	String sTitle = "";
	int classement = 1;

	String sAction = request.getParameter("sAction");
	int iIdLot = Integer.parseInt(request.getParameter("iIdLot"));
	MarcheLot lot = MarcheLot.getMarcheLot(iIdLot);
	int iIdNextPhaseEtapes = HttpUtil.parseInt("iIdNextPhaseEtapes", request,-1);
	String[] idRecevables = Outils.parserChaineVersString(request.getParameter("liste_recevables_ids"),"|");
	String[] idNonRecevables= Outils.parserChaineVersString(request.getParameter("liste_nonrecevables_ids"),"|");
	boolean bIsContainsEnveloppeCManagement = AffaireProcedure.isContainsEnveloppeCManagement(marche.getIdAlgoAffaireProcedure());
	
	if (idRecevables != null)
	{
		for (int i = 0; i < idRecevables.length; i++)
		{
			if ( (!idRecevables[i].equalsIgnoreCase("")) && (!idRecevables[i].equalsIgnoreCase("|")) )
			{
				EnveloppeALot oEnveloppeALot = EnveloppeALot.getEnveloppeALot(Integer.parseInt(idRecevables[i]));
				oEnveloppeALot.setRecevable(true);
				oEnveloppeALot.setClassement(classement);
				oEnveloppeALot.store();
			
				classement ++;
			}
		}
	}
	
	if (idNonRecevables != null)
	{
		for (int i = 0; i < idNonRecevables.length; i++)
		{
			if ( (!idNonRecevables[i].equalsIgnoreCase("")) && (!idNonRecevables[i].equalsIgnoreCase("|")) )
			{
				EnveloppeALot oEnveloppeALot = EnveloppeALot.getEnveloppeALot(Integer.parseInt(idNonRecevables[i]));
				oEnveloppeALot.setRecevable(false);
				oEnveloppeALot.setClassement(classement);
				oEnveloppeALot.store();
			}
		}
	}
	
	if(sAction.equals("figer"))
	{
		lot.setClassementEnveloppesAFige(true);
		lot.store();
		Evenement.addEvenement(lot.getIdMarche() ,"IHM-DESK-AFF-37", sessionUser.getIdUser(),"Classement des candidatures figé pour le lot n°"+lot.getNumero());
	}

	if(MarcheLot.isAllLotsFromMarcheFigesForEnveloppesA(iIdAffaire))
	{
		/* on supprime toutes les enveloppes des candidatures invalides */
		Vector<Candidature> vCandidaturesInvalides = Candidature.getAllCandidaturesInvalidesFromMarche(marche.getIdMarche());
		if(vCandidaturesInvalides != null )
		{
			for(int i=0;i<vCandidaturesInvalides.size();i++)
			{
				Candidature cand = vCandidaturesInvalides.get(i);
				EnveloppeA.removeAllFromCandidature(cand.getIdCandidature());
				EnveloppeB.removeAllFromCandidature(cand.getIdCandidature());
				if(bIsContainsEnveloppeCManagement)
				{
					EnveloppeC.removeAllFromCandidature(cand.getIdCandidature());
				}
			}
		}
		
		boolean bIsDialogue = false;
		if(AffaireProcedure.isDialogueComplete(marche.getIdAlgoAffaireProcedure()))
			bIsDialogue = true;
		
		Vector<MarcheLot> vLots = MarcheLot.getAllLotsConstituablesFromMarche(marche);
		for(int i=0;i<vLots.size();i++)
		{
			MarcheLot oLot = vLots.get(i);
			
			/* on supprime toutes les envB des candidatures non recevables */
			// Bug 3528 : il faut désormais conserver les candidatures non recevables en base
			/*Vector<EnveloppeALot> vEnveloppeALotNonRecevables = EnveloppeALot.getAllEnveloppeALotNonRecevablesFromLot(oLot.getIdMarcheLot());
			for(int j=0;j<vEnveloppeALotNonRecevables.size();j++)
			{
				EnveloppeALot oEnveloppeALot = vEnveloppeALotNonRecevables.get(j);
				EnveloppeA envA = EnveloppeA.getEnveloppeA(oEnveloppeALot.getIdEnveloppeA());
				
				Vector<EnveloppeB> vEnvB = EnveloppeB.getAllEnveloppeBFromCandidatureAndLotAndValidite(envA.getIdCandidature(),oLot.getIdMarcheLot(),oLot.getIdValiditeEnveloppeBCourante());
				if(vEnvB != null && vEnvB.size()==1) vEnvB.firstElement().removeWithObjectAttached();
				
				if(bIsContainsEnveloppeCManagement)
				{
					Vector<EnveloppeC> vEnvC = EnveloppeC.getAllEnveloppeCFromCandidatureAndLotAndValidite(envA.getIdCandidature(),oLot.getIdMarcheLot(),oLot.getIdValiditeEnveloppeBCourante());
					if(vEnvC != null && vEnvC.size()==1) vEnvC.firstElement().removeWithObjectAttached();
				}
			}*/
			
			/* si on est en dialogue on initialise les statuts des enveloppes recevables et des lots */
			if(bIsDialogue)
			{
				Vector<EnveloppeALot> vEnveloppeALotRecevables = EnveloppeALot.getAllEnveloppeALotRecevablesFromLot(oLot.getIdMarcheLot());
				for(int j=0;j<vEnveloppeALotRecevables.size();j++)
				{
					EnveloppeALot oEnveloppeALot = vEnveloppeALotRecevables.get(j);
					oEnveloppeALot.setAdmisDialogue(true);
					oEnveloppeALot.store();
				}
				oLot.setEnCoursDeDialogue(true);
				oLot.store();
			}
		}
		
		// Evenement.addEvenement(marche.getIdMarche(), "IHM-DESK-AFF-14", sessionUser.getIdUser(),"Attribution des statuts des enveloppes A");
		response.sendRedirect(response.encodeRedirectURL("afficherEnveloppesA.jsp?iIdNextPhaseEtapes="
				+iIdNextPhaseEtapes+"&iIdAffaire=" + iIdAffaire+"&#ancreHP"));
	}
	else
	{
		response.sendRedirect(
				response.encodeRedirectURL(
						"afficherLotsEtEnveloppesA.jsp"
						        + "?iIdLot="+iIdLot
						        + "&iIdAffaire="+ marche.getIdMarche()
						        + "&iIdNextPhaseEtapes="+iIdNextPhaseEtapes
								+ "&iIdOnglet="+lot.getNumero()
								+ "&nonce="+System.currentTimeMillis()
								+"#tabClassement"));
	}

%>