<%@page import="mt.website.SitemapPriority"%>
<%@page import="mt.website.WebsiteTreeRoot"%>
<%@page import="mt.website.WebsiteTree"%>
<%@page import="org.coin.util.Outils"%>
<%@page import="java.util.Vector"%>
<%@page import="org.coin.bean.conf.*"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.fr.bean.*,org.coin.bean.*" %>
<%
	String sAction = HttpUtil.parseStringBlank("sAction",request);
	String sName = HttpUtil.parseString("sName", request, "-- nouvelle page --");
	if (sName.equals("")) sName = "-- nouvelle page --";
	String sIndexName = HttpUtil.parseString("sIndexName", request, "");
	long lIdWebsiteTree = HttpUtil.parseInt("lIdWebsiteTree",request, 0);
	WebsiteTree item = null;
	Vector<TreeviewNode> vItemList = new Vector<TreeviewNode>();
	WebsiteTreeRoot root = null;
	if(lIdWebsiteTree != 0){
		item = WebsiteTree.getWebsiteTree(lIdWebsiteTree);
	} 
	
	int iIdRootNode = HttpUtil.parseInt("iIdRootNode",request, 0);
	if(iIdRootNode > 0){
		try{root = WebsiteTreeRoot.getWebsiteTreeRoot(iIdRootNode);
		vItemList = WebsiteTree.getAllTreeviewNode();
		vItemList = TreeviewParsing.getTreeviewNodeList((int)root.getIdWebsiteTree(),vItemList);
		}catch(Exception e){e.printStackTrace();}
	}
   
	
	if(sAction.equals("store"))
	{
	    item.setFromForm(request,"");
		item.store();
		
		
		String sRefId = HttpUtil.parseString("refOrderId",request,"");
	    String[] sRefIds = Outils.parserChaineVersString( sRefId,"|");
	    if(sRefIds != null)
	    {
	    	//VehicleCharacteristicType.storeOrderFromComponentType(item.getId(),sRefIds);
	    }
		
	} else if (sAction.equals("remove")) {
		//TreeviewParsing.removeNode(item,vItemList);
	} else if (sAction.equals("left")) {
		TreeviewParsing.moveUpInTreeview(item,vItemList) ;
	}else if (sAction.equalsIgnoreCase("right")){
		TreeviewParsing.moveDownInTreeview(item,vItemList) ;
		//item.moveDownInTreeview();
	}else if (sAction.equalsIgnoreCase("up")){
		TreeviewParsing.moveUpInTreeview(item,vItemList) ;
		//item.moveLeftInTreeview();
	}else if (sAction.equalsIgnoreCase("down")){
		TreeviewParsing.moveRightInTreeview(item,vItemList) ;
		//item.moveRightInTreeview();
	}else if (sAction.equalsIgnoreCase("create")){
		int iAddType = Integer.parseInt(request.getParameter("iAddType"));
		WebsiteTree newNode = new WebsiteTree();
		newNode.setName(sName);
		newNode.setIndexName(sIndexName);
		newNode.setIdSitemapPriority(SitemapPriority.DEFAULT_PRIORITY);
		
		switch (iAddType )
		{
			case 1 : 
				item.createNewFirstChildNode(newNode);
				break ;
			
			case 2 : 
				item.createNewNextSiblingNode(newNode);
				break ;
			
		}
		
	}
	if (root!=null){
		WebsiteTree.synchronizeWebsiteTreeNodes(root.getIdWebsiteTree());
	}

	response.sendRedirect(
		response.encodeRedirectURL("displayAllWebsiteTree.jsp#"+lIdWebsiteTree));

%>
