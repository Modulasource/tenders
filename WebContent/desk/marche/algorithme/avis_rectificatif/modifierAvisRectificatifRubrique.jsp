<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="modula.marche.*" %>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);

	int iIdAvisRectificatifRubrique = -1;
	String sIdAvisRectificatifRubrique = null;
	AvisRectificatifRubrique rubrique = null;
	int iIdOnglet = Integer.parseInt(request.getParameter("iIdOnglet"));
	
	int iIdAvisRectificatifType = Integer.parseInt(request.getParameter("iIdAvisRectificatifType"));
	String sRedirect = "";
	if (iIdAvisRectificatifType == AvisRectificatifType.TYPE_AAPC) sRedirect = "afficherAffaire";
	else if (iIdAvisRectificatifType == AvisRectificatifType.TYPE_AATR) sRedirect = "afficherAttribution";
	
	String sActionRectificatif = request.getParameter("sAction");
	if(sActionRectificatif.equals("remove"))
	{
		rubrique 
			= AvisRectificatifRubrique
				.getAvisRectificatifRubrique(
					Integer.parseInt(request.getParameter("iIdAvisRectificatifRubrique")));
					
		rubrique.remove();
	}
	
	if(sActionRectificatif.equals("create"))
	{	
		rubrique = new AvisRectificatifRubrique();
		rubrique.setIdAvisRectificatifRubriqueType(
			Integer.parseInt(request.getParameter("iIdAvisRectificatifRubriqueType")));

		rubrique.setIdAvisRectificatif(
			Integer.parseInt(request.getParameter("iIdAvisRectificatif")));

	
		if(rubrique.getIdAvisRectificatifRubriqueType() == AvisRectificatifRubrique.RUBRIQUE_TYPE_TEXTE)
		{	
			// gestion du sous type
			if(request.getParameter("sIdAvisRectificatifRubriqueSousType").equals("auLieuDe"))
			{
				rubrique.setIdAvisRectificatifRubriqueSousType(AvisRectificatifRubriqueSousType.SOUS_TYPE_LIRE);
			}
			
			if(request.getParameter("sIdAvisRectificatifRubriqueSousType").equals("apresLaMention"))
			{
				rubrique.setIdAvisRectificatifRubriqueSousType(AvisRectificatifRubriqueSousType.SOUS_TYPE_AJOUTER);
			}
			
			
			rubrique.setTexteAncienneValeur("à définir");
			rubrique.setTexteNouvelleValeur("à définir");
			rubrique.setRubrique("Texte à définir" );
		}

		if(rubrique.getIdAvisRectificatifRubriqueType() == AvisRectificatifRubrique.RUBRIQUE_TYPE_DATE)
		{	
			rubrique.setRubrique("Date à définir" );
		}
					
		rubrique.create();
		
	}

	response.sendRedirect(
		response.encodeRedirectURL(
			rootPath + "desk/marche/algorithme/affaire/"+sRedirect+".jsp?iIdAffaire="+iIdAffaire
				+"&iIdOnglet="+iIdOnglet
				+"&sActionRectificatif=show"
				+"&iIdAvisRectificatif="+ rubrique.getIdAvisRectificatif()
				+"&none="+System.currentTimeMillis()+"&#ancreHP"));

%>