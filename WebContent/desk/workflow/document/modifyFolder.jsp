<%@page import="org.coin.bean.workflow.*"%>

<%@ include file="../../include/beanSessionUser.jspf" %>
<%

	long lIdWorkflowFolder;
	String sAction;

	sAction = request.getParameter("sAction") ;
	String rootPath = request.getContextPath()+"/";
	Folder item = null;

	lIdWorkflowFolder = Integer.parseInt( request.getParameter("lIdWorkflowFolder") );

	if(sAction.equalsIgnoreCase("create"))
		item = new Folder();
	else
		item = Folder.getFolder(lIdWorkflowFolder);

	// partie Group
	if(sAction.equals("remove"))
	{
		String sPageUseCaseId = "xxx";
		%><%@ include file="../../include/checkHabilitationPage.jspf" %><%
		item.remove();
		response.sendRedirect(response.encodeRedirectURL("displayAllFolder.jsp"));
		return;
	}

	if(sAction.equals("store"))
	{
		String sPageUseCaseId = "xxxx";
		%><%@ include file="../../include/checkHabilitationPage.jspf" %><%
		item.setFromFormUTF8(request, "");
		item.store();
	}

	if(sAction.equals("create"))
	{
		String sPageUseCaseId = "xxx";
		%><%@ include file="../../include/checkHabilitationPage.jspf" %><%
		item.setFromFormUTF8(request, "");
		item.create();
	}

	response.sendRedirect(
			response.encodeRedirectURL(
					"displayAllFolder.jsp?nonce=" + System.currentTimeMillis()));
%>