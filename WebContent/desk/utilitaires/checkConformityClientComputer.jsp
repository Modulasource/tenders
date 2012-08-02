<%@ include file="../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.security.*" %>
<%
	String sTitle = "Test de la conformité du poste";
	
	Candidature candidature = new Candidature();
%>
</head>
<body>
<%@ include file="../../include/new_style/headerFiche.jspf" %>
<br />
<div style="padding:15px">

<%@ include file="../../publisher_traitement/private/candidat/pave/paveVerifierSysteme.jspf" %>

</div>
<%@ include file="../../include/new_style/footerFiche.jspf" %>
</body>
<%@page import="modula.candidature.Candidature"%>
</html>