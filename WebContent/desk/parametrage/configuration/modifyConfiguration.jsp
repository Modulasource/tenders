
<%@page import="org.coin.util.HTMLEntities"%>
<%@page import="org.coin.util.WindowsEntities"%>
<%@page import="org.coin.security.PreventInjection"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@ page import="org.coin.bean.conf.*"%>
<%@ include file="/include/beanSessionUser.jspf" %>
<%
	String sAction = request.getParameter("sAction");
	String rootPath = request.getContextPath()+"/";

	if (sAction.equals("create"))
	{
		String sPageUseCaseId = "IHM-DESK-PARAM-CONF-2";
		sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
		Configuration item = new Configuration();
		item.setFromForm(request, "");
		item.setDescription(request.getParameter("sDescription"));
		item.create();
	}

	if (sAction.equals("remove"))
	{
		Configuration item = Configuration.getConfigurationMemory(request.getParameter("sId"));
		item.remove();
	}
	
	if (sAction.equals("store"))
	{
		String sPageUseCaseId = "IHM-DESK-PARAM-CONF-2";
		sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
		boolean bUpdate = false;
		Configuration item = Configuration.getConfigurationMemory(request.getParameter("sOldId"));
		if(!request.getParameter("sId").equalsIgnoreCase(item.getIdString())) bUpdate = true;
		
		boolean bUseFieldValueFilter = HttpUtil.parseBoolean("bUseFieldValueFilter", request, true);
		String sDescription = request.getParameter("sDescription");
		
		if(!bUseFieldValueFilter && sDescription != null) {
            sDescription = WindowsEntities.cleanUpWindowsEntities(HTMLEntities.unhtmlentitiesComplete(sDescription));
            item.bUseHttpPrevent = false;
            item.bUseFieldValueFilter = false;
		}
        
		if(bUpdate){
			item.remove();
			item.setFromForm(request, "");
			if(sDescription != null) item.setDescription(sDescription);
			item.create();
		}
		else{
			item.setFromForm(request, "");
			if(sDescription != null) item.setDescription(sDescription);
			item.store();			
		}
	}
	response.sendRedirect(
			response.encodeRedirectURL(
					rootPath+"desk/parametrage/configuration/displayAllConfiguration.jsp"));
%>