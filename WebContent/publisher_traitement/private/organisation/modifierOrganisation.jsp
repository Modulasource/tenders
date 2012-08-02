
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="org.coin.bean.ws.AddressBookWebService"%><%@page import="org.coin.bean.ws.OrganisationWebService"%>

<%@ page import="org.coin.util.*,java.sql.*,org.coin.fr.bean.*,modula.*,modula.graphic.*,org.coin.bean.*" %>
<%@ include file="/publisher_traitement/public/include/beanSessionUser.jspf" %>
<%@ include file="/publisher_traitement/public/include/beanCandidat.jspf" %> 
<%@ include file="/include/publisherType.jspf" %> 
<%
	String rootPath = request.getContextPath()+"/";
	Connection conn = ConnectionManager.getConnection();	
	int iIdOnglet = -1;
	try{iIdOnglet = Integer.parseInt(request.getParameter("iIdOnglet"));}
	catch(Exception e){}
	boolean bRedirectToIndex = false;
	try { bRedirectToIndex = !Boolean.parseBoolean(request.getParameter("bDisplayAll")); }
	catch(Exception e){}
	
	if(bRedirectToIndex) {
		response.sendRedirect(response.encodeRedirectURL(rootPath + "publisher_portail/private/candidat/indexCandidat.jsp"));
	}
	if( iIdOnglet == Onglet.ONGLET_ORGANISATION_DONNEES_ADMINISTRATIVES)
	{
		organisation.setFromFormDonneesAdministratives(request,"");
		organisation.store();
	}
				
	if( iIdOnglet == Onglet.ONGLET_ORGANISATION_COORDONNEES)
	{
		organisation.setFromFormCoordonnees(request,"");
		organisation.store();
	}

	if( iIdOnglet == Onglet.ONGLET_ORGANISATION_ADRESSE)
	{
		Adresse adresse = Adresse.getAdresse(organisation.getIdAdresse());
		adresse.setFromForm(request, "");
		adresse.store();
	}
	
	/**
	 * Web Service
	 */
	if(AddressBookWebService.isActivated(conn))
    {
        try{
            OrganisationWebService wsOrga = AddressBookWebService.newInstanceOrganisationWebService(conn);
            if(wsOrga.isSynchronized(organisation,conn))
            {
                wsOrga.synchroStore(organisation, conn);
            }
        } catch(Exception e ) {
            e.printStackTrace();                    
        }
    }

	response.sendRedirect(
			response.encodeRedirectURL(
					rootPath + sPublisherPath
					+ "/private/organisation/afficherOrganisation.jsp"
					+ "?iIdOnglet="+ iIdOnglet));
	
	ConnectionManager.closeConnection(conn);
%>