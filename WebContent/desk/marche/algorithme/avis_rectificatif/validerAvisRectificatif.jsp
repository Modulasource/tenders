
<%@page import="modula.marche.joue.MarcheJoueFormulaire"%>
<%@page import="java.util.Vector"%>
<%@page import="modula.journal.Evenement"%>
<%@page import="org.coin.util.HttpUtil"%>

<%@ page import="modula.marche.*" %>
<%@ include file="/include/beanSessionUser.jspf" %>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);

	String rootPath = request.getContextPath()+"/";
	
	int iIdOnglet = Integer.parseInt(request.getParameter("iIdOnglet"));
	String sIdAvisRectificatif = request.getParameter("iIdAvisRectificatif");
	int iIdAvisRectificatif = Integer.parseInt(sIdAvisRectificatif );
	AvisRectificatif avis = AvisRectificatif.getAvisRectificatif(iIdAvisRectificatif);
	
	String sRedirect = "afficherAffaire";
	boolean bIsAATR = false;
	AvisAttribution avisAttrib = null;
	if(marche.isAffaireAATR(false))
	{
		sRedirect = "afficherAttribution";
		bIsAATR = true;
		avisAttrib = AvisAttribution.getAvisAttributionFromMarche(iIdAffaire);
	}
	
	String sAction = HttpUtil.parseStringBlank("sAction",request);
	
	
	if(sAction.equalsIgnoreCase("validateForm"))
	{
		avis.setAvisValide(true);
		avis.setLectureSeule(true);
		avis.store();
	
		if(bIsAATR)
		{
			avisAttrib.setLectureSeule(false);
			avisAttrib.store();
		}
		else
		{
			marche.setLectureSeule(false);
			marche.store();
		}
		
		Evenement.addEvenement(avis.getIdMarche(), "IHM-DESK-AFF-RECT-7", sessionUser.getIdUser(), "validation de l'avis rectificatif" );
	}
	if(sAction.equalsIgnoreCase("validateOnglets"))
	{
		avis.setOngletsValides(true);
		avis.store();
	
		if(bIsAATR)
		{
			avisAttrib.setLectureSeule(true);
			avisAttrib.store();
		}
		else
		{
			marche.setLectureSeule(true);
			marche.store();
		}
		
		Evenement.addEvenement(avis.getIdMarche(), "IHM-DESK-AFF-RECT-7", sessionUser.getIdUser(), "validation des onglets de l'affaire selon les modification apportées à l'avis rectificatif" );
	}

	response.sendRedirect( 
		response.encodeRedirectURL(
			rootPath + "desk/marche/algorithme/affaire/"+sRedirect+".jsp?iIdAffaire="+iIdAffaire
			+"&iIdOnglet="+iIdOnglet
			+"&sActionRectificatif=show"
			+"&iIdAvisRectificatif="+avis.getIdAvisRectificatif()
			+"&none="+System.currentTimeMillis()+"&#ancreHP"));
		
				
%>