<%@ include file="../../include/headerXML.jspf" %>

<%@ page import="org.coin.db.*,org.coin.bean.perf.*, java.util.*,javax.naming.*,java.sql.*" %>
<%
	String sTitle = "Liste des ";
	String rootPath = request.getContextPath()+"/";
	String sUrlRequested = request.getParameter("sUrlRequested");
	
%><%@ include file="../../desk/include/headerDesk.jspf" %>
</head>
<body >
<table class="pave" >
	<tr>
		<td>
<table  class="liste">
	<tr>
		<th>Hits</th>
		<th>Date</th>
		<th>Temps (ms)</th>
	</tr>
<%
	ResultSet rs = null;
	String sSqlQuery 
		= "SELECT COUNT(*) as url_hits, YEAR(date_creation), MONTH(date_creation), DAYOFMONTH(date_creation), sum(duration_millisecond)"
		+ " FROM mesure "
		+ " WHERE url_requested ='" + sUrlRequested + "' "
		+ " GROUP BY  YEAR(date_creation), MONTH(date_creation), DAYOFMONTH(date_creation) "
		+ " ORDER BY YEAR(date_creation), MONTH(date_creation), DAYOFMONTH(date_creation)";
	int i = 0;
	try {
		rs = ConnectionManager.executeQuery(sSqlQuery );
		while(rs.next()) 
		{
			int j = i % 2;
	
%>

	<tr class="liste<%=j%>">
	 	<td><%= rs.getInt(1) %> </td>
		<td><%= rs.getString(4) + "/" + rs.getString(3) + "/" + rs.getString(2)  %> </td>
		<td><%= rs.getInt(5) / rs.getInt(1)%> </td>
	</tr>
<% 
			i++;
		}
	}
	catch (SQLException e) {
		e.printStackTrace();
		throw e;
	}
	catch (NamingException e) {
		throw e;
	}
	finally {
		ConnectionManager.closeConnection(rs);
	}
 %>
</body>
</html>