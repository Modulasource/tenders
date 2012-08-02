
<%@ page import="java.util.Vector"%>
<%@ page import="org.coin.bean.ObjectType"%>
<%@ page import="org.coin.bean.organigram.*"%>
<%@ page import="org.coin.fr.bean.*" %>
<%@ include file="../../include/beanSessionUser.jspf" %>
<%
	Organigram item = null;

	String rootPath = request.getContextPath()+"/";
	String sAction = request.getParameter("sAction");


	if(sAction.equals("store"))
	{
		item
			= Organigram
				.getOrganigram(
					Long.parseLong(
							 request.getParameter("lIdOrganigram")));

		Vector vNode = OrganigramNode.getAllFromIdOrganigram( item.getId());
		for (int i=0; i < vNode.size(); i++)
		{
			OrganigramNode node = (OrganigramNode) vNode.get(i);
			node.setPosX(Long.parseLong( request.getParameter("node_" + node.getId() + "_posX")));
			node.setPosY(Long.parseLong( request.getParameter("node_" + node.getId() + "_posY")));
			node.store();
		}

	}


	response.sendRedirect(
		response.encodeRedirectURL(
				rootPath + "desk/organisation/organigramme/designOrganisationOrganigram.jsp?lIdOrganigram="
			+ item.getId()
			+ "&nonce=" + System.currentTimeMillis()));
%>