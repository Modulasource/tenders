<%@page import="org.coin.bean.param.ObjectParameterTemplate"%>
<%@page import="org.coin.db.CoinDatabaseAbstractBean"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@ include file="/include/beanSessionUser.jspf" %>
<%
	String sAction = request.getParameter("sAction");
	String rootPath = request.getContextPath()+"/";

    if (sAction.equals("remove"))
    {
        String sPageUseCaseId = "IHM-DESK-xxx";
        sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
        ObjectParameterTemplate item = ObjectParameterTemplate.getObjectParameterTemplate(Integer.parseInt(request.getParameter("lId")));
        item.remove();
    }

	
	if (sAction.equals("create"))
	{
		String sPageUseCaseId = "IHM-DESK-xxx";
		sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
		ObjectParameterTemplate item = new ObjectParameterTemplate();
		item.setFromForm(request, "");
		item.create();
	}
	
	if (sAction.equals("store"))
	{
		String sPageUseCaseId = "IHM-DESK-xxx";
		sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
		ObjectParameterTemplate item = ObjectParameterTemplate.getObjectParameterTemplate(Integer.parseInt(request.getParameter("lId")));
        item.setFromForm(request, "");
        item.store();           
	}
	

	if (sAction.equals("duplicate"))
	{
	     String sPageUseCaseId = "IHM-DESK-xxx";
	     sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
	     ObjectParameterTemplate item = ObjectParameterTemplate.getObjectParameterTemplate(Integer.parseInt(request.getParameter("lId")));
         item.setName("Copy of " + item.getName());
         item.setParamName(item.getParamName() + ".copy.of");
	     item.create();           
	 }

	response.sendRedirect(
			response.encodeRedirectURL("displayAllObjectParameterTemplate.jsp"));
%>