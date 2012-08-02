<%@page import="org.coin.db.CoinDatabaseLoadException"%>
<%@page import="modula.journal.Evenement"%>
<%@page import="org.coin.bean.conf.Configuration"%>
<%@page import="org.coin.security.PreventInjection"%>

<%@ page import="org.coin.fr.bean.export.*,org.coin.util.*" %>
<%@ page import="modula.marche.*,org.coin.fr.bean.*" %>
<%@ include file="/include/beanSessionUser.jspf" %>
<%
String sResult = "{success:true,message:'Publication g&eacute;n&eacute;r&eacute;e avec succ&egrave;s'}";
try{
	Export export = Export.getExport(Integer.parseInt( request.getParameter("iIdExport") ));
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	int iIdPublicationType = Integer.parseInt(request.getParameter("iIdPublicationType"));
	int iIdAvisRectificatif = HttpUtil.parseInt("iIdAvisRectificatif",request, 0);
	
	boolean bPublicationLibre = HttpUtil.parseBoolean("bPublicationLibre", request, false);
	String sXml = null;
	

	Organisation organisationPublication 
		= Organisation.getOrganisation(export.getIdObjetReferenceDestination(), false);
	Marche marche = Marche.getMarche(iIdAffaire, false);
	int iIdPublication = 0;
	Publication publication = null; 
	
	if(bPublicationLibre)
	{
		if(organisationPublication.isOrganisationPublicationPublissimo()){
			
			publication = (Publication)PublicationPublissimo.preparePublicationLibre(
					marche.getId(),
					iIdPublicationType,
					export);
			
		}
		else if(organisationPublication.isOrganisationPublicationEmail()){
			publication = (Publication)PublicationEmail.preparePublicationLibre(
					marche.getId(),
					iIdPublicationType,
					export);
		}	
		System.out.println(publication);
		if(publication == null)
		{
			throw new CoinDatabaseLoadException(
					"parametre manquant isPublicationEmail ou isublicationPublissimo"
					+ " pour l'organisme de publication : " + organisationPublication.getRaisonSociale()
					,"");
		}
		
		publication.setReferenceExterne(iIdAvisRectificatif==0?"":""+iIdAvisRectificatif);
		publication.store();
		
	} 
	else 
	{

	    sXml = request.getParameter("sXml");
		// TODO faire mieux la prochaine fois ...
		sXml = Outils.replaceAll(sXml, "&euro;", "euro(s)" );
		sXml = Outils.replaceAll(sXml, "&amp;", "&" );
		//sXml = Outils.replaceAll(sXml, "amp;", "&" );
        sXml = HTMLEntities.unhtmlentities(sXml);
        //sXml = Outils.replaceAll(sXml ,"&eacute;", "&#233;");
        //sXml = Outils.replaceAll(sXml ,"&eacute;", "é");
		//sXml = PreventInjection.preventRequestXMLParameter(sXml);
		
        //sXml = Outils.replaceAll(sXml, "&amp;", "et" );
        //sXml = XMLEntities.cleanUpXMLEntities(sXml);
	
		if(organisationPublication.isOrganisationPublicationPublissimo()){
			publication = (Publication)PublicationPublissimo.preparePublication(
					marche.getId(),
					iIdPublicationType,
					sXml,
					export);
			
		}	
		else if(organisationPublication.isOrganisationPublicationEmail()){
			publication = (Publication)PublicationEmail.preparePublication(
					marche.getId(),
					iIdPublicationType,
					sXml,
					export);
		}
	}
	

	Evenement.addEvenement(
			iIdAffaire, 
			"CU-PUBLICATION-001", 
			sessionUser.getIdUser(),
			"Préparation d'une publication vers "+publication.getOrganisationName());
	iIdPublication = publication.getIdPublication();
	
	if(Boolean.parseBoolean(Configuration.getConfigurationValueMemory("publication.spqr.use.hidden")))	{
		PublicationSpqr.preparePublication(
				marche.getId(),
				iIdPublicationType,
				sXml,
				export,
				iIdPublication);
	}
	
}catch(Exception e){
	e.printStackTrace();
	
	String sMessageRet =  "";
	if(e.getMessage() != null)
	{
		sMessageRet = Outils.addSlashes( Outils.sansAccent(e.getMessage()));
	}
	sResult = "{success:false,message:'Probleme lors de la generation de la publication : "
		+ sMessageRet
		+ "'}";
	
}

out.write(sResult);
%>