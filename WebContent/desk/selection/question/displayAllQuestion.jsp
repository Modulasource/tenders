<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.autoform.*,org.coin.autoform.component.searchengine.*,java.util.*" %>
<%
	String sTitle = "Liste des questions des s�lections" ;

	/*** MOTEUR DE RECHERCHE ***/
	// cr�ation du moteur de recherche
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

	
	
	// D�finition des champs � afficher
	afMoteur.setSelectPart("quest.question, quest.keyword, quest.reference");
	
	/// COMPOSANTS DE RECHERCHE
	
	// Ajout d'un composant recherche par mot cl�
	AutoFormSECptSearchByKeyWord afRechMotCle = new AutoFormSECptSearchByKeyWord("afRechMotCle");
	afRechMotCle.addItem("libell� de la question", "quest.question",AutoFormSearchEngine.TYPE_TEXT);
	afRechMotCle.addItem("mot cl�", "quest.keyword",AutoFormSearchEngine.TYPE_VARCHAR);
	afRechMotCle.addItem("r�f�rence", "quest.reference",AutoFormSearchEngine.TYPE_VARCHAR);
	afMoteur.addSEComponent(afRechMotCle);
	/// FIN COMPOSANTS DE RECHERCHE
	
	afMoteur.addHeaderToResultCpt("Num.","quest.id_qa_question");
	afMoteur.addHeaderToResultCpt("Mot cl�","quest.keyword");
	afMoteur.addHeaderToResultCpt("Question","quest.question");
	afMoteur.addHeaderToResultCpt("R�f�rence","quest.reference");
	
	// Initialisation des formulaires
	afMoteur.setFromForm(request, "");
	
	// RESULTATS
//	afMoteur.setMaxElementsPerPage(2);
//	afMoteur.setGroupPerPage(2);
	
	// Execution de la requ�te
	afMoteur.load();
	
	// R�cup�ration des r�sultats
	Vector<Hashtable<String,String>> vResults = afMoteur.getResults();
	
	
	// Int�gration des r�sultats dans les cellules des lignes
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
	

	// Ajout de boutons � la barre de boutons
	if (bAccesAll){
		afMoteur.addBoutonToBar(
					"Ajouter une question",
					response.encodeURL("createQuestionForm.jsp"),
					rootPath+"images/icones/ajouter-document.gif"
					);
	}
	/*** MOTEUR DE RECHERCHE ***/

//	System.out.println("Requete g�n�r�e : "+afMoteur.getGeneratedRequest());
//	System.out.println("Param�tre � transporter : "+afMoteur.getGeneratedParametersForURL());

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