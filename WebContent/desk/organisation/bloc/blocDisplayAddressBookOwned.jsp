<%@page import="org.coin.fr.bean.Organisation"%>
<%@page import="modula.graphic.Icone"%>
<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%@page import="java.util.Vector"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="java.sql.Connection"%>
<%@ include file="/include/new_style/beanSessionUser.jspf" %>
<%@ include file="../pave/localizationObject.jspf" %>
<%
	String rootPath = request.getContextPath() +"/";
	//Vector<Organisation> vOrganisationOwned =  (Vector<Organisation>)request.getAttribute("vOrganisationOwned");
	//Vector<PersonnePhysique> vPersonnePhysiqueOwned =  (Vector<PersonnePhysique>)request.getAttribute("vPersonnePhysiqueOwned");
	long lIdObjectTypeOwner = HttpUtil.parseLong("lIdObjectTypeOwner", request);
	long lIdObjectReferenceOwner = HttpUtil.parseLong("lIdObjectReferenceOwner", request);
	String sBlocTitle = (String) request.getAttribute("sBlocTitle");
	Connection conn = (Connection) request.getAttribute("conn");
	Vector<Organisation> vOrganisationOwned 
	 	= Organisation.getAllByOwner(
	 			lIdObjectTypeOwner,
	 			lIdObjectReferenceOwner,
				conn);
	 
	 Vector<PersonnePhysique> vPersonnePhysiqueOwned 
	 	= PersonnePhysique.getAllByOwner(
	 			lIdObjectTypeOwner,
	 			lIdObjectReferenceOwner,
				conn);

	 Vector<OrganisationType> vOT = OrganisationType.getAllOrganisationType(); 
	 
	 if(vOrganisationOwned.size() > 0 || vPersonnePhysiqueOwned.size() > 0)
	 {
%>

		
<%@page import="org.coin.db.CoinDatabaseLoadException"%>
<%@page import="org.coin.fr.bean.OrganisationType"%><div class="dataGridHolder">
		<table class="dataGrid fullWidth">
			<tr>
				<td><%= sBlocTitle %></td>
			</tr>
			<tr>
				<td>

<%

		if(vOrganisationOwned.size() > 0)
		{
%>

<table class="dataGrid fullWidth">
	<tr class="header">
		<td><%= locBloc.getValue(36,"Organisation") %></td>
		<td>&nbsp;</td>
	</tr>
<%
	
			for(Organisation organisationOwned : vOrganisationOwned)
			{
				OrganisationType ot 
					= OrganisationType.getOrganisationType(
						organisationOwned.getIdOrganisationType(), 
						vOT);
				
%>
	<tr class="liste0">
		<td><%= organisationOwned.getRaisonSociale() 
			+ " - " + ot.getName() %>
		</td>
		<td>
			<img alt="Voir" 
				style="cursor: pointer;"
				src="<%= rootPath + Icone.ICONE_FICHIER_DEFAULT_NEW_STYLE
				%>" onclick="parent.addParentTabForced('...', '<%=
						response.encodeURL(
								rootPath + "desk/organisation/afficherOrganisation.jsp"
								+ "?iIdOrganisation=" + organisationOwned.getId() ) %>');" />
		</td>
	</tr>

<%		
			}
%>
	</table>
	<br/>
<%
		}

		if(vPersonnePhysiqueOwned.size() > 0)
		{
%>
	<table class="dataGrid fullWidth">
		<tr class="header">
			<td><%= locBloc.getValue(6,"Personne") %></td>
			<td>&nbsp;</td>
		</tr>
<%
			for(PersonnePhysique personneOwned : vPersonnePhysiqueOwned)
			{
				String sOrgName = null;
				try{
					Organisation o = Organisation.getOrganisation(personneOwned.getIdOrganisation(), false, conn);
					
					OrganisationType ot 
						= OrganisationType.getOrganisationType(
								o.getIdOrganisationType(), 
								vOT);
					
					sOrgName = o.getName() + " - " + ot.getName() ;
				} catch (Exception e) {
					sOrgName = e.getMessage();
				}
%>
	<tr class="liste0">
		<td><%= personneOwned.getName() %> (<%= sOrgName %>)
		</td>
		<td>
			<img alt="Voir" 
				style="cursor: pointer;"
				src="<%= rootPath + Icone.ICONE_FICHIER_DEFAULT_NEW_STYLE
				%>" onclick="parent.addParentTabForced('...', '<%=
						response.encodeURL(
								rootPath + "desk/organisation/afficherPersonnePhysique.jsp"
								+ "?iIdPersonnePhysique=" + personneOwned.getId() ) %>');" />
		</td>
	</tr>

<%		
		}
%>
</table>
<%
	}
%>
				</td>
			</tr>			
		</table>
		</div>

<%
	}
%>
