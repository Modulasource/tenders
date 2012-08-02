<%@ include file="../../../include/new_style/headerDesk.jspf" %>

<%@ page import="java.util.*" %>
<%@ page import="org.coin.bean.ObjectType"%>
<%@ page import="org.coin.bean.workflow.*"%>
<%
	Vector vItems = Workflow.getAllStatic();
	String sPageUseCaseId = "xxx";
	
	// Le titre
	String sTitle = "Liste des workflows : <span class=\"altColor\"> ";

	if(vItems.size() > 1){
		sTitle += vItems.size()+ " workflows ";
	}
	else if(vItems.size() == 0) {
		sTitle += "Pas de workflow ";
	}
	else {
		sTitle += "1 workflow ";
	}
	sTitle += " </span>";

	// Les boutons
	Vector<BarBouton> vBarBoutons = new Vector<BarBouton>();

	vBarBoutons.add(
		new BarBouton(0 ,
			 "Ajouter un workflow",
			 response.encodeURL(rootPath + "desk/workflow/modifyWorkflowForm.jsp?sAction=create"),
			 rootPath+"images/icons/group_add.gif",
			 "this.src='"+rootPath+"images/icons/group_add.gif'" ,
			 "this.src='"+rootPath+"images/icons/group_add.gif'" ,
			 "" ,
			 true) );


	Vector vObjectType =  ObjectType.getAllStatic();
	Vector vWorkflows =  DefinitionWorkflow.getAllStatic();
	Vector vStates = DefinitionState.getAllStatic();

%>
</head>
<body>
<%@ include file="../../../include/new_style/headerFiche.jspf" %>
<div style="padding:15px">
<div id="fiche">
<br />

	<div class="sectionTitle"><div>Actions</div></div>
	<div class="sectionFrame">
	<table class="menu" cellspacing="2">
		<tr>
	<%= BarBouton.getAllButtonHtmlDesk(vBarBoutons) %>
			<td>&nbsp;</td>
		</tr>
	</table>
	</div>
	<br />


	<!-- La liste -->
	<div class="dataGridHolder fullWidth">
		<table class="dataGrid fullWidth">
			<tr class="header">
				<td width="10%">Id</td>
				<td width="10%">type objet</td>
				<td width="10%">ref objet</td>
				<td width="10%">WF init</td>
				<td width="10%">WF courant</td>
				<td width="10%">Etat courant</td>
				<td width="20%"></td>
			</tr>
<%
for (int i=0; i < vItems.size(); i++)
{
	Workflow item = (Workflow) vItems.get(i);

	String sTypeObjectName = "";
	String sWFInitialName = "";
	String sWFCurrentName = "";
	String sStateCurrentName = "";
	String sReferenceObjectName = "";

	try {

		ObjectType typeObject =
			(ObjectType) ObjectType
				.getCoinDatabaseAbstractBeanFromId (item.getIdTypeObject(), vObjectType);

		sTypeObjectName = typeObject.getName();

		DefinitionWorkflow wfInitial =
			(DefinitionWorkflow) DefinitionWorkflow
				.getCoinDatabaseAbstractBeanFromId (item.getIdDefinitionWorkflowInitial(), vWorkflows);

		sWFInitialName = wfInitial.getName();

		DefinitionWorkflow wfCurrent =
			(DefinitionWorkflow) DefinitionWorkflow
				.getCoinDatabaseAbstractBeanFromId (item.getIdDefinitionWorkflowCurrent(), vWorkflows);

		sWFCurrentName = wfCurrent.getName();


		DefinitionState stateCurrent =
			(DefinitionState) DefinitionState
				.getCoinDatabaseAbstractBeanFromId (item.getIdDefinitionStateCurrent(), vStates);

		sStateCurrentName = stateCurrent.getName() + " (" + stateCurrent.getId()  + ")";

		switch((int)item.getIdTypeObject())
		{
		case ObjectType.WORKFLOWDEFINITION_STATE :
			DefinitionState state = DefinitionState.getDefinitionState(item.getIdReferenceObject());
			sReferenceObjectName = state.getName();
			break;

		case ObjectType.WORKFLOWDEFINITION_TRANSITION :
			DefinitionTransition transition = DefinitionTransition.getDefinitionTransition(item.getIdReferenceObject());
			sReferenceObjectName = transition.getName();
			break;

		case ObjectType.WORKFLOWDEFINITION_TRANSITION_CONDITION :
			DefinitionTransitionCondition condition = DefinitionTransitionCondition.getDefinitionTransitionCondition(item.getIdReferenceObject());
			sReferenceObjectName = condition.getName();
			break;

		}

	} catch (Exception e){}



%>
		  	<tr class="liste<%=i%2%>"
		  	 	onmouseover="className='liste_over'"
		  	 	onmouseout="className='liste<%=i%2%>'"
		  	 	onclick="Redirect('<%=response.encodeRedirectURL(
		  	 			"displayWorkflow.jsp?lIdWorkflow="+item.getId())  %>')">
		    	<td><%=item.getId()    %></td>
		    	<td><%=sTypeObjectName   %></td>
		    	<td><%=sReferenceObjectName + "(" + item.getIdReferenceObject() + ")" %></td>
		    	<td><%=sWFInitialName %></td>
		    	<td><%=sWFCurrentName %></td>
		    	<td><%=sStateCurrentName %></td>
		    	<td></td>
		  	</tr>
<%
}
%>

		</table>
	</div>
	<br/>
	<div id="fiche_footer">
		&nbsp;
	</div>

</div>
<%@ include file="../../../include/new_style/footerFiche.jspf" %>
</body>
<%@page import="modula.graphic.BarBouton"%>
</html>
