
<%@ page import="java.util.*,org.coin.util.treeview.*" %>
<%@ include file="../../include/beanSessionUser.jspf" %>
<%  String sTitle = "HTML TreeView";
	String rootPath = request.getContextPath()+"/";
	String sPageUseCaseId = "IHM-DESK-PARAM-TV-5"; 
%>
<%@ include file="../../include/checkHabilitationPage.jspf" %>
<%
	TreeviewNode node;
	int iIdRootNode = 1;
	try {
		iIdRootNode = Integer.parseInt(request.getParameter( "iIdRootNode" ) );	
	} catch(Exception e) {}

	if (request.getMethod().equalsIgnoreCase("post")
			&& request.getParameter("node_post")!=null){
		
		int iIdNode = Integer.parseInt(request.getParameter("node_post"));
		node = TreeviewNode.getTreeviewNode(iIdNode );
		node.removeInTreeview();
	}

	response.sendRedirect(
			response.encodeRedirectURL(
					"modifierTreeviewForm.jsp?"
					+"iIdRootNode=" + iIdRootNode  
					));
%>