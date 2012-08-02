
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="mt.common.addressbook.AddressBookOwner"%><%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.bean.organigram.OrganigramNode"%>
<%@ page import="org.coin.fr.bean.*" %>
<%@page import="modula.graphic.Onglet"%>
<%@ page import="java.util.Vector"%>
<%@ include file="/include/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath()+"/";
	Connection conn = ConnectionManager.getConnection();

	String sAction = request.getParameter("sAction");
	OrganisationService orgService = null;
	OrganigramNode onService = null;
	String sUrlRedirect = null;
	
	if(sAction.equals("store"))
	{

		onService = OrganigramNode.getOrganigramNode(
				Long.parseLong(request.getParameter("on_lIdOrganigramNode")));

		orgService
			= OrganisationService.getOrganisationService(
					Integer.parseInt(request.getParameter("lIdOrganisationService")));

		orgService.setFromFormUTF8(request, "");
		onService.setFromFormUTF8(request, "on_");

		orgService.store();
		onService.store();

		sUrlRedirect = "../afficherOrganisation.jsp?iIdOrganisation="
			+ orgService.getIdOrganisation()
			+ "&iIdOnglet=" + Onglet.ONGLET_ORGANISATION_SERVICE;

	}

	if(sAction.equals("remove"))
	{
		onService = OrganigramNode.getOrganigramNode(
				Long.parseLong(request.getParameter("lIdOrganigramNode")));

		orgService
			= OrganisationService.getOrganisationService(
					onService.getIdReferenceObject() );


		/*  TODO à revoir complètement .....

		Vector<ObjectGroup> vServiceMembre
			= ObjectGroup.getAllGroupObjectFromIdGroupTypeAndObjectReference(
				ObjectGroupType.GROUP_ORGANISATION_SERVICE_MEMBRE,
				ObjectType.ORGANISATION_SERVICE,
				orgService.getId());

		ObjectGroup og = new ObjectGroup();

		if(	vServiceMembre.size() == 0)
		{
			// ne rien supprimer
		}
		else
		{
			if(	vServiceMembre.size() == 1)
			{
				// le groupe
				og = vServiceMembre.get(0);


				ObjectGroupItem ogi = new ObjectGroupItem();
				ogi.remove(" WHERE id_object_group = " + og.getId() );
				ogi = null;

				og.remove();

			}
			else
			{
				throw new Exception("Deux groupes de membres, ce n'est pas permis !");
			}
		}
		*/

		orgService.remove();
		onService.remove();
		
		sUrlRedirect = "../afficherOrganisation.jsp?iIdOrganisation="
			+ orgService.getIdOrganisation()
			+ "&iIdOnglet=" + Onglet.ONGLET_ORGANISATION_SERVICE;

	}

	if(sAction.equals("create"))
	{
		orgService = new OrganisationService();
		onService  = new OrganigramNode();

		orgService.setFromFormUTF8(request, "");
		onService.setFromFormUTF8(request, "on_");
		onService.checkAndStoreParent();

		orgService.create();
		onService.setIdReferenceObject(orgService.getId());
		onService.create();

		sUrlRedirect = "../afficherOrganisation.jsp?iIdOrganisation="
			+ orgService.getIdOrganisation()
			+ "&iIdOnglet=" + Onglet.ONGLET_ORGANISATION_SERVICE;

	}
	
	

	
	if(sAction.equals("linkOwner"))
	{
		orgService
			= OrganisationService.getOrganisationService(
					Integer.parseInt(request.getParameter("lIdOrganisationService")));

		
		long own_lIdObjectTypeOwned = HttpUtil.parseLong("own_lIdObjectTypeOwned", request);
		long own_lIdObjectReferenceOwned = HttpUtil.parseLong("own_lIdObjectReferenceOwned", request);
		
		AddressBookOwner.linkObject(
				own_lIdObjectTypeOwned, 
				own_lIdObjectReferenceOwned,
				orgService,
				conn);

		sUrlRedirect 
			= rootPath 
			+ "desk/organisation/groupe/displayOrganisationService.jsp?lIdOrganisationService="
			+ orgService.getId();

	}
	
	response.sendRedirect(
			response.encodeRedirectURL(
					sUrlRedirect));

%>