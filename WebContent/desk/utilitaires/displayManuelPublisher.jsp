<%@ include file="../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.security.*" %>
<%
	String sTitle = "Display manuel publisher";
	
	
%>
</head>
<body>
<%@ include file="../../include/new_style/headerFiche.jspf" %>
<div align="center">
<br />
<br />
<button onclick="doUrl('http://prod.modula-demat.com/install/ManuelUtilisateur-PUBLISHER.pdf')"
	>Télécharger le manuel</button>
<br />
<br />
</div>


<%@ include file="../../include/new_style/footerFiche.jspf" %>
</body>
</html>