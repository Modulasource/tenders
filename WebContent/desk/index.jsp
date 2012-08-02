<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%@ page contentType="text/html; charset=ISO-8859-1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="fr" lang="fr">
<head>
<!-- 
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
 -->
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
        
<%
    /**
     * Localization
     */
	LocalizeButton localizeButton = null;
	try {
		localizeButton = new LocalizeButton(request);
	}catch (Exception e) {
		e.printStackTrace();
	}
	
	request.setAttribute("localizeButton", localizeButton);
%>
<%@page import="org.coin.fr.bean.OrganisationParametre"%>
<%@page import="org.coin.bean.UserType"%>
<%@page import="org.coin.bean.conf.Treeview"%>
<%@page import="modula.TreeviewNoeud"%>
<%@page import="modula.graphic.Theme"%>
<%@page import="org.coin.bean.conf.Configuration"%>
<%@page import="org.coin.db.CoinDatabaseLoadException"%>
<%@page import="org.coin.security.HabilitationException"%>
<%@page import="modula.graphic.DeskUI"%>
<%@page import="org.coin.localization.LocalizeButton"%>
<%@page import="org.coin.fr.bean.PersonnePhysiqueParametre"%>
<%@page import="org.coin.util.JavascriptVersion"%>
<%@page import="org.coin.localization.Localize"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.servlet.filter.HabilitationFilterUtil"%>
<%@page import="org.coin.bean.UserHabilitation"%>
<%@page import="org.coin.bean.User"%>
<%@page import="org.coin.bean.UseCase"%>
<%@ page import="java.util.*" %>
<%@page import="org.coin.fr.bean.Organisation"%>
<%@page import="mt.common.addressbook.habilitation.AddressBookHabilitation"%>
<%@page import="org.coin.fr.bean.BOAMPProperties"%>
<%@ include file="/include/new_style/beanSessionUser.jspf" %>
<%
//TODO: pour les tabs : http://www.schillmania.com/projects/dialog2/
	//sessionUserHabilitation.isHabilitateException("TEST-UC");

	if (sessionUser == null) {
		response.sendRedirect(response.encodeRedirectURL("logout.jsp"));
		return;
	}
	try {
		sessionUserHabilitation.setHabilitations(sessionUser.getIdUser());
	} catch (Exception e) {
		e.printStackTrace();
		response.sendRedirect(response.encodeRedirectURL("logout.jsp"));
		return;
	}

	sessionUserHabilitation.unsetAsSuperUser();
	if (sessionUserHabilitation.getUser().getIdUserType() == modula.UserConstant.USER_ADMIN) {
		sessionUserHabilitation.setAsSuperUser();
		sessionUserHabilitation.setDebugSession(Configuration.isEnabledMemory("debug.session",false));
	}
	
	String rootPath = request.getContextPath() + "/";

	//sessionUserHabilitation.isHabilitateException("TEST-UC");

	int iIdPersonnePhysique = sessionUser.getIdIndividual();
	PersonnePhysique person = PersonnePhysique.getPersonnePhysique(iIdPersonnePhysique);
	
	String sTreeviewMode = "flash";
	try {
		sTreeviewMode = org.coin.bean.conf.Configuration
		.getConfigurationValueMemory("treeview.mode");
	} catch (Exception e) {
		sTreeviewMode = "flash";
	}

	Vector vTreeview = TreeviewNoeud.getTreeviewFromHabilitation(sessionUserHabilitation);

	String sDesignDeskTopBannerImagePath = null;
	try {
		sDesignDeskTopBannerImagePath = Configuration
		.getConfigurationValueMemory("design.desk.top.banner.image.path");
	} catch (CoinDatabaseLoadException e) {
	}

	String sDebugMode = "disabled";
	try {
		sDebugMode = org.coin.bean.conf.Configuration
		.getConfigurationValueMemory("debug.session");
	} catch (Exception e) {
		throw new Exception(
		"debug.session n'est pas défini dans la table de configuration");
	}
	
	
    String sUserDeskMainPage = null;
    
    try {
    	/**
    	 * set the default value of the organisation
    	 */
    	sUserDeskMainPage = OrganisationParametre
				.getOrganisationParametreValue(
						person.getIdOrganisation(), 
						"desk.main.page");
	} catch (Exception e) {	}

    
	try {
		sUserDeskMainPage = PersonnePhysiqueParametre
				.getPersonnePhysiqueParametreValue(
						sessionUser.getIdIndividual(), 
						"desk.main.page");
	} catch (Exception e) {	}

	if(sUserDeskMainPage != null)
	{
	    response.sendRedirect(response.encodeRedirectURL(rootPath + sUserDeskMainPage));
	    return;
	}
	Organisation organisation = null;
    try { 
        organisation = Organisation.getOrganisation(person.getIdOrganisation());
    } catch(Exception e) {
        organisation = new Organisation();
    }
    
    String sTVAIntra = organisation.getTvaIntra();
    String sSiret = organisation.getSiret();
    int iIdOrganisationClasseProfit = organisation.getIdOrganisationClasseProfit();
    
    boolean bDisplayFormMajBoamp = false;
    boolean bIsClientBOAMP = false;
    
    BOAMPProperties boampProperties = new BOAMPProperties();
    try {
        boampProperties = BOAMPProperties.getBOAMPPropertiesFromOrganisation(organisation.getIdOrganisation());
        if(boampProperties != null) bIsClientBOAMP = true;
        else boampProperties = new BOAMPProperties();
    } catch(Exception e){
        boampProperties = new BOAMPProperties();
    }
    
    if(bIsClientBOAMP) {
    	
    	if(sSiret.equals("") || sSiret.equals(null) || iIdOrganisationClasseProfit == 0) {
    		bDisplayFormMajBoamp = true;
    	}
    }
    
    String sOnLoad = bDisplayFormMajBoamp?"onload=\"setTimeout('displayFormMajInfoBoamp()', 1000)\"":"";
    
%> 
<meta http-equiv="Expires" content="-1" />
<meta http-equiv="Cache-Control" content="no-cache, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<title><%= Theme.getDeskTitle() %></title>
<link rel="stylesheet" href="<%=rootPath %>include/new_style/Proto.Menu.css" type="text/css" media="screen" />
<link rel="stylesheet" type="text/css" href="<%= rootPath %>include/new_style/<%= Theme.getMainCSS() %>.css" media="screen" />
<link rel="SHORTCUT ICON" href="<%= rootPath %>include/<%= Theme.getShortcutIcon() %>" />


<script type="text/javascript" src="<%=rootPath %>dwr/engine.js"></script>
<script type="text/javascript" src="<%=rootPath %>dwr/util.js"></script> 
<script type="text/javascript" >
var rootPath = "<%= rootPath %>";
var debugMode = "<%=sDebugMode %>";	
var enableDeskTabs = <%=DeskUI.useTabs(request)%>;
var enableDeskContextMenu = <%=DeskUI.useContextMenu(request)%>;
var enableDeskTabsSave = <%=DeskUI.useTabsSave(request)%>;

var documentFontSizeNormal = 100;
var documentFontSizeBig = 150;
var documentFontSize = documentFontSizeNormal;

</script>
<script type="text/javascript" src="<%= rootPath %>include/js/prototype.js?v=<%= JavascriptVersion.PROTOTYPE_JS %>"></script>
<!-- <script type="text/javascript" src="<%= rootPath %>include/js/prototype_update_helper.js"></script> -->
<script type="text/javascript" src="<%=rootPath %>include/js/scriptaculous/scriptaculous.js"></script>
<script type="text/javascript" src="<%=rootPath %>include/js/scriptaculous/effects.js"></script>
<script type="text/javascript" src="<%=rootPath %>include/js/shadedborder.js"></script>
<script type="text/javascript" src="<%=rootPath %>include/js/fastinit.js"></script>
<script type="text/javascript" src="<%= rootPath %>include/js/run.js?v=<%= JavascriptVersion.RUN_JS %>"></script>
<script type="text/javascript" src="<%= rootPath %>include/modula.treeview.js?v=<%= JavascriptVersion.MODULA_TV_JS %>"></script>
<script type="text/javascript" src="<%=rootPath %>include/js/livepipe/dragdrop.js"></script>
<script type="text/javascript" src="<%=rootPath %>include/js/livepipe/livepipe.js"></script>
<script type="text/javascript" src="<%=rootPath %>include/js/livepipe/window.js"></script>
<link rel="stylesheet" type="text/css" href="<%=rootPath %>include/new_style/facebox.css" media="screen" />


<script type="text/javascript" src="<%=rootPath %>include/js/accordion.js"></script>
<jsp:include page="/include/js/localization/localization.jsp" flush="false">
<jsp:param name="iIdLang" value="<%= sessionLanguage.getId() %>" />
</jsp:include>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/UserTab.js"></script>
<script type="text/javascript" src="<%=rootPath %>include/js/Proto.Menu.js"></script>
<link rel="stylesheet" type="text/css" href="<%=rootPath %>include/component/calendar/calendar.css" media="screen" />
<script type="text/javascript" src="<%= rootPath %>include/component/calendar/calendar.js"></script>
<script type="text/javascript" src="<%=rootPath%>include/popup.js"></script>
<script type="text/javascript" src="<%= rootPath %>include/verification.js"></script>
<!--Pour IE6--->
<!--[if lte IE 6]>
<link rel="stylesheet" type="text/css" href="<%=rootPath%>include/new_style/deskIE6.css" media="screen" />
<script type="text/javascript" src="<%=rootPath%>include/js/pngfixall.js"></script>
<![endif]-->
<!--Pour IE7+--->
<!--[if gte IE 7]>
<![endif]-->


<script type="text/javascript">
mt.config.enableTabs = true;
//prototypeUpdateHelper.logLevel = UpdateHelper.Warn;
onPageLoad = function() {

	try {
	<%	for(int i=0; i<vTreeview.size(); i++)	{
		Treeview tv = (Treeview)vTreeview.get(i); %>
		modula.treeview.loadTreeview("<%=response.encodeURL(rootPath+"desk/include/menu.jsp?iIdRootNode=" + tv.getIdMenuTreeview())%>&nonce=<%= System.currentTimeMillis()%>", "treeview_<%=tv.getIdMenuTreeview()%>",rootPath);
	<% } %>
	
	var tvAccordion = new accordion('tvAccordion', {
	    classNames : {
	        toggle : 'tv_accordion_toggle',
	        toggleActive : 'tv_accordion_toggle_active',
	        content : 'tv_accordion_content'
	    }
	});
	tvAccordion.activate($$('#tvAccordion .tv_accordion_toggle')[0]);
	
	var tvAccordions = $$('.tv_accordion_toggle');
	tvAccordions.each(function(accordion) {
	    $(accordion.next(0)).setStyle({
	        height: '0px'
	    });
	});
	} catch (e) {}
	


	$("navToggle").onclick = $("navToggleHidden").onclick = function(){
        modula.treeview.toggle();
    }
    
    Element.hide($("navToggleHidden"));

    Event.observe(document, 'mousemove', function(e){
        if (Event.pointerX(e)<=10) {
            if (!modula.treeview.tvOpen) {
                modula.treeview.toggle();
            }
        }
    });

	mt.html.loadUserConfig();
}
function addParentTabForced(name,url, reverseDefaultBehavior, idTab, nameTab){
    mt.html.addTabForced(name,url, reverseDefaultBehavior, idTab, nameTab);
}
function addParentTabReverseDefaultBehavior(name,url){
    mt.html.addTabReverseDefaultBehavior(name,url);
}
function addParentTab(name,url){
    mt.html.addTab(name,url);
}
function redirectParentTabActive(url){
   mt.html.redirectTabActive(url);
}
function getParentTabActive(){
    return mt.html.getTabActive();
}
function updateParentNavPath(url){
   mt.html.updateNavPath(url);
}

function onClickSelectFlagModal(node){	

	Element.toggle("langComboModal");
    if(node.id != "langListModal"){
        var item = $("langListModal");
        item.getElementsByTagName("img")[0].src = node.getElementsByTagName("img")[0].src;
        var spanLang =  $A($$("#"+node.id+" .langNameModal"))[0];
        $A($$("#"+item.id+" .langNameModal"))[0].innerHTML = "&nbsp;"+spanLang.innerHTML;
        $("langFileModal").value = spanLang.id;
    }
}

function displayFormMajInfoBoamp() {

	
	var sUrl = '<%= response.encodeURL(rootPath +"desk/organisation/updateBoampInformationForm.jsp?sAction=store"
	            + "&iIdOrganisation="+person.getIdOrganisation()
	            ) %>';
	
	parent.mt.utils.displayModal({
	    type:"iframe",
	    url:sUrl,
	    title:"Mise à jour des informations pour le BOAMP",
	    width:800,
	    height:500,
	    options: {
		   closeOnClick:false
		}
	});
}

/**
 * copy source code of screenDimension.js
 */
var popupWidth;
var popupHeight;
	
if(screen.width == 800)
	popupWidth =640;
else
	popupWidth =800;

if(screen.height == 600)
	popupHeight =480;
else
	popupHeight =600;


function displayIframeDocumentReader(url,title) {
	if(!isNotNull(title)) title = "";
	mt.utils.displayModal({
		type:"iframe",
		url:url,
		title:((title)?title:"&nbsp;"),
		width:popupWidth,
		height:popupHeight-100
	});	
}

Event.observe(window, 'load', mt.html.resizeLayout);
Event.observe(window, 'resize', mt.html.resizeLayout);

</script>
</head>
<%
	
	String sHomeImage = "images/icones/logo_modula_home_small.jpg";
	try{
		sHomeImage = Configuration.getConfigurationValueMemory("design.desk.main.top.left.image");
	} catch(Exception e) {}
	
	if(!sHomeImage.contains("http://")
	&& !sHomeImage.contains("https://")){
		sHomeImage = rootPath + sHomeImage;
	}
	
%>
<body scroll="no" id="index" <%= sessionLanguage.getWritingDirection() %> <%= sOnLoad %> >
<table class="fullWidth" id="tableLayout" cellpadding="0" cellspacing="0">
	<tr>
	<td id="nav" class="top">
		<div style="padding:5px 0 0 7px" class="center pointer"
		onclick="mt.html.addTab(MESSAGE_TAB[1],'<%= response.encodeURL("include/main.jsp")%>')">
			<img src="<%= sHomeImage %>"/>
		</div>
<%

	String sStyleDisplay = "";	
	{
%>    
	<div id="menu_gauche_treeview" <%= sStyleDisplay %> >

<%@ include file="/include/new_style/headerFicheTV.jspf" %>
		<div id="tvAccordion" class="treeview">
<%
        for (int i = 0; i < vTreeview.size(); i++) {
	        Treeview tv = (Treeview) vTreeview.get(i);
	        tv.setAbstractBeanLocalization(sessionLanguage);
%>
        <h2 class="tv_accordion_toggle"><%=tv.getName()%></h2>
		<div class="tv_accordion_content" id="treeview_<%=tv.getIdMenuTreeview()%>"></div>
<%
        }
%>
		</div>
	<%@ include file="/include/new_style/footerFicheTV.jspf" %>
	</div>
<%		
	}
%>		

	</td>
    <td id="navToggleHidden"></td>

	<td id="content" class="top">
		<jsp:include page="/include/new_style/menuBar.jsp" />	
        <div class="tabFrame">
            <div class="tabs" id="tabsTitle"></div>
            <div class="tabContent"></div>
        </div>
    </td>
</tr>
</table>
</body>
</html>
