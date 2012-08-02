<%@page import="java.util.Vector"%>
<%@page import="org.coin.fr.bean.ObjectGroup"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.fr.bean.ObjectGroupType"%>
<%
	String rootPath = request.getContextPath() +"/";
	Connection conn = (Connection) request.getAttribute("conn");
	Organisation organisation = (Organisation) request.getAttribute("organisation");
	LocalizeButton localizeButton = (LocalizeButton) request.getAttribute("localizeButton");

%>

<%@page import="java.sql.Connection"%>
<%@page import="org.coin.fr.bean.Organisation"%>
<%@page import="org.coin.localization.LocalizeButton"%><div class="right">
	<button
		type="button"
		onclick="javascript:Redirect('<%= response.encodeURL(
		rootPath + "desk/organisation/groupe/modifyOrganisationGroupeForm.jsp?sAction=create"
		+ "&amp;iIdOrganisation=" + organisation.getIdOrganisation()
		) %>')"
		>Ajouter un groupe</button>
	</div>
	<br />
<%
	Vector<ObjectGroup> vOrganisationGroupe
		= ObjectGroup.getAllGroupObjectFromIdGroupTypeAndObjectReference(
			ObjectGroupType.GROUP_ORGANISATION_SERVICE_MEMBRE,
			ObjectType.ORGANISATION,
			organisation.getId());


%>
	<div>
		<%
%>
		<div class="dataGridHolder">
		<table class="dataGrid fullWidth">
			<tr>
				<td> Les groupes : </td>
			</tr>
			<tr>
				<td>
					<table class="dataGrid fullWidth">
						<tr class="header">
							<td>Nom</td>
							<td>Description</td>
							<td>Alias</td>
							<td>Email</td>
							<td>&nbsp;</td>
						</tr>
<%
	for (int i =0; i < vOrganisationGroupe.size(); i++)
	{
		ObjectGroup orgGroupe = vOrganisationGroupe.get(i);
		int j = i % 2;
		String sUrlDisplay = rootPath
				+"desk/organisation/groupe/displayOrganisationGroupe.jsp?lIdObjectGroup="
				+ orgGroupe.getId();

%>
					<tr class="liste<%=j %>"
						onmouseover="className='liste_over'"
						onmouseout="className='liste<%=j %>'"
						onclick="Redirect('<%= response.encodeURL(sUrlDisplay ) %>')">
						<td style="width:25%"><%= orgGroupe.getNom()%></td>
						<td style="width:15%"><%= orgGroupe.getDescription() %></td>
						<td style="width:15%"><%= orgGroupe.getAlias() %></td>
						<td style="width:15%"><%= orgGroupe.getEmail() %></td>
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
