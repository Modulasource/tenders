
<%@ page import="modula.faq.*" %>
<%@ include file="../include/beanSessionUser.jspf" %>
<%	String rootPath = request.getContextPath()+"/";
%>
<%
	int iId;
	try{
		iId = Integer.parseInt(request.getParameter("id"));
		FAQ faq = new FAQ(); 
		faq.setIdCoupleFAQ(iId);
		faq.load();
		faq.setIdTypeQuestion(request.getParameter("typeQR"));
		faq.setIdStatutQuestion(FAQConstant.VALIDE);
		faq.store();
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