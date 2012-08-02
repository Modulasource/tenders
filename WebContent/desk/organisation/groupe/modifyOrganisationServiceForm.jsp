<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@page import="modula.graphic.Onglet"%>
<%@ page import="java.util.Vector"%>
<%@ page import="org.coin.bean.html.*,org.coin.fr.bean.*" %>
<%@ page import="org.coin.bean.organigram.*"%>
<%@ page import="org.coin.bean.ObjectType"%>
<%@ page import="org.coin.fr.bean.OrganisationServiceState"%>
<%@ page import="org.coin.db.CoinDatabaseAbstractBeanHtmlUtil"%>
<%

	Organisation organisation = null;
	long lIdOrganisation = -1;
	String sAction = request.getParameter("sAction");
	OrganisationService orgService = null;
	OrganisationService orgServiceDepend = null;
	String sActionCaption = "";
	OrganigramNode onService = null;
	String sStateActive = "";
	String sStateArchived = "";
	if(sAction.equals("create"))
	{
		orgService = new OrganisationService ();
		lIdOrganisation = Integer.parseInt(request.getParameter("iIdOrganisation"));
		long lIdOrganigramInterService = Integer.parseInt(request.getParameter("lIdOrganigramInterService"));
		onService = new OrganigramNode();
		onService.setIdOrganigram(lIdOrganigramInterService );
		onService.setIdTypeObject(ObjectType.ORGANISATION_SERVICE);
		onService.setIdOrganigramNodeState(OrganigramNodeState.STATE_ACTIVATED);

		sActionCaption = "Ajouter";
		orgServiceDepend = new OrganisationService ();
		
		sStateActive = " checked='checked'  ";
	}

	if(sAction.equals("store"))
	{
		onService = OrganigramNode.getOrganigramNode(
				Long.parseLong(request.getParameter("lIdOrganigramNode")));

		orgService
			= OrganisationService.getOrganisationService(onService.getIdReferenceObject());
		
		long lOrgState = orgService.getIdOrganisationServiceState();
		
		if(lOrgState == OrganisationServiceState.TYPE_ACTIVE)
			sStateActive = " checked='checked'  ";
		else
			sStateArchived = " checked='checked'  ";

		lIdOrganisation = orgService.getIdOrganisation();
		sActionCaption = "Modifier";
		try {
			// TODO : sera à modifier par la suite
			orgServiceDepend = OrganisationService.getOrganisationService(orgService.getIdOrganisationServiceDepend());
		} catch (Exception e) {
			orgServiceDepend = new OrganisationService ();
		}
	}
	organisation = Organisation.getOrganisation( lIdOrganisation );
	String sTitle = sActionCaption + " un service à l'organisation ";
	sTitle += organisation.getRaisonSociale();

	Vector vNode = OrganigramNode.getAllFromIdOrganigram( onService.getIdOrganigram() );
	Vector vService = OrganisationService.getAllFromIdOrganisation(organisation.getId());

	OrganigramNode.computeName(vNode, vService);

%>
</head>
<body>
<%
	HtmlBeanTableTrPave hbFormulaire = new HtmlBeanTableTrPave();
	hbFormulaire.bIsForm = true;
%>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<div style="padding:15px">

<form action="<%=response.encodeRedirectURL("modifyOrganisationService.jsp")%>" method="post" name="formulaire">
<input type="hidden" name="on_lIdOrganigramNode" value="<%=onService.getId()%>" />
<input type="hidden" name="on_lIdOrganigramNodeType" value="<%=onService.getIdOrganigramNodeType()%>" />
<input type="hidden" name="on_lIdOrganigramNodeState" value="<%=onService.getIdOrganigramNodeState()%>" />
<input type="hidden" name="on_lIdOrganigram" value="<%=onService.getIdOrganigram()%>" />
<input type="hidden" name="on_lIdTypeObject" value="<%=onService.getIdTypeObject()%>" />
<input type="hidden" name="on_lIdReferenceObject" value="<%=onService.getIdReferenceObject()%>" />
<input type="hidden" name="on_sName" value="<%=onService.getName()%>" />
<input type="hidden" name="on_sDescription" value="<%=onService.getDescription()%>" />
<input type="hidden" name="on_lPosX" value="<%=onService.getPosX()%>" />
<input type="hidden" name="on_lPosY" value="<%=onService.getPosY()%>" />

<input type="hidden" name="lIdOrganisationService" value="<%=orgService.getId()%>" />
<input type="hidden" name="lIdOrganisationServiceDepend" value="<%=orgService.getIdOrganisationServiceDepend()%>" />
<input type="hidden" name="lIdOrganisation" value="<%=organisation.getIdOrganisation()%>" />
<input type="hidden" name="lIdAdresse" value="<%=organisation.getIdAdresse()%>" />
<input type="hidden" name="sAction" value="<%= sAction %>" />
	<table class="pave" >
		<tr>
			<td class="pave_titre_gauche" colspan="2">Service</td>
		</tr>
		<%= hbFormulaire.getHtmlTrInput("Nom :", "sNom", orgService.getNom() , "size=40" ) %>
		<%= hbFormulaire.getHtmlTrInput("Matricule :", "sMatricule", orgService.getMatricule() , "size=40" ) %>
		<%= hbFormulaire.getHtmlTrInput("Reference externe :", "sReferenceExterne", orgService.getReferenceExterne() , "size=40" ) %>
		<tr>
			<td class="pave_cellule_gauche" >Responsable :</td>
			<td class="pave_cellule_droite">
		<%=	CoinDatabaseAbstractBeanHtmlUtil
				.getHtmlSelect("on_lIdOrganigramNodeParent", 5, vNode, onService.getIdOrganigramNodeParent(), "", true, false)

		%>
			</td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche" >Adresse</td>
			<td class="pave_cellule_droite" >
				<input type="radio" name="adresseType" value="1" checked="checked" /> Celle de l'organisation
				<input type="radio" name="adresseType" value="2" /> Une autre
			</td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche" >State</td>
			<td class="pave_cellule_droite" >
				<input type="radio" name="lIdOrganisationServiceState" value="<%= OrganisationServiceState.TYPE_ACTIVE %>" <%= sStateActive %> /> Active
				<input type="radio" name="lIdOrganisationServiceState" value="<%= OrganisationServiceState.TYPE_ARCHIVED %>" <%= sStateArchived %> /> Archived
			</td>
		</tr>
		
	</table>
	<br />
	<div class="center">
		<button type="submit" name="submit" >Valider</button>&nbsp;
		<button type="button" name="RAZ" onclick="Redirect('<%=
			response.encodeRedirectURL("../afficherOrganisation.jsp?iIdOrganisation="
					+organisation.getIdOrganisation()+"&amp;iIdOnglet=" + Onglet.ONGLET_ORGANISATION_SERVICE )
			%>')" >Annuler</button>
	</div>
</form>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>

</body>
</html>

