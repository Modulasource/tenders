
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.security.MD5"%>
<%@page import="org.coin.util.FileUtil"%>
<%@page import="org.coin.util.Outils"%>
<%
String sScript = "";

String sAction = HttpUtil.parseStringBlank("action",request);
String sNS = HttpUtil.parseStringBlank("ns",request);
String sHilo = HttpUtil.parseStringBlank("hilo",request);

String sSessionId = ";jsessionid="+session.getId();

if(sAction.equalsIgnoreCase("eval")){
	long b = System.currentTimeMillis();
	%>
	
<%@page import="java.math.BigDecimal"%>
<%@page import="java.math.RoundingMode"%><div><!--
	<%@ include file="files/lo.inc.jspf" %>
	--></div>
	<%
	long e = System.currentTimeMillis();
	long d =e-b;
	if(d>=2000) { // if more than 2s to download 128K -> low bw
		sScript += "g_hi_lo = 'lo';\n";
		sScript += "g_dwweight = 128;\n";
		sScript += "g_upweight = 32;\n";
	} else {
		sScript += "g_hi_lo = 'hi';\n";
		sScript += "g_dwweight = 512;\n";
		sScript += "g_upweight = 128;\n";
	}
	
	sScript += "console('ServerID: " + request.getServerName()+ "');\n";
	sScript += "console('BrowserID: " +request.getHeader("User-Agent")+ "');\n";
	sScript += "console('ConnectionID: " +request.getRemoteHost()+ " [" +request.getRemoteAddr()+ "]" + "');\n";
	sScript += "console(str_console_preeval+g_dwweight+'K/'+g_upweight+'K');\n";
	sScript += "SpeedZilla ( "+sNS+ ");";
}else if(sAction.equalsIgnoreCase("dw")){
	// setup the line (auto adapted rwin)
	%>
	<div id="load">
	<div><!--
	<%@ include file="files/lo.inc.jspf" %>
	--></div>
	<%= MD5.getEncodedString(""+System.currentTimeMillis()) %>
	<%
	// we measure the download time of the specified file
	long b = System.currentTimeMillis();
	%>
	<div><!--
	<% if(sHilo.equalsIgnoreCase("hi")){ %>
	<%@ include file="files/hi.inc.jspf" %>
	<%} else if(sHilo.equalsIgnoreCase("lo")){ %>
	<%@ include file="files/lo.inc.jspf" %>
	<%} %>
	--></div>
	</div>
	<%
	long e = System.currentTimeMillis();
	long d = e-b;
	
	sScript += "g_difftime[g_count] = (" + d + "/1000)\n";
	sScript += "g_count--;\n";
	sScript += "console((" + d + "/1000)+' s');\n";//Outils.round((d/1000), 4)
	sScript += "this.document.getElementById('load').innerHTML = '';\n";
	sScript += "SpeedZilla ( " +sNS+ ");";
	
}else if(sAction.equalsIgnoreCase("upstart")){
	%>
	<% if(sHilo.equalsIgnoreCase("hi")){ %>
	<%@ include file="files/uphi.inc.jspf" %>
	<%} else if(sHilo.equalsIgnoreCase("lo")){ %>
	<%@ include file="files/uplo.inc.jspf" %>
	<%} %>
	<%
	sScript = "g_upstart=gettimestamp();\n";
	sScript += "new Ajax.Updater('spdtc', 'do.jsp"+sSessionId+"', {\n";
	sScript += "	asynchronous: true,\n";
	sScript += "	evalScripts: true,\n";
	sScript += "	postBody: decodeURI(Form.serialize(document.upform))\n});";
	
}else if(sAction.equalsIgnoreCase("upstop")){
	sScript = "g_upstop=gettimestamp();\n";
	sScript += "SpeedZilla(3);";
}else if(sAction.equalsIgnoreCase("latency")){
	sScript = "SpeedZilla ( "+ sNS + ");";
}
%>
<script type="text/javascript">
<%= sScript %>
</script>
