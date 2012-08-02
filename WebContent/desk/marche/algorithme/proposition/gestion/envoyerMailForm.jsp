<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="java.util.*,modula.marche.*,org.coin.fr.bean.mail.*" %>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));//input type="hidden" value="<%=iIdAffaire ...dans paveMailer
	Marche marche = Marche.getMarche(iIdAffaire);

	Vector<MarcheLot> vLots = MarcheLot.getAllLotsFromMarche(iIdAffaire);
	
	int iIdLot = Integer.parseInt(request.getParameter("iIdLot"));
	MarcheLot lot = MarcheLot.getMarcheLot(iIdLot);
	
	int iIdNextPhaseEtapes = HttpUtil.parseInt("iIdNextPhaseEtapes", request,-1);
	int iMailType = Integer.parseInt(request.getParameter("iMailType"));
	
	//String sRedirectURL = request.getParameter("sRedirectURL");
	String sRedirectURLEncoded = request.getParameter("sRedirectURL");
	String sRedirectURL = SecureString.getSessionPlainString(sRedirectURLEncoded, session);	
	
	sRedirectURL = SecureString.getSessionSecureString(sRedirectURL,session);
	MailType mailType = MailType.getMailTypeMemory(iMailType);
	String sTitrePave = "Mail à envoyer";
	String[] sBalisesActives = null;
	if(vLots.size() > 1) 
	{
		String[] sBalisesActivesSepare = {
				"[personne_civilite]",
				"[personne_nom]",
				"[personne_prenom]",
				"[marche_objet]",
				"[marche_reference]",
				"[logged_personne_civilite]",
				"[logged_personne_nom]",
				"[logged_personne_prenom]",
				"[marche_lots_size]",
				"[marche_lot_reference]"};
		sBalisesActives = sBalisesActivesSepare;
	}
	else
	{
		String[] sBalisesActivesUnique = {
				"[personne_civilite]",
				"[personne_nom]",
				"[personne_prenom]",
				"[marche_objet]",
				"[marche_reference]",
				"[logged_personne_civilite]",
				"[logged_personne_nom]",
				"[logged_personne_prenom]"};
		sBalisesActives = sBalisesActivesUnique;
	}
	boolean bJoindreAAPC = false;
	boolean bJoindreAATR = false;
	
	String sTitle = MailConstant.getDescriptionMailCandidat(iMailType, "Envoi d'une notification aux candidats");
	if(vLots.size() == 1) sTitle += "pour le marché "+marche.getReference();
	else sTitle += "pour le lot n°"+lot.getNumero()+" réf. "+lot.getReference();

%>
</head>
<body>
<%@ include file="/include/new_style/headerFichePopUp.jspf" %>
<br/>
<div style="padding:15px">
<form id="form" action="<%= response.encodeURL("envoyerMail.jsp") %>" method="post"  name="form">
<%@ include file="/include/paveMailer.jspf" %>
<br />
<div style="text-align:center">
	<input type="hidden" name="iIdNextPhaseEtapes" value="<%= iIdNextPhaseEtapes %>" />
	<input type="hidden" name="iIdLot" value="<%=iIdLot%>" />
	<input type="hidden" name="iMailType" value="<%= iMailType %>" />
	<input type="hidden" name="sTitle" value="<%= sTitle %>" />
	<input type="hidden" name="sRedirectURL" value="<%= sRedirectURL %>" />
	

	<button type="submit"  id="store_btn" name="store_btn">Envoyer le mail</button>
</div>
</form>
<div id="sHtmlContentPreview"></div>

</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
<%@page import="org.coin.util.HttpUtil"%>

<%@page import="org.coin.security.SecureString"%></html>