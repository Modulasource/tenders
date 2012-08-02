<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.*,org.coin.fr.bean.*,org.coin.db.*,org.coin.bean.perf.*,java.sql.*" %>
<%
	String sTitle = "Liste des ";

	String sWhereClause = " WHERE id_coin_user <> 0 ";
	try {
		if(request.getParameter("bDisplayNotConnectedUser").equals("true") )
		{
			sWhereClause = " WHERE 1=1 ";
		}
	}catch (Exception e) {}
	

	int iDayCount= 1;
	try {
		iDayCount = Integer.parseInt( request.getParameter("iDayCount"));
	}catch (Exception e) {}
	
	try {
		if(request.getParameter("bShowAdmin").equals("false") )
		{
			sWhereClause += " AND id_coin_user <> 1 ";
		}
	}catch (Exception e) {}
	
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
		<th>Utilisateur</th>
		<th>Connexion début</th>
		<th>Connexion fin</th>
		<th>Durée visite</th>
		<th>Navigateur</th>
	</tr>
<%
	ResultSet rs = null;
	String sSqlQuery 
		= "SELECT COUNT(*) as user_hits, id_coin_user, session_id, sum(duration_millisecond), user_agent "
		+ " FROM mesure "
		+ sWhereClause 
		+ " AND "+CoinDatabaseUtil.getSqlDateAddFunction(CoinDatabaseUtil.getSqlCurrentDateFunction(), "-"+iDayCount, "DAY")+" < date_creation"
		+ " GROUP BY id_coin_user, session_id, user_agent "
		+ " ORDER BY  id_coin_user, user_hits desc";
	int i = 0;
	try {
		rs = ConnectionManager.executeQuery(sSqlQuery );
		while(rs.next()) 
		{
			int j = i % 2;
	
			String sDureeVisite = "";
			String sPersonneNomPrenom = "";
			try {
				User user = User.getUser(rs.getInt(2) );
				PersonnePhysique personne  = PersonnePhysique.getPersonnePhysique(user.getIdIndividual());
				sPersonneNomPrenom 
					= "<a href='" 
					+ response.encodeURL(
						rootPath + "desk/organisation/afficherPersonnePhysique.jsp?" 
						+ "iIdPersonnePhysique="+ personne.getIdPersonnePhysique() )
					+ "' >" + personne.getPrenomNom() + "</a>"; 
			}catch(Exception e) {
				sPersonneNomPrenom = "non connecté";
			}
			String sWhereClauseFilter =
				" WHERE session_id = '" + rs.getString(3) + "'"
				+ " AND id_coin_user = " + rs.getInt(2);
			
			Mesure mesureFirst 
				= Mesure.getFirstMesureWithWhereClause(	sWhereClauseFilter);

			Mesure mesureLast 
				= Mesure.getLastMesureWithWhereClause(	sWhereClauseFilter);
					
			Timestamp tsDureeVisite = Mesure.getTimestampDelta(mesureFirst, mesureLast);
			String sSessionIdUrl =
					rootPath 
					+ "desk/monitoring/afficherToutesMesure.jsp?"
					+ "sWhereClause=WHERE+session_id+=\""+ rs.getString(3) + "\"" ;
			
%>

	<tr class="liste<%=j%>">
	 	<td><a href='<%= response.encodeURL(sSessionIdUrl ) 
	 		%>' ><img  src="<%= rootPath %>images/icones/fleche.gif" /></a> <%= rs.getInt(1) %>
	 	</td>
		<td><%= sPersonneNomPrenom %></a> </td>
		<td><%= CalendarUtil.getDateFormattee(mesureFirst.getDateCreation()) %> </td>
		<td><%= CalendarUtil.getDateFormattee(mesureLast.getDateCreation()) %> </td>
		<td><%= CalendarUtil.getDureeString(tsDureeVisite) %> </td>
		<td><%= rs.getString(5) %> </td>
	</tr>
<% 
			i++;
		}
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
<%@page import="org.coin.util.CalendarUtil"%>
</html>