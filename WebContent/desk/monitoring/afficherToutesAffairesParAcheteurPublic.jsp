<%@ include file="../../include/headerXML.jspf" %>

<%@ page import="org.coin.db.*,java.sql.*,org.coin.bean.perf.*, java.util.*,modula.marche.*" %>
<%

	String sSqlQuery
		= "	SELECT count(*), org.id_organisation, org.raison_sociale,  mar.id_marche_passation, proced.libelle"
		+ " FROM marche mar, organisation org, commission com, algo_affaire_procedure algo_aff, marche_passation proced"
		+ " WHERE org.id_organisation = com.id_organisation"
		+ " AND com.id_commission = mar.id_commission"
		+ " AND mar.id_algo_affaire_procedure <> 29"
		+ " AND algo_aff.id_algo_affaire_procedure = mar.id_algo_affaire_procedure"
		+ " AND algo_aff.id_marche_passation = proced.id_marche_passation"
		+ " GROUP BY org.id_organisation,  mar.id_algo_affaire_procedure"
		+ " ORDER BY org.raison_sociale,  mar.id_algo_affaire_procedure";

		
	String sTitle = "Liste des affaires par acheteur public";
	String rootPath = request.getContextPath()+"/";
 %>
<%@ include file="../../desk/include/headerDesk.jspf" %>
</head>
<body >
<table class="pave" >
	<tr>
		<td>
<table  class="liste">
	<tr>
		<th>Acheteur Public</th>
		<th>Procédure</th>
		<th>Consommation</th>
	</tr>

<%
	ResultSet rs = null;
	int i = 0;
	int iIdOrganisation = -1;
	try {
		rs = ConnectionManager.executeQuery(sSqlQuery );
		while(rs.next()) 
		{
			int j = i % 2;
			String sAP = "";
			if(iIdOrganisation != rs.getInt(2))
			{
				String sUrlRedir = rootPath + "desk/organisation/afficherOrganisation.jsp?iIdOrganisation=" + rs.getInt(2);
				sAP = "<a href='" + response.encodeURL(sUrlRedir) + "' >" + rs.getString(3) + "</a>";
			}
			
			iIdOrganisation = rs.getInt(2);
			
%>

	<tr class="liste<%=j%>">
		<td><%= sAP  %></td>
		<td><%= rs.getString(5) %> </td>
		<td><%= rs.getInt(1) %> </td>
	</tr>
<% 
			i++;
		}
	}
	catch (Exception e) {
		e.printStackTrace();
		throw e;
	}finally {
		ConnectionManager.closeConnection(rs);
	}
 %>
 </table>
 </td>
 </tr>
 </table>
 </body>
</html>