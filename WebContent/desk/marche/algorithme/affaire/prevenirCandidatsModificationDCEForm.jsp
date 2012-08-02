<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="modula.marche.*,org.coin.fr.bean.mail.*" %>
<%

	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));//input type="hidden" value="<%=iIdAffaire ...dans paveMailer
	Marche marche = Marche.getMarche(iIdAffaire);

	MailType mailType = MailType.getMailTypeMemory(MailConstant.MAIL_CDT_MODIF_DCE);

	String sTitrePave = "Mail à envoyer";
	String[] sBalisesActives = {
			"[marche_objet]",
			"[personne_civilite]",
			"[logged_personne_civilite]",
			"[logged_personne_nom]",
			"[publisher_url]",
			"[marche_reference]"};
	boolean bJoindreAAPC = false;
	boolean bJoindreAATR = false;
	String sTitle = "Communiquer la modification du DCE de l'affaire " + marche.getReference();
%>
</head>
<body>
<%@ include file="/include/new_style/headerFichePopUp.jspf" %>
<br/>
<div style="padding:15px">
<form action="<%= response.encodeURL("prevenirCandidatsModificationDCE.jsp")
    %>" method="post"  id="form" name="form">
<%@ include file="/include/paveMailer.jspf" %>
<br />
<div style="text-align:center">
	<button name="store_btn" id="store_btn" type="submit" >Envoyer le mail</button>
</div>
</form>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>