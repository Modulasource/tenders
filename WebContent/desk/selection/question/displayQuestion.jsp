<%@page import="org.coin.bean.question.QuestionAnswer"%>
<%@page import="org.coin.bean.question.Question"%>
<%@page import="org.coin.bean.question.Answer"%>
<%@ include file="../../../include/headerXML.jspf" %>

<%@ page import="org.coin.autoform.*,org.coin.autoform.component.*, modula.graphic.*,java.util.*" %>
<%@ include file="../../include/beanSessionUser.jspf" %>
<%
String rootPath = request.getContextPath()+"/";
String sTitle = "Question ";
String sPageUseCaseId = "IHM-DESK-SELECTION-QR-001";
String sUseCaseIdBoutonModifier = "IHM-DESK-SELECTION-QR-003";
String sUseCaseIdBoutonSupprimer = "IHM-DESK-SELECTION-QR-004";

String sAction = "store";
if(request.getParameter("sAction") != null)
	sAction = request.getParameter("sAction");

int iIdQuestion = -1;
try{iIdQuestion = Integer.parseInt(request.getParameter("lIdQuestion"));}
catch (Exception e)	{}

Question _question = null;
try{
	_question = Question.getQuestionMemory(iIdQuestion);
}catch(Exception e){e.printStackTrace();}
sTitle += "n&deg;"+_question.getId();

String sLibelle = "";
try {sLibelle = request.getParameter("sQuestion");}
catch (Exception e) {}
if (sLibelle==null) sLibelle = _question.getQuestion();

String sKeyword = "";
try {sKeyword = request.getParameter("sKeyword");}
catch (Exception e) {}
if (sKeyword==null) sKeyword = _question.getKeyword();

String sReference = "";
try {sReference = request.getParameter("sReference");}
catch (Exception e) {}
if (sReference==null) sReference = _question.getReference();

String sMessage="";
try{sMessage = (String)request.getAttribute("m");}
catch(Exception e){}
if (sMessage==null) sMessage = "";
else request.removeAttribute("m");

//////////

	/*** PAGE ***/
	// cr�ation de la page
	AutoFormPage afPage = new AutoFormPage(rootPath, sTitle);

	// Ajout de boutons � cette page
	afPage.addBoutonToBar(
		"Supprimer cette question",
		response.encodeURL(rootPath + "desk/selection/question/removeQuestionForm.jsp?lIdQuestion=" + _question.getId()),
		rootPath+Icone.ICONE_SUPPRIMER
		);
	/*** PAGE ***/
	
	/*** FORMULAIRE ***/
	// cr�ation du formulaire
	AutoFormForm afForm = 
		new AutoFormForm("post", "formulaire", response.encodeURL("modifyQuestion.jsp?sAction="+sAction));
	/*** FORMULAIRE ***/
	
	/*** CHAMPS/COMPOSANTS ***/
	// cr�ation des champs

	AutoFormCptTextarea afQuestion = 
		new AutoFormCptTextarea("Libelle de la question", "sQuestion", sLibelle, true);
	afQuestion.afTextarea.setRow(2);
	afQuestion.afTextarea.setMaxCharacter(500);
	
	AutoFormCptInputText afKeyword = new AutoFormCptInputText("Mot cl�", "sKeyword", sKeyword, true, 250);
	
	AutoFormCptInputText afReference = new AutoFormCptInputText("R�f�r�nce", "sReference", sReference, true, 250);
	
	AutoFormCptDoubleMultiSelectOrder afSelReponse = 
		new AutoFormCptDoubleMultiSelectOrder("R�ponses associ�es", "aReponse", false, rootPath);
	// Remplissage de la liste (liste des �l�ments s�lectionn�s)
	afSelReponse.setBeans((Vector)QuestionAnswer.getAllAnswerFromQuestionMemory(_question.getId()),(Vector)Answer.getAllStaticMemory());
	

	/*** CHAMPS/COMPOSANTS **/
	
	/*** BLOCS & FORMULAIRES ***/
	// cr�ation du bloc et int�gration des champs dans celui-ci
	AutoFormCptBlock afBloc = new AutoFormCptBlock("Composition de la question");
	afBloc.addComponent(afQuestion);
	afBloc.addComponent(afKeyword);
	afBloc.addComponent(afReference);
	
	AutoFormCptBlock afBlocRep = new AutoFormCptBlock("R�ponses");
	afBlocRep.addComponent(afSelReponse);
	
	// Affichage d'un message le cas �ch�ant
	if(!sMessage.equals("")){
		AutoFormCptLabel afMessage = new AutoFormCptLabel(sMessage, "m");
		AutoFormCptBlock afBlocMessage = new AutoFormCptBlock("Avertissement");
		afBlocMessage.addComponent(afMessage);
		afForm.addComponent(afBlocMessage);
	}
	
	// int�gration des blocs dans le formulaire
	afForm.addComponent(afBloc);
	afForm.addComponent(afBlocRep);
	
	// ajout de champs cach�s
	afForm.addHidden("sSessionId", session.getId());
	afForm.addHidden("sRootPath", request.getContextPath());
	afForm.addHidden("lIdQuestion", iIdQuestion);
	
	
	// int�gration du formulaire dans la page
	afPage.addForm(afForm);
	/*** BLOCS & FORMULAIRES ***/
%>
<%@ include file="../../include/checkHabilitationPage.jspf" %>
<%=afPage.getHTML() %>