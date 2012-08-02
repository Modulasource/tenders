<%@ include file="/include/new_style/headerDesk.jspf"%>

<%@ page import="org.coin.util.*,modula.marche.*,org.coin.fr.bean.mail.*"%>

<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));//input type="hidden" value="<%=iIdAffaire ...dans paveMailer
	Marche marche = Marche.getMarche(iIdAffaire);
	String sFormPrefix = "";
	Vector<MarcheLot> vLots = MarcheLot.getAllLotsFromMarche(iIdAffaire);
	int iIdNextPhaseEtapes = HttpUtil.parseInt("iIdNextPhaseEtapes", request,-1);
	String sAction = HttpUtil.parseStringBlank("sAction", request);
	boolean bNegociation = HttpUtil.parseBoolean("bNegociation", request,  false);
			
	if(bNegociation && !marche.isMailInvitationPresenterOffreEnvoye(false)) {
				
		int iIdOnglet = HttpUtil.parseInt("iIdOnglet", request);
		
		MarcheLot lot = null;
		
		for (int i = 0; i < vLots.size(); i++)
		{
			MarcheLot lotTemp = vLots.get(i);
			if(lotTemp.getNumero() == iIdOnglet )
				lot = lotTemp ;
		}
		if(lot==null)
		{
			lot = vLots.firstElement();
			iIdOnglet = lot.getNumero();
		}
	 
		if(Validite.getNextValiditeEnveloppeBFromLotWithoutException(lot) == null) {
			response.sendRedirect(
					response.encodeURL(
						rootPath 
						+ "desk/marche/algorithme/proposition/gestion/modifierPlanningReceptionOffresForm.jsp"
						+ "?iIdNextPhaseEtapes=" +iIdNextPhaseEtapes
						+ "&iIdAffaire=" + iIdAffaire
						+ "&bNegociation=true"
						+ "&bDisplayMessageAlert=true"
						+ "&iIdOnglet="+lot.getNumero()+"&#tabClassement"));
		}
	}
	
	int iMailType = -1;
	String[] sBalisesActives = null;
	if(vLots.size() > 1) 
	{
		iMailType = MailConstant.MAIL_INVITATION_PRESENTER_OFFRE_SEPARE;
		String[] sBalisesActivesSepare = {
				"[personne_civilite]",
				"[marche_objet]",
				"[marche_reference]",
				"[logged_personne_civilite]",
				"[logged_personne_nom]",
				"[marche_lots_size]",
				"[numero_ref_lot_retenu]",
				"[date_limite_offres]",
				"[site_web]"};
		sBalisesActives = sBalisesActivesSepare;
	}
	else
	{
		iMailType = MailConstant.MAIL_INVITATION_PRESENTER_OFFRE_UNIQUE;
		String[] sBalisesActivesUnique = {
				"[personne_civilite]",
				"[marche_reference]",
				"[marche_objet]",
				"[logged_personne_civilite]",
				"[logged_personne_nom]",
				"[date_limite_offres]",
				"[site_web]"};
		sBalisesActives = sBalisesActivesUnique;
	}
		
	MailType mailType = MailType.getMailTypeMemory(iMailType);
	String sTitrePave = "Mail aux candidats invités à présenter une offre";
	boolean bJoindreAAPC = false;
	boolean bJoindreAATR = false;
	
	String sTitle = "Envoi d'une invitation à présenter une offre";
		
	//PROCEDURE
	boolean bIsContainsAAPCPublicity = AffaireProcedure.isContainsAAPCPublicity(marche.getIdAlgoAffaireProcedure());
	boolean bIsContainsEnveloppeAManagement = AffaireProcedure.isContainsEnveloppeAManagement(marche.getIdAlgoAffaireProcedure());
	boolean bIsContainsCandidatureManagement = AffaireProcedure.isContainsCandidatureManagement(marche.getIdAlgoAffaireProcedure());
	boolean bIsForcedNegociationManagement = AffaireProcedure.isForcedNegociationManagement(marche.getIdAlgoAffaireProcedure());
	int iIdTypeProcedure = AffaireProcedure.getTypeProcedure(marche.getIdAlgoAffaireProcedure());
	
	sessionUserHabilitation.isHabilitateException("IHM-DESK-AFF-27");
			
	//BUG 719 : on enleve la modification du planning à ce niveau car ca se fait maintenant
	//dans l'étape suivante
	
    String sUrlRedirection = response.encodeURL(rootPath 
	    + "desk/marche/algorithme/affaire/poursuivreProcedure.jsp"
	    + "?sAction=next"
	    + "&iIdAffaire=" + marche.getId());
%>
<script type="text/javascript" src="<%= rootPath + "include/date.js" %>"></script>
<script type="text/javascript" src="<%= rootPath + "include/fonctions.js" %>"></script>

<link rel="stylesheet" type="text/css" href="<%= rootPath %>include/component/calendar/calendar.css" media="screen" />
<script type="text/javascript" src="<%= rootPath %>include/component/calendar/calendar.js"></script>
<script type="text/javascript">
var rootPath = "<%= rootPath %>";

var bIsMailInvitationPresenterOffreEnvoye = <%= marche.isMailInvitationPresenterOffreEnvoye(false) %>;
var sUrlRedirection = "<%= sUrlRedirection %>";

onPageLoad = function() {
    if(bIsMailInvitationPresenterOffreEnvoye) {
        closeModalAndRedirectTabActive(sUrlRedirection);
    }
}
</script>
</head>
<body>
<%@ include file="/include/new_style/headerFichePopUp.jspf"%>
<br/>
<div style="padding:15px">
<br />
<form
	action="<%= response.encodeURL("envoyerMailInvitationOffre.jsp") %>"
	method="post" name="form" id="form"><%@ include
	file="/include/paveMailer.jspf"%> <br />
<div style="text-align: center"><input type="hidden"
	name="iIdNextPhaseEtapes" value="<%= iIdNextPhaseEtapes %>" /> <input
	type="hidden" name="bNegociation" value="<%= bNegociation %>" /> 
<button type="submit" name="store_btn" id="store_btn">Envoyer le mail</button>
</div>
</form>
<div id="sHtmlContentPreview"></div>
</div>
<%@ include file="/include/new_style/footerFiche.jspf"%>
</body>

<%@page import="modula.algorithme.AffaireProcedure"%>

<%@page import="java.util.Vector"%>
<%@page import="modula.Validite"%></html>