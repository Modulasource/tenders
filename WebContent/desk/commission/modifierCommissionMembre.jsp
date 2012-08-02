
<%@ page import="modula.commission.*"%>
<%@ include file="../include/beanSessionUser.jspf" %>
<%@ include file="../include/beanSessionIdCommission.jspf" %>
<%
	String rootPath = request.getContextPath()+"/";
	int iIdMembre = Integer.parseInt(request.getParameter("iIdCommissionMembre"));
	
	CommissionMembre membre = CommissionMembre.getCommissionMembre(iIdMembre);
	membre.setFromForm(request, "");
	
	membre.store();
	response.sendRedirect(
		response.encodeRedirectURL(
			"afficherCommissionMembre.jsp?iIdCommissionMembre=" + membre.getIdCommissionMembre()
			+ "&nonce=" + System.currentTimeMillis()));
	
%>