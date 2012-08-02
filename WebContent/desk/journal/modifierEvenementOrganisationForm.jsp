<%@ include file="../../include/headerXML.jspf" %>

<%@ page import="java.util.*, modula.journal.*, org.coin.fr.bean.*"%>
<%@ include file="../include/beanSessionUser.jspf" %>
<%
	String sType = request.getParameter("sType");
	String sIdObjet = request.getParameter("sIdObjet");
	String sTitle = "Evénement";
	String sAction = request.getParameter("sAction");
	int iIdEvenement = -1;
	Evenement oEvenement = null;
	String sActionLibelle = "";
	if (sAction == null) {
		return;
	}
	if(sAction.equals("create"))
	{
		oEvenement = new Evenement ();
		oEvenement.setIdReferenceObjet(Integer.parseInt(sIdObjet));
		sActionLibelle = "Ajouter";
	}
	
	if(sAction.equals("store"))
	{
		if (request.getParameter("iIdEvenement") != null) {
			iIdEvenement = Integer.parseInt(request.getParameter("iIdEvenement"));
		} 
		
		oEvenement = Evenement.getEvenement(iIdEvenement);
		sActionLibelle = "Modifier";
	}
	
	String rootPath = request.getContextPath()+"/";
	Organisation oOrganisation = Organisation.getOrganisation(oEvenement.getIdReferenceObjet());
	String sRedirection = "";
%>
<%@ include file="../include/headerDesk.jspf" %>
</head>
<body>
<div class="titre_page"><%= sTitle %></div>
<form action="<%= response.encodeUrl("modifierEvenementsOrganisation.jsp")%>" method="post" name="formulaire" >
<% String sFormPrefix = ""; %>
<%@ include file="pave/paveEvenementOrganisationForm.jspf"%>
<br />
<div style="text-align:center">
	<input type="submit" value="<%=sActionLibelle %>" 
		onclick="checkForm()')" />
	<input type="button" value="Annuler" 
		onclick="Redirect('<%=response.encodeRedirectURL("afficherTousEvenements.jsp?sType="+sType+"&amp;sIdObjet="+sIdObjet) %>')" />
</div> 
</form>
<!-- /Liste des types d'évenements -->
<%@ include file="../include/footerDesk.jspf"%>
</body>
</html>