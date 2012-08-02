<%@ include file="../../include/headerXML.jspf" %>

<%@ page import="org.coin.fr.bean.*,org.coin.bean.*,org.coin.db.*,org.coin.bean.perf.*, java.util.*,javax.naming.*,java.sql.*" %>
<%
	String sTitle = "Liste des ";
	String rootPath = request.getContextPath()+"/";
	String sWhereClause = "";
	
	if(request.getParameter("sWhereClause") != null)
		sWhereClause = request.getParameter("sWhereClause");
	
	
%><%@ include file="../../desk/include/headerDesk.jspf" %>
</head>
<body >
<table class="pave" >
	<tr>
		<td>
<table  class="liste">
	<tr>
		<th>Début de la session</th>
		<th>Hits</th>
		<th>Visiteur</th>
		<th>durée visite</th>
		<th>durée globale</th>
		<th>durée moyenne</th>
	</tr>
<%
	ResultSet rs = null;
	String sSqlQuery 
		= "SELECT COUNT(*) as sid_hits, session_id , id_coin_user, sum(duration_millisecond)"
		+ " FROM mesure "
		+ sWhereClause  
		+ " GROUP BY id_coin_user, session_id "
		+ " ORDER BY sid_hits desc, id_coin_user, session_id ";
		
	int i = 0;
	try {
		rs = ConnectionManager.executeQuery(sSqlQuery );
		while(rs.next()) 
		{
			int j = i % 2;
			String sPersonneNomPrenom = "";
			try {
				User user = User.getUser(rs.getInt(3) );
				PersonnePhysique personne  = PersonnePhysique.getPersonnePhysique(user.getIdIndividual());
				sPersonneNomPrenom 
					= "<a href='" 
					+ response.encodeURL(
						rootPath + "desk/organisation/afficherPersonnePhysique.jsp?" 
						+ "iIdPersonnePhysique="+ personne.getIdPersonnePhysique() )
					+ "' >" + personne.getCivilitePrenomNom() + "</a>"; 
			}catch(Exception e) {
				sPersonneNomPrenom = "non connecté";
			}
			String sWhereClauseFilter =
				" WHERE session_id = '" + rs.getString(2) + "'"
				+ " AND id_coin_user = " + rs.getInt(3);
				
			Mesure mesureFirst 
				= Mesure.getFirstMesureWithWhereClause(	sWhereClauseFilter);

			Mesure mesureLast 
				= Mesure.getLastMesureWithWhereClause(	sWhereClauseFilter);
					
			Timestamp tsDureeVisite = Mesure.getTimestampDelta(mesureFirst, mesureLast);
		
			String sSessionId 
				= "<a href='" 
				+ response.encodeURL(
					rootPath + "desk/monitoring/afficherToutesMesurePourSessionId.jsp?" 
					+ "sSessionId="+ rs.getString(2) )
				+ "' >" + mesureFirst.getDateCreation() + "</a>"; 

%>

	<tr class="liste<%=j%>">
		<td><%= sSessionId %> </td>
	 	<td><%= rs.getInt(1) %> </td>
		<td><%= sPersonneNomPrenom %> </td>
		<td><%= org.coin.util.CalendarUtil.getDureeString(tsDureeVisite)  %> </td>
		<td><%= rs.getInt(4) %> </td>
		<td><%= rs.getInt(4) / rs.getInt(1)%> </td>
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