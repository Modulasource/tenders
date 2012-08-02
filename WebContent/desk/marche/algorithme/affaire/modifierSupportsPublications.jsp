
<%@page import="mt.modula.affaire.publication.PublicationUtil"%><%@page import="org.coin.util.HttpUtil"%>

<%@ page import="java.sql.*,org.coin.fr.bean.*" %>
<%@ page import="java.util.*,org.coin.fr.bean.export.*,modula.marche.*" %>
<%@ page import="org.coin.bean.*" %>
<%@ include file="../../../include/beanSessionUser.jspf" %>
<%
	String sPageUseCaseId = "IHM-DESK-AFF-79";
	Marche marche = Marche.getMarche(Integer.parseInt( request.getParameter("iIdAffaire") ));

	Vector vOrganisationsPublication = Organisation.getAllOrganisationsWithIdType(OrganisationType.TYPE_PUBLICATION);
	String[] sarrPublicationSelected = request.getParameterValues("organisationSelected");
	String sUrlTraitement = request.getParameter("sUrlTraitement");
	int iIdNextPhaseEtapes = HttpUtil.parseInt("iIdNextPhaseEtapes", request, -1);
	String sIsProcedureLineaire = request.getParameter("sIsProcedureLineaire");
	int iIdAvisRectificatif = HttpUtil.parseInt("iIdAvisRectificatif", request, -1);
	
	// Gestion des publications papiers
	int iIsPubliePapier = HttpUtil.parseInt("bPublicationPapier", request, -1);

	if(iIsPubliePapier==1) marche.setPubliePapier(true);
	else if(iIsPubliePapier==2) marche.setPubliePapier(false);
	marche.store();

	// Recherche le cas échéant de l'organisation BOAMP
	int iIdOrganisationBoamp = HttpUtil.parseInt("boamp", request, 0);
	
	// Gestion de la veille de marché
	int bVeilleDeMarche = HttpUtil.parseInt("bVeilleDeMarche", request, 0);
	if (bVeilleDeMarche==1) marche.setVeilleDeMarche(true);
	else marche.setVeilleDeMarche(false);
	marche.store();
	
	if(iIdOrganisationBoamp!=0 
	&& Organisation.getOrganisation(iIdOrganisationBoamp).isOrganisationPublicationBOAMP())
	{
		if(Export.getAllExportFromSourceAndDestination(
				marche.getIdMarche(),
				ObjectType.AFFAIRE,
				iIdOrganisationBoamp,
				ObjectType.ORGANISATION).size()<1)
		{
			// il n'y a pas encore d'export, il faut le creer
			PublicationBoamp.createExportBoampFromMarche(marche.getIdMarche());
		}
	}else{
		
		
		// par mesure de précaution on supprime les exports BOAMP et les publications associées.
		PublicationBoamp.removeExportBoampFromMarche(marche.getIdMarche(), false);
				
	}
	
	PublicationUtil.updateAllPublication( 
			marche,
            sarrPublicationSelected,
            vOrganisationsPublication,
            iIsPubliePapier);
	
	response.sendRedirect(
			response.encodeURL("afficherToutesPublications.jsp?iIdAffaire="+
					marche.getIdMarche()
					+"&sIsProcedureLineaire="+sIsProcedureLineaire
					+"&iIdNextPhaseEtapes="+iIdNextPhaseEtapes
					+"&sUrlTraitement="+sUrlTraitement
					+"&iIdAvisRectificatif="+iIdAvisRectificatif));
%>