<%@ include file="/include/new_style/headerPublisher.jspf" %>
<%@ page import="modula.candidature.*" %>
<%@ page import="modula.*,java.util.*" %> 
<%@ page import="org.coin.fr.bean.*" %>
<%@ include file="/publisher_traitement/public/include/beanCandidat.jspf" %> 
<%
	String sTitle = "Informations site";
	String path_page = "pave/"+request.getParameter("page");
%>
<%@ include file="/publisher_traitement/public/include/redirectOnLoad.jspf" %>
</head>
<body>
<%@ include file="/publisher_traitement/public/include/header.jspf" %>

<div style="padding:20px;text-align:center;max-width:700px;margin:0 auto">
    <div class="post" >
        <div class="post-title" >Informations site</div>
        <div class="post-header post-block" style="text-align:left" >
        	<jsp:include page="<%=path_page%>" />
        </div>
    </div>
</div>

<%@include file="/publisher_traitement/public/include/footer.jspf"%>
</body>
</html>