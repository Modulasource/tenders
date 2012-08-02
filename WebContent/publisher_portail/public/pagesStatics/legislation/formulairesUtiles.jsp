<%@ include file="/include/new_style/headerPublisher.jspf" %>

<%@page import="modula.graphic.Icone"%>
<%@page import="com.oreilly.servlet.multipart.*"%>
<%@page import="java.io.File"%>
<%@ include file="/publisher_traitement/public/include/beanCandidat.jspf" %>
<%
    String sTitle = "Formulaires utiles";
    String sPageUseCaseId = "IHM-PUBLI-3";  
%>
<%@ include file="/publisher_traitement/public/include/redirectOnLoad.jspf" %>

</head>
<body>
<%@ include file="/publisher_traitement/public/include/header.jspf" %>
<div class="mention">
Voici quelques formulaires provenant du site du Ministère de l'économie et des finances utiles pour
 constituer vos candidatures et offres.
</div>
<br />
<%@include file="/publisher_traitement/public/pagesStatics/legislation/pave/paveFormulairesUtiles.jspf" %> 
<%@include file="/publisher_traitement/public/include/footer.jspf"%>
</body>
</html>