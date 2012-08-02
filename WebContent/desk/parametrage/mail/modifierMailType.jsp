<%@page import="org.coin.fr.bean.mail.MailType"%>
<%@ include file="../../../include/new_style/headerDesk.jspf" %>
<%
	String sAction = request.getParameter("sAction");
	
	if (sAction.equals("create"))
	{
		String sPageUseCaseId = "IHM-DESK-PARAM-002";
		sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
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

		MailType oMailType  = MailType.getMailType(Integer.parseInt(sIdMailType));
		oMailType.remove();
	}
	
	if (sAction.equals("store"))
	{
		String sPageUseCaseId = "IHM-DESK-PARAM-002";
		sessionUserHabilitation.isHabilitateException(sPageUseCaseId);

		String sIdMailType = request.getParameter("iIdMailType") ;
		if (sIdMailType == null) {
			return;
		} 

		MailType oMailType  = MailType.getMailType(Integer.parseInt(sIdMailType));
		oMailType.setFromForm(request, "");
		oMailType.store();
		
	}
	response.sendRedirect(
			response.encodeRedirectURL(
					rootPath+"desk/parametrage/mail/afficherTousMailType.jsp"));
%>