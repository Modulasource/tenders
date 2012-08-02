<%@ include file="../../include/new_style/headerDesk.jspf" %>
<%
	String sTitle = "Généré MD5";
 %>
</head>

<body>
<%@ include file="../../include/new_style/headerFiche.jspf" %>
<form action="<%= response.encodeURL("generateMD5.jsp" ) %>" method="post" >
Mot de passe : <input type="text" name="sPassPhrase" /><br />
<input type="submit" />
<button type="button" onclick="Redirect('<%= 
	response.encodeURL("afficherToutesAutoriteCertification.jsp" ) %>')" >Annuler</button>

</form>
<%@ include file="../../include/new_style/footerFiche.jspf" %>

</body>
</html>
