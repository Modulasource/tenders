
<%@ page import="org.coin.bean.ObjectType"%>
<%@ page import="org.coin.bean.organigram.*"%>
<%@ page import="org.coin.fr.bean.*" %>
<%@page import="modula.graphic.Onglet"%>
<%@ include file="../../include/beanSessionUser.jspf" %>
<%
	long lIdOrganisation = -1;
	Organisation organisation = null;

	String rootPath = request.getContextPath()+"/";
	String sAction = request.getParameter("sAction");

	if(sAction.equals("remove"))
	{
		int iIdOrganigramNode = Integer.parseInt(request.getParameter("lIdOrganigramNode"));
		OrganigramNode node = OrganigramNode.getOrganigramNode(iIdOrganigramNode);
		Organigram organigram  = Organigram.getOrganigram(node.getIdOrganigram());
		lIdOrganisation = organigram.getIdReferenceObject();
		node.remove();
	}

	if(sAction.equals("create"))
	{
		OrganigramNode node = new OrganigramNode();
		node.setFromFormUTF8(request, "");
		node.create();

		if(node.getIdOrganigramNodeParent() == 0
		|| node.getIdOrganigramNodeParent() == -1 )
		{
			// on le fait boucler sur lui meme
			node.setIdOrganigramNodeParent(node.getId()) ;
			node.store();
		}

		Organigram organigram  = Organigram.getOrganigram(node.getIdOrganigram());
		lIdOrganisation = organigram.getIdReferenceObject();
	}

	if(sAction.equals("store"))
	{
		OrganigramNode node = OrganigramNode.getOrganigramNode(
				Long.parseLong(request.getParameter("lIdOrganigramNode")));
		node.setFromFormUTF8(request, "");
		node.store();

		Organigram organigram  = Organigram.getOrganigram(node.getIdOrganigram());
		lIdOrganisation = organigram.getIdReferenceObject();
	}

	response.sendRedirect(
		response.encodeRedirectURL(
				rootPath + "desk/organisation/afficherOrganisation.jsp?iIdOrganisation="
	+ lIdOrganisation
	+ "&iIdOnglet=" + Onglet.ONGLET_ORGANISATION_ORGANIGRAM
	+ "&nonce=" + System.currentTimeMillis()));
%>