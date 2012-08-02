<%@ page contentType="text/html; charset=UTF-8" %>
<%
	String rootPath = request.getContextPath() + "/";
	String sRootUrl = null;

	try {
		sRootUrl = Configuration.getConfigurationValueMemory("welcome.page.url");
	} catch (CoinDatabaseLoadException e){
	}
	String sWelcomeImagePath = null;
	try {
		sWelcomeImagePath = Configuration.getConfigurationValueMemory("welcome.image.path");
	} catch (CoinDatabaseLoadException e){
	}

	String sWelcomePageDeskUrlLabel = null;
	try {
		sWelcomePageDeskUrlLabel = Configuration.getConfigurationValueMemory("welcome.page.desk.url.label");
	} catch (CoinDatabaseLoadException e){
		sWelcomePageDeskUrlLabel = "ESPACE ACHETEURS PUBLICS";
	}
	
	String sWelcomePagePublisherUrlLabel = null;
	try {
		sWelcomePagePublisherUrlLabel = Configuration.getConfigurationValueMemory("welcome.page.publisher.url.label");
	} catch (CoinDatabaseLoadException e){
		sWelcomePagePublisherUrlLabel = "ESPACE DE PUBLICATION";
	}
	
	String sWelcomePageTitle = null;
	try {
		sWelcomePageTitle = Configuration.getConfigurationValueMemory("welcome.page.title");
	} catch (CoinDatabaseLoadException e){
		sWelcomePageTitle = "Bienvenue sur la plate-forme de dématérialisation de marchés publics";
	}
	
	String sPublisherUrl = null;
	try {
		sPublisherUrl = Configuration.getConfigurationValueMemory("publisher.url");
	} catch (CoinDatabaseLoadException e){
		sPublisherUrl = "";
	}
	
	if (sRootUrl != null)
	{
%><jsp:include flush="true" page="<%= response.encodeURL( sRootUrl) %>"></jsp:include><%
		return ;
	}
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@page import="org.coin.db.*"%>
<%@page import="modula.graphic.*"%>
<%@page import="org.coin.bean.conf.Configuration"%>
<%@page import="org.coin.localization.*"%>
<%@page import="org.coin.ui.Border"%>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="fr" lang="fr">
<head> 
<title><%= sWelcomePageTitle %></title>
<link rel="stylesheet" type="text/css" href="<%= rootPath %>include/new_style/<%= Theme.getDeskCSS() %>.css" media="screen" />  
<link rel="SHORTCUT ICON" href="<%= rootPath %>include/<%= Theme.getShortcutIcon() %>" /> 
</head>  
<body>
<br />   
<table style="height:100%;width:100%;border:0px" >
  <tr> 
<%
	if(sWelcomeImagePath != null)
	{
%>
    <td colspan="2" style="text-align:center">
    	<img src="<%=  sWelcomeImagePath %>" alt="Welcome image" />
    </td>
<%
	}
%>
  </tr> 
  <tr>
    <td style="width:50%;text-align:center;vertical-align:top"> 
      	<h2>
    	  	<a href="<%= rootPath %>desk/index.jsp">  
    	  		<img src="<%= rootPath + Icone.PUCE_FLECHE %>" style="vertical-align:middle" alt="puce" />
	    		<%= sWelcomePageDeskUrlLabel %>
		    </a>
    	</h2>
    </td>
<%
	if(!sWelcomePagePublisherUrlLabel.equals("#NO_PUBLISHER#"))
	{
%>    
    <td style="width:50%;text-align:center;vertical-align:top;height:70%"> 
		<h2> 
			<a href="<%=  sPublisherUrl %>">
    	  		<img src="<%= rootPath + Icone.PUCE_FLECHE %>" style="vertical-align:middle" alt="puce" />
				 <%= sWelcomePagePublisherUrlLabel %>
	    	</a>
        </h2>
    </td>
<%
	}
%>    
  </tr>
</table>



</body>
</html>