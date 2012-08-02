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

int iIdAnswerGroup = -1;
try{iIdAnswerGroup = Integer.parseInt(request.getParameter("iIdAnswerGroup"));}
catch (Exception e)	{}

AnswerGroup _group = null;
try{
	_group = AnswerGroup.getAnswerGroupMemory(iIdAnswerGroup);
}catch(Exception e){e.printStackTrace();}
sTitle += "n&deg;"+_group.getId();

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
	if (sessionUserHabilitation.isHabilitate(sUseCaseIdBoutonSupprimer)){
		afPage.addBoutonToBar(
			"Supprimer cet groupe",
			response.encodeURL(rootPath + "desk/selection/answer_group/removeAnswerGroupForm.jsp?iIdAnswerGroup=" + _group.getId()),
			rootPath+Icone.ICONE_SUPPRIMER
			);
	}
	/*** PAGE ***/
	
	/*** FORMULAIRE ***/
	// cr�ation du formulaire
	AutoFormForm afForm = 
		new AutoFormForm("post", "formulaire", response.encodeURL("modifyAnswerGroup.jsp?sAction="+sAction));
	/*** FORMULAIRE ***/
	
	/*** CHAMPS/COMPOSANTS ***/
	AutoFormCptInputText afKeyword = new AutoFormCptInputText("Nom", "sName", _group.getName(), true, 250);
	
	AutoFormCptMultiSelectOrder afSelAnswer = 
		new AutoFormCptMultiSelectOrder("R�ponses associ�es", "aAnswer", false, rootPath);
	// Remplissage de la liste (liste des �l�ments s�lectionn�s)
	afSelAnswer.setBeansSelected((Vector)Answer.getAllFromGroupMemory(_group.getId()));
	
	/*** BLOCS & FORMULAIRES ***/
	// cr�ation du bloc et int�gration des champs dans celui-ci
	AutoFormCptBlock afBloc = new AutoFormCptBlock("Composition du groupe");
	afBloc.addComponent(afKeyword);
	afBloc.addComponent(afSelAnswer);
	
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
	afForm.addHidden("iIdAnswerGroup", iIdAnswerGroup);
	
	
	// int�gration du formulaire dans la page
	afPage.addForm(afForm);
	/*** BLOCS & FORMULAIRES ***/
%>
<%@ include file="../../include/checkHabilitationPage.jspf" %>
<%=afPage.getHTML() %>