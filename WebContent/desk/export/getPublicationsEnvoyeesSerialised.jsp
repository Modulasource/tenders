<%@ page contentType="text/xml;charset=iso-8859-1" %><?xml version="1.0" encoding="iso-8859-1"?>
<%@page import="org.coin.db.CoinDatabaseAbstractBean"%>
<%@page import="java.util.*,org.coin.fr.bean.export.*,org.coin.bean.*,org.coin.fr.bean.*" %>
<% 
	String rootPath = request.getContextPath()+"/";
	String sAction = request.getParameter("action");
	
	if(sAction != null && sAction.equalsIgnoreCase("remove")){
		try{
			int iIdPublication = Integer.parseInt(request.getParameter("iIdPublication"));
			Publication.getPublication(iIdPublication).removeWithObjectAttached();
		}catch(Exception e){}
	}
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	int iIdExport = Integer.parseInt(request.getParameter("iIdExport"));
	Export export = Export.getExport(iIdExport);
	Organisation organisationPublication = Organisation.getOrganisation(export.getIdObjetReferenceDestination(), false);
	
	String sXml="<publications>";
	if(organisationPublication.isOrganisationPublicationPublissimo())
	{
		Vector<PublicationPublissimo> vPublications
			= PublicationPublissimo
				.getAllPublicationPublissimoFromObjetDestinationAndExport(
					ObjectType.AFFAIRE, 
					iIdAffaire ,
					iIdExport);
		for(int i=0;i<vPublications.size();i++)
			sXml+= vPublications.get(i).serialise(rootPath,request, response,export.getIdObjetReferenceDestination());
		
	}
	else if(organisationPublication.isOrganisationPublicationEmail()){
		Vector<PublicationEmail> vPublications = new Vector<PublicationEmail>();

		vPublications 
			= PublicationEmail
				.getAllPublicationEmailFromObjetDestinationAndExport(
					ObjectType.AFFAIRE, 
					iIdAffaire ,
					iIdExport);
	
		for(int i=0;i<vPublications.size();i++)
			sXml+= vPublications.get(i).serialise(rootPath,request,response,export.getIdObjetReferenceDestination());
	}
	sXml+="</publications>";
%>
<%= sXml %>