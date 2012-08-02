<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.*,java.util.*" %>
<%@ page import="org.coin.bean.workflow.*"%>
<%@ page import="org.coin.fr.bean.*"%>
<%@ page import="org.coin.bean.organigram.*"%>
<%@ page import="org.coin.db.CoinDatabaseAbstractBean"%>
<%@ page import="org.coin.db.CoinDatabaseAbstractBeanHtmlUtil"%>
<%

	String sAction = "generate";
	String sTitle = "Génération";
	long lIdOrganisation = -1;
	Vector vOrganisation = null;
	Vector vOrganisationService = null;
	Vector vOrganisationServiceAll = null;
	Vector vPersonne = null;
	Vector vNodeStart = null;
	Vector vNodeEnd = null;
	long lIdOrganisationServiceStart = -1;
	long lIdOrganisationServiceEnd = -1;
	long lIdOrganigramNodeStart = -1;
	long lIdOrganigramNodeEnd = -1;
	Organisation organisation = null;
	Organigram organigramInterService =  null;
	Vector<OrganigramNode> vOrganigramNodeInterService =  null;
	// TODO : à voir pour chaque entreprise ?
	Vector vPoste = OrganigramNodeType.getAllStatic();

	
	boolean bAddNodeHead = HttpUtil.parseBoolean("bAddNodeHead", request, true);
	lIdOrganisation = CoinDatabaseAbstractBean.getLongFromHtmlForm(request, "lIdOrganisation", -1);

	if(lIdOrganisation != -1 )  {
		// car l'une va être filtré pour supprimer les services sans organigramme
		vOrganisationService = OrganisationService.getAllFromIdOrganisation(lIdOrganisation);
		vOrganisationServiceAll = OrganisationService.getAllFromIdOrganisation(lIdOrganisation);

 		Vector<Organigram> vOrganisationOrganigramInterService
			= Organigram.getAllFromObject(
				ObjectType.ORGANISATION,
				lIdOrganisation ,
				ObjectType.ORGANISATION_SERVICE);

 		if( vOrganisationOrganigramInterService.size() == 1)
		{
			organigramInterService = (Organigram )vOrganisationOrganigramInterService.get(0);
			vOrganigramNodeInterService
				= OrganigramNode.getAllFromIdOrganigram(
						organigramInterService.getId());

		}

		vOrganisationService = OrganisationService.filterOnlyWithOrganigram (vOrganisationService );
		vPersonne = PersonnePhysique.getAllFromIdOrganisation( (int) lIdOrganisation);
		organisation = Organisation.getOrganisation((int) lIdOrganisation);

		lIdOrganisationServiceStart = CoinDatabaseAbstractBean.getLongFromHtmlForm(request, "lIdOrganisationServiceStart", -1);
		lIdOrganisationServiceEnd = CoinDatabaseAbstractBean.getLongFromHtmlForm(request, "lIdOrganisationServiceEnd", -1);

		lIdOrganigramNodeStart = CoinDatabaseAbstractBean.getLongFromHtmlForm(request, "lIdOrganigramNodeStart", -1);
		lIdOrganigramNodeEnd = CoinDatabaseAbstractBean.getLongFromHtmlForm(request, "lIdOrganigramNodeEnd", -1);



		if(lIdOrganisationServiceStart != -1)
		{
			Organigram organigramStart = OrganisationService.getOrganigramStatic(lIdOrganisationServiceStart);
			vNodeStart = OrganigramNode.getAllFromIdOrganigram( organigramStart.getId() );
			OrganigramNode.computeName(vNodeStart, vPersonne, vPoste);

		}

		if(lIdOrganisationServiceEnd != -1)
		{
			Organigram organigramEnd = OrganisationService.getOrganigramStatic(lIdOrganisationServiceEnd);
			vNodeEnd = OrganigramNode.getAllFromIdOrganigram( organigramEnd.getId() );
			OrganigramNode.computeName(vNodeEnd, vPersonne, vPoste);
		}
	}
	else
	{
		vOrganisation = OrganisationService.getAllOrganisationWithAtLeastOneService();
	}





%>
<script type="text/javascript" src="<%= rootPath %>include/bascule.js" ></script>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<div style="padding:15px">

<form name="formulaire" action="<%= response.encodeRedirectURL("generateOrganigramCircuitForm.jsp") %>" method="post" >
	<input type="hidden" name="sAction" value="<%=sAction %>" />

	<div id="fiche">

	<div class="sectionTitle"><div>Génération de circuit </div></div>
	<div class="sectionFrame">
		<table class="formLayout" cellspacing="3">
<%
	if(lIdOrganisation == -1)
	{
%>
			<tr>
				<td class="label" >Organisation :</td>
				<td class="frame">
			<%=	CoinDatabaseAbstractBeanHtmlUtil
					.getHtmlSelect("lIdOrganisation", 1, vOrganisation, lIdOrganisation)
			%>
				</td>
			</tr>
<%
	}
	else
	{
%>
			<tr>
				<td class="label" >Organisation :</td>
				<td class="frame">
				<input type="hidden" name="lIdOrganisation" value="<%=organisation.getId() %>" />
					<%= organisation.getRaisonSociale()  %>
				</td>
			</tr>
			<tr>
				<td class="label" >Service émetteur :</td>
				<td class="frame">
			<%=	CoinDatabaseAbstractBeanHtmlUtil
					.getHtmlSelect("lIdOrganisationServiceStart", 1, vOrganisationService, lIdOrganisationServiceStart)
			%>
				</td>
			</tr>
<%
		if(lIdOrganisationServiceStart != -1)
		{
%>
			<tr>
				<td class="label" >Personne émetteur :</td>
				<td class="frame">
			<%=	CoinDatabaseAbstractBeanHtmlUtil
					.getHtmlSelect("lIdOrganigramNodeStart", 1, vNodeStart, lIdOrganigramNodeStart)
			%>
				</td>
			</tr>
<%
		}
%>

			<tr>
				<td class="label" >Service destinataire :</td>
				<td class="frame">
			<%=	CoinDatabaseAbstractBeanHtmlUtil
					.getHtmlSelect("lIdOrganisationServiceEnd", 1, vOrganisationService, lIdOrganisationServiceEnd)
			%>
				</td>
			</tr>
<%
		if(lIdOrganisationServiceEnd != -1)
		{
%>
			<tr>
				<td class="label" >Personne destinataire :</td>
				<td class="frame">
			<%=	CoinDatabaseAbstractBeanHtmlUtil
					.getHtmlSelect("lIdOrganigramNodeEnd", 1, vNodeEnd, lIdOrganigramNodeEnd)
			%>
				</td>
			</tr>

            <tr>
                <td class="label" >Ajouter la tête du circuit:</td>
                <td class="frame">
                    <select name="bAddNodeHead">
                        <option value="true" >oui</option>
                        <option value="false" >non</option>
                    </select>
                </td>
            </tr>

<%
		}
	}
%>
		</table>
	</div>
	<br />

	<div class="sectionFrame">

		<!-- Les boutons -->
		<div id="fiche_footer">
			<button type="submit" ><%=sTitle %></button>

		</div>
	</div>
</div>

<%@ include file="/desk/workflow/bloc/blocDisplayGenerateCircuit.jspf" %>

</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>

</form>
</body>

<%@page import="org.coin.util.HttpUtil"%></html>