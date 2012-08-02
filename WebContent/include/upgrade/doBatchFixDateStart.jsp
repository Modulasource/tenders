<%@page import="mt.paraph.batch.BatchFixDateStart" %>
<%@page import="java.sql.Connection" %>
<%@page import="org.coin.db.ConnectionManager" %>
<html>
<head>
<title>Fix Start Date and Issue Date</title>
<style>
	body	{background-color: gray;}
	pre		{font-size: 8pt; color: yellow;}
</style>
</head>
<body>
<pre>
<%
/**
 * Execute this batch for the resolution of the bug #4131.
 * 
 * Previously, make a backup!
 */
Connection conn = ConnectionManager.getConnection();
try {
	out.println (new BatchFixDateStart (conn).run ());
	out.println ("End");
} finally {
	ConnectionManager.closeConnection (conn);
}
%>
</pre>
</body>
</html>