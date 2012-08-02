<%@page import="java.util.Vector"%>
<%@page import="org.coin.bean.conf.*"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@ include file="../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.fr.bean.*,org.coin.bean.*" %>
<%
	String sPageUseCaseId = "IHM-DESK-ORG-GROUP-2"; 
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);

	int iIdRootNode = OrganisationGroup.ROOT;
	OrganisationGroup og = new OrganisationGroup();
	Vector<TreeviewNode> vItemList = og.getAll();
	vItemList = TreeviewParsing.getTreeviewNodeList(iIdRootNode,vItemList);

	String sAction = HttpUtil.parseStringBlank("sAction",request);
	long lIdOrganisationGroup = HttpUtil.parseInt("lIdOrganisationGroup",request, 0);

	OrganisationGroup item = null;
	
	if(lIdOrganisationGroup != 0)
	{
		item = 
			OrganisationGroup.getOrganisationGroup(
					lIdOrganisationGroup);
	} 
	
	if(sAction.equals("store"))
	{
		item.setFromForm(request,"");
		item.store();
		
	} else if (sAction.equals("remove")) {
		TreeviewParsing.removeNode(item,vItemList);
	} else if (sAction.equals("left")) {
		TreeviewParsing.moveUpInTreeview(item,vItemList) ;
	}else if (sAction.equalsIgnoreCase("right")){
		System.out.println("item = " + item);
		TreeviewParsing.moveDownInTreeview(item,vItemList) ;
		//item.moveDownInTreeview();
	}else if (sAction.equalsIgnoreCase("up")){
		TreeviewParsing.moveLeftInTreeview(item,vItemList) ;
		//item.moveLeftInTreeview();
	}else if (sAction.equalsIgnoreCase("down")){
		TreeviewParsing.moveRightInTreeview(item,vItemList) ;
		//item.moveRightInTreeview();
	}else if (sAction.equalsIgnoreCase("create")){
		
		int iAddType = Integer.parseInt(request.getParameter("iAddType"));
		OrganisationGroup newNode = 
			new OrganisationGroup();
		newNode.setName("-- new Organisation group --");
		
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

	response.sendRedirect(
		response.encodeRedirectURL("displayAllOrganisationGroup.jsp"));

%>
