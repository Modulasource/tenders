<%@ include file="/include/new_style/headerPublisher.jspf" %>

<%@page import="modula.graphic.Icone"%>
<%@page import="com.oreilly.servlet.multipart.*"%>
<%@page import="java.io.File"%>
<%@ include file="/publisher_traitement/public/include/beanCandidat.jspf" %>
<%
	String sTitle = "Obtenir un certificat électronique";
    String sPageUseCaseId = "IHM-PUBLI-3";  
    String sContactRedirection = "publisher_portail/public/pagesStatics/certificat/commanderCertificat.jsp";
%>
<script type="text/javascript" src="<%=rootPath %>publisher_traitement/public/pagesStatics/contact/pave/checkContactForm.js" ></script>
<%@ include file="/publisher_traitement/public/include/redirectOnLoad.jspf" %>
</head>
<body>
<%@ include file="/publisher_traitement/public/include/header.jspf" %>
<%@ include file="/publisher_traitement/public/pagesStatics/certificat/pave/paveCommanderCertificat.jspf" %> 
<%@include file="/publisher_traitement/public/include/footer.jspf"%>
</body>
</html>