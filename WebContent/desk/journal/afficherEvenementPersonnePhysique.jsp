<%@ include file="../../include/new_style/headerDesk.jspf" %>

<%@ page import="java.util.*, modula.journal.*, modula.marche.*"%>
<%@ include file="pave/getHttpParameters.jspf" %>
<%
	String sPageUseCaseId = "IHM-DESK-JOU-004";
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
<form action="none" >
<% String sFormPrefix = ""; %>
<%@ include file="pave/paveEvenementPersonnePhysique.jspf" %>
<br />
	<div style="text-align:center">
		<button type="button" 
			onclick="Redirect('<%=
				response.encodeRedirectURL("afficherTousEvenements.jsp?" +
						sExtraParam.replaceAll("&amp;", "&")) %>')" >Retour</button>&nbsp;
<%
	if(sessionUserHabilitation.isSuperUser())
	{
%>
		<button type="button" 
			onclick="javascript:removeEvent();" >Supprimer</button>Fonction Super Admin
<%
	}
%>	
		
	</div> 
</form>
</div>
<%@ include file="../../include/new_style/footerFiche.jspf" %>	
</body>
</html>