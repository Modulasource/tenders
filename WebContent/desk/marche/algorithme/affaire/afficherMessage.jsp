<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="modula.marche.*" %>
<%

	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);

	String sTitle = "Traitement de l'étape";
	String sUrlIcone = request.getParameter("sUrlIcone");
	String sMessTitle = request.getParameter("sMessTitle");
	String sMess = request.getParameter("sMess");
	String sTargetURL = "afficherAffaire.jsp";
	if(marche.isAffaireAATR(false)) sTargetURL = "afficherAttribution.jsp";
	String sHeadTitre = sMessTitle;
	boolean bAfficherPoursuivreProcedure = false;

%>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<br/>
<div style="padding:15px">
<%@ include file="/include/new_style/headerAffaireOnlyButtonDisplayAffaire.jspf" %>
<%@ include file="/include/message.jspf" %>
<div style="text-align:center">
	<button type="button" 
		onclick="Redirect('<%= 
			response.encodeURL(rootPath + "desk/marche/algorithme/affaire/"
					+ sTargetURL +"?iIdOnglet=0&iIdAffaire="+ iIdAffaire) 
		%>')" >Retour à l'affaire</button>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>