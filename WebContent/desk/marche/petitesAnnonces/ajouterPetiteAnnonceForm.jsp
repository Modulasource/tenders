<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="modula.marche.*"%>
<%
	String sUrlCancel = "";
	String sFormPrefix = "";
	String sTitle = "Ajouter une petite annonce";
	int iIdPetiteAnnonce = -1;
	String sAction = null;
	Marche marche = null;
	
	sAction = "create";
	String sPageUseCaseId = "IHM-DESK-PA-5";
%>
<%@ include file="/desk/include/checkHabilitationPage.jspf" %>
<script src="<%= rootPath %>include/cacherDivision.js" type="text/javascript"></script>
<script type="text/javascript" src="<%= rootPath %>include/AjaxComboList.js?v=<%= JavascriptVersion.AJAX_COMBO_LIST_JS %>"></script>
<script type="text/javascript" src="<%=rootPath %>include/fonctions.js"></script>
<%@ include file="pave/paveAjouterPetiteAnnonce.jspf" %>
</head>
<body> 
<%@ include file="/include/new_style/headerFiche.jspf" %>
<form name="formulaire" action="<%=response.encodeURL (rootPath +"desk/marche/petitesAnnonces/modifierPetiteAnnonce.jsp")%>" method="post">
	<input type="hidden" name="sAction" value="<%=sAction %>" />
	<input type="hidden" name="iIdAffaire" value="<%= iIdPetiteAnnonce %>" />
<%@ include file="pave/paveChoisirOrganismeForm.jspf" %>
<%@ include file="pave/paveProcedureForm.jspf" %>
<br />
		
<div align="center">		
	<button type="submit" onclick="return checkForm();"><%=sTitle %></button>
</div>
</form>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>
