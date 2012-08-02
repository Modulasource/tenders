<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="java.io.*" %>
<%
	String sTitle = "";
	
	String sExceptionClass = "";
	if(request.getParameter("sExceptionClass") != null)
		sExceptionClass = request.getParameter("sExceptionClass");
	
	String sRefererURL = request.getHeader("REFERER");
	String sRequestURL = request.getRequestURL()+";jsessionid="+request.getRequestedSessionId()+"?"+request.getQueryString();
	
	String sMessage = "";
	ByteArrayOutputStream baosException = new ByteArrayOutputStream();
	PrintStream psException = new PrintStream(baosException, true);
	String sException = "";
	ByteArrayOutputStream baosRootException = new ByteArrayOutputStream();
	PrintStream psRootException = new PrintStream(baosRootException, true);
	String sRootException = "";

	if(sExceptionClass.equalsIgnoreCase("ServletException"))
	{
		Exception ee = (Exception)session.getAttribute(sExceptionClass);
		if(ee instanceof ServletException)
		{
			if(((ServletException)ee).getRootCause() != null)
			{
				((ServletException)ee).getRootCause().printStackTrace(psRootException);
				sRootException = baosRootException.toString();
			}
		}
		//exception = (ServletException)session.getAttribute(sExceptionClass);
		if(ee.getMessage() != null) sMessage = ee.getMessage();
		ee.printStackTrace(psException);
		sException = baosException.toString();

	}
%>
<script type="text/javascript" src="<%=rootPath%>include/redirection.js"></script>
<script type="text/javascript" src="<%=rootPath%>include/cacherDivision.js"></script>
<script type="text/javascript">
function onAfterPageLoading()
{
	cacher('exception');
	cacher('rootException');
}
</script>
<%
if(!sessionUserHabilitation.isDebugSession())
{
%>
<script type="text/javascript">
window.setTimeout("history.go(-1)",1000); // delai en millisecondes
</script>
<%
}

String sUrlImage = rootPath + Theme.getErrorImage();
String sContentError = Theme.getErrorContent();
%>
</head>
<body onload="onAfterPageLoading()">
<%@ include file="/include/new_style/headerFiche.jspf" %>

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

<div style="padding:15px">
<%
if(sessionUserHabilitation.isDebugSession()){
%>
<div align="center">
<table class="pave" >
	<tr>
		<td class="pave_titre_gauche" colspan="2">Erreur Exceptionnelle</td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr>
		<td style="text-align:right;font-weight:bold">
		Message :
		</td>
		<td style="width:80%;padding-left:5px;">
		<%= sMessage.replaceAll("\n", "\n<br/>") %>
		</td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr>
		<td style="text-align:right;font-weight:bold">
		<a href="javascript:montrer_cacher('exception');montrer_cacher('rootException')">+ En savoir plus...</a>
		</td>
		<td style="width:80%;padding-left:5px;">
		&nbsp;
		</td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr id="exception">
		<td style="text-align:right;font-weight:bold;vertical-align:top;">
		Cause :
		</td>
		<td style="width:80%;padding-left:5px;">
		<%= sException.replaceAll("\n", "\n<br/>") %>
		</td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr id="rootException">
	<%
	if(!sRootException.equalsIgnoreCase(""))
	{
	%>
		<td style="text-align:right;font-weight:bold;vertical-align:top;">
		Cause m&egrave;re :
		</td>
		<td style="width:80%">
		<%= sRootException.replaceAll("\n", "\n<br/>") %>
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
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>

</body>
</html>