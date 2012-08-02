<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@ page import="org.coin.bean.html.*" %>
<%@ page import="mt.paraph.folder.util.ParaphFolderOrganizationUtil" %>
<% 
	Connection conn = ConnectionManager.getConnection();

	/** Just for localization **/
	Delegation delegationLoc = new Delegation ();
	delegationLoc.setAbstractBeanLocalization(sessionLanguage);

	String sTitle = "Delegation : "; 

    Delegation item = null;
	String sPageUseCaseId = "IHM-DESK-PARAM-HAB-DELEG-2";
	
	boolean bChangeOwner = true;
	boolean bChangeDelegate = true;
	
	String sAction = HttpUtil.parseString("sAction",request,"store");
	boolean bIsPopup = HttpUtil.parseBoolean("bIsPopup",request,false);

	long lIdPersonnePhysiqueOwner = HttpUtil.parseLong("lIdPersonnePhysiqueOwner",request,0);
	String sUrlReturn = "displayAllDelegation.jsp";
	if(lIdPersonnePhysiqueOwner>0){
		sUrlReturn = rootPath+"desk/organisation/afficherPersonnePhysique.jsp?"
				+ "iIdPersonnePhysique="+lIdPersonnePhysiqueOwner
				+ "&iIdOnglet="+Onglet.ONGLET_PERSONNE_PHYSIQUE_DELEGATION;
	}
	
	if(sAction.equals("create"))
	{
		item = new Delegation();
		sTitle += "<span class=\"altColor\">Nouvelle Délégation</span>"; 
	}
	
	if(sAction.equals("store"))
	{
		item = Delegation.getDelegation(Integer.parseInt(request.getParameter("lId")),false,conn);
		lIdPersonnePhysiqueOwner = item.getIdPersonnePhysiqueOwner();
		sTitle += "<span class=\"altColor\">"+item.getId()+"</span>"; 
	}
	if(lIdPersonnePhysiqueOwner>0){
		item.setIdPersonnePhysiqueOwner(lIdPersonnePhysiqueOwner);
		bChangeOwner = false;
	}
	
	int iIdPersonnePhysique = sessionUser.getIdIndividual();
	long lIdOrganisationUser = 0;
	PersonnePhysique ppUser = new PersonnePhysique();
	try{ppUser = PersonnePhysique.getPersonnePhysique(iIdPersonnePhysique);		
	}catch(Exception e){}
	if (ppUser!=null){
		lIdOrganisationUser = ppUser.getIdOrganisation();
	}
	

	
	HtmlBeanTableTrPave pave = new HtmlBeanTableTrPave();
	pave.bIsForm = true;
	
	JSONArray jsonType = DelegationType.getJSONArray(sessionLanguage);
	JSONArray jsonState = DelegationState.getJSONArray(sessionLanguage);
	
	String sURLPersonne = response.encodeURL(
			rootPath+"desk/organisation/afficherPersonnePhysique.jsp?iIdPersonnePhysique=") ;
			
	boolean bAutorizeDisplay = false;
	if(sessionUserHabilitation.isSuperUser() 
	|| sessionUserHabilitation.isHabilitate("IHM-DESK-PARAM-HAB-DELEG-2")
	|| (sessionUserHabilitation.isHabilitate("IHM-DESK-PARAM-HAB-DELEG-6") && sessionUser.getIdIndividual()==item.getIdPersonnePhysiqueDelegate())
	|| (sessionUserHabilitation.isHabilitate("IHM-DESK-PARAM-HAB-DELEG-7") && sessionUser.getIdIndividual()==item.getIdPersonnePhysiqueOwner())){
		bAutorizeDisplay = true;
	}
	if(!bAutorizeDisplay) throw new HabilitationException(sPageUseCaseId, sessionLanguage.getId());
	
	boolean bAuthorizeModify = false;
	if(sessionUserHabilitation.isSuperUser() 
	|| sessionUserHabilitation.isHabilitate("IHM-DESK-PARAM-HAB-DELEG-5")
	|| (sessionUserHabilitation.isHabilitate("IHM-DESK-PARAM-HAB-DELEG-8") && sessionUser.getIdIndividual()==item.getIdPersonnePhysiqueDelegate())
	|| (sessionUserHabilitation.isHabilitate("IHM-DESK-PARAM-HAB-DELEG-9") && sessionUser.getIdIndividual()==item.getIdPersonnePhysiqueOwner())){
		bAuthorizeModify = true;
	}else{
		bChangeDelegate = false;
	}
	
	boolean bAuthorizeCreate = false;
	if(sessionUserHabilitation.isSuperUser() 
	|| sessionUserHabilitation.isHabilitate("IHM-DESK-PARAM-HAB-DELEG-3")
	|| (sessionUserHabilitation.isHabilitate("IHM-DESK-PARAM-HAB-DELEG-12") && sessionUser.getIdIndividual()==item.getIdPersonnePhysiqueDelegate())
	|| (sessionUserHabilitation.isHabilitate("IHM-DESK-PARAM-HAB-DELEG-13") && sessionUser.getIdIndividual()==item.getIdPersonnePhysiqueOwner())){
		bAuthorizeCreate = true;
	}
	
	if(sAction.equals("create")) bAuthorizeModify = bAuthorizeCreate;
	
	boolean bAuthorizeDelete = false;
	if(sessionUserHabilitation.isSuperUser() 
	|| sessionUserHabilitation.isHabilitate("IHM-DESK-PARAM-HAB-DELEG-4")
	|| (sessionUserHabilitation.isHabilitate("IHM-DESK-PARAM-HAB-DELEG-10") && sessionUser.getIdIndividual()==item.getIdPersonnePhysiqueDelegate())
	|| (sessionUserHabilitation.isHabilitate("IHM-DESK-PARAM-HAB-DELEG-11") && sessionUser.getIdIndividual()==item.getIdPersonnePhysiqueOwner())){
		bAuthorizeDelete = true;
	}
%>
<%@ include file="/desk/paraph/folder/include/localization.jspf" %>
<link rel="stylesheet" type="text/css" href="<%=rootPath %>include/component/calendar/calendar.css" media="screen" />
<script type="text/javascript" src="<%=rootPath %>include/component/calendar/calendar.js"></script>
<script type="text/javascript" src="<%= rootPath %>include/AjaxComboList.js?v=<%= JavascriptVersion.AJAX_COMBO_LIST_JS %>"></script>
<script type="text/javascript" src="<%= rootPath %>dwr/interface/OrganigramNodeType.js" ></script>
</head>
<body>
<script type="text/javascript">
mt.config.enableAutoLoading = false;
var g_lIdOrganisationUser = <%= lIdOrganisationUser %>;
function removeItem()
{
    if(confirm("Voulez vous supprimer cette délégation ?")){
    	doUrl("<%= response.encodeURL("modifyDelegation.jsp?sAction=remove&bIsPopup="+bIsPopup+"&lId="+item.getId()+"&lIdPersonnePhysiqueOwnerForced="+lIdPersonnePhysiqueOwner)%>");
     }
}
onPageLoad = function(){
	Element.hide($("ownerLink"));
	Element.hide($("delegateLink"));
	
    $("iIdDelegationType").populate(<%= jsonType %>,<%= item.getIdDelegationType() %>,"lId", "sName");
    $("iIdDelegationState").populate(<%= jsonState %>,<%= item.getIdDelegationState() %>,"lId", "sName");
    var acOwner = new AjaxComboList("lIdPersonnePhysiqueOwner", "getAllPersonnePhysiqueFromIdOrganisation_"+g_lIdOrganisationUser,"right","onSelectOwner();");
    var acDelegate = new AjaxComboList("lIdPersonnePhysiqueDelegate", "getAllPersonnePhysiqueFromIdOrganisation_"+g_lIdOrganisationUser,"right","onSelectDelegate();");

    acOwner.addActionOnChange("onSelectOwner();");
    <% if(item.getIdPersonnePhysiqueOwner()>0){ %>
    acOwner.init(<%= item.getIdPersonnePhysiqueOwner() %>);
    <% } %>

    acDelegate.addActionOnChange("onSelectDelegate();");
    <% if(item.getIdPersonnePhysiqueDelegate()>0){ %>
    acDelegate.init(<%= item.getIdPersonnePhysiqueDelegate() %>);
    <% } %>

    $("iIdDelegationType").onchange = function(){
    	Element.hide($("sSignTemplate_table"));
    	$("sSignTemplateHidden").name = "sSignTemplate";
    	Element.hide($("delegation_statut_table"));
    	$("delegation_statut_<%= Delegation.ID_STATUT_PRIVATE %>_hidden").name = "delegation_statut_<%= Delegation.ID_STATUT_PRIVATE %>";
    	
    	
		if(this.value==<%= DelegationType.TYPE_PP%>){
			Element.show($("sSignTemplate_table"));
			$("sSignTemplateHidden").name = "sSignTemplateHidden";
			updateDelegatePoste();
		}

		if(this.value==<%= DelegationType.TYPE_PP%> || this.value==<%= DelegationType.TYPE_READ%>){
			Element.show($("delegation_statut_table"));
	    	$("delegation_statut_<%= Delegation.ID_STATUT_PRIVATE %>_hidden").name = "delegation_statut_<%= Delegation.ID_STATUT_PRIVATE %>_hidden";
		}
    }
    $("iIdDelegationType").onchange();

    if(<%= !sessionUserHabilitation.isSuperUser() %>){
	    $$(".dataType-checkbox4").each(function(cb){
			cb.onclick = function(span){
				if(this.value != 0 && this.value!=2) {
					span.onclick();
				}
			}
	    });
    }

    
	<% if(sessionUserHabilitation.isSuperUser()
			|| bChangeOwner 
			|| (!bChangeOwner && item.getIdPersonnePhysiqueOwner()!=sessionUser.getIdIndividual())){ %>
			Element.show("owner_table");
	<%}else{%>
		Element.hide("owner_table");
	<%}%>

	<% if(sessionUserHabilitation.isSuperUser()
			|| bChangeDelegate 
			|| (!bChangeDelegate && item.getIdPersonnePhysiqueDelegate()!=sessionUser.getIdIndividual())){ %>
			Element.show("delegate_table_label");
			Element.show("delegate_table_value");
	<%}else{%>
		Element.hide("delegate_table_label");
		Element.hide("delegate_table_value");
	<%}%>
}
function onSelectOwner(){
	var select = $("AJCL_sel_lIdPersonnePhysiqueOwner");
	if(select.options.selectedIndex >= 0){
	    var optionSelected = select.options[select.options.selectedIndex];
	    var optionSelectedObj = optionSelected.obj;
	
		if($("lIdPersonnePhysiqueOwner").value > 0){
		    Element.show($("ownerLink"));
		    $("ownerLink").onclick = function(){
		    	parent.addParentTabForced('Délégataire','<%= sURLPersonne %>'+optionSelectedObj.lId);
		    }
		}else{
			Element.hide($("ownerLink"));
		}
	}else{
		Element.hide($("ownerLink"));
	}
}
var objDelegate;
function onSelectDelegate(){
	var select = $("AJCL_sel_lIdPersonnePhysiqueDelegate");
	if(select.options.selectedIndex >= 0){
	    var optionSelected = select.options[select.options.selectedIndex];
	    var optionSelectedObj = optionSelected.obj;
	    objDelegate = optionSelectedObj;
		if($("lIdPersonnePhysiqueDelegate").value > 0){
		    Element.show($("delegateLink"));
		    $("delegateLink").onclick = function(){
		    	parent.addParentTabForced('Délégué','<%= sURLPersonne %>'+optionSelectedObj.lId);
		    }

		    updateDelegatePoste();
		    
		}else{
			Element.hide($("delegateLink"));
		}
	}else{
		Element.hide($("delegateLink"));
	}
}

function updateDelegatePoste(){
	
	if($("iIdDelegationType").value == <%= DelegationType.TYPE_PP %> && isNotNull(objDelegate)){
	    if(objDelegate.lId != <%= item.getIdPersonnePhysiqueDelegate() %>){
		    OrganigramNodeType.getOrganigramNodeTypeFromIndividual(
		    		objDelegate.lId, 
		    		objDelegate.iIdOrganisation,
				    function(results){
					    var types = results.parseJSON();
					    if(types.length>0){
					    	$("sSignTemplate").value = "<%= DelegationType.getDelegationTypeMemoryLocalized(DelegationType.TYPE_PP,sessionLanguage.getId()).getName() %>";
					    							+" ";
						    //							+ " le " + types[0];
					    }
					}
			);
	    }else{
	    	$("sSignTemplate").value = "<%= item.getSignTemplate() %>";
	    }
    }
}
</script>
<style>
.col_label{
	padding:5px 5px 5px 0;
	font-weight:bold;
}
.col_value{
	padding:5px;
}
</style>
<% if(!bIsPopup){ %>
<%@ include file="../../../../../include/new_style/headerFiche.jspf" %>
<%}else{ %>
<div style="padding:5px;">
<%} %>
<form action="<%= response.encodeURL("modifyDelegation.jsp") %>" method="post" name="formulaire" id="formulaire" class="validate-fields">
<div id="fiche">
        <input type="hidden" name="lId" value="<%= item.getId() %>" />
        <input type="hidden" name="bIsPopup" value="<%= bIsPopup %>" />
		<input type="hidden" name="sAction" value="<%= sAction %>" />
		<input type="hidden" name="sSignTemplateHidden" id="sSignTemplateHidden" value="" />
		<input type="hidden" name="delegation_statut_<%= Delegation.ID_STATUT_PRIVATE %>_hidden" id="delegation_statut_<%= Delegation.ID_STATUT_PRIVATE %>_hidden" value="<%= BitField.VALUE_TRUE %>" />
		<input type="hidden" name="lIdPersonnePhysiqueOwnerForced" value="<%= lIdPersonnePhysiqueOwner %>" />
		<table cellspacing="3">
			<tr id="owner_table">
				<td class="col_label"><%=delegationLoc.getIdPersonnePhysiqueOwnerLabel() %> :</td>
				<td class="col_value">
					<button type="button" id="AJCL_but_lIdPersonnePhysiqueOwner" <%= (!bChangeOwner)?"disabled='disabled'":"" %>
					class="<%= CSS.DESIGN_CSS_MANDATORY_CLASS %>" ><%=locButton.getValue (102, "Choisir Délégataire") %></button>
					<input class="dataType-notNull dataType-id dataType-integer" type="hidden" id="lIdPersonnePhysiqueOwner" 
						name="lIdPersonnePhysiqueOwner" value="<%= item.getIdPersonnePhysiqueOwner() %>" />
					<img style="cursor:pointer" src="<%= rootPath %>images/icons/user_go.gif" id="ownerLink" />
				</td>
			</tr>
			<tr id="delegate_table">
				<td id="delegate_table_label" class="col_label"><%=delegationLoc.getIdPersonnePhysiqueDelegateLabel() %> :</td>
				<td id="delegate_table_value" class="col_value">
					<button type="button" id="AJCL_but_lIdPersonnePhysiqueDelegate" <%= (!bChangeDelegate)?"disabled='disabled'":"" %>
					class="<%= CSS.DESIGN_CSS_MANDATORY_CLASS %>" ><%=locButton.getValue (101, "Choisir Délégué") %></button>
					<input class="dataType-notNull dataType-id dataType-integer" type="hidden" id="lIdPersonnePhysiqueDelegate" 
						name="lIdPersonnePhysiqueDelegate" value="<%= item.getIdPersonnePhysiqueDelegate() %>" />
					<img style="cursor:pointer" src="<%= rootPath %>images/icons/user_go.gif" id="delegateLink" />
				</td>
				<td class="col_label"><%=delegationLoc.getIdDelegationTypeLabel() %> :</td>
                <td class="col_value"><select class="dataType-notNull dataType-id dataType-integer" id="iIdDelegationType" name="iIdDelegationType"></select></td>
				<td class="col_label"><%=delegationLoc.getIdDelegationStateLabel() %> :</td>
                <td class="col_value"><select class="dataType-notNull dataType-id dataType-integer" id="iIdDelegationState" name="iIdDelegationState"></select></td>
			</tr>
		</table>

		<table cellspacing="3">
			<tr>
				<td class="col_label"><%=delegationLoc.getStartLabel() %> :</td>
	            <td class="col_value"><input type="text" class="dataType-date" id="tsDateStart" name="tsDateStart" value="<%= CalendarUtil.getDateCourte(item.getDateStart()) %>" /></td>
	            <td class="col_label"><%=delegationLoc.getEndLabel() %> :</td>
	            <td class="col_value"><input type="text" class="dataType-date" id="tsDateEnd" name="tsDateEnd" value="<%= CalendarUtil.getDateCourte(item.getDateEnd()) %>" /></td>
			</tr>
		</table>

		<table cellspacing="3" id="sSignTemplate_table">	
			<tr>
				<td class="col_label"><%=locTitle.getValue (228, "Mention de signature") %> :</td>
		        <td class="col_value"><input type="text" size="80" id="sSignTemplate" name="sSignTemplate" value="<%= item.getSignTemplate() %>" /></td>
		    </tr>
		</table>	

		<table cellspacing="3" id="delegation_statut_table" >	
			<tr>
                <td class="col_label"><%=locTitle.getValue (229, "Privé (cacher Mes Documents))") %> :</td>
                <td class="col_value"><input name="delegation_statut_<%= Delegation.ID_STATUT_PRIVATE %>" 
                type="checkbox" <%= item.isPrivate(false)?"checked=\"checked\"":"" %> 
                value="<%= BitField.VALUE_TRUE %>" /></td>
            </tr>
        </table>
        
        <table cellspacing="3"> 
            <tr>
                <td class="col_label"><%=locTitle.getValue (230, "Mettre en copie des notifications le délégataire") %> :</td>
                <td class="col_value"><input name="delegation_statut_<%= Delegation.ID_STATUT_DELEGATOR_IN_COPY_OF_NOTIFICATIONS %>" 
                    type="checkbox" <%= item.isDelegatorInCopyOfNotifications(false)?"checked=\"checked\"":"" %> 
                    value="<%= BitField.VALUE_TRUE %>" />
                </td>
            </tr>
        </table>
        <%
        Vector<DelegationObject> vDelegationObject = DelegationObject.getAllFromDelegation(item.getId(),false,null);
    	PersonnePhysique person = PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual(),true,conn);
    	ParaphFolderHabilitation paraphFolderHabilitation 
    	= new ParaphFolderHabilitation(
    			response,
    			person,
    			-1,
    			conn);
    	Vector<ParaphFolderType> vParaphFolderTypeInternal = ParaphFolderType.getAllParaphFolderTypeFromGroup(ParaphFolderType.GROUP_INTERNAL, paraphFolderHabilitation);
    	Vector<ParaphFolderType> vParaphFolderTypeIn = ParaphFolderType.getAllParaphFolderTypeFromGroup(ParaphFolderType.GROUP_IN, paraphFolderHabilitation);
    	Vector<ParaphFolderType> vParaphFolderTypeOut = ParaphFolderType.getAllParaphFolderTypeFromGroup(ParaphFolderType.GROUP_OUT, paraphFolderHabilitation);
    	
    	/** For Internal Validation **/
    	if (!ParaphFolderType.contains (vParaphFolderTypeInternal, ParaphFolderType.TYPE_INTERNAL_VALIDATION)
    	&& ParaphFolderOrganizationUtil.isInternalValidationEnabled (sessionUser.getOrganisation().getIdOrganisation(), conn))
    		vParaphFolderTypeInternal.add (ParaphFolderType.getParaphFolderTypeMemory(ParaphFolderType.TYPE_INTERNAL_VALIDATION));
        
    	/**
    	 * V3.0.2 patch Bug 3462  - MQB 110 - Délégation impossible pour les circuits persos (No delegation for personnal wf)
    	 */
    	//vParaphFolderTypeInternal.add(ParaphFolderType.getParaphFolderType(ParaphFolderType.TYPE_INTERNAL_VALIDATION));
        
        %>

        <table cellspacing="3">
			<tr>
			<% if(!vParaphFolderTypeInternal.isEmpty()){ %>
			<td class="col_label"><%=locTitle.getValue(157,"Documents internes")%></td>
			<%} %>
			<% if(!vParaphFolderTypeOut.isEmpty()){ %>
			<td class="col_label"><%=locTitle.getValue(158,"Documents sortants")%></td>
			<%} %>
			<% if(!vParaphFolderTypeIn.isEmpty()){ %>
			<td class="col_label"><%=locTitle.getValue(167,"Documents entrants") %></td>
			<%} %>
			</tr>
			<tr>
				<% if(!vParaphFolderTypeInternal.isEmpty()){ %>
				<td style="vertical-align:top;padding:5px 5px 0 0;">
				<%
				for(ParaphFolderType type : vParaphFolderTypeInternal )
				{
					type.setAbstractBeanLocalization(sessionLanguage);
					long lTypeValue = 0;
                	for(DelegationObject obj : vDelegationObject){
                		if(obj.getIdTypeObject()==ObjectType.PARAPH_FOLDER_TYPE
                		&& obj.getIdReferenceObject()==type.getId()){
                			lTypeValue = obj.getIdDelegationObjectType();
                		}
                	}
				%>
				<div style="margin-bottom:3px;">
					<input id="delegation_object_<%= type.getId() %>" 
                           type="hidden"
                           name="delegation_object_<%= type.getId() %>" 
                           value="<%= lTypeValue %>"
                           class="dataType-checkbox4"/>&nbsp;<%= type.getName() %></div>
				<%	
				}
				%>
				</td>
				<%} %>
				<% if(!vParaphFolderTypeOut.isEmpty()){ %>
				<td style="vertical-align:top;padding:5px 5px 0 0;">
				<%
				for(ParaphFolderType type : vParaphFolderTypeOut )
				{
					type.setAbstractBeanLocalization(sessionLanguage);
					long lTypeValue = 0;
                	for(DelegationObject obj : vDelegationObject){
                		if(obj.getIdTypeObject()==ObjectType.PARAPH_FOLDER_TYPE
                		&& obj.getIdReferenceObject()==type.getId()){
                			lTypeValue = obj.getIdDelegationObjectType();
                		}
                	}
				%>
				<div style="margin-bottom:3px;">
					<input id="delegation_object_<%= type.getId() %>" 
                           type="hidden"
                           name="delegation_object_<%= type.getId() %>" 
                           value="<%= lTypeValue %>"
                           class="dataType-checkbox4"/>&nbsp;<%= type.getName() %></div>
				<%	
				}
				%>
				</td>
				<%} %>
				<% if(!vParaphFolderTypeIn.isEmpty()){ %>
				<td style="vertical-align:top;padding:5px 5px 0 0;">
				<%
				for(ParaphFolderType type : vParaphFolderTypeIn )
				{
					type.setAbstractBeanLocalization(sessionLanguage);
					long lTypeValue = 0;
                	for(DelegationObject obj : vDelegationObject){
                		if(obj.getIdTypeObject()==ObjectType.PARAPH_FOLDER_TYPE
                		&& obj.getIdReferenceObject()==type.getId()){
                			lTypeValue = obj.getIdDelegationObjectType();
                		}
                	}
				%>
				 <div style="margin-bottom:3px;">
					<input id="delegation_object_<%= type.getId() %>" 
                           type="hidden"
                           name="delegation_object_<%= type.getId() %>" 
                           value="<%= lTypeValue %>"
                           class="dataType-checkbox4"/>&nbsp;<%= type.getName() %></div>
				<%	
				}
				%>
				</td>
				<%} %>
			</tr>
		</table>
		<% if(sessionUserHabilitation.isSuperUser()){ %>
		<br/>
	<div>
	    <img src="<%= rootPath+"images/check_empty.png" %>" /> : unselected<br/>
		<img src="<%= rootPath+"images/check_checked.png" %>" /> : READ<br/>
		<img src="<%= rootPath+"images/check_full.png" %>" /> : WRITE<br/>
		<img src="<%= rootPath+"images/check_full_2.png" %>" /> : EXECUTE<br/>
	</div>
	<%} %>
</div>
<div id="fiche_footer">
	<%if(bAuthorizeModify){%>
	<button type="submit" ><%= localizeButton.getValueSubmit() %></button>
	<%}%>
	<%if(sAction.equals("store") && bAuthorizeDelete){ %>
	<button type="button" onclick="javascript:removeItem();">
			<%= localizeButton.getValueDelete() %></button>
	<%}%>
	<% if(!bIsPopup){ %>
	<button type="button" onclick="javascript:doUrl('<%=
			response.encodeURL(sUrlReturn) %>');" >
			<%= localizeButton.getValueCancel() %></button>
	<%} %>
	
</div>
</form>
<% if(!bIsPopup){ %>
<%@ include file="../../../../../include/new_style/footerFiche.jspf" %>
<%} else{%>
</div>
<%} %>
</body>
<%
	ConnectionManager.closeConnection(conn);
%>
<%@page import="mt.veolia.vfr.vehicle.VehicleType"%>
<%@page import="org.json.JSONArray"%>
<%@page import="mt.veolia.vfr.vehicle.VehicleBodyType"%>

<%@page import="org.coin.fr.bean.Delegation"%>
<%@page import="org.coin.fr.bean.DelegationType"%>

<%@page import="org.coin.util.CalendarUtil"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.util.BitField"%>
<%@page import="mt.paraph.folder.ParaphFolderType"%>
<%@page import="java.util.Vector"%>
<%@page import="org.coin.fr.bean.DelegationObjectType"%>
<%@page import="org.coin.fr.bean.DelegationObject"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.security.HabilitationException"%>
<%@page import="org.coin.fr.bean.DelegationState"%>
<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="mt.paraph.folder.util.ParaphFolderHabilitation"%>
<%@page import="org.coin.bean.organigram.OrganigramNode"%>
<%@page import="org.coin.fr.bean.OrganisationService"%>
<%@page import="org.coin.bean.organigram.OrganigramNodeType"%>
<%@page import="org.coin.db.CoinDatabaseLoadException"%>
<%@page import="org.coin.bean.organigram.Organigram"%>
</html>
