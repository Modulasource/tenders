<%@ include file="/include/headerXML.jspf" %>
<%@ page import="org.coin.fr.bean.*" %>
<%@ include file="/publisher_traitement/public/include/beanSessionUser.jspf" %>
<%
	String sTitle = "Accusé de réception d'une publication";
	String sMessage = request.getParameter("bMessage");
%>
<%@ include file="/include/headerPublisher.jspf" %>
<%@ include file="/publisher_traitement/public/include/beanCandidat.jspf" %>   
<%@ include file="/publisher_traitement/public/include/redirectOnLoad.jspf" %>
</head> 
<body>
<%@ include file="public/include/header.jspf" %><br /> 
	<table style="vertical-align:top;width:100%;border:0" >
		<tr>
			<td><div class="titre_page"><%=sTitle%></div><div style="clear:both"></div></td>
		</tr>
		<tr>
			<td style="vertical-align:top;">
				<table class="pave" cellpadding="10" style="vertical-align:top;" >
					<tr>
						<td style="text-align:left"><br />
							&nbsp;&nbsp;Merci d'avoir accusé réception de la publication.<br /><br />
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
<%@include file="public/include/footer.jspf"%>
</body>
</html>