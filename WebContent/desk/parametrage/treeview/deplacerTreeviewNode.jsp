
<%@ page import="java.util.*,org.coin.util.treeview.*" %>
<%@ include file="../../include/beanSessionUser.jspf" %>
<% 
	String rootPath = request.getContextPath()+"/";
	int iIdNode = Integer.parseInt(request.getParameter("iIdNode"));
	String sAction = request.getParameter("sAction");
	TreeviewNode node = TreeviewNode.getTreeviewNode(iIdNode );
	String sPageUseCaseId = "IHM-DESK-PARAM-TV-7"; 
%><%@ include file="../../include/checkHabilitationPage.jspf" %><%
	int iIdRootNode = 1;
	try {
		iIdRootNode = Integer.parseInt(request.getParameter( "iIdRootNode" ) );	
	} catch(Exception e) {}
	

	if (sAction.equalsIgnoreCase("left")){
		node.moveUpInTreeview();
	}else if (sAction.equalsIgnoreCase("right")){
		node.moveDownInTreeview();
	}else if (sAction.equalsIgnoreCase("up")){
		node.moveLeftInTreeview();
	}else if (sAction.equalsIgnoreCase("down")){
		node.moveRightInTreeview();
	}

	response.sendRedirect(
		response.encodeRedirectURL(
				"modifierTreeviewForm.jsp?"
				+"iIdRootNode=" + iIdRootNode  
				+"#ancre_"+iIdNode));
%>