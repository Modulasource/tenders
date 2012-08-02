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


String sLibelle = "";
try {sLibelle = request.getParameter("sAnswer");}
catch (Exception e) {}

String sKeyword = "";
try {sKeyword = request.getParameter("sKeyword");}
catch (Exception e) {}

if (sAction.equals("create") && !sKeyword.equals("")){
	if (Answer.isExistWithKeywordMemory(sKeyword)){
		request.setAttribute("m","Le mot clé que vous avez saisi existe déjà. Merci d'en saisir un différent.");
		response.sendRedirect(response
		.encodeRedirectURL("createAnswerForm.jsp?sAnswer=" + sLibelle +"&sKeyword="
		+ sKeyword + "&iIdOnglet=" + 0
		+ "&nonce=" + System.currentTimeMillis()));
	}else{
		Answer _reponse = new Answer();
		_reponse.setFromForm(request, "");
		_reponse.create();
		request.setAttribute("m","Elément correctement ajouté");
		response.sendRedirect(response
		.encodeRedirectURL("displayAnswer.jsp?lIdAnswer="
		+ _reponse.getId() + "&iIdOnglet=" + 0
		+ "&nonce=" + System.currentTimeMillis()));
	}

}else if(sAction.equals("store") && !sKeyword.equals("")){
	sPageUseCaseId = "IHM-DESK-SELECTION-QR-007";
	int iIdReponse = -1;
	try {
		iIdReponse = Integer.parseInt(request.getParameter("lIdAnswer"));
		Answer _reponse = Answer.getAnswerMemory(iIdReponse);
		if (Answer.isExistWithKeywordWithoutIdMemory(sKeyword, iIdReponse)){
			request.setAttribute("m","Le mot clé que vous avez saisi existe déjà. Merci d'en saisir un différent.");
			response.sendRedirect(response
			.encodeRedirectURL("displayAnswer.jsp?lIdAnswer=" + iIdReponse + "&sAnswer=" + sLibelle +"&sKeyword="
			+ sKeyword + "&iIdOnglet=" + 0
			+ "&nonce=" + System.currentTimeMillis()));
		}else{
	_reponse.setFromForm(request, "");
	_reponse.store();
	request.setAttribute("m","Elément correctement modifié");
	response.sendRedirect(response
			.encodeRedirectURL("displayAnswer.jsp?lIdAnswer="
			+ _reponse.getId() + "&iIdOnglet=" + 0
			+ "&nonce=" + System.currentTimeMillis()));
		}

	}catch (Exception e) {}
}
%>