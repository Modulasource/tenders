<%@ include file="../../include/headerXML.jspf" %>

<%@ page import="org.coin.bean.workflow.*"%>
<%@ page import="java.util.Vector"%>
<%@ page import="org.coin.db.CoinDatabaseAbstractBeanHtmlUtil"%>
<%@ page import="org.coin.bean.ObjectType"%>
<%@ page import="org.coin.bean.workflow.DefinitionTransition"%>
<%@ include file="../include/beanSessionUser.jspf" %>
<%
	long lIdWorkflow ;
	String sIdUser ;
	String sSelected ;

	lIdWorkflow = Integer.parseInt( request.getParameter("lIdWorkflow") );
	Workflow item = Workflow.getWorkflow(lIdWorkflow );
	String sTitle = "Afficher un workflow";
	String rootPath = request.getContextPath()+"/";
	String sPageUseCaseId = "xxx";

	Vector vWorkflows =  DefinitionWorkflow.getAllStatic();
	Vector vStates = DefinitionState.getAllStatic();
	Vector vTransitions = DefinitionTransition.getAllFromIdDefinitionWorkflow(item.getId());
	Vector vObjectType =  ObjectType.getAllObjectType();
	Vector vItems = PathEvent.getAllFromIdWorkflow(item.getId());



	String sTypeObjectName = "";
	String sWFInitialName = "";
	String sWFCurrentName = "";
	String sStateCurrentName = "";

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

	} catch (Exception e){}



%>
<%@ include file="../include/checkHabilitationPage.jspf" %>
<%@ include file="../include/headerDesk.jspf" %>
</head>
<body>
<%@ include file="../../../include/new_style/headerFiche.jspf" %>
<div style="padding:15px">

	<div id="fiche">

	<!-- Pavé groupe -->
	<div class="sectionTitle"><div>Workflow</div></div>
	<div class="sectionFrame">
		<table class="formLayout" cellspacing="3">
			<tr>
				<td class="label" >Workflow initial :</td>
				<td class="frame">
			<%=	sWFInitialName %>
				</td>
			</tr>
			<tr>
				<td class="label" >Etat courant :</td>
				<td class="frame">
			<%=	sStateCurrentName %>
				</td>
			</tr>
			<tr>
				<td class="label" >Workflow courant :</td>
				<td class="frame">
			<%=	sWFCurrentName %>
				</td>
			</tr>
			<tr>
				<td class="label" >Type objet :</td>
				<td class="frame">
			<%=	sTypeObjectName %>
				</td>
			</tr>
			<tr>
				<td class="label" >Référence objet :</td>
				<td class="frame"><%= item.getIdReferenceObject()%></td>
			</tr>
		</table>
	</div>
	<br />




	<!-- La liste -->
	<div class="sectionTitle"><div>Les evts</div></div>
	<div class="dataGridHolder fullWidth">
		<table class="dataGrid fullWidth">
			<tr class="header">
				<td width="10%">Objet type</td>
				<td width="10%">Objet ref</td>
				<td width="10%">Objet type cible</td>
				<td width="10%">Objet ref cible</td>
				<td width="20%"></td>
			</tr>
<%
for (int i=0; i < vItems.size(); i++)
{
	PathEvent evt = (PathEvent ) vItems.get(i);

	String sTypeEvent = "";
	String sTypeTarget = "";
	String sReferenceObjectName = "";

	try {

		ObjectType typeEvent =
			(ObjectType) ObjectType
				.getCoinDatabaseAbstractBeanFromId (evt.getIdTypeObjectEvent(), vObjectType);

		ObjectType typeTarget
			= (ObjectType) ObjectType
				.getCoinDatabaseAbstractBeanFromId (evt.getIdTypeObjectTarget(), vObjectType);

		sTypeEvent = typeEvent.getName();
		sTypeTarget = typeTarget.getName();


		switch((int)evt.getIdTypeObjectEvent())
		{
		case ObjectType.WORKFLOWDEFINITION_STATE :
			DefinitionState state = DefinitionState.getDefinitionState(evt.getIdReferenceObjectEvent());
			sReferenceObjectName = state.getName();
			break;

		case ObjectType.WORKFLOWDEFINITION_TRANSITION :
			DefinitionTransition transition = DefinitionTransition.getDefinitionTransition(evt.getIdReferenceObjectEvent());
			sReferenceObjectName = transition.getName();
			break;

		case ObjectType.WORKFLOWDEFINITION_TRANSITION_CONDITION :
			DefinitionTransitionCondition condition = DefinitionTransitionCondition.getDefinitionTransitionCondition(evt.getIdReferenceObjectEvent());
			sReferenceObjectName = condition.getName();
			break;

		}


	} catch (Exception e){}

%>
		  	<tr class="liste<%=i%2%>"
		  	 	onmouseover="className='liste_over'"
		  	 	onmouseout="className='liste<%=i%2%>'"
		  	 	onclick="Redirect('<%=response.encodeRedirectURL(
		  	 			"modifyPathEventForm.jsp?sAction=store&lIdPathEvent="+evt.getId())  %>')">
		    	<td><%= sTypeEvent  %></td>
		    	<td><%=sReferenceObjectName + " (" + evt.getIdReferenceObjectEvent() + ")" %></td>
		    	<td><%= sTypeTarget    %></td>
		    	<td><%=evt.getIdReferenceObjectTarget()    %></td>
		    	<td></td>
		  	</tr>
<%
}

%>

		</table>
	</div>




	<!-- Boutons -->
	<div id="fiche_footer">
		<button type="button" onclick="javascript:Redirect('<%=
			response.encodeRedirectURL("modifyWorkflowForm.jsp?sAction=store&amp;lIdWorkflow="
			+item.getId()) %>')" >Modifier</button>
		<button type="button" value="" onclick="javascript:Redirect('<%=
			response.encodeRedirectURL("modifyWorkflow.jsp?sAction=remove&amp;lIdWorkflow="
			+ item.getId()) %>')" >Supprimer</button>
		<button type="button" value="" onclick="javascript:Redirect('<%=
			response.encodeRedirectURL("displayAllWorkflow.jsp")%>')" >Retour</button>
	</div>

</div> <!-- end fiche -->
</div>
<%@ include file="../../../include/new_style/footerFiche.jspf" %>

</body>
</html>
