<%@ include file="../../../include/new_style/headerDesk.jspf" %>

<%@page import="modula.graphic.Onglet"%>
<%@ page import="org.coin.bean.html.*,org.coin.fr.bean.*" %>
<%@ page import="java.util.Vector"%>
<%@ page import="org.coin.db.CoinDatabaseAbstractBeanHtmlUtil"%>
<%

	Organisation organisation = null;
	long lIdOrganisation = -1;

	String sAction = request.getParameter("sAction");
	ObjectGroup ogOrganisationGroupe = null;
	String sActionCaption = "";


	if(sAction.equals("create"))
	{
		ogOrganisationGroupe = new ObjectGroup();
		lIdOrganisation = Integer.parseInt(request.getParameter("iIdOrganisation"));
		sActionCaption = "Ajouter";
		ogOrganisationGroupe.setIdTypeObject(ObjectType.ORGANISATION);
		ogOrganisationGroupe.setIdReferenceObject(lIdOrganisation);
		ogOrganisationGroupe.setIdTypeObjectHead(ObjectType.PERSONNE_PHYSIQUE);
		ogOrganisationGroupe.setIdGroupType(ObjectGroupType.GROUP_ORGANISATION_GROUPE);
	}

	if(sAction.equals("store"))
	{
		ogOrganisationGroupe
			= ObjectGroup.getObjectGroup(
					Long.parseLong(request.getParameter("lIdObjectGroup")));
		System.out.println("ogOrganisationGroupe=" + ogOrganisationGroupe.getId() + "\n\n");

		sActionCaption = "Modifier";
		lIdOrganisation = ogOrganisationGroupe.getIdReferenceObject();

	}

	organisation = Organisation.getOrganisation( lIdOrganisation );
	String sTitle = sActionCaption + " un groupe à l'organisation ";
	sTitle += organisation.getRaisonSociale();

	System.out.println(sTitle + "\n\n");

	PersonnePhysique membreResponsable = null;
	try{
		membreResponsable = PersonnePhysique.getPersonnePhysique(ogOrganisationGroupe.getIdReferenceObjectHead());
	} catch (Exception e) {
		// le service n'a pas de membre affecté
		membreResponsable = new PersonnePhysique();
	}

	Vector vPPGroupeMembreDispo
		= PersonnePhysique.getAllWithWhereAndOrderByClauseStatic(
			" WHERE id_organisation=" + organisation.getId(),
			"");

%>
</head>
<body>
<%
	HtmlBeanTableTrPave hbFormulaire = new HtmlBeanTableTrPave();
	hbFormulaire.bIsForm = true;
%>
<%@ include file="../../../include/new_style/headerFiche.jspf" %>
<div style="padding:15px">

<form action="<%=response.encodeRedirectURL("modifyOrganisationGroupe.jsp")%>" method="post" name="formulaire">
<input type="hidden" name="lIdObjectGroup" value="<%= ogOrganisationGroupe.getId()%>" />
<input type="hidden" name="lIdGroupType" value="<%= ogOrganisationGroupe.getIdGroupType()%>" />
<input type="hidden" name="lIdTypeObject" value="<%= ogOrganisationGroupe.getIdTypeObject()%>" />
<input type="hidden" name="lIdReferenceObject" value="<%= ogOrganisationGroupe.getIdReferenceObject()%>" />
<input type="hidden" name="lIdTypeObjectHead" value="<%= ogOrganisationGroupe.getIdTypeObjectHead()%>" />
<input type="hidden" name="sAction" value="<%= sAction %>" />
	<table class="pave" >
		<tr>
			<td class="pave_titre_gauche" colspan="2">Groupe</td>
		</tr>
		<%= hbFormulaire.getHtmlTrInput("Nom :", "sNom", ogOrganisationGroupe.getNom() ) %>
		<%= hbFormulaire.getHtmlTrInput("Description :", "sDescription", ogOrganisationGroupe.getDescription() ) %>
		<%= hbFormulaire.getHtmlTrInput("Alias :", "sAlias", ogOrganisationGroupe.getAlias() ) %>
		<%= hbFormulaire.getHtmlTrInput("Email :", "sEmail", ogOrganisationGroupe.getEmail() ) %>

		<tr class="header">
			<td>
				Responsable :
			</td>
			<td>
			<%= CoinDatabaseAbstractBeanHtmlUtil.getHtmlSelect(
					"lIdReferenceObjectHead",
					1,
					vPPGroupeMembreDispo,
					membreResponsable.getId(),
					"",
					true,
					true) %>
			</td>
		</tr>

	</table>
	<br />
	<div class="center">
		<button type="submit" name="submit" >Valider</button>&nbsp;
		<button type="button" name="RAZ" onclick="Redirect('<%=
			response.encodeRedirectURL("../afficherOrganisation.jsp?iIdOrganisation="
					+organisation.getIdOrganisation()+"&amp;iIdOnglet=" + Onglet.ONGLET_ORGANISATION_GROUP)
			%>')" >Annuler</button>
	</div>
</form>
</div>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>

</body>
<%@page import="org.coin.bean.ObjectType"%>
</html>

