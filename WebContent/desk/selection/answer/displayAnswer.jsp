<%@page import="org.coin.bean.question.AnswerGroup"%>
<%@page import="org.coin.bean.question.Question"%>
<%@page import="org.coin.bean.question.Answer"%>
<%@ include file="../../../include/headerXML.jspf" %>

<%@ page import="org.coin.autoform.*,org.coin.autoform.component.*, modula.graphic.*, java.util.*" %>
<%@ include file="../../include/beanSessionUser.jspf" %>
<%
String rootPath = request.getContextPath()+"/";
String sTitle = "Reponse ";
String sPageUseCaseId = "IHM-DESK-SELECTION-QR-005";
String sUseCaseIdBoutonModifier = "IHM-DESK-SELECTION-QR-007";
String sUseCaseIdBoutonSupprimer = "IHM-DESK-SELECTION-QR-008";

String sAction = "store";
if(request.getParameter("sAction") != null)
	sAction = request.getParameter("sAction");

int iIdReponse = -1;
try{iIdReponse = Integer.parseInt(request.getParameter("lIdAnswer"));}
catch (Exception e)	{}

Answer _reponse = null;
try{
	_reponse = Answer.getAnswerMemory(iIdReponse);
}catch(Exception e){e.printStackTrace();}
sTitle += "n&deg;"+_reponse.getId();

String sLibelle = "";
try {sLibelle = request.getParameter("sAnswer");}
catch (Exception e) {}
if (sLibelle==null) sLibelle = _reponse.getAnswer();

String sKeyword = "";
try {sKeyword = request.getParameter("sKeyword");}
catch (Exception e) {}
if (sKeyword==null) sKeyword = _reponse.getKeyword();

String sReference = "";
try {sReference = request.getParameter("sReference");}
catch (Exception e) {}
if (sReference==null) sReference = _reponse.getReference();

String sMessage="";
try{sMessage = (String)request.getAttribute("m");}
catch(Exception e){}
if (sMessage==null) sMessage = "";
else request.removeAttribute("m");

//////////

	/*** PAGE ***/
	// création de la page
	AutoFormPage afPage = new AutoFormPage(rootPath, sTitle);

	// Ajout de boutons à cette page
	if (sessionUserHabilitation.isHabilitate(sUseCaseIdBoutonSupprimer)){
		afPage.addBoutonToBar(
			"Supprimer cette réponse",
			response.encodeURL(rootPath + "desk/selection/answer/removeAnswerForm.jsp?lIdAnswer=" + _reponse.getId()),
			rootPath+Icone.ICONE_SUPPRIMER
			);
		afPage.addBoutonToBar(
		"Ajouter une réponse",
		response.encodeURL(rootPath + "desk/selection/answer/createAnswerForm.jsp"),
		rootPath+Icone.ICONE_PLUS
		);
	}
	/*** PAGE ***/
	
	/*** FORMULAIRE ***/
	// création du formulaire
	AutoFormForm afForm = 
		new AutoFormForm("post", "formulaire", response.encodeURL("modifyAnswer.jsp?sAction="+sAction));
	/*** FORMULAIRE ***/
	
	/*** CHAMPS/COMPOSANTS ***/
	// création des champs
	AutoFormCptSelect afIdAnswerGroup 
		= new AutoFormCptSelect("Groupe associé", "iIdAnswerGroup", _reponse.getIdAnswerGroup()+"", false);
	afIdAnswerGroup.addItem("Aucun","0");
	afIdAnswerGroup.setBeans((Vector)AnswerGroup.getAllStaticMemory());

	AutoFormCptTextarea afReponse = 
		new AutoFormCptTextarea("Réponse", "sAnswer", _reponse.getAnswer(), false);
	afReponse.afTextarea.setRow(2);
	afReponse.afTextarea.setMaxCharacter(500);
	
	AutoFormCptInputText afKeyword = new AutoFormCptInputText("Mot clé", "sKeyword", sKeyword, true, 250);
	
	AutoFormCptInputText afReference = new AutoFormCptInputText("Référénce", "sReference", sReference, true, 250);
	/*** CHAMPS/COMPOSANTS **/
	
	/*** BLOCS & FORMULAIRES ***/
	// création du bloc et intégration des champs dans celui-ci
	AutoFormCptBlock afBloc = new AutoFormCptBlock("Composition de la réponse");
	afBloc.addComponent(afIdAnswerGroup);
	afBloc.addComponent(afReponse);
	afBloc.addComponent(afKeyword);
	afBloc.addComponent(afReference);
	

	// Affichage d'un message le cas échéant
	if(!sMessage.equals("")){
		AutoFormCptLabel afMessage = new AutoFormCptLabel(sMessage, "m");
		AutoFormCptBlock afBlocMessage = new AutoFormCptBlock("Avertissement");
		afBlocMessage.addComponent(afMessage);
		afForm.addComponent(afBlocMessage);
	}
	
	// intégration des blocs dans le formulaire
	afForm.addComponent(afBloc);
	
	// ajout de champs cachés
	afForm.addHidden("sSessionId", session.getId());
	afForm.addHidden("sRootPath", request.getContextPath());
	afForm.addHidden("lIdAnswer", iIdReponse);
	
	
	// intégration du formulaire dans la page
	afPage.addForm(afForm);
	/*** BLOCS & FORMULAIRES ***/
%>
<%@ include file="../../include/checkHabilitationPage.jspf" %>
<%=afPage.getHTML() %>