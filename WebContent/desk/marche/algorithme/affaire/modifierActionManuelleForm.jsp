<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="modula.marche.*" %>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);

	String sSelected ;
	String sTitle = null;
	String sAction = null;

	sAction = request.getParameter("sAction") ;
	if(sAction.equals("store"))
	{
		sTitle = "Modifier une action manuelle"; 
	}
	
	if(sAction.equals("create"))
	{
		sTitle = "Ajouter une action manuelle"; 
	}
		
%>
</head>
<body>
<%@ include file="/include/new_style/headerFichePopUp.jspf" %>
<br/>
<div style="padding:15px">
<form name="formulaire" action="<%=response.encodeUrl("modifierActionManuelle.jsp")%>" method='post' >
	<input type="hidden" name="sAction" value="<%=sAction %>" />
	<table class="pave" >
		<tr>
			<td class="pave_titre_gauche" colspan="2" >Informations</td>
		</tr>
		<tr>
			<td  colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">Action Manuelle : </td>
			<td class="pave_cellule_droite">
				<select name="sActionManuelle" >
					<option>Réception d'un courrier postal</option>
					<option>Réception d'un FAX</option>
					<option>Réception d'un FAX</option>
					<option>Livraison</option>
					<option>Autre</option>
				<select>
			</td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">Commentaire : </td>
			<td class="pave_cellule_droite"><textarea name="sCommentaire" cols='98' rows='2' ></textarea></td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">Nom de la pièce jointe : </td>
			<td class="pave_cellule_droite"><input value='' name="sPieceJointeNom" size="100" /></td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">Pièce jointe : </td>
			<td class="pave_cellule_droite"><input type="file" value="" name="filePieceJointe" size="85" /></td>
		</tr>
		<tr>
			<td  colspan="2">&nbsp;</td>
		</tr>
	</table>
	<br />
	<input type="submit" value="<%=sTitle %>" />
	<input type="button" value="Annuler" onclick="javascript:Redirect('<%=
		response.encodeRedirectURL("afficherAffaire.jsp?iIdAffaire=" + iIdAffaire) %>')" />
</form>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>

</body>
</html>
