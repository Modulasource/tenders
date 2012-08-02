<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.*,java.util.*" %>
<%@page import="org.coin.bean.workflow.*"%>
<%
	long lIdDefinitionState;
	String sAction;
	String sTitle ;
	DefinitionState item;
	DefinitionStateType type = null;
	sAction = request.getParameter("sAction") ;


	if(sAction.equals("store"))
	{
		lIdDefinitionState = Integer.parseInt( request.getParameter("lIdDefinitionState") );
		sTitle = "Modifier une definition d'état";
		item = DefinitionState .getDefinitionState(lIdDefinitionState);
		type = DefinitionStateType.getDefinitionStateType(item.getIdDefinitionStateType());
	}
	else
	{
		lIdDefinitionState = -1;
		sTitle = "Ajouter une definition d'état";
		item = new DefinitionState ();
		item.setPosHeight(80);
		item.setPosWidth(80);
		type = new DefinitionStateType(DefinitionStateType.TYPE_NORMAL);
	}



%>
<script type="text/javascript" src="<%= rootPath %>include/bascule.js" ></script>
</head>
<body>

<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<div style="padding:15px">

<form name="formulaire" action="<%= response.encodeRedirectURL("modifyDefinitionState.jsp") %>" method="post" >
	<input type="hidden" name="lIdDefinitionState" value="<%=item.getId() %>" />
	<input type="hidden" name="lIdDefinitionWorkflow" value="<%=item.getIdDefinitionWorkflow() %>" />
	<input type="hidden" name="sAction" value="<%=sAction %>" />

	<div id="fiche">

	<div class="sectionTitle"><div>Définition de état <%= item.getId() %></div></div>
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
				<td class="frame"><%= type.getAllInHtmlSelect("lIdDefinitionStateType", false) %></td>
			</tr>
			<tr>
				<td class="label" >Reference : </td>
				<td class="frame"><input type="input" name="lIdTypeObject" value="<%= item.getIdTypeObject()%>" size="60" /></td>
			</tr>
			<tr>
				<td class="label" >Reference : </td>
				<td class="frame"><input type="input" name="lIdReferenceObject" value="<%= item.getIdReferenceObject()%>" size="60" /></td>
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

		<!-- Les boutons -->
		<div id="fiche_footer">
			<button type="submit" ><%=sTitle %></button>
			<button type="button" onclick="javascript:Redirect('<%=
				response.encodeRedirectURL(
						"modifyDefinitionState.jsp?sAction=remove&lIdDefinitionState="
						+ item.getId()
						)
				%>')" >Supprimer</button>
			<button type="button" value="" onclick="javascript:Redirect('<%=
				response.encodeRedirectURL(
						"displayDefinitionWorkflow.jsp?lIdDefinitionWorkflow="
						+ item.getIdDefinitionWorkflow() )
				%>')" >Annuler</button>
		</div>
	</div>
</div>

</form>

</div>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>

</body>
</html>