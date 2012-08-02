<%@ include file="../../../include/new_style/headerDesk.jspf" %>

<%@ page import="modula.*,java.util.*, modula.journal.*, org.coin.bean.*"%>
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
	Vector vUseCases = null;
	
	if (sAction.equals("create")) {
		sTitle = "Ajouter un type d'évenement";
		oTypeEvenement = new TypeEvenement();
		// FLON à revoir
		//vUseCases = TypeEvenement.getAllUseCaseNonAssociesTypeEvenement();
		vUseCases = UseCase.getAllStaticMemory();
	}
	if (sAction.equals("store")) {
		sTitle = "Modifier un type d'évenement";
		oTypeEvenement = TypeEvenement.getTypeEvenementMemory(iIdTypeEvenement);
		vUseCases = UseCase.getAllStaticMemory();
	}
	Vector vTypesObjetsModula ;
	vTypesObjetsModula = TypeObjetModula.getAllTypeObjetModula();
	String sSelected="";
	String sPageUseCaseId = "IHM-DESK-JOU-008";
%>
<%@ include file="../../include/checkHabilitationPage.jspf" %>
</head>
<body>
<%@ include file="../../../include/new_style/headerFiche.jspf" %>
<br/>
<form action="<%= response.encodeURL("modifierTypeEvenement.jsp?sAction=" + sAction + "&amp;iIdTypeEvenement=" + iIdTypeEvenement ) %>" method="post" name="formulaire" >
<% String sFormPrefix = ""; %>
<%@ include file="pave/paveTypeEvenementForm.jspf" %>

	<br />
	<div style="text-align:center">
		<%
		String sSubmitValue = "Ajouter";
		if(sAction.equals("store"))
		{
			sSubmitValue = "Modifier";
		}
		
		%>
		<input type="submit" value="<%= sSubmitValue %>"  />
		<input type="button" value="Annuler" 
			onclick="Redirect('<%= response.encodeURL("afficherTousTypeEvenement.jsp") %>')" />
		
	</div> 
</form>
<%@ include file="../../../include/new_style/footerFiche.jspf" %>
</body>
</html>