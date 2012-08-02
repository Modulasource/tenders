<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.bean.UserStatus"%>
<%
String sPageUseCaseId = "xxx";
String sTitle = "Gestion des procédures";

JSONArray json_MarchePassation = MarchePassation.getJSONArray(false);
JSONArray json_MarchePhaseCandidature = MarchePhaseCandidature.getJSONArray(false);
JSONArray json_Procedure = Procedure.getJSONArray(false);
JSONArray json_BoampFormulaireType = BoampFormulaireType.getJSONArray(false);
JSONArray json_AffaireProcedureType = AffaireProcedureType .getJSONArray(false);
JSONArray json_UseCase = UseCase.getJSONArray(false);
JSONArray json_Phase = Phase.getJSONArray(false);
%>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/AutoFormSearchEngine.js"></script>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/AffaireProcedure.js"></script>
<script type="text/javascript" src="<%=rootPath %>include/js/mt.component.js?v=<%= JavascriptVersion.MT_COMPONENT_JS %>"></script>
<script>

var passList = <%= json_MarchePassation%>;
var candList = <%= json_MarchePhaseCandidature%>;
var algoList = <%=json_Procedure%>;
var form_typeList = <%= json_BoampFormulaireType%>;
var niveauList = <%= json_AffaireProcedureType%>;
var cuList = <%= json_UseCase%>;
var phaseList = <%= json_Phase%>;

var mySearch = new mt.component.SearchEngine("search","search_dg","search_dg_pagination","infosSearchLeft","infosSearchRight","searchAdvancedFunction");

mySearch.lineBackgroundBis = "#DFEBFF";
mySearch.sIdInTable = "id_algo_affaire_procedure";
mySearch.sMainTable = "algo_affaire_procedure";
mySearch.sMainAliasTable = "aff_proc";
mySearch.sLabelElement = "procédure";
mySearch.bKindFemaleElement = true;
mySearch.uniqueSort = true;
mySearch.sSelectPart = "<%=SecureString.getSessionSecureString(
	"aff_proc.*, mp.libelle AS pass,"+
	"mpc.libelle AS cand,"+
	"algo_proc.libelle AS proc,"+
	"boamp_type.libelle as boamp_type_libelle,"+
	"algo_proc_type.libelle as niveau,"+
	"phase.libelle as demarrage,"+
	"aff_proc.id_use_case AS cu", session)%>";

mySearch.addOtherTable("marche_passation mp", "mp.id_marche_passation = aff_proc.id_marche_passation");
mySearch.addOtherTable("marche_phase_candidature mpc", "mpc.id_marche_phase_candidature = aff_proc.id_marche_phase_candidature");
mySearch.addOtherTableWithLeftJoin("algo_procedure algo_proc", "algo_proc.id_algo_procedure = aff_proc.id_algo_procedure");
mySearch.addOtherTable("algo_affaire_procedure_type algo_proc_type", "algo_proc_type.id_algo_affaire_procedure_type = aff_proc.id_algo_affaire_procedure_type");
mySearch.addOtherTable("algo_phase phase", "phase.id_algo_phase = aff_proc.id_algo_phase_demarrage");
mySearch.addOtherTable("boamp_formulaire_type boamp_type", "boamp_type.id_boamp_formulaire_type = aff_proc.id_boamp_formulaire_type");

//mySearch.setGroupByClause("user.id_coin_user");

mySearch.addHeader("Mode de Passation",["pass"],"mp.libelle","asc");
mySearch.addHeader("Phase de Candidature",["cand"],"mpc.libelle");
mySearch.addHeader("Algo",["proc"],"algo_proc.libelle");
mySearch.addHeader("Type Formulaire",["boamp_type_libelle"],"boamp_type.libelle");
mySearch.addHeader("Niveau",["niveau"],"algo_proc_type.libelle");
mySearch.addHeader("Demarrage",["demarrage"],"phase.libelle");
mySearch.addHeader("CU",["cu"],"aff_proc.id_use_case");

/*
.onPopulate = function(values, id) {
	var linkTitle = "<a href=\""+values[1]+"\">"+values[0]+"</a>";
	return linkTitle;
}
*/


mySearch.addHeader('').onPopulate = function(values, mainId) {
	var div = document.createElement("div");
	var link = document.createElement("a");
	link.href = "javascript:void(0);";
	link.innerHTML = "<img src=\"<%=rootPath + "images/icons/application_edit.gif"%>\" " +
				" alt=\"Afficher\" title=\"Afficher\" />";
				
	var linkDelete = document.createElement("a");
	linkDelete.href = "javascript:deleteProcedure("+values.id_algo_affaire_procedure+");";
	linkDelete.innerHTML = "<img src=\"<%=rootPath + "images/icons/cross.gif"%>\" " +
				" alt=\"Supprimer\" title=\"Supprimer\" />";


	link.onclick = function(){
		openModal(values);
		/*
		var divModal;
		try{divModal = createModal(values,parent.document);}
		catch(e){divModal = createModal(values,document);}

		var modal;
		try {modal = new parent.Control.Modal(link,{contents: divModal});}
		catch(e) {modal = new Control.Modal(link,{contents: divModal});}
		modal.container.insert(divModal);
		modal.open();
		*/
	}			
	
	div.appendChild(link);
	div.appendChild(linkDelete);
			
	return div;
}

function deleteProcedure(id){
	if(confirm("Etes-vous sûr de vouloir supprimer cette procédure?")){
	AffaireProcedure.removeWithObjectAttachedStatic(id,
	function(result){
		if(result){
			mySearch.search();
		}
	});
	}
}

function openModal(obj){
	var modal, div ;
	
	try{div = createModal(obj,parent.document);}
	catch(e){div = createModal(obj,document);}
	
	try {modal = new parent.Control.Modal(false,{contents: div});}
	catch(e) {modal = new Control.Modal(false,{contents: div});}

    modal.container.insert(div);
	modal.open();
}

function createModal(obj, doc){
	
	var modal_princ = doc.createElement("div");
	modal_princ.className = "modal_principal";
	
	var divControls = doc.createElement("div");
	divControls.className = "modal_controls";
	
	var divTitle = doc.createElement("div");
	divTitle.className = "modal_title";
	divTitle.innerHTML = obj!=null?"Procédure réf."+obj.id_algo_affaire_procedure:"Nouvelle Procédure";
	
	var img = doc.createElement("img");
	img.style.position = "absolute";
	img.style.top = "3px";
	img.style.right = "3px";
	img.style.cursor = "pointer";
	img.src = "<%= rootPath %>images/icons/close.gif";
	img.onclick = function(){
		try {new parent.Control.Modal.close();}
		catch(e) { Control.Modal.close();}
	}
	
	divControls.appendChild(divTitle);
	divControls.appendChild(img);
	
	var divFrame = doc.createElement("div");
	divFrame.className = "modal_frame_principal";
	
	var divContent = doc.createElement("div");
	divContent.className = "modal_frame_content";
	
	var sHTML = '<table class="formLayout" cellspacing="3">'+
			    '<tr>'+
			    	'<td class="label">Mode de passation</td>'+
			    	'<td class="value"><select id="passModal"></select></td>'+
		    	'</tr>'+
			    '<tr>'+
			    	'<td class="label">Phase de Candidature</td>'+
			    	'<td class="value"><select id="candModal"></select></td>'+
			    '</tr>'+
			    '<tr>'+
			    	'<td class="label">Algo</td>'+
			    	'<td class="value"><select id="algoModal"></select></td>'+
			    '</tr>'+
			    '<tr>'+
			    	'<td class="label">Niveau de traitement</td>'+
			    	'<td class="value"><select id="niveauModal"></select></td>'+
			    '</tr>'+
			    '<tr>'+
			    	'<td class="label">Phase de démarrage</td>'+
			    	'<td class="value"><select id="phaseModal"></select></td>'+
			    '</tr>'+
			    '<tr>'+
			    	'<td class="label">Type de formulaire</td>'+
			    	'<td class="value"><select id="form_typeModal"></select></td>'+
			    '</tr>'+
			    '<tr>'+
			    	'<td class="label">CU</td>'+
			    	'<td class="value"><select id="cuModal"></select></td>'+
			    '</tr>'+
			    '</table>';
	divContent.innerHTML = sHTML;
	divFrame.appendChild(divContent);

	var selects = divContent.getElementsByTagName("select");
	mt.html.setSuperCombo(selects[0]);
	selects[0].populate(passList, (obj!=null?obj.id_marche_passation:null), "lId", "sLibelle");
	mt.html.setSuperCombo(selects[1]);
	selects[1].populate(candList, (obj!=null?obj.id_marche_phase_candidature:null), "lId", "sName");
	mt.html.setSuperCombo(selects[2]);
	selects[2].populate(algoList, (obj!=null?obj.id_algo_procedure:null), "lId", "sLibelle");
	mt.html.setSuperCombo(selects[3]);
	selects[3].populate(niveauList, (obj!=null?obj.id_algo_affaire_procedure_type:null), "lId", "sName");
	mt.html.setSuperCombo(selects[4]);
	selects[4].populate(phaseList, (obj!=null?obj.id_algo_phase_demarrage:null), "lId", "sName");
	mt.html.setSuperCombo(selects[5]);
	selects[5].populate(form_typeList, (obj!=null?obj.id_boamp_formulaire_type:null), "lId", "sLibelle");
	mt.html.setSuperCombo(selects[6]);
	selects[6].populate(cuList, (obj!=null?obj.id_use_case:null), "sId", "sLibelle");
	
	
	var divOptions = doc.createElement("div");
	divOptions.className = "modal_options";
	
	var btnRegister = doc.createElement("button");
	btnRegister.onclick = function() {
		try {
			this.disabled = true;
			this.innerHTML = "Enregistrement en cours...";
			var item = new Object();
			item.lId = (obj!=null?obj.id_algo_affaire_procedure:0);
			item.sIdUseCase = selects[6].value;
			item.iIdPhaseDemarrage = selects[4].value;
			item.iIdType = selects[3].value;
			item.iIdMarchePassation = selects[0].value;
			item.iIdMarchePhaseCandidature = selects[1].value;
			item.iIdProcedure = selects[2].value;
			item.iIdBoampFormulaireType = selects[5].value;

			AffaireProcedure.storeFromJSONString(Object.toJSON(item),
			function(result){
				this.disabled = false;
				this.innerHTML = "Enregistrer";
				if(result){
					mySearch.search();
					try {new parent.Control.Modal.close();}
					catch(e) { Control.Modal.close();}
				}
			});
		} catch(e){}
	}
	btnRegister.innerHTML = "Enregistrer";
	divOptions.appendChild(btnRegister);
	
	modal_princ.appendChild(divControls);
	modal_princ.appendChild(divFrame);
	modal_princ.appendChild(divOptions);
	
	return modal_princ;
}


mySearch.onLoad = function(){
	Element.hide('searchLoader');
	if (mySearch.iTotalCountCriterias>0) Element.show('search_dg');
}

mySearch.onBeforeSearch = function(){
	Element.hide('search_dg');
	Element.show('searchLoader');
	
	var pass = $('pass').value;
	if (pass!=0) {
		mySearch.addFilter(["aff_proc.id_marche_passation"],[pass],false);
	}
	
	var cand = $('cand').value;
	if (cand!=0) {
		mySearch.addFilter(["aff_proc.id_marche_phase_candidature"],[cand],false);
	}
	
	var algo = $('algo').value;
	if (algo!=0) {
		mySearch.addFilter(["aff_proc.id_algo_procedure"],[algo],false);
	}
	
	var form_type = $('form_type').value;
	if (form_type!=0) {
		mySearch.addFilter(["aff_proc.id_boamp_formulaire_type"],[form_type],false);
	}
	
	var niveau = $('niveau').value;
	if (niveau!=0) {
		mySearch.addFilter(["aff_proc.id_algo_affaire_procedure_type"],[niveau],false);
	}
	
	var keyword = $('keyword').value;
	if (!keyword.isNull()) {
		mySearch.addFilter(["aff_proc.id_use_case"],[keyword],true);
	}
	
}


onPageLoad = function() {
	var passListSE = <%= json_MarchePassation%>;
	var candListSE = <%= json_MarchePhaseCandidature%>;
	var algoListSE = <%=json_Procedure%>;
	var form_typeListSE = <%= json_BoampFormulaireType%>;
	var niveauListSE = <%= json_AffaireProcedureType%>;

	passListSE.splice(0, 0, {lId:0, sLibelle:"Tous"});
	$('pass').populate(passListSE, null, "lId", "sLibelle");
	
	candListSE.splice(0, 0, {lId:0, sName:"Toutes"});
	$('cand').populate(candListSE, null, "lId", "sName");

	algoListSE.splice(0, 0, {lId:0, sLibelle:"Tous"});
	$('algo').populate(algoListSE, null, "lId", "sLibelle");
	
	form_typeListSE.splice(0, 0, {lId:0, sLibelle:"Tous"});
	$('form_type').populate(form_typeListSE, null, "lId", "sLibelle");
	
	niveauListSE.splice(0, 0, {lId:0, sName:"Tous"});
	$('niveau').populate(niveauListSE, null, "lId", "sName");
	
	
	setTimeout(function(){
		$('keyword').focus();
	}, 1000);
	$('searchButton').onclick = function() {mySearch.search();}
	mySearch.search();
}

</script>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<form onsubmit="return false;">
<br/>
<div class="center">
	<img class="middleAlign" src="<%=rootPath %>images/icons/plus_blue.gif" />&nbsp;<a id="new" href="javascript:openModal(null,$('new'))" class="middleAlign">Ajouter une procédure</a>
</div>
<div id="search" style="padding:15px">
	<div style="position:relative">
		<div class="searchBlock">
			<div style="padding:2px">
				<table class="formLayout">
					<tr>
						<td class="label">CU :</td>
						<td class="value"><input id="keyword" type="text" /></td>
						<td class="label">Type Formulaire :</td>
						<td class="value"><select id="form_type"></select></td>
					</tr>
					<tr>
						<td class="label">Mode de passation :</td>
						<td class="value"><select id="pass"></select></td>
						<td class="label">Phase de candidature :</td>
						<td class="value"><select id="cand"></select></td>
					</tr>
					<tr>
						<td class="label">Algo :</td>
						<td class="value"><select id="algo"></select></td>
						<td class="label">Niveau :</td>
						<td class="value"><select id="niveau"></select></td>
					</tr>
					<tr><td>&nbsp;</td><td>
						<button style="right:4px;bottom:4px" id="searchButton"><%= SearchEngine.getLocalizedLabel(SearchEngine.LABEL_SEARCH_BUT,sessionLanguage.getId()) %></button>
					</td></tr>
				</table>
			</div>
		</div>
	</div>
	<br/>
	<div class="searchTitle">
		<div id="infosSearchLeft" style="float:left"></div>
		<div id="infosSearchRight" style="float:right;text-align:right;"></div>
		<div style="clear:both"></div>
	</div>
	<div id="searchLoader" style="text-align:center;"><img src="<%= rootPath %>images/loader_modula.gif" alt="chargement..." title="chargement..."/></div>
	<div id="search_dg" style="margin-top:5px"></div>
	<div id="search_dg_pagination" style="margin-top:10px" class="center"></div>
	<div id="searchAdvancedFunction" style="display:none;margin-top:5px"></div>
</div>
</form>


<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
<%@page import="modula.marche.MarchePassation"%>
<%@page import="modula.marche.MarchePhaseCandidature"%>
<%@page import="modula.algorithme.Procedure"%>
<%@page import="org.coin.bean.boamp.BoampFormulaireType"%>
<%@page import="modula.algorithme.AffaireProcedureType"%>
<%@page import="modula.graphic.Icone"%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.coin.bean.UseCase"%>
<%@page import="modula.algorithme.Phase"%>
<%@page import="org.coin.util.*"%>
<%@page import="modula.algorithme.AffaireProcedure"%>
<%@page import="org.coin.security.SecureString"%>
</html>