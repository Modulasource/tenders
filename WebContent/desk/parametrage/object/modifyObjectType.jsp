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
		ObjectType item = new ObjectType();
		item.setFromForm(request, "");
		item.create();
	}
	
	if (sAction.equals("store"))
	{
		String sPageUseCaseId = "IHM-DESK-xxx";
		boolean bUpdate = false;
		sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
		ObjectType item = ObjectType.getObjectTypeMemory(Integer.parseInt(request.getParameter("lOldId")));
		
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
	
	response.sendRedirect(
			response.encodeRedirectURL("displayAllObjectType.jsp"));
%>