<%@ include file="../../../../include/headerXML.jspf" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%
Whois whois = (Whois)session.getAttribute(HabilitationFilterUtil.SESSION_WHOIS);
if(whois == null)
{
	whois = new Whois(request.getRemoteAddr());
	whois.sendQuery();
	session.setAttribute(HabilitationFilterUtil.SESSION_WHOIS, whois);
}



%><%@page import="org.coin.net.Whois"%>
<%@page import="org.coin.servlet.filter.HabilitationFilterUtil"%>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="fr" lang="fr">
<head>
<meta HTTP-EQUIV="Expires" CONTENT="-1" />
<meta HTTP-EQUIV="Cache-Control" CONTENT="no-cache, must-revalidate" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache" /> 
<body>
<p>
Vous ne pouvez pas accéder à cette page.<br/>
Pour plus de renseignement vous pouvez contacter votre fournisseur d'accès internet ou appeler le numéro suivant :  08 92 23 02 41 (0,34 euro /min)<br/>
<br/>
IP : <%= whois.getIpAddress() %>

</p>
</body>
</html>