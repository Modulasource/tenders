<%@page import="java.util.Vector"%>

<%@ page import="org.coin.bean.ObjectType"%>
<%@ page import="org.coin.bean.organigram.*"%>
<%@ page import="org.coin.fr.bean.*" %>
<%@page import="modula.graphic.Onglet"%>
<%@ include file="../../include/beanSessionUser.jspf" %>
<%
	long lIdOrganigramNode = -1;
	OrganisationService service= null;
	OrganigramNode node = null;

	String sAction = request.getParameter("sAction");

	if(sAction.equals("remove"))
	{
		int iIdOrganigram = Integer.parseInt(request.getParameter("lIdOrganigram"));
		Organigram organigram = Organigram.getOrganigram(iIdOrganigram);
		Vector vNode = OrganigramNode.getAllFromIdOrganigram( organigram.getId() );
		for(int i =0 ; i < vNode.size(); i++ )
		{
			OrganigramNode nodeTmp = (OrganigramNode) vNode.get(i);
			nodeTmp.remove();
		}

		organigram.remove();
	}

	if(sAction.equals("create"))
	{
		lIdOrganigramNode = Integer.parseInt(request.getParameter("lIdOrganigramNode"));
		node = OrganigramNode.getOrganigramNode (lIdOrganigramNode);
		service= OrganisationService.getOrganisationService(node.getIdReferenceObject());
		Organigram organigram = new Organigram();
		organigram.setIdTypeObject(ObjectType.ORGANISATION_SERVICE);
		organigram.setIdTypeObjectNode(ObjectType.PERSONNE_PHYSIQUE);
		organigram.setIdReferenceObject(service.getId());
		organigram.setName("Organigramme du service " + service.getNom());
		organigram.setDescription("Organigramme du service " + service.getNom());
		organigram.create();
	}

	if(sAction.equals("store"))
	{

	}




	response.sendRedirect(
		response.encodeRedirectURL("displayOrganisationService.jsp?lIdOrganigramNode="
			+ node.getId()
			+ "&iIdOnglet="+Onglet.ONGLET_SERVICE_MEMBRES
			+ "&nonce=" + System.currentTimeMillis()));
%>