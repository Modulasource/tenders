<%@page import="mt.paraph.batch.ScannedSignatureNameAndRatioMigration" %>
<%@page import="java.sql.Connection" %>
<%@page import="org.coin.db.ConnectionManager" %>
<%@page import="java.io.PrintWriter" %>
<html>
<head><title>Scanned Signature Name and Ratio Migration</title></head>
<body>
<pre>
<%
ScannedSignatureNameAndRatioMigration.out = new PrintWriter (out);
Connection connection = ConnectionManager.getConnection ();

try {
	ScannedSignatureNameAndRatioMigration.fillLibelleFields (connection);
	ScannedSignatureNameAndRatioMigration.copyRatios (connection);
	
	out.println ("End");
	
} finally {
	connection.close ();
}
%>
</pre>
</body>
</html>