<%@ include file="../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.*,java.util.*" %>
<%@page import="org.coin.bean.workflow.*"%>
<%
	Vector vItems = PathEvent.getAllStatic();
	String sPageUseCaseId = "xxx";

	// Le titre
	String sTitle = "Liste des evt : <span class=\"altColor\"> ";

	if(vItems.size() > 1){
		sTitle += vItems.size()+ " evts";
	}
	else if(vItems.size() == 0) {
		sTitle += "Pas evt";
	}
	else {
		sTitle += "1 evt";
	}
	sTitle += " </span>";

	// Les boutons
	Vector<BarBouton> vBarBoutons = new Vector<BarBouton>();

	vBarBoutons.add(
		new BarBouton(0 ,
			 "Ajouter un evt",
			 response.encodeURL(rootPath + "desk/workflow/modifyPathEventForm.jsp?sAction=create"),
			 rootPath+"images/icons/group_add.gif",
			 "this.src='"+rootPath+"images/icons/group_add.gif'" ,
			 "this.src='"+rootPath+"images/icons/group_add.gif'" ,
			 "" ,
			 true) );


	Vector vObjectType =  ObjectType.getAllStatic();

%>
</head>
<body>

<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
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
				<td width="10%">Workflow</td>
				<td width="10%">Id evt prev</td>
				<td width="10%">Objet type</td>
				<td width="10%">Objet ref</td>
				<td width="10%">Objet type cible</td>
				<td width="10%">Objet ref cible</td>
				<td width="20%"></td>
			</tr>
<%
for (int i=0; i < vItems.size(); i++)
{
	PathEvent item = (PathEvent ) vItems.get(i);

	String sTypeEvent = "";
	String sTypeTarget = "";
	String sReferenceObjectName = "";

	try {

		ObjectType typeEvent =
			(ObjectType) ObjectType
				.getCoinDatabaseAbstractBeanFromId (item.getIdTypeObjectEvent(), vObjectType);

		ObjectType typeTarget
			= (ObjectType) ObjectType
				.getCoinDatabaseAbstractBeanFromId (item.getIdTypeObjectTarget(), vObjectType);

		sTypeEvent = typeEvent.getName();
		sTypeTarget = typeTarget.getName();


		switch((int)item.getIdTypeObjectEvent())
		{
		case ObjectType.WORKFLOWDEFINITION_STATE :
			DefinitionState state = DefinitionState.getDefinitionState(item.getIdReferenceObjectEvent());
			sReferenceObjectName = state.getName();
			break;

		case ObjectType.WORKFLOWDEFINITION_TRANSITION :
			DefinitionTransition transition = DefinitionTransition.getDefinitionTransition(item.getIdReferenceObjectEvent());
			sReferenceObjectName = transition.getName();
			break;

		case ObjectType.WORKFLOWDEFINITION_TRANSITION_CONDITION :
			DefinitionTransitionCondition condition = DefinitionTransitionCondition.getDefinitionTransitionCondition(item.getIdReferenceObjectEvent());
			sReferenceObjectName = condition.getName();
			break;

		}


	} catch (Exception e){}

%>
		  	<tr class="liste<%=i%2%>"
		  	 	onmouseover="className='liste_over'"
		  	 	onmouseout="className='liste<%=i%2%>'"
		  	 	onclick="Redirect('<%=response.encodeRedirectURL(
		  	 			"modifyPathEventForm.jsp?sAction=store&lIdPathEvent="+item.getId())  %>')">
		    	<td><%=item.getId()    %></td>
		    	<td><%=item.getIdWorkflow()    %></td>
		    	<td><%=item.getIdPathEventPrevious()    %></td>
		    	<td><%= sTypeEvent  %></td>
		    	<td><%=sReferenceObjectName + " (" + item.getIdReferenceObjectEvent() + ")" %></td>
		    	<td><%= sTypeTarget    %></td>
		    	<td><%=item.getIdReferenceObjectTarget()    %></td>
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



</div>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>


</body>
<%@page import="modula.graphic.BarBouton"%>
</html>
