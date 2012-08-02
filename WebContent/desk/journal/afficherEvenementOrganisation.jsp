<%@ include file="../../include/new_style/headerDesk.jspf" %>

<%@ page import="java.util.*, modula.journal.*, org.coin.fr.bean.*"%>
<%@ include file="pave/getHttpParameters.jspf" %>
<%
	Organisation oOrganisation = Organisation.getOrganisation(oEvenement.getIdReferenceObjet());
	String sPageUseCaseId = "IHM-DESK-JOU-003";
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

<%@ include file="../../include/new_style/headerFiche.jspf" %>
<br/>
<div style="padding:15px">
<% String sHeadTitre = "Evènements de l'organisation "+oOrganisation.getRaisonSociale(); %>
<form action="none" >
<% String sFormPrefix = ""; %>
<%@ include file="pave/paveEvenementOrganisation.jspf"%>
<br />
	<div style="text-align:center">
		<button type="button" 
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