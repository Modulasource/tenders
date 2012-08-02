<%@ include file="../../include/headerXML.jspf" %>

<%@ page import="org.coin.bean.perf.*, java.util.*" %>
<%
//TODO: attention c'est vraiment pas bien tout ca niveau secu

	String sWhereClause = "";
	if(request.getParameter("sWhereClause") != null)
		sWhereClause = HTMLEntities.unhtmlentitiesComplete( request.getParameter("sWhereClause"));

	String sOrderByClause = " ORDER BY date_creation DESC ";
	if(request.getParameter("sOrderByClause") != null)
		sOrderByClause = HTMLEntities.unhtmlentitiesComplete(request.getParameter("sOrderByClause"));
	
	// TODO : revoir ces purges en SQL
	Vector<Mesure> vMesures = Mesure.getAllMesureWithWhereAndOrderByClause(sWhereClause,sOrderByClause );

	String sTitle = "Liste des mesures";
	String rootPath = request.getContextPath()+"/";
 %>
<%@ include file="../../desk/include/headerDesk.jspf" %>
</head>
<body >
<%@ include file="pave/paveAfficherListeMesures.jspf" %>
</body>
<%@page import="org.coin.db.CoinDatabaseAbstractBean"%>
<%@page import="org.coin.util.HTMLEntities"%>
</html>