<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="modula.algorithme.*" %>
<%
	String sLibelle = null;
	String sTitle = null;
	int iIdProcedure;
	String sAction = null;
	String sVerouilleNoSelected = null;
	String sVerouilleSelected = null;
	
	Procedure procedure = null;
	sAction = request.getParameter("sAction") ;
	if(sAction.equals("store"))
	{
		iIdProcedure = Integer.parseInt( request.getParameter("iIdProcedure") );
		sTitle = "Modifier une procédure"; 
		procedure = Procedure.getProcedure(iIdProcedure);
	}
	
	if(sAction.equals("create"))
	{
		iIdProcedure = -1;
		sTitle = "Ajouter une procédure"; 
		procedure = new Procedure();
	}
	
%>
</head>
<body>
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<form name="formulaire" action="<%= response.encodeURL("modifierProcedure.jsp")%>" method='post' >
	<input type="hidden" name="iIdProcedure" value="<%= procedure.getId() %>" />
	<input type="hidden" name="sAction" value="<%=sAction %>" />
	<table class="pave" summary="none">
		<tr>
			<td class="pave_titre_gauche" colspan="2" >Informations</td>
		</tr>
		<tr>
			<td  colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">Libellé : </td>
			<td class="pave_cellule_droite"><input value="<%=procedure.getLibelle() %>" name="sLibelle" size="100" /></td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">Verrouillé : </td>
			<td class="pave_cellule_droite">
				<select name="sVerrouille" >
					<% if(procedure.isVerrouille()) 
						{
							sVerouilleSelected="oui";
							sVerouilleNoSelected="non";
						}
					   else
					   {
					   		sVerouilleSelected="non";
							sVerouilleNoSelected="oui";
					   } 
					%>
					<option selected="selected"='selected' value="<%= procedure.isVerrouille() %>"> <%= sVerouilleSelected %> </option>
					<option value="<%= !procedure.isVerrouille() %>"> <%= sVerouilleNoSelected %> </option>
				</select>
			</td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">Commentaire : </td>
			<td class="pave_cellule_droite"><textarea name="sCommentaire" cols='100' rows='5' ><%=procedure.getCommentaire()%></textarea></td>
		</tr>
		<tr>
			<td  colspan="2">&nbsp;</td>
		</tr>
	</table>
	<br />
	<div align="center">
	<button type="submit" ><%= sTitle %></button>
	<button type="button" onclick="javascript:Redirect('<%=
		response.encodeRedirectURL("afficherToutesProcedures.jsp")
		%>')" >Annuler</button>
	</div>
</form>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>
</html>
