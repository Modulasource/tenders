<%@page import="org.coin.localization.LocalizeButton"%>
<%@page import="org.coin.util.CalendarUtil"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="org.coin.bean.conf.Configuration"%>
<%@page import="org.coin.util.Outils"%>
<%@page import="org.coin.localization.Language"%>
<%@page import="org.coin.fr.bean.Organisation"%>
<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%@page import="java.util.Calendar"%>
<%@page import="org.coin.mail.Mail"%>
<%@page import="java.util.Vector"%>
<%@page import="modula.graphic.Theme"%>
<%@page import="org.coin.fr.bean.Delegation"%>
<%@ include file="/include/new_style/beanSessionUser.jspf" %>
<%

	LocalizeButton localizeButton = (LocalizeButton) request.getAttribute("localizeButton");
	String rootPath = request.getContextPath() + "/";

	String sHotLineNumber = "08 92 23 02 41";
	try {
		//sHotLineNumber = Configuration.getConfigurationValueMemory("publisher.portail.hotline.number");
		Configuration confHotline = Configuration.getConfigurationMemory("publisher.portail.hotline.number");
		confHotline.setAbstractBeanLocalization(sessionLanguage);
		sHotLineNumber = confHotline.getLocalizedName();
	} catch (Exception e) { }

	String sHotLinePrice = "0,34&euro; /min";
	try {
		sHotLinePrice = Configuration.getConfigurationValueMemory("publisher.portail.hotline.price",false);
		sHotLinePrice = Outils.replaceAll(sHotLinePrice, "&amp;" , "&");
		if(Outils.isEmailValide(sHotLinePrice)){
			sHotLinePrice = "<a href='mailto:"+sHotLinePrice+"'>"+sHotLinePrice+"</a>";
		}
	} catch (Exception e) {}

	if(!sHotLinePrice.equals(""))
	{
		sHotLinePrice = "(" + sHotLinePrice + ")";
	}
	
	boolean bShowHotline= Configuration.isTrueMemory("design.desk.theme.hotline.show", true);
	
    /**
     * Use localization
     */
 	String sMessageMyProfile = localizeButton.getValue(30,"Mon profil");
	String sMessageLogout = localizeButton.getValue(31,"Déconnexion");
	String sMessageTutorial = localizeButton.getValue(47,"Tutorial");
	String sMessageAssistance = localizeButton.getValue(48,"Assistance");
	String sMessageLog = "";
	String sMessageLogDelegate = "Délégation : ";
	
	Timestamp tsServer = new Timestamp(System.currentTimeMillis());
	Calendar calServer = CalendarUtil.getCalendar(tsServer);
	String sServerDate = ""+ (calServer.get(Calendar.YEAR) - 1900) + "," 
			+ calServer.get(Calendar.MONTH) + "," 
			+ calServer.get(Calendar.DAY_OF_MONTH) + "," 
			+ calServer.get(Calendar.HOUR_OF_DAY) + "," 
			+ calServer.get(Calendar.MINUTE) + "," 
			+ calServer.get(Calendar.SECOND) 
			;
%>

<script type="text/javascript">
var myBorder = RUZEE.ShadedBorder.create({corner:4, border:1});
Event.observe(window, 'load', function(){
    myBorder.render($('titleCorners'));
});

var timerLocal;
var timerServer;
var lTimeLocalSynchro;
var lTimeServerSynchro ;
var lTimeOffset;
var g_dtServerTime;

function updateFromLocalClock()
{
    var dt=new Date();
    
    dt.setTime(dt.getTime() + lTimeOffset);
   	$("deskClockTime").innerHTML=dt.dateFormat("H:i");
   
}

function computeTimeOffset()
{
	lTimeLocalSynchro = new Date().getTime();
	lTimeServerSynchro = <%= System.currentTimeMillis() %>;
	
	g_dtServerTime = new Date(<%= sServerDate %>);
	
	lTimeOffset = g_dtServerTime.getTime() - lTimeLocalSynchro;
}


Event.observe(window, 'load', function(){
	computeTimeOffset();
	updateFromLocalClock();
	
	/* toutes les 30 min */
    //timerServer=setInterval("computeTimeOffset()", 60000 * 30);

	/* toutes les 30 secs */
    timerLocal=setInterval("updateFromLocalClock()", 30000);
});

function confirmLogout(){
   if(enableDeskTabsSave){
       var b = mt.html.updateUserConfig(logout);
   }else{
       logout();
   }
}
function logout(){
    location.href = "<%= response.encodeURL(rootPath+"desk/logout.jsp") %>";
}
</script>
<div id="headerMenu">
	<div id="titleCorners" class="headerBar sb" style="padding:7px 10px 7px 10px">
		<div>
		<table class="fullWidth" cellpadding="0" cellspacing="0">
		<tr><td>

   		<div class="hour" id="deskClockDate" style="float:left"><%= CalendarUtil.getDateWithFormat(
			new Timestamp(System.currentTimeMillis()),"dd/MM/yyyy") %>
			<span id="deskClockTime"></span>
		</div>
<%
	if(bShowHotline){
%>
			<div class="hotline" style="float:left"><%= sMessageAssistance %> <%= sHotLineNumber %> <%= sHotLinePrice %></div>
<%	}

	if(Theme.getTheme().equalsIgnoreCase("veolia"))
	{ 
%>
			<div class="tutorial" style="float:left">
				<a href="<%= response.encodeURL(rootPath+"vfr_tutorial/") %>" target="_blank"><%= sMessageTutorial %></a>
			</div>
<%	
	} 
%>
<%
	String sVersionApplication = "";
	{
		sVersionApplication = mt.modula.Version.VERSION_APPLICATION ;
	}
			
%>
			<div class="version" style="float:left">
				Version <%= sVersionApplication %>
			</div>
<%

	if(!Outils.isNullOrBlank(Configuration.getConfigurationValueMemory("design.desk.theme.help.site.url", "")) )
	{
%>
	   		<div class="helpsite" style="float:left;cursor: pointer;" 
	   			onclick="window.open('<%= 
	   			Configuration.getConfigurationValueMemory("design.desk.theme.help.site.url") %>','blank')">
	   			Aide
			</div>
<%
	}
%>				
		</td>
		<td style="text-align:right">
		
<%
	if(Configuration.isEnabledMemory("server.localization", false))
	{
		sessionLanguage.setAbstractBeanLocalization(sessionLanguage.getId());	
%>
		<script type="text/javascript">
		function onClickSelectFlag()
		{
			var item = $("langList");
			var calframe = $("langCombo");
			var input = item.cloneNode(true);
			
			calframe.style.position = "absolute";
			calframe.style.right = 0;
			calframe.style.top = Element.getHeight(input) + 30;
			Element.toggle('langCombo');
		}
		</script>
			
		<span id="langList">
		   <a target="_top" href="javascript:void(0);"
		   	  onclick="onClickSelectFlag();"><img border="0" src="<%= rootPath %>images/flags/<%= 
		   		  sessionLanguage.getShortLabel() 
		   %>.gif" /> <%= sessionLanguage.getName()  %></a>
              
		<div id="langCombo" style="width:100px; padding:2px;display:none;position:absolute;border: 1px solid #C2CCE0;background : #FFFFFF;">
			<table >
<%
		Vector<Language> vLangAvailable = Language.getAllLanguageAvailable();
		for(Language langSelected : vLangAvailable)
		{
			String sUrlLangSelection = response.encodeURL(rootPath 
                          + "desk/index.jsp?system_iIdSessionLanguage="
                          + langSelected.getId() +"&nonce=" + System.currentTimeMillis());
%>
		   <tr>
		   		<td style="vertical-align:middle">
				   <a  target="_top" href="<%= sUrlLangSelection
                        %>"><img border="0" src="<%= rootPath %>images/flags/<%= langSelected.getShortLabel() 
                        %>.gif" /></a>
                      </td>
                      <td style="text-align:left;vertical-align:middle">&nbsp;
			   		<a  target="_top" href="<%= sUrlLangSelection %>">
                      		<%= langSelected.getName() %></a>
                  	</td>
                  </tr>
<%
		}
    } // END server.localization
%>
          </table>
		</div>				   
		</span>
		
		<a class="profil" style="margin-right:10px;" href="javascript:void(0)" onclick="mt.html.addTab('Mon profil','<%=
			response.encodeURL(rootPath+"desk/organisation/afficherPersonnePhysique.jsp?iIdPersonnePhysique="
					+sessionUser.getIdIndividual())%>')"><%= sMessageMyProfile %></a>
		
		<a id="logout" href="javascript:confirmLogout()" class="logout"><%= sMessageLogout %></a>
		</td></tr>
		</table>
		</div>
	</div>
	<div class="login" style="float:right">
	<% 
	//pour eviter les duplicate var si le nom de la var est déja utilisé,
	//j'ai rajouté __
	String __sOrgUserLog = "";
	try{
		Organisation __o = sessionUser.getOrganisation();
		__sOrgUserLog = "- "+__o.getRaisonSociale();
	}
	catch(Exception e){__sOrgUserLog = "";}
	%>
	<%= sMessageLog + sessionUser.getLogin() %> <%= __sOrgUserLog %> (<%= sessionUserHabilitation.getGroupName() %>)
	</div>
	<div style="clear:both"></div>
</div>