<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="java.util.*,modula.algorithme.*,modula.algorithme.condition.*" %>
<%
	String sSelected ;
	String sTitle ;
	int iIdProcedure;
	iIdProcedure = Integer.parseInt( request.getParameter("iIdProcedure") );

	Procedure procedure = Procedure.getProcedure(iIdProcedure);
	String sSousEnsembleEtapesName ;
	String sSousEnsembleEtapesId ;
	
	Vector vPhaseTransitions = PhaseTransition.getAllPhaseTransitionOrdonnees(iIdProcedure);
	String sUseCaseIdBoutonAfficherPhaseTransition = "IHM-DESK";
	sTitle = "Définition de la procédure : " + procedure.getLibelle() ; 
	
%>
<script type="text/javascript">
function confirmSubmit(phrase){
	var agree=confirm("Etes vous sûr de vouloir "+phrase);
	if (agree)
		Redirect('<%= response.encodeURL("modifierProcedure.jsp?sAction=remove&iIdProcedure="+procedure.getId()) %>');
	else
		return false ;
}
</script>
</head>
<body>
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<br />
<%
for(int i=0 ; i<vPhaseTransitions.size() ; i++)
{
	PhaseTransition oPhasetransition =  (PhaseTransition) vPhaseTransitions.get(i);
	Vector vConditions = new Vector();
	try{vConditions = PhaseTransitionConditions.getAllConditionsForPhaseTransition(oPhasetransition.getId());}
	catch(CoinDatabaseLoadException e){
		e.printStackTrace();
	}
	PhaseProcedure oPhaseProcedureIn = null;
	try{oPhaseProcedureIn = PhaseProcedure.getPhaseProcedureMemory( oPhasetransition.getIdPhaseProcedureIn() );}
	catch(CoinDatabaseLoadException e){}
	PhaseProcedure oPhaseProcedureOut = null;
	try{oPhaseProcedureOut = PhaseProcedure.getPhaseProcedureMemory( oPhasetransition.getIdPhaseProcedureOut() );}
	catch(CoinDatabaseLoadException  e){}
	Vector<Etape> vEtapes = new Vector<Etape>();
	try{vEtapes = PhaseEtapes.getAllEtapesForPhaseProcedureMemory(oPhaseProcedureOut.getId());}
	catch(CoinDatabaseLoadException e){}
	Vector vPhaseEtapes = new Vector();
	try{vPhaseEtapes = PhaseEtapes.getAllForPhaseProcedureMemory(oPhaseProcedureOut.getId());}
	catch(CoinDatabaseLoadException  e){}

	if(i>0) { %>
<br />
<table class="pave" >
	<tr>
		<td  colspan="2">&nbsp;</td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">(<%= oPhasetransition.getId() %>) Conditions pour clôturer la phase : </td>
		<td class="pave_cellule_droite">
		<%
			for(int k=0;k<vConditions.size();k++)
			{
				Condition condition = (Condition)vConditions.get(k);
				out.write((k+1)+"/ "+condition.getName()+"<br />");
			}
		%>
		</td>
	    </tr>
		<tr>
			<td  colspan="2">&nbsp;</td>
		</tr>
</table>
<br />
<% } %>
<table class="pave" >
	<tr>
		<td colspan="2" class="pave_titre_gauche">Phase : <%= Phase.getPhaseNameMemory(oPhaseProcedureOut.getIdAlgoPhase() ) %></td>
	</tr>
	<tr>
		<td  colspan="2">&nbsp;</td>
	</tr>
		<%
		for (int j=0; j < vEtapes.size(); j++)
		{
			Etape etape = (Etape) vEtapes.get(j);
			PhaseEtapes oPhaseEtapes = null;
			try {
				oPhaseEtapes = (PhaseEtapes) vPhaseEtapes.get(j);
			}catch (Exception e)
			{
				oPhaseEtapes = new PhaseEtapes();
			}
		%>
	<tr>
		<td class="pave_cellule_gauche">(<%= oPhaseEtapes.getId()   %>) Etape <%= j+1 %>: </td>
		<td class="pave_cellule_droite">
			<a href="<%= response.encodeURL("afficherEtape.jsp?iIdEtape=" + etape.getId() ) %>" >
			<%= etape.getLibelle() %> (<%= etape.getIdUseCase()%>, <%= etape.getId() %>)
			</a>
		</td>
  	</tr>
		<% } %>
	<tr>
		<td  colspan="2">&nbsp;</td>
	</tr>
</table>
<%
}
%>
	<br />
	<button type="submit" onclick="javascript:Redirect('<%=
		response.encodeRedirectURL("modifierProcedureForm.jsp?iIdProcedure="+procedure.getId()) 
		%>')" >Modifier</button>
	<button type="button" 
		onclick="confirmSubmit('supprimer cette procédure ?')" >Supprimer</button>
	<button type="button" onclick="javascript:Redirect('<%=
		response.encodeRedirectURL("afficherToutesProcedures.jsp")
		%>')" >Retour</button>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>
<%@page import="org.coin.db.CoinDatabaseLoadException"%>
</html>
