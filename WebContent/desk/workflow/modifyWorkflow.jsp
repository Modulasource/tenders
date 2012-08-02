<%@page import="org.coin.db.CoinDatabaseAbstractBean"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@ page import="org.coin.bean.workflow.*"%>

<%@ include file="../include/beanSessionUser.jspf" %>
<%

	long lIdWorkflow;
	String sAction;

	sAction = request.getParameter("sAction") ;
	String rootPath = request.getContextPath()+"/";
	Workflow item = null;


	lIdWorkflow = Integer.parseInt( request.getParameter("lIdWorkflow") );

	if(sAction.equalsIgnoreCase("create"))
		item = new Workflow();
	else
		item = Workflow.getWorkflow(lIdWorkflow);

	// partie Group
	if(sAction.equals("remove"))
	{
		String sPageUseCaseId = "xxx";
		%><%@ include file="../include/checkHabilitationPage.jspf" %><%

		item.removeWithObjectAttached();
		response.sendRedirect(response.encodeRedirectURL("displayAllWorkflow.jsp"));
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
		item.createWithObjectAttached(
				ObjectType.PERSONNE_PHYSIQUE,
				sessionUser.getIdIndividual() );

	}

	response.sendRedirect(
			response.encodeRedirectURL(
					"displayAllWorkflow.jsp?nonce=" + System.currentTimeMillis()));
%>