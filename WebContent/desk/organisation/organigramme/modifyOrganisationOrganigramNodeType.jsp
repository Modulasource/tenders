<%@page import="modula.graphic.Onglet"%>

<%@ page import="org.coin.bean.ObjectType"%>
<%@ page import="org.coin.bean.organigram.*"%>
<%@ page import="org.coin.fr.bean.*" %>
<%@ include file="../../include/beanSessionUser.jspf" %>
<%
	long lIdOrganisation = -1;

	String rootPath = request.getContextPath()+"/";
	String sAction = request.getParameter("sAction");
	lIdOrganisation = Long.parseLong(request.getParameter("lIdOrganisation"));

	if(sAction.equals("remove"))
	{
		int iIdOrganigramNodeType = Integer.parseInt(request.getParameter("lIdOrganigramNodeType"));
		OrganigramNodeType item = OrganigramNodeType.getOrganigramNodeType(iIdOrganigramNodeType);
		item.remove();
	}

	if(sAction.equals("create"))
	{
		OrganigramNodeType item = new OrganigramNodeType();
		item.setFromFormUTF8(request, "");
		item.create();
	}

	if(sAction.equals("store"))
	{
		OrganigramNodeType item= OrganigramNodeType.getOrganigramNodeType(
				Long.parseLong(request.getParameter("lIdOrganigramNodeType")));
		item.setFromFormUTF8(request, "");
		item.store();
	}

	response.sendRedirect(
		response.encodeRedirectURL(
				rootPath + "desk/organisation/afficherOrganisation.jsp?iIdOrganisation="
			+ lIdOrganisation
			+ "&iIdOnglet=" + Onglet.ONGLET_ORGANISATION_ORGANIGRAM
			+ "&nonce=" + System.currentTimeMillis()));
%>