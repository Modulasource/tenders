
<%@page import="java.util.Enumeration"%>
<jsp:useBean id="sessionUser" scope="session" class="org.coin.bean.User" />
<%
	sessionUser.logout();

	Enumeration eEnum = session.getAttributeNames();
	while (eEnum.hasMoreElements())
	{
		session.removeAttribute(eEnum.nextElement().toString());
	}

	session.invalidate();
	response.sendRedirect(response.encodeURL("mlogon.jsp"));
%>