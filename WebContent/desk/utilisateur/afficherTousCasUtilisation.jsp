<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@ page import="org.coin.autoform.component.searchengine.*,org.coin.autoform.*,java.util.*" %>
<% 
	String sTitle = "cas d'utilisation";
	String sTitleSingulier = "CU";
	String sPageUseCaseId = "IHM-DESK-PARAM-HAB-4";
	String sUseCaseIdBoutonAjouterCU = "IHM-DESK-PARAM-HAB-4";
	String sUseCaseIdBoutonSupprimerCU = "IHM-DESK-PARAM-HAB-4";
	
	String sContraint = "";
	
	AutoFormSearchEngine afMoteur = 
		new AutoFormSearchEngine(response,
								request.getSession(),
								rootPath,
								sTitle,
								"afficherTousCasUtilisation.jsp",
								"use_case",
								"cu",
								sTitleSingulier,
								sTitle,
								"id_use_case",
								"sId");
	
	afMoteur.setTitle(sTitle);
	afMoteur.setLabelElementInSingular(sTitleSingulier);
	afMoteur.setLabelElementInPlurial(sTitle);
	afMoteur.getAfBlockResult().setLabelText("Liste des "+sTitle.toLowerCase());

	afMoteur.setSelectPart("cu.name");
	
	AutoFormSECptSearchByKeyWord afRechMotCle = new AutoFormSECptSearchByKeyWord("afRechMotCle");
	afRechMotCle.setLabelValueForSelect("");
	afRechMotCle.setClassName("af_se_component");
	afRechMotCle.addItem("Référence", "cu.id_use_case");
	afRechMotCle.addItem("Désignation", "cu.name");
	afMoteur.addSEComponent(afRechMotCle);

    afMoteur.addHeaderToResultCpt("Référence","id_use_case");
    afMoteur.addHeaderToResultCpt("Désignation","name");
    afMoteur.addHeaderToResultCpt("&nbsp;");

	// 25 par défaut
	afMoteur.setMaxElementsPerPage(25);
	afMoteur.setFromForm(request, "");
	afMoteur.load();
	Vector<Hashtable<String,String>> vResults = afMoteur.getResults();
    
	// Intégration des résultats dans les cellules des lignes
	for(int iLigne=0;iLigne<vResults.size();iLigne++){
		AutoFormSEMatrixListLine afLine = new AutoFormSEMatrixListLine(rootPath);

		afLine.addCell((String) vResults.get(iLigne).get("id_use_case"));
		afLine.addCell((String) vResults.get(iLigne).get("name"));
		String sId = ((String) vResults.get(iLigne).get(afMoteur.getIdInTable()));
		afLine.setURLToOpen(
					response.encodeURL(rootPath
									+"desk/utilisateur/modifyCUForm.jsp?sAction=store&"
									+afMoteur.getIdInJava()+"="
									+sId));
		
		if(sessionUserHabilitation.isHabilitate(sUseCaseIdBoutonSupprimerCU ))
		{
			afLine.setURLToRemove("javascript:deleteCU('"+sId+"');");
		}
		
		afLine.setOnClickActivate(false);		
		
		afMoteur.addLineToResultCpt(afLine);
	}
	
	if(sessionUserHabilitation.isHabilitate(sUseCaseIdBoutonAjouterCU ))
	{
		afMoteur.addBoutonToBar(
				"Ajouter un "+sTitleSingulier,
				response.encodeURL("modifyCUForm.jsp?sAction=create"),
				rootPath+"images/icons/brick_add.gif"
				);
	}

	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
%>
</head>
<body>
<%@ include file="../../../../../include/new_style/headerFiche.jspf" %>
<br/>
<div style="padding:15px">
<div id="fiche">
	<%=afMoteur.getHTMLBody() %>
	<script type="text/javascript" src="<%=rootPath %>dwr/interface/UseCase.js"></script>
	<script type="text/javascript" >
		function deleteCU(id) {
			if(confirm("Etes-vous sûr de vouloir effacer ce <%= sTitleSingulier %> ?")) {
				UseCase.removeWithObjectAttachedStatic(id,function(){
					window.location.reload(true);
				});
			}
		}
	</script>

</div>
</div>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>

<%@page import="org.coin.db.CoinDatabaseAbstractBean"%></html>