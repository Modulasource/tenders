
<%@ page import="modula.ws.marco.*" %>
<%@ include file="../../include/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath()+"/";
	String sFormPrefix = "";
	String sAction = request.getParameter("sAction");
	int iIdExport = -1;
	
	try{
		iIdExport = Integer.parseInt( request.getParameter("iIdExportMarco") );
	}catch (Exception e) {}
	
	if(request.getParameter("sAction") == null) sAction="";
	
	
	if(sAction.equals("remove"))
	{
		ExportMarco export = ExportMarco.getExportMarco(iIdExport);
		export.remove();
		response.sendRedirect( response.encodeRedirectURL("afficherListeExport.jsp") );
		
		return;
	}
	
%>