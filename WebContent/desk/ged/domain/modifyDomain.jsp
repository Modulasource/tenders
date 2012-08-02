<%@page import="org.coin.bean.ged.GedDomain"%>

<%@ include file="../../../../include/beanSessionUser.jspf" %>
<%
	String sAction = request.getParameter("sAction");
	String rootPath = request.getContextPath()+"/";

	if (sAction.equals("create"))
	{
		String sPageUseCaseId = "IHM-DESK-xxx";
		sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
		GedDomain item = new GedDomain();
		item.setFromForm(request, "");
		item.create();
	}

	if (sAction.equals("remove"))
	{
		GedDomain item = GedDomain.getGedDomain(Integer.parseInt(request.getParameter("lId")));
		item.remove();
	}
	
	if (sAction.equals("store"))
	{
		String sPageUseCaseId = "IHM-DESK-xxx";
		sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
		GedDomain item = GedDomain.getGedDomain(Integer.parseInt(request.getParameter("lId")));
		
		item.setFromForm(request, "");
		item.store();			
	}
	
	response.sendRedirect(
			response.encodeRedirectURL("displayAllDomain.jsp"));
%>