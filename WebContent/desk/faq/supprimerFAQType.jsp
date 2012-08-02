
<%@ page import="modula.faq.*" %>
<%@ include file="../include/beanSessionUser.jspf" %>
<%	String rootPath = request.getContextPath()+"/";
	String sPageUseCaseId = "IHM-DESK-FAQ-004";
%>
<%@ include file="../include/checkHabilitationPage.jspf" %>
<%	int iIdType;
	try{
		iIdType = Integer.parseInt(request.getParameter("iIdType"));
		FAQType type = new FAQType(iIdType); 
		type.remove();
		response.sendRedirect(response.encodeRedirectURL(rootPath + "desk/faq/gererCategories.jsp"));
	}
	catch (Exception e) {
		try{
			out.println("pas de catégorie");	
			return;
		}
		catch(java.io.IOException ioe){}
	}
%>
