
<%@ page import="org.coin.fr.bean.annonce.*,org.coin.fr.bean.*,modula.*,org.coin.util.*" %>
<%@ include file="../include/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath()+"/";
	String sPageUseCaseId = "IHM-DESK-ANN-xxx";
	// TODO : include file="../include/checkHabilitationPage.jspf"


	String sAction = request.getParameter("sAction");
	Annonce annonce = null;
	if(sAction.equals("create"))
	{
		annonce = new Annonce ();
		annonce.setFromForm(request, "");
	
		annonce.create();
	}
	
	response.sendRedirect(
			response.encodeRedirectURL(
					"afficherAnnonce.jsp?iIdAnnonce=" + annonce.getIdAnnonce() 
					+ "&nonce=" + System.currentTimeMillis() ));
%>
