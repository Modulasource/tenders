<%@page import="org.coin.apache.tomcat.SessionManager"%>
<%

	String sSessionId = request.getParameter("session");

	/**
	* La session peut déja être invalidée
	*/
	try {
		SessionManager.invalidateSession(sSessionId);
	} catch (Exception e) {}

	response.sendRedirect(response.encodeRedirectURL("displayAllActiveSession.jsp"));
%>