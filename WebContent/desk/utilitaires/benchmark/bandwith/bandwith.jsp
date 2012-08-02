<%@ include file="/include/new_style/headerDesk.jspf" %>

<%
	String sTitle = "Bandwith Test";

	String sRemoteAddrRequest = request.getRemoteAddr();
	String sRemoteHostRequest = request.getRemoteHost();
%>
<link rel="stylesheet" type="text/css" href="<%= response.encodeURL("css/spdz.css")%>" />
<link rel="stylesheet" type="text/css" href="<%= response.encodeURL("css/custom.css")%>" />
<script type="text/javascript">
var sSessionId = ";jsessionid=<%= session.getId() %>";
</script>
<script type="text/javascript" src="<%= response.encodeURL("lang/"+sessionLanguage.getShortLabel()+".js") %>"></script>
<script type="text/javascript" src="<%= response.encodeURL("js/spdz.js")%>"></script>
<script type="text/javascript">
onPageLoad = function() {
	$("dwtitle").innerHTML = lang['Download'];
	$("connection").innerHTML = lang['YourConnection'] +"<%= sRemoteHostRequest%> [<%= sRemoteAddrRequest %>]";
	$("status").innerHTML = lang['InitialStatus'];
	$("uptitle").innerHTML = lang['Upload'];
	$("stb").innerHTML = lang['RestartButton'];
	$("imgcopy").alt = lang['Copyright'];
	
	SpeedZilla(0, null);
}
</script>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<div style="padding:15px">
	<div id="spdtc" style="display:none;"></div>
	<div id="center">
		<div id="resw">
			<div id="connection"></div>
			<div id="status"></div>
			<div class="bargraph">
				<div class="bargraphtitle" id="dwtitle"></div>
				<div class="barcontainer"><div class="cal">&nbsp;</div><div id="dwbar"></div><div id="dwtext"><strong>&nbsp;</strong></div></div>
			</div>
			<div class="clr"></div>
			<div id="scale">
				<div class="step" style="width:15.488%"><span class="label">56k&nbsp;</span></div>
				<div class="step" style="width:5.556%"><span class="label">100k&nbsp;</span></div>
				<div class="step" style="width:15.152%"><span class="label">512k&nbsp;</span></div>
				<div class="step" style="width:6.566%"><span class="label">1m&nbsp;</span></div>
				<div class="step" style="width:21.886%"><span class="label">10m&nbsp;</span></div>
				<div class="step" style="width:21.886%"><span class="label">100m&nbsp;</span></div>
				<div class="stepn" style="width:10%"><span class="label">log&nbsp;</span></div>
			</div>
			<div class="clr"></div>
			<div class="bargraph">
				<div class="bargraphtitle" id="uptitle"></div>
				<div class="barcontainer"><div class="cal">&nbsp;</div><div id="upbar"></div><div id="uptext"><strong>&nbsp;</strong></div></div>
			</div>
			<div class="clr"></div>
			<div id="bottomblock">
				<div style="float:left;">
					<textarea id="console" rows="7" cols="45" readonly="readonly"></textarea>
					<div class="copyspeed">
						<a href="http://www.speedzilla.net/" target="_blank"><img id="imgcopy" src="<%= response.encodeURL("css/copy6.png") %>" alt="" border="none" /></a>
					</div>
				</div>
				<div id="right">
					<div id="results"></div>
					<button id="stb" onclick="SpeedZilla(0);return false;" style="display:none;"></button>
				</div>
			</div>
		</div>
	</div>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>