<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="java.util.*, modula.algorithme.*" %>
<% 
	String sTitle = "Transitions"; 
	int iIdProcedure;
	iIdProcedure = Integer.parseInt( request.getParameter("iIdProcedure") );
	
	Vector vPhaseTransitions = PhaseTransition.getAllPhaseTransitionOrdonnees(iIdProcedure );
%>
</head>
<body>
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
	<table class="pave" summary="none">
	<% 
	if(vPhaseTransitions.size() > 0)
	{
		for(int i=0;i<vPhaseTransitions.size();i++)
		{
			PhaseTransition pt = (PhaseTransition)vPhaseTransitions.get(i);
			PhaseProcedure ppIn = PhaseProcedure.getPhaseProcedure ( pt.getIdPhaseProcedureIn() );
			PhaseProcedure ppOut = PhaseProcedure.getPhaseProcedure( pt.getIdPhaseProcedureOut() );
		%>
		<tr>
			<td><%= pt.getId()%> (<%= pt.getIdPhaseProcedureIn()%>, <%= pt.getIdPhaseProcedureOut()%>)</td>
			<td>Transition de <b><%= Phase.getPhaseName( ppIn.getIdAlgoPhase() )  %> </b>à <b><%= Phase.getPhaseName( ppOut.getIdAlgoPhase() )  %></b></td>
		</tr>
		<%}}%>
	</table>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>
</html>
