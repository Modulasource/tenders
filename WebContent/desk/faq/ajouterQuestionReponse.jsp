
<%@ page import="modula.faq.*" %>
<%@ include file="../include/beanSessionUser.jspf" %>
<%	String rootPath = request.getContextPath()+"/";
	String sQuestion="";
	String sReponse="";
	int idType;
	sQuestion = request.getParameter("question");
	sReponse = request.getParameter("reponse");
	idType = Integer.parseInt(request.getParameter("type"));
	FAQ faq = new FAQ();
	faq.setQuestion(sQuestion);
	faq.setReponseQuestion(sReponse);
	faq.setIdStatutQuestion(FAQConstant.VALIDE);
	faq.setIdTypeQuestion(idType);
	faq.create();
	response.sendRedirect(response.encodeRedirectURL(rootPath + "desk/faq/faq.jsp"));
%>