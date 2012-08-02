<%@ include file="/include/headerXML.jspf" %>
<%@ page import="org.coin.fr.bean.*" %>
<%@ include file="/publisher_traitement/public/include/beanSessionUser.jspf" %>
<%
	String sTitle = "Validation de votre compte";
	String sMessage = request.getParameter("bMessage");
%>
<%@ include file="/include/headerPublisher.jspf" %>
<%@ include file="/publisher_traitement/public/include/beanCandidat.jspf" %>   
<%@ include file="/publisher_traitement/public/include/redirectOnLoad.jspf" %>
</head> 
<body>
<%@ include file="../include/header.jspf" %><br />
	<table style="vertical-align:top;width:100%;border:0" >
		<tr>
			<td><div class="titre_page"><%=sTitle%></div><div style="clear:both"></div></td>
		</tr>
		<tr>
			<td style="vertical-align:top;">
				<table class="pave" cellpadding="10" style="vertical-align:top;" >
					<tr>
						<td style="text-align:left">
						<%
							if(sMessage.equalsIgnoreCase("true")) 
							{ 
							%>Votre compte est désormais validé.<br />
							Vous recevrez un email comprenant vos codes d'accès (login et mot de passe) 
							à la plate-forme Modula.
							<%
							}
							else{%>Vous ne pouvez pas valider ce compte.<%}%>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
<%@include file="/publisher_traitement/public/include/footer.jspf"%>
</body>
</html>