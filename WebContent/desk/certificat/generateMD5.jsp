<%@ include file="../../include/new_style/headerDesk.jspf" %>
<%
	String sTitle = "Généré MD5";
	String sPassPhrase = request.getParameter("sPassPhrase") ;
 %>
</head>
<body>
<%@ include file="../../include/new_style/headerFiche.jspf" %>
Mot de passe : <%= sPassPhrase  %><br />
MD5 = <%= org.coin.security.MD5.getEncodedString(sPassPhrase) %>
<br>
<br>
<button type="button" 
	onclick="Redirect('<%= response.encodeURL("afficherToutesAutoriteCertification.jsp" ) %>')" 
	>Retour</button>
<%@ include file="../../include/new_style/footerFiche.jspf" %>

</body>
</html>
