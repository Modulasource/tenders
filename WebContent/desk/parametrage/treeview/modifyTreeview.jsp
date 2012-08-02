<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.localization.Language"%>
<%@page import="org.coin.db.ObjectLocalization"%>
<%@page import="org.coin.util.treeview.TreeviewNode"%>
<%@page import="org.coin.bean.conf.Treeview"%>

<%@ include file="../../include/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath()+"/";

	String sAction = request.getParameter("sAction");

	if(sAction.equals("create"))
	{
		TreeviewNode node = new TreeviewNode("Root node" );
		node.iFirstChildNode = 0;
		node.iNextSiblingNode = 0;
		node.iParentNode = (int)node.getId();
		node.sIconName = "";
		node.sTooltip = "";
		node.sURLLink = "";
		node.create();
		//node.iIdNode = 12;
		
		Treeview item = new Treeview();
		item.setName("Nouvelle Treeview");
		item.setIdMenuTreeview(node.getId());
		item.create();
		
	}

	
	if(sAction.equals("store"))
	{
		long lIdTreeview = Long.parseLong(request.getParameter("lIdTreeview"));
		Treeview item = Treeview.getTreeview(lIdTreeview);
		item.setFromForm(request, "");
		item.store();
	}

	if(sAction.equals("remove"))
	{
		long lIdTreeview = Long.parseLong(request.getParameter("lIdTreeview"));
		Treeview item = Treeview.getTreeview(lIdTreeview);
		item.remove();
	}


	
	response.sendRedirect(response.encodeRedirectURL("displayAllTreeview.jsp"));
%>