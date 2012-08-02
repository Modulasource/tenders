<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="java.util.*,modula.algorithme.*,modula.algorithme.condition.*,modula.graphic.*" %>
<%
	String sTitle ;
	String sAction = "store";
	int iIdPhaseTransition;
	int iIdProcedure;
	
	String sFlecheGauche = rootPath + Icone.ICONE_GAUCHE;
	String sFlecheDroite = rootPath + Icone.ICONE_DROITE;
	
	iIdPhaseTransition = Integer.parseInt( request.getParameter("iIdPhaseTransition") );
	iIdProcedure = Integer.parseInt( request.getParameter("iIdProcedure") );
	sTitle = "Modifier les conditions de transition"; 
	
	PhaseTransition oPhaseTransition = PhaseTransition.getPhaseTransition(iIdPhaseTransition);	
	PhaseProcedure oPhaseProcedureIn = null;
	try{oPhaseProcedureIn = PhaseProcedure.getPhaseProcedure ( oPhaseTransition.getIdPhaseProcedureIn() );}
	catch(Exception e){}
	PhaseProcedure oPhaseProcedureOut = null;
	try{oPhaseProcedureOut = PhaseProcedure.getPhaseProcedure( oPhaseTransition.getIdPhaseProcedureOut() );}
	catch(Exception e){}
	Vector vConditions = new Vector();
	try{vConditions=  PhaseTransitionConditions.getAllConditionsForPhaseTransition(oPhaseTransition.getId());}
	catch(Exception e){
		e.printStackTrace();
	}
	Vector vConditionsAll = ConditionBean.getAllConditionBean();

%>
<script src="<%= rootPath %>include/bascule.js" type="text/javascript"></script>
</head>
<body>
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<br/>
<form name="formulaire" action="<%= response.encodeURL("modifierPhaseTransitionConditions.jsp")%>"  >
	<input type="hidden" name="iIdPhaseTransition" value="<%= iIdPhaseTransition %>" />
	<input type="hidden" name="iIdProcedure" value="<%= iIdProcedure %>" />
	<input type="hidden" name="sAction" value="<%=sAction %>" />
	<table class="pave" summary="none">
		<tr>
			<td class="pave_titre_gauche" colspan='2'>Conditions de Transition de <%= Phase.getPhaseName(oPhaseProcedureIn.getIdAlgoPhase()) %> à  <%= Phase.getPhaseName(oPhaseProcedureOut.getIdAlgoPhase()) %></td>
		</tr>
		<tr>
			<td  colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">
				<select name="iIdCondition" size="15" style="width:250px" multiple="multiple" >
<%

	for (int i=0; i < vConditionsAll.size(); i++)
	{
		ConditionBean condition = (ConditionBean) vConditionsAll.get(i);
		boolean bDisplayCondition = true;
		
		for (int j=0; j < vConditions.size(); j++)
		{
			Condition conditionTmp = (Condition) vConditions.get(j);
			if(condition.getId() == conditionTmp.getId())
			{
				bDisplayCondition = false;
			}
		}
		if(bDisplayCondition )
		{
			if(condition.getId() != 0) out.write("<option value='"+ condition.getId() +"'>" + condition.getName() + "</option>\n");
		}
		
	}
		  %>
                </select>
			</td >
		
		
			<td class="pave_cellule_droite">
				<table summary="none">
					<tr>
						<td style="width:100px;text-align:center">
						
						
						
						
			<table cols="2">
				<tr>
					<td style="width:50%">
					<a href="#" onclick="DeplacerTous(document.formulaire.iIdConditionSelection,document.formulaire.iIdCondition)">
						<img src="<%= sFlecheGauche %>"  />
					</a>
					</td>
					<td align="right">
					<a href="#" onclick="DeplacerTous(document.formulaire.iIdCondition,document.formulaire.iIdConditionSelection)">
						<img src="<%= sFlecheDroite %>"  />
					</a>
					</td>
				</tr>
			</table>
						
						
						
						</td>
						<td>
							<select name="iIdConditionSelection" size="15" style="width:250px" multiple="multiple" >
							<%
							
								for (int j=0; j < vConditions.size(); j++)
								{
									Condition condition = (Condition) vConditions.get(j);
									if(condition.getId() != 0) out.write("<option value='"+ condition.getId() +"'>" + condition.getName() + "</option>\n");
								}
									  %>
		                    </select>
							<input type="hidden" name="iIdConditionSelectionListe" >
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td  colspan="2">&nbsp;</td>
		</tr>
	</table>
	<br />
	<div align="center">
	<button type="submit"
		onclick="javascript:Visualise(document.formulaire.iIdConditionSelection,document.formulaire.iIdConditionSelectionListe);" 
		><%=sTitle %></button>
	<button type="button" onclick="javascript:Redirect('<%=
		response.encodeRedirectURL("modifierProcedureForm.jsp?iIdProcedure="+iIdProcedure) 
		%>')" >Annuler</button>
	</div>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>
</html>
