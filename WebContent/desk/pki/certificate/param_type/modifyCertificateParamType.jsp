<%@page import="mt.veolia.vfr.vehicle.VehicleType"%>

<%@ include file="../../../../include/beanSessionUser.jspf" %>
<%
	String sAction = request.getParameter("sAction");
	String rootPath = request.getContextPath()+"/";

	if (sAction.equals("create"))
	{
		String sPageUseCaseId = "IHM-DESK-xxx";
		sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
		VehicleType item = new VehicleType();
		item.setFromForm(request, "");
		item.create();
		item.createComponentType();
	}

	if (sAction.equals("remove"))
	{
		VehicleType item = VehicleType.getVehicleTypeMemory(Integer.parseInt(request.getParameter("lId")));
		item.removeWithObjectAttached();
	}
	
	if (sAction.equals("store"))
	{
		String sPageUseCaseId = "IHM-DESK-xxx";
		sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
		VehicleType item = VehicleType.getVehicleTypeMemory(Integer.parseInt(request.getParameter("lId")));
		
		item.setFromForm(request, "");
		item.store();
		item.storeComponentType();
		
		
	}
	
	response.sendRedirect(
			response.encodeRedirectURL("displayAllVehicleType.jsp"));
%>