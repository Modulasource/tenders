
<%@ page import="org.coin.fr.bean.mail.*,modula.journal.*"%>
<%@ include file="../../include/beanSessionUser.jspf" %>
<%
	String sAction = request.getParameter("sAction");
	int iIdTypeEvenement = -1;
	String rootPath = request.getContextPath()+"/";
	
	if (sAction.equals("create"))
	{
	String sPageUseCaseId = "IHM-DESK-xxx";
%>
<%@ include file="../../include/checkHabilitationPage.jspf" %>
<%
		MailType oMailType = new MailType ();
		oMailType.setFromForm(request, "");
		oMailType.create();
	}

	if (sAction.equals("remove"))
	{
		String sIdMailType = request.getParameter("iIdMailType") ;
		if (sIdMailType == null) {
			return;
		} 

		MailType oMailType  = MailType.getMailTypeMemory(Integer.parseInt(sIdMailType));
		oMailType.remove();
	}
	
	if (sAction.equals("store"))
	{
		String sPageUseCaseId = "IHM-DESK-xxx";
%>
<%@ include file="../../include/checkHabilitationPage.jspf" %>
<%
		String sIdMailType = request.getParameter("iIdMailType") ;
		if (sIdMailType == null) {
			return;
		} 

		MailType oMailType  = MailType.getMailTypeMemory(Integer.parseInt(sIdMailType));
		oMailType.setFromForm(request, "");
		oMailType.store();
		
	}
	
	response.sendRedirect(response.encodeRedirectURL(rootPath+"desk/parametrage/mail/afficherTousMailType.jsp"));
	
%>