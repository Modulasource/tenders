<%@page import="org.coin.bean.ObjectType"%>
<%@ include file="../../../../include/headerXML.jspf" %>

<%@ page import="org.coin.fr.bean.*,java.util.*,org.coin.fr.bean.mail.*" %>
<%@ include file="../../../include/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath()+"/";
	int iIdMailing = Integer.parseInt( request.getParameter("iIdMailing") );
	int iIdOrganisation = Integer.parseInt( request.getParameter("iIdOrganisation") );
	
	String [] sarrIdPersonnePhysiqueSelected =  request.getParameterValues("iIdPersonnePhysique");
	Organisation organisation = Organisation.getOrganisation(iIdOrganisation );

	// 1. on récupere les anciens
	Vector<MailingDestinataire> vMailingDestinatairePersonnesPhysiqueSelected 
		= MailingDestinataire.getAllForPersonnePhysiqueSelected(iIdMailing, organisation.getIdOrganisation());

	
	// 2. on les supprime de la base
	for(int i= 0; i < vMailingDestinatairePersonnesPhysiqueSelected.size() ; i++)
	{
		MailingDestinataire md = vMailingDestinatairePersonnesPhysiqueSelected.get(i);
		md.remove();
	}

	MailingDestinataire mdOrg = MailingDestinataire.getOrganisationSelected(iIdMailing, organisation.getIdOrganisation());
	if (mdOrg != null) mdOrg.remove();

	if( request.getParameter("bOrganisationChecked")  != null)
	{
		MailingDestinataire md = new MailingDestinataire();
		md.setIdMailing(iIdMailing);
		md.setIdObjetReference(organisation.getIdOrganisation());
		md.setIdTypeObjet(ObjectType.ORGANISATION);
		md.create();
	}
	

	if(sarrIdPersonnePhysiqueSelected != null)
		for(int i = 0; i <sarrIdPersonnePhysiqueSelected.length  ;i++)
		{
			MailingDestinataire md = new MailingDestinataire();
			md.setIdMailing(iIdMailing);
			md.setIdObjetReference(Integer.parseInt(sarrIdPersonnePhysiqueSelected[i]));
			md.setIdTypeObjet(ObjectType.PERSONNE_PHYSIQUE);
			md.create();
		}
		
	response.sendRedirect( 
		response.encodeRedirectURL("modifierDestinatairesFromOrganisationForm.jsp?iIdMailing=" 
			+ iIdMailing + "&bClosePopUp=true&iIdOrganisation=" + iIdOrganisation
			+ "&nonce=" + System.currentTimeMillis()) );
%>
