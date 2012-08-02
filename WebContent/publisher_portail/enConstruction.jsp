<%@ include file="/include/headerXML.jspf" %>
<%@ page import="modula.candidature.*" %>
<%@ page import="java.util.*" %> 
<%@ page import="org.coin.fr.bean.*" %>
<%@ include file="/publisher_traitement/public/include/beanSessionUser.jspf" %>
<%@ include file="/publisher_traitement/public/include/beanCandidat.jspf" %> 
<%
	String sTitle = "Modula Publisher Portail";
	String sPageUseCaseId = "IHM-PUBLI-1";	
%>
<%@ include file="../include/headerPublisher.jspf" %>
<%@ include file="../publisher_traitement/public/include/checkHabilitationPage.jspf" %>
<script type="text/javascript" src="<%= rootPath %>include/redirection.js" ></script>
<script type="text/javascript" src="<%= rootPath %>include/crypto.js" ></script>
<script type="text/javascript" src="<%= rootPath %>include/cryptage.js" ></script>
<script type="text/javascript" src="<%= rootPath %>include/popup.js" ></script>
<%@ include file="/publisher_traitement/public/include/redirectOnLoad.jspf" %>
</head>
<body>
<%@ include file="public/include/header.jspf" %><br />
<jsp:include page="../publisher_traitement/public/include/menuHorizontal.jsp" flush="true" />
<table style="vertical-align:top;border:0" summary="none" >
	<tr>
		<td style="text-align:left;vertical-align:top;height:90%">
			<table style="height:500px" summary="Home Page">
				<tr>
					<td style="vertical-align:top;height:90%">
						<div class="titre_page">En construction</div>
						<div style="clear:both"></div>
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
				</tr>
			</table>
		</td>
<% 
	boolean bShowLogin = false;
	boolean bShowHotline = false;

%>
<%@ include file="/publisher_traitement/public/include/menuRight.jspf" %> 

	</tr>
</table>
<%@include file="public/include/footer.jspf"%>
</body>
</html>