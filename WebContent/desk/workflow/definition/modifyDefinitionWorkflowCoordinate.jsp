
<%@ page import="java.util.Vector"%>
<%@ page import="org.coin.bean.ObjectType"%>
<%@ page import="org.coin.fr.bean.*" %>
<%@page import="org.coin.bean.workflow.*"%>
<%@ include file="../../include/beanSessionUser.jspf" %>
<%
	DefinitionWorkflow item = null;

	String sAction = request.getParameter("sAction");


	if(sAction.equals("store"))
	{
		item
			= DefinitionWorkflow
				.getDefinitionWorkflow(
					Long.parseLong(
							 request.getParameter("lIdDefinitionWorkflow")));

		Vector vState = DefinitionState.getAllFromIdDefinitionWorkflow( item.getId());
		for (int i=0; i < vState.size(); i++)
		{
			DefinitionState state = (DefinitionState) vState.get(i);
			state.setPosX(Long.parseLong( request.getParameter("state_" + state.getId() + "_posX")));
			state.setPosY(Long.parseLong( request.getParameter("state_" + state.getId() + "_posY")));
			state.store();
		}


		Vector vTransition= DefinitionTransition.getAllFromIdDefinitionWorkflow( item.getId());
		for (int i=0; i < vTransition.size(); i++)
		{
			DefinitionTransition transition = (DefinitionTransition) vTransition.get(i);
			transition.setPosX(Long.parseLong( request.getParameter("transition_" + transition.getId() + "_posX")));
			transition.setPosY(Long.parseLong( request.getParameter("transition_" + transition.getId() + "_posY")));
			transition.store();
		}

	}


	response.sendRedirect(
		response.encodeRedirectURL("designDefinitionWorkflow.jsp?lIdDefinitionWorkflow="
			+ item.getId()
			+ "&nonce=" + System.currentTimeMillis()));
%>