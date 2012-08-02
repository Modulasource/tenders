<%@ include file="../../include/new_style/headerDesk.jspf" %>
<%@ page import="java.util.*, org.json.*" %>
<%@page import="org.coin.localization.*"%>
<%

	
	String sTitle = "Localize matrix";
	Vector<CaptionCategory> vCaptionCategory = CaptionCategory.getAllStatic();
	
	Vector<Language> vLanguage = Language.getAllStatic();

	
	
%>
</head>
<body>
<%@ include file="../../include/new_style/headerFiche.jspf" %>
<div id="fiche">
	
	<div class="dataGridHolder fullWidth">
		<table class="dataGrid fullWidth">
		<tr class="header">
		    <td>Category</td>
		    <td>Index</td>
<%
	
	for (Language captionValue : vLanguage) {
%>	
			<td><%= captionValue.getName() %></td>
<%
	}	
%>
		</tr>
<%




	for (int j = 1; j <= Localize.COUNT_CAPTION_CATEGORY ; j++) 
	{
		for (int k = 1; k <=Localize.MAX_CAPTION_VALUE_INDEX; k++) 
		{
			CaptionCategory captionCategory = CaptionCategory.getCaptionCategory(1,vCaptionCategory);
			
			%>
		<tr>
			<td><%= captionCategory.getName() %></td>
			<td><%= k %></td>
			<%
			for (int i = 1; i <= Localize.COUNT_LANGUAGE; i++) {
				String sValue = "";
				if(Localize.LOCALIZED_MATRIX[i][j][k] != null )
				{
					sValue =  Localize.LOCALIZED_MATRIX[i][j][k];
				} else {
					sValue = " - ";
				}
				%><td><%= sValue %></td>
				<%
			}
		%>
		</tr>
		<%
		}
	}

%>
	</table>
	</div>
	
</div>
<%@ include file="../../include/new_style/footerFiche.jspf" %>
</body>

</html>