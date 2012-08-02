<%@page import="org.coin.bean.workflow.*"%>

<%@ include file="../include/beanSessionUser.jspf" %>
<%

	long lIdPathEvent;
	String sAction;

	sAction = request.getParameter("sAction") ;
	String rootPath = request.getContextPath()+"/";
	PathEvent item = null;


	lIdPathEvent = Integer.parseInt( request.getParameter("lIdPathEvent") );

	if(sAction.equalsIgnoreCase("create"))
		item = new PathEvent();
	else
		item = PathEvent.getPathEvent(lIdPathEvent);

	// partie Group
	if(sAction.equals("remove"))
	{
		String sPageUseCaseId = "xxx";
		%><%@ include file="../include/checkHabilitationPage.jspf" %><%
		item.remove();
		response.sendRedirect(response.encodeRedirectURL("displayAllPathEvent.jsp"));
		return;
	}

	if(sAction.equals("store"))
	{
		String sPageUseCaseId = "xxxx";
		%><%@ include file="../include/checkHabilitationPage.jspf" %><%
		item.setFromForm(request, "");
		item.store();
	}

	if(sAction.equals("create"))
	{
		String sPageUseCaseId = "xxx";
		%><%@ include file="../include/checkHabilitationPage.jspf" %><%
		item.setFromForm(request, "");
		item.create();
	}

	response.sendRedirect(
			response.encodeRedirectURL(
					"displayAllPathEvent.jsp?nonce=" + System.currentTimeMillis()));
%>