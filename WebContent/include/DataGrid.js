/*
Attention ce composant est en cours de d?veloppement !!!
FB, le 6 d?cembre 2005

*/
function DataGrid(sIdChamp) {
	this.id = sIdChamp;
	this.sComposantPrefix = "DG_";
	this.sIdChamp = sIdChamp;
	this.sIdDiv = this.sComposantPrefix+"div_"+this.sIdChamp;
	this.sIdTableau = this.sComposantPrefix+"table_"+this.sIdChamp;
	this.sIdTBody = this.sComposantPrefix+"tbody_"+this.sIdChamp;
	this.aEntete = new Array();
	this.aDonnees = new Array();
	
	
	this.bHeaderFix = true;
	this.height = "50";
	this.width='100%';

	this.onRowClick = null;

	/*
	onRowClick doit ?tre un objet compos? de 2 param?tres :
	sAction : la fonction javascript ? appeler
	iParamColIndexValue : l'index de la colonne du datagrid
	
	exemple :
	this.dataGrid.setOnRowClick(new Object({sAction:"alert", iParamColIndexValue:0}));
	ici on appelle la fonction alert avec comme param?tre la valeur de la colonne n?0 
	ce qui fait alert(<la valeur de la colonne n?0>);
	*/
	this.setOnRowClick = function(oObjet){
		if (typeof(oObjet) != "object"){
			alert("Erreur DataGrid.setOnRowClick : Objet attendu");
		}else{
			this.onRowClick = oObjet;
		}
	}

	this.setEntete = function(aTab){
		this.aEntete = aTab;
	}
	this.setDonnees = function(aTab){
		if (this.aEntete.length==0){
			alert("Erreur DataGrid : Vous devez d'abord d?finir l'ent?te.\nIl faut appeler d'abord setEntete et ensuite setDonnees.");
			this.aDonnees = new Array();
		}else if ((aTab.length>0) && (this.aEntete.length != aTab[0].length)){
			alert("Erreur DataGrid : Le nombre de colonnes des donn?es ne correspond pas ? l'ent?te.");
			this.aDonnees = new Array();
		}else{
			this.aDonnees = aTab;
		}
	}

	this.setIdDiv = function(sName){
		this.sIdDiv = sName;
	}
	this.getIdDiv = function(){
		return this.sIdDiv;
	}
	this.setWidth = function(sWidth){
		this.width = sWidth;
	}
	this.setHeight = function(sHeight){
		this.height = sHeight;
	}

	this.addSlashes = function(sTexte){
		var sT = new String(sTexte);
		sT = sT.replace(/\\/g,"\\\\");
		sT = sT.replace(/\'/g,"\\'");
		sT = sT.replace(/\"/g,"\\\"");
		sT = sT.replace(/\&apos;/g,"\\'");
		return sT;
	}
	this.getHTML = function(){
		var sHTML = "";
	  	
	    sHTML += '<table id="' +this.sIdTableau + '" class="bsDg_table" cellspacing="0" cellpadding="0" border="0" ';
	    sHTML += 'width="'+this.width+'" style="width:'+this.width+';" ';
//	    sHTML += ' headerCSS="bsDb_tr_header" bs_dg_objectId="' + sIdDivDataGrid + '"';
	    sHTML += '>';

		sHTML += '<thead><tr class="DG_tr_header">';
		for (var i=0 ; i<this.aEntete.length ; i++){
			if (this.aEntete[i]['visible']){
				
				sHTML += '<td';
				if (this.aEntete[i]['titre']!="") {
					sHTML += ' title="' + this.aEntete[i]['titre'] + '"';
				}
				sHTML += ' class="DG_td_header"';
				if (this.aEntete[i]['width']!="") {
					sHTML += ' style="width:' + this.aEntete[i]['width'] + '"';
				}
				sHTML += '>' + this.aEntete[i]['libelle'] + '</td>';
			}
		}
		sHTML += '</tr></thead>';
		
		sHTML += '<tbody id="'+this.sIdTBody+'" ';
		//sHTML += 'style="overflow:auto;max-height:'+this.height+';"';
		sHTML += '>';

		if (this.aDonnees.length == 0) {
			sHTML += '<tr><td colspan="100%">-</td></tr>';
        } else {
			for (var l=0; l<this.aDonnees.length; l++) {
	            sHTML += '<tr ';
	            sHTML += 'class="liste'+(l%2)+'" ';
	            sHTML += 'onmouseover="className=\'liste_over\'" ';
	            sHTML += 'onmouseout="className=\'liste'+(l%2)+'\'" ';
	            
				if (this.onRowClick != null) {
	              sHTML += ' style="cursor:pointer" onclick="'+this.onRowClick["sAction"]+'(\'';
	              sHTML += this.addSlashes(this.aDonnees[l][this.onRowClick["iParamColIndexValue"]]);
	              sHTML += '\'';
					// ajout des ?ventuels param?tres suppl?mentaires
					if (this.onRowClick["aParamSuppl"]!=null){
						for (var iP=0;iP<this.onRowClick["aParamSuppl"].length;iP++){
							sHTML += ', \''+this.addSlashes(this.onRowClick["aParamSuppl"][iP])+'\'';
						}
					}
	              sHTML += ');"';
	            }
	            
	            sHTML += '>';
	            for (var c=0; c<this.aDonnees[l].length; c++) {
	            	if (this.aEntete[c]['visible']){
						sHTML += '<td style="vertical-align:top;border-bottom:1px solid #000;">';
						sHTML += (this.aDonnees[l][c].length == 0) ? '&nbsp;' :this.aDonnees[l][c];
						sHTML += '</td>';
	            	}
	            }
	            sHTML += '</tr>' + "\n";
			}
		}
		sHTML += '</tbody></table>';
		return sHTML;
	}
	this.imprimer = function() {
		document.getElementById(this.getIdDiv()).innerHTML = this.getHTML();
	}
}
