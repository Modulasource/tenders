<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="modula.graphic.*,modula.marche.*,modula.algorithme.*,modula.algorithme.condition.*" %>
<%@page import="org.coin.autoform.component.AutoFormCptBlock"%>
<%@page import="org.coin.autoform.component.AutoFormCptInputRadioSet"%>
<%@ include file="/desk/include/useBoamp17.jspf" %>
<%

	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);

	String sTitle = "Suivi de l'affaire"; 
	
	int iIdAlgoProcedure = AffaireProcedure.getAffaireProcedureMemory(marche.getIdAlgoAffaireProcedure()).getIdProcedure();
	Procedure oProcedure2 = Procedure.getProcedureMemory(iIdAlgoProcedure);
	int iIdPhaseEtapes = marche.getIdAlgoPhaseEtapes();
	PhaseEtapes oPhaseEtapesCourante = PhaseEtapes.getPhaseEtapesMemory(iIdPhaseEtapes);
	long iIdEtapeCourante = oPhaseEtapesCourante.getIdAlgoEtape();
	long iIdPhaseCourante = PhaseProcedure.getPhaseProcedureMemory(oPhaseEtapesCourante.getIdAlgoPhaseProcedure()).getIdAlgoPhase();
	String sSousEnsembleEtapesName ;
	String sSousEnsembleEtapesId ;

	AutoFormCptBlock afBlockPub = null;
	AutoFormCptInputRadioSet afTypePublication = null;
	AutoFormCptBlock afBlockTypeAvis = null;
	AutoFormCptSelect afProcedureSimpleEnveloppe = null;

	MarcheProcedure marProc = new MarcheProcedure();
	
	try	{
		marProc = MarcheProcedure.getFromMarche(marche.getIdMarche());
	} catch (Exception e) {}
	
	if(marProc == null)
		marProc = new MarcheProcedure();

	Vector vPhaseTransitions = PhaseTransition.getAllPhaseTransitionOrdonnees(oProcedure2.getId());
	String sUseCaseIdBoutonAfficherPhaseTransition = "IHM-DESK";
	String sPaveProcedureTitre = "Procédure";
	
%>
</head>
<body>
<%
String sHeadTitre = "Suivi de l'affaire";
boolean bAfficherPoursuivreProcedure = false;
%>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<%@ include file="/include/new_style/headerAffaireOnlyButtonDisplayAffaire.jspf" %>
<br />
<div style="padding:15px">
<%@ include file="pave/paveProcedure.jspf" %>
<br />
<% if(sessionUserHabilitation.isSuperUser())
{%>

<div style="text-align:center;">
<form action="<%=response.encodeURL("poursuivreProcedure.jsp")%>" method="post"  name="choixEtape">
	[Fonction Super Admin] Attention, se déplacer dans l'algorithme peut engendrer des 
	anomalies irréversibles sur l'affaire !<br/>
	<input type="hidden" name="sAction" value="select" />
	<input type="hidden" name="iIdAffaire" id="iIdAffaire" value="<%=iIdAffaire%>" />

	<select name="iIdPhaseEtapes">
	<option value="0" selected="selected">Choix de l'etape</option>
	<%
		Vector vPhaseEtapes = PhaseEtapes.getAllForProcedure(iIdAlgoProcedure);
		for(int i=0;i<vPhaseEtapes.size();i++)
		{
			Vector vPhaseEtapes2 = (Vector)vPhaseEtapes.get(i);
			for(int j=0;j<vPhaseEtapes2.size();j++)
			{
				PhaseEtapes oPhaseEtapes2 = (PhaseEtapes)vPhaseEtapes2.get(j);
				%>
				<option value="<%= oPhaseEtapes2.getId()%>"><%= 
					Etape.getEtapeNameMemory(oPhaseEtapes2.getIdAlgoEtape())%></option>
				<%
			}
		}
	%>
	</select>
	<input type="submit" name="submit" value="Aller à l'etape" style="vertical-align:middle"/>
</div><br />
	<%
}

	String sImageSucces = "<img src='" + rootPath + "images/icons/flag_green.gif' >";
	String sImageInCreation = "<img src='" + rootPath + "images/icons/flag_red.gif'>";
	String sImageCourante = sImageSucces ;
	boolean bEtapeASuivre = true;
	boolean bEtapeCreation = true;
	for(int i=0 ; i<vPhaseTransitions.size() ; i++)
	{
		PhaseTransition oPhasetransition =  (PhaseTransition) vPhaseTransitions.get(i);
		Vector vConditions = new Vector();
		try{vConditions = PhaseTransitionConditions.getAllConditionsForPhaseTransition(oPhasetransition.getId());}
		catch(Exception e){}
		PhaseProcedure oPhaseProcedureIn = null;
		try{oPhaseProcedureIn = PhaseProcedure.getPhaseProcedureMemory(oPhasetransition.getIdPhaseProcedureIn() );}
		catch(Exception e){}
		PhaseProcedure oPhaseProcedureOut = null;
		try{oPhaseProcedureOut = PhaseProcedure.getPhaseProcedureMemory( oPhasetransition.getIdPhaseProcedureOut() );}
		catch(Exception e){}
		Vector vEtapes = new Vector();
		try{vEtapes = PhaseEtapes.getAllEtapesForPhaseProcedureMemory(oPhaseProcedureOut.getId());}
		catch(Exception e){}
		
	%>

<% if(i>0) { %>
<!-- Affichage des conditions de transition -->
<table class="pave"  >
	<tr>
		<td class="pave_cellule_droite" colspan='2'><b>Conditions pour clotûrer la phase: </b></td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">&nbsp;</td>
		<td class="pave_cellule_droite">
		<%
			for(int k=0;k<vConditions.size();k++)
			{
				Condition condition = (Condition)vConditions.get(k);
				if(condition.getId() != 0) out.write(condition.getName()+"<br />");
			}
		%>
		</td>
	  </tr>
</table>
<br />
<!-- /Affichage des conditions de transition -->
<% } %>
<!-- Affichage de la phase et de ses étapes -->
<table class="pave" >
	<tr>
		<td colspan="2" class="pave_titre_gauche">Phase : <%= 
			Phase.getPhaseNameMemory(oPhaseProcedureOut.getIdAlgoPhase()) %></td>
	</tr>
	<tr>
		<td class="pave_cellule_droite" colspan='2' ><b>Liste des étapes: </b></td>
	</tr>
		<%
		
	
		for (int j=0; j < vEtapes.size(); j++)
		{
			String sTdEtapeStatut = "<td class='pave_cellule_gauche' style='vertical-align:top'>";
			String sTdEtapeLibelle = "<td class='pave_cellule_droite' style='vertical-align:top'>";
			Etape etape = (Etape) vEtapes.get(j);
		%>
		<tr>
			<%
			// spécificique à l'étape de création
			
			if(oPhaseProcedureOut.getIdAlgoPhase() == Phase.PHASE_CREATION && bEtapeCreation)
			{
				try 
				{
					if( marche.isOngletInstancie( j ) )
					{
						sImageCourante = sImageSucces ;
					}	
					else
					{
						sImageCourante = sImageInCreation ;
					}
					
				} 
				catch (Exception e) {}
				
				if(etape.getId() == Etape.PREMIERE_ETAPE_AAPC)
				{
					bEtapeCreation = false;
					sImageCourante = sImageSucces;
				}
			}
				
			
			
			sTdEtapeLibelle += etape.getLibelle() + "</td>";
			
			if(etape.getId() == iIdEtapeCourante)
			{
				sTdEtapeStatut += sImageInCreation + "</td>";
				sImageCourante = "";
			}
			else
			{
				if(bEtapeASuivre && sImageCourante.equals(""))
				{
					bEtapeASuivre = false;
					sTdEtapeStatut += "Prochaine Etape</td>";
				}
				else
				{	
					sTdEtapeStatut += sImageCourante + "</td>";
				}
			}
			%>
			<%= sTdEtapeStatut %>
			<%= sTdEtapeLibelle %>
	  	</tr>
		<% } %>
</table>
	  <!-- /Affichage de la phase et de ses étapes -->
<%
}
%>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>