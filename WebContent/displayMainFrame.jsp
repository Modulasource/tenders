<%
	String sTitle = "Les marchés publics";
	String sMainFrameUrl = "cadre.jsp";
	//String sPreURI = "";
    //String sParam = "";
	
	try {
		URL urlRequest = new URL( request.getRequestURL().toString());
		sMainFrameUrl = Configuration.getConfigurationValueMemory("publisher.main.frame.url:" + urlRequest.getHost());
		sTitle = Configuration.getConfigurationValueMemory("publisher.main.frame.title:" + urlRequest.getHost());
	} catch (CoinDatabaseLoadException e){}
	
	/*try {
		if(request.getParameter("pre") != null && !request.getParameter("pre").equals("")) {
			if(sMainFrameUrl.contains("?")) sPreURI = "&pre="+request.getParameter("pre");
			else sPreURI = "?pre="+request.getParameter("pre");
		}
	} catch (Exception e) {}
	
    try {
        if(request.getParameter("filtreType") != null) {
            sParam = "&filtreType="+request.getParameter("filtreType");
        }
        if(request.getParameter("filtre") != null) {
            sParam += "&filtre="+request.getParameter("filtre");
        }
    } catch(Exception e) {}*/
	
	// sMainFrameUrltemplatesClients/antillesLegales/index.jsp
	System.out.println("sMainFrameUrl" + sMainFrameUrl);
	
%>
<%@ include file="/include/new_style/headerPublisher.jspf" %> 
<%@page import="org.coin.db.CoinDatabaseLoadException"%>
<%@ page import="org.coin.bean.conf.*" %>
<style type="text/css">
<!--
html{
 margin:0;
 padding:0;
 border:0;
 height: 100%;
}

body {
 margin:0;

}
-->
</style>
<script type="text/javascript">
<!--
function resizeLayout() {
 var h = Element.getHeight(document.documentElement);
 $('pagesContainer12').style.height = (h-5)+"px"; 
}

Event.observe(window, 'load', resizeLayout);
Event.observe(window, 'resize', resizeLayout);

//-->
</script>
</head>
<body scroll="no">
<iframe id="pagesContainer12" frameborder="0" src="<%= 
	response.encodeURL(rootPath + sMainFrameUrl /*+ sPreURI + sParam*/) %>" 
	width="100%"  ></iframe> 
</body>
<%@page import="java.util.Vector"%>
<%@page import="java.net.URL"%>
</html>
