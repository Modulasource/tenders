<%@ include file="../../include/headerXML.jspf" %>

<%@ page import="org.coin.fr.bean.annonce.*,java.util.*,org.coin.fr.bean.*,modula.*,org.coin.util.*,modula.marche.*,modula.graphic.*" %>
<%@ include file="../include/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath()+"/";
	String sTitle = "Formulaire de création d'une parution";

	String sFormPrefix = "";
	boolean bReadOnly = false;

	Annonce annonce = new Annonce();
	String sPageUseCaseId = "IHM-DESK-ANN-001";
	
	int iIdTypeObjet= TypeObjetModula.PERSONNE_PHYSIQUE;
	int iIdReferenceObjet = sessionUser.getIdIndividual();
	try {
		iIdTypeObjet = Integer.parseInt(request.getParameter("iIdTypeObjet"));
	}catch (Exception e) {}

	try {
		iIdReferenceObjet = Integer.parseInt(request.getParameter("iIdReferenceObjet"));
	}catch (Exception e) {}

	annonce.setIdTypeObjet(iIdTypeObjet);
	annonce.setIdReferenceObjet(iIdReferenceObjet);

	annonce.setIdAnnonceEtat(AnnonceEtat.ETAT_EN_COURS_DE_REDACTION);

%><%@ include file="../include/checkHabilitationPage.jspf" %>
<%@ include file="../include/headerDesk.jspf" %>
<script type="text/javascript" src="<%= rootPath %>include/verification.js" ></script>
<script type="text/javascript" src="<%= rootPath %>include/bascule.js" ></script>
<script type="text/javascript" src="<%= rootPath %>include/pave/paveAdresse.js" ></script>
<script type="text/javascript" src="<%= rootPath %>include/pave/paveOrganisationCoordonnees.js" ></script>
<script type="text/javascript" src="<%= rootPath %>include/pave/paveOrganisationDonneesAdministratives.js" ></script>
<script type="text/javascript">
function checkForm()
{
	var form = document.formulaire;
	
	return true;
}

</script>
</head>
<body>
<form action="<%=response.encodeURL("modifierAnnonce.jsp")%>" method="post" name="formulaire" onsubmit="return checkForm();">
	<div class="titre_page"><%= sTitle %></div>
	<div class="mention">* : Champs obligatoires </div>
	<br />
	<%@ include file="pave/paveAnnonceReferenceForm.jspf" %>
	<br />
	
	<div style="text-align:center">
		<input type='hidden' name='sAction' value='create' />&nbsp;
		<input type='submit' name='submit' value='Inscrire' />&nbsp;
		<input type="button" name="RAZ" value="Annuler" onclick="Redirect('<%= response.encodeURL("afficherToutesAnnonces.jsp?") %>')" />
	</div>
</form>
<%@ include file="../include/footerDesk.jspf" %>
</body>
</html>