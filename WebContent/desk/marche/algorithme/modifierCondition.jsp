
<%@ page import="modula.algorithme.condition.*" %>
<%
	
	String sAction = "store";
	int iIdCondition;
	String rootPath = request.getContextPath()+"/";

	sAction  = request.getParameter("sAction") ;
	iIdCondition = -1;
	ConditionBean condition = null;
	
	if(sAction.equals("remove") )
	{
		iIdCondition = Integer.parseInt( request.getParameter("iIdCondition") );
		condition = ConditionBean.getConditionBean(iIdCondition);
		condition.remove();
		response.sendRedirect(response.encodeRedirectURL("afficherToutesConditions.jsp") );
		return;
	}
	
	if(sAction.equals("store") )
	{
		iIdCondition = Integer.parseInt( request.getParameter("iIdCondition") );
		condition = ConditionBean.getConditionBean(iIdCondition);
		condition.setName( request.getParameter("sName") );
		condition.store();
	}
	
	if(sAction.equals("create") )
	{
		condition = new ConditionBean();
		condition.setName( request.getParameter("sName") );
		condition.create();
	}
	response.sendRedirect(response.encodeRedirectURL("afficherCondition.jsp?iIdCondition=" + condition.getId()));

	
%>