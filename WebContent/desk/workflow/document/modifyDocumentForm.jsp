<%@ include file="../../../include/headerXML.jspf" %>

<%@ page import="org.coin.bean.*,java.util.*,mt.paraph.graphic.*" %>
<%@ page import="org.coin.bean.workflow.*"%>
<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%@ page import="org.coin.db.CoinDatabaseAbstractBeanHtmlUtil"%>
<%@ include file="../../include/beanSessionUser.jspf" %>
<%
	long lIdWorkflowDocument;
	String sAction;
	String sTitle ;
	Document item;
	Folder folder;
	sAction = request.getParameter("sAction") ;
	String rootPath = request.getContextPath()+"/";
	Vector vWorkflows =  DefinitionWorkflow.getAllStatic();


	if(sAction.equals("store"))
	{
		lIdWorkflowDocument = Integer.parseInt( request.getParameter("lIdWorkflowDocument") );
		sTitle = "Modifier un document";
		item = Document.getDocument(lIdWorkflowDocument);
		folder = Folder.getFolder(item.getIdWorkflowFolder());
	}
	else
	{
		lIdWorkflowDocument = -1;
		sTitle = "Ajouter un document";
		item = new Document();
		folder = new Folder();
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
<form name="formulaire" action="<%= response.encodeRedirectURL("modifyDocument.jsp") %>" method="post" >
	<input type="hidden" name="lIdWorkflowDocument" value="<%=item.getId() %>" />
	<input type="hidden" name="sAction" value="<%=sAction %>" />
	<input type="hidden" name="lIdTypeObjectOwner" value="<%=item.getIdTypeObjectOwner() %>" />
	<input type="hidden" name="lIdRefenceObjectOwner" value="<%=item.getIdRefenceObjectOwner() %>" />
	<input type="hidden" name="lIdTypeObjectSource" value="<%=item.getIdTypeObjectSource() %>" />
	<input type="hidden" name="lIdRefenceObjectSource" value="<%=item.getIdRefenceObjectSource() %>" />

	<%@ include file="../../include/headerFiche.jspf" %>
	<div id="fiche">

	<div class="sectionTitle"><div>Définition du document <%= item.getId() %></div></div>
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
			<tr>
				<td class="label" >Dossier :</td>
				<td class="frame">
			<%=	folder.getAllInHtmlSelect("lIdWorkflowFolder", false) %>
				</td>
			</tr>
	<%
	if(sAction.equals("create"))
	{
	%>
			<tr>
				<td class="label" >Workflow initial :</td>
				<td class="frame">
			<%=	CoinDatabaseAbstractBeanHtmlUtil
					.getHtmlSelect("lIdDefinitionWorkflowInitial", 1, vWorkflows, -1, "", true, false)

			%>
				</td>
			</tr>
	<%
	}
	%>
		</table>
	</div>
	<br />

	<div class="sectionFrame">

		<!-- Les boutons -->
		<div id="fiche_footer">
			<input type="submit" value="<%=sTitle %>"  />
			<input type="button" value="Annuler" onclick="javascript:Redirect('<%=
				response.encodeRedirectURL(
						"displayAllDocument.jsp" )
				%>')" />
		</div>
	</div>
</div>
<%@ include file="../../include/footerFiche.jspf" %>
</form>
</body>
</html>