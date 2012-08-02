<%@ include file="../../include/new_style/headerDesk.jspf" %>

<%@ page import="modula.journal.*, modula.marche.*"%>
<%@ include file="pave/getHttpParameters.jspf" %>
<%
	Marche oMarche = Marche.getMarche(oEvenement.getIdReferenceObjet());
	Marche marche = oMarche;
	int iIdAffaire = oMarche.getIdMarche();
	String sPageUseCaseId = "IHM-DESK-JOU-001";
	

%>
<%@ include file="../include/checkHabilitationPage.jspf" %>
<script type="text/javascript">

function removeEvent()
{
	if( !confirm("Voulez-vous vraiment supprimer cet événement ?") ) 
	{
		return;
	}
	Redirect('<%=
		response.encodeRedirectURL(
			"modifierEvenement.jsp?sAction=remove&iIdEvenement=" 
			+ iIdEvenement + "&" + sExtraParam.replaceAll("&amp;", "&")) %>');
}
</script>

</head>
<body>
<% 
String sHeadTitre = "Evènements de l'affaire"; 
boolean bAfficherPoursuivreProcedure = false;
%>

<%@ include file="../../include/new_style/headerFiche.jspf" %>
<br/>
<div style="padding:15px">
<%@ include file="../../include/new_style/headerAffaireOnlyButtonDisplayAffaire.jspf" %>
<br />
<form action="none" >
<% String sFormPrefix = ""; %>
<%@ include file="pave/paveEvenementMarche.jspf" %>
<br />
	<div style="text-align:center">
		<button type="button" value="" 
			onclick="Redirect('<%=response.encodeRedirectURL("afficherTousEvenements.jsp?"
					+ sExtraParam.replaceAll("&amp;", "&")) %>')" >Retour</button>&nbsp;
<%
	if(sessionUserHabilitation.isSuperUser())
	{
%>
		<button type="button" 
			onclick="javascript:removeEvent();" >Supprimer</button> Fonction Super Admin
<%
	}
%>	

</div> 
</form>
	
</div>
<%@ include file="../../include/new_style/footerFiche.jspf" %>	
</body>
</html>