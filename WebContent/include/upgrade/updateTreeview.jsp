<%@page import="java.sql.Connection" %>
<%@page import="org.coin.db.ConnectionManager" %>
<%@page import="java.io.PrintWriter" %>
<%@page import="mt.paraph.batch.UpdateTreeview"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@ page import="java.io.*" %>
<html>
<head><title>Treeview Update</title>
<%

boolean bHide =  HttpUtil.parseBoolean("bHide", request, false);
boolean bDoUpdate =  HttpUtil.parseBoolean("bDoUpdate", request, false);

String sDisplay = "";

if(bHide)
	sDisplay = "display: none;";

Connection conn = ConnectionManager.getConnection();
UpdateTreeview ut = new UpdateTreeview(conn);
ut.setPrintWriter(new PrintWriter(out));
ut.setDoUpdate(bDoUpdate);
%>
<script type="text/javascript">
function modifyTreeviewBatch()
{
	var sUrl = '<%= response.encodeURL( "updateTreeview.jsp?bDoUpdate="+true)%>';

	sUrl += "&bHide="+true;
	location.href = sUrl;
	
}
</script>
</head>
<body>
<pre>
<%

try{
	ut.doBatch(conn);
}
catch(Exception ex)
{
	sDisplay = "display: none;";
	String sException = "";
	ByteArrayOutputStream baosException = new ByteArrayOutputStream();
	PrintStream psException = new PrintStream(baosException, true);
	
	ex.printStackTrace(psException);
	sException = baosException.toString();
	
	out.println("An error occurred during the treeview change process");
	out.println();
	out.println("Cause :");
	out.println("\t"+ex.getCause());
	
	out.println("Trace :");
	out.println(sException);
	
}
finally {
	conn.close();
}
%>
</pre>
<div id="divInfoUp" style="<%=sDisplay%>">
This is a preview of the changes that will be performed when you start the process.
Be sure that the above description is exactly what you want to change before doing any action.
</div>
<br>
<div id="divInfoDown" style="<%=sDisplay%>">
Click on the button below to start the treeview change process only if you are fully agree with it.
</div>
<br>
<div id="divButton" style="<%=sDisplay%>">
	<center><button id="btnModifyTreeview" type="button" onclick="modifyTreeviewBatch();" >Start Process</button></center>
</div>
</body>
</html>