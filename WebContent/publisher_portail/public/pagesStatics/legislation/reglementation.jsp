<%@ include file="/include/new_style/headerPublisher.jspf" %>

<%@page import="java.io.File"%>
<%@ include file="/publisher_traitement/public/include/beanCandidat.jspf" %>
<%
	String sTitle = "R�glementation";
    String sPageUseCaseId = "IHM-PUBLI-3";  
%>
<%@ include file="/publisher_traitement/public/include/redirectOnLoad.jspf" %>

</head>
<body>
<%@ include file="/publisher_traitement/public/include/header.jspf" %>
<div class="mention">
Voici quelques textes relatifs � la r�glementation actuelle en mati�re de march�s publics. Ces textes proviennent du site legifrance.gouv.fr.
</div><br />
<%@ include file="/publisher_traitement/public/pagesStatics/legislation/pave/paveReglementation.jspf" %> 
<%@include file="/publisher_traitement/public/include/footer.jspf"%>
</body>
</html>