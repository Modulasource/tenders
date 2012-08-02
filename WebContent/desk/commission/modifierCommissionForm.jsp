<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.fr.bean.*,modula.commission.*,java.util.*"%>
<%@ include file="../include/beanSessionIdCommission.jspf" %>
<%
	String sTitle = "Formulaire de commission d'appel d'offre";
	boolean bReadOnly = false;
	boolean bDisplayForm = true;
	String sFormPrefix="";
	String sPaveAdresseTitre ;
	String sPageUseCaseId = "IHM-DESK-COM-004";

	Organisation organisation = Organisation.getOrganisation(commission.getIdOrganisation());
	
%>
<script type="text/javascript" src="<%= rootPath %>include/js/desk/commission/ajouterCommissionForm.js" ></script>
<script type="text/javascript" src="<%= rootPath %>include/js/desk/organisation/paveAdresse.js" ></script>
<script type="text/javascript" src="<%=rootPath%>include/verification.js" ></script>
<script type="text/javascript" src="<%= rootPath%>include/changeUrl.js" ></script>
<script type="text/javascript">
function checkForm()
{
	var formulaire = document.formulaire;
	if (!checkCommission(formulaire,""))
		return false;
	if (!checkAdresse(formulaire, "Technique_"))
		return false;
	return true;
}
</script>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>

TEST_DK
<form action="<%= response.encodeURL("modifierCommission.jsp") %>" method="post" name="formulaire" onsubmit="return checkForm();">
<input type="hidden" name="modification" value="1" />
<input type="hidden" name="iIdCommission" value="<%= commission.getIdCommission() %>" />
	<div class="mention">* : Champs obligatoires </div>
	<br />
	<%@ include file="pave/paveCommissionInfosForm2.jspf" %> 
	<br />
	<div style="text-align:center">
		<input type="submit" name="submit" value="Modifier" />
		&nbsp;<input type="reset" name="RAZ" value="Annuler" 
		onclick="Redirect('<%= response.encodeRedirectURL("afficherCommission.jsp?iIdCommission="+iIdCommission)%>')"/>
	</div>
</div>
</form>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>