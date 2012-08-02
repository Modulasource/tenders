<%@ include file="../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.*,org.coin.bean.html.*,org.coin.bean.editorial.*,org.coin.fr.bean.*" %>
<%
	String sTitle = "Ajouter un groupe rédactionnel";
	String sPageUseCaseId = "IHM-DESK-AR-018";
	String sFormPrefix = "";
	String sAction = "create";
	
	PersonnePhysique personneUser = PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual() );
	
	int iIdTypeObjet = ObjectType.SYSTEME;
	try{iIdTypeObjet = Integer.parseInt(request.getParameter("iIdTypeObjet"));}
	catch(Exception e){iIdTypeObjet = ObjectType.SYSTEME;}
	
	int iIdReferenceObjet = 0;
	try{iIdReferenceObjet = Integer.parseInt(request.getParameter("iIdReferenceObjet"));}
	catch(Exception e){iIdReferenceObjet = 0;}
	
	if(iIdTypeObjet == ObjectType.ORGANISATION)
	{
		Organisation org = Organisation.getOrganisation(iIdReferenceObjet);
		if(personneUser.getIdOrganisation() == org.getIdOrganisation())
		{
			sPageUseCaseId = "IHM-DESK-AR-019";
		}
		sTitle += " à "+org.getName();
	}
	
	if(iIdTypeObjet == ObjectType.PERSONNE_PHYSIQUE)
	{
		PersonnePhysique pers = PersonnePhysique.getPersonnePhysique(iIdReferenceObjet);
		if(personneUser.getId() == pers.getId())
		{
			sPageUseCaseId = "IHM-DESK-AR-020";
		}
		sTitle += " à "+pers.getName();
	}
	
	String sVisibilite = "public";
	String sDisabled = "";
	if(iIdTypeObjet != ObjectType.SYSTEME){
		sVisibilite = "private";
		sDisabled = "disabled=\"disabled\"";
	}
	
	String sMessage = "";
	try{sMessage = request.getParameter("sMessage");}
	catch(Exception e){}
	if(sMessage == null) sMessage = "";
	
	PersonnePhysique auteur = PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual());
	EditorialAssistanceGroup group = new EditorialAssistanceGroup();
	
%>
<%@ include file="../include/checkHabilitationPage.jspf" %>
<script type="text/javascript" src="<%= rootPath %>include/verification.js"></script>
<script type="text/javascript">
<%@ include file="pave/ajouterEditorialAssistanceGroup.jspf" %>
</script>
</head>
<body>
<%@ include file="../../include/new_style/headerFiche.jspf" %>
<br/>
<div class="mention">* : Champs obligatoires </div>
<br />
<a name="ancreError"></a>
<div class="rouge" style="text-align:left" id="divError"></div>
<%
	HtmlBeanTableTrPave hbFormulaire = new HtmlBeanTableTrPave();
	hbFormulaire.bIsForm = true;
%>
<form action="<%=response.encodeURL("modifierEditorialAssistanceGroup.jsp?sAction="+sAction)%>" method="post" name="formulaire" onSubmit="return checkForm();">
<%@ include file="pave/paveAjouterEditorialAssistanceGroupForm.jspf" %>
<br />
<div style="text-align:center">
	<input type='hidden' name='<%= sFormPrefix %>iIdPersonnePhysiqueAuteur' value='<%= auteur.getId() %>' />&nbsp;
	<input type='hidden' name='<%= sFormPrefix %>iIdTypeObjet' id='<%= sFormPrefix %>iIdTypeObjet' value='<%= iIdTypeObjet %>' />&nbsp;
	<input type='hidden' name='<%= sFormPrefix %>iIdReferenceObjet' id='<%= sFormPrefix %>iIdReferenceObjet' value='<%= iIdReferenceObjet %>' />&nbsp;
	<input type='submit' name='submit' value='Ajouter' />&nbsp;
	<input type="button" name="RAZ" value="Annuler" onclick="Redirect('<%= response.encodeURL("afficherTousEditorialAssistanceGroup.jsp") %>')" />
</div>
</form>
<%@ include file="../../include/new_style/footerFiche.jspf" %>
</body>
</html>