<%@ include file="../../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="java.sql.*,org.coin.fr.bean.*,org.coin.util.*,java.util.*,modula.algorithme.*, modula.*, modula.marche.*,modula.candidature.*, modula.marche.cpv.*,modula.commission.*, org.coin.util.treeview.*,java.text.*,org.coin.bean.*" %>
<%@ include file="../../../../include/useBoamp17.jspf" %>
<%
	long lStartTime = System.currentTimeMillis();
	String sPageUseCaseId = "IHM-DESK-AFF-CDT-PAPIER-1";
	String sHeadTitre = "";
	Marche marche = Marche.getMarche(
			Integer.parseInt(request.getParameter("iIdAffaire")));
	
	int iIdAffaire = marche.getIdMarche();
	boolean bAfficherPoursuivreProcedure = false;
	String sAction = "create";
	String sTitle = "Ajouter une candidature papier"; 
	
	if(!sessionUserHabilitation.isHabilitate(sPageUseCaseId ))
	{
		
		if(sessionUserHabilitation.isHabilitate("IHM-DESK-AFF-CDT-PAPIER-2" )
		&& marche.getIdCreateur() == sessionUser.getIdIndividual() )
		{
			// OK !
		} else {
			throw new HabilitationException("IHM-DESK-AFF-CDT-PAPIER-1");
		}
		
	}
	
%>
<script type="text/javascript">


/******** Fonctions de raffraichissement de la liste des candidats ***********/
function populateCandidatSelect(sReponse){
	var aReponseLibelle = new Array();
	var aReponseId = new Array();
	var aReponseObj = new Array();
	eval(sReponse);
	var l1 = $("iIdCandidat");
	for (var i=0;i<aReponseId.length;i++){
		l1.options[i] = new Option(aReponseLibelle[i], aReponseId[i],0,0);
	}
}

function emptyCandidatSelect(){
	var l1 = $("iIdCandidat");
   	l1.options.length = 0;
}

function getCandidat(iIdOrganisation){
	// Ajax ///
	var HttpObj = null;
	if (window.XMLHttpRequest) {
		HttpObj = new XMLHttpRequest();
	}else if (window.ActiveXObject) {
		HttpObj = new ActiveXObject("Microsoft.XMLHTTP");
	}
	emptyCandidatSelect();
	
	var sURL = "desk/GetListeForAjaxComboList";	// URL par d?faut
	var sRootPath = "<%= rootPath %>";
	var sSessionId = ";jsessionid=<%= session.getId() %>";
	try{
		// on pr?pare l'envoi avec l'url donn?e
		var sU = "sAction="+escape("getCandidat");
		sU += "&sChamp="+escape(iIdOrganisation);
		HttpObj.open("POST", sRootPath+sURL+sSessionId);

		// fonction executee lorsque le traitement est termine
		HttpObj.onreadystatechange = function(){
			if (HttpObj.readyState == 4) {
				var sReponse = HttpObj.responseText;
				if (sReponse.length>0){
					emptyCandidatSelect();
					populateCandidatSelect(sReponse);
				}else{
					emptyCandidatSelect();
				}
			}else{
			}
		}
		HttpObj.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
		HttpObj.send(sU);
	} catch (e){alert("Erreur > getCandidat :\n\n"+e);}
}
function populateCandidat(){
	var iIdOrganisation = parseInt($("iIdOrganisation").value,10);
	if (iIdOrganisation>0){
		getCandidat(iIdOrganisation);
	}
}
/******** FIN Fonctions de raffraichissement de la liste des commissions ***********/

window.onload = function(){

	var ac = new AjaxComboList("iIdOrganisation", "getRaisonSocialeCandidat");
	ac.addActionOnChange("populateCandidat()");
}


function checkCandidatChoosen()
{
	var selectIdCandidat = $("iIdCandidat");
	if(selectIdCandidat.value <= 0)
	 alert ("Veuillez choisir le candidat");
}

function displayCandidature()
{
	var selectIdCandidat = $("iIdCandidat");

	if(selectIdCandidat.value == '' || selectIdCandidat.value <= 0)
	{
	 	 alert ("Veuillez choisir le candidat");
	 	 return false;
	}

	var sUrl = "<%= 
		response.encodeURL(
				rootPath + "desk/organisation/afficherCandidature.jsp?" 
				+ "iIdMarche=" + marche.getId() ) %>" ;
	
	sUrl += "&iIdPersonnePhysique=" + selectIdCandidat.value;
	
	//alert(sUrl);
	Redirect(sUrl);
}

</script>
<script type="text/javascript" src="<%= rootPath %>include/AjaxComboList.js?v=<%= JavascriptVersion.AJAX_COMBO_LIST_JS %>"></script>
<script type="text/javascript" src="<%= rootPath %>include/fonctions.js"></script>
<script type="text/javascript" src="<%= rootPath %>include/cacherDivision.js" ></script>
</head>
<body>
<%@ include file="../../../../../include/new_style/headerFiche.jspf" %>
<br/>
<div style="padding:15px">
<%@ include file="../../../../include/headerCandidature.jspf" %>
<br/>
<form name="formulaire" action="" method='post' >
<input type="hidden" name="sAction" value="<%=sAction %>" />
<table class="pave" >
	<tr>
		<td class="pave_titre_gauche" colspan="2" >Choix du candidat</td>
	</tr>
	<tr>
		<td colspan="2" >&nbsp;</td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Organisation soumissionaire * </td>
		<td class="pave_cellule_droite">
			<button type="button" id="AJCL_but_iIdOrganisation"
			class="<%= CSS.DESIGN_CSS_MANDATORY_CLASS %>" >Cliquer ici pour sélectionner l'organisme</button>
			<input type="hidden" id="iIdOrganisation" name="iIdOrganisation" />
             	 </td>
		</tr>
		<tr>
		<td class="pave_cellule_gauche">Candidat * </td>
		<td class="pave_cellule_droite">
			<select name="iIdCandidat" id="iIdCandidat" style="width:450px" class="<%= CSS.DESIGN_CSS_MANDATORY_CLASS %>">
				<option selected="selected" value="">Sélectionnez le candidat</option>
			</select>
		</td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
</table>
<br/>
<div align="center">
	<button 
		type="button" class="disabledOnClick"
		id="buttonValidate"
		onclick="displayCandidature();"
		>Valider</button> 
</div>
</form>
<%@ include file="../../../../../include/new_style/footerFiche.jspf" %>
<%
if(sessionUserHabilitation.isSuperUser())
{
	long lStopTime = System.currentTimeMillis();
	%>généré en <%= lStopTime- lStartTime%> ms<% 	
}
%>
</div>
</body>
<%@page import="org.coin.security.HabilitationException"%>
</html>
