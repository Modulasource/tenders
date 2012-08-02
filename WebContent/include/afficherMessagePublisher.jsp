<%@ include file="../include/new_style/headerPublisher.jspf" %>
<%@ include file="../publisher_traitement/public/include/beanCandidat.jspf" %>
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
    
	if(session.isNew())
	{
		sTitle = "Session interrompue";
		sMessTitle = "Session interrompue";
		sMess = "La session a été interrompue, veuillez vous reconnecter."
			+ "<br /><br />"
			+ "<a href='"+ response.encodeURL(rootPath + sPublisherPath )+"'>Retour à l'accueil</a>";
		sUrlIcone = Icone.ICONE_ERROR;	
	}
 %>
</head>
<body>
<a name="anchor_top"></a>

<%@ include file="../../../publisher_traitement/public/include/header.jspf" %>

<div style="padding:20px;text-align:center">
	<div class="post" >
	    <div class="post-title" ><%= sTitle %></div>
	    <%@ include file="message.jspf" %>
	</div>
</div>
                    
<%@include file="../../../publisher_traitement/public/include/footer.jspf"%>

</body>
<%@page import="modula.graphic.Icone"%>
</html>