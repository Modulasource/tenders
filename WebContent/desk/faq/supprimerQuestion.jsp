
<%@ page import="modula.faq.*" %>
<%@ include file="../include/beanSessionUser.jspf" %>
<%	String rootPath = request.getContextPath()+"/";
	String sPageUseCaseId = "IHM-DESK-FAQ-008";
%>
<%@ include file="../include/checkHabilitationPage.jspf" %>
%>
<%
	int iId;
	try{
		iId = Integer.parseInt(request.getParameter("id"));
		FAQ faq = new FAQ();
		faq.setIdCoupleFAQ(iId);
		faq.remove();
		response.sendRedirect(response.encodeRedirectURL(rootPath + "desk/faq/faq.jsp"));
	}
	catch (Exception e) {
		try{
			out.println("pas de question");	
			return;
		}
		catch(java.io.IOException ioe){}
	}
%>
