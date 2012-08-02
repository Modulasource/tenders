<%@ include file="/include/new_style/headerPublisher.jspf" %>
<%@ page import="modula.candidature.*" %>
<%@ page import="modula.*,java.util.*" %> 
<%@ page import="org.coin.fr.bean.*" %>
<%@ include file="/publisher_traitement/public/include/beanCandidat.jspf" %> 
<%
	String sTitle = "Informations légales";
	
	String sView = "";
	if(request.getParameter("view") != null)
		sView = request.getParameter("view");
	
	String pathInfosLegales = "pave/paveInfosLegales.jspf";
	
	try {
		pathInfosLegales = Configuration.getConfigurationValueMemory("publisher.portail.cgu.url");
	} catch(Exception e){}
	
%>
<%@ include file="/publisher_traitement/public/include/redirectOnLoad.jspf" %>
</head>
<body>
<%@ include file="/publisher_traitement/public/include/header.jspf" %>

<div style="padding:20px;text-align:center;max-width:700px;margin:0 auto">
    <div class="post" >
        <div class="post-title" >Conditions générales d'utilisation</div>
        <div class="post-header post-block" style="text-align:left;height:400px;overflow:auto">
        	<jsp:include page="<%=pathInfosLegales%>" />
        </div>
    </div>
</div>

<%@include file="/publisher_traitement/public/include/footer.jspf"%>
</body>
</html>