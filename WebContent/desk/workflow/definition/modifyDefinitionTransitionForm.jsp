<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.db.CoinDatabaseAbstractBeanHtmlUtil"%>
<%@ page import="org.coin.bean.*,java.util.*" %>
<%@page import="org.coin.bean.workflow.*"%>
<%
	long lIdDefinitionWorkflow;
	long lIdDefinitionTransition;
	String sAction;
	String sTitle ;
	DefinitionTransition item;
	DefinitionTransitionType type;

	sAction = request.getParameter("sAction") ;

	if(sAction.equals("store"))
	{
		lIdDefinitionTransition = Integer.parseInt( request.getParameter("lIdDefinitionTransition") );
		sTitle = "Modifier une definition de transition";
		item = DefinitionTransition.getDefinitionTransition(lIdDefinitionTransition);
		try {
			type = DefinitionTransitionType.getDefinitionTransitionType(item.getIdDefinitionTransitionType());
		} catch (Exception e) {
			type = new DefinitionTransitionType(DefinitionTransitionType.TYPE_NORMAL);
		}
	}
	else
	{
		lIdDefinitionWorkflow = Integer.parseInt( request.getParameter("lIdDefinitionWorkflow") );
		lIdDefinitionTransition = -1;
		sTitle = "Ajouter une definition de transition";
		item = new DefinitionTransition ();
		item.setIdDefinitionWorkflow(lIdDefinitionWorkflow);
		item.setPosHeight(80);
		item.setPosWidth(80);
		type = new DefinitionTransitionType(DefinitionTransitionType.TYPE_NORMAL);
	}

	Vector vStates = DefinitionState.getAllFromIdDefinitionWorkflow(item.getIdDefinitionWorkflow());

%>
<script type="text/javascript" src="<%= rootPath %>include/bascule.js" ></script>
</head>
<body>



<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<div style="padding:15px">

<form name="formulaire" action="<%= response.encodeRedirectURL("modifyDefinitionTransition.jsp") %>" method="post" >
	<input type="hidden" name="lIdDefinitionWorkflow" value="<%=item.getIdDefinitionWorkflow() %>" />
	<input type="hidden" name="lIdDefinitionTransition" value="<%=item.getId() %>" />
	<input type="hidden" name="sAction" value="<%=sAction %>" />

	<div id="fiche">

	<div class="sectionTitle"><div>Définition de la transition <%= item.getId() %></div></div>
	<div class="sectionFrame">
		<table class="formLayout" cellspacing="3">
			<tr>
				<td class="label" >Nom :</td>
				<td class="frame"><input type="input" name="sName" value="<%= item.getName()%>" size="60" /></td>
			</tr>
			<tr>
				<td class="label" >Description :</td>
				<td class="frame"><textarea cols="60" rows="3" name="sDescription" ><%= item.getDescription()%></textarea></td>
			</tr>
			<tr>
				<td class="label" >Type :</td>
				<td class="frame"><%= type.getAllInHtmlSelect("lIdDefinitionTransitionType", false) %></td>
			</tr>
			<tr>
				<td class="label" >Etat inial :</td>
				<td class="frame">
			<%=	CoinDatabaseAbstractBeanHtmlUtil
					.getHtmlSelect("lIdDefinitionStateInitial", 1, vStates, item.getIdDefinitionStateInitial(), "", true, false)

			%>
				</td>
			</tr>
			<tr>
				<td class="label" >Etat final :</td>
				<td class="frame">
			<%=	CoinDatabaseAbstractBeanHtmlUtil
					.getHtmlSelect("lIdDefinitionStateFinal", 1, vStates, item.getIdDefinitionStateFinal(), "", true, false)

			%>
				</td>
			</tr>


			<tr>
				<td class="label" >Pos X :</td>
				<td class="frame"><input type="input" name="lPosX" value="<%= item.getPosX()%>" size="60" /></td>
			</tr>
			<tr>
				<td class="label" >Pos Y :</td>
				<td class="frame"><input type="input" name="lPosY" value="<%= item.getPosY()%>" size="60" /></td>
			</tr>
			<tr>
				<td class="label" >Pos height :</td>
				<td class="frame"><input type="input" name="lPosHeight" value="<%= item.getPosHeight()%>" size="60" /></td>
			</tr>
			<tr>
				<td class="label" >Pos width :</td>
				<td class="frame"><input type="input" name="lPosWidth" value="<%= item.getPosWidth()%>" size="60" /></td>
			</tr>
		</table>
	</div>
	<br />

	<div class="sectionFrame">

		<div id="fiche_footer">
			<button type="submit" ><%=sTitle %></button>
			<button type="button" onclick="javascript:Redirect('<%=
				response.encodeRedirectURL(
						"modifyDefinitionTransition.jsp?sAction=remove&lIdDefinitionTransition="
						+ item.getId()
						)
				%>')" >Supprimer</button>
			<button type="button" onclick="javascript:Redirect('<%=
				response.encodeRedirectURL(
						"displayDefinitionWorkflow.jsp?lIdDefinitionWorkflow="
						+ item.getIdDefinitionWorkflow() )
				%>')" />Annuler</button>
		</div>
	</div>
</div>


</div>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>

</form>
</body>
</html>