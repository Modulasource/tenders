<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="modula.graphic.*,java.sql.*,org.coin.fr.bean.*,org.coin.util.*,java.util.*,modula.algorithme.*, modula.*, modula.marche.*,modula.candidature.*, modula.marche.cpv.*,modula.commission.*, org.coin.util.treeview.*,java.text.*" %>
<%@ page import="mt.modula.servlet.*"%>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);

	int iIdOnglet = HttpUtil.parseInt("iIdOnglet", request, 0);
	String sTitle = "Afficher le registre de l'affaire ref. " + marche.getReference(); 
	String sHeadTitre = "";
	boolean bAfficherPoursuivreProcedure = false;
	Vector<MarcheLot> vLots = MarcheLot.getAllLotsFromMarcheAndPA(marche);
	boolean bIsContainsEnveloppeCManagement = AffaireProcedure.isContainsEnveloppeCManagement(marche.getIdAlgoAffaireProcedure());
	int iTypeProcedure = AffaireProcedure.getTypeProcedure(marche.getIdAlgoAffaireProcedure());
	
	Onglet.sNotCurrentTabStyle = " class='onglet_non_selectionne' "; 
	Onglet.sCurrentTabStyle =  " class='onglet_selectionne' ";
	Onglet.sNotCurrentTabStyleInCreation = " class='onglet_non_selectionne' ";
	Onglet.sCurrentTabStyleInCreation =  " class='onglet_selectionne' ";
	Onglet.sEnddingTabStyle =  " class='onglet_vide_dernier' ";

	Vector<Onglet> vOnglets = new Vector<Onglet>();

	vOnglets.add( new Onglet(0, false, "Registre des retraits du DCE", response.encodeURL("afficherRegistre.jsp?iIdOnglet=0") ) ); 
	if(iTypeProcedure!=AffaireProcedure.TYPE_PROCEDURE_PETITE_ANNONCE){
		vOnglets.add( new Onglet(1, false, "Registre des candidatures", response.encodeURL("afficherRegistre.jsp?iIdOnglet=1") ) ); 
		vOnglets.add( new Onglet(2, false, "Registre des offres", response.encodeURL("afficherRegistre.jsp?iIdOnglet=2") ) ); 
		vOnglets.add( new Onglet(3, false, "Pièces", response.encodeURL("afficherRegistre.jsp?iIdOnglet=3") ) ); 
	}
	Onglet onglet = vOnglets.get(iIdOnglet);
	onglet.bIsCurrent = true;
	

%>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<% if(iTypeProcedure==AffaireProcedure.TYPE_PROCEDURE_PETITE_ANNONCE){ %>
<%@ include file="/desk/include/headerPetiteAnnonceOnlyButtonDisplayPA.jspf" %>
<%}else{ %>
<%@ include file="/include/new_style/headerAffaireRegistrePage.jspf" %>
<%} %>
<br/>

<div class="tabFrame">
<div class="tabs">
	<%
	for (int i = 0; i < vOnglets.size(); i++) 
	{
		onglet = vOnglets.get(i);
		if(!onglet.bHidden)
		try {
			String sImageInCreation = "" ;
			String sOnClick = "";
			
			
			%><div <%= (onglet.bIsCurrent?"class=\"active\"":"") %>
				onclick="javascript:location.href='<%= response.encodeURL(onglet.sTargetUrl 
					+"&amp;iIdAffaire="+marche.getIdMarche()
					+"&amp;nonce=" + System.currentTimeMillis())%>';">
				<%= onglet.sLibelle %><%= sImageInCreation %></div>
			<%	
		} 
		catch (Exception e) {
			e.printStackTrace();
		}
	}
	%>
</div>
<div class="tabContent">
<%

	/*if( marche.isAffairePublieeSurPublisher(false) 
	|| (!AffaireProcedure.isContainsAAPCPublicity(marche.getIdAlgoAffaireProcedure()) 
		&& marche.isAffaireValidee(false)))
	*/
	{
		if( iIdOnglet == 0 )
		{
%> 
<jsp:include page="pave/ongletRegistreRetraitDCE.jsp" flush="true">
    <jsp:param name="iIdMarche" value="<%= marche.getIdMarche() %>"/>
</jsp:include>
<%
		}
		if( iIdOnglet == 1 	)
		{
%>
<jsp:include page="pave/ongletRegistreCandidature.jsp" flush="true">
    <jsp:param name="iIdMarche" value="<%= marche.getIdMarche() %>"/>
</jsp:include>
<%
		}
		if( iIdOnglet == 2 )
		{
			if(bIsContainsEnveloppeCManagement)
			{
			%>
<jsp:include page="pave/ongletRegistreOffreC.jsp" flush="true">
    <jsp:param name="iIdMarche" value="<%= marche.getIdMarche() %>"/>
</jsp:include><%
			}
		%>
<jsp:include page="pave/ongletRegistreOffre.jsp" flush="true">
    <jsp:param name="iIdMarche" value="<%= marche.getIdMarche() %>"/>
</jsp:include>
        <%
		}

		if( iIdOnglet == 3 )
		{
%>
<table class="pave" >
	<tr>
		<td class="pave_titre_gauche" colspan="2">Toutes les pièces</td> 
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td> 
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td> 
	</tr>
	<tr>
		<td class="pave_cellule_gauche" >
		Fichier zip contenant toutes pièces des offres et candidatures : 
		</td>
		<td class="pave_cellule_droite" >
		<img alt="Fichier zip"
			style="cursor: pointer"
			 src="<%= 
			rootPath %>images/icons/32x32/zip.png"
			onclick="javascript:OuvrirPopup('<%= 
			response.encodeURL(rootPath + "desk/DownloadZipAffaireEnveloppeServlet?"
			+ DownloadZipAffaireDceServlet
				.getSecureTransactionString(marche.getIdMarche(), request)) 
				%>',400,200,'menubar=no,scrollbars=yes,statusbar=no');" />
		</td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td> 
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td> 
	</tr>
</table>
<%
		}
	}

%>
</div>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>
