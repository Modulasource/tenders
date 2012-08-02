<?xml version="1.0" encoding="ISO-8859-1" ?>
<%@ page contentType="text/html; charset=iso-8859-1" %>
<%@page import="org.coin.bean.User"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%@page import="mt.paraph.folder.util.ParaphFolderSearchEngine"%>
<%
	/**
	 * Example of using 
	 * http://localhost:8080/modula_test/include/webservice/paraph/getUserDocumentBasketCount.jsp?sLogin=florent.fremont@parapheur-test.fr
	 * 
	 * and add in the config table your ip in this entry "system.ws.allowed.ip" 
	 */

	String rootPath = request.getContextPath() +"/";
	String sLogin = HttpUtil.parseStringBlank("sLogin", request);
	Connection conn = ConnectionManager.getConnection();
	request.setAttribute("conn", conn);
	String sUrl = "";
	String sName = "";
	long[] larrCount = null;
	try {
		User user = User.getUserFromLogin(sLogin, false, conn);
		PersonnePhysique person = PersonnePhysique.getPersonnePhysique(user.getIdIndividual(), false, conn);
		sName = person.getPrenomNom();
		larrCount = ParaphFolderSearchEngine.getUserBasketCount(user.getIdIndividual(), conn);
	} catch (Exception e) {
		e.printStackTrace();
	}
	
	ConnectionManager.closeConnection(conn);
%>
<user>
	<login><%= sLogin %></login>
	<name><%= sName %></name>
	<baskets>
<%
	int index = 0;
	for(long count : larrCount)
	{
		String sBasketName = ParaphFolderSearchEngine.DOCUMENT_BASKET_LIST[index];
%>
		<basket >
			<name><%= sBasketName %></name>
			<count><%= count %></count>
		</basket>
<% 		
		index ++;
	}
%>	
	</baskets>
</user>
