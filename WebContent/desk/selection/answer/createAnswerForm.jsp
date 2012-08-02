<%@page import="org.coin.bean.question.AnswerGroup"%>
<%@page import="org.coin.bean.question.Question"%>
<%@ include file="../../../include/headerXML.jspf" %>

<%@ page import="org.coin.autoform.*,org.coin.autoform.component.*,java.util.*" %>
<%@ include file="../../include/beanSessionUser.jspf" %>
<%
String rootPath = request.getContextPath()+"/";
String sTitle = "Ajouter une réponse";
String sPageUseCaseId = "IHM-DESK-SELECTION-QR-006";
String sAction = "create";

String sLibelle = "";
try {sLibelle = request.getParameter("sAnswer");}
catch (Exception e) {}
if (sLibelle==null) sLibelle = "";

String sKeyword = "";
try {sKeyword = request.getParameter("sKeyword");}
catch (Exception e) {}
if (sKeyword==null) sKeyword = "";

String sMessage="";
try{sMessage = (String)request.getAttribute("m");}
catch(Exception e){}
if (sMessage==null) sMessage = "";
else request.removeAttribute("m");

//////////

	/*** PAGE ***/
	// création de la page
	AutoFormPage afPage = new AutoFormPage(rootPath, sTitle);
	/*** PAGE ***/
	
	/*** FORMULAIRE ***/
	// création du formulaire
	AutoFormForm afForm = 
		new AutoFormForm("post", "formulaire", response.encodeURL("modifyAnswer.jsp?sAction="+sAction));
	/*** FORMULAIRE ***/
	
	/*** CHAMPS/COMPOSANTS ***/
	// création des champs
	AutoFormCptSelect afIdAnswerGroup 
		= new AutoFormCptSelect("Groupe associé", "iIdAnswerGroup", "", false);
	afIdAnswerGroup.addItem("Aucun","0");
	afIdAnswerGroup.setBeans((Vector)AnswerGroup.getAllStaticMemory());
	
	AutoFormCptTextarea afLibelle = 
		new AutoFormCptTextarea("Réponse", "sAnswer", sLibelle, false);
	afLibelle.afTextarea.setRow(2);
	afLibelle.afTextarea.setMaxCharacter(500);
	
	AutoFormCptInputText afKeyword = new AutoFormCptInputText("Mot clé", "sKeyword", sKeyword, true, 250);
	
	/*** CHAMPS/COMPOSANTS **/
	
	/*** BLOCS & FORMULAIRES ***/
	// création du bloc et intégration des champs dans celui-ci
	
	AutoFormCptBlock afBloc = new AutoFormCptBlock("Composition de la réponse");
	afBloc.addComponent(afIdAnswerGroup);
	afBloc.addComponent(afLibelle);
	afBloc.addComponent(afKeyword);
	
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
	
	// intégration du formulaire dans la page
	afPage.addForm(afForm);
	/*** BLOCS & FORMULAIRES ***/
%>
<%@ include file="../../include/checkHabilitationPage.jspf" %>
<%=afPage.getHTML() %>