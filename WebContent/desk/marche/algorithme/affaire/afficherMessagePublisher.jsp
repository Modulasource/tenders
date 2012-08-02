<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="modula.marche.*,modula.algorithme.*,modula.*" %>
<%@page import="java.sql.Timestamp"%>
<%@page import="org.coin.util.CalendarUtil"%>
<%

	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);

	String sTitle = "Traitement de l'étape";
	String sMessTitle = "Etat des candidatures";
	String sMess = "";
	String sUrlIcone = Icone.ICONE_WARNING;
	String sHeadTitre = "Etat des candidatures";
	boolean bAfficherPoursuivreProcedure = false;
%>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<br/>
<div style="padding:15px">
<%@ include file="/include/new_style/headerAffaireOnlyButtonDisplayAffaire.jspf" %>
<%
		PhaseEtapes oPhaseEtapes = null;
		PhaseProcedure oPhaseProcedure = null;
		boolean bOffresCloses = marche.isOffresCloses(false);
		boolean bCandidaturesCloses = marche.isCandidaturesCloses(false);
		
		boolean bIsContainsCandidatureManagement = AffaireProcedure.isContainsCandidatureManagement(marche.getIdAlgoAffaireProcedure());
		boolean bIsContainsDCEManagament = AffaireProcedure.isContainsDCEManagement(marche.getIdAlgoAffaireProcedure());
		boolean bIsForcedNegociationManagement = AffaireProcedure.isForcedNegociationManagement(marche.getIdAlgoAffaireProcedure());
		int iTypeProcedure = AffaireProcedure.getTypeProcedure(marche.getIdAlgoAffaireProcedure());
		
		Vector<MarcheLot> vLots = MarcheLot.getAllLotsConstituablesFromMarche(marche);
		
		long iPreTraitement = -1;
		long iIdPhaseEtapes = marche.getIdAlgoPhaseEtapes();
		oPhaseEtapes = PhaseEtapes.getPhaseEtapesMemory( iIdPhaseEtapes );
		oPhaseEtapes = AlgorithmeModula.getNextPhaseEtapesInProcedure(oPhaseEtapes.getId());
		oPhaseProcedure = PhaseProcedure.getPhaseProcedureMemory(oPhaseEtapes.getIdAlgoPhaseProcedure());
		
		PhaseEtapes oNextPhaseEtapes = AlgorithmeModula.getLastPhaseEtapesInPhaseProcedure(oPhaseProcedure.getId() );
		
		/* exception pour les procedures qui contiennent des négociations */
		if(bIsForcedNegociationManagement
				&& !Validite.isMarcheInFirstValidite(marche.getIdMarche())
				&& (iTypeProcedure == AffaireProcedure.TYPE_PROCEDURE_OUVERTE || marche.getIdAlgoAffaireProcedure() == AffaireProcedure.AFFAIRE_PROCEDURE_CONCOURS_RESTREINT) )
		{
			oNextPhaseEtapes = PhaseEtapes.getPhaseEtapesBeforeFromProcedureAndEtape(AffaireProcedure.getAffaireProcedureMemory(marche.getIdAlgoAffaireProcedure()).getIdProcedure(),
					Etape.ETAPE_DECACHETAGE_ENVELOPPES_B_NEGOCIE);
		}
		
		Timestamp tsDateJour = new Timestamp(System.currentTimeMillis());
		boolean bAfficheDate = false;
		String sDate = ""; 
		if(vLots != null && vLots.size()>0)
		{
			Validite oValiditeB = Validite.getValidite(vLots.firstElement().getIdValiditeEnveloppeBCourante());
			if(oValiditeB != null && oValiditeB.getDateDebut() != null && tsDateJour.before(oValiditeB.getDateDebut()))
			{
				bAfficheDate = true;
				sDate = CalendarUtil.getDateCourte(oValiditeB.getDateDebut()) + " à " + CalendarUtil.getHeureMinuteSecLitterale(oValiditeB.getDateDebut());
			}
		}
		
		if ( oPhaseProcedure.getIdAlgoPhase() == Phase.PHASE_CONSTITUTION_PROPOSITIONS )
		{
			if(bIsForcedNegociationManagement && !Validite.isMarcheInFirstValidite(marche.getIdMarche()))
			{
				sMess = AlgorithmeModula.MESSAGE_PHASE_PUBLISHER_CONSTITUTION_OFFRE_EN_COURS;
				if(bAfficheDate)
					sMess = AlgorithmeModula.MESSAGE_PHASE_PUBLISHER_CONSTITUTION_OFFRE_PROCHAINE + sDate;		
			}
			else
			{
				sMess = AlgorithmeModula.MESSAGE_PHASE_PUBLISHER_CONSTITUTION_DOSSIER_EN_COURS;
				if(bAfficheDate)
					sMess = AlgorithmeModula.MESSAGE_PHASE_PUBLISHER_CONSTITUTION_DOSSIER_PROCHAIN + sDate;		
			}

			if(!bIsContainsCandidatureManagement && bIsContainsDCEManagament)
			{
				sMess = AlgorithmeModula.MESSAGE_PHASE_PUBLISHER_DCE_EN_COURS;
				if(bAfficheDate)
					sMess = AlgorithmeModula.MESSAGE_PHASE_PUBLISHER_DCE_PROCHAIN + sDate;
			}
			
			if ( oPhaseEtapes.getIdAlgoEtape() == Etape.ETAPE_PROPOSITIONS_EN_COURS_PUBLISHER )
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
			}
			
			if(bCandidaturesCloses && bOffresCloses)
			{
				try
				{
					iPreTraitement = oNextPhaseEtapes.getId();
				}
				catch(Exception e)
				{
                    e.printStackTrace();
				}
				sUrlIcone = modula.graphic.Icone.ICONE_SUCCES;
				sMess = AlgorithmeModula.MESSAGE_PHASE_PUBLISHER_CONSTITUTION_DOSSIER_FINI;
				if(!bIsContainsCandidatureManagement && bIsContainsDCEManagament) sMess = AlgorithmeModula.MESSAGE_PHASE_PUBLISHER_DCE_FINI;
			}
		}
		
		if ( oPhaseProcedure.getIdAlgoPhase() == Phase.PHASE_CONSTITUTION_ENVELOPPE_A )
		{
			sMess = AlgorithmeModula.MESSAGE_PHASE_PUBLISHER_CONSTITUTION_CANDIDATURE_EN_COURS;
			
			if ( oPhaseEtapes.getIdAlgoEtape() == Etape.ETAPE_CANDIDATURE_EN_COURS_PUBLISHER )
			{
				marche.setIdAlgoPhaseEtapes(oPhaseEtapes.getId());
				marche.store();
			}
			
			if(bCandidaturesCloses)
			{
				iPreTraitement = oNextPhaseEtapes.getId();
				sUrlIcone = Icone.ICONE_SUCCES;
				sMess = AlgorithmeModula.MESSAGE_PHASE_PUBLISHER_CONSTITUTION_CANDIDATURE_FINI;
			}
		}
		
		if ( oPhaseProcedure.getIdAlgoPhase() == Phase.PHASE_CONSTITUTION_ENVELOPPE_B || oPhaseProcedure.getIdAlgoPhase() == Phase.PHASE_CONSTITUTION_ENVELOPPE_B_C )
		{
			sMess = AlgorithmeModula.MESSAGE_PHASE_PUBLISHER_CONSTITUTION_OFFRE_EN_COURS;
			if(bAfficheDate)
				sMess = AlgorithmeModula.MESSAGE_PHASE_PUBLISHER_CONSTITUTION_OFFRE_PROCHAINE + sDate;		

			if ( oPhaseEtapes.getIdAlgoEtape() == Etape.ETAPE_OFFRE_EN_COURS_PUBLISHER )
			{
				marche.setIdAlgoPhaseEtapes(oPhaseEtapes.getId());
				marche.store();
			}
			
			
			if(bOffresCloses)
			{
				iPreTraitement = oNextPhaseEtapes.getId();
				
				sUrlIcone = Icone.ICONE_SUCCES;
				sMess = AlgorithmeModula.MESSAGE_PHASE_PUBLISHER_CONSTITUTION_OFFRE_FINI;
			}
		}
%>
<div align="center">
<%@ include file="/include/message.jspf" %>
<%
if(iPreTraitement != -1)
{
%>
<div style="text-align:center">
	<button type="button"
		onclick="Redirect('<%= response.encodeURL(rootPath 
				+ "desk/marche/algorithme/affaire/poursuivreProcedure.jsp"
			    + "?iIdAffaire=" + iIdAffaire
			    + "&amp;sAction=next"
			    + "&amp;iTesterConditions=0"
			    + "&amp;iPreTraitement=" +iPreTraitement) 
			    %>')" >Poursuivre la procédure</button>
</div>
<%
}
%>
</div>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>

</html>