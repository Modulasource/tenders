<%@ include file="../../../../include/new_style/headerDesk.jspf" %>
<%@ page import="org.coin.bean.*"%>
<%
	String sAction = request.getParameter("sAction");

	if (sAction.equals("create"))
	{
		String sPageUseCaseId = "IHM-DESK-PARAM-HAB-4";
		sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
		UseCase item = new UseCase();
		item.setId(request.getParameter("sId"));
		item.setFromForm(request, "");
		item.create();
	}

	if (sAction.equals("remove"))
	{
		UseCase.removeWithObjectAttachedStatic(request.getParameter("sId"));
	}
	
	if (sAction.equals("store"))
	{
		String sPageUseCaseId = "IHM-PUBLI-DESK-HAB-4";
		sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
		boolean bUpdate = false;
		UseCase item = UseCase.getUseCase(request.getParameter("sOldId") );
		if(!request.getParameter("sId").equalsIgnoreCase(item.getIdString())) bUpdate = true;
		
		if(bUpdate){
			item.remove();
			item.setFromFormWithObjectAttached(request, "");
			item.create();
		}
		else{
			item.setFromForm(request, "");
			item.store();			
		}
		
	}
	response.sendRedirect(response.encodeRedirectURL(rootPath+"desk/utilisateur/afficherTousCasUtilisation.jsp"));
%>