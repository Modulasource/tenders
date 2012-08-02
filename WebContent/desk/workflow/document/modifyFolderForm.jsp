<%@ include file="../../../include/headerXML.jspf" %>

<%@ page import="org.coin.bean.*,java.util.*,mt.paraph.graphic.*" %>
<%@ page import="org.coin.bean.workflow.*"%>
<%@ page import="org.coin.fr.bean.PersonnePhysique"%>
<%@ page import="org.coin.bean.ObjectType"%>
<%@ page import="org.coin.db.CoinDatabaseAbstractBeanHtmlUtil"%>
<%@ include file="../../include/beanSessionUser.jspf" %>
<%
	long lIdWorkflowFolder;
	String sAction;
	String sTitle ;
	Folder item;
	sAction = request.getParameter("sAction") ;
	String rootPath = request.getContextPath()+"/";


	if(sAction.equals("store"))
	{
		lIdWorkflowFolder = Integer.parseInt( request.getParameter("lIdWorkflowFolder") );
		sTitle = "Modifier un dossier";
		item = Folder.getFolder(lIdWorkflowFolder);
	}
	else
	{
		lIdWorkflowFolder = -1;
		sTitle = "Ajouter un dossier";
		item = new Folder();
		item.setIdRefenceObjectOwner(sessionUser.getIdIndividual());
		item.setIdTypeObjectOwner(ObjectType.PERSONNE_PHYSIQUE);

	}

	String sOwner = "";
	if(item.getIdTypeObjectOwner() == ObjectType.PERSONNE_PHYSIQUE)
	{
		PersonnePhysique personne
			= PersonnePhysique.getPersonnePhysique(item.getIdRefenceObjectOwner());
		sOwner = personne.getPrenomNom();
	}


%>
<%@ include file="../../include/headerDesk.jspf" %>
<script type="text/javascript" src="<%= rootPath %>include/bascule.js" ></script>
</head>
<body>
<form name="formulaire" action="<%= response.encodeRedirectURL("modifyFolder.jsp") %>" method="post" >
	<input type="hidden" name="lIdWorkflowFolder" value="<%=item.getId() %>" />
	<input type="hidden" name="lIdTreeviewNodeFirstChild" value="<%=item.getIdTreeviewNodeFirstChild() %>" />
	<input type="hidden" name="lIdTreeviewNodeNextSibling" value="<%=item.getIdTreeviewNodeNextSibling() %>" />
	<input type="hidden" name="lIdTypeObjectOwner" value="<%=item.getIdTypeObjectOwner() %>" />
	<input type="hidden" name="lIdRefenceObjectOwner" value="<%=item.getIdRefenceObjectOwner() %>" />
	<input type="hidden" name="sAction" value="<%=sAction %>" />

	<%@ include file="../../include/headerFiche.jspf" %>
	<div id="fiche">

	<div class="sectionTitle"><div>Définition du dossier <%= item.getName() %></div></div>
	<div class="sectionFrame">
		<table class="formLayout" cellspacing="3">
			<tr>
				<td class="label" >Appartient à :</td>
				<td class="frame"><%= sOwner  %></td>
			</tr>
			<tr>
				<td class="label" >Date création :</td>
				<td class="frame"><%= item.getDateCreation()  %></td>
			</tr>
			<tr>
				<td class="label" >Date modification :</td>
				<td class="frame"><%= item.getDateModification()  %></td>
			</tr>
			<tr>
				<td class="label" >Nom :</td>
				<td class="frame"><input type="input" name="sName" value="<%= item.getName()%>" size="60" /></td>
			</tr>
			<tr>
				<td class="label" >Description :</td>
				<td class="frame"><textarea rows="3" cols="60" name="sDescription" ><%= item.getDescription()%></textarea></td>
			</tr>
		</table>
	</div>

	<div class="sectionFrame">

		<!-- Les boutons -->
		<div id="fiche_footer">
			<input type="submit" value="<%=sTitle %>"  />
			<input type="button" value="Supprimer" onclick="javascript:Redirect('<%=
				response.encodeRedirectURL(
						"modifyFolder.jsp?sAction=remove&lIdWorkflowFolder=" + item.getId())
				%>')" />
			<input type="button" value="Annuler" onclick="javascript:Redirect('<%=
				response.encodeRedirectURL(
						"displayAllFolder.jsp")
				%>')" />
		</div>
	</div>
</div>
<%@ include file="../../include/footerFiche.jspf" %>
</form>
</body>
</html>