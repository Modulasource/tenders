<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.*,java.util.*" %>
<%
	String sSelected ;
	String sAction;
	String sTitle ;
	int iIdAlgorithme;

	sAction = request.getParameter("sAction") ;

	if(sAction.equals("store"))
	{
		iIdAlgorithme = Integer.parseInt( request.getParameter("iIdAlgorithme") );
		sTitle = "Modifier Algorithme"; 
	}
	else
	{
		iIdAlgorithme = -1;
		sTitle = "Ajouter Algorithme"; 
	
	}
	
	String sSousEnsembleEtapesName ;
	String sSousEnsembleEtapesId ;
%>
<script src="<%= rootPath %>include/bascule.js" type="text/javascript"></script>
<script type="text/javascript">
	function checkForm(){
	
	if (Visualise(document.formulaire.ALGOMODULA_CONSTITUTIONiIdRoleSelection,document.formulaire.iIdRoleSelectionListe))
		return false;
		
	return true;
}
</script>

</head>
<body>
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<form name="formulaire" action="<%= response.encodeURL("modifierAlgorithme.jsp")%>"  >
	<input type="hidden" name="sAction" value="<%=sAction %>" />
	<div class="titre_page">Définition de l'algorithme : Appel d'Offres Ouvert</div>
	<table class="pave" summary="none">
		<tr>
			<td class="pave_titre_gauche" colspan="2">Phase : Constitution</td>
		</tr>
<%
		sSousEnsembleEtapesName = "Constitution de l'affaire";
		sSousEnsembleEtapesId = "ALGOMODULA_CONSTITUTION";
%>
<%@ include file="pave/paveSousEnsembleEtapes.jspf" %>

	</table>
	
	
	<br />
	<table class="pave" summary="none">
		<tr>
			<td class="pave_cellule_gauche">Conditions pour passer à la phase suivante : </td>
			<td class="pave_cellule_droite">&nbsp;</td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche"><input type="checkbox" /></td>
			<td class="pave_cellule_droite">Validation de l'affaire par le sécrétaire</td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche"><input type="checkbox" /></td>
			<td class="pave_cellule_droite">Validation de l'affaire par le président</td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche"><input type="checkbox" /></td>
			<td class="pave_cellule_droite">Signature électronique de l'affaire par le président</td>
		</tr>
	</table>
	
	
	<br />
	<table class="pave" summary="none">
		<tr>
			<td class="pave_titre_gauche" colspan="2">Phase : Publication</td>
		</tr>
<%
		sSousEnsembleEtapesName = "Publication de l'affaire";
		sSousEnsembleEtapesId = "ALGOMODULA_PUBLICATION";
%>
<%@ include file="pave/paveSousEnsembleEtapes.jspf" %>
		<tr>
			<td class="pave_cellule_gauche">Conditions pour passer à la phase suivante : </td>
			<td class="pave_cellule_droite">Envoi de l'affaire aux journaux par Modula Server</td>
		</tr>

	</table>
	<br />
	<table class="pave" summary="none">
		<tr>
			<td class="pave_titre_gauche" colspan="2">Phase : Passation</td>
		</tr>
<%
		sSousEnsembleEtapesName = "Passation de l'affaire";
		sSousEnsembleEtapesId = "ALGOMODULA_PASSATION";
%>
<%@ include file="pave/paveSousEnsembleEtapes.jspf" %>
		<tr>
			<td class="pave_cellule_gauche">Conditions pour passer à la phase suivante : </td>
			<td class="pave_cellule_droite">Clôture de la phase de passation</td>
		</tr>

	</table>
	<br />
	<table class="pave" summary="none">
		<tr>
			<td class="pave_titre_gauche" colspan="2">Phase : Attribution</td>
		</tr>
<%
		sSousEnsembleEtapesName = "Attribution de l'affaire";
		sSousEnsembleEtapesId = "ATTRIBUTION_ATTRIBUTION";
%>
<%@ include file="pave/paveSousEnsembleEtapes.jspf" %>
	</table>
	<br />
	<input type="submit" value="<%=sTitle %>"  onclick="javascript:" />
	<input type="button" value="Annuler" onclick="javascript:Redirect('<%=response.encodeRedirectURL("afficherTousAlgorithme.jsp")%>')" />
</form>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>
</html>
