<%@page import="org.coin.db.ConnectionManager"%>

<%@ page import="org.coin.bean.perf.*, java.util.*" %>
<%
	String sWhereClause = "";
	if(request.getParameter("sWhereClause") != null)
		sWhereClause = request.getParameter("sWhereClause");
	
	// TODO : revoir ces purges en SQL
/*	Vector<Mesure> vMesures = Mesure.getAllMesureWithWhereAndOrderByClause(sWhereClause,"");
	for(int i = 0; i < vMesures.size(); i++)
	{
		Mesure mesure = vMesures.get(i);
		mesure.removeWithMesurePoints();
	}
*/
	
	ConnectionManager.executeUpdate("DELETE FROM mesure ");
	ConnectionManager.executeUpdate("DELETE FROM mesure_point ");


	response.sendRedirect(
		response.encodeURL("afficherMonitoring.jsp"));
	
 %>
