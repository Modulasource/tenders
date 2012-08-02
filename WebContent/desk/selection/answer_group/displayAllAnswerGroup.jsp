<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@page import="org.coin.bean.question.Question"%>

<%@ page import="org.coin.autoform.*,org.coin.autoform.component.searchengine.*,
		java.util.*" %>
<%
	String sTitle = "Liste des groupes de réponses des sélections" ;

	/*** MOTEUR DE RECHERCHE ***/
	// création du moteur de recherche
	AutoFormSearchEngine afMoteur = 
		new AutoFormSearchEngine(response,
								request.getSession(),
								rootPath,
								sTitle,
								"displayAllAnswerGroup.jsp",
								"qa_answer_group",
								"grp",
								"groupe de réponses",
								"groupes de réponses",
								"id_qa_answer_group",
								"iIdAnswerGroup");
	
	/// HABILITATIONS
	String sPageUseCaseId = "IHM-DESK-SELECTION-QR-005";
	boolean bAccesAll = true;
	
	String sUseCaseIdBoutonAjouter = "IHM-DESK-SELECTION-QR-007";

	if(!sessionUserHabilitation.isHabilitate(sUseCaseIdBoutonAjouter)){
		bAccesAll = false;
	}
	
	/// FIN HABILITATIONS

	
	
	// Définition des champs à afficher
	afMoteur.setSelectPart("grp.name");
	
	/// COMPOSANTS DE RECHERCHE
	
	// Ajout d'un composant recherche par mot clé
	AutoFormSECptSearchByKeyWord afRechMotCle = new AutoFormSECptSearchByKeyWord("afRechMotCle");
	afRechMotCle.addItem("Nom du groupe", "grp.name");
	afMoteur.addSEComponent(afRechMotCle);
	/// FIN COMPOSANTS DE RECHERCHE
	
	
	// Ajout de critères de tri dans le menu déroulant "OrderBy"
	afMoteur.addHeaderToResultCpt("Num.", "grp.id_qa_answer_group");
	afMoteur.addHeaderToResultCpt("Nom", "grp.name");
	
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
		afLine.addCell((String) vResults.get(iLigne).get("id_qa_answer_group"));
		afLine.addCell((String) vResults.get(iLigne).get("name"));

		afLine.setURLToOpen(
					response.encodeURL(rootPath
									+"desk/selection/answer_group/displayAnswerGroup.jsp?"
									+afMoteur.getIdInJava()+"="
									+((String) vResults.get(iLigne).get("id_qa_answer_group"))));
		afMoteur.addLineToResultCpt(afLine);
	}
	// FIN RESULTATS
	

	// Ajout de boutons à la barre de boutons
	if (bAccesAll){
		afMoteur.addBoutonToBar(
					"Ajouter un groupe",
					response.encodeURL("createAnswerGroupForm.jsp"),
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