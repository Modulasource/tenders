<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.*,java.util.*" %>
<%@ page import="org.coin.bean.workflow.*"%>
<%@page import="org.coin.bean.organigram.*"%>
<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%@page import="modula.graphic.Onglet"%>
<%@page import="org.coin.db.*"%>
<%
	long lIdOrganigramNode ;
	String sAction;
	String sTitle ;
	OrganigramNode item;

	sAction = request.getParameter("sAction") ;

	if(sAction.equals("store"))
	{
		lIdOrganigramNode = Integer.parseInt( request.getParameter("lIdOrganigramNode") );
		sTitle = "Modifier poste";
		item = OrganigramNode.getOrganigramNode(lIdOrganigramNode );
	}
	else
	{
		lIdOrganigramNode = -1;
		sTitle = "Ajouter un poste";
		item = new OrganigramNode();
		long lIdOrganigram = Integer.parseInt( request.getParameter("lIdOrganigram") );
		item.setIdOrganigram(lIdOrganigram );
		item.setIdTypeObject(ObjectType.PERSONNE_PHYSIQUE);
	}

	Organigram organigram = Organigram.getOrganigram(item.getIdOrganigram());
	Vector vNode = OrganigramNode.getAllFromIdOrganigram( item.getIdOrganigram() );
	Vector vPoste = OrganigramNodeType.getAllStatic( );

	if(organigram.getIdTypeObject() != ObjectType.ORGANISATION)
	{
		throw new CoinDatabaseLoadException("ObjetType not ObjectType.ORGANISATION" ,"");
	}

	Vector vPersonne = PersonnePhysique.getAllFromIdOrganisation( (int)organigram .getIdReferenceObject());

%>
<script type="text/javascript" src="<%= rootPath %>include/bascule.js" ></script>
</head>
<body>

<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<div style="padding:15px">

<form name="formulaire" action="<%= response.encodeRedirectURL("modifyOrganisationOrganigramNode.jsp") %>" method="post" >

	<input type="hidden" name="lIdOrganigram" value="<%=item.getIdOrganigram() %>" />
	<input type="hidden" name="lIdOrganigramNode" value="<%=item.getId() %>" />
	<input type="hidden" name="lIdTypeObject" value="<%=item.getIdTypeObject() %>" />
	<input type="hidden" name="sAction" value="<%=sAction %>" />

	<div id="fiche">

	<div class="sectionTitle"><div>Poste <%= item.getId() %></div></div>
	<div class="sectionFrame">
		<table class="formLayout" cellspacing="3">
			<tr>
				<td class="label" >Poste :</td>
				<td class="frame">
			<%=	CoinDatabaseAbstractBeanHtmlUtil
					.getHtmlSelect("lIdOrganigramNodeType", 1, vPoste, item.getIdOrganigramNodeType(), "", true, false)

			%>
				</td>
			</tr>
			<tr>
				<td class="label" >Nom :</td>
				<td class="frame"><input type="input" name="sName" value="<%= item.getName()%>" size="60" /></td>
			</tr>
			<tr>
				<td class="label" >Description :</td>
				<td class="frame"><textarea rows="3" cols="60" name="sDescription" ><%= item.getDescription() %></textarea></td>
			</tr>
			<tr>
				<td class="label" >Node parent :</td>
				<td class="frame">
			<%=	CoinDatabaseAbstractBeanHtmlUtil
					.getHtmlSelect("lIdOrganigramNodeParent", 1, vNode, item.getIdOrganigramNodeParent(), "", true, false)

			%>
				</td>
			</tr>
			<tr>
				<td class="label" >Personne :</td>
				<td class="frame">
			<%=	CoinDatabaseAbstractBeanHtmlUtil
					.getHtmlSelect("lIdReferenceObject", 1, vPersonne, item.getIdReferenceObject(), "", true, false)

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
		</table>
	</div>
	<br />

	<div class="sectionFrame">

		<!-- Les boutons -->
		<div id="fiche_footer">
			<button type="submit" ><%=sTitle %></button>

<%
	if(sAction.equals("store"))
	{
%>
			<button type="button" onclick="javascript:Redirect('<%=
				response.encodeRedirectURL(
						rootPath + "desk/organisation/organigram/modifyOrganisationOrganigramNode.jsp?sAction=remove&lIdOrganigramNode="
						+ item.getId()
						)
				%>')" >Supprimer</button>
<%
	}
%>			<button type="button" onclick="javascript:Redirect('<%=
				response.encodeRedirectURL(
						rootPath + "desk/organisation/afficherOrganisation.jsp?iIdOrganisation="
						+ organigram.getIdReferenceObject()
						+ "&iIdOnglet=" + Onglet.ONGLET_ORGANISATION_ORGANIGRAM
						+ "&nonce=" + System.currentTimeMillis())
				%>')" >Annuler</button>
		</div>
	</div>
</div>
</div>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>


</form>
</body>
</html>