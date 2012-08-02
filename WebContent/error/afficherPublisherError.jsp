<%@page import="org.coin.util.Outils"%>
<%@page import="modula.graphic.Theme"%>
<%@ include file="/include/headerXML.jspf" %>

<%@ page import="java.io.*" %>
<%@ include file="/publisher_traitement/public/include/beanSessionUser.jspf" %>
<%@ include file="/publisher_traitement/public/include/beanCandidat.jspf" %> 
<%
String sTitle = "";
//String rootPath = request.getContextPath() +"/";

String sExceptionClass = "";
if(request.getParameter("sExceptionClass") != null)
	sExceptionClass = request.getParameter("sExceptionClass");

String sRefererURL = request.getHeader("REFERER");
String sRequestURL = request.getRequestURL()+";jsessionid="+request.getRequestedSessionId()+"?"+request.getQueryString();

Exception exception = null;
String sMessage = "";
ByteArrayOutputStream baosException = new ByteArrayOutputStream();
PrintStream psException = new PrintStream(baosException, true);
String sException = "";
ByteArrayOutputStream baosRootException = new ByteArrayOutputStream();
PrintStream psRootException = new PrintStream(baosRootException, true);
String sRootException = "";

if(sExceptionClass.equalsIgnoreCase("ServletException"))
{
	exception = (ServletException)session.getAttribute(sExceptionClass);
	sMessage = exception.getMessage();
	exception.printStackTrace(psException);
	sException = baosException.toString();
	if(((ServletException)exception).getRootCause() != null)
	{
		((ServletException)exception).getRootCause().printStackTrace(psRootException);
		sRootException = baosRootException.toString();
	}
}

String sUrlImage = request.getContextPath() +"/" + Theme.getErrorImage();
String sContentError = Theme.getErrorContent();
%>
<%@ include file="/include/headerPublisher.jspf" %>
<script type="text/javascript" src="<%=rootPath%>include/cacherDivision.js"></script>
<script type="text/javascript">
function onAfterPageLoading()
{
	cacher('exception');
	cacher('rootException');
}
</script>
<%
if(!sessionUserHabilitation.isDebugSession()){
%>
<script type="text/javascript">
window.setTimeout("history.go(-1)",1000); // delai en millisecondes
</script>
<%
}
%>
</head>
<body onload="onAfterPageLoading()">

<div align="center">
<%if(!Outils.isNullOrBlank(sUrlImage)){%>
<a href="javascript:history.go(-1)">
<img src="<%= sUrlImage %>" title="Retour" alt="Retour"  />
</a>
<%}%>
<%if(!Outils.isNullOrBlank(sContentError)){%>
<br/>
<%= sContentError %>
<%}%>
</div>
<%
if(sessionUserHabilitation.isDebugSession()){
%>
<div align="center">
<table class="pave" style="width:100%">
	<tr>
		<td class="pave_titre_gauche" colspan="2">Erreur Exceptionnelle</td>
	</tr>
	<tr>
		<td style="text-align:right;font-weight:bold">
		Message :
		</td>
		<td style="width:80%">
		<%= sMessage %>
		</td>
	</tr>
	<tr>
		<td style="text-align:right;font-weight:bold">
		<a href="javascript:montrer_cacher('exception');montrer_cacher('rootException')">+ En savoir plus...</a>
		</td>
		<td style="width:80%">
		&nbsp;
		</td>
	</tr>
	<tr id="exception">
		<td style="text-align:right;font-weight:bold">
		Cause :
		</td>
		<td style="width:80%">
		<%= sException %>
		</td>
	</tr>
	<tr id="rootException">
	<%
	if(!sRootException.equalsIgnoreCase(""))
	{
	%>
		<td style="text-align:right;font-weight:bold">
		Cause m&egrave;re :
		</td>
		<td style="width:80%">
		<%= sRootException %>
		</td>
	<%
	}
	else{%><td colspan="2">&nbsp;</td><%}%>
	</tr>
</table>
</div>
<%
}
%>
</body>
</html>