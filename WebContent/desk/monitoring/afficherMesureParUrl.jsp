<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.db.*,org.coin.bean.perf.*, java.util.*,javax.naming.*,java.sql.*" %>
<%
	String sTitle = "Liste des ";	
%>
</head>
<body >
<%@ include file="../../include/new_style/headerFiche.jspf" %>
<div style="padding:15px">
<table class="pave" >
	<tr>
		<td>
<table  class="liste">
	<tr>
		<th>Hits</th>
		<th>URL</th>
		<th>durée globale</th>
		<th>durée moyenne</th>
	</tr>
<%
	ResultSet rs = null;
	String sSqlQuery 
		= "SELECT COUNT(*) as url_hits, "+CoinDatabaseUtil.getSqlText2VarcharFunction("url_requested")+" as url_requested_string , sum(duration_millisecond)"
		+ " FROM mesure "
		+ " GROUP BY "+CoinDatabaseUtil.getSqlText2VarcharFunction("url_requested")
		+ " ORDER BY url_hits desc, url_requested_string ";
	int i = 0;
	try {
		rs = ConnectionManager.executeQuery(sSqlQuery );
		while(rs.next()) 
		{
			int j = i % 2;
			//String sUrlRedir = "afficherToutesMesure.jsp?sWhereClause=WHERE+url_requested+=\""+ rs.getString(2) + "\"";
			String sUrlRedir = "afficherMesurePourUrl.jsp?sUrlRequested=" + rs.getString(2);
%>

	<tr class="liste<%=j%>">
	 	<td><%= rs.getInt(1) %> </td>
		<td><a href='<%= response.encodeURL(sUrlRedir) %>' ><%= rs.getString(2) %></a> </td>
		<td><%= rs.getString(3) %> </td>
		<td><%= rs.getInt(3) / rs.getInt(1)%> </td>
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
 </table>
 </td>
 </tr>
 </table>
</div>
<%@ include file="../../include/new_style/footerFiche.jspf" %>
</body>
</html>