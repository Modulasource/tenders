<%@page import="org.coin.fr.bean.OrganisationService"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="java.util.Vector"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.fr.bean.Organisation"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%@ include file="/include/new_style/beanSessionUser.jspf" %>
<%@ include file="../pave/localizationObject.jspf" %>
<%@page import="org.coin.localization.LocalizeButton"%>

<%
	LocalizeButton localizeButton = null;
	try {
		localizeButton = new LocalizeButton(request);
	}catch (Exception e) {
		e.printStackTrace();
	}

	Connection conn = (Connection) request.getAttribute("conn");
	Organisation organisation = (Organisation) request.getAttribute("organisation");
	PersonnePhysique personne = (PersonnePhysique) request.getAttribute("personne");
	int iIdOnglet = HttpUtil.parseInt("iIdOnglet", request);

	
	Vector<OrganisationService> vOrganisationService = null;
	vOrganisationService 
		= OrganisationService.getAllFromIdOrganisationByOwned(
				organisation.getId(), false, conn);
		 
	long lIdObjectTypeOwner = ObjectType.PERSONNE_PHYSIQUE;
	long lIdObjectReferenceOwner = personne.getId();
	request.setAttribute("sBlocTitle", "Appartiennent à l'organisation");
				
%>

<jsp:include page="blocDisplayAddressBookOwned.jsp">
<jsp:param value="<%= lIdObjectTypeOwner %>" name="lIdObjectTypeOwner"/>
<jsp:param value="<%= lIdObjectReferenceOwner %>" name="lIdObjectReferenceOwner"/>
</jsp:include>
		<br/>



<div >
<%= locBloc.getValue(34,"Lier une organisation") %> :

	<input type="hidden" 
        id="own_lIdObjectReferenceOwnedOrganization" 
        name="own_lIdObjectReferenceOwnedOrganization"  />
	<button type="button" 
        id="AJCL_but_own_lIdObjectReferenceOwnedOrganization" 
        name="AJCL_but_own_lIdObjectReferenceOwnedOrganization"
         ><%=localizeButton.getValueSelect() %></button>				

	
<button type="button"
	id="btnValidOrganizationOwned" 
	onclick="Owner_linkOwnerOrganisation()" 
	style="display: none;" 
	><%=localizeButton.getValueSubmit() %></button>


<br/>
<%= locBloc.getValue(35,"Lier une personne") %> :

	<input type="hidden" 
        id="own_lIdObjectReferenceOwnedIndividual" 
        name="own_lIdObjectReferenceOwnedIndividual"  />
	<button type="button" 
        id="AJCL_but_own_lIdObjectReferenceOwnedIndividual" 
        name="AJCL_but_own_lIdObjectReferenceOwnedIndividual"
         ><%=localizeButton.getValueSelect() %></button>				

	
<button type="button" 
	 id="btnValidIndividualOwned"
	 onclick="Owner_linkOwnerIndividual()" 
	 style="display: none;" ><%= localizeButton.getValueSubmit() %></button>
</div>

<script type="text/javascript">
var g_aclOrganization;
var g_aclIndividual;

var g_urlToOwn = "<%= 
	response.encodeURL("modifierPersonnePhysique.jsp"
			+ "?iIdPersonnePhysique=" + personne.getId()
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