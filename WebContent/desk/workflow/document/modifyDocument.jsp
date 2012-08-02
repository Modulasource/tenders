<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.bean.workflow.*"%>

<%@ include file="../../include/beanSessionUser.jspf" %>
<%

	long lIdWorkflowDocument;
	String sAction;

	sAction = request.getParameter("sAction") ;
	String rootPath = request.getContextPath()+"/";
	Document item = null;

	lIdWorkflowDocument = Integer.parseInt( request.getParameter("lIdWorkflowDocument") );

	if(sAction.equalsIgnoreCase("create"))
		item = new Document();
	else
		item = Document.getDocument(lIdWorkflowDocument);

	if(sAction.equals("remove"))
	{
		String sPageUseCaseId = "xxx";
		%><%@ include file="../../include/checkHabilitationPage.jspf" %><%
		item.removeWithObjectAttached();
		response.sendRedirect(response.encodeRedirectURL("displayAllDocument.jsp"));
		return;
	}

	if(sAction.equals("store"))
	{
		String sPageUseCaseId = "xxxx";
		%><%@ include file="../../include/checkHabilitationPage.jspf" %><%
		item.setFromFormUTF8(request, "");
		item.store();
	}

	if(sAction.equals("create"))
	{
		String sPageUseCaseId = "xxx";
		%><%@ include file="../../include/checkHabilitationPage.jspf" %><%
		item.setFromFormUTF8(request, "");
		item.createWithObjectAttached(
				ObjectType.PERSONNE_PHYSIQUE,
				sessionUser.getIdIndividual(),
				Integer.parseInt( request.getParameter("lIdDefinitionWorkflowInitial")));
	}

	response.sendRedirect(
			response.encodeRedirectURL(
					"displayAllDocument.jsp?nonce=" + System.currentTimeMillis()));
%>