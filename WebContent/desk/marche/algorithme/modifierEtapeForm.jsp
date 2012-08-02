<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="java.util.*,modula.algorithme.*" %>
<%
	String sSelected ;
	String sTitle = null;
	int iIdEtape;
	String sAction = null;

	Etape etape = null;
	sAction = request.getParameter("sAction") ;
	if(sAction.equals("store"))
	{
		iIdEtape = Integer.parseInt( request.getParameter("iIdEtape") );
		sTitle = "Modifier une étape"; 
		etape = Etape.getEtape(iIdEtape);
	}
	
	if(sAction.equals("create"))
	{
		iIdEtape = -1;
		sTitle = "Ajouter une étape"; 
		etape = new Etape();
	}
	
	Vector vPhases = Phase.getAllStaticMemory();
	
	String sComplement = "(1 Affaire et 2 Lot)";
    if(Theme.getTheme().equalsIgnoreCase("veolia")){
        sComplement = "";
    }
	
%>
</head>
<body>
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<form name="formulaire" action="<%= response.encodeURL("modifierEtape.jsp")%>" method='post' >
	<input type="hidden" name="iIdEtape" value="<%= etape.getId() %>" />
	<input type="hidden" name="sAction" value="<%=sAction %>" />
	<br />
	<table class="pave" summary="none">
		<tr>
			<td class="pave_titre_gauche" colspan="2" >Informations</td>
		</tr>
		<tr>
			<td  colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">Libellé : </td>
			<td class="pave_cellule_droite"><input value="<%=etape.getLibelle() %>" name="sLibelle" size="100" /></td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">Appartient à la phase : </td>
			<td class="pave_cellule_droit" >
				<select name="iIdAlgoPhase" >
				<% for (int i = 0; i < vPhases.size(); i++) 
				{
					sSelected = "";
					Phase phase = (Phase) vPhases.get(i);
					if(phase.getId() == etape.getIdAlgoPhase() ) sSelected = "SELECTED";
				 %>
					<option <%= sSelected %> value="<%= phase.getId() %>" ><%= phase.getName() %></option>
				<%}%>
				</select></td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">Cas d'utilisation : </td>
			<td class="pave_cellule_droite"><input value="<%=etape.getIdUseCase() %>" name="sIdUseCase" size="100" /></td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">URL du formulaire : </td>
			<td class="pave_cellule_droite"><input value="<%=etape.getUrlFormulaire() %>" name="sUrlFormulaire" size="100" /></td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">URL du traitement : </td>
			<td class="pave_cellule_droite"><input value="<%=etape.getUrlTraitement() %>" name="sUrlTraitement" size="100" /></td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">Type d'objet <%= sComplement %> : </td>
			<td class="pave_cellule_droite"><input value="<%=etape.getIdObjetType() %>" name="iIdObjetType" size="100" /></td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">Commentaire : </td>
			<td class="pave_cellule_droite"><textarea name="sCommentaire" cols='100' rows='5' ><%=etape.getCommentaire()%></textarea></td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">Schéma (grand) : </td>
			<td class="pave_cellule_droite"><input value='<%= etape.getUrlSchemaFull() %>' name="sUrlSchemaFull" size="100" /></td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">Schéma (vignette) : </td>
			<td class="pave_cellule_droite"><input value='<%= etape.getUrlSchemaThumb() %>' name="sUrlSchemaThumb" size="100" /></td>
		</tr>
		<tr>
			<td  colspan="2">&nbsp;</td>
		</tr>
	</table>
	<br />
	<input type="submit" value="<%=sTitle %>" />
	<input type="button" value="Annuler" onclick="javascript:Redirect('<%=response.encodeRedirectURL("afficherEtape.jsp?iIdEtape="+etape.getId()) %>')" />
</form>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>
</html>
