<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@ page import="org.coin.bean.*,org.coin.fr.bean.*,java.util.*,modula.graphic.*,modula.*,org.coin.util.treeview.*" %>
<%@page import="org.coin.db.CoinDatabaseLoadException"%>
<%@page import="org.coin.bean.conf.Treeview"%>
<%@page import="org.coin.ui.Border"%>
<%@page import="org.coin.util.CalendarUtil"%>
<%@page import="mt.common.addressbook.habilitation.DisplayIndividualHabilitation"%>
<%@page import="org.coin.db.CoinDatabaseUtil"%>
<%@page import="org.coin.util.Outils"%>
<%@page import="org.coin.bean.html.HtmlBeanTableTrPave"%>
<%@page import="mt.modula.JavascriptVersionModula"%>
<%@page import="org.coin.db.CoinDatabaseAbstractBeanComparator"%>
<%@page import="org.coin.bean.organigram.OrganigramNode"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="org.coin.bean.organigram.OrganigramNodeType"%>
<%@page import="org.coin.bean.organigram.OrganigramNodeTypeIndividual"%>
<%@page import="org.coin.bean.organigram.Organigram"%>
<%@page import="java.sql.SQLException"%>
<%@ include file="include/localization.jspf" %>
<%
	int iIdUser ;
	String sIdUser ;
	String sSelected ;
	Connection conn = ConnectionManager.getConnection();
	request.setAttribute("conn", conn);
	
	iIdUser = Integer.parseInt( request.getParameter("iIdUser") );

	User user = User.getUser(iIdUser, false, conn);
	user.setAbstractBeanLocalization(sessionLanguage);
	
	CoinUserAccessModuleType accessType = null;
	if(user.getIdCoinUserAccessModuleType()>0){
		try {
			accessType = CoinUserAccessModuleType.getCoinUserAccessModuleTypeMemory(
					user.getIdCoinUserAccessModuleType());
		} catch (CoinDatabaseLoadException e ){}
		catch (SQLException se ){
			/** no user acces module in db */
			accessType = new CoinUserAccessModuleType();
		}
	}else{
		accessType = new CoinUserAccessModuleType();
	}

	
	PersonnePhysique personne = PersonnePhysique.getPersonnePhysique(user.getIdIndividual(), false, conn);
	personne.setAbstractBeanLocalization(sessionLanguage);
	
	Adresse adrPersonne = Adresse.getAdresse(personne.getIdAdresse(), false, conn);
	adrPersonne.setAbstractBeanLocalization(sessionLanguage);
	Organisation orga = Organisation .getOrganisation(personne.getIdOrganisation(), false, conn);
	orga.setAbstractBeanLocalization(sessionLanguage);
	
	Vector<Group> vGroupAll = new Vector<Group>();
	Vector<Group> vGroup = UserGroup.getAllGroup(iIdUser);
	CoinDatabaseUtil.merge(vGroup,vGroupAll);
	Vector<Group> vGroupManageable = sessionUserHabilitation.getGroupsManageable();
	CoinDatabaseUtil.merge(vGroupManageable,vGroupAll);
	Collections.sort( vGroupAll , new CoinDatabaseAbstractBeanComparator(CoinDatabaseAbstractBeanComparator.ORDERBY_LEXICOGRAPHIC_NAME_ASCENDING));
	
	Vector<Group> vUserGroupManageable = UserGroup.getAllGroup(iIdUser,CoinUserGroupType.TYPE_MANAGEABLE);
	
	String sAction = "store";
	
    DisplayIndividualHabilitation dih = new DisplayIndividualHabilitation();
    PersonnePhysique personneLogue = PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual() );
    dih.update(personne, orga, personneLogue);
	
	String sUseCaseIdModifier = "IHM-DESK-PERS-23";
	if(!sessionUserHabilitation.isHabilitate(sUseCaseIdModifier) )
	{
		sUseCaseIdModifier = "IHM-DESK-PERS-22";
	}

	String sTitle = personne.getNomPrenom(); 
	Habilitation habLoc = new Habilitation();
	habLoc.setAbstractBeanLocalization(sessionLanguage);
	
	
	Vector<OrganigramNode> vOrganigramNode = new Vector<OrganigramNode>();
	try{
		vOrganigramNode = OrganisationService.getAllOrganigramNodeFromIndividual(
				orga.getId(), 
				user.getIdIndividual(), 
				conn);
	}catch(SQLException e){}

%>
<link rel="stylesheet" type="text/css" href="<%=rootPath %>include/component/calendar/calendar.css" media="screen" />
<script type="text/javascript" src="<%= rootPath %>include/component/calendar/calendar.js"></script>
<script type="text/javascript" src="<%=rootPath%>include/cacherDivision.js"></script>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/UserGroup.js"></script>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/TreeviewHabilitationUser.js"></script>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/UserUsecase.js"></script>
<script type="text/javascript" src="<%= rootPath %>include/verification.js" ></script>
<script type="text/javascript" src="<%= rootPath %>dwr/interface/CheckAjaxVerifField.js"></script>
<script type="text/javascript" src="<%= rootPath %>include/AjaxVerifField.js?v=<%= JavascriptVersionModula.VERIF_FIELD %>" ></script>
<script>
mt.config.enableAutoRoundPave = false;
mt.config.enableTabs = true;

var updateGroup = false;
function onSelectGroup(){
	if(!updateGroup){
		updateGroup = true;
		$("tabTitleGroup").innerHTML += ' <img class="updateHabilitateGroup" style="cursor:pointer;vertical-align:middle;" onclick="updateGroupSelect()" src="<%= rootPath %>images/icons/refresh.gif" />';
	}
}
function updateGroupSelect(){
	var arrGroupHabil = new Array();
	$$("#tableGroup input").each(function(input){
		if(input.name.substring(0, "cb_group_habil_".length) == "cb_group_habil_"){
			var groupHabil = new Object();
			groupHabil.id = input.name.substring("cb_group_habil_".length, input.name.length);
			groupHabil.value = input.value;
			arrGroupHabil.push(groupHabil);
		}
	});
	UserGroup.updateHabilitate(<%= iIdUser %>,Object.toJSON(arrGroupHabil),function(){

		var arrGroupManage = new Array();
		$$("#tableGroup input").each(function(input){
			if(input.name.substring(0, "cb_group_manage_".length) == "cb_group_manage_"){
				var groupManage = new Object();
				groupManage.id = input.name.substring("cb_group_manage_".length, input.name.length);
				groupManage.value = input.value;
				arrGroupManage.push(groupManage);
			}
		});
		UserGroup.updateManageable(<%= iIdUser %>,Object.toJSON(arrGroupManage),function(){
			$("tabTitleGroup").innerHTML = "Groupes";
			updateGroup = false;
			location.href = "<%= response.encodeURL("afficherUtilisateurGroupe.jsp?iIdUser="+user.getId())%>";
		});
	});
}
var updateTreeview = false;
function selectBranch(id, force){
    disableOnClick = true;
    var cb = $(id);
    if(isNotNull(force))
        cb.value = force;
        
    $$("."+id).each(function(cbItem,index){
         cbItem.value = cb.value;
         selectBranch(cbItem.id,force);
    });
        
    updateCheckboxMultipleField(cb,3);
    if(!updateTreeview){
    	updateTreeview = true;
    	<% if( sessionUserHabilitation.isHabilitate("IHM-DESK-xxx") ){ %>
    	$("tabTitleTreeview").innerHTML += ' <img class="updateTreeview" style="cursor:pointer;vertical-align:middle;" onclick="updateTreeviewSelect()" src="<%= rootPath %>images/icons/refresh.gif" />';
    	<%} %>
	}
}
function updateTreeviewSelect(){
	var arrTV = new Array();
	$$("#tableTV input").each(function(input){
		if(input.name.substring(0, "cb_tv_".length) == "cb_tv_"){
			var tv = new Object();
			tv.id = input.name.substring("cb_tv_".length, input.name.length);
			tv.value = input.value;
			arrTV.push(tv);
		}
	});
	TreeviewHabilitationUser.updateHabilitate(<%= iIdUser %>,Object.toJSON(arrTV),function(){
		$("tabTitleTreeview").innerHTML = "Treeview";
		updateTreeview = false;
	});
}

var updateUseCase = false;
function onSelectUseCase(){
	if(!updateUseCase){
		updateUseCase = true;
		$("tabTitleUseCase").innerHTML += ' <img class="updateCU" style="cursor:pointer;vertical-align:middle;" onclick="updateUseCaseSelect()" src="<%= rootPath %>images/icons/refresh.gif" />';
	}
}
<%
long lIdItemManageable = user.getId();
int iBlocID = 5;
%>
function updateUseCaseSelect(){
	var arrCU = new Array();
	$$("#trCU_<%= iBlocID %> input").each(function(input){
		if(input.name.substring(0, "manageable_".length) == "manageable_"){
			var cu = new Object();
			cu.id = input.name.substring("manageable_".length, input.name.length);
			cu.value = input.value;
			arrCU.push(cu);
		}
	});
	UserUsecase.updateManageable(<%= lIdItemManageable %>,Object.toJSON(arrCU),function(){
		$("tabTitleUseCase").innerHTML = "Use case";
		updateUseCase = false;
	});
}

function updateAdminSelect(){
	if(checkForm()) {
		$("tabTitleAdmin").innerHTML = "Administration";
		updateAdmin = false;
		$("formAdmin").submit();
	}
}

onPageLoad = function(){
	var updateAdmin = false;
	$$("#formAdmin input").each(function(item){
		Event.observe(item,"focus",function(){
			if(!updateAdmin){
				updateAdmin = true;
				$("tabTitleAdmin").innerHTML += ' <img class="updateAdmin" style="cursor:pointer;vertical-align:middle;" onclick="updateAdminSelect()" src="<%= rootPath %>images/icons/refresh.gif" />';
			}
		});
	});
	
	<%
	if ( (user.getIdUserStatus() == UserStatus.INVALIDE && sessionUserHabilitation.isHabilitate(dih.sUseCaseIdBoutonActiverCompte))
	||  (user.getIdUserStatus() != UserStatus.INVALIDE && sessionUserHabilitation.isHabilitate(dih.sUseCaseIdBoutonDesactiverCompte)))
	{
	%>
	$('changeAccountStatus').onclick = changeAccountStatus;
	$('changeAccountStatus').style.cursor = "pointer";
    <%}%>

    <%
	if(sessionUserHabilitation.isHabilitate(dih.sUseCaseIdBoutonGenererMotDePasse))
	{
	%>
	$('regeneratePassword').onclick = regeneratePassword;
	$('regeneratePassword').style.cursor = "pointer";
	<%
	}
	%>
	mt.html.jumpToTabIndex("tabsTitle", 0);
}
function changeAccountStatus()
{
    if(confirm("<%= locAddressBookMessage.getValue(28,"Do you want change account status ?") %>")){
         doUrl('<%= 
        		 response.encodeURL(rootPath + "desk/organisation/activerCompte.jsp?iIdUser=" + user.getIdUser())
			%>');
     }
}
function regeneratePassword()
{
	if(confirm("<%= locAddressBookMessage.getValue(27,"Do you want regenerate password ?")%>")){
        doUrl('<%= 
        	response.encodeURL(rootPath + "desk/organisation/genererMDP.jsp?iIdUser=" + user.getIdUser())
			%>');
    }
}
</script>
<style type="text/css">
.user_icon{
	width:60px;
	height:72px;
	<%
	switch(personne.getIdPersonnePhysiqueCivilite()){
	case PersonnePhysiqueCivilite.UNDEFINED:
	case PersonnePhysiqueCivilite.MONSIEUR:
		%>
		background:url(../../images/icons/user_enabled_disabled.png) no-repeat;
		<%
		break;
	case PersonnePhysiqueCivilite.MADAME:
	case PersonnePhysiqueCivilite.MADEMOISELLE:
		%>
		background:url(../../images/icons/userf_enabled_disabled.png) no-repeat;
		<%
		break;
	}
	%>
	<% if(user.getIdUserStatus() != UserStatus.VALIDE){%>
	background-position:0 -72px;
	<%}%>
}
<%
if ( (user.getIdUserStatus() == UserStatus.INVALIDE && sessionUserHabilitation.isHabilitate(dih.sUseCaseIdBoutonActiverCompte))
||  (user.getIdUserStatus() != UserStatus.INVALIDE && sessionUserHabilitation.isHabilitate(dih.sUseCaseIdBoutonDesactiverCompte))){
%>
.user_icon:hover{
	<% if(user.getIdUserStatus() != UserStatus.VALIDE){%>
	background-position:0 0;
	<%}else{%>
	background-position:0 -72px;
	<%}%>
}
<%}%>
</style>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<br/>
<div style="padding:0px 15px 15px 15px">
<%
Border bHeader = new Border(Theme.getMainHeaderColor(),7,request);
%>
<%= bHeader.getHTMLTop() %>
<div class="user_icon" id="changeAccountStatus" style="float:left"></div>
<div style="float:left;margin-left:10px;padding-left:10px;">
	<div>
		<% if( sessionUserHabilitation.isHabilitate("IHM-DESK-xxx") ){ %>
		<a class="link_user dataType-tablink" style="font-size:20px;" href='<%= 
		response.encodeURL( rootPath + "desk/organisation/afficherPersonnePhysique.jsp?iIdPersonnePhysique=" 
				+ personne.getIdPersonnePhysique() ) %>' ><%= personne.getName() %></a>
		<%}else{ %>
		<span class="link_user" style="font-size:20px;"><%= personne.getName() %></span>
		<%} %>
		<div class="link_user">
		<%
		for(int iG=0;iG<vGroup.size();iG++){
			if( sessionUserHabilitation.isHabilitate("IHM-DESK-xxx") ){
				%>
				<a class="link_user dataType-tablink" href="<%= response.encodeURL("afficherGroupe.jsp?iIdGroup="+vGroup.get(iG).getId()) %>">
				<%= vGroup.get(iG).getName() %>
				</a>
				<%
			}else{
				%><%= vGroup.get(iG).getName() %><%
			}
			if(iG!=(vGroup.size()-1)){%>, <%}
		}
		%>
		</div>
	</div>
	<div style="margin-top:10px;">
		<%= user.getLogin()%>
	</div>
	<div style="margin-top:2px;">
		<span class="link_user" id="regeneratePassword" style="font-size:15px;"><%= "*************" %></span><br/>
	</div>
</div>
<div class="header_bloc_separator">&nbsp;</div>
<div style="float:left;margin-top:6px;">
	<div style="font-weight:bold"><%= personne.getIdAdresseLabel() %></div>
	<div style="text-align:justify">
		<%= orga.getName() %><br/>
		<%= adrPersonne.getAllAdresseString("<br/>")%>
	</div>
</div>
<%
	if(vOrganigramNode.size() > 0)
	{
		Vector<OrganisationService> vOrganisationService 
		= OrganisationService.getAllFromIdOrganisation(orga.getId(), false, conn);
	
		Vector<Organigram> vOrganigramOrganisationService 
	    =  OrganisationService.getAllOrganigramStatic(vOrganisationService, false, conn);
	
	    Vector<OrganigramNode> vOrganigramNodeAll 
	    	= OrganisationService.getAllOrganigramNode(
	    		vOrganisationService,
	    		vOrganigramOrganisationService,
	    		false,
	    		conn);
%>
<div class="header_bloc_separator">&nbsp;</div>
<div style="float:left;margin-top:6px;">
	<div style="font-weight:bold">Membre de </div>
	<div style="text-align:justify">
<%


		for(OrganigramNode on : vOrganigramNode)
		{
			OrganigramNodeType ont = null;
			OrganisationService osTemp = null;
			try{
				ont = OrganigramNodeType.getOrganigramNodeType(on.getIdOrganigramNodeType()); 
			} catch (CoinDatabaseLoadException e){
				ont = new OrganigramNodeType();
			}
	
			try{
				osTemp 
					= OrganisationService.getOrganisationServiceFromIdOrganigramNode(
						on.getId(),
						vOrganisationService, 
						vOrganigramOrganisationService, 
						vOrganigramNodeAll);
			
			} catch (CoinDatabaseLoadException e){
				osTemp = new OrganisationService();
				osTemp.setName(e.getMessage());
			}


%>
<a class="dataType-tablink" href='<%= 
		response.encodeURL( rootPath
				+ "desk/organisation/groupe/displayOrganisationService.jsp?lIdOrganisationService=" 
				+ osTemp.getId() ) 
				%>' ><%= ont.getName() + " du service " + osTemp.getName() %>
</a><br/>
<%		
	}
%>
	</div>
</div>
<%
	}
%>

<div style="float:right;margin-left:10px;padding-left:10px;text-align:right">
	<div>
		<%if(user.getDateExpiration() != null) {%>
		<%= "<a href=\"\">"+user.getDateExpirationLabel()+"</a> : <span class='link_user'>" + CalendarUtil.getDateCourte(user.getDateExpiration())+"</span><br/>" %>
		<%}	%>
		<%if(user.getDateLastAccess() != null) {%>
		<%= user.getDateLastAccessLabel()+" : <span class='link_user'>" + CalendarUtil.getDateCourte(user.getDateLastAccess())+"</span><br/>" %>
		<%}	%>
	</div>
</div>
<div style="clear:both"></div>
<%= bHeader.getHTMLBottom() %>
<br/>
<a name="ancreError"></a>
<div class="rouge" style="text-align:left" id="divError"></div>
<div class="tabFrame" style="padding:0;margin:0;">
    <div class="tabs" id="tabsTitle">
        <div class="active" id="tabTitleGroup"><%= locTab.getValue(1,"Groupes") %></div>
        <div id="tabTitleTreeview"><%= locTab.getValue(2,"Treeview") %></div>
        <div id="tabTitleUseCase"><%= locTab.getValue(3,"Use case") %></div>
        <div id="tabTitleAdmin"><%= locTab.getValue(4,"Administration") %></div>
    </div>
    <div class="tabContent">
        <div>
			<div class="blockPaveBorder">
				<div style="float: left;"><%= locBloc.getValue(2,"Groupes associés") %></div>
				<div class="" style="float: right;">
				<%
				String sHabilitate = locTitle.getValue(3,"Habilitate");
				String sManageable = habLoc.getIsManageableLabel("Manageable");
				
				%>
		    	<%= sHabilitate.charAt(0) %> : <%= sHabilitate %>, <%= sManageable.charAt(0) %> : <%= sManageable %> 
				<%
				if( sessionUserHabilitation.isHabilitate(sUseCaseIdModifier) )
				{
					%>
					,&nbsp;<a href="<%= response.encodeURL( "modifierUtilisateurGroupeForm.jsp?iIdUser="+user.getIdUser()+"&amp;sAction="+sAction ) %>"><%= locHabilitationButton.getValue(1,"Modifier les droits")%></a>
					<%
				}
				%>
		    	</div>
				<div style="clear: both;"></div>
			</div>
			<table class="paveUnrounded" id="tableGroup">
			<tr>
			<%
			int iGroup = 0;
			int iModuloGroup = (int)(vGroupAll.size()/3)+1;
			if(iModuloGroup<=10) iModuloGroup = 10;
			for (Group group : vGroupAll)
			{
				group.setAbstractBeanLocalization(sessionLanguage);
				if(iGroup%iModuloGroup==0){
					if(iGroup>0){
					%>
					</table>
					</td>
					<%} %>
					<td style="vertical-align:top;">
						<table>
						<tr>
							<td class="pave_cellule_gauche" style="width:90%;vertical-align:top;">&nbsp;</td>
							<td class="pave_cellule_droite" style="width:5%;vertical-align:top;" ><%= sHabilitate.charAt(0) %></td>
							<td class="pave_cellule_droite" style="width:5%;vertical-align:top;" ><%= sManageable.charAt(0) %></td>
						</tr>
					<%
				}
				%>
				<tr>
				<td class="pave_cellule_gauche" style="font-weight:normal;width:85%;vertical-align:top;">
				<%= group.getName()  %>
				</td>
				<td >
					<input type="hidden" 
		            name="cb_group_habil_<%= group.getId() %>" 
		            id="cb_group_habil_<%= group.getId() %>" 
		            onclick="onSelectGroup();"
		            value="<%= CoinDatabaseUtil.isInList(group,vGroup)?1:0 %>"
		            class="dataType-checkbox2"/>
		            </td>
		            <td>
		            <% if(CoinDatabaseUtil.isInList(group,vGroupManageable)){ %>
		            <input type="hidden" 
		            name="cb_group_manage_<%= group.getId() %>" 
		            id="cb_group_manage_<%= group.getId() %>" 
		            onclick="onSelectGroup();"
		            value="<%= CoinDatabaseUtil.isInList(group,vUserGroupManageable)?1:0 %>"
		            class="dataType-checkbox2"/>
		            <%} %>
					</td>
				</tr>
				<%
				iGroup++;
			}
		%>
			</table>
			</td>
			</tr>
		</table>
        </div>
        <div class="hide">
			<%
			Treeview treeview = null;
			Vector<Long> vIds = new Vector<Long>();
			try{vIds = TreeviewNoeud.getAllIdTreeviewFromIdUser(user.getId());
			}catch(Exception e){}
			for (int iInd=0;iInd<vIds.size();iInd++){
				try {
					treeview = Treeview.getTreeview(vIds.get(iInd).intValue());
				}catch (CoinDatabaseLoadException e) {
					treeview = new Treeview();
				}
				treeview.setAbstractBeanLocalization(sessionLanguage);
			%>
			<div style="float:left;margin-left:10px;">
	        	<div class="blockPaveBorder">
					<span style="float: left;"><%= treeview.getName() %></span>
					<span style="float: right;">&nbsp;</span>
					<div style="clear: both;"></div>
				</div>
				<table class="paveUnrounded" id="tableTV">
				<%
			
				Vector vHabilitationDifferential = TreeviewNoeud.getHabilitationsFromUser( user );
				Vector vHabilitation = TreeviewNoeud.getHabilitationsFromUser( user,false );
				
				Vector vItemList = TreeviewNoeud.getItemListWithHabilitations((int) treeview.getIdMenuTreeview(), 0, request.getContextPath()+"/", vHabilitation ) ;
			
			 	for (int i=0; i < vItemList.size(); i++)
			 	{
				 	TreeviewNode node = (TreeviewNode ) vItemList.get(i);
				 	node.setAbstractBeanLocalization(sessionLanguage);
					int j;
				%> 	
					<tr>
						<td colspan="2">
					  	  <table cellpadding="0" cellspacing="0">
							<tr>
								<td>
								<% if( sessionUserHabilitation.isHabilitate("IHM-DESK-xxx") ){ %>
								<input type="hidden" 
				                name="cb_tv_<%= node.getId() %>" 
				                id="cb_tv_<%= node.getId() %>"
				                onclick="selectBranch('cb_tv_<%= node.getId() %>')"
				                value="<%= vHabilitationDifferential.contains(new Integer((int)node.getId()))?1:0 %>"
				                class="cb_tv_<%= node.iParentNode %> dataType-checkbox2"/><%} %>&nbsp;</td>
								<%@ include file="pave/paveTreeviewNode.jspf" %>
							</tr>
						  </table>
						</td>
					</tr>	
				<%
				}
			 	%>
				</table>
			</div>
			<% } %>
			<div style="clear:left"></div>
			
        </div>
        <div class="hide">
        	<%
			ArrayList<Vector<UseCase>> arrCU = Habilitation.getAllUseCaseFromIdUser(user.getIdUser(),false );
			Vector<UseCase> vUseCases = arrCU.get(0);
			Vector<UseCase> vUseCasesManageable = arrCU.get(1);
			
			ArrayList<Vector<UseCase>> arrCUDifferential = Habilitation.getAllUseCaseFromIdUser(user.getIdUser(),true );
			Vector<UseCase> vUseCasesDifferential = arrCUDifferential.get(0);
			
			boolean bUseManageableAdmin = true;
			boolean bDisplayOnlyManageable = true;
			String sBlocDefaultTitle = "Cas d'Utilisation administrables";
			%>
			<%@include file="pave/paveListeUseCase.jspf" %>
			<%
			bUseManageableAdmin = false;
			bDisplayOnlyManageable = false;
			vUseCases = vUseCasesDifferential;
			iBlocID = 3;
			sBlocDefaultTitle = "Cas d'Utilisation consolidés";
			%>
			<br/>
			<%@include file="pave/paveListeUseCase.jspf" %>
			<script>
				Element.hide("trCU_<%= iBlocID %>");
			</script>
        </div>
        <div class="hide">
	        <div>
	        <%
			User userPersonne = user;
			String sUseCaseIdBoutonModifierMotDePasse = dih.sUseCaseIdBoutonModifierMotDePasse;
			String sModifyAccountUseCaseId = dih.sModifyAccountUseCaseId;
			Organisation organisation = orga;
			String sBlocNameUserAccount = locBloc.getValue(1,"Utilisateur");
			HtmlBeanTableTrPave hbFormulaire = new HtmlBeanTableTrPave();
			hbFormulaire.bIsForm = true;
			int iIdOnglet = Onglet.ONGLET_PERSONNE_PHYSIQUE_COMPTE_UTILISATEUR;

			Localize locBlocOld = locBloc;
			locBloc = locAddressBookBloc;
			Localize locMessageOld = locMessage;
			locMessage = locAddressBookMessage;
			%>
			<%@ include file="../organisation/pave/modifierPersonnePhysique.jspf" %>
			<form action="<%= response.encodeURL("../organisation/modifierPersonnePhysique.jsp")%>" method="post" name="formAdmin" id="formAdmin">
			<input type="hidden" name="sAction" value="store" />
			<input type="hidden" name="iIdOnglet" value="<%= iIdOnglet  %>" />
			<input type="hidden" name="iIdPersonnePhysique" value="<%= personne.getIdPersonnePhysique() %>" />
			<%@ include file="../organisation/pave/paveCompteUtilisateurForm.jspf" %>
			<%
			locBloc = locBlocOld;
			locMessage = locMessageOld;
			%>
			</form>


	
</div>

<%@ include file="/include/new_style/footerFiche.jspf" %>

</body>
<%
	ConnectionManager.closeConnection(conn);
%>
</html>
