<%@ include file="../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.*,org.coin.bean.html.*,org.coin.bean.document.*,java.util.*,org.coin.fr.bean.*,modula.*,org.coin.util.*,modula.marche.*,modula.graphic.*" %>
<%
	String sTitle = "Ajouter un document";
	String sPageUseCaseId = "IHM-DESK-GED-001";
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
			sPageUseCaseId = "IHM-DESK-GED-012";
		}
		sTitle += " à "+org.getName();
	}
	
	if(iIdTypeObjet == ObjectType.PERSONNE_PHYSIQUE)
	{
		PersonnePhysique pers = PersonnePhysique.getPersonnePhysique(iIdReferenceObjet);
		if(personneUser.getId() == pers.getId())
		{
			sPageUseCaseId = "IHM-DESK-GED-011";
		}
		sTitle += " à "+pers.getName();
	}
	
	String sVisibilite = "public";
	if(iIdTypeObjet != ObjectType.SYSTEME)
		sVisibilite = "private";
	
	String sMessage = "";
	try{sMessage = request.getParameter("sMessage");}
	catch(Exception e){}
	if(sMessage == null) sMessage = "";
	
	PersonnePhysique auteur = PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual());
	Document doc = new Document();
	
%>
<%@ include file="../include/checkHabilitationPage.jspf" %>
<script type="text/javascript" src="<%= rootPath %>include/verification.js"></script>
<script type="text/javascript">
<%@ include file="pave/ajouterDocument.jspf" %>
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
<form action="<%=response.encodeURL("modifierDocument.jsp?sAction="+sAction)%>" method="post" name="formulaire" enctype="multipart/form-data" onSubmit="return checkForm();">
<%@ include file="pave/paveAjouterDocumentForm.jspf" %>
<br />
<div style="text-align:center">
	<input type='hidden' name='<%= sFormPrefix %>iIdPersonnePhysiqueAuteur' value='<%= auteur.getId() %>' />&nbsp;
	<input type='hidden' name='<%= sFormPrefix %>iIdTypeObjet' id='<%= sFormPrefix %>iIdTypeObjet' value='<%= iIdTypeObjet %>' />&nbsp;
	<input type='hidden' name='<%= sFormPrefix %>iIdReferenceObjet' id='<%= sFormPrefix %>iIdReferenceObjet' value='<%= iIdReferenceObjet %>' />&nbsp;
	<input type='submit' name='submit' value='Ajouter' />&nbsp;
	<input type="button" name="RAZ" value="Annuler" onclick="Redirect('<%= response.encodeURL("afficherTousDocuments.jsp") %>')" />
</div>
</form>
<%@ include file="../../include/new_style/footerFiche.jspf" %>
</body>
</html>