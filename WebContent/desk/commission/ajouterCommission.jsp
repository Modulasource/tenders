
<%@ page import="modula.commission.*"%>
<%@ include file="../include/beanSessionUser.jspf" %>
<%
	Commission commission = new Commission( );
	
	commission.setFromForm(request, "");
	commission.create();
	response.sendRedirect(response.encodeRedirectURL("afficherCommission.jsp?iIdCommission=" + commission.getIdCommission()));
%>