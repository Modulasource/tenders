
<%@ page import="org.coin.bean.ObjectType"%>
<%@ page import="org.coin.bean.organigram.*"%>
<%@ page import="org.coin.fr.bean.*" %>
<%@page import="modula.graphic.Onglet"%>
<%@ include file="../../include/beanSessionUser.jspf" %>
<%
	long lIdOrganigramNode = -1;
	OrganisationService service = null;
	OrganigramNode node = null;

	String sAction = request.getParameter("sAction");

	if(sAction.equals("remove"))
	{
		int iIdOrganigramNode = Integer.parseInt(request.getParameter("lIdOrganigramNode"));
		node = OrganigramNode.getOrganigramNode(iIdOrganigramNode);
		node.remove();
	}

	if(sAction.equals("create"))
	{
		node = new OrganigramNode();
		node.setFromFormUTF8(request, "");
		node.create();
		node.checkAndStoreParent();
	}

	if(sAction.equals("store"))
	{
		node = OrganigramNode.getOrganigramNode(
				Long.parseLong(request.getParameter("lIdOrganigramNode")));
		node.setFromFormUTF8(request, "");
		node.store();
	}

	Organigram organigram  = Organigram.getOrganigram(node.getIdOrganigram());

	service
		= OrganisationService.getOrganisationService(
				organigram.getIdReferenceObject());

	Organigram oo = Organigram.getOrganigramFromObject(
			ObjectType.ORGANISATION,
			service.getIdOrganisation(),
			ObjectType.ORGANISATION_SERVICE	);

	OrganigramNode
		nn =  OrganigramNode.getOrganigramNode(
				oo.getId(),
				ObjectType.ORGANISATION_SERVICE,
				service.getId()	);

	lIdOrganigramNode = nn.getId();


	response.sendRedirect(
		response.encodeRedirectURL("displayOrganisationService.jsp?lIdOrganigramNode="
		+ lIdOrganigramNode
		+ "&iIdOnglet="+Onglet.ONGLET_SERVICE_MEMBRES
		+ "&nonce=" + System.currentTimeMillis()));
%>