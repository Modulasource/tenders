<%@ include file="../include/headerXML.jspf" %>
<%
	String sTitle = "Le Républicain Lorrain";
%>
<%@ include file="../include/headerPublisher.jspf" %> 
<style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
} 
-->
</style></head>

<body>
<table width="200" align="center" cellpadding="0">
  <tr>
    <td colspan="2"><img src="templatesClients/repu/images/republicain_03.jpg" width="805" height="122"></td>
  </tr>
  <tr>
    <td style="width:130"><img src="templatesClients/repu/images/republicain_05.jpg" width="130" height="716"></td>
    <td style="width:669px;vertical-align:top">
<% if (sDesignUseOrganisationId == null) sDesignUseOrganisationId = "0"; %>
		<iframe name="main" id="main" frameborder="0" src="<%= response.encodeURL("publisher_portail/index.jsp?design_use_organisation_id="+sDesignUseOrganisationId) %>" width="666" height="700"></iframe>
	</td> 
  </tr>
</table>
</body>
</html>
