<%@ include file="../../include/headerXML.jspf" %>

<%@ page import="java.util.*, modula.journal.*, modula.commission.*"%>
<%@ include file="../include/beanSessionUser.jspf" %>
<%
	String sType = request.getParameter("sType");
	String sIdObjet = request.getParameter("sIdObjet");
	String sTitle = "Evénement";
	int iIdEvenement = -1;
	if (request.getParameter("iIdEvenement") != null) {
		iIdEvenement = Integer.parseInt(request.getParameter("iIdEvenement"));
	} else {
		iIdEvenement = -1;
	}
	
	String rootPath = request.getContextPath()+"/";
	
	Evenement oEvenement = Evenement.getEvenement(iIdEvenement);
	
	Commission oCommission = Commission.getCommission(oEvenement.getIdReferenceObjet());
	
	String sRedirection = "";
	String sPageUseCaseId = "IHM-DESK-JOU-002";
%>
<%@ include file="../include/checkHabilitationPage.jspf" %>
<%@ include file="../include/headerDesk.jspf" %>
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
<div class="titre_page"><%= sTitle %></div>
<!-- Moteur de recherche -->
<!-- Formulaire de tri & filtre -->
<form action="<%=response.encodeUrl("afficherTousEvenements.jsp")%>" method="post" name="formulaire" >
<% String sFormPrefix = ""; %>
<%@ include file="pave/paveEvenementCommission.jspf"%>
<br />
	<tr>
		<div style="text-align:center">
<%
	if(sessionUserHabilitation.isSuperUser())
	{
%>
		<input type="button" value="Supprimer" 
			onclick="javascript:removeEvent();" /> Fonction Super Admin
<%
	}
%>	
		<input type="button" value="Annuler" 
				onclick="Redirect('<%=response.encodeRedirectURL("afficherTousEvenements.jsp?sType="+sType+"&sIdObjet="+sIdObjet) %>')" />
		</div> 
	</tr>
</form>
<!-- /Liste des types d'évenements -->
<%@ include file="../include/footerDesk.jspf"%>
</body>
</html>