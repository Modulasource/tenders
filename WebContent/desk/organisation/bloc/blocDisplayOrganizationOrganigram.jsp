<%
	String rootPath = request.getContextPath() +"/";
	Organisation organisation = (Organisation) request.getAttribute("organisation");
	LocalizeButton localizeButton = (LocalizeButton) request.getAttribute("localizeButton");
	int iIdOnglet = HttpUtil.parseInt("iIdOnglet", request);
	
	Vector<Organigram> vOrganisationOrganigram
		= Organigram.getAllFromObject(
			ObjectType.ORGANISATION,
			organisation.getId(),
			ObjectType.PERSONNE_PHYSIQUE);

%>
	
<%@page import="java.util.Vector"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.bean.organigram.Organigram"%>
<%@page import="org.coin.bean.organigram.OrganigramNode"%>
<%@page import="org.coin.fr.bean.Organisation"%>
<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%@page import="org.coin.localization.LocalizeButton"%>

<%@page import="org.coin.util.HttpUtil"%><div class="right">
<%	
		if( vOrganisationOrganigram.size() == 0)
		{
%>
	<button
		type="button"
		onclick="javascript:Redirect('<%= response.encodeURL(
		rootPath + "desk/organisation/organigramme/modifyOrganisationOrganigram.jsp?sAction=create"
		+ "&iIdOrganisation=" + organisation.getIdOrganisation()
		+ "&lIdTypeObject=" + ObjectType.ORGANISATION
		+ "&lIdTypeObjectNode=" + ObjectType.PERSONNE_PHYSIQUE
		+ "&iIdOnglet=" + iIdOnglet ) %>')"
		>Ajouter l'organigramme</button>
<%
		}
		else
		{
			Organigram organigram = (Organigram )vOrganisationOrganigram.get(0);
%>
	<button
		type="button"
		onclick="javascript:Redirect('<%= response.encodeURL(
		rootPath + "desk/organisation/organigramme/modifyOrganisationOrganigramNodeForm.jsp?sAction=create"
		+ "&lIdOrganisation=" + organisation.getIdOrganisation()
		+ "&lIdOrganigram=" + organigram.getId()
		) %>')"
		>Ajouter un poste</button>
	<button
		type="button"
		onclick="javascript:Redirect('<%= response.encodeURL(
		rootPath + "desk/organisation/organigramme/designOrganisationOrganigram.jsp?"
		+ "&lIdOrganigram=" + organigram.getId()
		) %>')"
		>Voir organigramme</button>
<%

	
			Vector<OrganigramNode> vOrganigramNode
				= OrganigramNode.getAllFromIdOrganigram(
						organigram.getId());
	
			Vector<?> vPersonne = PersonnePhysique.getAllFromIdOrganisation( (int)organigram .getIdReferenceObject());

%>
	<button
		type="button"
		onclick="javascript:Redirect('<%= 
			response.encodeURL(
				rootPath + "desk/organisation/organigramme/modifyOrganisationOrganigramNodeTypeForm.jsp?sAction=create"
				+ "&lIdOrganisation=" + organisation.getId()
				+ "&lIdTypeObject=" + ObjectType.PERSONNE_PHYSIQUE
		) %>')"
		>Ajouter type de poste</button>
	</div>
	<div>
		<div class="dataGridHolder">
		<table class="dataGrid fullWidth">
			<tr>
				<td> Les postes : </td>
			</tr>
			<tr>
				<td>
					<table class="dataGrid fullWidth">
						<tr class="header">
							<td>Poste</td>
							<td>Nom</td>
							<td>Responsable</td>
							<td>&nbsp;</td>
						</tr>
<%
		for (int i =0; i < vOrganigramNode.size(); i++)
		{
			OrganigramNode poste = vOrganigramNode.get(i);
			int j = i % 2;
			String sUrlDisplay = rootPath
					+"desk/organisation/organigramme/modifyOrganisationOrganigramNodeForm.jsp?lIdOrganigramNode="
					+ poste.getId()
					+ "&sAction=store";
	
			PersonnePhysique personne = (PersonnePhysique)
				PersonnePhysique
					.getCoinDatabaseAbstractBeanFromId(
						poste.getIdReferenceObject(), vPersonne);
	
			OrganigramNode posteResp = (OrganigramNode)
				OrganigramNode
					.getCoinDatabaseAbstractBeanFromId(
						poste.getIdOrganigramNodeParent(), vOrganigramNode);
	
			PersonnePhysique personneResp = (PersonnePhysique)
				PersonnePhysique
					.getCoinDatabaseAbstractBeanFromId(
							posteResp.getIdReferenceObject(), vPersonne);

%>
					<tr class="liste<%=j %>"
						onmouseover="className='liste_over'"
						onmouseout="className='liste<%=j %>'"
						onclick="Redirect('<%= response.encodeURL(sUrlDisplay ) %>')">
						<td style="width:25%"><%= poste.getName()%></td>
						<td style="width:15%"><%= personne.getPrenomNom() %></td>
						<td style="width:15%"><%= posteResp.getName() %> : <%= personneResp.getPrenomNom()  %></td>
						<td style="text-align:right;width:5%">
							<a class="image" href="<%= response.encodeURL(sUrlDisplay ) %>">
								<img src="<%=rootPath+"images/icons/default.gif"
								%>" alt="<%= localizeButton.getValueDisplay() 
								%>" title="<%= localizeButton.getValueDisplay() %>"/>
							 </a>
						</td>
					</tr>
<%
		}
%>
					</table>
				</td>
			</tr>
		</table>
		</div>
		</div>

<%
	}
%>