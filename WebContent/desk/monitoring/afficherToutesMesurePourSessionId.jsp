<%@ include file="../../include/headerXML.jspf" %>

<%@ page import="org.coin.bean.perf.*, java.util.*" %>
<%

	String sTitle = "Liste des ";
	String rootPath = request.getContextPath()+"/";
	Vector<Mesure> vMesures 
		= Mesure.getAllMesureWithWhereAndOrderByClause(
			" WHERE session_id = '" + request.getParameter("sSessionId") + "'" + sSystemContraint,
			" ORDER BY date_creation DESC ");
 %>
<%@ include file="../../desk/include/headerDesk.jspf" %>
</head>
<body >
<%@ include file="pave/paveAfficherListeMesures.jspf" %>
</body>
</html>