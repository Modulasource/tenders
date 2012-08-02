<%@ include file="../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.*,org.coin.bean.html.*,org.coin.bean.editorial.*,modula.graphic.*,java.util.*,org.coin.fr.bean.*,modula.*,modula.commission.*,org.coin.util.*,modula.marche.*" %>
<%
	String sTitle = "Contenu rédactionnel : ";
	String sFormPrefix = "";
	
	PersonnePhysique personne = PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual());

	int iIdEditorialAssistance = -1;
	try{iIdEditorialAssistance = Integer.parseInt(request.getParameter("iIdEditorialAssistance"));}
	catch (Exception e)	{}
	EditorialAssistance edit = EditorialAssistance.getEditorialAssistance(iIdEditorialAssistance);
	sTitle += edit.getName();
	PersonnePhysique auteur = PersonnePhysique.getPersonnePhysique(edit.getIdPersonnePhysiqueAuteur());
	EditorialAssistanceGroup group = EditorialAssistanceGroup.getEditorialAssistanceGroup(edit.getIdEditorialAssistanceGroup());
	
	String sAction = "";
	if(request.getParameter("sAction") != null)
		sAction = request.getParameter("sAction");
	
	int iIdOnglet = 0;
	try {iIdOnglet = Integer.parseInt(request.getParameter("iIdOnglet"));}
	catch (Exception e){}
	
	String sPageUseCaseId = "IHM-DESK-AR-013";
	String sUseCaseIdBoutonModifierContenu = "IHM-DESK-AR-004";
	String sUseCaseIdBoutonSupprimerContenu = "IHM-DESK-AR-007";
	
	Vector<EditorialAssistanceLibrary> vLibOrganisation = EditorialAssistanceLibrary.getAllEditorialAssistanceLibraryFromEditorialAssistanceAndReferenceAndTypeObjet((int)edit.getId(),personne.getIdOrganisation(),ObjectType.ORGANISATION);
	if(vLibOrganisation != null && vLibOrganisation.size()>0)
	{
		sUseCaseIdBoutonModifierContenu = "IHM-DESK-AR-005";
		sUseCaseIdBoutonSupprimerContenu = "IHM-DESK-AR-008";	
		sPageUseCaseId = "IHM-DESK-AR-014";
	}
	
	if(personne.getIdPersonnePhysique() == edit.getIdPersonnePhysiqueAuteur())
	{
		sUseCaseIdBoutonModifierContenu = "IHM-DESK-AR-006";
		sUseCaseIdBoutonSupprimerContenu = "IHM-DESK-AR-009";	
		sPageUseCaseId = "IHM-DESK-AR-015";
	}
	
	Onglet.sNotCurrentTabStyle = " class='onglet_non_selectionne' "; 
	Onglet.sCurrentTabStyle = " class='onglet_selectionne' ";
	Onglet.sNotCurrentTabStyleInCreation = " class='onglet_non_selectionne' ";
	Onglet.sCurrentTabStyleInCreation = " class='onglet_selectionne' ";
	Onglet.sEnddingTabStyle = " class='onglet_vide_dernier' ";

	Vector<Onglet> vOnglets = new Vector<Onglet>();
	vOnglets.add( new Onglet(0, false, "Contenu éditorial", "afficherEditorialAssistance.jsp?iIdOnglet=0") );
	vOnglets.add( new Onglet(1, false, "Visibilité", "afficherEditorialAssistance.jsp?iIdOnglet=1") ); 
	
	Onglet onglet = vOnglets.get(iIdOnglet);
	onglet.bIsCurrent = true;
%>
<%@ include file="../include/checkHabilitationPage.jspf" %>
</head>
<body >
<%@ include file="../../include/new_style/headerFiche.jspf" %>
<br/>
<%@include file="pave/paveHeaderEditorialAssistance.jspf" %>
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
			
			
			%><div <%= (onglet.bIsCurrent?"class=\"active\"":"")%>
				onclick="javascript:location.href='<%= response.encodeURL(onglet.sTargetUrl 
					+"&amp;iIdEditorialAssistance="+edit.getId()
					+"&amp;nonce=" + System.currentTimeMillis())%>';">
					<%= onglet.sLibelle %><%= sImageInCreation %>
			</div><%	
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
	if(sessionUserHabilitation.isHabilitate(sUseCaseIdBoutonModifierContenu))
	{
		if(iIdOnglet != Onglet.ONGLET_AR_VISIBILITE)
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
			"Redirect('afficherEditorialAssistance.jsp?iIdEditorialAssistance=" + edit.getId()) 
			+ "&amp;iIdOnglet=" + iIdOnglet 
			+ "&amp;sAction=store" %>');" />
	</div>
	<br/>
<%
	}
	
	HtmlBeanTableTrPave hbFormulaire = new HtmlBeanTableTrPave();
	hbFormulaire.bIsForm = false;
	
	if( bDisplayFormButton)
	{
		hbFormulaire.bIsForm = true;
%>
	<form action="<%= response.encodeURL("modifierEditorialAssistance.jsp")%>" method="post" name="formulaire">
	<div align="right" >
	<input type="hidden" name="sAction" value="store" />
	<input type="hidden" name="iIdOnglet" value="<%= iIdOnglet  %>" />
	<input type="hidden" name="iIdEditorialAssistance" value="<%= edit.getId() %>" />
	<input type="submit" value="Valider" />
	</div>
	<br/>
<%
	}

	if(iIdOnglet == Onglet.ONGLET_AR_CONTENU)
	{
		if(sAction.equals("store"))
		{
			%><%@ include file="pave/paveEditorialAssistanceForm.jspf" %><%
		}
		else
		{
			%><%@ include file="pave/paveEditorialAssistance.jspf" %><%
		}	
	}
	
	if(iIdOnglet == Onglet.ONGLET_AR_VISIBILITE)
	{
		if(sAction.equals("store"))
		{
			%><%@ include file="pave/paveEditorialAssistanceVisibiliteForm.jspf" %><%
		}
		else
		{
			%><%@ include file="pave/paveEditorialAssistanceVisibilite.jspf" %><%
		}	
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
<%@ include file="../../include/new_style/footerFiche.jspf" %>
</body>
</html>