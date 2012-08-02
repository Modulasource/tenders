<%@page import="org.coin.bean.history.ObjectAttributeHistorizable"%>
<%@page import="org.coin.db.CoinDatabaseAbstractBean"%>
<%@page import="org.coin.bean.ObjectType"%>

<%@ include file="/include/beanSessionUser.jspf" %>
<%
	String sAction = request.getParameter("sAction");
	String rootPath = request.getContextPath()+"/";

	if (sAction.equals("create"))
	{
		String sPageUseCaseId = "IHM-DESK-xxx";
		sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
		ObjectAttributeHistorizable item = new ObjectAttributeHistorizable();
	
		item.setFromForm(request, "");
		item.create();
	}
	
	if (sAction.equals("store"))
	{
		String sPageUseCaseId = "IHM-DESK-xxx";
		boolean bUpdate = false;
		sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
		ObjectAttributeHistorizable item = ObjectAttributeHistorizable.getObjectAttributeHistorizableMemory(Integer.parseInt(request.getParameter("lOldId")));
		long lId = Long.parseLong(request.getParameter("lId"));
		
        if(lId != item.getId()) bUpdate = true;
        
        if(bUpdate){
            item.remove();
            item.setFromForm(request, "");
            item.create();
        }
        else{
            item.setFromForm(request, "");
            item.store();           
        }
	}
	boolean bSucces = true;
	if (sAction.equals("remove"))
	{
		String sPageUseCaseId = "IHM-DESK-xxx";
		sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
		long lId = Long.parseLong(request.getParameter("lId"));
		ObjectAttributeHistorizable item = new ObjectAttributeHistorizable(lId);
		if( item.countObjectAttributeHistoryAttached() == 0){
			new ObjectAttributeHistorizable(lId).remove();
		} else {
			bSucces = false;
			String sMessage = "Delete History items before";
			response.sendRedirect(
					response.encodeRedirectURL("modifyObjectAttributeHistorizableForm.jsp?sAction=store&lId="+item.getId()+"&sMessage="+sMessage));
		}
	}
	
	if( bSucces ){
		response.sendRedirect(
			response.encodeRedirectURL("displayAllObjectAttributeHistorizable.jsp"));
	}
%>