<%@page import="org.coin.bean.question.AnswerGroup"%>
<%@page import="org.coin.bean.question.Question"%>
<%@ include file="../../../include/headerXML.jspf" %>

<%@ page import="org.coin.autoform.*,org.coin.autoform.component.*,java.util.*" %>
<%@ include file="../../include/beanSessionUser.jspf" %>
<%
String rootPath = request.getContextPath()+"/";
String sTitle = "Ajouter une r�ponse";
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
	// cr�ation de la page
	AutoFormPage afPage = new AutoFormPage(rootPath, sTitle);
	/*** PAGE ***/
	
	/*** FORMULAIRE ***/
	// cr�ation du formulaire
	AutoFormForm afForm = 
		new AutoFormForm("post", "formulaire", response.encodeURL("modifyAnswer.jsp?sAction="+sAction));
	/*** FORMULAIRE ***/
	
	/*** CHAMPS/COMPOSANTS ***/
	// cr�ation des champs
	AutoFormCptSelect afIdAnswerGroup 
		= new AutoFormCptSelect("Groupe associ�", "iIdAnswerGroup", "", false);
	afIdAnswerGroup.addItem("Aucun","0");
	afIdAnswerGroup.setBeans((Vector)AnswerGroup.getAllStaticMemory());
	
	AutoFormCptTextarea afLibelle = 
		new AutoFormCptTextarea("R�ponse", "sAnswer", sLibelle, false);
	afLibelle.afTextarea.setRow(2);
	afLibelle.afTextarea.setMaxCharacter(500);
	
	AutoFormCptInputText afKeyword = new AutoFormCptInputText("Mot cl�", "sKeyword", sKeyword, true, 250);
	
	/*** CHAMPS/COMPOSANTS **/
	
	/*** BLOCS & FORMULAIRES ***/
	// cr�ation du bloc et int�gration des champs dans celui-ci
	
	AutoFormCptBlock afBloc = new AutoFormCptBlock("Composition de la r�ponse");
	afBloc.addComponent(afIdAnswerGroup);
	afBloc.addComponent(afLibelle);
	afBloc.addComponent(afKeyword);
	
	// Affichage d'un message le cas �ch�ant
	if(!sMessage.equals("")){
		AutoFormCptLabel afMessage = new AutoFormCptLabel(sMessage, "m");
		AutoFormCptBlock afBlocMessage = new AutoFormCptBlock("Avertissement");
		afBlocMessage.addComponent(afMessage);
		afForm.addComponent(afBlocMessage);
	}
	
	// int�gration des blocs dans le formulaire
	afForm.addComponent(afBloc);
	
	
	// ajout de champs cach�s
	afForm.addHidden("sSessionId", session.getId());
	afForm.addHidden("sRootPath", request.getContextPath());
	
	// int�gration du formulaire dans la page
	afPage.addForm(afForm);
	/*** BLOCS & FORMULAIRES ***/
%>
<%@ include file="../../include/checkHabilitationPage.jspf" %>
<%=afPage.getHTML() %>