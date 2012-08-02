<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@page import="org.coin.bean.question.AnswerGroup"%>
<%@page import="org.coin.bean.question.Question"%>

<%@ page import="org.coin.autoform.*,org.coin.autoform.component.searchengine.*,
		java.util.*" %>
<%
	String sTitle = "Liste des réponses des sélections" ;

	/*** MOTEUR DE RECHERCHE ***/
	// création du moteur de recherche
	AutoFormSearchEngine afMoteur = 
		new AutoFormSearchEngine(response,
								request.getSession(),
								rootPath,
								sTitle,
								"displayAllAnswer.jsp",
								"qa_answer",
								"rep",
								"réponse",
								"réponses",
								"id_qa_answer",
								"lIdAnswer");
	
	afMoteur.addOtherTableWithLeftJoin("qa_answer_group grp","rep.id_qa_answer_group=grp.id_qa_answer_group");
	
	/// HABILITATIONS
	String sPageUseCaseId = "IHM-DESK-SELECTION-QR-005";
	boolean bAccesAll = true;
	
	String sUseCaseIdBoutonAjouter = "IHM-DESK-SELECTION-QR-007";

	if(!sessionUserHabilitation.isHabilitate(sUseCaseIdBoutonAjouter)){
		bAccesAll = false;
	}
	
	/// FIN HABILITATIONS
	
	// Définition des champs à afficher
	afMoteur.setSelectPart("rep.answer, rep.keyword, rep.reference, grp.name as groupe");
	
	/// COMPOSANTS DE RECHERCHE
	// Ajout d'un composant recherche par mot clé
	AutoFormSECptSearchByKeyWord afRechMotCle = new AutoFormSECptSearchByKeyWord("afRechMotCle");
	afRechMotCle.addItem("libellé de la réponse", "rep.answer");
	afRechMotCle.addItem("mot clé", "rep.keyword");
	afRechMotCle.addItem("référence", "rep.reference");
	afMoteur.addSEComponent(afRechMotCle);
	
	AutoFormSECptSearchSelection afRechGroupe = new AutoFormSECptSearchSelection("afRechGroupe","");
	afRechGroupe.addItem("Tous les groupes", "");
	afRechGroupe.setConditionAndBeans("grp.id_qa_answer_group",(Vector)AnswerGroup.getAllStaticMemory());
	afRechGroupe.setInSearchBlock(true);
	afMoteur.addSEComponent(afRechGroupe);
	/// FIN COMPOSANTS DE RECHERCHE
	
	
	// Ajout de critères de tri dans le menu déroulant "OrderBy"
	afMoteur.addHeaderToResultCpt("Num.", "rep.id_qa_answer");
	afMoteur.addHeaderToResultCpt("Mot clé", "rep.keyword");
	afMoteur.addHeaderToResultCpt("Référénce", "rep.reference");
	afMoteur.addHeaderToResultCpt("Réponse", "rep.answer");
	afMoteur.addHeaderToResultCpt("Groupe", "grp.name");
	
	
	// Initialisation des formulaires
	afMoteur.setFromForm(request, "");
	
	// RESULTATS
//	afMoteur.setMaxElementsPerPage(2);
//	afMoteur.setGroupPerPage(2);
	
	// Execution de la requête
	afMoteur.load();
	
	// Récupération des résultats
	Vector<Hashtable<String,String>> vResults = afMoteur.getResults();
	
	
	// Intégration des résultats dans les cellules des lignes
	for(int iLigne=0;iLigne<vResults.size();iLigne++){
		AutoFormSEMatrixListLine afLine = new AutoFormSEMatrixListLine(rootPath);
		afLine.addCell((String) vResults.get(iLigne).get("id_qa_answer"));
		afLine.addCell((String) vResults.get(iLigne).get("keyword"));
		afLine.addCell((String) vResults.get(iLigne).get("reference"));
		afLine.addCell((String) vResults.get(iLigne).get("answer"));
		afLine.addCell((String) vResults.get(iLigne).get("groupe"));
		afLine.setURLToOpen(
					response.encodeURL(rootPath
									+"desk/selection/answer/displayAnswer.jsp?"
									+afMoteur.getIdInJava()+"="
									+((String) vResults.get(iLigne).get("id_qa_answer"))));
		afMoteur.addLineToResultCpt(afLine);
	}
	// FIN RESULTATS
	

	// Ajout de boutons à la barre de boutons
	if (bAccesAll){
		afMoteur.addBoutonToBar(
					"Ajouter une réponse",
					response.encodeURL("createAnswerForm.jsp"),
					rootPath+"images/icones/ajouter-document.gif"
					);
	}
	/*** MOTEUR DE RECHERCHE ***/

//	System.out.println("Requete générée : "+afMoteur.getGeneratedRequest());
//	System.out.println("Paramètre à transporter : "+afMoteur.getGeneratedParametersForURL());

%>
</head>
<%@ include file="../../include/checkHabilitationPage.jspf" %>
<body>
<%@ include file="../../../include/new_style/headerFiche.jspf" %>
<div id="search" style="padding:15px">
    <%= afMoteur.getHTMLBody() %>
</div>
<%@ include file="../../../include/new_style/footerFiche.jspf" %>
</body>
</html>