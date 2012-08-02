<%@ include file="../../../include/new_style/headerDesk.jspf" %>

<%@ page import="java.util.*" %>
<%@ page import="org.coin.fr.bean.PersonnePhysique"%>
<%@ page import="org.coin.bean.ObjectType"%>
<%@ page import="org.coin.bean.workflow.*"%>
<%
	Vector vItems = Folder.getAllStatic();
	String sPageUseCaseId = "xxx";

	// Le titre
	String sTitle = "Liste des dossiers : <span class=\"altColor\"> ";

	if(vItems.size() > 1){
		sTitle += vItems.size()+ " dossiers ";
	}
	else if(vItems.size() == 0) {
		sTitle += "Pas de dossier ";
	}
	else {
		sTitle += "1 dossier";
	}
	sTitle += " </span>";

	// Les boutons
	Vector<BarBouton> vBarBoutons = new Vector<BarBouton>();

	vBarBoutons.add(
			new BarBouton(0 ,
				 "Ajouter un dossier",
				 response.encodeURL(rootPath + "desk/workflow/document/modifyFolderForm.jsp?sAction=create"),
				 rootPath+"images/icons/group_add.gif",
				 "this.src='"+rootPath+"images/icons/group_add.gif'" ,
				 "this.src='"+rootPath+"images/icons/group_add.gif'" ,
				 "" ,
				 true) );

	

%>
</head>
<body>

<%@ include file="../../../include/new_style/headerFiche.jspf" %>
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
				<td width="5%">Id</td>
				<td width="20%">Nom</td>
				<td width="10%">Suivi par</td>
				<td width="10%">Date création</td>
				<td width="10%">Date modification</td>
				<td width="5%"></td>
			</tr>
<%
for (int i=0; i < vItems.size(); i++)
{
	Folder item = (Folder) vItems.get(i);

	String sOwner = "";
	if(item.getIdTypeObjectOwner() == ObjectType.PERSONNE_PHYSIQUE)
	{
		PersonnePhysique personne
			= PersonnePhysique.getPersonnePhysique(item.getIdRefenceObjectOwner());
		sOwner = personne.getPrenomNom();
	}


%>
		  	<tr class="liste<%=i%2%>"
		  	 	onmouseover="className='liste_over'"
		  	 	onmouseout="className='liste<%=i%2%>'"
		  	 	onclick="Redirect('<%=response.encodeRedirectURL(
		  	 			"modifyFolderForm.jsp?sAction=store&lIdWorkflowFolder="+item.getId())  %>')">
		    	<td><%=item.getId()    %></td>
		    	<td><%=item.getName() %></td>
		    	<td><%=sOwner %></td>
		    	<td><%=item.getDateCreation() %></td>
		    	<td><%=item.getDateModification() %></td>
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
<%@ include file="../../../include/new_style/footerFiche.jspf" %>
</body>
</html>
