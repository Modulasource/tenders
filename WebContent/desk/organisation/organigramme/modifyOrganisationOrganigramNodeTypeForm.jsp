<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@ page import="org.coin.bean.*,java.util.*" %>
<%@ page import="org.coin.bean.workflow.*"%>
<%@page import="org.coin.bean.organigram.*"%>
<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%@page import="modula.graphic.Onglet"%>
<%@page import="org.coin.db.*"%>
<%
	long lIdOrganigramNodeType ;
	String sAction;
	String sTitle ;
	OrganigramNodeType item;

	sAction = request.getParameter("sAction") ;


	// pour le moment on les stocke dans cette page
	long lIdOrganisation = Integer.parseInt( request.getParameter("lIdOrganisation") );

	if(sAction.equals("store"))
	{
		lIdOrganigramNodeType = Integer.parseInt( request.getParameter("lIdOrganigramNodeType") );
		sTitle = "Modifier poste";
		item = OrganigramNodeType.getOrganigramNodeType(lIdOrganigramNodeType );
	}
	else
	{
		lIdOrganigramNodeType = -1;
		sTitle = "Ajouter un poste";
		item = new OrganigramNodeType();
		long lIdTypeObject = Integer.parseInt( request.getParameter("lIdTypeObject") );
		item.setIdTypeObject(ObjectType.PERSONNE_PHYSIQUE);
	}

%>
<script type="text/javascript" src="<%= rootPath %>include/bascule.js" ></script>
</head>
<body>

<%@ include file="/include/new_style/headerFiche.jspf" %>
<div style="padding:15px">

<form name="formulaire" action="<%= response.encodeRedirectURL("modifyOrganisationOrganigramNodeType.jsp") %>" method="post" >

	<input type="hidden" name="lIdOrganigramNodeType" value="<%=item.getId() %>" />
	<input type="hidden" name="lIdTypeObject" value="<%=item.getIdTypeObject() %>" />
	<input type="hidden" name="sAction" value="<%=sAction %>" />
	<input type="hidden" name="lIdOrganisation" value="<%=lIdOrganisation%>" />

	<div id="fiche">

	<div class="sectionTitle"><div>Poste <%= item.getId() %></div></div>
	<div class="sectionFrame">
		<table class="formLayout" cellspacing="3">
			<tr>
				<td class="label" >Nom :</td>
				<td class="frame"><input type="input" name="sName" value="<%= item.getName()%>" size="60" /></td>
			</tr>
			<tr>
				<td class="label" >Description :</td>
				<td class="frame"><textarea rows="3" cols="60" name="sDescription" ><%= item.getDescription() %></textarea></td>
			</tr>
		</table>
	</div>
	<br />

	<div class="sectionFrame">

			<div id="fiche_footer">
			<button type="submit" ><%=sTitle %></button>
<%
	if(sAction.equals("store"))
	{
%>			<button type="button"  onclick="javascript:Redirect('<%=
				response.encodeRedirectURL(
						rootPath + "desk/organisation/organigramme/modifyOrganisationOrganigramNodeType.jsp?sAction=remove&lIdOrganigramNodeType="
						+ item.getId()
						)
				%>')" >Supprimer</button>
<%
	}
%>			<button type="button"  onclick="javascript:Redirect('<%=
				response.encodeRedirectURL(
						rootPath + "desk/organisation/afficherOrganisation.jsp?iIdOrganisation="
						+ lIdOrganisation
						+ "&iIdOnglet=" + Onglet.ONGLET_ORGANISATION_ORGANIGRAM
						+ "&nonce=" + System.currentTimeMillis())
				%>')" >Annuler</button>
		</div>
	</div>
</div>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>


</form>
</body>
</html>