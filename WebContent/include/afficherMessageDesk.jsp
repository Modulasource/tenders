<%@ include file="/include/new_style/headerDesk.jspf" %>

<%
	String sTitle = (String) session.getAttribute("sessionPageTitre");
	String sMessTitle = (String) session.getAttribute("sessionMessageTitre");
	String sMess = (String) session.getAttribute("sessionMessageLibelle");
	String sUrlIcone = (String) session.getAttribute("sessionMessageUrlIcone");
	String sUrlRedirect = (String) session.getAttribute("sessionMessageUrlRedirect");
	

	// on vide les attributs de session
	session.setAttribute("sessionPageTitre", "");
	session.setAttribute("sessionMessageTitre", "");
	session.setAttribute("sessionMessageLibelle", "");
	session.setAttribute("sessionMessageUrlIcone", "");
	session.setAttribute("sessionMessageUrlRedirect", "");
 %>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>

<%@ include file="message.jspf" %>

<div style="text-align:center">
	<button type="button" 
		onclick="Redirect('<%= response.encodeRedirectURL(sUrlRedirect) %>')" 
		>Poursuivre</button>
</div>

<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>