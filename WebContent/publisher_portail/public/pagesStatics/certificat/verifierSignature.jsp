<%@ include file="/include/new_style/headerPublisher.jspf" %>

<%@page import="modula.graphic.Icone"%>
<%@page import="com.oreilly.servlet.multipart.*"%>
<%@page import="java.io.File"%>
<%@ include file="/publisher_traitement/public/include/beanCandidat.jspf" %>
<%
	String sTitle = "V�rificateur de signature";
    String sPageUseCaseId = "IHM-PUBLI-3";  
%>
<%@ include file="/publisher_traitement/public/include/redirectOnLoad.jspf" %>

</head>
<body>
<%@ include file="/publisher_traitement/public/include/header.jspf" %>
<div class="mention">
Prochainement un utilitaire vous permettant de v�rifier l'authenticit� des documents du DCE sign�s par le pouvoir adjudicateur sera � votre disposition.
</div>
<%@include file="/publisher_traitement/public/include/footer.jspf"%>
</body>
</html>