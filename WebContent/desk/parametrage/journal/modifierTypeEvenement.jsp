
<%@ page import="modula.journal.*"%>
<%@ include file="../../include/beanSessionUser.jspf" %>
<%
	String sAction = request.getParameter("sAction");
	int iIdTypeEvenement = -1;
	String rootPath = request.getContextPath()+"/";
	
	if (sAction.equals("create"))
	{
	String sPageUseCaseId = "IHM-DESK-JOU-006";
%>
<%@ include file="../../include/checkHabilitationPage.jspf" %>
<%
		TypeEvenement oTypeEvenement = new TypeEvenement();
		oTypeEvenement.setFromForm(request, "");
		oTypeEvenement.create();
	}

	if (sAction.equals("remove"))
	{
		String sIdTypeEvenement = request.getParameter("iIdTypeEvenement") ;
		if (sIdTypeEvenement == null) {
			return;
		} 

		TypeEvenement oTypeEvenement = TypeEvenement.getTypeEvenementMemory(Integer.parseInt(sIdTypeEvenement));
		oTypeEvenement.remove();
		
	}
	
	if (sAction.equals("store"))
	{
	String sPageUseCaseId = "IHM-DESK-JOU-008";
%>
<%@ include file="../../include/checkHabilitationPage.jspf" %>
<%
		String sIdTypeEvenement = request.getParameter("iIdTypeEvenement") ;
		if (sIdTypeEvenement == null) {
			return;
		} 

		TypeEvenement oTypeEvenement = TypeEvenement.getTypeEvenementMemory(Integer.parseInt(sIdTypeEvenement));
		oTypeEvenement.setFromForm(request, "");
		oTypeEvenement.store();
	
	}
	try{
		response.sendRedirect(response.encodeRedirectURL(rootPath+"desk/parametrage/journal/afficherTousTypeEvenement.jsp"));
	}
	catch(java.io.IOException ioe){}
%>