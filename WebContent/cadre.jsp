<% 
	String sTitle = "Modula Publisher" ; 
	String sDesignUseOrganisationId = request.getParameter("design_use_organisation_id");

	int iIFrameWidth = Configuration.getIntValueMemory("welcome.page.cadre.iframe.width", 760);
	String rootPath = request.getContextPath() +"/";
 
%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.bean.conf.Configuration"%>
<html>
<head>
	<title><%=sTitle%></title>
</head>
<body style="background-color:#EEE">
	<table cellpadding="0" align="center">
		<tr> 
			<td width="<%= iIFrameWidth %>" style="vertical-align:top" align="center"  >
				<iframe name="main" id="main" frameborder="0" src="<%= 
					response.encodeURL( rootPath +  "publisher_portail/public/annonce/afficherAnnonces.jsp?design_use_organisation_id="
							+sDesignUseOrganisationId) 
						%>" width="<%= iIFrameWidth %>" height="2000"></iframe> 
	      	</td>
		</tr>
	</table>
</body>
</html>
