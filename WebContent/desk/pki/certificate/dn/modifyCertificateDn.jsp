<%@page import="org.coin.bean.pki.certificate.PkiCertificateDn"%>

<%@ include file="../../../../include/beanSessionUser.jspf" %>
<%
	String sAction = request.getParameter("sAction");
	String rootPath = request.getContextPath()+"/";

	if (sAction.equals("create"))
	{
		String sPageUseCaseId = "IHM-DESK-xxx";
		sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
		PkiCertificateDn item = new PkiCertificateDn();
		item.setFromForm(request, "");
		item.create();
	}

	if (sAction.equals("remove"))
	{
		PkiCertificateDn item = PkiCertificateDn.getPkiCertificateDn(Integer.parseInt(request.getParameter("lId")));
		item.remove();
	}
	
	if (sAction.equals("store"))
	{
		String sPageUseCaseId = "IHM-DESK-xxx";
		sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
		PkiCertificateDn item = PkiCertificateDn.getPkiCertificateDn(Integer.parseInt(request.getParameter("lId")));
		
		item.setFromForm(request, "");
		item.store();
	}
	
	response.sendRedirect(
			response.encodeRedirectURL("displayAllCertificateDn.jsp"));
%>