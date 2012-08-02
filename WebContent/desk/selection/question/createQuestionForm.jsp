<%@ include file="../../../include/headerXML.jspf" %>

<%@ page import="org.coin.autoform.*,org.coin.autoform.component.*" %>
<%@ include file="../../include/beanSessionUser.jspf" %>
<%
String rootPath = request.getContextPath()+"/";
String sTitle = "Ajouter une question";
String sPageUseCaseId = "IHM-DESK-SELECTION-QR-002";
String sAction = "create";

String sLibelle = "";
try {sLibelle = request.getParameter("sQuestion");}
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
		new AutoFormForm("post", "formulaire", response.encodeURL("modifyQuestion.jsp?sAction="+sAction));
	/*** FORMULAIRE ***/
	
	/*** CHAMPS/COMPOSANTS ***/
	// cr�ation des champs
	
	AutoFormCptTextarea afQuestion = 
		new AutoFormCptTextarea("Libelle de la question", "sQuestion", sLibelle, true);
	afQuestion.afTextarea.setRow(2);
	afQuestion.afTextarea.setMaxCharacter(500);
	
	AutoFormCptInputText afKeyword = new AutoFormCptInputText("Mot cl�", "sKeyword", sKeyword, true, 250);
	
//	AutoFormCptDoubleMultiSelect af
	
	/*** CHAMPS/COMPOSANTS **/
	
	/*** BLOCS & FORMULAIRES ***/
	// cr�ation du bloc et int�gration des champs dans celui-ci
	
	AutoFormCptBlock afBloc = new AutoFormCptBlock("Composition de la question");
	afBloc.addComponent(afQuestion);
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