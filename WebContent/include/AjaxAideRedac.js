/**
AjaxAideRedac Beta

? ins?rer dans la page (en vrac) : 


<link rel="stylesheet" type="text/css" href="<%= rootPath %>include/css/desk.css" media="screen" /> 
<script type="text/javascript" src="<%= rootPath %>include/AjaxAideRedac.js"></script>
<script type="text/javascript" src="<%= rootPath %>include/DataGrid.js"></script>
<script type="text/javascript" src="<%= rootPath %>include/fonctions.js?v=<%= JavascriptVersion.FONCTIONS_JS %>"></script>
<script type="text/javascript">
function addToTextField(sTexte){
	insererTexteApresCurseur(sTexte, "monChamp");
	AJAR_contournerBugSelectIE(ar.sIdDiv);
	AJAR_fermerDIV(ar.sIdDiv);
}
</script>

var ar
window.onload = function(){
	if (window.XMLHttpRequest || window.ActiveXObject){
		ar = new AjaxAideRedac("iIdOrganisation", "getRaisonSociale", "<%= rootPath %>", "<%= session.getId() %>");
		ar.setLimit(5);
	}else{
		alert("Attention, votre navigateur n'est pas compatible avec la technologie \"Ajax\".\nVeuillez installer un navigateur r?cent : www.GetFirefox.com");
	}
}

<input type="button" name="AJAR_but_iIdCautionnement" id="AJAR_but_iIdCautionnement" value="Aide contextuelle" style="height:31px;background-image: url(<%=rootPath+"images/icones/aide_redac.png"%>);" />

**/


function AjaxAideRedac(sIdChamp, sChampTextField, sVarAJAR, sAction, sRootPath, sSessionId){
	this.sIdChamp = sIdChamp;
	this.sChampTextField = sChampTextField;
	this.sVarAJAR = sVarAJAR;
	this.sAction = sAction;
	this.sComposantPrefix = "AJAR_";
	
	this.sIdDataGrid = this.sComposantPrefix+"dg_"+this.sIdChamp;	//
//	this.sIdDivDataGrid = this.sComposantPrefix+"dgdiv_"+this.sIdChamp;	//
	
	this.sIdSelect = this.sComposantPrefix+"sel_"+this.sIdChamp;	// Liste des r?sultats
	
	this.sIdTextfield = this.sComposantPrefix+"txt_"+this.sIdChamp;	// Champ texte pour recherche
	this.sIdLimitOffset = this.sComposantPrefix+"hlo_"+this.sIdChamp;	// Hidden
	this.sIdLimit = this.sComposantPrefix+"hl_"+this.sIdChamp;	// Hidden 
	this.sIdTotal = this.sComposantPrefix+"ht_"+this.sIdChamp;	// Hidden 
	this.sIdAffichage = this.sComposantPrefix+"aff_"+this.sIdChamp;	// Affichage
	this.sIdButton = this.sComposantPrefix+"but_"+this.sIdChamp;	// Bouton de lancement
	this.sIdButtonPrec = this.sComposantPrefix+"butp_"+this.sIdChamp;	// Bouton pr?c?dent
	this.sIdButtonSuiv = this.sComposantPrefix+"buts_"+this.sIdChamp;	// Bouton suivant
	this.sIdButtonFermer = this.sComposantPrefix+"butf_"+this.sIdChamp;	// Bouton fermer
	
	this.sURL = "desk/GetListeForAjaxAideRedac";	// URL par d?faut
	this.sRootPath = sRootPath;
	this.sSessionId = ";jsessionid="+sSessionId;
	
	this.sInstanceName = null;
	this.sActionOnChange = "";
	
	this.sIdDiv = this.sComposantPrefix+"div_"+this.sIdChamp;
	
	this.iLimitOffset = 0;	// d?but du LIMIT de la requ?te ; exemple : LIMIT 7,50 => pour commencer ? 7
	this.iLimit = 50;	// valeur du LIMIT de la requ?te ; exemple : LIMIT 7,50 => retourner 50 ?l?ments ? partir du 7?me
		
	var self = this;
	
	// cr?ation du div
	var div = document.createElement("div");
	div.id = this.sIdDiv;
	window.document.body.appendChild(div);
	
	/* Initialisation du datagrid */
	this.dataGrid = AJAR_initDataGrid(this.sIdDataGrid);
	/******************************/
	
	this.setLimit = function(iLimit){
		this.iLimit = iLimit;
	}
	
	this.setURL = function(sURL){
		this.sURL = sURL;
	}
	this.getCompleteURL = function (){
		return this.sRootPath+this.sURL+this.sSessionId;
	}
	
	this.setInstanceName = function(sInstanceName){
		this.sInstanceName = sInstanceName;
	}
	this.addActionOnChange = function(sActionOnChange){
		this.sActionOnChange = sActionOnChange;
	}
	
	this.setMinimumSaisi = function(iTaille){
		this.iMinimumSaisi = iTaille;
	};
	this.initialiserChamps = function(sLibelle, sValeur){
		document.getElementById(this.sIdChamp).value = sValeur;
		document.getElementById(this.sIdButton).value = sLibelle;
	}
		
	document.getElementById(this.sIdButton).onclick = function(){
		if (document.getElementById(self.sIdDiv).style.visibility!="visible"){
			var t = eval(self.getPosTop(document.getElementById(self.sIdButton)) 
					+ document.getElementById(self.sIdButton).offsetHeight) + "px";
			var l = eval(self.getPosLeft(document.getElementById(self.sIdButton)))
					- 550 + "px";
			
			var div = document.getElementById(self.sIdDiv);
			div.style.display = "block";
			div.style.visibility = "visible";
			div.style.zIndex = 1000;
			div.style.left = l;
			div.style.top = t;
			div.style.width = "550px";
			
			self.dataGrid.setWidth("550px");
			
			div.setAttribute('class', 'divSuggestion');
		    div.setAttribute('className', 'divSuggestion');
			
			var sHTML = "<table width=\"550px\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">";
			sHTML += "<tr><td>";
			
			sHTML += "<table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">";
			sHTML += "<tr>";
			sHTML += "<td width=\"90%\"><div align=\"left\" id=\""+self.sIdAffichage+"\">";
			sHTML += "Chargement";			
			sHTML += "</div></td>";
			sHTML += "<td width=\"10%\"><div align=\"right\">";
			sHTML += "<button type=\"button\" name=\""+self.sIdButtonFermer+"\" ";
			sHTML += "id=\""+self.sIdButtonFermer+"\" ";
			sHTML += "onclick=\"AJAR_contournerBugSelectIE('"+self.sIdDiv+"');";
			sHTML += "AJAR_fermerDIV('"+self.sIdDiv+"')\" ";
			sHTML += ">x</button></div></td>";
			sHTML += "</tr></table>";
			
			sHTML += "</td></tr>";
			
			sHTML += "<tr><td>";
			sHTML += "<div id=\""+self.dataGrid.getIdDiv()+"\" class=\"DGClassAideRedactionelle\">";
			sHTML += "</div>";
			sHTML += "<div id=\"debug\"></div>";
			
			sHTML += "</td></tr>";
			
			sHTML += "<tr><td>";
			
			sHTML += "<table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">";
			sHTML += "<tr>";
			sHTML += "<td width=\"10%\">";
			sHTML += "<button type=\"button\" name=\""+self.sIdButtonPrec+"\" ";
			sHTML += "id=\""+self.sIdButtonPrec+"\" ";
			sHTML += "onclick=\"AJAR_prevResults('"+self.sIdDataGrid+"',";
			sHTML += "'"+self.getCompleteURL()+"',";
			sHTML += "'"+self.sAction+"',";
			sHTML += "'"+self.sIdTextfield+"',";
			sHTML += "'"+self.sChampTextField+"',";
			sHTML += "'"+self.sVarAJAR+"',";
			sHTML += "'"+self.sIdLimitOffset+"',";
			sHTML += "'"+self.sIdLimit+"',";
			sHTML += "'"+self.sIdAffichage+"',";
			sHTML += "'"+self.sIdTotal+"')\"";
			sHTML += " >&lt;&lt;</button></td>";
			
			sHTML += "<td width=\"80%\"><div align=\"center\">Rechercher : ";			
			sHTML += "<input type=\"text\" size=\"20\" name=\""+self.sIdTextfield+"\" ";
			sHTML += "id=\""+self.sIdTextfield+"\" class=\"AJAR_search\" accesskey=\"4\" ";
			sHTML += "onkeyup=\"AJAR_launchRequestRecherche('"+self.sIdDataGrid+"',";
			sHTML += "'"+self.getCompleteURL()+"',";
			sHTML += "'"+self.sAction+"',";
			sHTML += "'"+self.sIdTextfield+"',";
			sHTML += "'"+self.sChampTextField+"',";
			sHTML += "'"+self.sVarAJAR+"',";
			sHTML += "'"+self.sIdLimitOffset+"',";
			sHTML += "'"+self.sIdLimit+"',";
			sHTML += "'"+self.sIdAffichage+"',";
			sHTML += "'"+self.sIdTotal+"')\"";
			sHTML += " />";
			
			sHTML += "</div></td>";
			sHTML += "<td width=\"10%\"><div align=\"right\">";
			sHTML += "<button type=\"button\" name=\""+self.sIdButtonSuiv+"\" ";
			sHTML += "id=\""+self.sIdButtonSuiv+"\"  ";
			sHTML += "onclick=\"AJAR_nextResults('"+self.sIdDataGrid+"',";
			sHTML += "'"+self.getCompleteURL()+"',";
			sHTML += "'"+self.sAction+"',";
			sHTML += "'"+self.sIdTextfield+"',";
			sHTML += "'"+self.sChampTextField+"',";
			sHTML += "'"+self.sVarAJAR+"',";
			sHTML += "'"+self.sIdLimitOffset+"',";
			sHTML += "'"+self.sIdLimit+"',";
			sHTML += "'"+self.sIdAffichage+"',";
			sHTML += "'"+self.sIdTotal+"')\"";
			sHTML += " >&gt;&gt;</button></div></td>";
			sHTML += "</tr></table>";
			
			sHTML += "</td></tr>";
			
			sHTML += "</table>";
			sHTML += "<input type=\"hidden\" id=\""+self.sIdLimitOffset+"\" name=\""+self.sIdLimitOffset+"\" />";
			sHTML += "<input type=\"hidden\" id=\""+self.sIdLimit+"\" name=\""+self.sIdLimit+"\" />";
			sHTML += "<input type=\"hidden\" id=\""+self.sIdTotal+"\" name=\""+self.sIdTotal+"\" />";
			
			
			
			document.getElementById(self.sIdDiv).innerHTML = sHTML;			
			document.getElementById(self.sIdDiv).onclick = function(){};
			
			document.getElementById(self.sIdLimitOffset).value = self.iLimitOffset;
			document.getElementById(self.sIdLimit).value = self.iLimit;
			
			//self.dataGrid.imprimer(self.sIdDivDataGrid);
			
			//document.getElementById(self.sIdTextfield).setAttribute('class', 'AJAR_search');
		    //document.getElementById(self.sIdTextfield).setAttribute('className', 'AJAR_search');
			
			AJAR_contournerBugSelectIE(self.sIdDiv);
			
			AJAR_launchRequest(self.dataGrid,
								self.getCompleteURL(),
								self.sAction, 
								self.sIdTextfield, 
								self.sChampTextField,
								self.sVarAJAR,
								self.sIdLimitOffset, 
								self.sIdLimit,
								self.sIdAffichage,
								self.sIdTotal);
		}else{
			AJAR_contournerBugSelectIE(self.sIdDiv);
			AJAR_fermerDIV(self.sIdDiv);
		}
	};

	this.getPosTop = function(obj){
		toreturn = 0;
		while(obj){
			toreturn += obj.offsetTop;
			obj = obj.offsetParent;
		}
		return toreturn;
	};
	this.getPosLeft = function(obj){
		toreturn = 0;
		while(obj){
			toreturn += obj.offsetLeft;
			obj = obj.offsetParent;
		}
		return toreturn;
	};

}

function AJAR_chargerDataGrid(sReponse, dataGrid, sIdAffichage, sIdTotal, sIdLimitOffset, sIdLimit){
	var iTotal = 0;
	var aEntete = new Array();
	var aDonnees = new Array();
	var onRowClick = new Object();
	eval(sReponse);
	
	dataGrid.setOnRowClick(onRowClick);
	dataGrid.setEntete(aEntete);
	dataGrid.setDonnees(aDonnees);
	dataGrid.imprimer();
	
	document.getElementById(sIdTotal).value = iTotal;
	//Page x/xx (xx r?sultats)
	var s = "";
	if(iTotal<1){
		s += "Aucun résultat n'a été trouvé";
	}else{
		s += "Page ";
		var iLo = parseInt(document.getElementById(sIdLimitOffset).value,10);
		var iLi = parseInt(document.getElementById(sIdLimit).value,10);
		
		s += Math.floor(iLo/iLi)+1;
		s += "/";
		s += Math.ceil(iTotal/iLi);
		
		s += " ("+iTotal+" résultat";
		if (iTotal>1) s += "s";
		s += ")";
	}
	document.getElementById(sIdAffichage).innerHTML = s;
}

function AJAR_viderDataGrid(dataGrid, sIdAffichage){
	dataGrid.setEntete(new Array(new Object({libelle:'...', titre:'Chargement', width:'100%', visible:true})));
	dataGrid.setDonnees(new Array());
	dataGrid.imprimer();
	var s = "Aucun résultat n'a été trouvé";
	document.getElementById(sIdAffichage).innerHTML = s;
}
function AJAR_afficherPatienterSelect(dataGrid, sIdAffichage){
	dataGrid.setEntete(new Array(new Object({libelle:'...', titre:'Chargement', width:'100%', visible:true})));
	dataGrid.setDonnees(new Array());
	dataGrid.imprimer();
   	var s = "Chargement...";
	document.getElementById(sIdAffichage).innerHTML = s;
}

// Ajax ///
// NB : il faut d?clarer cet objet en global si on souhaite pouvoir intervenir
// sur celui-ci afin qu'une seule et unique requ?te soit ex?cut?e.
var AJAR_HttpObj = null;
if (window.XMLHttpRequest) {
	AJAR_HttpObj = new XMLHttpRequest();
}else if (window.ActiveXObject) {
	AJAR_HttpObj = new ActiveXObject("Microsoft.XMLHTTP");
}
function AJAR_launchRequest(dataGrid, sURL, sAction, sIdTextfield, sChampTextField, sVarAJAR, sIdLimitOffset, sIdLimit, sIdAffichage, sIdTotal){
	// on r?initialise la variable de sorte ? interrompre une ?ventuelle
	// requ?te d?j? en cours d'ex?cution
	if (window.XMLHttpRequest) {
		AJAR_HttpObj = new XMLHttpRequest();
	}else if (window.ActiveXObject) {
		AJAR_HttpObj = new ActiveXObject("Microsoft.XMLHTTP");
	}
	AJAR_viderDataGrid(dataGrid, sIdAffichage);
	AJAR_afficherPatienterSelect(dataGrid, sIdAffichage);
	try{
		// on pr?pare l'envoi avec l'url donn?e
		var sU = "sAction="+escape(sAction);
		sU += "&sChampRecherche="+escape(document.getElementById(sIdTextfield).value);
		sU += "&sChampTextField="+escape(sChampTextField);
		sU += "&sVarAJAR="+escape(sVarAJAR);
		sU += "&iLimitOffset="+document.getElementById(sIdLimitOffset).value;
		sU += "&iLimit="+document.getElementById(sIdLimit).value;
		AJAR_HttpObj.open("POST", sURL);

		// fonction ex?cut?e lorsque le traitement est termin?
		AJAR_HttpObj.onreadystatechange = function(){
			if (AJAR_HttpObj.readyState == 4) {
				var sReponse = AJAR_HttpObj.responseText;
				if (sReponse.length>0){
					AJAR_viderDataGrid(dataGrid, sIdAffichage);
					AJAR_chargerDataGrid(sReponse, dataGrid, sIdAffichage, sIdTotal, sIdLimitOffset, sIdLimit);
				}else{
					AJAR_viderDataGrid(dataGrid, sIdAffichage);
				}
			}else{
			}
		}
		AJAR_HttpObj.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
		AJAR_HttpObj.send(sU);
	} catch (e){alert("Erreur > AJAR_launchRequest :\n\n"+e);}
}

function AJAR_initDataGrid(sIdDataGrid){
	var dataGrid = new DataGrid(sIdDataGrid);
	dataGrid.setHeight(50);
	dataGrid.setWidth("100%");
	return dataGrid;
}

function AJAR_launchRequestRecherche(sIdDataGrid, sURL, sAction, sIdTextfield, sChampTextField, sVarAJAR, sIdLimitOffset, sIdLimit, sIdAffichage, sIdTotal){
//	pour une recherche il faut remettre le limitoffset ? 0
	var dataGrid = AJAR_initDataGrid(sIdDataGrid);
	document.getElementById(sIdLimitOffset).value = 0;
	AJAR_launchRequest(dataGrid, sURL, sAction, sIdTextfield, sChampTextField, sVarAJAR, sIdLimitOffset, sIdLimit, sIdAffichage, sIdTotal);
}

function AJAR_nextResults(sIdDataGrid, sURL, sAction, sIdTextfield, sChampTextField, sVarAJAR, sIdLimitOffset, sIdLimit, sIdAffichage, sIdTotal){
	var iLo = parseInt(document.getElementById(sIdLimitOffset).value,10);
	var iLi = parseInt(document.getElementById(sIdLimit).value,10);
	var iTotal = parseInt(document.getElementById(sIdTotal).value,10);
	if (iTotal>0 && ((iLo+iLi)<iTotal)){
		iLo += iLi;
		document.getElementById(sIdLimitOffset).value = iLo;
		var dataGrid = AJAR_initDataGrid(sIdDataGrid);
		AJAR_launchRequest(dataGrid, sURL, sAction, sIdTextfield, sChampTextField, sVarAJAR, sIdLimitOffset, sIdLimit, sIdAffichage, sIdTotal);
	}
}

function AJAR_prevResults(sIdDataGrid, sURL, sAction, sIdTextfield, sChampTextField, sVarAJAR, sIdLimitOffset, sIdLimit, sIdAffichage, sIdTotal){
	var iLo = parseInt(document.getElementById(sIdLimitOffset).value,10);
	var iLi = parseInt(document.getElementById(sIdLimit).value,10);
	var iTotal = parseInt(document.getElementById(sIdTotal).value,10);
	if (iTotal>0 && ((iLo-iLi)>=0)){
		iLo -= iLi;
		document.getElementById(sIdLimitOffset).value = iLo;
		var dataGrid = AJAR_initDataGrid(sIdDataGrid);
		AJAR_launchRequest(dataGrid, sURL, sAction, sIdTextfield, sChampTextField, sVarAJAR, sIdLimitOffset, sIdLimit, sIdAffichage, sIdTotal);
	}
}

function AJAR_fermerDIV(sIdDiv){
	document.getElementById(sIdDiv).style.display = "none";
	document.getElementById(sIdDiv).style.visibility = "hidden";
}

// AJAR_contournerBugSelectIE :
// 	- sIdDiv : le div qui s'ouvre et couvre les select ? cacher
function AJAR_contournerBugSelectIE(sIdDiv){
	// r?cup?ration des dimensions du div
	var oDiv = document.getElementById(sIdDiv);
	var x=0; var y=0; var oDivp; 
	if(oDiv.offsetParent){ 
		oDivp=oDiv; 
		while(oDivp.offsetParent){ 
			oDivp=oDivp.offsetParent;
			x+=oDivp.offsetLeft; 
			y+=oDivp.offsetTop; 
		} 
	} 
	x+=oDiv.offsetLeft; 
	y+=oDiv.offsetTop;
	w=oDiv.offsetWidth; 
	h=oDiv.offsetHeight;
	
	// on v?rifie qu'il s'agit bien de IE
	var appVer = navigator.appVersion.toLowerCase(); 
	var iePos = appVer.indexOf('msie'); 
	if (iePos !=-1) { 
		var is_minor = parseFloat(appVer.substring(iePos+5,appVer.indexOf(';',iePos))); 
		var is_major = parseInt(is_minor); 
	} 
	if (navigator.appName.substring(0,9) == "Microsoft"){ // Check if IE version is 6 or older 
		if (is_major <= 6) {
			var selx,sely,selw,selh,i 
			var sel=document.getElementsByTagName("SELECT")
			for(i=0;i<sel.length;i++){ 
				selx=0; sely=0; var selp; 
				if(sel[i].offsetParent){ 
					selp=sel[i]; 
					while(selp.offsetParent){ 
						selp=selp.offsetParent;
						selx+=selp.offsetLeft; 
						sely+=selp.offsetTop; 
					} 
				} 
				selx+=sel[i].offsetLeft; 
				sely+=sel[i].offsetTop;
				selw=sel[i].offsetWidth; 
				selh=sel[i].offsetHeight; 
				if(selx+selw>x && selx<x+w && sely+selh>y && sely<y+h){
					if(sel[i].style.visibility!="hidden") sel[i].style.visibility="hidden"; 
					else sel[i].style.visibility="visible"; 
				}
			}
		} 
	} 
}

function AJAR_addToTextField(sTexte, sChamp,oAjar ){
	var ajar = eval(oAjar);
	insererTexteApresCurseur(sTexte + "\n", sChamp);
	AJAR_contournerBugSelectIE(ajar.sIdDiv);
	AJAR_fermerDIV(ajar.sIdDiv);
} 
