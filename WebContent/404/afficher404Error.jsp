<%@ include file="../../../../include/headerXML.jspf" %>
<%@ page isErrorPage="true" %>
<%@ include file="../../../include/beanSessionUser.jspf" %>
<%@ page import="modula.*" %>
<%@page import="org.coin.servlet.filter.HabilitationFilterUtil"%><%
String rootPath = request.getContextPath() + "/";
String sPathRedirect = "publisher";


try{
	String sCurrentApplicationName 
		= (String) request.getSession()
			.getAttribute(HabilitationFilterUtil.sSessionCurrentApplicationBeanName);
	
	if(sCurrentApplicationName.equals(UserConstant.USER_SESSION_APPLICATION_PUBLISHER_GENERIQUE) 
	|| sCurrentApplicationName.equals(UserConstant.USER_SESSION_APPLICATION_PUBLISHER_PORTAIL) 
	|| sCurrentApplicationName.equals(UserConstant.USER_SESSION_APPLICATION_DESK))
		sPathRedirect = sCurrentApplicationName;
}catch(Exception e){sPathRedirect = "publisher_portail";}
%>
<script type="text/javascript" src="<%= rootPath %>include/redirection.js" ></script>
<script type="text/javascript">
window.setTimeout("window.location='<%=response.encodeURL(rootPath + sPathRedirect 
		+"/")%>'",1000); // delai en millisecondes
</script>
</head>
<body>
<div align="center">
<br><br><br>
<a href="javascript:history.go(-1)">
	<img border="0" alt="Retour" name="Retour" src="<%= rootPath 
	%>images/fonds/404.jpg" width="309" height="195" ></img>
</a>
</div>
</body>
</html>