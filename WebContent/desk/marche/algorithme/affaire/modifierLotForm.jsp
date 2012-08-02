<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.util.*,java.util.*,modula.*, modula.marche.*, modula.marche.cpv.*" %>
<%@ include file="/desk/include/useBoamp17.jspf" %>
<%@page import="org.coin.bean.accountancy.Currency"%>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);
%><%@ include file="/desk/include/typeForm.jspf" %><%

	String sAction = request.getParameter("sAction");
	String sFormPrefix = "";
	int iIdOnglet = HttpUtil.parseInt("iIdOnglet", request,0);
	String sTitle = "Définition";
	int iIdMarcheLot = 0;
	MarcheLot lot = null;
	if( sAction.equals("store") ) 
	{
		String sIdMarcheLot = request.getParameter("iIdMarcheLot");
		iIdMarcheLot = Integer.parseInt( sIdMarcheLot );
		lot = MarcheLot.getMarcheLot(iIdMarcheLot );
		sTitle = "Modification";
	}

	if( sAction.equals("create") ) 
	{
		iIdMarcheLot = -1;
		lot = new MarcheLot();
		sTitle = "Création";
	}

	String sPaveDefinitionLotsTitre = "Définition du lot";

	MarcheLotDetail marcheLotDetail = null;
	try {
		marcheLotDetail = MarcheLotDetail.getMarcheLotDetailFormIdMarcheLot(lot.getId());
	} catch (Exception e) {
		marcheLotDetail = new MarcheLotDetail();
	}
	
	Currency currency = null;
	try {
		currency = Currency.getCurrency(marcheLotDetail.getIdCurrencyCoutEstime());
	} catch (Exception e) {
		currency = new Currency ("EUR");
	}
%>
<script type="text/javascript" src="<%= rootPath %>include/calendar.js"></script>
<script type="text/javascript" src="<%= rootPath %>include/date.js" ></script>
<script type="text/javascript" src="<%= rootPath %>include/verification.js"></script>
<script type="text/javascript" src="<%= rootPath %>include/cacherDivision.js"></script>
<script type="text/javascript" src="<%= rootPath + "include/js/desk/marche/pave/paveCreationLots.js" %>" ></script>
<script type="text/javascript" src="<%= rootPath + "include/js/desk/marche/pave/paveGestionLots.js" %>" ></script>
<script type="text/javascript" src="<%= rootPath + "include/js/desk/marche/pave/modifierLotForm.js" %>" ></script>
<script type="text/javascript" src="<%= rootPath %>include/AjaxComboList.js?v=<%= JavascriptVersion.AJAX_COMBO_LIST_JS %>"></script>
<script type="text/javascript" src="<%= rootPath %>include/fonctions.js"></script>
<link rel="stylesheet" type="text/css" href="<%= rootPath %>include/component/calendar/calendar.css" media="screen" />
<script type="text/javascript" src="<%= rootPath %>include/component/calendar/calendar.js"></script>
<script type="text/javascript">
<!--
var rootPath = "<%= rootPath %>";
mt.config.enableAutoLoading = false;
function abortModification()
{
	try {new parent.Control.Modal.close();}
	catch(e) { Control.Modal.close();}
}	

function onLoadPage(){
	onAfterPageLoading();
	// pas de CPV si c'est un MAPA
	try {prepareCPVButton();} catch (e) {}
    window.focus();
    $("sReference").focus();
}

//-->
</script>


</head>
<body onload="javascript:onLoadPage();">
<%@ include file="/include/new_style/headerFichePopUp.jspf" %>
<br/>
<div style="padding:15px">

<form action="<%= response.encodeURL("modifierLot.jsp") 
	%>" method="post" name="formulaireLot" onSubmit="return checkForm();" >
	<input type="hidden" value="<%= sAction %>" name="sAction" />
    <input type="hidden" value="<%= marche.getId() %>" name="iIdAffaire" />
	<input type="hidden" value="<%= iIdOnglet %>" name="iIdOnglet" />
<%@ include file="pave/paveCreationLotsForm.jspf" %>
<br />
<%
	if(!bUseBoamp17 || 
	(bUseBoamp17 && (bUseFormNS || bUseFormUE)) )
	{
		String sPaveNomenclatureTitre = "Nomenclature du lot "; 
		%><%@ include file="pave/paveNomenclatureLotsForm.jspf" %><br /><%
	}
%>
<div style="text-align:center">
	<button type="submit" >Valider</button>&nbsp;
	<button type="button" onclick="javascript:abortModification()" >Annuler</button>&nbsp;
</div>

</form>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>

</body>
</html>