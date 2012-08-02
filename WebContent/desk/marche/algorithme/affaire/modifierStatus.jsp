<%@page import="org.coin.util.HttpUtil"%>

<%@ page import="modula.marche.*, java.util.*, modula.candidature.*" %>
<%@ include file="/include/beanSessionUser.jspf" %>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);
	
	String rootPath = request.getContextPath()+"/";
	String sFormPrefix = "";
	int iIdOnglet  = HttpUtil.parseInt("iIdOnglet", request, 0);
	String sAction = HttpUtil.parseStringBlank("sAction", request);
	
	AvisAttribution oAvisAttribution = null;
	try
	{
		oAvisAttribution = AvisAttribution.getAvisAttributionFromMarche(iIdAffaire);
	}
	catch(Exception e){}
	
	if(!sAction.equals("store"))
	{
		response.sendRedirect(response.encodeRedirectURL("afficherStatus.jsp?iIdOnglet=" + iIdOnglet+"&iIdAffaire="+iIdAffaire));
		return;
	}

	if(iIdOnglet == 0)
	{
		Vector vStatus = marche.getAllStatus();
		
		for(int i=0;i<vStatus.size();i++)
		{
			Vector vStatut = (Vector)vStatus.get(i);
			int iIdStatut = Integer.parseInt((String)vStatut.firstElement());
			
			int iStatutValeur = Integer.parseInt(request.getParameter(sFormPrefix + "selectStatut" + iIdStatut));
	
			marche.setStatut(iIdStatut,iStatutValeur);
		}
		marche.store();
	}
	
	if(iIdOnglet == 1)
	{
		Vector<MarcheLot> vLots = MarcheLot.getAllLotsFromMarche(iIdAffaire);
		for(int i = 0; i<vLots.size();i++)
		{
			MarcheLot lot = vLots.get(i);
			Vector vStatus = lot.getAllStatus();
	
			for(int j=0;j<vStatus.size();j++)
			{
				Vector vStatut = (Vector)vStatus.get(j);
				int iIdStatut = Integer.parseInt((String)vStatut.firstElement());
				int iStatutValeur = Integer.parseInt(request.getParameter(lot.getIdMarcheLot() + "selectStatut" + iIdStatut));
		
				lot.setStatut(iIdStatut,iStatutValeur);
			}
			lot.store();
		}
	}
	
	if(iIdOnglet == 2)
	{
		Vector<Candidature> vCandidatures = Candidature.getAllCandidatureFromMarche(iIdAffaire);
		
		for(int iCand = 0;iCand<vCandidatures.size();iCand++ )
		{
			Candidature oCandidature = vCandidatures.get(iCand);
			Vector vStatusCandidature = oCandidature.getAllStatus();
			
			Vector vEnveloppeA = EnveloppeA.getAllEnveloppeAFromCandidature(oCandidature.getIdCandidature());
			Vector vEnveloppeB = EnveloppeB.getAllEnveloppeBFromCandidature(oCandidature.getIdCandidature());
			Vector vEnveloppeC = EnveloppeC.getAllEnveloppeCFromCandidature(oCandidature.getIdCandidature());
			
			/* mise à jour des status de la candidature */
			for(int j=0;j<vStatusCandidature.size();j++)
			{
				Vector vStatut = (Vector)vStatusCandidature.get(j);
				int iIdStatut = Integer.parseInt((String)vStatut.firstElement());
				int iStatutValeur = Integer.parseInt(request.getParameter("candidature_" + oCandidature.getIdCandidature() + "selectStatut" + iIdStatut));
		
				oCandidature.setStatut(iIdStatut,iStatutValeur);
			}
			oCandidature.store();
			
			for( int iEnvA = 0 ; iEnvA < vEnveloppeA.size() ; iEnvA ++ )
			{
				EnveloppeA oEnveloppeA = (EnveloppeA)vEnveloppeA.get(iEnvA);
				Vector vStatusEnveloppeA = oEnveloppeA.getAllStatus();
				
				/* mise à jour des status de l'enveloppe A de la candidature */
				for(int j=0;j<vStatusEnveloppeA.size();j++)
				{
					Vector vStatut = (Vector)vStatusEnveloppeA.get(j);
					int iIdStatut = Integer.parseInt((String)vStatut.firstElement());
					int iStatutValeur = Integer.parseInt(request.getParameter("enveloppeA_" + oEnveloppeA.getIdEnveloppe() + "selectStatut" + iIdStatut));
			
					oEnveloppeA.setStatut(iIdStatut,iStatutValeur);
				}
				oEnveloppeA.store();
			}
			
			for( int iEnvB = 0 ; iEnvB < vEnveloppeB.size() ; iEnvB ++ )
			{
				EnveloppeB oEnveloppeB = (EnveloppeB)vEnveloppeB.get(iEnvB);
				Vector vStatusEnveloppeB = oEnveloppeB.getAllStatus();
				
				/* mise à jour des status de l'enveloppe A de la candidature */
				for(int j=0;j<vStatusEnveloppeB.size();j++)
				{
					Vector vStatut = (Vector)vStatusEnveloppeB.get(j);
					int iIdStatut = Integer.parseInt((String)vStatut.firstElement());
					int iStatutValeur = Integer.parseInt(request.getParameter("enveloppeB_" + oEnveloppeB.getIdEnveloppe() + "selectStatut" + iIdStatut));
			
					oEnveloppeB.setStatut(iIdStatut,iStatutValeur);
				}
				oEnveloppeB.store();
			}
			
			for( int iEnvC = 0 ; iEnvC < vEnveloppeC.size() ; iEnvC ++ )
			{
				EnveloppeC oEnveloppeC = (EnveloppeC)vEnveloppeC.get(iEnvC);
				Vector vStatusEnveloppeC = oEnveloppeC.getAllStatus();
	
				for(int j=0;j<vStatusEnveloppeC.size();j++)
				{
					Vector vStatut = (Vector)vStatusEnveloppeC.get(j);
					int iIdStatut = Integer.parseInt((String)vStatut.firstElement());
					int iStatutValeur = Integer.parseInt(request.getParameter("enveloppeC_" + oEnveloppeC.getIdEnveloppe() + "selectStatut" + iIdStatut));
			
					oEnveloppeC.setStatut(iIdStatut,iStatutValeur);
				}
				oEnveloppeC.store();
			}
		}
	}
	if(iIdOnglet == 3)
	{
		if(oAvisAttribution != null)
		{
			Vector vStatus = oAvisAttribution.getAllStatus();
			
			for(int i=0;i<vStatus.size();i++)
			{
				Vector vStatut = (Vector)vStatus.get(i);
				int iIdStatut = Integer.parseInt((String)vStatut.firstElement());
				
				int iStatutValeur = Integer.parseInt(request.getParameter(sFormPrefix + "selectStatut" + iIdStatut));
		
				oAvisAttribution.setStatut(iIdStatut,iStatutValeur);
			}
			oAvisAttribution.store();
		}
	}
	if(iIdOnglet == 4)
	{
		Vector<AvisRectificatif> vAvisRectificatif = AvisRectificatif.getAllAvisRectificatif(iIdAffaire);
	
		for(int iRect = 0;iRect < vAvisRectificatif.size();iRect++)
		{
			AvisRectificatif oAvisRectificatif = vAvisRectificatif.get(iRect);
			Vector vStatusAvisRectificatif = oAvisRectificatif.getAllStatus();
			
			/* mise à jour des status de l'avis */
			for(int j=0;j<vStatusAvisRectificatif.size();j++)
			{
				Vector vStatut = (Vector)vStatusAvisRectificatif.get(j);
				int iIdStatut = Integer.parseInt((String)vStatut.firstElement());
				int iStatutValeur = Integer.parseInt(request.getParameter("avis_rectificatif_" + oAvisRectificatif.getIdAvisRectificatif() + "selectStatut" + iIdStatut));
		
				oAvisRectificatif.setStatut(iIdStatut,iStatutValeur);
			}
			oAvisRectificatif.store();
		}
	}
	response.sendRedirect(response.encodeRedirectURL("afficherStatus.jsp?iIdOnglet=" + iIdOnglet+"&iIdAffaire="+iIdAffaire));
%>
