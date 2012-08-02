<%@ include file="/include/new_style/headerPublisher.jspf" %>

<%@page import="java.io.File"%>
<%@ include file="/publisher_traitement/public/include/beanCandidat.jspf" %>
<%
	String sTitle = "Informations administratives";
    String sPageUseCaseId = "IHM-PUBLI-3";  
    /* on recupere le rootPath pour determiner les pdf qui
       doivent etre telechargeables */
    // FLON : 8 = ???
    String sPath = rootPath.substring(8,rootPath.length()-1);
%>
<%@ include file="/publisher_traitement/public/include/redirectOnLoad.jspf" %>
</head>
<body>
<%@ include file="/publisher_traitement/public/include/header.jspf" %>
<%@ include file="/publisher_traitement/public/pagesStatics/pave/paveInfosAdm.jspf" %> 
<%@include file="/publisher_traitement/public/include/footer.jspf"%>
</body>
</html>