
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.db.ConnectionManager"%><%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.bean.ged.GedCategorySelection"%>
<%@page import="org.coin.bean.ged.GedFolder"%>
<%@page import="org.coin.bean.ged.GedFolderType"%>

<%@ include file="/include/beanSessionUser.jspf" %>
<%
	String sAction = request.getParameter("sAction");
	String rootPath = request.getContextPath()+"/";
	String sCategoryList = HttpUtil.parseString("sCategoryList", request, "");

	if (sAction.equals("create"))
	{
		String sPageUseCaseId = "IHM-DESK-xxx";
		sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
		GedFolder item = new GedFolder();
		item.setFromForm(request, "");
		item.create();
		if (item.getId()>0){
			GedCategorySelection.storeAndUpdateFromStringTypeObjectAndReferenceObject(
					sCategoryList, ObjectType.GED_FOLDER, item.getId());
		}
	}

	if (sAction.equals("remove"))
	{
		GedFolder item = GedFolder.getGedFolder(Integer.parseInt(request.getParameter("lId")));
		GedCategorySelection.removeAllFromTypeAndReferenceObject(ObjectType.GED_FOLDER, item.getId());
		item.remove();
	}
	
	if (sAction.equals("store"))
	{
		String sPageUseCaseId = "IHM-DESK-xxx";
		sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
		GedFolder item = GedFolder.getGedFolder(Integer.parseInt(request.getParameter("lId")));
		
		item.setFromForm(request, "");
		if (item.getId()>0){
			GedCategorySelection.storeAndUpdateFromStringTypeObjectAndReferenceObject(
					sCategoryList, ObjectType.GED_FOLDER, item.getId());
		}
		item.store();			
	}
	
    if (sAction.equals("duplicate"))
    {
        String sPageUseCaseId = "IHM-DESK-xxx";
        sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
        GedFolder item = GedFolder.getGedFolder(Integer.parseInt(request.getParameter("lId")));
        
        Connection conn = ConnectionManager.getConnection();

        GedFolder itemNew = GedFolder.duplicateGedFolder(item, "copie de ", conn);  
        
        ConnectionManager.closeConnection(conn);
    }
	
	response.sendRedirect(
			response.encodeRedirectURL("displayAllFolder.jsp"));
%>