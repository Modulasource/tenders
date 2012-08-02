
<%@ page import="modula.commission.*"%>
<%@ include file="../include/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath()+"/";

	int iIdCommissionMembre = Integer.parseInt(request.getParameter("iIdCommissionMembre"));

	CommissionMembre membreASupprimer = 
		CommissionMembre.getCommissionMembre(iIdCommissionMembre);
	int iIdCommission = membreASupprimer.getIdCommission();
	
	membreASupprimer.remove();
	response.sendRedirect(
		response.encodeRedirectURL(
			rootPath + "desk/commission/afficherCommission.jsp?iIdCommission=" + iIdCommission));
%>
