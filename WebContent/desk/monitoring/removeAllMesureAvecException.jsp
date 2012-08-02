
<%@ page import="org.coin.bean.perf.*, java.util.*" %>
<%
	Vector<Mesure> vMesures 
		= Mesure.getAllMesureWithWhereAndOrderByClause(
			" WHERE mesure.exception IS NOT NULL ",
			" ORDER BY date_creation DESC ");
	for(int i = 0; i < vMesures.size(); i++)
	{
		Mesure mesure = vMesures.get(i);
		if(mesure.getException() != null)
		{
			mesure.removeWithMesurePoints();
		}
	}
	
	response.sendRedirect(
		response.encodeURL("afficherMonitoring.jsp"));
 %>
