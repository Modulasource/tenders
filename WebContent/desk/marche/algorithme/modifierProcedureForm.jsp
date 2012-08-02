<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="java.util.*,modula.algorithme.*,modula.algorithme.condition.*" %>
<%
	String sSelected ;
	String sTitle ;
	int iIdProcedure;
	
	iIdProcedure = Integer.parseInt( request.getParameter("iIdProcedure") );
	Procedure procedure = Procedure.getProcedure(iIdProcedure);
	sTitle = "Modifier la procédure :" + procedure.getLibelle() ; 

	String sSousEnsembleEtapesName ;
	String sSousEnsembleEtapesId ;
	
	Vector<PhaseTransition> vPhaseTransitions = PhaseTransition.getAllPhaseTransitionOrdonnees(iIdProcedure);
	String sUseCaseIdBoutonAfficherPhaseTransition = "IHM-DESK";  
	
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
<table class="menu" cellspacing="2" >
	<tr>
		<th>
			<button onclick="javascript:Redirect('<%= 
				response.encodeURL("modifierProcedureInfosForm.jsp?sAction=store&amp;iIdProcedure="
				+procedure.getId()) %>');" >Modifier les infos</button>
		</th>
		<th>
			<button onclick="javascript:Redirect('<%= 
				response.encodeURL("ajouterPhaseProcedureForm.jsp?iIdProcedure="+procedure.getId()) 
				%>');" >Ajouter phase</button>
		</th>
		<td>&nbsp;</td>
	</tr>
</table>

<br />

<%
for(int i=0 ; i<vPhaseTransitions.size() ; i++)
{
	PhaseTransition oPhasetransition = vPhaseTransitions.get(i);
	Vector vConditions = new Vector();
	try{vConditions = PhaseTransitionConditions.getAllConditionsForPhaseTransition(oPhasetransition.getId());}
	catch(Exception e){
		e.printStackTrace();
	}
	PhaseProcedure oPhaseProcedureIn = null;
	try{oPhaseProcedureIn = PhaseProcedure.getPhaseProcedureMemory ( oPhasetransition.getIdPhaseProcedureIn() );}
	catch(Exception e){}
	PhaseProcedure oPhaseProcedureOut = null;
	try{oPhaseProcedureOut = PhaseProcedure.getPhaseProcedureMemory( oPhasetransition.getIdPhaseProcedureOut() );}
	catch(Exception e){}
	Vector vEtapes = new Vector();
	try{vEtapes = PhaseEtapes.getAllEtapesForPhaseProcedureMemory(oPhaseProcedureOut.getId());}
	catch(Exception e){}
%>
<% 
if(i>0) 
{ 
%>

<table class="pave" summary="none">
	<tr>
		<td class="pave_titre_gauche">Conditions de Transition de <%= Phase.getPhaseName(oPhaseProcedureIn.getIdAlgoPhase()) %> à  <%= Phase.getPhaseName(oPhaseProcedureOut.getIdAlgoPhase()) %></td>
		<%
		if(vConditions.size() > 1)
		{
		%>
		<td class="pave_titre_droite"><%= vConditions.size() %> Conditions</td>
		<%
		}
		else 
		{
			if(vConditions.size() == 0) 
			{
			%>
			<td class="pave_titre_droite">Aucune condition définie</td>
			<%
			}
			else 
			{
				if(((Condition)vConditions.firstElement()).getId() != 0) 
				{
				%>
				<td class="pave_titre_droite">1 condition</td>
				<%
				}
				else 
				{
				%>
				<td class="pave_titre_droite">Aucune condition définie</td>
				<%
				}
			}
		}
		%>
	</tr>
	<tr>
		<td colspan="2">
			<table class="liste" summary="none">
				<tr class="liste1" onmouseover="className='liste_over'" 
	  			onmouseout="className='liste1'" 
	  			onclick="Redirect('<%=response.encodeRedirectURL("modifierPhaseTransitionConditionsForm.jsp?iIdProcedure="+iIdProcedure+"&amp;iIdPhaseTransition="+oPhasetransition.getId()) %>')">
		    		<td width="80%">
		    		<%
						for(int k=0;k<vConditions.size();k++)
		    			{
		    				Condition condition = (Condition)vConditions.get(k);
							out.write((k+1)+"/ "+condition.getName()+"<br />");
		    			}
		    		%>
		    		<br /></td>
		    		<td style="text-align:right;width:20%"><a href="#">
						<img src="<%=rootPath+modula.graphic.Icone.ICONE_FICHIER_DEFAULT %>" width="21" height="21"  alt="Afficher" title="Afficher"/>
		    		</a>
		    		</td>
	  			</tr>
			</table>
		</td>
	</tr>
</table>
<br />

<% } %>
<table class="pave" summary="none">
	<tr>
		<td class="pave_titre_gauche">Phase : <%= Phase.getPhaseName (oPhaseProcedureOut.getIdAlgoPhase() ) %></td>
		<%
			if(vEtapes.size() > 1){
		%>
		<td class="pave_titre_droite"><%= vEtapes.size() %> Etapes</td>
		<%
		}
		else {
		if(vEtapes.size() == 0) {
		%>
		<td class="pave_titre_droite">Aucune étape définie</td>
		<%
		}
		else {
		%>
		<td class="pave_titre_droite">1 étape</td>
		<%
		}
		}
		%>
	</tr>
	<tr>
		<td colspan="2">
			<table class="liste" summary="none">
				<tr>
					<th>Libelle</th>
					<th>Etapes</th>
					<th>&nbsp;</th>
				</tr>
				<tr class="liste0" onmouseover="className='liste_over'" 
				  		onmouseout="className='liste0'" 
				  		onclick="Redirect('<%=response.encodeRedirectURL("modifierPhaseProcedureForm.jsp?iIdPhaseProcedure="+oPhaseProcedureOut.getId())%>')">
				    <td style="width:30%"><%= Phase.getPhaseName (oPhaseProcedureOut.getIdAlgoPhase() ) %></td>
					<td style="width:50%">
					<%
					for (int j=0; j < vEtapes.size(); j++)
					{
						Etape etape = (Etape) vEtapes.get(j);
					%>
					<%= etape.getLibelle() %>(<%= etape.getIdUseCase()%>)<br />
					<% } %>
					</td>
				    <td style="text-align:right;width:20%"><a href="<%= response.encodeURL("modifierPhaseProcedureForm.jsp?iIdPhaseProcedure="+oPhaseProcedureOut.getId()) %>" >
						<img src="<%=rootPath+modula.graphic.Icone.ICONE_FICHIER_DEFAULT %>" width="21" height="21"  alt="Afficher" title="Afficher"/>
				    </a>
				    </td>
				  </tr>
			</table>
		</td>
	</tr>
</table>
<br />
<%
}
%>
<form>
<button type="button" onclick="javascript:Redirect('<%=
	response.encodeRedirectURL("afficherToutesProcedures.jsp")
	%>')" >Retour</button>
</form>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>
</html>
