<%@ include file="/include/new_style/headerPublisher.jspf" %>

<%@page import="modula.graphic.Icone"%>
<%@page import="com.oreilly.servlet.multipart.*"%>
<%@page import="java.io.File"%>
<%@ include file="/publisher_traitement/public/include/beanCandidat.jspf" %>
<%
	String sTitle = "Liste des autorit�s d�livrants des certificats";
    String sPageUseCaseId = "IHM-PUBLI-3";  
%>
<%@ include file="/publisher_traitement/public/include/redirectOnLoad.jspf" %>

</head>
<body>
<%@include file="/publisher_traitement/public/include/header.jspf" %>
<%@include file="/publisher_traitement/public/pagesStatics/certificat/pave/paveListeAutorites.jspf" %> 
<%@include file="/publisher_traitement/public/include/footer.jspf"%>
</body>
</html>