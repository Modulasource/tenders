<%@ include file="../../../include/headerXML.jspf" %>

<%@ page import="org.coin.fr.bean.*" %>
<%@ include file="../../../publisher_traitement/public/include/beanSessionUser.jspf" %>
<%@ include file="../../../publisher_traitement/public/include/beanCandidat.jspf" %> 
<%
	String sTitle = (String) session.getAttribute("sessionPageTitre");
	String sMessTitle = (String) session.getAttribute("sessionMessageTitre");
	String sMess = (String) session.getAttribute("sessionMessageLibelle");
	String sUrlIcone = (String) session.getAttribute("sessionMessageUrlIcone");
	
	// on vide les attributs de session
	session.setAttribute("sessionPageTitre", "");
	session.setAttribute("sessionMessageTitre", "");
	session.setAttribute("sessionMessageLibelle", "");
	session.setAttribute("sessionMessageUrlIcone", "");
%>
<%@ include file="../../../include/headerPublisher.jspf" %>
<script type="text/javascript">
window.setTimeout("window.location='<%= org.coin.bean.conf.Configuration.getConfigurationValueMemory("publisher.url")%>'",5000); // delai en millisecondes
</script>
</head>
<body>
<table style="vertical-align:top;width:100%;border:0" summary="none">
		<tr>
			<td style="vertical-align:top">
				<div class="titre_page"><%= sTitle %></div>
				<div style="clear:both"></div>
				<div class="mention">Vous allez être redirigé dans 5s</div>
				<div>
					<%@ include file="message.jspf" %>
				</div>
			</td>
		</tr>
	</table>
</body>
</html>