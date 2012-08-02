
<%@ page import="modula.faq.*" %>
<%@ include file="../include/beanSessionUser.jspf" %>
<%	String rootPath = request.getContextPath()+"/";
%>
<%
	try{
		FAQ faq = new FAQ();
		faq.setIdCoupleFAQ(Integer.parseInt(request.getParameter("id")));
		faq.load();
		faq.setQuestion(request.getParameter("question"));
		faq.setReponseQuestion(request.getParameter("reponse"));
		faq.setIdTypeQuestion(request.getParameter("type")); 
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