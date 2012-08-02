<%@page import="java.util.Vector"%>
<%@page import="org.coin.bean.workflow.*"%>

<%@ include file="../../include/beanSessionUser.jspf" %>
<%

	long lIdDefinitionTransition;
	String sAction;

	sAction = request.getParameter("sAction") ;
	String rootPath = request.getContextPath()+"/";
	DefinitionTransition item = null;

	if(sAction.equals("createFromDefinitionState"))
	{
		item = new DefinitionTransition();
		/*long lIdDefinitionWorkflow = Integer.parseInt( request.getParameter("lIdDefinitionWorkflow") );
		item.setIdDefinitionWorkflow(lIdDefinitionWorkflow);
		item.create();
		item.setName("WF_" + lIdDefinitionWorkflow + " " + item.getId() );
		item.store();
		response.sendRedirect(
				response.encodeRedirectURL(
						"displayDefinitionWorkflow.jsp?lIdDefinitionWorkflow="
						+ item.getIdDefinitionWorkflow() ));
		*/
		return;
	}

	lIdDefinitionTransition = Integer.parseInt( request.getParameter("lIdDefinitionTransition") );

	if(sAction.equalsIgnoreCase("create"))
		item = new DefinitionTransition();
	else
		item = DefinitionTransition.getDefinitionTransition(lIdDefinitionTransition);

	// partie Group
	if(sAction.equals("remove"))
	{
		String sPageUseCaseId = "xxx";
		%><%@ include file="../../include/checkHabilitationPage.jspf" %><%
		Vector <DefinitionTransitionCondition> vCondition
			= DefinitionTransitionCondition.getAllFromIdDefinitionTransition(item.getId());

		for(int i=0; i < vCondition.size() ; i++)
		{
			DefinitionTransitionCondition condition
				= (DefinitionTransitionCondition) vCondition.get(i);
			condition.remove();
		}

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
					"displayDefinitionWorkflow.jsp?lIdDefinitionWorkflow=" + item.getIdDefinitionWorkflow()
					+ "&nonce" + System.currentTimeMillis()));
%>