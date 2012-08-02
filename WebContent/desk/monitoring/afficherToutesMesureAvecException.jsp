<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.perf.*, java.util.*" %>
<%
	String sTitle = "Liste des ";
	Vector<Mesure> vMesures 
		= Mesure.getAllMesureWithWhereAndOrderByClause(
			" WHERE mesure.exception IS NOT NULL ",
			" ORDER BY date_creation DESC ");
 %>
</head>
<body >
<%@ include file="../../include/new_style/headerFiche.jspf" %>
<div style="padding:15px">
<%@ include file="pave/paveAfficherListeMesures.jspf" %>
</div>
<%@ include file="../../include/new_style/footerFiche.jspf" %>
</body>
</html>