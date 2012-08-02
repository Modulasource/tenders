
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
		int iIdExportModeEmailDestinataire = Integer.parseInt(request.getParameter("iIdExportModeEmailDestinataire"));
		ExportModeEmailDestinataire destinataire = ExportModeEmailDestinataire.getExportModeEmailDestinataire(iIdExportModeEmailDestinataire );
		
		String sUrlRedirect = "afficherExport.jsp?iIdExport=" + destinataire.getIdExport()
				+ "&sUrlRedirect=" + sUrlRedirectTemp
				+ "&nonce=" +System.currentTimeMillis();
		
		destinataire.remove();
	
		System.out.println("sUrlRedirect = " + sUrlRedirect);

		response.sendRedirect(response.encodeRedirectURL(sUrlRedirect)); 
	}


	if(sAction.equals("create"))
	{
		int iIdExport = Integer.parseInt(request.getParameter("iIdExport"));
		ExportModeEmailDestinataire destinataire = new ExportModeEmailDestinataire();
		
		destinataire.setIdExport(iIdExport);
		
		String sUrlRedirect = "afficherExport.jsp?iIdExport=" + destinataire.getIdExport()
				+ "&sUrlRedirect=" + sUrlRedirectTemp
				+ "&nonce=" +System.currentTimeMillis();

		destinataire.create();

		destinataire.setEmailDestinataire("Email " + destinataire.getIdExportModeEmailDestinataire());
		destinataire.setTypeDestinataire("Type " + destinataire.getIdExportModeEmailDestinataire());
		destinataire.store();

		response.sendRedirect(response.encodeRedirectURL(sUrlRedirect)); 
		return;
	}	
%>