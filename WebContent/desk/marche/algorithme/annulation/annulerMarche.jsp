<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="modula.marche.*" %>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);

	String sTitle = "Annuler définitivement le marché";
	String sMessTitle = "Attention";
	String sMess = " Vous vous apprétez à annuler définitivement le marché.<br />";
	String sUrlIcone = modula.graphic.Icone.ICONE_WARNING;
%>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<br/>
<div style="padding:15px">
<%@ include file="/include/new_style/headerAffaireOnlyButtonDisplayAffaire.jspf" %>
<%@ include file="/include/message.jspf" %>
<br />

<div style="text-align:center">
	<button type="button" 
		onclick="Redirect('<%= response.encodeURL(rootPath 
				+ "desk/marche/algorithme/annulation/annulerMarcheDefinitivement.jsp?iIdAffaire="+iIdAffaire) 
		%>')" >Continuer la procédure</button>
</div>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>

</body>
</html>
