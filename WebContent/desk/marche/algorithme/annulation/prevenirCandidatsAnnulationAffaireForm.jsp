<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.fr.bean.mail.*,modula.marche.*" %>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));//input type="hidden" value="<%=iIdAffaire ...dans paveMailer
	Marche marche = Marche.getMarche(iIdAffaire);

	String sTitle = "Prévenir les candidats de l'annulation du marché";
	boolean bJoindreAAPC = false;
	boolean bJoindreAATR = false;
	MailType mailType = MailType.getMailTypeMemory(MailConstant.MAIL_CDT_ANNULATION); 
	String sTitrePave = "Mail envoyé aux candidats";
	String[] sBalisesActives = {
			"[marche_reference]",
			"[marche_objet]",
			"[marche_prm_personne_nom]",
			"[marche_prm_personne_civilite]",
			"[logged_personne_civilite]",
			"[logged_personne_nom]",
			"[personne_civilite]"};
%>
<script type="text/javascript" src="<%= rootPath %>include/calendar.js"></script>
<script type="text/javascript" src="<%= rootPath %>include/fonctions.js"></script>
<script type="text/javascript" src="<%= rootPath %>include/checkbox.js"></script>
</head>
<body>
<%@ include file="/include/new_style/headerFichePopUp.jspf" %>
<div style="padding:15px">
<form action="<%=response.encodeURL("prevenirCandidatsAnnulationAffaire.jsp") %>" method="post"  name="form" id="form" >
<%@ include file="/include/paveMailer.jspf" %>
<br />
<div style="text-align:center">
						
	<button name="store_btn" id="store_btn" type="submit" >Envoyer le mail</button>
</div>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>