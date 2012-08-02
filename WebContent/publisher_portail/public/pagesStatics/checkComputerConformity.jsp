<%@ include file="/include/new_style/headerPublisher.jspf" %>
<%@ page import="modula.candidature.*" %>
<%@ page import="modula.*,java.util.*" %> 
<%@ page import="org.coin.fr.bean.*" %>
<%@ include file="/publisher_traitement/public/include/beanCandidat.jspf" %> 
<%
	String sTitle = "Test de la conformité du poste";
	 
	Candidature candidature = new Candidature();
%>
<%@ include file="/publisher_traitement/public/include/redirectOnLoad.jspf" %>
</head>
<body>
<%@ include file="/publisher_traitement/public/include/header.jspf" %>

<%@ include file="/publisher_traitement/public/include/menu_hotline.jspf" %>

<%@ include file="/publisher_traitement/private/candidat/pave/paveVerifierSysteme.jspf" %>

		
<%@include file="/publisher_traitement/public/include/footer.jspf"%>
     
</body>
</html>