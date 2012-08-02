
<%@ page import="modula.marche.*,modula.algorithme.*, org.coin.util.*" %>
<%@ include file="/include/beanSessionUser.jspf" %>
<!DOCTYPE HTML PUBLIC "-//w3c//dtd html 4.0 transitional//en">
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);

	String rootPath = request.getContextPath()+"/";
	String sTitle = "Poursuivre la petite annonce"; 
	
	String sAction = "";
	if(request.getParameter("sAction") != null)
		sAction = request.getParameter("sAction");
	
	/* si iPreTraitement != -1 ce sera l'id algo phase etapes pour le pretraitement */
	int iPreTraitement = -1;
	if(request.getParameter("iPreTraitement")!=null)
		iPreTraitement = Integer.parseInt(request.getParameter("iPreTraitement"));
	
	int iTesterConditions=1;
	if(request.getParameter("iTesterConditions")!=null)
		iTesterConditions = Integer.parseInt(request.getParameter("iTesterConditions"));
	
	PhaseEtapes oPhaseEtapes = null;
	int iEtapeCourante = -1;
	int iPhaseCourante = -1;
	if(sAction.equals("init"))
	{
		int iIdAlgoProcedure = AffaireProcedure.getAffaireProcedureMemory(marche.getIdAlgoAffaireProcedure()).getIdProcedure();
		oPhaseEtapes = AlgorithmeModula.getFirstPhaseEtapesInProcedure(iIdAlgoProcedure);
		try
		{
			marche.setIdAlgoPhaseEtapes(oPhaseEtapes.getId());
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		java.math.BigInteger bi = new java.math.BigInteger(new byte[] { 0x00} );
		marche.setStatus(bi);
		marche.setCandidaturesCloses(false);
		marche.setLectureSeule(false);
		marche.setAffairePublieeSurPublisher(false);
		marche.setAffaireValidee(false);
		
		marche.store();
		
		response.sendRedirect(
				response.encodeRedirectURL(
						"afficherPetiteAnnonce.jsp"
						+ "?iIdOnglet=0"
						+ "&iIdAffaire=" + iIdAffaire));
		return;
	}
	if(sAction.equals("next"))
	{
		if(iPreTraitement != -1)
		{
			try
			{
				marche.setIdAlgoPhaseEtapes(iPreTraitement);
			}
			catch(Exception e)
			{
				e.printStackTrace();
			}
			marche.store();
		}
		
		iEtapeCourante = PhaseEtapes.getPhaseEtapesMemory(marche.getIdAlgoPhaseEtapes()).getIdAlgoEtape();
		iPhaseCourante = (int)Phase.getPhaseMemory(Etape.getEtapeMemory(iEtapeCourante).getIdAlgoPhase()).getId();
		oPhaseEtapes = null;
		
		if( AlgorithmeModula.getNextPhaseEtapesInProcedure(marche.getIdAlgoPhaseEtapes()) != null)
			oPhaseEtapes = AlgorithmeModula.getNextPhaseEtapesInProcedure(marche.getIdAlgoPhaseEtapes());

		if(oPhaseEtapes != null)
		{
			Etape oEtape = Etape.getEtapeMemory(oPhaseEtapes.getIdAlgoEtape());
			String sUrlFormulaire = oEtape.getUrlFormulaire();
			String sUrlTraitement = oEtape.getUrlTraitement();
			String[] sUseCase = Outils.parserChaineVersString(oEtape.getIdUseCase(),"-");

			boolean bFirst = AlgorithmeModula.isFirstPhaseEtapesInPhaseProcedure((int)oPhaseEtapes.getId());
			if(bFirst && iTesterConditions == 1)
			{
				response.sendRedirect(
						response.encodeRedirectURL(
								"afficherConditions.jsp"
								+ "?iIdAffaire=" + marche.getId()));
				return;
			}
			else
			{
				if(sUseCase[1].compareTo("PUB")==0)
				{
					response.sendRedirect(response.encodeRedirectURL(
							"afficherMessagePublisher.jsp"
							+ "?iIdAffaire=" + marche.getId()));
					return;
				}
				else if(sUrlFormulaire.compareTo("")==0 || sUrlTraitement.compareTo("")==0)
				{
					try
					{
						marche.setIdAlgoPhaseEtapes(oPhaseEtapes.getId());
	                    return;
					}
					catch(Exception e)
					{
						e.printStackTrace();
					}
					marche.store();
					response.sendRedirect(response.encodeRedirectURL(
							"afficherPetiteAnnonce.jsp"
							+ "?iIdOnglet=0"
							+ "&iIdAffaire=" + iIdAffaire));
					return;
				}
				else 
				{
					response.sendRedirect(
							response.encodeRedirectURL(
									rootPath+sUrlFormulaire
								    + "?iIdAffaire=" + iIdAffaire 
									+ "&sUrlTraitement=" + sUrlTraitement 
									+ "&iIdNextPhaseEtapes=" + oPhaseEtapes.getId()));
					return ;
				}
			}
		}
		else if( iPhaseCourante == Phase.PHASE_ARCHIVAGE )
		{
			String sMessTitle = "Message d'information";
			String sMess = AlgorithmeModula.MESSAGE_AFFAIRE_FINIE;
			String sUrlIcone = rootPath+modula.graphic.Icone.ICONE_SUCCES;
			response.sendRedirect(
					response.encodeRedirectURL(
							rootPath+"desk/marche/algorithme/affaire/afficherMessage.jsp"
							+ "?sMess="+sMess
							+ "&iIdAffaire" + marche.getId()
							+ "&sMessTitle="+sMessTitle
							+ "&sUrlIcone="+sUrlIcone ));
			return;
		}
	}
	if(sAction.equals("select"))
	{
		int iIdPhaseEtapes = Integer.parseInt(request.getParameter("iIdPhaseEtapes"));
		oPhaseEtapes = PhaseEtapes.getPhaseEtapesMemory(iIdPhaseEtapes);
		if(oPhaseEtapes != null)
		{
			Etape oEtape = Etape.getEtapeMemory(oPhaseEtapes.getIdAlgoEtape());
			String sUrlFormulaire = oEtape.getUrlFormulaire();
			String sUrlTraitement = oEtape.getUrlTraitement();
			String[] sUseCase = Outils.parserChaineVersString(oEtape.getIdUseCase(),"-");
			
			/* POUR TESTER */
			if(sUseCase[1].compareTo("PUB")==0)
			{
				response.sendRedirect(
						response.encodeRedirectURL(
							"afficherPetiteAnnonce.jsp"
							+ "?sMessage=" + AlgorithmeModula.MESSAGE_PHASE_PUBLISHER_CONSTITUTION_DOSSIER_EN_COURS 
							+ "&iIdOnglet=0"
							+ "&iIdAffaire=" + iIdAffaire ));
			}
			else if(sUrlFormulaire.compareTo("")==0 || sUrlTraitement.compareTo("")==0)
			{
				try
				{
					marche.setIdAlgoPhaseEtapes(oPhaseEtapes.getId());
				}
				catch(Exception e)
				{
					e.printStackTrace();
				}
				marche.store();
				response.sendRedirect(
						response.encodeRedirectURL(
								"afficherPetiteAnnonce.jsp?iIdOnglet=0"
								+ "&iIdAffaire=" + iIdAffaire ));
				return;
			}
			/* POUR TESTER */
			else
			{	
				response.sendRedirect(
						response.encodeRedirectURL(
								rootPath+sUrlFormulaire
								+ "?iIdAffaire=" + iIdAffaire 
								+ "&sUrlTraitement=" + sUrlTraitement 
								+ "&iIdNextPhaseEtapes=" + oPhaseEtapes.getId() ));
				return;
			}
		}
		else 
		{
			response.sendRedirect(
					response.encodeRedirectURL(
							"afficherPetiteAnnonce.jsp"
							+ "?iIdOnglet=0"
							+ "&iIdAffaire=" + iIdAffaire ));
			return;
		}
	}
	
%>
PAS D ETAPE APRES : iEtapeCourante = <%=iEtapeCourante  %> et iEtapeCourante  <%= iPhaseCourante %>
