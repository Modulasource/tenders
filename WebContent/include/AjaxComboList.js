/**
AjaxComboList Beta

à insérer dans la page (en vrac) : 


window.onload = function(){
	if (window.XMLHttpRequest || window.ActiveXObject){
		var ac = new AjaxComboList("iIdOrganisation", "getRaisonSociale");
	}else{
		alert("Attention, votre navigateur n'est pas compatible avec la technologie \"Ajax\".\nVeuillez installer un navigateur récent : www.GetFirefox.com");
	}
}


<input type="button" name="AJCL_but_iIdOrganisation" id="AJCL_but_iIdOrganisation" value="Cliquer ici pour sélectionner l'organisme" />
<input type="hidden" id="iIdOrganisation" name="iIdOrganisation" />

**/

/**
 * WARNING : sInitActionOnChange and sInitActionOnEmpty cannot be a function with a parameter !!!
 * GOOD : foo()
 * BAD  : foo('hello')
 */
function AjaxComboList(
		sIdChamp, 
		sAction, 
		openDirection,
		sInitActionOnChange,
		bSimpleUI,
		iFieldLengthMin)
{
	if(!openDirection)
	   this.openDirection = "right";
	else
	   this.openDirection = openDirection;
	
	if(bSimpleUI != null) {
		this.bSimpleUI = bSimpleUI;
	} else {
		this.bSimpleUI = false;
	}
	
	if(iFieldLengthMin != null) {
		this.iFieldLengthMin = iFieldLengthMin;
	} else {
		this.iFieldLengthMin = 3;
	}
	
	this.sIdChamp = sIdChamp;
	this.sAction = sAction;
	this.sFocedId = 0;
	this.sComposantPrefix = "AJCL_";
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

    /** for the form controls */
	try{$(this.sIdChamp).fieldReference = $(this.sIdButton);}
	catch(e){}
	
	this.selectedText = "";
	this.bLaunchQueryOnStartUp = false;
	
	this.sInstanceName = null;
	this.sActionOnChange = "";
	if(isNotNull(sInitActionOnChange)) this.sActionOnChange = sInitActionOnChange;
	this.bShowId="false";
	
	this.sIdDiv = this.sComposantPrefix+"div_"+this.sIdChamp;
	
	this.iLimitOffset = 0;	
	this.iLimit = 50;	
	
	var self = this;
	
	var div = document.createElement("div");
	div.id = this.sIdDiv;
	window.document.body.appendChild(div);
	
	this.setInstanceName = function(sInstanceName){
		this.sInstanceName = sInstanceName;
	}
	this.addActionOnChange = function(sAction){
		this.sActionOnChange = sAction;
	}
	this.addActionOnEmpty = function(sAction){
		this.addActionOnEmpty = sAction;
	}
	
	this.setMinimumSaisi = function(iTaille){
		this.iMinimumSaisi = iTaille;
	};
	this.initialiserChamps = function(sLibelle, sValeur){
		$(this.sIdChamp).value = sValeur;
		$(this.sIdButton).value = sLibelle;
		$(this.sIdButton).innerHTML = sLibelle;
		
	}
	this.getPosTop = function(obj){
        toreturn = 0;
        while(obj){
            toreturn += obj.offsetTop;
            obj = obj.offsetParent;
        }
        return toreturn;
    }
    this.getPosLeft = function(obj){
        toreturn = 0;
        while(obj){
            toreturn += obj.offsetLeft;
            obj = obj.offsetParent;
        }
        return toreturn;
    }
    
	this.defineSelectSpecificAction = function(){}
    
    this.actualizePosition = function(){
        var t = eval(self.getPosTop($(self.sIdButton)) 
        + $(self.sIdButton).offsetHeight) + "px";
        var buttonWidth = $(self.sIdButton).offsetWidth;
        var l = eval(
                 self.getPosLeft($(self.sIdButton))
                 -((self.openDirection == "left")?450:0)
                 +((self.openDirection == "left")?buttonWidth:0)
                 ) + "px";
                 
         var div = $(self.sIdDiv);
         div.style.left = l;
         div.style.top = t;
    }
    
    this.createHTML = function(){
    	self = this;
        var div = $(self.sIdDiv);
        div.style.display = "none";
        div.style.visibility = "hidden";
        div.style.zIndex = 1000;
        div.style.width = "450px";
        
        div.setAttribute('class', 'divSuggestion');
        div.setAttribute('className', 'divSuggestion');
        
        var iTableWidth = 450;
        var iSearchInputWidth = 50;
        var iSizeDivButton = 130;
        if(this.bSimpleUI) {
        	div.style.width = "280px";
            iTableWidth = 280;
        	iSearchInputWidth = 20;
        }
        
        var sHTML = "<table width=\"" + iTableWidth + "px\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">\n";
        sHTML += "<tr><td>\n";
        
        sHTML += "<table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">\n"
            + "<tr>\n"

            + "<td width=\"" + (iTableWidth - iSizeDivButton) + "px\"><div align=\"left\">\n"
            + "&nbsp;"
            
        var sHTMLInputSearch =
            "<input type=\"text\" size=\""+ iSearchInputWidth + "\" name=\""+self.sIdTextfield+"\" "
            + "id=\""+self.sIdTextfield+"\" class=\"AJCL_search\" accesskey=\"4\" "
            + "onkeyup=\"AJCL_launchRequestRecherche("
            + "'"+self.sIdSelect+"',"
            + "'"+self.sAction+"',"
            + "'"+self.sIdTextfield+"',"
            + "'"+self.sIdLimitOffset+"',"
            + "'"+self.sIdLimit+"',"
            + "'"+self.sIdAffichage+"',"
            + "'"+self.sIdTotal+"',"
            + "'"+self.sFocedId+"',"
            + self.iFieldLengthMin
            + ")\""
            + (this.bSimpleUI?"":"value=\""+MESSAGE_AJCL[7]+"\"")
            + " />\n"
            
            
        sHTML += 
        	sHTMLInputSearch
        	+ "</div>\n</td>\n"
            + "<td width=\"" + iSizeDivButton + "px\"><div  align=\"right\">\n";
        

        
        var sHTMLButtonEmpty 
        	="<button type=\"button\" "
            + "onclick=\"AJCL_setEmptyAndClose("
            + "'"+self.sIdTextfield+"', "
            + "'"+self.sIdSelect+"', "
            + "'"+self.sIdChamp+"',"
            + "'"+self.sIdButton+"',"
            + "'"+self.sIdDiv+"',"
            + "'"+self.sActionOnChange+"'"
            + ");\" >" + MESSAGE_AJCL[1] + "</button>\n";


            
        sHTML += 
        	sHTMLButtonEmpty
            + "<button type=\"button\" "
            + "onclick=\"AJCL_contournerBugSelectIE('"+self.sIdDiv+"','"+self.sIdSelect+"');"
            + "AJCL_fermerDIV('"+self.sIdDiv+"')\" "
            + ">x</button>\n"
            + "</div></td>\n"
            + "</tr></table>\n";
        
        
        sHTML += "</td></tr>";
        
        sHTML += "<tr><td style=\"width:" + iTableWidth + "px\" >";
        sHTML += "<select ";
        sHTML += "name=\""+self.sIdSelect+"\" ";
        sHTML += "id=\""+self.sIdSelect+"\" ";
        sHTML += "size=\"10\" style=\"width:" + iTableWidth + "px\" ";
        sHTML += "/>";
        sHTML += "</td></tr>";
        
        sHTML += "<tr "
        	+ (this.bSimpleUI?" style='display:none;' ":"" )
        	+ " ><td>";
        
        sHTML += "<table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">";
        sHTML += "<tr>";
        sHTML += "<td width=\"10%\">";
        sHTML += "<button type=\"button\" name=\""+self.sIdButtonPrec+"\" ";
        sHTML += "id=\""+self.sIdButtonPrec+"\" value=\"&lt;&lt;\" ";
        sHTML += "onclick=\"AJCL_prevResults('"+self.sIdSelect+"',";
        sHTML += "'"+self.sAction+"',";
        sHTML += "'"+self.sIdTextfield+"',";
        sHTML += "'"+self.sIdLimitOffset+"',";
        sHTML += "'"+self.sIdLimit+"',";
        sHTML += "'"+self.sIdAffichage+"',";
        sHTML += "'"+self.sIdTotal+"')\"";
        sHTML += " >&lt;&lt;</button></td>"

            + "<td width=\"90%\"><div align=\"center\" id=\""+self.sIdAffichage+"\">"
            + " "/*Chargement*/
            + "</div></td>";
        

        sHTML += "<td width=\"10%\"><div align=\"right\">";
        sHTML += "<button type=\"button\" name=\""+self.sIdButtonSuiv+"\" ";
        sHTML += "id=\""+self.sIdButtonSuiv+"\" value=\"&gt;&gt;\" ";
        sHTML += "onclick=\"AJCL_nextResults('"+self.sIdSelect+"',";
        sHTML += "'"+self.sAction+"',";
        sHTML += "'"+self.sIdTextfield+"',";
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
        
        $(self.sIdDiv).innerHTML = sHTML;         
        $(self.sIdDiv).onclick = function(){};
        
        $(self.sIdLimitOffset).value = self.iLimitOffset;
        $(self.sIdLimit).value = self.iLimit;
                
        $(self.sIdTextfield).onfocus = function(){
        	if(this.value==MESSAGE_AJCL[7]) this.value="";
        }
    
        $(self.sIdSelect).onchange = function(){
          AJCL_getItemFromSelect(
        		  self.sIdChamp,
                  self.sIdSelect,
                  self.sIdButton,
                  self.sIdDiv,
                  self.bShowId,
                  self.sActionOnChange);
         }
    }
    
    this.createHTML();
	$(this.sIdButton).onclick = function(){
		if ($(self.sIdDiv).style.visibility!="visible"){
            /**
             * display SE
             */
			AJCL_openDIV(self);
			self.defineSelectSpecificAction();
			AJCL_contournerBugSelectIE(self.sIdDiv, self.sIdSelect);
			
			if(self.bLaunchQueryOnStartUp)
			{
				/**
				 * does not working ...
				 */
				AJCL_launchRequest(self.sIdSelect,
						self.sAction, 
						self.sIdTextfield, 
						self.sIdLimitOffset, 
						self.sIdLimit,
						self.sIdAffichage,
						self.sIdTotal,
						self.sFocedId,
						null);
			}
		}else{
            /**
             * hide SE
             */
			AJCL_contournerBugSelectIE(self.sIdDiv, self.sIdSelect);
			AJCL_fermerDIV(self.sIdDiv);
		}
	};
	
	this.init = function(value){
	   if(parseInt(value) > 0){
	       $(self.sIdButton).innerHTML = MESSAGE_AJCL[5];
	       self.sFocedId = value;
		   AJCL_launchRequest(
				   self.sIdSelect,
                   self.sAction, 
                   self.sIdTextfield, 
                   self.sIdLimitOffset, 
                   self.sIdLimit,
                   self.sIdAffichage,
                   self.sIdTotal,
                   self.sFocedId,
			       function(){
				       var l = $(self.sIdSelect);
				       mt.html.setSuperCombo(l);
				       l.setSelectedValue(value);
				       self.defineSelectSpecificAction();
		
				       AJCL_getItemFromSelect(self.sIdChamp,
				                                     self.sIdSelect,
				                                     self.sIdButton,
				                                     self.sIdDiv,
				                                     self.bShowId,
				                                     self.sActionOnChange);
		
				       self.selectedText = l.getSelectedText();
				       self.onAfterInit();
		
				       if($(self.sIdButton).innerHTML == MESSAGE_AJCL[5])
				          $(self.sIdButton).innerHTML = MESSAGE_AJCL[6];
			       });
	   }else{
	       self.onAfterInit();
	   }
	}
	
	this.onAfterInit = function(){}
	
	this.getSelectedText = function(){
	   var l = $(this.sIdSelect);
       mt.html.setSuperCombo(l);
       return l.getSelectedText();
	}

}

function AJCL_chargerSelect(
		sReponse, 
		sIdSelect, 
		sIdAffichage, 
		sIdTotal, 
		sIdLimitOffset, 
		sIdLimit)
{
	var iTotal = 0;
	var aReponseLibelle = new Array();
	var aReponseId = new Array();
	var aReponseObj = new Array();
	eval(sReponse);	
	var l1 = $(sIdSelect);	
	for (var i=0;i<aReponseId.length;i++){		

		var newOpt = document.createElement("OPTION");
		newOpt.text = aReponseLibelle[i];
		newOpt.value = aReponseId[i];
		newOpt.obj = aReponseObj[i];
		try{
			l1.add(newOpt,null); 
		}catch(ex){
			l1.add(newOpt);//IE
		}	
	}
	$(sIdTotal).value = iTotal;
	var s = "";
	if(iTotal<1){
		s += MESSAGE_AJCL[2];
	}else{
		s += "Page ";
		var iLo = parseInt($(sIdLimitOffset).value,10);
		var iLi = parseInt($(sIdLimit).value,10);
		
		s += Math.floor(iLo/iLi)+1;
		s += "/";
		s += Math.ceil(iTotal/iLi);
		
		s += " ("+iTotal+" "+MESSAGE_AJCL[3];
		if (iTotal>1) s += "s";
		s += ")";
	}
	$(sIdAffichage).innerHTML = s;
}

function AJCL_viderSelect(sIdSelect, sIdAffichage){
	var l1 =$(sIdSelect);
	l1.length = 0;
	var s = MESSAGE_AJCL[2];
	$(sIdAffichage).innerHTML = s;
}
function AJCL_afficherPatienterSelect(sIdSelect, sIdAffichage){
	var l1 = $(sIdSelect);
   	l1.options[0] = new Option(MESSAGE_AJCL[4], -1,0,0);
   	var s = MESSAGE_AJCL[5];
	$(sIdAffichage).innerHTML = s;
}

function AJCL_setEmptyAndClose(
		sIdTextfield,
		sIdSelect, 
		sIdChamp, 
		sIdButton, 
		sDIV, 
		sActionOnChange)
{
	var l = $(sIdSelect);
	$(sIdChamp).value = "";
	$(sIdButton).value = "";
	$(sIdButton).innerHTML = "&nbsp;";
	$(sIdSelect).length = 0;
	$(sIdTextfield).value = "";
	
	AJCL_contournerBugSelectIE(sDIV, sIdSelect);
	AJCL_fermerDIV(sDIV);
	if (sActionOnChange!=""){
		eval(sActionOnChange);
	}
	
}

function AJCL_launchRequest(
		sIdSelect, 
		sAction, 
		sIdTextfield, 
		sIdLimitOffset, 
		sIdLimit, 
		sIdAffichage, 
		sIdTotal, 
		iForceId,
		callback)
{
    AJCL_viderSelect(sIdSelect, sIdAffichage);
    AJCL_afficherPatienterSelect(sIdSelect, sIdAffichage);
    try{
        sAction = sAction;        
        sChamp = $(sIdTextfield).value;
        iLimitOffset = $(sIdLimitOffset).value;
        iLimit = $(sIdLimit).value;
        iForceId = iForceId;

        GetListeForAjaxComboList.getAjaxList(
        		sAction,
                sChamp,
                iLimitOffset,
                iLimit,
                iForceId,
		        function(sReponse){
		            try{           	
			            if (sReponse.length>0){
			                AJCL_viderSelect(sIdSelect, sIdAffichage);
			                AJCL_chargerSelect(
			                		sReponse, 
			                		sIdSelect, 
			                		sIdAffichage, 
			                		sIdTotal, 
			                		sIdLimitOffset, 
			                		sIdLimit);
			            }else{
			                AJCL_viderSelect(sIdSelect, sIdAffichage);
			            }    
			            if(isNotNull(callback)){
			                callback();
			            }
		            }catch(e){alert("Erreur > AJCL_launchRequest / Response :\n\n"+e);}
		        });
    } catch (e){alert("Erreur > AJCL_launchRequest :\n\n"+e);}
}

function AJCL_launchRequestRecherche(
		sIdSelect, 
		sAction, 
		sIdTextfield, 
		sIdLimitOffset, 
		sIdLimit, 
		sIdAffichage, 
		sIdTotal,
		sFocedId,
		iFieldLengthMin)
{
    clearTimeout($(sIdTextfield).lastKeyUpTimeId);
    $(sIdTextfield).lastKeyUpTimeId = setTimeout(function() {
        if($(sIdTextfield).value.length >= iFieldLengthMin){
	       $(sIdLimitOffset).value = 0;
	       AJCL_launchRequest(
	    		   sIdSelect, 
	    		   sAction, 
	    		   sIdTextfield, 
	    		   sIdLimitOffset, 
	    		   sIdLimit, 
	    		   sIdAffichage, 
	    		   sIdTotal,
	    		   sFocedId,
	    		   null);
	    }
    }, 1000);
    
}

function AJCL_nextResults(
		sIdSelect, 
		sAction, 
		sIdTextfield, 
		sIdLimitOffset, 
		sIdLimit, 
		sIdAffichage, 
		sIdTotal)
{
	var iLo = parseInt($(sIdLimitOffset).value,10);
	var iLi = parseInt($(sIdLimit).value,10);
	var iTotal = parseInt($(sIdTotal).value,10);
	if (iTotal>0 && ((iLo+iLi)<iTotal)){
		iLo += iLi;
		$(sIdLimitOffset).value = iLo;
		AJCL_launchRequest(
				sIdSelect, 
				sAction, 
				sIdTextfield, 
				sIdLimitOffset, 
				sIdLimit, 
				sIdAffichage, 
				sIdTotal,
				0,
				null);
	}
}

function AJCL_prevResults(
		sIdSelect, 
		sAction, 
		sIdTextfield, 
		sIdLimitOffset, 
		sIdLimit, 
		sIdAffichage, 
		sIdTotal)
{
	var iLo = parseInt($(sIdLimitOffset).value,10);
	var iLi = parseInt($(sIdLimit).value,10);
	var iTotal = parseInt($(sIdTotal).value,10);
	if (iTotal>0 && ((iLo-iLi)>=0)){
		iLo -= iLi;
		$(sIdLimitOffset).value = iLo;
		AJCL_launchRequest(
				sIdSelect, 
				sAction, 
				sIdTextfield, 
				sIdLimitOffset, 
				sIdLimit, 
				sIdAffichage, 
				sIdTotal,
				0,
				null);
	}
}




function AJCL_getItemFromSelect(
		sIdChamp, 
		sIdSelect, 
		sIdButton, 
		sDIV, 
		bShowId, 
		sActionOnChange)
{
	var l = $(sIdSelect);
	if(l.options.selectedIndex>=0){
	    var optionSelected = l.options[l.options.selectedIndex];
		$(sIdChamp).value = optionSelected.value;

		var sValue = "";
		if(bShowId=="true"){
			sValue = optionSelected.value;
		}
		else {
			sValue = optionSelected.text;
		}

		$(sIdButton).value = sValue;
		$(sIdButton).innerHTML = sValue;

		AJCL_contournerBugSelectIE(sDIV, sIdSelect);
		AJCL_fermerDIV(sDIV);

	    if (sActionOnChange!=""){
	        eval(sActionOnChange);
	    }
	}
}
function AJCL_fermerDIV(sIdDiv){
	$(sIdDiv).style.display = "none";
	$(sIdDiv).style.visibility = "hidden";
}
function AJCL_openDIV(ac){
    $(ac.sIdDiv).style.display = "block";
    $(ac.sIdDiv).style.visibility = "visible";
    
    ac.actualizePosition();
}

// AJCL_contournerBugSelectIE :
// 	- sIdDiv : le div qui s'ouvre et couvre les select à cacher
//	- sIdSelectException : le select du composant à ne pas cacher
function AJCL_contournerBugSelectIE(sIdDiv, sIdSelectException){
	// récupération des dimensions du div
	var oDiv = $(sIdDiv);
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
	
	// on vérifie qu'il s'agit bien de IE
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
				if(sel[i].id!=sIdSelectException && 
					selx+selw>x && selx<x+w && sely+selh>y && sely<y+h){
					if(sel[i].style.visibility!="hidden") sel[i].style.visibility="hidden"; 
					else sel[i].style.visibility="visible"; 
				}
			}
		} 
	} 
} 
