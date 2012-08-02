<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="java.util.*,modula.algorithme.*" %>
<%
	String sSelected ;
	String sTitle = "Ajouter une phase";
	int iIdProcedure = Integer.parseInt( request.getParameter("iIdProcedure") );
	Vector vPhases = Phase.getAllPhase();
	Vector vPhaseTransition = PhaseTransition.getAllPhaseTransitionOrdonnees(iIdProcedure);
%>
</head>
<body>
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<form name="formulaire" action="<%= response.encodeURL("modifierPhaseProcedure.jsp?sAction=create")%>" method='post' >
	<input type="hidden" name="iIdProcedure" value="<%= iIdProcedure %>" />
	<table class="pave" >
		<tr>
			<td class="pave_titre_gauche" colspan="2" >Sélection de la phase à ajouter à la procédure</td>
		</tr>
		<tr>
			<td  colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">Phase : </td>
			<td class="pave_cellule_droite">
				<select name="iIdPhase" >
				<% for (int i = 0; i < vPhases.size(); i++) 
				{
					Phase phase = (Phase) vPhases.get(i);
				 %>
					<option value="<%= phase.getId() %>" ><%= phase.getName() %></option>
				<%}%>
				</select>
			</td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">Position : </td>
			<td class="pave_cellule_droite">
				<select name="iIdPhaseTransition">
				<option value="0" >En Premier</option>
				<% for (int i = 0; i < vPhaseTransition.size(); i++) 
				{
					PhaseTransition oPhaseTransition = (PhaseTransition)vPhaseTransition.get(i);
					PhaseProcedure oPhaseProcedure = PhaseProcedure.getPhaseProcedure(oPhaseTransition.getIdPhaseProcedureOut());
				 %>
					<option value="<%= oPhaseTransition.getId() %>" >Après <%= Phase.getPhaseName(oPhaseProcedure.getIdAlgoPhase()) %></option>
				<%}%>
				</select>
			</td>
		</tr>
		<tr>
			<td  colspan="2">&nbsp;</td>
		</tr>
	</table>
	<br />
	<div align="center">
	<button type="submit" ><%= sTitle %></button>
	<button type="button" onclick="javascript:Redirect('<%=
		response.encodeRedirectURL("modifierProcedureForm.jsp?iIdProcedure="+iIdProcedure) 
		%>')" >Annuler</button>
	</div>
</form>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>
</html>
