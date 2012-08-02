<%@page import="org.coin.bean.ged.GedDocumentType"%>
<%@page import="org.coin.bean.ged.GedFolderType"%>

<%@ include file="../../../../include/beanSessionUser.jspf" %>
<%
	String sAction = request.getParameter("sAction");
	String rootPath = request.getContextPath()+"/";

	if (sAction.equals("create"))
	{
		String sPageUseCaseId = "IHM-DESK-xxx";
		sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
		GedDocumentType item = new GedDocumentType();
		item.setFromForm(request, "");
		item.create();
	}

	if (sAction.equals("remove"))
	{
		GedDocumentType item = GedDocumentType.getGedDocumentType(Integer.parseInt(request.getParameter("lId")));
		item.remove();
	}
	
	if (sAction.equals("store"))
	{
		String sPageUseCaseId = "IHM-DESK-xxx";
		sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
		GedDocumentType item = GedDocumentType.getGedDocumentType(Integer.parseInt(request.getParameter("lId")));
		
		item.setFromForm(request, "");
		item.store();			
	}
	
	response.sendRedirect(
			response.encodeRedirectURL("displayAllDocumentType.jsp"));
%>