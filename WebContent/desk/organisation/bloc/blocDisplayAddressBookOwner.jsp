<%@page import="mt.common.addressbook.AddressBookOwner"%>
<%@page import="org.coin.bean.ObjectType"%>
<%
	AddressBookOwner addressBookOwner = (AddressBookOwner )request.getAttribute("addressBookOwner");	
		
%>
			<input type="hidden" 
			        id="lIdObjectReferenceOwner" 
			        name="lIdObjectReferenceOwner"
			        value="<%= addressBookOwner.lIdObjectReferenceOwner %>" />
			
			<input type="radio" name="lIdObjectTypeOwner"  
				onclick="Owner_updateOwnerType(this);"
				value="<%= ObjectType.ORGANISATION %>" 
				<%= addressBookOwner.sOrganizationOwnerCheckbox %> 
				/> <%= addressBookOwner.otOrganization.getName() %> 
				<input type="hidden" 
			        id="lIdObjectReferenceOwnerOrganization" 
			        name="lIdObjectReferenceOwnerOrganization"
			        value="<%= addressBookOwner.lIdOrganizationOwner %>" />
			    <span id="spanObjectReferenceOwnerOrganizationName" style="display: none;font-weight: bold;" >
			    <%= addressBookOwner.sOrganizationOwnerName %> 
			    </span>
				<span id="spanObjectReferenceOwnerOrganization" > 
					<button type="button" 
				        id="AJCL_but_lIdObjectReferenceOwnerOrganization" 
				        name="AJCL_but_lIdObjectReferenceOwnerOrganization"
				         ><%= addressBookOwner.sOrganizationOwnerName %></button>				
				</span>
				<br/>
				
			<input type="radio" name="lIdObjectTypeOwner"  
				onclick="Owner_updateOwnerType(this);"
				value="<%= ObjectType.ORGANISATION_SERVICE %>" 
				<%= addressBookOwner.sOrganizationServiceOwnerCheckbox %>
				/> <%= addressBookOwner.otService.getName() %>
				<input type="hidden" 
			        id="lIdObjectReferenceOwnerOrganizationService" 
			        name="lIdObjectReferenceOwnerOrganizationService" />
				<span id="spanObjectReferenceOwnerOrganizationService" > 
					<button type="button" 
				        id="AJCL_but_lIdObjectReferenceOwnerOrganizationService" 
				        name="AJCL_but_lIdObjectReferenceOwnerOrganizationService"
				         ><%= addressBookOwner.sOrganizationServiceOwnerName %></button>		
			    </span>		
 				<br/>

			<input type="radio" name="lIdObjectTypeOwner"  
				onclick="Owner_updateOwnerType(this);"
				value="<%= ObjectType.PERSONNE_PHYSIQUE %>" 
			        <%= addressBookOwner.sIndividualOwnerCheckbox %>
			        /> <%= addressBookOwner.otIndividual.getName() %> 
				<input type="hidden" 
			        id="lIdObjectReferenceOwnerIndividual" 
			        name="lIdObjectReferenceOwnerIndividual" />

				<span id="spanObjectReferenceOwnerIndividual" > 
					<button type="button" 
				        id="AJCL_but_lIdObjectReferenceOwnerIndividual" 
				        name="AJCL_but_lIdObjectReferenceOwnerIndividual"
				         ><%= addressBookOwner.sIndividualOwnerName %></button>			
			    </span>	
				<br/>


<script type="text/javascript">
<!--
var g_aclOrganization;
var g_aclOrganizationService;
var g_aclIndividual;

Event.observe(window,"load",function(){
	
	g_aclOrganization = new AjaxComboList(
			"lIdObjectReferenceOwnerOrganization", 
			"getRaisonSociale",
			"right",
			"Owner_populateOwnerOrganization()",
			true);


	
	g_aclOrganizationService
		 = new AjaxComboList(
			"lIdObjectReferenceOwnerOrganizationService", 
			"getOrganisationServiceFromName",
			"right",
			"Owner_populateOwnerOrganizationService()",
			true);
	g_aclOrganizationService.sFocedId=<%= addressBookOwner.lIdOrganizationOwner %>;
	g_aclOrganizationService.createHTML();
	
	g_aclIndividual
		 = new AjaxComboList(
			"lIdObjectReferenceOwnerIndividual", 
			"getPersonnePhysiqueAllTypeWithOrgIdForced",
			"right",
			"Owner_populateOwnerIndividual()",
			true);
	g_aclIndividual.sFocedId=<%= addressBookOwner.lIdOrganizationOwner %>;
	g_aclIndividual.createHTML();



	Owner_updateOwnerTypeId("<%= addressBookOwner.lIdObjectTypeOwner %>");
});


function Owner_populateOwnerOrganization()
{
	var id = $("lIdObjectReferenceOwnerOrganization").value;
	$("lIdObjectReferenceOwner").value = id;
	$("spanObjectReferenceOwnerOrganizationName").innerHTML 
		= $("AJCL_but_lIdObjectReferenceOwnerOrganization").innerHTML;
	
	g_aclOrganizationService.sFocedId=id;
	g_aclOrganizationService.createHTML();
	g_aclIndividual.sFocedId=id;
	g_aclIndividual.createHTML();
}

function Owner_populateOwnerOrganizationService()
{
	var id = $("lIdObjectReferenceOwnerOrganizationService").value;
	$("lIdObjectReferenceOwner").value = id;


}


function Owner_populateOwnerIndividual()
{
	$("lIdObjectReferenceOwner").value = $("lIdObjectReferenceOwnerIndividual").value;
}

function Owner_updateOwnerType(item)
{
	Owner_updateOwnerTypeId(item.value);
}

function Owner_updateOwnerTypeId(id)
{
	switch(id)
	{
	case "<%= ObjectType.ORGANISATION %>" :
		Element.show("spanObjectReferenceOwnerOrganization");
		Element.hide("spanObjectReferenceOwnerOrganizationName");
		Element.hide("spanObjectReferenceOwnerOrganizationService");
		Element.hide("spanObjectReferenceOwnerIndividual");
		Owner_populateOwnerOrganization();
		break;
	case "<%= ObjectType.ORGANISATION_SERVICE %>" :
		Element.hide("spanObjectReferenceOwnerOrganization");
		Element.show("spanObjectReferenceOwnerOrganizationName");
		Element.show("spanObjectReferenceOwnerOrganizationService");
		Element.hide("spanObjectReferenceOwnerIndividual");
		Owner_populateOwnerOrganizationService();
		break;
	case "<%= ObjectType.PERSONNE_PHYSIQUE %>" :
		Element.hide("spanObjectReferenceOwnerOrganization");
		Element.show("spanObjectReferenceOwnerOrganizationName");
		Element.hide("spanObjectReferenceOwnerOrganizationService");
		Element.show("spanObjectReferenceOwnerIndividual");
		Owner_populateOwnerIndividual();
		break;
	default:
		Element.hide("spanObjectReferenceOwnerOrganization");
		Element.hide("spanObjectReferenceOwnerOrganizationName");
		Element.hide("spanObjectReferenceOwnerOrganizationService");
		Element.hide("spanObjectReferenceOwnerIndividual");
		break;
	}
}

//-->
</script>
		