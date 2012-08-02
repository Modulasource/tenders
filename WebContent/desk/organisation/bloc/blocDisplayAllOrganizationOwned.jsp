<%@page import="org.coin.fr.bean.OrganisationService"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="java.util.Vector"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.fr.bean.Organisation"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%
	String rootPath = request.getContextPath() +"/";
	Connection conn = (Connection) request.getAttribute("conn");
	Organisation organisation = (Organisation) request.getAttribute("organisation");
	int iIdOnglet = HttpUtil.parseInt("iIdOnglet", request);

	
	Vector<OrganisationService> vOrganisationService 
		= OrganisationService.getAllFromIdOrganisationByOwned(
				organisation.getId(), false, conn);
	
	Vector<PersonnePhysique> vPersonnePhysique 
			= PersonnePhysique.getAllFromIdOrganisation(
					(int)organisation.getId(), false, conn);
		
		 
	long lIdObjectTypeOwner = ObjectType.ORGANISATION;
	long lIdObjectReferenceOwner = organisation.getId();
	request.setAttribute("sBlocTitle", "Appartiennent à l'organisation");
				
%>


<div style="font-weight: bold;">
De l'organisation
</div>
<jsp:include page="blocDisplayAddressBookOwned.jsp">
<jsp:param value="<%= lIdObjectTypeOwner %>" name="lIdObjectTypeOwner"/>
<jsp:param value="<%= lIdObjectReferenceOwner %>" name="lIdObjectReferenceOwner"/>
</jsp:include>
		<br/>

<div style="font-weight: bold;">
Des services
</div>

<%

	for(OrganisationService service : vOrganisationService)
	{
		lIdObjectTypeOwner = ObjectType.ORGANISATION_SERVICE;
		lIdObjectReferenceOwner = service.getId();
		request.setAttribute("sBlocTitle", 
				"Appartiennent au service "
				+ "<a href='javascript:void(0)' "
				+ " onclick=\"parent.addParentTabForced('...', '" 
					+ response.encodeURL(
							rootPath + "desk/organisation/groupe/displayOrganisationService.jsp"
							+ "?lIdOrganisationService=" + service.getId())
					+ "');\" >"
				+ service.getName()
				+ "</a>"
				);

%>
<jsp:include page="blocDisplayAddressBookOwned.jsp">
<jsp:param value="<%= lIdObjectTypeOwner %>" name="lIdObjectTypeOwner"/>
<jsp:param value="<%= lIdObjectReferenceOwner %>" name="lIdObjectReferenceOwner"/>
</jsp:include>
		<br/>

<div style="font-weight: bold;">
Des personnes
</div>

<% 		
	}

	for(PersonnePhysique pp : vPersonnePhysique)
	{
		lIdObjectTypeOwner = ObjectType.PERSONNE_PHYSIQUE;
		lIdObjectReferenceOwner = pp.getId();
		//request.setAttribute("sBlocTitle", "Appartiennent à la personne " + pp.getName());

		request.setAttribute("sBlocTitle", 
				"Appartiennent à la personne "
				+ "<a href='javascript:void(0)' "
				+ " onclick=\"parent.addParentTabForced('...', '" 
					+ response.encodeURL(
							rootPath + "desk/organisation/afficherPersonnePhysique.jsp"
							+ "?iIdPersonnePhysique=" + pp.getId())
					+ "');\" >"
				+ pp.getName()
				+ "</a>"
				);
%>
<jsp:include page="blocDisplayAddressBookOwned.jsp">
<jsp:param value="<%= lIdObjectTypeOwner %>" name="lIdObjectTypeOwner"/>
<jsp:param value="<%= lIdObjectReferenceOwner %>" name="lIdObjectReferenceOwner"/>
</jsp:include>


<% 		
	}
%>


<div >
Lier une organisation :

	<input type="hidden" 
        id="own_lIdObjectReferenceOwnedOrganization" 
        name="own_lIdObjectReferenceOwnedOrganization"  />
	<button type="button" 
        id="AJCL_but_own_lIdObjectReferenceOwnedOrganization" 
        name="AJCL_but_own_lIdObjectReferenceOwnedOrganization"
         ><%= "Sélectionner" %></button>				

	
<button type="button"
	id="btnValidOrganizationOwned" 
	onclick="Owner_linkOwnerOrganisation()" 
	style="display: none;" 
	>Valider</button>


<br/>
Lier une personne :

	<input type="hidden" 
        id="own_lIdObjectReferenceOwnedIndividual" 
        name="own_lIdObjectReferenceOwnedIndividual"  />
	<button type="button" 
        id="AJCL_but_own_lIdObjectReferenceOwnedIndividual" 
        name="AJCL_but_own_lIdObjectReferenceOwnedIndividual"
         ><%= "Sélectionner" %></button>				

	
<button type="button" 
	 id="btnValidIndividualOwned"
	 onclick="Owner_linkOwnerIndividual()" 
	 style="display: none;" >Valider</button>
</div>

<script type="text/javascript">
var g_aclOrganization;
var g_aclIndividual;

var g_urlToOwn = "<%= 
	response.encodeURL("modifierOrganisation.jsp"
			+ "?iIdOrganisation=" + organisation.getId()
			+ "&iIdOnglet=" + iIdOnglet
			) %>";

/**
 * TODO : 
 */
function Owner_detachOwnerOrganisation()
{
	
}

function Owner_linkOwnerOrganisation()
{
	var id = $("own_lIdObjectReferenceOwnedOrganization").value;
	
	doUrl(g_urlToOwn 
			+ "&sAction=linkOwner"
			+ "&own_lIdObjectReferenceOwned=" + id
			+ "&own_lIdObjectTypeOwned=<%= ObjectType.ORGANISATION %>" );
}

function Owner_linkOwnerIndividual()
{
	var id = $("own_lIdObjectReferenceOwnedIndividual").value;
	
	doUrl(g_urlToOwn 
			+ "&sAction=linkOwner"
			+ "&own_lIdObjectReferenceOwned=" + id
			+ "&own_lIdObjectTypeOwned=<%= ObjectType.PERSONNE_PHYSIQUE %>" );
}



function Owner_populateOwnerOrganization()
{
	Element.show("btnValidOrganizationOwned");
}

function Owner_populateOwnerIndividual()
{
	Element.show("btnValidIndividualOwned");
}


Event.observe(window,"load",function(){
	
	g_aclOrganization = new AjaxComboList(
			"own_lIdObjectReferenceOwnedOrganization", 
			"getRaisonSociale",
			"right",
			"Owner_populateOwnerOrganization()",
			true);

	g_aclIndividual
	 = new AjaxComboList(
		"own_lIdObjectReferenceOwnedIndividual", 
		"getPersonnePhysiqueAllTypeWithOrg",
		"right",
		"Owner_populateOwnerIndividual()",
		true);
});

</script>