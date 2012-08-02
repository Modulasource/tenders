<%@ include file="../../../include/new_style/headerDesk.jspf" %>

<%@ page import="modula.*,modula.journal.*"%>
<%
	String sAction = request.getParameter("sAction");
	String sTitle = "";
	int iIdTypeEvenement = -1;
	if (request.getParameter("iIdTypeEvenement") != null) {
		iIdTypeEvenement = Integer.parseInt(request.getParameter("iIdTypeEvenement"));
	} else {
		iIdTypeEvenement = -1;
	}
	TypeEvenement oTypeEvenement = null;
	
	if (sAction.equals("load")) {
		sTitle = "Type d'évenement";
		oTypeEvenement = TypeEvenement.getTypeEvenementMemory(iIdTypeEvenement);
	}
	
	String sSelected="";
	String sPageUseCaseId = "IHM-DESK-JOU-007";
%>
<%@ include file="../../include/checkHabilitationPage.jspf" %>
</head>
<body>
<%@ include file="../../../include/new_style/headerFiche.jspf" %>
<br/>
<form action="<%= response.encodeURL("modifierTypeEvenementForm.jsp?sAction=store&amp;iIdTypeEvenement=" + iIdTypeEvenement )%>" method="post" name="formulaire" >
<% String sFormPrefix = ""; %>
<%@ include file="pave/paveTypeEvenement.jspf"%>

	<br />
	<div style="text-align:center">
		<input type="submit" value="Modifier" />
		<input type="button" value="Retour" 
			onclick="Redirect('<%= response.encodeURL("afficherTousTypeEvenement.jsp") %>')" />
		<input type="button" value="Supprimer" 
			onclick="Redirect('<%= response.encodeURL("modifierTypeEvenement.jsp?sAction=remove&amp;iIdTypeEvenement=" + iIdTypeEvenement )%>')"/>
		
	</div> 
</form>
<%@ include file="../../../include/new_style/footerFiche.jspf" %>
</body>
</html>