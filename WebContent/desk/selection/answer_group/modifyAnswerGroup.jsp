<%@page import="org.coin.bean.question.AnswerGroup"%>
<%@page import="org.coin.bean.question.Answer"%>

<%@ page import="org.coin.util.*"%>
<%@ include file="../../include/beanSessionUser.jspf"%>
<%
String rootPath = request.getContextPath() + "/";
String sPageUseCaseId = "IHM-DESK-SELECTION-QR-006";
String sFormPrefix = "";

String sAction = "";
try {sAction = request.getParameter("sAction");}
catch (Exception e) {}

if (sAction.equals("create")){

		AnswerGroup _reponse = new AnswerGroup();
		_reponse.setFromForm(request, "");
		_reponse.create();
		request.setAttribute("m","Elément correctement ajouté");
		response.sendRedirect(response
		.encodeRedirectURL("displayAnswerGroup.jsp?iIdAnswerGroup="
		+ _reponse.getId() + "&iIdOnglet=" + 0
		+ "&nonce=" + System.currentTimeMillis()));

}else if(sAction.equals("store")){
	sPageUseCaseId = "IHM-DESK-SELECTION-QR-007";
	int iIdReponse = 0;
	try {
		iIdReponse = Integer.parseInt(request.getParameter("iIdAnswerGroup"));
		AnswerGroup _reponse = AnswerGroup.getAnswerGroupMemory(iIdReponse);
		
		_reponse.setFromForm(request, "");
		int[] iIdReponses = Outils.parserChaineVersEntier(request.getParameter("aAnswer"), "|");
		if (iIdReponses != null){
			AnswerGroup.updateAnswer(_reponse.getId(),iIdReponses);
		}
		_reponse.store();
		request.setAttribute("m","Elément correctement modifié");
		response.sendRedirect(response
				.encodeRedirectURL("displayAnswerGroup.jsp?iIdAnswerGroup="+iIdReponse
				+ "&iIdOnglet=" + 0 
				+ "&nonce=" + System.currentTimeMillis()));
	}catch (Exception e) {}
}
%>