<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@ page import="org.coin.util.*,modula.marche.*,org.coin.fr.bean.mail.*" %>
<%@ page import="modula.fqr.*,java.sql.*,org.coin.fr.bean.*,org.coin.bean.boamp.*,modula.candidature.*" %>
<%@ page import="java.util.*,modula.algorithme.*, modula.*, modula.marche.*,org.coin.fr.bean.export.*" %>
<%@ page import="modula.marche.cpv.*,modula.commission.*, org.coin.util.treeview.*,java.text.*, modula.graphic.*,modula.ws.boamp.*,org.coin.bean.*" %>
<%@page import="org.coin.autoform.component.*"%>
<%@page import="modula.marche.joue.JoueFormulaire"%>
<%@page import="org.coin.db.CoinDatabaseHtmlTraitment"%>
<%@page import="modula.marche.joue.MarcheJoueFormulaire"%>
<%@ include file="/desk/include/useBoamp17.jspf" %>

<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);
	String sFormPrefix = "";
	Vector<MarcheLot> vLots = MarcheLot.getAllLotsFromMarche(iIdAffaire);
	int iIdNextPhaseEtapes = HttpUtil.parseInt("iIdNextPhaseEtapes", request,-1);
	String sAction = HttpUtil.parseStringBlank("sAction", request);

	int iIdOnglet = HttpUtil.parseInt("iIdOnglet",request,0);
	
	boolean bNegociation = HttpUtil.parseBoolean("bNegociation", request,  false);
	boolean bDisplayMessageAlert = HttpUtil.parseBoolean("bDisplayMessageAlert", request, false);
	boolean bSendMailStage = bDisplayMessageAlert;
	
	boolean bJoindreAAPC = false;
	boolean bJoindreAATR = false;
	
	String sTitle = "Vérification du planning de réception des offres";
		
	//PROCEDURE
	boolean bIsContainsAAPCPublicity = AffaireProcedure.isContainsAAPCPublicity(marche.getIdAlgoAffaireProcedure());
	boolean bIsContainsEnveloppeAManagement = AffaireProcedure.isContainsEnveloppeAManagement(marche.getIdAlgoAffaireProcedure());
	boolean bIsContainsCandidatureManagement = AffaireProcedure.isContainsCandidatureManagement(marche.getIdAlgoAffaireProcedure());
	boolean bIsForcedNegociationManagement = AffaireProcedure.isForcedNegociationManagement(marche.getIdAlgoAffaireProcedure());
	int iIdTypeProcedure = AffaireProcedure.getTypeProcedure(marche.getIdAlgoAffaireProcedure());
	
	sessionUserHabilitation.isHabilitateException("IHM-DESK-AFF-27");
	
	String sPaveDelaisValiditeTitre = "Rappel du planning";
    String sFormName = "invitform";
%>
<script type="text/javascript" src="<%= rootPath + "include/date.js" %>"></script>
<script type="text/javascript" src="<%= rootPath + "include/fonctions.js" %>"></script>

<link rel="stylesheet" type="text/css" href="<%= rootPath %>include/component/calendar/calendar.css" media="screen" />
<script type="text/javascript" src="<%= rootPath %>include/component/calendar/calendar.js"></script>

<script type="text/javascript">
var rootPath = "<%= rootPath %>";
</script>

<script type="text/javascript">
onPageLoad = function(){
    $("<%= sFormName %>").onValidSubmit = function(){
        return checkForm();
    }
    <%if(sAction.equals("showPlanning")){%>    
    cacher('periodeOffresSupp')";
    <%}%>
}


function checkForm(){
	var form = document.invitform;
    <%@ include file="../../affaire/pave/checkContainsEnveloppeManagement.jspf" %>
}
</script>
</head>
<body>
<%@ include file="/include/new_style/headerFichePopUp.jspf" %>
<br/>
<div style="padding:15px">
<div class="mention">
	Pour que le système puisse prendre en compte le planning du marché, veuillez vérifier 
	les dates encadrant le délai de remise des offres.
</div>
<br />
<%
	if(bDisplayMessageAlert) {
%>
<div class="rouge" style="padding-left:10px">
	Vous avec choisi de lancer une phase de négociation. 
	Vous devez donc attribuer une nouvelle période de réception des offres.
</div>
<br />
<%
	}
%>
<div class="center">
	<form action="<%= response.encodeURL("modifierPlanningReceptionOffres.jsp") %>" class="validate-fields" method="post"  name="<%= sFormName %>" id="<%= sFormName %>">
	<%@ include file="../../affaire/pave/pavePlanningForm.jspf" %>
	<br />
	<input type="hidden" name="iIdNextPhaseEtapes" value="<%= iIdNextPhaseEtapes %>" />
	<input type="hidden" name="sAction" value="storePlanning" />
	<input type="hidden" name="iIdAffaire" value="<%= iIdAffaire%>" />
	<input type="hidden" name="bNegociation" value="<%= bNegociation %>" />
	<input type="hidden" name="iIdOnglet" value="<%= iIdOnglet %>" />
	<input type="hidden" name="bSendMailStage" value="<%= bSendMailStage %>" />
	<button type="submit">Valider le planning</button>
	</form>
</div>
	
<br />
<br />
<div id="sHtmlContentPreview"></div>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>