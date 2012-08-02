<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@page import="org.coin.apache.tomcat.SessionManager"%>
<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%@page import="java.util.*" %>
<%@page import="org.coin.bean.User"%>
<%@page import="org.coin.servlet.filter.HabilitationFilterUtil"%>
<%@page import="org.coin.net.Whois"%>
<%@page import="org.coin.util.*"%>
<%@page import="java.sql.Timestamp"%>
<%
	String sTitle = "Liste des sessions actives";

%>
</head>
<script type="text/javascript">
function killSession(sSessionId)
{
	if(confirm("Etes vous sûr de vouloir supprimer la session ?"))
	{
		doUrl("<%= response.encodeURL("modifySessionUser.jsp?sAction=remove&session=") %>"
		+ sSessionId);
	}
}

function displayUser(lId)
{
	parent.addParentTabForced("Utilisateur","<%= 
			response.encodeURL(
					rootPath + "desk/utilisateur/afficherUtilisateurGroupe.jsp?iIdUser=") 
					%>" + lId, 
					false, "user_" + lId, "user_" + lId);
}



</script>
<style type="text/css">
.user_icon_male{
	width:60px;
	height:72px;
	background:url(../../images/icons/user_enabled_disabled.png) no-repeat;
	background-position:0 0;
}
.user_icon_female{
	width:60px;
	height:72px;
	background:url(../../images/icons/userf_enabled_disabled.png) no-repeat;
	background-position:0 0;
}
</style>
<body >
<div style="padding: 15px;">
<div style="text-align: right;">
	<button onclick="doUrl('<%= response.encodeURL(
			rootPath + "desk/monitoring/displayAllActiveSessionUser.jsp") 
			%>');" >Recharger la liste</button>
</div>
<%
List<HttpSession> listActiveSession = SessionManager.getAllActiveSession();

for (int i = 0; i < listActiveSession.size(); i++) {
	try {
		HttpSession sessionActive = listActiveSession.get(i);
		int j = i % 2;
	    User uUserSession = (User) sessionActive.getAttribute("sessionUser");
	    String sRemoteHostSession = (String) sessionActive.getAttribute(HabilitationFilterUtil.SESSION_REMOTE_HOST_NAME);
	    String sRemoteAddrSession = (String) sessionActive.getAttribute(HabilitationFilterUtil.SESSION_REMOTE_ADDR_NAME);
	    String sUserAgentSession = (String) sessionActive.getAttribute(HabilitationFilterUtil.SESSION_USER_AGENT);
	    long lTimeDuration = sessionActive.getLastAccessedTime() - sessionActive.getCreationTime();
		Whois whois = (Whois)sessionActive.getAttribute(HabilitationFilterUtil.SESSION_WHOIS);
		String sUriLastAccess = (String)sessionActive.getAttribute(HabilitationFilterUtil.SESSION_URI_LAST_ACCESS);

	    
	    String sUserName = "not connected";
	    String sCountry = "";
	    String sDescription = "";
	    
	    if(uUserSession!=null){
	    	sUserName = "<b>"+ uUserSession.getLogin() + "</b>";
	    } else {
	    	continue;
	    }
	
		if(whois != null)
		{
			sCountry = whois.getCountry();
			sDescription = whois.getDescription();
		}


		String sInfoStyle = "style = 'color: #66F'";
		String sUserIconClass = "user_icon_male";
		PersonnePhysique person = PersonnePhysique.getPersonnePhysique(uUserSession.getIdIndividual());

		switch (person.getIdPersonnePhysiqueCivilite())
		{
		case PersonnePhysiqueCivilite.MADAME:
		case PersonnePhysiqueCivilite.MADEMOISELLE:
			sUserIconClass = "user_icon_female";
			break;
		}

		
		String sDivBg = "";
		boolean bIsActualSession = false;
		if(session.equals(sessionActive))
		{
			sDivBg  = "background-color: #EEF;";
			bIsActualSession = true;
		}
%>

	<div style="border: 1px #DDD solid;padding: 5px;margin-bottom: 10px;<%=sDivBg %>"> 
		<table width="100%">
			<tr >
				<td style="width: 80px">
					<div class="<%= sUserIconClass %>" ></div>
				</td>
				<td>
					<table width="100%">
						<tr >
							<td >
								<span style="font-size: 16px"><%= person.getName() 
								+ (bIsActualSession?" (session active)":"")%></span>
							</td>
							<td style="text-align: right;">
								<a href="javascript:void(0);" onclick="displayUser('<%= uUserSession.getId() %>')" >afficher le profil</a>
<%
		if(!session.equals(sessionActive))
		{
%>
								&nbsp;&nbsp;<a href="javascript:void(0);" onclick="killSession('<%= 
									sessionActive.getId() %>')"; >supprimer la session</a>
<%
		}
%>
							</td>
						</tr>
					</table>
											
					<div id="divInfo<%= i %>" style="padding-left: 10px;">
						login : <%= uUserSession.getLogin() %><br/>
						Navigateur : <span <%= sInfoStyle%> ><%=  sUserAgentSession %></span><br/>
						Host : <span <%= sInfoStyle%> ><%=  sRemoteHostSession %></span><br/>
						Dernier accès : <span <%= sInfoStyle%> ><%=  CalendarUtil.getDateFormattee(new Timestamp(sessionActive.getLastAccessedTime()))  %></span><br/>
						Durée : <span <%= sInfoStyle%> ><%= CalendarUtil.getDureeString(new Timestamp(lTimeDuration)) %></span><br/>
						Derniere page visitée : <span <%= sInfoStyle%> ><%= sUriLastAccess %></span><br/>
						Intervalle max d'inactivité : <span <%= sInfoStyle%> ><%=  sessionActive.getMaxInactiveInterval() %> s</span><br/>
						Session ID : <span <%= sInfoStyle%> ><%=  sessionActive.getId() %></span><br/>
					</div>
				</td>
			</tr>
		</table>
	</div>	
		<% 
	} catch (Exception e) {}
}

%>	
</body>
</div>

<%@page import="org.coin.fr.bean.PersonnePhysiqueCivilite"%></html>