<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.autoform.*,org.coin.autoform.component.searchengine.*,java.util.*" %>
<%
	String sTitle = "Liste des questions des sélections" ;

	/*** MOTEUR DE RECHERCHE ***/
	// création du moteur de recherche
	AutoFormSearchEngine afMoteur = 
		new AutoFormSearchEngine(response,
								request.getSession(),
								rootPath,
								sTitle,
								"displayAllQuestion.jsp",
								"qa_question",
								"quest",
								"question",
								"questions",
								"id_qa_question",
								"lIdQuestion");
	
	/// HABILITATIONS
	String sPageUseCaseId = "IHM-DESK-SELECTION-QR-001";
	boolean bAccesAll = true;
	
	String sUseCaseIdBoutonAjouter = "IHM-DESK-SELECTION-QR-002";

	if(!sessionUserHabilitation.isHabilitate(sUseCaseIdBoutonAjouter)){
		bAccesAll = false;
	}
	/// FIN HABILITATIONS

	
	
	// Définition des champs à afficher
	afMoteur.setSelectPart("quest.question, quest.keyword, quest.reference");
	
	/// COMPOSANTS DE RECHERCHE
	
	// Ajout d'un composant recherche par mot clé
	AutoFormSECptSearchByKeyWord afRechMotCle = new AutoFormSECptSearchByKeyWord("afRechMotCle");
	afRechMotCle.addItem("libellé de la question", "quest.question",AutoFormSearchEngine.TYPE_TEXT);
	afRechMotCle.addItem("mot clé", "quest.keyword",AutoFormSearchEngine.TYPE_VARCHAR);
	afRechMotCle.addItem("référence", "quest.reference",AutoFormSearchEngine.TYPE_VARCHAR);
	afMoteur.addSEComponent(afRechMotCle);
	/// FIN COMPOSANTS DE RECHERCHE
	
	afMoteur.addHeaderToResultCpt("Num.","quest.id_qa_question");
	afMoteur.addHeaderToResultCpt("Mot clé","quest.keyword");
	afMoteur.addHeaderToResultCpt("Question","quest.question");
	afMoteur.addHeaderToResultCpt("Référence","quest.reference");
	
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
		afLine.addCell((String) vResults.get(iLigne).get("id_qa_question"));
		afLine.addCell((String) vResults.get(iLigne).get("keyword"));
		afLine.addCell((String) vResults.get(iLigne).get("question"));
		afLine.addCell((String) vResults.get(iLigne).get("reference"));
		afLine.setURLToOpen(
					response.encodeURL(rootPath
									+"desk/selection/question/displayQuestion.jsp?"
									+afMoteur.getIdInJava()+"="
									+((String) vResults.get(iLigne).get("id_qa_question"))));
		afMoteur.addLineToResultCpt(afLine);
	}
	// FIN RESULTATS
	

	// Ajout de boutons à la barre de boutons
	if (bAccesAll){
		afMoteur.addBoutonToBar(
					"Ajouter une question",
					response.encodeURL("createQuestionForm.jsp"),
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