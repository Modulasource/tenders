
<%@ page import="modula.commission.*"%>
<%@ include file="../include/beanSessionUser.jspf" %>
<%@ include file="../include/beanSessionIdCommission.jspf" %>
<%
	String rootPath = request.getContextPath()+"/";
	String sPageUseCaseId = "IHM-DESK-COM-004";
%><%@ include file="../include/checkHabilitationCommissionMembrePage.jspf" %><%

	commission.setFromForm(request, "");		
	commission.store();
	response.sendRedirect(response.encodeRedirectURL("afficherCommission.jsp?iIdCommission=" + commission.getIdCommission()));
	
%>
