<%@ include file="../../include/headerXML.jspf" %>

<%@ page import="java.util.*, modula.journal.*, org.coin.fr.bean.*,org.coin.util.*,org.coin.bean.*"%>
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
	int iIdTypeObjet = -1;
	
	if(sAction.equals("create"))
	{
		oEvenement = new Evenement ();
		sActionLibelle = "Ajouter";
		oEvenement.setIdReferenceObjet(Integer.parseInt( sIdObjet ) );
		oEvenement.setIdUser(sessionUser.getIdUser());
		iIdTypeObjet = ObjectType.PERSONNE_PHYSIQUE;
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
	String sRedirection = "";
%>
<%@ include file="../include/headerDesk.jspf" %>
</head>
<body>
<div class="titre_page"><%= sTitle %></div>
<form action="<%= response.encodeURL("modifierEvenement.jsp?sAction=" + sAction)%>" method="post" name="formulaire" >
<% String sFormPrefix = ""; %>
<%@ include file="pave/paveEvenementPersonnePhysiqueForm.jspf"%>
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