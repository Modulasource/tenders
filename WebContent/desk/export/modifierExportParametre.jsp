
<%@ page import="org.coin.fr.bean.export.*,java.io.*"%>
<%@ include file="../include/beanSessionUser.jspf" %>
<%
	String sAction = request.getParameter("sAction");
	String sUrlRedirectTemp ="foo=0";
	if (request.getParameter("sUrlRedirect") != null)
	{
		sUrlRedirectTemp = request.getParameter("sUrlRedirect") ;
	}
	
	if(sAction.equals("remove"))
	{
		int iIdExportParametre = Integer.parseInt(request.getParameter("iIdExportParametre"));
		ExportParametre param = ExportParametre.getExportParametre(iIdExportParametre );
		
		String sUrlRedirect = "afficherExport.jsp?iIdExport=" + param.getIdExport()
				+ "&sUrlRedirect=" + sUrlRedirectTemp
				+ "&nonce=" +System.currentTimeMillis();
		
		param.remove();
		
		response.sendRedirect(response.encodeRedirectURL(sUrlRedirect)); 
		return;
	}


	if(sAction.equals("create"))
	{
		int iIdExport = Integer.parseInt(request.getParameter("iIdExport"));
		ExportParametre param = new ExportParametre();
		
		param.setIdExport(iIdExport);
		
		String sUrlRedirect = "afficherExport.jsp?iIdExport=" + param.getIdExport()
				+ "&sUrlRedirect=" + sUrlRedirectTemp
				+ "&nonce=" +System.currentTimeMillis();

		param.create();

		param.setName("Paramètre " + param.getIdExportParametre());
		param.setValue("Valeur " + param.getIdExportParametre());
		param.store();

		response.sendRedirect(response.encodeRedirectURL(sUrlRedirect)); 
	}	

%>
