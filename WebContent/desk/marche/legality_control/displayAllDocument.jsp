<%@ include file="/include/new_style/headerDesk.jspf" %>
</head>
<body>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);

	String sTitle = "Contrôle de légalité";

	Vector<Onglet> vOnglets = new Vector<Onglet>();
	vOnglets.add( new Onglet(0, false, "Eléments envoyés", "displayAllDocument.jsp?iIdOnglet=0") ); 
	vOnglets.add( new Onglet(1, false, "Eléments reçus", "displayAllDocument.jsp?iIdOnglet=1") ); 
	vOnglets.add( new Onglet(2, false, "Recherche", "displayAllDocument.jsp?iIdOnglet=2") ); 

%>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<%@ include file="/include/new_style/headerAffaireOnlyButtonDisplayAffaire.jspf" %>
<div style="padding:15px">
<div class="tabFrame">
<div class="tabs">
<%
	for (int i = 0; i < vOnglets.size(); i++) 
	{
		Onglet onglet = vOnglets.get(i);
		if(!onglet.bHidden)
		try {
			String sImageInCreation = "" ;
			String sOnClick = "";
			
			
			%><div <%= (onglet.bIsCurrent?"class=\"active\"":"")%>
				onclick="javascript:location.href='<%= response.encodeURL(onglet.sTargetUrl 
					+"&amp;iIdAffaire="+marche.getId()
					+"&amp;nonce=" + System.currentTimeMillis())%>';">
					<%= onglet.sLibelle %><%= sImageInCreation %>
			</div><%	
		} 
		catch (Exception e) {
			e.printStackTrace();
		}
	}
	%>
</div>
<div class="tabContent">
<button onclick="Redirect('<%= response.encodeURL("modifyDocumentForm.jsp?iIdAffaire=" + marche.getId()) 
	%>');" >Ajouter un document</button>

</div>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>

<%@page import="modula.marche.Marche"%></html>
