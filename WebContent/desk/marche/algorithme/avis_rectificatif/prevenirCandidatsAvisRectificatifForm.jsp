<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="modula.marche.*,org.coin.fr.bean.mail.*" %>
<%
	int iIdAffaire = HttpUtil.parseInt("iIdAffaire", request, 0);//input type="hidden" value="<%=iIdAffaire ...dans paveMailer
	Marche marche = Marche.getMarche(iIdAffaire);

	int iIdAvisRectificatif = Integer.parseInt( request.getParameter("iIdAvisRectificatif") );
	int iIdOnglet = HttpUtil.parseInt("iIdOnglet", request, 0);

	AvisRectificatif avis = AvisRectificatif.getAvisRectificatif(iIdAvisRectificatif);
	MailType mailType = MailType.getMailTypeMemory(MailConstant.MAIL_CDT_AVIS_RECTIFICATIF);
	String sTitrePave = "Mail à envoyer";
	String[] sBalisesActives = {
			"[personne_civilite]",
			"[logged_personne_civilite]",
			"[logged_personne_nom]",
			"[publisher_url]",
			"[marche_objet]",
			"[publication_type_avis]"};
	
	boolean bJoindreAAPC = false;
	boolean bJoindreAATR = false;
	String sTitle = "Prévenir les candidats de la publication d'un avis rectificatif de l'affaire " 
		+ marche.getReference();
%>
</head>
<body>
<%@ include file="/include/new_style/headerFichePopUp.jspf" %>
<br/>
<div style="padding:15px">
<br />
<form action="<%= response.encodeURL( rootPath + "desk/marche/algorithme/avis_rectificatif/prevenirCandidatsAvisRectificatif.jsp") %>" method="post"   name="form" id="form">
<%@ include file="/include/paveMailer.jspf" %>
<br />
<div style="text-align:center">

	<button type="submit"  name="store_btn" id="store_btn" >Envoyer le mail</button>
</div>
<input type="hidden" name="iIdAvisRectificatif" value="<%= avis.getIdAvisRectificatif() %>" />
<input type="hidden" name="iIdOnglet" value="<%= iIdOnglet %>" />
</form>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
<%@page import="org.coin.util.HttpUtil"%>
</html>
