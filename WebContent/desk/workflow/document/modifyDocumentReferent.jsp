<%@page import="org.coin.db.CoinDatabaseAbstractBean"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.bean.workflow.*"%>

<%@ include file="../../include/beanSessionUser.jspf" %>
<%

	String sAction;

	sAction = request.getParameter("sAction") ;
	String rootPath = request.getContextPath()+"/";
	DocumentReferent item = null;

	long lIdWorkflowDocumentReferent
		= CoinDatabaseAbstractBean.getLongFromHtmlForm(request, "lIdWorkflowDocumentReferent" , -1);

	if(sAction.equalsIgnoreCase("create"))
		item = new DocumentReferent();
	else
		item = DocumentReferent.getDocumentReferent(lIdWorkflowDocumentReferent);

	if(sAction.equals("remove"))
	{
		String sPageUseCaseId = "xxx";
		%><%@ include file="../../include/checkHabilitationPage.jspf" %><%
		item.removeWithObjectAttached();
		response.sendRedirect(response
				.encodeRedirectURL(
						"displayDocument.jsp?lIdWorkflowDocument="
								+ item.getIdWorkflowDocument() ));
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
		item.create();
	}

	response.sendRedirect(
			response.encodeRedirectURL(
					"displayDocument.jsp?lIdWorkflowDocument="
					+ item.getIdWorkflowDocument()
					+ "&nonce=" + System.currentTimeMillis()));
%>