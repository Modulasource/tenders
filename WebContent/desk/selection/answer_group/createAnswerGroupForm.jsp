<%@page import="org.coin.bean.question.Question"%>
<%@ include file="../../../include/headerXML.jspf" %>

<%@ page import="org.coin.autoform.*,org.coin.autoform.component.*,java.util.*" %>
<%@ include file="../../include/beanSessionUser.jspf" %>
<%
String rootPath = request.getContextPath()+"/";
String sTitle = "Ajouter un groupe de réponses";
String sPageUseCaseId = "IHM-DESK-SELECTION-QR-006";
String sAction = "create";

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
		new AutoFormForm("post", "formulaire", response.encodeURL("modifyAnswerGroup.jsp?sAction="+sAction));
	/*** FORMULAIRE ***/
	
	/*** CHAMPS/COMPOSANTS ***/
	// création des champs
	AutoFormCptInputText afKeyword = new AutoFormCptInputText("Nom", "sName", "", true, 250);
	
	/*** CHAMPS/COMPOSANTS **/
	
	/*** BLOCS & FORMULAIRES ***/
	// création du bloc et intégration des champs dans celui-ci
	
	AutoFormCptBlock afBloc = new AutoFormCptBlock("Composition du groupe");
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