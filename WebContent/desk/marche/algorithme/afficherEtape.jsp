<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="modula.algorithme.*,modula.graphic.*" %>
<%
	String sSelected ;
	String sTitle ;
	int iIdEtape;
	iIdEtape = Integer.parseInt( request.getParameter("iIdEtape") );
	Etape etape = Etape.getEtape(iIdEtape);
	sTitle = "Description de l'étape"; 
	
	String sComplement = "(1 Affaire et 2 Lot)";
    if(Theme.getTheme().equalsIgnoreCase("veolia")){
    	sComplement = "";
    }
	
%>
<script type="text/javascript">
function confirmSubmit(phrase){
	var agree=confirm("Etes vous sûr de vouloir "+phrase);
	if (agree)
		return true ;
	else
		return false ;
}
</script>
</head>
<body>
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<table class="menu" cellspacing="2" summary="menu">
	<tr>
		<th>
			<a href="<%= response.encodeURL(rootPath+"desk/marche/algorithme/modifierEtapeForm.jsp?sAction=store&amp;iIdEtape="+etape.getId()) %>" ><img width="25" src="<%= rootPath %>images/icones/modifier.gif"  alt="Modifier l'étape" /></a>
		</th>
		<th>
			<a href="<%= response.encodeURL(rootPath+"desk/marche/algorithme/modifierEtape.jsp?sAction=remove&amp;iIdEtape="+etape.getId()) %>" onclick="return confirmSubmit('supprimer cette étape ?')" ><img width="25" src="<%= rootPath + Icone.ICONE_SUPPRIMER %>"  alt="Supprimer l'étape" /></a>
		</th>
		<td>&nbsp;</td>
	</tr>
	</table>
	<br />
	
	<table class="pave" summary="none">
		<tr>
			<td class="pave_titre_gauche" colspan="2" >Etape: <%=etape.getLibelle() %></td>
		</tr>
		<tr>
			<td  colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">Libellé : </td>
			<td class="pave_cellule_droite"><%=etape.getLibelle() %></td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">Phase Associée : </td>
			<td class="pave_cellule_droite"><%=Phase.getPhaseName( etape.getIdAlgoPhase() )%></td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">Cas d'utilsation : </td>
			<td class="pave_cellule_droit" ><%=etape.getIdUseCase() %></td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">URL du formulaire : </td>
			<td class="pave_cellule_droit" ><%=etape.getUrlFormulaire() %></td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">URL du traitement : </td>
			<td class="pave_cellule_droit" ><%=etape.getUrlTraitement() %></td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">Type d'objet <%= sComplement %> : </td>
			<td class="pave_cellule_droit" ><%=etape.getIdObjetType() %></td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">Commentaire : </td>
			<td class="pave_cellule_droit" ><%=org.coin.util.Outils.replaceAll(etape.getCommentaire(), "\n","<br />") %></td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">Schéma (vignette) : </td>
			<td class="pave_cellule_droit" ><img src='<%= rootPath + etape.getUrlSchemaThumb() %>' > </img></td>
		</tr>
		<tr>
			<td  colspan="2">&nbsp;</td>
		</tr>
	</table>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>

</body>
</html>
