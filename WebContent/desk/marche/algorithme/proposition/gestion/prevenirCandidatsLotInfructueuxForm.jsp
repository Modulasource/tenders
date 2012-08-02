<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.fr.bean.mail.*,modula.marche.*" %>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));//input type="hidden" value="<%=iIdAffaire ...dans paveMailer
	Marche marche = Marche.getMarche(iIdAffaire);

	int iIdLot = Integer.parseInt(request.getParameter("iIdLot"));

	String sTitle = "Lot infructueux, prévenir les candidats";
	boolean bJoindreAAPC = false;
	boolean bJoindreAATR = false;
	MailType mailType = MailType.getMailTypeMemory(MailConstant.MAIL_CDT_LOT_INFRUCTUEUX); 
	String[] sBalisesActives = {
			"[personne_civilite]",
			"[marche_objet]",
			"[marche_reference]",
			"[logged_personne_nom]",
			"[logged_personne_civilite]",
			"[marche_lot_numero]"};
	String sTitrePave = "Mail envoyé aux candidats";
%>
<script type="text/javascript" src="<%= rootPath %>include/calendar.js"></script>
<script type="text/javascript" src="<%= rootPath %>include/fonctions.js"></script>
<script type="text/javascript" src="<%= rootPath %>include/checkbox.js"></script>
</head>
<body>
<%@ include file="/include/new_style/headerFichePopUp.jspf" %>
<br/>
<div style="padding:15px">
<form action="<%=response.encodeURL("prevenirCandidatsLotInfructueux.jsp?iIdLot="+iIdLot) %>" method="post"  name="form" id="form">
<%@ include file="/include/paveMailer.jspf" %>
<br />

<div style="text-align:center">
						
	<button type="submit"  name="store_btn" id="store_btn"  >Envoyer le mail</button>
</div>

</form>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>