<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@page import="org.coin.apache.tomcat.SessionManager"%>

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
<body >
<%@ include file="/include/new_style/headerFiche.jspf" %>
<div style="padding:15px">
<br/>
<table class="pave" >
	<tr>
		<td>
<table class="liste">
	<tr>
		<th>Num</th>
		<th>User</th>
		<th>Host</th>
		<th>Country</th>
		<th>Description</th>
		<th>Max inactive interval</th>
		<th>Durée</th>
		<th>URI</th>
		<th>User agent</th>
		<th>Dernier accès</th>
		<th>Action</th>
	</tr>
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
	    }
	
		if(whois != null)
		{
			sCountry = whois.getCountry();
			sDescription = whois.getDescription();
		}


%>
	
			<tr class="liste<%=j%>">
			 	<td><%= i %> </td>
				<td><%= sUserName %> </td>
				<td><%= sRemoteHostSession %> <%= sRemoteAddrSession %></td>
				<td><%= sCountry %> </td>
				<td><%= sDescription %> </td>
				<td><%= sessionActive.getMaxInactiveInterval()  %> </td>
				<td><%= CalendarUtil.getDureeString(new Timestamp(lTimeDuration))  %> </td>
				<td><%= Outils.truncate2Ways(sUriLastAccess,40)  %> </td>
				<td><%= sUserAgentSession %> </td>
				<td><%= CalendarUtil.getDateFormattee(new Timestamp(sessionActive.getLastAccessedTime()))  %> </td>
				<td><a href="<%= response.encodeURL("modifySession.jsp?session="+ sessionActive.getId()) %>">remove</a></td>
			</tr>
		<% 
	} catch (Exception e) {}
}

%>	</table>
</td>
</tr>
</table>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>

</html>