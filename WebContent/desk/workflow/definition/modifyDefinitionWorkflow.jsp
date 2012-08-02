<%@page import="org.coin.bean.workflow.DefinitionWorkflow"%>

<%@ include file="../../include/beanSessionUser.jspf" %>
<%

	long lIdDefinitionWorkflow ;
	String sAction;

	lIdDefinitionWorkflow = Integer.parseInt( request.getParameter("lIdDefinitionWorkflow") );
	sAction = request.getParameter("sAction") ;
	String rootPath = request.getContextPath()+"/";
	DefinitionWorkflow item = null;

	if(sAction.equalsIgnoreCase("create"))
		item = new DefinitionWorkflow();
	else
		item = DefinitionWorkflow.getDefinitionWorkflow(lIdDefinitionWorkflow);

	// partie Group
	if(sAction.equals("remove"))
	{
		String sPageUseCaseId = "xxx";
		sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
		item.remove();
		response.sendRedirect(response.encodeRedirectURL("displayAllDefinitionWorkflow.jsp"));
		return;
	}

	if(sAction.equals("store"))
	{
		String sPageUseCaseId = "xxxx";
		sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
		item.setFromForm(request, "");
		item.store();
	}

	if(sAction.equals("create"))
	{
		String sPageUseCaseId = "xxx";
		sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
		item.setFromForm(request, "");
		item.create();
	}

	response.sendRedirect(
			response.encodeRedirectURL(
					"displayDefinitionWorkflow.jsp?lIdDefinitionWorkflow=" + item.getId()
					+ "&nonce" + System.currentTimeMillis()));
%>