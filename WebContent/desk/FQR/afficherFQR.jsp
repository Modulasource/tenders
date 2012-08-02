<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="modula.fqr.*,org.coin.fr.bean.*, modula.marche.*" %>
<%
	
	String sPageUseCaseId = "IHM-DESK-FQR-001";
	String sIdAffaire = null;
	Marche marche = null;
	int iIdAffaire;
	int iIdOnglet = HttpUtil.parseInt("iIdOnglet", request, 0) ;
	sIdAffaire = request.getParameter("iIdAffaire");
	iIdAffaire = Integer.parseInt(sIdAffaire);
	marche = Marche.getMarche(iIdAffaire );
	String sTitle = "Afficher la FQR"; 
		
	Onglet.sNotCurrentTabStyle = " class='onglet_non_selectionne' ";  
	Onglet.sCurrentTabStyle =  " class='onglet_selectionne' ";
	Onglet.sNotCurrentTabStyleInCreation = " class='onglet_non_selectionne' ";
	Onglet.sCurrentTabStyleInCreation =  " class='onglet_selectionne' ";
	Onglet.sEnddingTabStyle =  " class='onglet_vide_dernier' ";

	Vector<Onglet> vOnglets = new Vector<Onglet>();
	vOnglets.add( new Onglet(0, false, "Questions en attente de validation", "afficherFQR.jsp?iIdOnglet=0") ); 
	vOnglets.add( new Onglet(1, false, "Ajouter une question", "afficherFQR.jsp?iIdOnglet=1") ); 	
	vOnglets.add( new Onglet(2, false, "Questions traitées", "afficherFQR.jsp?iIdOnglet=2") ); 	
	
	Onglet onglet = vOnglets.get(iIdOnglet);
	onglet.bIsCurrent = true;
	String sHeadTitre = ""; 
	boolean bAfficherPoursuivreProcedure = false;
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
%>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<%@ include file="/include/new_style/headerAffaireOnlyButtonDisplayAffaire.jspf" %>
<br/>
<div class="tabFrame">
<div class="tabs">
	<%
	for (int i = 0; i < vOnglets.size(); i++) 
	{
		onglet = vOnglets.get(i);
		if(!onglet.bHidden)
		try {
			String sImageInCreation = "" ;
			String sOnClick = "";
			
			
			%><div <%= (onglet.bIsCurrent?"class=\"active\"":"") %>
				onclick="javascript:location.href='<%= response.encodeURL(onglet.sTargetUrl 
					+"&amp;iIdAffaire="+marche.getIdMarche()
					+"&amp;nonce=" + System.currentTimeMillis())%>';">
				<%= onglet.sLibelle %><%= sImageInCreation %></div>
			<%	
		} 
		catch (Exception e) {
			e.printStackTrace();
		}
	}
	%>
</div>
<div class="tabContent">
<%
	switch(iIdOnglet) {
		case Onglet.ONGLET_FQR_QUESTIONS_EN_ATTENTE :
			%><%@ include file="pave/ongletFQRQuestionsEnAttente.jspf" %><%
			break;
		case Onglet.ONGLET_FQR_AJOUTER_QUESTION :
			%><%@ include file="pave/ongletFQRAjouterQuestion.jspf" %><%
			break;
		case Onglet.ONGLET_FQR_QUESTIONS_VALIDEES :
			%><%@ include file="pave/ongletFQRQuestionsValidees.jspf" %><%
			break;
	}
%>
</div>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="modula.graphic.Onglet"%>
</html>
