
<%@ page import="modula.faq.*" %>
<%@ include file="../include/beanSessionUser.jspf" %>
<%	String rootPath = request.getContextPath()+"/";
	String sPageUseCaseId = "IHM-DESK-FAQ-002";
%>
<%@ include file="../include/checkHabilitationPage.jspf" %>
<%
	String sType ;
	sType = request.getParameter("FAQType_libelle");
	FAQType type = new FAQType(sType); 
	type.create();
	response.sendRedirect(response.encodeRedirectURL(rootPath + "desk/faq/gererCategories.jsp"));
%>
