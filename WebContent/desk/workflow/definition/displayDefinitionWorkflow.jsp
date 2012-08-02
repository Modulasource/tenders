<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.workflow.*"%>
<%@ page import="java.util.Vector"%>
<%
	long lIdDefinitionWorkflow ;
	String sIdUser ;
	String sSelected ;

	lIdDefinitionWorkflow = Integer.parseInt( request.getParameter("lIdDefinitionWorkflow") );
	DefinitionWorkflow item = DefinitionWorkflow.getDefinitionWorkflow(lIdDefinitionWorkflow );
	String sTitle = "Afficher une définition de workflow";
	String sPageUseCaseId = "xxx";

	Vector vStates = DefinitionState.getAllFromIdDefinitionWorkflow(item.getId());
	Vector vTransitions = DefinitionTransition.getAllFromIdDefinitionWorkflow(item.getId());


%>

</head>
<body>
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<div style="padding:15px">

	<div id="fiche">

	<!-- Pavé groupe -->
	<div class="sectionTitle"><div>Définition de workflow</div></div>
	<div class="sectionFrame">
		<table class="formLayout" cellspacing="3">
			<tr>
				<td class="label" >Nom :</td>
				<td class="frame"><%= item.getName()%></td>
			</tr>
			<tr>
				<td class="label" >Description :</td>
				<td class="frame"><%= item.getDescription()%></td>
			</tr>
		</table>
	</div>
	<br />


	<div class="sectionTitle"><div>Les états</div></div>
	<br/>
	<br/>
	<!-- La liste des états -->
	<div class="dataGridHolder fullWidth">
		<table class="dataGrid fullWidth">
			<tr class="header">
				<td width="10%">Id</td>
				<td width="20%">Type</td>
				<td width="20%">Name</td>
				<td width="10%">Pos X</td>
				<td width="10%">Pos Y</td>
				<td width="20%">Creation</td>
				<td width="10%"><a href="<%=
					response.encodeRedirectURL(
		  	 			"modifyDefinitionState.jsp?sAction=createFromDefinitionWorkflow"
		  	 			+"&lIdDefinitionWorkflow=" + item.getId() )
		  	 			%>" >Add</a>
				</td>
			</tr>
<%
for (int i=0; i < vStates.size(); i++)
{
	DefinitionState state = (DefinitionState ) vStates.get(i);
	DefinitionStateType stateType = DefinitionStateType.getDefinitionStateTypeMemory( state.getIdDefinitionStateType() );

%>
		  	<tr class="liste<%=i%2%>"
		  	 	onmouseover="className='liste_over'"
		  	 	onmouseout="className='liste<%=i%2%>'"
		  	 	onclick="Redirect('<%=response.encodeRedirectURL(
		  	 			"modifyDefinitionStateForm.jsp?sAction=store&lIdDefinitionState="+state.getId())  %>')">
		    	<td><%=state.getId()    %></td>
		    	<td><%=stateType.getName()    %></td>
		    	<td><%=state.getName()    %></td>
		    	<td><%=state.getPosX()    %></td>
		    	<td><%=state.getPosY()    %></td>
		    	<td><%=state.getDateCreation()    %></td>
		    	<td>
		    	</td>
		  	</tr>
<%
}
%>

		</table>
	</div>

	<br/>
	<div class="sectionTitle"><div>Les transitions</div></div>
	<br/>
	<br/>

	<!-- La liste des transitions -->
	<div class="dataGridHolder">
		<table class="dataGrid fullWidth">
			<tr class="header">
				<td width="10%">Id</td>
				<td width="20%">Name</td>
				<td width="10%">Type</td>
				<td width="10%">State initial</td>
				<td width="10%">State final</td>
				<td width="10%">Pos X</td>
				<td width="10%">Pos Y</td>
				<td width="20%">Creation</td>
				<td width="10%"><a href="<%=
					response.encodeRedirectURL(
		  	 			"modifyDefinitionTransitionForm.jsp?sAction=create"
		  	 			+"&lIdDefinitionWorkflow=" + item.getId() )
		  	 			%>" >Add</a>
				</td>
			</tr>
<%
for (int i=0; i < vTransitions.size(); i++)
{
	DefinitionTransition transition = (DefinitionTransition) vTransitions.get(i);
	DefinitionState stateInitial
		= (DefinitionState) DefinitionState
			.getCoinDatabaseAbstractBeanFromId(
					transition.getIdDefinitionStateInitial(), vStates);

	DefinitionState stateFinal
		= (DefinitionState) DefinitionState
			.getCoinDatabaseAbstractBeanFromId(
				transition.getIdDefinitionStateFinal(), vStates);

	DefinitionTransitionType transitionType;

	try {
		transitionType = DefinitionTransitionType.getDefinitionTransitionTypeMemory(transition.getIdDefinitionTransitionType());
	} catch (Exception e) {
		transitionType  = new DefinitionTransitionType();
		transitionType.setName("???");
	}

%>
		  	<tr class="liste<%=i%2%>"
		  	 	onmouseover="className='liste_over'"
		  	 	onmouseout="className='liste<%=i%2%>'"
		  	 	onclick="Redirect('<%=response.encodeRedirectURL(
		  	 			"displayDefinitionTransition.jsp?lIdDefinitionTransition="+transition.getId())  %>')">
		    	<td><%=transition.getId()    %></td>
		    	<td><%=transition.getName()    %></td>
		    	<td><%=transitionType.getName() %></td>
		    	<td><%=stateInitial.getName() %> (<%= stateInitial.getId() %>)</td>
		    	<td><%=stateFinal.getName() %> (<%= stateFinal.getId() %>)</td>
		    	<td><%=transition.getPosX()    %></td>
		    	<td><%=transition.getPosY()    %></td>
		    	<td><%=transition.getDateCreation()    %></td>
		    	<td>
		    	</td>
		  	</tr>
<%
}
%>

		</table>
	</div>


	<!-- Boutons -->
	<div id="fiche_footer">
		<button type="button" onclick="javascript:Redirect('<%=
			response.encodeRedirectURL("modifyDefinitionWorkflowForm.jsp?sAction=store&amp;lIdDefinitionWorkflow="
			+item.getId()) %>')" >Modifier</button>
		<button type="button" onclick="javascript:Redirect('<%=
			response.encodeRedirectURL("modifyDefinitionWorkflow.jsp?sAction=remove&amp;lIdDefinitionWorkflow="
			+ item.getId()) %>')" >Supprimer</button>
		<button type="button" onclick="javascript:Redirect('<%=
			response.encodeRedirectURL("designDefinitionWorkflow.jsp?lIdDefinitionWorkflow="
			+ item.getId()) %>')" >Voir diagramme</button>
		<button type="button"  onclick="javascript:Redirect('<%=
			response.encodeRedirectURL("displayAllDefinitionWorkflow.jsp")%>')" >Retour</button>
	</div>

</div> <!-- end fiche -->
</div>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>

</body>
</html>
