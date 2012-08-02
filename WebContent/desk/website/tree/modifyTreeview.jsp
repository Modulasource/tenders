<%@page import="org.coin.util.HttpUtil"%>
<%@page import="mt.website.WebsiteTree"%>
<%@page import="mt.website.WebsiteTreeRoot"%>
<%@page import="org.coin.bean.conf.Treeview"%>
<%@ include file="/include/new_style/headerDesk.jspf" %>
<%
	String sAction = request.getParameter("sAction");
	String sName = HttpUtil.parseString("sName", request, "-- nouvelle page --");
	long lIdWebsiteTreeRoot = HttpUtil.parseInt("lIdWebsiteTreeRoot", request, 0);
	if (sName.equals("")) sName = "Nouvelle arborescence";

	if(sAction.equals("create")){
		WebsiteTree node = new WebsiteTree();
		node.setIdTreeviewNodeFirstChild(0);
		node.setIdTreeviewNodeNextSibling(0);
		node.setName("-- racine --");
		node.setIndexName("racine");
		node.create();
		
		WebsiteTreeRoot root = new WebsiteTreeRoot();
		root.setName(sName);
		root.setIdWebsiteTree(node.getId());
		root.create();		
	}

	
	if(sAction.equals("store"))
	{
		long lIdTreeview = Long.parseLong(request.getParameter("lIdTreeview"));
		Treeview item = Treeview.getTreeview(lIdTreeview);
		item.setFromForm(request, "");
		item.store();
	}

	if(sAction.equals("remove") && lIdWebsiteTreeRoot>0){
		WebsiteTreeRoot root = WebsiteTreeRoot.getWebsiteTreeRoot(lIdWebsiteTreeRoot);
		WebsiteTree.removeFromId(root.getIdWebsiteTree(), root.getIdWebsiteTree());
		root.remove();
	}


	
	response.sendRedirect(response.encodeRedirectURL("displayAllWebsiteTree.jsp"));
%>