<%@page import="org.coin.bean.workflow.DefinitionTransitionCondition"%>
<%@page import="org.coin.bean.workflow.DefinitionStateType"%>
<%@page import="org.coin.bean.workflow.DefinitionState"%>

<%@ include file="../../include/beanSessionUser.jspf" %>
<%

	long lIdDefinitionTransitionCondition;
	String sAction;

	sAction = request.getParameter("sAction") ;
	String rootPath = request.getContextPath()+"/";
	DefinitionTransitionCondition item = null;

	if(sAction.equals("createFromDefinitionTransition"))
	{
		item = new DefinitionTransitionCondition();
		long lIdDefinitionTransition = Integer.parseInt( request.getParameter("lIdDefinitionTransition") );
		item.setIdDefinitionTransition(lIdDefinitionTransition );
		item.setIdDefinitionTransitionConditionClass( 1 /* TODO : Pour PARAPH */);

		item.create();
		item.store();
		response.sendRedirect(
				response.encodeRedirectURL(
						"displayDefinitionTransition.jsp?lIdDefinitionTransition="
						+ item.getIdDefinitionTransistion() ));
		return;
	}

	lIdDefinitionTransitionCondition = Long.parseLong( request.getParameter("lIdDefinitionTransitionCondition") );

	if(sAction.equalsIgnoreCase("create"))
		item = new DefinitionTransitionCondition();
	else
		item = DefinitionTransitionCondition.getDefinitionTransitionCondition(lIdDefinitionTransitionCondition);

	if(sAction.equals("remove"))
	{
		String sPageUseCaseId = "xxx";
		%><%@ include file="../../include/checkHabilitationPage.jspf" %><%
		item.remove();
	}


	if(sAction.equals("copy"))
	{
		String sPageUseCaseId = "xxx";
		%><%@ include file="../../include/checkHabilitationPage.jspf" %><%
		item.setId(-1);
		item.create();
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
					"displayDefinitionTransition.jsp?lIdDefinitionTransition="
					+ item.getIdDefinitionTransistion() ));

%>