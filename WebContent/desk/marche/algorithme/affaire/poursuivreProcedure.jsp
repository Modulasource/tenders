<%@page import="modula.graphic.Icone"%>
<%@page import="java.math.BigInteger"%>

<%@ page import="modula.marche.*,modula.algorithme.*, org.coin.util.*" %>
<%@ include file="/desk/include/beanSessionUser.jspf" %>
<!DOCTYPE HTML PUBLIC "-//w3c//dtd html 4.0 transitional//en">
<%

	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);

	String rootPath = request.getContextPath()+"/";
	String sAction = request.getParameter("sAction");
	
	int iPreTraitement = HttpUtil.parseInt("iPreTraitement", request, -1) ;
	int iTesterConditions= HttpUtil.parseInt("iTesterConditions", request, 1) ;
	
	PhaseEtapes oPhaseEtapes = null;
	int iEtapeCourante = -1;
	int iPhaseCourante = -1;
	
	boolean bIsAffaireValidee = false;
	if(marche.isAffaireAAPC(false))
	{
		bIsAffaireValidee = true;
	}
	else if(marche.isAffaireAATR(false))
	{
		AvisAttribution avis = AvisAttribution.getAvisAttributionFromMarche(iIdAffaire);
		bIsAffaireValidee = avis.isValide(false);
	}

	if(sAction.equals("init"))
	{
		int iIdAlgoProcedure 
			= AffaireProcedure
				.getAffaireProcedureMemory(
						marche.getIdAlgoAffaireProcedure()).getIdProcedure();
		
		oPhaseEtapes = AlgorithmeModula.getFirstPhaseEtapesInProcedure(iIdAlgoProcedure);
		marche.setIdAlgoPhaseEtapes(oPhaseEtapes.getId());
		BigInteger bi = new BigInteger(new byte[] { 0x00} );
		marche.setStatus(bi);
		marche.setCandidaturesCloses(false);
		marche.setLectureSeule(false);
		marche.setAffaireValidee(false);
		
		marche.store();
		 
		response.sendRedirect(
				response.encodeRedirectURL(
						"afficherAffaire.jsp"
						+ "?iIdOnglet=0"
						+ "&iIdAffaire=" + iIdAffaire));
		return;
	}
	if(sAction.equals("next"))
	{
		if(iPreTraitement != -1)
		{
			marche.setIdAlgoPhaseEtapes(iPreTraitement);
			marche.store();
		}
		
		iEtapeCourante = PhaseEtapes.getPhaseEtapesMemory(marche.getIdAlgoPhaseEtapes()).getIdAlgoEtape();
		iPhaseCourante = (int)Phase.getPhaseMemory(Etape.getEtapeMemory(iEtapeCourante).getIdAlgoPhase()).getId();
		oPhaseEtapes = null;
		if( AlgorithmeModula.getNextPhaseEtapesInProcedure(marche.getIdAlgoPhaseEtapes()) != null){
			oPhaseEtapes = AlgorithmeModula.getNextPhaseEtapesInProcedure(marche.getIdAlgoPhaseEtapes());
		}
		if(oPhaseEtapes != null)
		{
			Etape oEtape = Etape.getEtapeMemory(oPhaseEtapes.getIdAlgoEtape());
			String sUrlFormulaire = oEtape.getUrlFormulaire();
			String sUrlTraitement = oEtape.getUrlTraitement();
			
			String sKeyURL = "?";
			if(sUrlFormulaire.contains(sKeyURL))
				sKeyURL = "&";
			
			String[] sUseCase = Outils.parserChaineVersString(oEtape.getIdUseCase(),"-");
			
			if(bIsAffaireValidee && marche.isAffaireValidee() == false && marche.isAffaireAATR(false) == false) 
			{
				response.sendRedirect(
						response.encodeRedirectURL(
								"verifierAffaire.jsp"
								+ "?iIdAffaire=" + iIdAffaire
								+ "&sUrlFormulaire="+sUrlFormulaire
								+ "&sUrlTraitement=" + sUrlTraitement 
								+ "&sIsProcedureLineaire=true" 
								+ "&iIdNextPhaseEtapes=" + oPhaseEtapes.getId()
								+ "&iIdEtape=" + oEtape.getId()));
				return;
			} else if(!bIsAffaireValidee) 
			{
				response.sendRedirect(
						response.encodeRedirectURL(
								"verifierAffaire.jsp"
								+ "?iIdAffaire=" + iIdAffaire
								+ "&sUrlFormulaire="+sUrlFormulaire
								+ "&sUrlTraitement=" + sUrlTraitement 
								+ "&sIsProcedureLineaire=true" 
								+ "&iIdNextPhaseEtapes=" + oPhaseEtapes.getId()
								+ "&iIdEtape=" + oEtape.getId()));
				return;
			}
			
			
			boolean bFirst = AlgorithmeModula.isFirstPhaseEtapesInPhaseProcedure((int)oPhaseEtapes.getId());
			if(bFirst && iTesterConditions == 1)
			{
				response.sendRedirect(
						response.encodeRedirectURL(
								"afficherConditions.jsp"
								+ "?iIdAffaire=" + iIdAffaire
                                ));
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
					marche.setIdAlgoPhaseEtapes(oPhaseEtapes.getId());
					marche.store();

					String sTargetPage = "desk/marche/algorithme/affaire/afficherAffaire.jsp";
						
					boolean bIsAATR = marche.isAffaireAATR(false);
					boolean bIsAAPC = marche.isAffaireAAPC(false);
						
					if( (bIsAATR) || (bIsAAPC && oEtape.getId() == Etape.ETAPE_AATR_DEFINITION_TITULAIRE) ) 
					{
						sTargetPage = "desk/marche/algorithme/affaire/afficherAttribution.jsp";
					}

					response.sendRedirect(
							response.encodeRedirectURL(
									rootPath+sTargetPage
									+"?iIdAffaire=" + iIdAffaire));
					return;
				}
				else if((iEtapeCourante == Etape.ETAPE_DECACHETAGE_ENVELOPPES_B_OUVERTE)
					|| (iEtapeCourante == Etape.ETAPE_DECACHETAGE_ENVELOPPES_B_RESTREINTE)
					|| (iEtapeCourante == Etape.ETAPE_DECACHETAGE_ENVELOPPES_B_NEGOCIE)
					|| (iEtapeCourante == Etape.ETAPE_GESTION_ENVELOPPES_B_OUVERTE)
					|| (iEtapeCourante == Etape.ETAPE_GESTION_ENVELOPPES_B_RESTREINTE)
					|| (iEtapeCourante == Etape.ETAPE_GESTION_ENVELOPPES_B_NEGOCIE))
				{
					PhaseEtapes oPhaseEtapesSuivante = null;
					PhaseEtapes oPhaseEtapesSuivante2 = null;
					//on avance de 2 etapes
					oPhaseEtapes = AlgorithmeModula.getNextPhaseEtapesInProcedure(marche.getIdAlgoPhaseEtapes());
					oPhaseEtapesSuivante = AlgorithmeModula.getNextPhaseEtapesInProcedure(oPhaseEtapes.getId());
					
					response.sendRedirect(
							response.encodeRedirectURL(
									rootPath+sUrlFormulaire+sKeyURL
									+ "iIdAffaire=" + iIdAffaire
									+ "&sUrlTraitement=" + sUrlTraitement 
									+ "&sIsProcedureLineaire=true" 
									+ "&iIdNextPhaseEtapes=" + oPhaseEtapesSuivante.getId()));
					return;
				}
				else 
				{
					response.sendRedirect(
							response.encodeRedirectURL(
									rootPath+sUrlFormulaire+sKeyURL
									+"iIdAffaire=" + iIdAffaire 
									+ "&sUrlTraitement=" + sUrlTraitement 
									+ "&sIsProcedureLineaire=true" 
									+ "&iIdNextPhaseEtapes=" + oPhaseEtapes.getId()));
					return;
				}
			}
		}
		else if( iPhaseCourante == Phase.PHASE_ARCHIVAGE )
		{
			String sMessTitle = "Message d'information";
			String sMess = AlgorithmeModula.MESSAGE_AFFAIRE_FINIE;
			String sUrlIcone = Icone.ICONE_SUCCES;
			
			response.sendRedirect(
					response.encodeRedirectURL(
							rootPath
							+ "desk/marche/algorithme/affaire/afficherMessage.jsp"
							+ "?sMess="+sMess
							+ "&iIdAffaire=" + iIdAffaire
                            + "&sMessTitle=" + sMessTitle
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
			
			String sKeyURL = "?";
			if(sUrlFormulaire.contains(sKeyURL))
				sKeyURL = "&";
			
			/* POUR TESTER */
			if(sUseCase[1].compareTo("PUB")==0)
			{
				response.sendRedirect(
						response.encodeRedirectURL(
								"afficherAffaire.jsp"
								+ "?sMessage=" + AlgorithmeModula.MESSAGE_PHASE_PUBLISHER_CONSTITUTION_DOSSIER_EN_COURS 
								+ "&iIdAffaire=" + iIdAffaire ));
				return;
			}
			else if(sUrlFormulaire.compareTo("")==0 || sUrlTraitement.compareTo("")==0)
			{
				marche.store();
				response.sendRedirect(
						response.encodeRedirectURL(
								"afficherAffaire.jsp"
								+ "?iIdAffaire=" + iIdAffaire ));
				return;
			}
			/* POUR TESTER */
			else
			{
				response.sendRedirect(
						response.encodeRedirectURL(
								rootPath+sUrlFormulaire+sKeyURL
										+ "iIdAffaire=" + iIdAffaire 
										+ "&sUrlTraitement=" + sUrlTraitement 
										+ "&sIsProcedureLineaire=true" 
										+ "&iIdNextPhaseEtapes=" + oPhaseEtapes.getId() ));
				return;
			}
		}
		else 
		{
			response.sendRedirect(
					response.encodeRedirectURL(
							"afficherAffaire.jsp"
							+ "?iIdAffaire=" + iIdAffaire ));
			return;
		}
	}
	
%>
PAS D ETAPE APRES : iEtapeCourante = <%=iEtapeCourante  %> et iEtapeCourante  <%= iPhaseCourante %>
