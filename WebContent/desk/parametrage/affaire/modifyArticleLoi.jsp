<%@page import="modula.marche.ArticleLoi"%>

<%@ include file="../../../include/beanSessionUser.jspf" %>
<%
	String sAction = request.getParameter("sAction");
	String rootPath = request.getContextPath()+"/";

	if (sAction.equals("create"))
	{
		String sPageUseCaseId = "IHM-DESK-xxxx";
		sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
		ArticleLoi article = new ArticleLoi();
		article.setFromForm(request, "");
		article.create();
	}

	if (sAction.equals("remove"))
	{
		ArticleLoi article = ArticleLoi.getArticleLoiMemory(Long.parseLong( request.getParameter("lId")));
		article.remove();
	}
	
	if (sAction.equals("store"))
	{
		String sPageUseCaseId = "IHM-xxxxx";
		sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
		ArticleLoi article 
			= ArticleLoi
				.getArticleLoi(Integer.parseInt(request.getParameter("lId")));
		
		article.setFromForm(request, "");
		article.store();
	}
	response.sendRedirect(response.encodeRedirectURL(rootPath+"desk/parametrage/affaire/displayAllArticleLoi.jsp"));
%>
