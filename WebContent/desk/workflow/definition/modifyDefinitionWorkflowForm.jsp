<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.*,java.util.*" %>
<%@page import="org.coin.bean.workflow.DefinitionWorkflow"%>
<%
	long lIdDefinitionWorkflow;
	String sAction;
	String sTitle ;
	DefinitionWorkflow item;

	sAction = request.getParameter("sAction") ;

	if(sAction.equals("store"))
	{
		lIdDefinitionWorkflow = Integer.parseInt( request.getParameter("lIdDefinitionWorkflow") );
		sTitle = "Modifier une definition de workflow";
		item = DefinitionWorkflow.getDefinitionWorkflow(lIdDefinitionWorkflow );
	}
	else
	{
		lIdDefinitionWorkflow = -1;
		sTitle = "Ajouter une definition de workflow";
		item = new DefinitionWorkflow();
	}


%>
<script type="text/javascript" src="<%= rootPath %>include/bascule.js" ></script>
</head>
<body>
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<div style="padding:15px">

<form name="formulaire" action="<%= response.encodeRedirectURL("modifyDefinitionWorkflow.jsp") %>" method="post" >
	<input type="hidden" name="lIdDefinitionWorkflow" value="<%=item.getId() %>" />
	<input type="hidden" name="sAction" value="<%=sAction %>" />

	<div id="fiche">

	<div class="sectionTitle"><div>Définition de workflow</div></div>
	<div class="sectionFrame">
		<table class="formLayout" cellspacing="3">
			<tr>
				<td class="label" >Nom :</td>
				<td class="frame"><input type="input" name="sName" value="<%= item.getName()%>" size="60" /></td>
			</tr>
			<tr>
				<td class="label" >Description :</td>
				<td class="frame"><textarea name="sDescription" cols="60" rows="4"><%= item.getDescription()%></textarea></td>
			</tr>
			<tr>
				<td class="label" >Extra :</td>
				<td class="frame">
					<input type="radio" name="sExtra" checked="checked"  />Aucun<br/>
					<input type="radio" name="sExtra"  />Recopie du workflow <%=
						item.getAllInHtmlSelect("iIdCopy", false) %> (en V2)<br/>
					<input type="radio" name="sExtra"  />Utilisation du workflow en tant que layer <%=
						item.getAllInHtmlSelect("iIdLayer", false) %> (en V2)<br/>
				</td>
			</tr>
		</table>
	</div>
	<br />

	<div class="sectionFrame">

		<!-- Les boutons -->
		<div id="fiche_footer">
			<button type="submit" ><%=sTitle %></button>
			<button type="button" onclick="javascript:Redirect('<%=
				response.encodeRedirectURL("displayAllDefinitionWorkflow.jsp")%>')" >Annuler</button>
		</div>
	</div>
</div>

</form>
</div>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>
</html>