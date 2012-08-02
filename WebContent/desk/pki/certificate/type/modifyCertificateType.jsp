<%@page import="org.coin.bean.pki.certificate.PkiCertificateType"%>

<%@ include file="/include/beanSessionUser.jspf" %>
<%
	String sAction = request.getParameter("sAction");
	String rootPath = request.getContextPath()+"/";

	if (sAction.equals("create"))
	{
		String sPageUseCaseId = "IHM-DESK-xxx";
		sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
		PkiCertificateType item = new PkiCertificateType();
		item.setFromForm(request, "");
		item.create();
	}

	if (sAction.equals("remove"))
	{
		PkiCertificateType item = PkiCertificateType.getPkiCertificateType(Integer.parseInt(request.getParameter("lId")));
		item.remove();
	}
	
	if (sAction.equals("store"))
	{
		String sPageUseCaseId = "IHM-DESK-xxx";
		sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
		PkiCertificateType item = PkiCertificateType.getPkiCertificateType(Integer.parseInt(request.getParameter("lId")));
		
		item.setFromForm(request, "");
		item.store();
	}
	
	response.sendRedirect(
			response.encodeRedirectURL("displayAllCertificateType.jsp"));
%>