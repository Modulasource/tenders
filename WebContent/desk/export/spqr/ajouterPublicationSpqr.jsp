<%@ include file="../../../../include/headerXML.jspf" %>

<%@ page import="modula.ws.spqr.*,modula.ws.boamp.*,java.sql.*,org.coin.fr.bean.mail.*,org.coin.fr.bean.*,org.coin.fr.bean.export.*,modula.candidature.*,org.coin.util.*" %>
<%@ page import="java.io.*,java.util.*,modula.*, modula.marche.*,org.coin.bean.*" %>
<%@ include file="../../../include/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath()+"/";
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	int iIdAvisRectificatif = -1;
	try{
		iIdAvisRectificatif = Integer.parseInt(request.getParameter("iIdAvisRectificatif"));
	}
	catch(Exception e){}
	int iIdOnglet = Integer.parseInt(request.getParameter("iIdOnglet"));
	String sPageUseCaseId = "IHM-DESK-AFF-xx";
	Marche marche = Marche.getMarche(iIdAffaire);
	int iIdPublicationType = Integer.parseInt(request.getParameter("iIdPublicationType"));
	int iIdExport = Integer.parseInt(request.getParameter("iIdExport"));
	Export export = Export.getExport(iIdExport);
	if (export.getIdExportMode() != ExportMode.MODE_FTP) 
		throw new Exception("L'export " + export.getIdExport() + " n'est pas du mode FTP");

	// Génération du fichier XML
	String sXmlToSend = "";
	
	if (marche.getIdAlgoAffaireProcedure() == modula.algorithme.AffaireProcedure.AFFAIRE_PROCEDURE_PETITE_ANNONCE)
	{		
		sXmlToSend  = ExportXml.getTagEnregistrement(marche, export); 
	} 
	else
	{
		switch (iIdPublicationType)
		{
		case PublicationType.TYPE_AAPC : 
			sXmlToSend  = ExportXml.getTagEnregistrementAAPC(marche, export); 
			break;
	
		case PublicationType.TYPE_AATR : 
			sXmlToSend  = ExportXml.getTagEnregistrement(marche, export);
			break;
	
		case PublicationType.TYPE_AVIS_ANNULATION : 
			sXmlToSend  = ExportXml.getTagEnregistrement(marche, export);
			break;
	
		case PublicationType.TYPE_AVIS_RECTIFICATIF_DE_AAPC : 
			sXmlToSend  = ExportXml.genererXmlAvisRectificatifAAPC(iIdAvisRectificatif);
			break;
	
		case PublicationType.TYPE_AVIS_RECTIFICATIF_DE_AATR: 
			sXmlToSend  = ExportXml.genererXmlAvisRectificatifAATR(iIdAvisRectificatif);
			break;
	
		default : 
			throw new Exception("Type de publication non reconnue");
		}
	}
	
	PublicationSpqr publi = null;
	Vector vPublicationSpqr = null;
	boolean bPublicationExist = false;
	try {
		vPublicationSpqr = PublicationSpqr.getAllPublicationSpqrFromAffaire(marche.getIdMarche()); 
		publi = (PublicationSpqr)vPublicationSpqr.firstElement();
		bPublicationExist = true;
	}
	catch(Exception e){
		publi = new PublicationSpqr();
	}
	publi.setFichier(sXmlToSend);
	publi.setIdExport(iIdExport);
	publi.setIdReferenceObjet(iIdAffaire);
	//publi.computeAndSetNomFichier(export); 
	publi.setNomFichier("En attente d'envoi");
	publi.setIdPublicationType(iIdPublicationType);
	publi.setDateEnvoiEffective(null);
	publi.setIdPublicationDestinationType(PublicationDestinationType.TYPE_SPQR);
	publi.setIdTypeObjet(ObjectType.AFFAIRE);
	publi.setIdPublicationEtat(PublicationEtat.ETAT_A_ENVOYER);
	if(bPublicationExist)
		publi.store();
	else
		publi.create();

	
	if (marche.getIdAlgoAffaireProcedure() != modula.algorithme.AffaireProcedure.AFFAIRE_PROCEDURE_PETITE_ANNONCE)
	{		
		response.sendRedirect(response.encodeRedirectURL(rootPath+"desk/marche/algorithme/affaire/afficherToutesPublications.jsp?iIdAffaire="+iIdAffaire
				+"&iIdOnglet="+iIdOnglet));
	}else
	{
		response.sendRedirect(response.encodeRedirectURL(rootPath+"desk/marche/petitesAnnonces/afficherToutesPublications.jsp?iIdAffaire="+iIdAffaire
				+"&iIdOnglet="+iIdOnglet));
	}
%>
