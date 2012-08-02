<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.db.CoinDatabaseAbstractBeanHtmlUtil"%>
<%@ page import="org.coin.bean.*,java.util.*" %>
<%@ page import="org.coin.bean.workflow.*"%>
<%@ page import="org.coin.fr.bean.*"%>
<%@ page import="org.coin.bean.organigram.*"%>
<%@ page import="org.coin.db.CoinDatabaseLoadException"%>
<%
	long lIdDefinitionWorkflow;
	long lIdDefinitionTransition;
	String sAction;
	String sTitle ;
	DefinitionTransition item;
	DefinitionTransitionType type;

	lIdDefinitionTransition = Integer.parseInt( request.getParameter("lIdDefinitionTransition") );
	sTitle = "Modifier une definition de transition";
	item = DefinitionTransition.getDefinitionTransition(lIdDefinitionTransition);

	Vector vStates = DefinitionState.getAllFromIdDefinitionWorkflow(item.getIdDefinitionWorkflow());

	DefinitionState stateInitial
		= (DefinitionState) DefinitionState
			.getCoinDatabaseAbstractBeanFromId(
				item.getIdDefinitionStateInitial(), vStates);

	DefinitionState stateFinal
		= (DefinitionState) DefinitionState
			.getCoinDatabaseAbstractBeanFromId(
					item.getIdDefinitionStateFinal(), vStates);

	try {
		type = DefinitionTransitionType.getDefinitionTransitionTypeMemory(item.getIdDefinitionTransitionType());
	} catch (Exception e) {
		type = DefinitionTransitionType.getDefinitionTransitionTypeMemory(DefinitionTransitionType.TYPE_NORMAL);
	}


	Vector vConditions
		= DefinitionTransitionCondition.getAllFromIdDefinitionTransition(item.getId());


%>
<script type="text/javascript" src="<%= rootPath %>include/bascule.js" ></script>
</head>
<body>
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<div style="padding:15px">

<form name="nonce" action="nonce" method="post" >
	<div id="fiche">

	<div class="sectionTitle"><div>Définition de la transition <%= item.getId() %></div></div>
	<div class="sectionFrame">
		<table class="formLayout" cellspacing="3">
			<tr>
				<td class="label" >Nom :</td>
				<td class="frame"><%= item.getName() %></td>
			</tr>
			<tr>
				<td class="label" >Decription :</td>
				<td class="frame"><%= item.getDescription() %></td>
			</tr>
			<tr>
				<td class="label" >Type :</td>
				<td class="frame"><%= type.getName() %></td>
			</tr>
			<tr>
				<td class="label" >Etat inial :</td>
				<td class="frame"><%=stateInitial.getName() %> (<%= stateInitial.getId() %>)</td>
			</tr>
			<tr>
				<td class="label" >Etat final :</td>
				<td class="frame"><%=stateFinal.getName() %> (<%= stateFinal.getId() %>)</td>
			</tr>


			<tr>
				<td class="label" >Pos X :</td>
				<td class="frame"><%= item.getPosX()%></td>
			</tr>
			<tr>
				<td class="label" >Pos Y :</td>
				<td class="frame"><%= item.getPosY()%></td>
			</tr>
			<tr>
				<td class="label" >Pos height :</td>
				<td class="frame"><%= item.getPosHeight()%></td>
			</tr>
			<tr>
				<td class="label" >Pos width :</td>
				<td class="frame"><%= item.getPosWidth()%></td>
			</tr>
		</table>
	</div>
	<br />


	<br/>
	<div class="sectionTitle"><div>Les conditions de transition</div></div>
	<br/>
	<br/>

	<!-- La liste des conditions de transition -->
	<div class="dataGridHolder fullWidth">
		<table class="dataGrid fullWidth">
			<tr class="header">
				<td width="5%">Id</td>
				<td width="15%">Name</td>
				<td width="15%">Type Obj</td>
				<td width="30%">Ref</td>
				<td width="15%">Creation</td>
				<td width="10%"><a href="<%=
					response.encodeRedirectURL(
		  	 			"modifyDefinitionTransitionConditionForm.jsp?sAction=create"
		  	 			+"&lIdDefinitionTransition=" + item.getId() )
		  	 			%>" >Add</a>
				</td>
			</tr>
<%
for (int i=0; i < vConditions.size(); i++)
{
	DefinitionTransitionCondition condition = (DefinitionTransitionCondition) vConditions.get(i);
	ObjectType obtype = null;
	try{
		obtype = ObjectType.getObjectTypeMemory(condition.getIdTypeObject() );
	} catch (Exception e) {
		obtype = new ObjectType();
	}

	String sReferenceObjectName = "" + condition.getIdReferenceObject();

	if(condition.getIdTypeObject() == ObjectType.ORGANIGRAM_NODE)
	{
		try {
			OrganigramNode node2
				= OrganigramNode
				.getOrganigramNode(condition.getIdReferenceObject());


		if(node2.getIdTypeObject() != ObjectType.PERSONNE_PHYSIQUE)
		{
			throw new CoinDatabaseLoadException(
					"node2.getIdTypeObject() != ObjectType.PERSONNE_PHYSIQUE : pour " + node2.getId(), "");
		}
		PersonnePhysique personne = PersonnePhysique.getPersonnePhysique(node2.getIdReferenceObject());
		sReferenceObjectName = node2.getName() + " : "  + personne.getPrenomNom();

		}catch (Exception e) {}
	}

%>
		  	<tr class="liste<%=i%2%>"
		  	 	onmouseover="className='liste_over'"
		  	 	onmouseout="className='liste<%=i%2%>'"
		  	 	onclick="Redirect('<%=response.encodeRedirectURL(
		  	 			"modifyDefinitionTransitionConditionForm.jsp?sAction=store&lIdDefinitionTransitionCondition="
		  	 					+condition.getId())  %>')">
		    	<td><%=condition.getId()    %></td>
		    	<td><%=condition.getName()    %></td>
		    	<td><%=obtype.getName()    %></td>
		    	<td><%=sReferenceObjectName     %></td>
		    	<td><%=condition.getDateCreation()    %></td>
		    	<td>

		    	<a href="<%=
					response.encodeRedirectURL(
		  	 			"modifyDefinitionTransitionCondition.jsp?sAction=copy"
		  	 			+"&lIdDefinitionTransitionCondition=" + condition.getId() )
		  	 			%>" >Copy</a>
		    	</td>
		  	</tr>
<%
}
%>

		</table>
	</div>




	<div class="sectionFrame">

		<!-- Les boutons -->
		<div id="fiche_footer">
			<button type="button" onclick="javascript:Redirect('<%=
				response.encodeRedirectURL(
						"modifyDefinitionTransitionForm.jsp?sAction=store&lIdDefinitionTransition="
						+ item.getId() )
				%>')" >Modifier</button>
			<button type="button" onclick="javascript:Redirect('<%=
				response.encodeRedirectURL(
						"displayDefinitionWorkflow.jsp?lIdDefinitionWorkflow="
						+ item.getIdDefinitionWorkflow() )
				%>')" >Retour</button>
		</div>
	</div>
</div>

</div>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</form>
</body>
</html>