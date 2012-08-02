<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.localization.Language"%>
<%@page import="org.coin.db.ObjectLocalization"%>

<%@ page import="org.coin.util.treeview.*" %>
<%@ include file="../../include/beanSessionUser.jspf" %>
<%  String sTitle = "HTML TreeView";
	String rootPath = request.getContextPath()+"/";

	String sPageUseCaseId = "IHM-DESK-PARAM-TV-6"; 
%><%@ include file="../../include/checkHabilitationPage.jspf" %><%

	int iIdRootNode = 1;
	try {
		iIdRootNode = Integer.parseInt(request.getParameter( "iIdRootNode" ) );	
	} catch(Exception e) {}

	int iIdNode;
	iIdNode = Integer.parseInt(request.getParameter("iIdNode"));
	TreeviewNode node = new TreeviewNode( iIdNode );
	node.setFromForm(request, "");
	node.store();
	response.sendRedirect(
		response.encodeRedirectURL(
			"modifierTreeviewForm.jsp?"
			+"iIdRootNode=" + iIdRootNode  
			+"#ancre_"+iIdNode));

	
%>
