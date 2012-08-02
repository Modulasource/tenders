<%@page import="org.coin.bean.question.QuestionAnswer"%>
<%@page import="org.coin.bean.question.Answer"%>
<%@page import="org.coin.bean.question.Question"%>

<%@ page import="org.coin.util.*"%>
<%@ include file="../../include/beanSessionUser.jspf"%>
<%
String rootPath = request.getContextPath() + "/";
String sPageUseCaseId = "IHM-DESK-SELECTION-QR-002";
String sFormPrefix = "";

String sAction = "";
try {sAction = request.getParameter("sAction");}
catch (Exception e) {}

String sLibelle = "";
try {sLibelle = request.getParameter("sQuestion");}
catch (Exception e) {}

String sKeyword = "";
try {sKeyword = request.getParameter("sKeyword");}
catch (Exception e) {}

if (sAction.equals("create") && !sLibelle.equals("") && !sKeyword.equals("")){
	if (Question.isExistWithKeywordMemory(sKeyword)){
		request.setAttribute("m","Le mot clé que vous avez saisi existe déjà. Merci d'en saisir un différent.");
		response.sendRedirect(response
		.encodeRedirectURL("createQuestionForm.jsp?sQuestion=" + sLibelle +"&sKeyword="
		+ sKeyword + "&iIdOnglet=" + 0
		+ "&nonce=" + System.currentTimeMillis()));
	}else{
		Question quest = new Question();
		quest.setFromForm(request, "");
		quest.create();
		request.setAttribute("m","Elément correctement ajouté");
		response.sendRedirect(response
		.encodeRedirectURL("displayQuestion.jsp?lIdQuestion="
		+ quest.getId() + "&iIdOnglet=" + 0
		+ "&nonce=" + System.currentTimeMillis()));
	}

}else if(sAction.equals("store") && !sLibelle.equals("") && !sKeyword.equals("")){
	sPageUseCaseId = "IHM-DESK-SELECTION-QR-003";
	int iIdQuestion = -1;
	Question _question = null;
	try {
		iIdQuestion = Integer.parseInt(request.getParameter("lIdQuestion"));
		_question = Question.getQuestionMemory(iIdQuestion);
	}catch (Exception e) {e.printStackTrace();}
	if (_question != null){
		if (Question.isExistWithKeywordWithoutIdMemory(sKeyword, iIdQuestion)){
			request.setAttribute("m","Le mot clé que vous avez saisi existe déjà. Merci d'en saisir un différent.");
			response.sendRedirect(response
			.encodeRedirectURL("displayQuestion.jsp?lIdQuestion=" + iIdQuestion + "&sQuestion=" + sLibelle +"&sKeyword="
			+ sKeyword + "&iIdOnglet=" + 0
			+ "&nonce=" + System.currentTimeMillis()));
		}else{
	_question.setFromForm(request, "");
	// mise à jour de l'ordre des réponses :
	int[] iIdReponses = Outils.parserChaineVersEntier(request.getParameter("aReponse"), "|");
	if (iIdReponses != null){
		QuestionAnswer.updateAnswerFromQuestion(_question.getId(),iIdReponses);
	}
	_question.store();
	request.setAttribute("m","Elément correctement modifié");
	response.sendRedirect(response
			.encodeRedirectURL("displayQuestion.jsp?lIdQuestion="
			+ _question.getId() + "&iIdOnglet="
			+ "&nonce=" + System.currentTimeMillis()));
		}
	}
}
%>