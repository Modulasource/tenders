<%@ include file="../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.*,org.coin.bean.html.*,org.coin.bean.document.*,modula.graphic.*,org.coin.fr.bean.*,modula.*" %>
<%
	String sTitle = "Document : ";
	String sFormPrefix = "";
	
	PersonnePhysique personne = PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual());

	int iIdDocument = -1;
	try{iIdDocument = Integer.parseInt(request.getParameter("iIdDocument"));}
	catch (Exception e)	{}
	Document doc = Document.getDocument(iIdDocument);
	sTitle += doc.getName();
	PersonnePhysique auteur = PersonnePhysique.getPersonnePhysique(doc.getIdPersonnePhysiqueAuteur());
	Vector<DocumentSignatory> vDocumentSignataires = DocumentSignatory.getAllDocumentSignatoryFromDocument(iIdDocument);
	
	String sAction = "";
	if(request.getParameter("sAction") != null)
		sAction = request.getParameter("sAction");
	
	int iIdOnglet = 0;
	try {iIdOnglet = Integer.parseInt(request.getParameter("iIdOnglet"));}
	catch (Exception e){}
	
	String sPageUseCaseId = "IHM-DESK-GED-008";
	String sUseCaseIdBoutonModifierDocument = "IHM-DESK-GED-002";
	String sUseCaseIdBoutonSupprimerDocument = "IHM-DESK-GED-005";
	String sUseCaseIdBoutonAjouterDocumentBalise = "IHM-DESK-GED-023";
	
	Vector<DocumentLibrary> vLibOrganisation = DocumentLibrary.getAllDocumentLibraryFromDocumentAndReferenceAndTypeObjet((int)doc.getId(),personne.getIdOrganisation(),ObjectType.ORGANISATION);
	if(vLibOrganisation != null && vLibOrganisation.size()>0)
	{
		sUseCaseIdBoutonModifierDocument = "IHM-DESK-GED-014";
		sUseCaseIdBoutonSupprimerDocument = "IHM-DESK-GED-018";	
		sPageUseCaseId = "IHM-DESK-GED-010";
	}
	
	if(personne.getIdPersonnePhysique() == doc.getIdPersonnePhysiqueAuteur())
	{
		sUseCaseIdBoutonModifierDocument = "IHM-DESK-GED-013";
		sUseCaseIdBoutonSupprimerDocument = "IHM-DESK-GED-017";	
		sPageUseCaseId = "IHM-DESK-GED-009";
	}
	
	Onglet.sNotCurrentTabStyle = " class='onglet_non_selectionne' "; 
	Onglet.sCurrentTabStyle = " class='onglet_selectionne' ";
	Onglet.sNotCurrentTabStyleInCreation = " class='onglet_non_selectionne' ";
	Onglet.sCurrentTabStyleInCreation = " class='onglet_selectionne' ";
	Onglet.sEnddingTabStyle = " class='onglet_vide_dernier' ";

	Vector<Onglet> vOnglets = new Vector<Onglet>();
	vOnglets.add( new Onglet(0, false, "Propriétés", "afficherDocument.jsp?iIdOnglet=0") ); 
	vOnglets.add( new Onglet(1, false, "Fichier", "afficherDocument.jsp?iIdOnglet=1") ); 
	vOnglets.add( new Onglet(2, false, "Visibilité", "afficherDocument.jsp?iIdOnglet=2") ); 
	vOnglets.add( new Onglet(3, false, "Signataires", "afficherDocument.jsp?iIdOnglet=3") ); 
	
	Onglet onglet = vOnglets.get(iIdOnglet);
	onglet.bIsCurrent = true;
%>
<%@ include file="../include/checkHabilitationPage.jspf" %>
</head>
<body >
<%@ include file="/include/new_style/headerFiche.jspf" %>
<%@include file="pave/paveHeaderDocument.jspf" %>
<br />	
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
					+"&amp;iIdDocument="+doc.getId()
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
	boolean bDisplayFormButton = false;
	boolean bDisplayButtonModify = false;
	if(sessionUserHabilitation.isHabilitate(sUseCaseIdBoutonModifierDocument))
	{
		if(/*iIdOnglet != Onglet.ONGLET_GED_FICHIER
		&& */iIdOnglet != Onglet.ONGLET_GED_SIGNATAIRES
		&& iIdOnglet != Onglet.ONGLET_GED_VISIBILITE)
		{
			if(sAction.equals("store"))	
			{
				bDisplayFormButton = true;
			}
			else
			{
				bDisplayButtonModify = true;
			}
		}
	}
	
	if( bDisplayButtonModify)
	{
	%>
	<div align="right" >
	<input 
		type="button" 
		value="Modifier" 
		onclick="<%= response.encodeURL(
			"Redirect('afficherDocument.jsp?iIdDocument=" + doc.getId()) 
			+ "&amp;iIdOnglet=" + iIdOnglet 
			+ "&amp;sAction=store" %>');" />
	</div>
	<br/>
<%
	}
	boolean bIsFormTemp = false;
	HtmlBeanTableTrPave hbFormulaire = new HtmlBeanTableTrPave();
	hbFormulaire.bIsForm = false;
	
	if( bDisplayFormButton)
	{
		hbFormulaire.bIsForm = true;
%>
	<form action="<%= response.encodeURL("modifierDocument.jsp")%>" method="post" name="formulaire">
	<div align="right" >
	<input type="hidden" name="sAction" value="store" />
	<input type="hidden" name="iIdOnglet" value="<%= iIdOnglet  %>" />
	<input type="hidden" name="iIdDocument" value="<%= doc.getId() %>" />
	<input type="submit" value="Valider" />
	</div>
	<br/>
<%
	}

	if(iIdOnglet == Onglet.ONGLET_GED_PROPRIETES)
	{
		if(sAction.equals("store"))
		{
			%><%@ include file="pave/paveDocumentForm.jspf" %><%
		}
		else
		{
			%><%@ include file="pave/paveDocument.jspf" %><%
		}	
	}
	
	if(iIdOnglet == Onglet.ONGLET_GED_FICHIER)
	{
		%><%@ include file="pave/paveFichier.jspf" %><%
	}
	
	if(iIdOnglet == Onglet.ONGLET_GED_VISIBILITE)
	{
		if(sAction.equals("store"))
		{
			%><%@ include file="pave/paveVisibiliteForm.jspf" %><%
		}
		else
		{
			%><%@ include file="pave/paveVisibilite.jspf" %><%
		}	
	}
	
	if(iIdOnglet == Onglet.ONGLET_GED_SIGNATAIRES)
	{
		%><%@ include file="pave/paveSignataires.jspf" %><%	
	}
	
	if( bDisplayFormButton)
	{
	%>
	</form>
	<%
	}
	%>
</div>
</div>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>
</html>