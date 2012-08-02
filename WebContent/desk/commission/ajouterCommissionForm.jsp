<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.fr.bean.*,java.util.*,modula.commission.*, modula.marche.*" %>
<%
	String sTitle = "Création d'une commission";
	int id = -1;
	String sPageUseCaseId = "IHM-DESK-COM-002";

	if(!sessionUserHabilitation.isHabilitate(sPageUseCaseId ) )
	{
		sPageUseCaseId = "IHM-DESK-COM-19";
	}
%><%@ include file="../include/checkHabilitationPage.jspf" %><%
	
	Organisation organisation = null;
	Adresse adresseAdministrative = null;
	
	boolean bReadOnly = false;
	boolean bDisplayForm = true;

	if (request.getParameter("iIdOrganisation") != null)
	{
		id = Integer.parseInt(request.getParameter("iIdOrganisation"));
		organisation = Organisation.getOrganisation(id);
		adresseAdministrative = Adresse.getAdresse(organisation.getIdAdresse());
		
		// l'organisation est connue, ok pour remplir les champs
		bDisplayForm = true;
	}
	else
	{
	  	
	  	if( sPageUseCaseId.equals("IHM-DESK-COM-19") )
	  	{
	  		// il faut forcer l'affichage de l'organisation du user
	  		PersonnePhysique maPersonne = PersonnePhysique.getPersonnePhysique( sessionUser.getIdIndividual() );
	  		organisation = Organisation.getOrganisation(maPersonne.getIdOrganisation() );
			id = organisation.getIdOrganisation();
			bDisplayForm = true;
			adresseAdministrative = Adresse.getAdresse(organisation.getIdAdresse());
	  		
	  	}
	  	else
	  	{
		  	// il n'est pas possible de modifier le formulaire tant que l'organisation n'a pas été choisie
			organisation = new Organisation();
			adresseAdministrative = new Adresse();
	  		bDisplayForm = false;
	  	}
	  	
	 	
	}
	String sFormPrefix = "";

	Vector<Organisation> vOrganisations 
		= Organisation.getAllOrganisationsWithIdType(
				OrganisationType.TYPE_ACHETEUR_PUBLIC  );

	Adresse adresse ; 
	Pays pays = new Pays();
	try{
		pays = Pays.getPays (adresseAdministrative.getIdPays() );
	} catch (Exception e) {}
	Commission commission = new Commission();

%>
<script type="text/javascript" src="<%= rootPath%>include/js/desk/commission/ajouterCommissionForm.js") %>" ></script>
<script type="text/javascript" src="<%= rootPath%>include/verification.js" ></script>
<script type="text/javascript" src="<%= rootPath%>include/changeUrl.js" ></script>
<script type="text/javascript">
function checkForm()
{
	var formulaire = document.formulaire;
	if (!checkCommission(formulaire,""))
		return false;
	}
	return true;
}
</script>
</head>
<body>
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<form action="<%= response.encodeURL("ajouterCommission.jsp") %>" method="post" name="formulaire" onsubmit="return checkForm();">
	<div class="mention">* : Champs obligatoires </div>
	<br />
	<%@ include file="pave/paveCommissionInfosForm.jspf" %>
	<br />
	<div style="text-align:center">
		<% if( bDisplayForm) 
		{ 
		%><input type="submit" name="submit" value="Inscrire" />&nbsp;
		<% } %><input type="reset" name="RAZ" value="Annuler" 
		onclick="Redirect('<%= response.encodeURL(rootPath+"desk/commission/afficherTouteCommission.jsp")%>')" />
	</div>
</form>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>
</html>