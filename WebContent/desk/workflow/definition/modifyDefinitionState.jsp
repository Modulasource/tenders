<%@page import="org.coin.bean.workflow.DefinitionStateType"%>
<%@page import="org.coin.bean.workflow.DefinitionState"%>

<%@ include file="../../include/beanSessionUser.jspf" %>
<%

	long lIdDefinitionState;
	String sAction;

	sAction = request.getParameter("sAction") ;
	String rootPath = request.getContextPath()+"/";
	DefinitionState item = null;

	if(sAction.equals("createFromDefinitionWorkflow"))
	{
		item = new DefinitionState();
		long lIdDefinitionWorkflow = Integer.parseInt( request.getParameter("lIdDefinitionWorkflow") );
		item.setIdDefinitionWorkflow(lIdDefinitionWorkflow);
		item.setIdDefinitionStateType(DefinitionStateType.TYPE_NORMAL);
		item.create();
		item.setName("WF_" + lIdDefinitionWorkflow + " " + item.getId() );
		item.store();
		response.sendRedirect(
				response.encodeRedirectURL(
						"displayDefinitionWorkflow.jsp?lIdDefinitionWorkflow="
						+ item.getIdDefinitionWorkflow() ));
		return;
	}

	lIdDefinitionState = Integer.parseInt( request.getParameter("lIdDefinitionState") );

	if(sAction.equalsIgnoreCase("create"))
		item = new DefinitionState();
	else
		item = DefinitionState.getDefinitionState(lIdDefinitionState);

	// partie Group
	if(sAction.equals("remove"))
	{
		String sPageUseCaseId = "xxx";
		%><%@ include file="../../include/checkHabilitationPage.jspf" %><%
		item.remove();
		response.sendRedirect(
				response.encodeRedirectURL(
						"displayDefinitionWorkflow.jsp?lIdDefinitionWorkflow="
						+ item.getIdDefinitionWorkflow() ));
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
					"displayDefinitionWorkflow.jsp?lIdDefinitionWorkflow="
					+ item.getIdDefinitionWorkflow() ));

	/*response.sendRedirect(
			response.encodeRedirectURL(
					"displayDefinitionState.jsp?lIdDefinitionState=" + item.getId()
					+ "&nonce" + System.currentTimeMillis()));

	*/

%>