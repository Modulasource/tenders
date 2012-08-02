<%@ include file="../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.*,org.coin.bean.html.*,org.coin.bean.editorial.*,modula.graphic.*,java.util.*,org.coin.fr.bean.*" %>
<%
	String sTitle = "Groupe rédactionnel : ";
	String sFormPrefix = "";
	
	PersonnePhysique personne = PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual());

	int iIdEditorialAssistanceGroup = -1;
	try{iIdEditorialAssistanceGroup = Integer.parseInt(request.getParameter("iIdEditorialAssistanceGroup"));}
	catch (Exception e)	{}
	EditorialAssistanceGroup group = EditorialAssistanceGroup.getEditorialAssistanceGroup(iIdEditorialAssistanceGroup);
	sTitle += group.getName();
	PersonnePhysique auteur = PersonnePhysique.getPersonnePhysique(group.getIdPersonnePhysiqueAuteur());
	
	String sAction = "";
	if(request.getParameter("sAction") != null)
		sAction = request.getParameter("sAction");
	
	int iIdOnglet = 0;
	try {iIdOnglet = Integer.parseInt(request.getParameter("iIdOnglet"));}
	catch (Exception e){}
	
	String sPageUseCaseId = "IHM-DESK-AR-030";
	String sUseCaseIdBoutonModifierGroupe = "IHM-DESK-AR-021";
	String sUseCaseIdBoutonSupprimerGroupe = "IHM-DESK-AR-024";
	
	Vector<EditorialAssistanceGroupLibrary> vLibOrganisation = EditorialAssistanceGroupLibrary.getAllEditorialAssistanceGroupLibraryFromGroupAndReferenceAndTypeObjet((int)group.getId(),personne.getIdOrganisation(),ObjectType.ORGANISATION);
	if(vLibOrganisation != null && vLibOrganisation.size()>0)
	{
		sUseCaseIdBoutonModifierGroupe = "IHM-DESK-AR-022";
		sUseCaseIdBoutonSupprimerGroupe = "IHM-DESK-AR-025";	
		sPageUseCaseId = "IHM-DESK-AR-031";
	}
	
	if(personne.getIdPersonnePhysique() == group.getIdPersonnePhysiqueAuteur())
	{
		sUseCaseIdBoutonModifierGroupe = "IHM-DESK-AR-023";
		sUseCaseIdBoutonSupprimerGroupe = "IHM-DESK-AR-026";	
		sPageUseCaseId = "IHM-DESK-AR-032";
	}
	
	Onglet.sNotCurrentTabStyle = " class='onglet_non_selectionne' "; 
	Onglet.sCurrentTabStyle = " class='onglet_selectionne' ";
	Onglet.sNotCurrentTabStyleInCreation = " class='onglet_non_selectionne' ";
	Onglet.sCurrentTabStyleInCreation = " class='onglet_selectionne' ";
	Onglet.sEnddingTabStyle = " class='onglet_vide_dernier' ";

	Vector<Onglet> vOnglets = new Vector<Onglet>();
	vOnglets.add( new Onglet(0, false, "Groupe", "afficherEditorialAssistanceGroup.jsp?iIdOnglet=0") ); 
	vOnglets.add( new Onglet(1, false, "Contenus Editoriaux", "afficherEditorialAssistanceGroup.jsp?iIdOnglet=1") ); 
	vOnglets.add( new Onglet(2, false, "Visibilité", "afficherEditorialAssistanceGroup.jsp?iIdOnglet=2") ); 
	
	Onglet onglet = vOnglets.get(iIdOnglet);
	onglet.bIsCurrent = true;
%>
<%@ include file="../include/checkHabilitationPage.jspf" %>
</head>
<body >
<%@ include file="../../include/new_style/headerFiche.jspf" %>
<br/>
<%@include file="pave/paveHeaderEditorialAssistanceGroup.jspf" %>
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
					+"&amp;iIdEditorialAssistanceGroup="+group.getId()
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
	if(sessionUserHabilitation.isHabilitate(sUseCaseIdBoutonModifierGroupe))
	{
		if(iIdOnglet != Onglet.ONGLET_AR_GROUP_CONTENUS
		&& iIdOnglet != Onglet.ONGLET_AR_GROUP_VISIBILITE)
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
			"Redirect('afficherEditorialAssistanceGroup.jsp?iIdEditorialAssistanceGroup=" + group.getId()) 
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
	<form action="<%= response.encodeURL("modifierEditorialAssistanceGroup.jsp")%>" method="post" name="formulaire">
	<div align="right" >
	<input type="hidden" name="sAction" value="store" />
	<input type="hidden" name="iIdOnglet" value="<%= iIdOnglet  %>" />
	<input type="hidden" name="iIdEditorialAssistanceGroup" value="<%= group.getId() %>" />
	<input type="submit" value="Valider" />
	</div>
	<br/>
<%
	}

	if(iIdOnglet == Onglet.ONGLET_AR_GROUP_GROUPE)
	{
		if(sAction.equals("store"))
		{
			%><%@ include file="pave/paveEditorialAssistanceGroupForm.jspf" %><%
		}
		else
		{
			%><%@ include file="pave/paveEditorialAssistanceGroup.jspf" %><%
		}	
	}
	
	if(iIdOnglet == Onglet.ONGLET_AR_GROUP_CONTENUS)
	{
		Vector<EditorialAssistance> vEdit = EditorialAssistance.getAllFromEditorialAssistanceGroupWithHabilitations((int)group.getId(),sessionUser,sessionUserHabilitation);
		%><%@ include file="pave/paveEditorialAssistanceGroupContenus.jspf" %><%	
	}
	
	if(iIdOnglet == Onglet.ONGLET_AR_GROUP_VISIBILITE)
	{
		if(sAction.equals("store"))
		{
			%><%@ include file="pave/paveEditorialAssistanceGroupVisibiliteForm.jspf" %><%
		}
		else
		{
			%><%@ include file="pave/paveEditorialAssistanceGroupVisibilite.jspf" %><%
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