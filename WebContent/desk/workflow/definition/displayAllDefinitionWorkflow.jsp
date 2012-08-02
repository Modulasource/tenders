<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="java.util.*,modula.graphic.*" %>
<%@ page import="org.coin.bean.workflow.DefinitionWorkflow"%>
<%
	Vector vItems = DefinitionWorkflow.getAllStatic();
	String sPageUseCaseId = "xxx";

	// Le titre
	String sTitle = "Liste des groupes : <span class=\"altColor\"> ";

	if(vItems.size() > 1){
		sTitle += vItems.size()+ " workflows definition";
	}
	else if(vItems.size() == 0) {
		sTitle += "Pas de workflow definition";
	}
	else {
		sTitle += "1 workflow definition";
	}
	sTitle += " </span>";

	// Les boutons
	Vector<BarBouton> vBarBoutons = new Vector<BarBouton>();

	vBarBoutons.add(
		new BarBouton(0 ,
			 "Ajouter une definition de workflow",
			 response.encodeURL(rootPath + "desk/workflow/definition/modifyDefinitionWorkflowForm.jsp?sAction=create"),
			 rootPath+"images/icons/group_add.gif",
			 "this.src='"+rootPath+"images/icons/group_add.gif'" ,
			 "this.src='"+rootPath+"images/icons/group_add.gif'" ,
			 "" ,
			 true) );

%>
</head>
<body>
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<div style="padding:15px">
<div id="fiche">
<br />
	<!-- Les boutons -->
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
				<td width="40%">Name</td>
				<td width="30%">Description</td>
				<td width="20%"></td>
			</tr>
<%
for (int i=0; i < vItems.size(); i++)
{
	DefinitionWorkflow item = (DefinitionWorkflow) vItems.get(i);
%>
		  	<tr class="liste<%=i%2%>"
		  	 	onmouseover="className='liste_over'"
		  	 	onmouseout="className='liste<%=i%2%>'"
		  	 	onclick="Redirect('<%=response.encodeRedirectURL(
		  	 			"displayDefinitionWorkflow.jsp?lIdDefinitionWorkflow="+item.getId())  %>')">
		    	<td><%=item.getId()    %></td>
		    	<td><%=item.getName()    %></td>
		    	<td><%=item.getDescription()    %></td>
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
</html>
