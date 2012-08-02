<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.fr.bean.mail.*,modula.marche.*, java.util.*" %>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));//input type="hidden" value="<%=iIdAffaire ...dans paveMailer
	Marche marche = Marche.getMarche(iIdAffaire);

	String sTitle = "Envoyer le mail aux candidats non recevables";
	Vector<MarcheLot> vLots = MarcheLot.getAllLotsFromMarche(iIdAffaire);
	int iIdNextPhaseEtapes = HttpUtil.parseInt("iIdNextPhaseEtapes", request,-1);
	sessionUserHabilitation.isHabilitateException("IHM-DESK-AFF-14");

	int iMailType = -1;
	String[] sBalisesActives = null;
	
	/**
	* Pour mémoire :
	* contenuMail = Outils.replaceAll(contenuMail, "[nom_coll]",oOrganisationPrm.getRaisonSociale());
	* remplacé par : [marche_organisation_raison_sociale]
	*/
	
	if(vLots.size() > 1) 
	{
		iMailType = MailConstant.MAIL_CDT_REJET_CANDIDATURE_MARCHE_SEPARE;
		String[] sBalisesActivesSepare = {
				"[personne_civilite]",
				"[personne_nom]",
				"[personne_prenom]",
				"[marche_organisation_raison_sociale]",
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
		iMailType = MailConstant.MAIL_CDT_REJET_CANDIDATURE_MARCHE_UNIQUE;
		String[] sBalisesActivesUnique = {
				"[personne_civilite]",
				"[personne_nom]",
				"[personne_prenom]",
				"[marche_organisation_raison_sociale]",
				"[marche_objet]",
				"[marche_reference]",
				"[logged_personne_civilite]",
				"[logged_personne_nom]",
				"[logged_personne_prenom]",
				};
		sBalisesActives = sBalisesActivesUnique;
	}
	/**
	 * 
	 */
    iMailType = MailConstant.MAIL_CDT_REJET_CANDIDATURE_MARCHE_UNIQUE;
		
	MailType mailType = MailType.getMailTypeMemory(iMailType);
	String sTitrePave = "Mail aux candidats non recevables";
	boolean bJoindreAAPC = false;
	boolean bJoindreAATR = false;
	
	

%>
</head>
<body>
<div style="padding:15px">
<form id="form" action="<%= response.encodeURL("envoyerMailNonRecevable.jsp") %>" method="post" name="form">
<br />
<div class="rouge" style="font-size:12px;">
ATTENTION! Les titulaires des <strong>candidatures non recevables</strong> recevront un courrier du type suivant :
</div>
<br />
<%@ include file="/include/paveMailer.jspf" %>
<br />
<div style="text-align:center">
	<input type="hidden" name="iIdNextPhaseEtapes" value="<%= iIdNextPhaseEtapes%>" />
	<button type="submit" id="store_btn" name="store_btn" >Envoyer le mail</button>
</div>
</form>
 <div id="sHtmlContentPreview"></div> 

</div>
</body>
<%@page import="org.coin.util.HttpUtil"%>
</html>