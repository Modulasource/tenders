<%@ include file="/include/new_style/headerPublisher.jspf" %>

<%@page import="java.io.File"%>
<%@ include file="/publisher_traitement/public/include/beanCandidat.jspf" %>
<%
	String sTitle = "Liens utiles";
    String sPageUseCaseId = "IHM-PUBLI-3";  
%>
<%@ include file="/publisher_traitement/public/include/redirectOnLoad.jspf" %>

</head>
<body>
<%@ include file="/publisher_traitement/public/include/header.jspf" %>
<div class="mention">
Pour en savoir plus sur les marchés publics, vous pouvez consulter les sites suivants :
</div>
<br />
<%@ include file="/publisher_traitement/public/pagesStatics/legislation/pave/paveLiensUtiles.jspf" %> 
<%@include file="/publisher_traitement/public/include/footer.jspf"%>
</body>
</html>