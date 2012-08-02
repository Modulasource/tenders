<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.html.*" %>
<%@page import="java.util.Vector"%>
<% 
	WebsitePublication item = null;
	String sPageUseCaseId = "IHM-DESK-WEBSITE-PUBLICATION";
	
	String sTitle = "Actualité";
	String sWebsitePublicationWord = "actualité";
	boolean bKindFemaleElement = true;

	// Type de News (permet de décliner sous plusieurs rubriques d'actu)
	long lIdWebsitePublicationType = HttpUtil.parseLong("lIdWebsitePublicationType", request, WebsitePublicationType.TYPE_DEFAULT);
	
	if(lIdWebsitePublicationType==WebsitePublicationType.TYPE_HOMMAGE){
		sTitle = "Hommage";
		sWebsitePublicationWord = "hommage";
		bKindFemaleElement = false;
	}
	if(lIdWebsitePublicationType==WebsitePublicationType.TYPE_ACTUALITE_CULTURELLE){
		sTitle = "Actualité culturelle";
		sWebsitePublicationWord = "actualité culturelle";
		bKindFemaleElement = true;
	}
	if(lIdWebsitePublicationType==WebsitePublicationType.TYPE_NOUVEAUX_OUVRAGES){
		sTitle = "Nouveaux ouvrages";
		sWebsitePublicationWord = "nouvel ouvrage";
		bKindFemaleElement = false;
	}
	if(lIdWebsitePublicationType==WebsitePublicationType.TYPE_ASSOCIATION){
		sTitle = "Billet des 15 régiments";
		sWebsitePublicationWord = "nouvel article";
		bKindFemaleElement = false;
	}
	
	sTitle = "<span class=\"altColor\">"+sTitle+"</span>"; 

	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);

	
	String sarrDisplayModeArray[] 
	     = new String[] {
			 "detail",
			 "miniature"
		};
	
    String sarrDisplayModeArrayLabel[] 
            = new String[] {
                "Détail",
                "Miniatures"
       };
	
	
	String sDisplayModeArrayDocument = HttpUtil.parseString("sDisplayModeArrayDocument", request, "miniature");

%>
<style type="text/css">
<!--
#results th{
    text-align: left;
}
-->
.LabelContentType{
	position:"absolute";
	z-index: "2";
	font-size: "10px";
	color: "#EEE";
	background-color: "#990000";
	filter:Alpha(opacity=84);-moz-opacity:0.84; 
	width: "40px";
	height: "12px";
	text-align: "center";
	vertical-align: "middle";
	margin-top: "42px";
	margin-left: "25px";
}
</style>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/SearchEngine.js"></script>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/WebsitePublication.js"></script>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/WebsitePublicationTemplate.js"></script>
<script type="text/javascript" src="<%=rootPath %>include/js/searchEngine/mt.component.SearchEngine.js?v=3"></script>
<script type="text/javascript" src="<%=rootPath %>include/js/searchEngine/layout/mt.component.layout.DocumentLayout.js?v=1"></script>

<script type="text/javascript">

mt.config.enableAutoLoading = false;
var jsonWebsitePublicationPlace = <%=WebsitePublicationTemplate.getJSONArray()%>;
var sURLModify = "<%= response.encodeURL(rootPath+"desk/website/publication/modifyForm.jsp?lId=") %>";
var jsonDisplay = [{"sLabel":"Affichage en miniature","sId":"miniature"},{"sLabel":"Affichage détaillé","sId":"detail"}];
var jsonState = [{"lId":<%=WebsitePublication.STATE_ACTIVE%>, "sLabel":"Actif"}, {"lId":<%=WebsitePublication.STATE_INACTIVE%>, "sLabel":"Inactif"}];

function formatToComponent(sDate){
	if (!sDate) return "";
	var aDate = sDate.substring(0, 10).split("-");
	return aDate[2]+"/"+aDate[1]+"/"+aDate[0]; 
}

function getReducedWord(sWord, iNumberChar){
// fonction en cours de dev
	if (sWord.length==0) return "";
	var arrWords = sWord.split(new RegExp("\\W", "g"));
	if (arrWords.length==0){
		if(sWord.length>iNumberChar) return sWord.substring(0, iNumberChar)+"...";
		else return sWord;
	}
	for (var i=0;i<arrWords.length;i++){
		if (arrWords[i].length>iNumberChar) arrWords[i]=arrWords[i].substring(0, iNumberChar)+"...";
	}
	return arrWords.join(" ");
}

function getBooleanModeExactKeyword(sString){
	return '"'+sString+'"';
}
/*
bOptionAllWords : Search with "and" if true (must content all words)
				else search with "or" (content one or more words)
*/
function getBooleanModeWordOption(sString, bOptionAllWords){
	if (sString.indexOf(",")==-1){
		var a = sString.split(" ");
	} else {
		var a = sString.split(",");
	}
	var a2 = [];
	if (bOptionAllWords){
		a.each(function(item){a2.push("+"+item.trim()+"*");});
	} else {
		a.each(function(item){a2.push(item.trim()+"*");});
	}
	return a2.join(" ");
}
function getLinkModifyDocument(obj, bComplete) {
	var linkDoc = document.createElement("span");
	
	var img = document.createElement("img");
	img.alt = img.title = "Modifier";
	img.src = "<%= rootPath + "images/icons/application_edit.gif" %>";
	
    var aLink = document.createElement("a");
    aLink.href= sURLModify + obj.id_website_publication;
    aLink.style.paddingLeft="5px";
    aLink.innerHTML = "Modifier";    
    
    if (!bComplete){
    	aLink.innerHTML = "";
    	aLink.appendChild(img);
    	return aLink;
    }    
    
    linkDoc.appendChild(img);
    linkDoc.appendChild(aLink);
    return linkDoc;
}
var engine = new mt.component.SearchEngine();
var sDisplayModeArrayDocument = "<%= sDisplayModeArrayDocument %>";


/**
 * Définition des LAYOUT et du contenu des cellules
 */ 

/* Définition du layout détail */
var layoutDetail = new mt.component.layout.TableLayout('results');
layoutDetail.enableSelections(false, "id_website_publication");
layoutDetail.addHeader("Id").getCellContent = function(obj) {
    return obj.id_website_publication;
}
layoutDetail.addHeader("Titre").getCellContent = function(obj, cell) {
    cell.style.padding = "5px 5px 2px 6px";
    cell.style.fontWeight = "bold";
    cell.style.color = "#36C";
    cell.style.fontSize = "12px";
    cell.style.verticalAlign = "top";
    var div = document.createElement("div");
    div.innerHTML = obj.title;
    return div;
}

layoutDetail.addHeader("Sous-titre").getCellContent = function(obj) {
    return obj.subtitle;
}
layoutDetail.addHeader("Date de publication").getCellContent = function(obj) {
    return formatToComponent(obj.date_publish);
}
layoutDetail.addHeader("Date d'archivage").getCellContent = function(obj) {
    return formatToComponent(obj.date_archive);
}
layoutDetail.addHeader("Etat").getCellContent = function(obj) {
    return (obj.state==<%= WebsitePublication.STATE_ACTIVE %>?"Visible":"Non visible sur le site");
}
	
layoutDetail.addHeader("").getCellContent = function(obj) {
	var div = document.createElement("div");
    div.appendChild(getLinkModifyDocument(obj, true));
    return div;
}


var layoutMosaic = new mt.component.layout.DocumentLayout('results');
layoutMosaic.enableSelections(false, "id_website_publication");
layoutMosaic.setItemDisplay = function(obj) {
	var sTitle = obj.title;
    
    var div = document.createElement("div");
    div.style.width = "100px";
    div.style.textAlign = "center";

    var br = document.createElement("br");
    
    var divImg = document.createElement("div");
    divImg.style.width = divImg.style.maxHeight = "64px";
    //divImg.style.border = "solid blue 1px";
    divImg.style.marginRight = "auto";
    divImg.style.marginLeft = "auto";
    
    var img = document.createElement("img");
    img.src = "<%= rootPath+"images/icons/64x64/document.png" %>";
    img.alt = img.title = sTitle;
    img.style.display = "block";
    img.style.marginRight = "auto";
    img.style.marginLeft = "auto";
    img.style.cursor = "pointer";
    img.style.marginTop = "-50%";
    img.style.position = "relative";
    img.onclick = function(){
    	document.location.href = sURLModify + obj.id_website_publication;
    }
    divImg.appendChild(img);
    
    var linkDoc = document.createElement("a");
    linkDoc.href = sURLModify + obj.id_website_publication;
    linkDoc.innerHTML = linkDoc.title = sTitle;
       
    var label = document.createElement("div");
    label.className = "SE_DocumentLayout_label";
    label.title = sTitle;
    label.onclick = function(){
    	//document.location.href = sURL;
    }
    
    label.appendChild(divImg);
    label.appendChild(linkDoc);
    //div.appendChild(divType);
    div.appendChild(label);
    return div;
}

engine.enablePagination(false);
engine.setMainTable("website_publication", "p");
engine.setSelectPart("<%=SecureString.getSessionSecureString(
        "p.id_website_publication, p.title, p.subtitle, "
        +"p.date_publish, p.date_archive, p.state"
    , session)%>");



engine.setGroupByClause("p.id_website_publication");
engine.setOrderBy("p.date_publish", "desc");

engine.onBeforeSearch = function(){
    $('resultCount').innerHTML = '';
	//engine.addTable("WebsitePublication_place gp", "g.id_website_publication_place = gp.id_website_publication_place", []);
    
    var sKeyword = $('keyword').value;
	if (isNotNull(sKeyword)){
		//engine.addWhereClause("CONCAT_WS('', doc.name, doc.description, doc.reference) LIKE ?", ["%"+sKeyword.trim()+"%"]);
		engine.addWhereClause("MATCH (p.title, p.subtitle, p.content) AGAINST (? IN BOOLEAN MODE)", [getBooleanModeWordOption(sKeyword, false)]);
	}
	engine.addWhereClause("p.id_website_publication_type=?", [<%= lIdWebsitePublicationType %>]);	
	if ($('lState').value>0){
		engine.addWhereClause("p.state=?", [$('lState').value]);
	} 
    return true;
}

engine.onAfterSearch = function(result){
	if(result.dataset.length==0){
		$('resultCount').innerHTML = "<h5>Aucun résultat n'a été trouvé.</h5>";
		$('results').innerHTML = "";
	}else $('resultCount').innerHTML = (result.dataset.length)+" résultat"+((result.dataset.length>1)?"s":"");
}

function removeDocument(id, name){
    if(confirm("Do you want to delete the document \"" + name + "\" ?")){
         location.href = '<%= 
             response.encodeURL("../document/modifyDocument.jsp?sAction=remove&lId=") %>' + id;
     }
}

function removeDocumentSelected(){
	var selections;
	switch($('selectDisplay').value){
		case "detail":
			selections = layoutDetail.getSelections();
			break;
		default:
			selections = layoutMosaic.getSelections();
			break;
	}
	

	var sSelectedItemUrlParam = "";
    var sSelectedItemListDocumentName = "";
    
    if (selections.length==0) {
        alert("Pas de document sélectionné");   
        return false;
    }

    selections.each(function(item){
        if(sSelectedItemUrlParam != "") {
            sSelectedItemUrlParam += ",";
            sSelectedItemListDocumentName += ",\n";
        }
        sSelectedItemUrlParam += item.id_website_publication ;
        sSelectedItemListDocumentName += "- " + item.name ;
    }) 
       

    if(confirm("Souhaitez-vous supprimer ces fiches ?\n" 
            + sSelectedItemListDocumentName
             )){
         location.href = '<%= 
             response.encodeURL(rootPath+"desk/ged/fondation_leclerc/modifyDocument.jsp?sAction=removeAll&arrayId=")
             %>' + sSelectedItemUrlParam;
     }
    
}

function setCookie (name, value) {
	var argv=setCookie.arguments;
	var argc=setCookie.arguments.length;
	var expires=(argc > 2) ? argv[2] : null;
	var path=(argc > 3) ? argv[3] : null;
	var domain=(argc > 4) ? argv[4] : null;
	var secure=(argc > 5) ? argv[5] : false;
	document.cookie=name+"="+escape(value)+
		((expires==null) ? "" : ("; expires="+expires.toGMTString()))+
		((path==null) ? "" : ("; path="+path))+
		((domain==null) ? "" : ("; domain="+domain))+
		((secure==true) ? "; secure" : "");
}
function getCookieVal(offset) {
	var endstr=document.cookie.indexOf (";", offset);
	if (endstr==-1)
      		endstr=document.cookie.length;
	return unescape(document.cookie.substring(offset, endstr));
}
function getCookie (name) {
	var arg=name+"=";
	var alen=arg.length;
	var clen=document.cookie.length;
	var i=0;
	while (i<clen) {
		var j=i+alen;
		if (document.cookie.substring(i, j)==arg)
                        return getCookieVal (j);
                i=document.cookie.indexOf(" ",i)+1;
                        if (i==0) break;}
	return null;
}
function switchDisplay(){
	switch($('selectDisplay').value){
		case "detail":
			engine.setLayoutProvider(layoutDetail);
			break;
		default:
			engine.setLayoutProvider(layoutMosaic);
			break;
	}
		
	engine.run(true);
	setCookie("SEDisplayDocument", $('selectDisplay').value);
}

function populate(){
	//$('lIdWebsitePublicationPlace').populate([{"sLabel":"-","lId":0}].concat(jsonWebsitePublicationPlace), "", "lId", "sLabel");
	var sDefaultDisplay = ((getCookie("SEDisplayDocument")==null)?"detail":getCookie("SEDisplayDocument"));
	$('lState').populate([{"sLabel":"-","lId":0}].concat(jsonState), "", "lId", "sLabel");
	$('selectDisplay').populate(jsonDisplay, sDefaultDisplay, "sId", "sLabel");
	$('selectDisplay').onchange = function(){switchDisplay();}
	switchDisplay();
}

onPageLoad = function() {   
	populate();
	// Préchargement de l'image par défaut :
	var img = new Image(16, 16);
	img.src = "<%= rootPath %>images/icons/application.gif";
	var imgDoc = new Image(64, 64);
	imgDoc.src = "<%= rootPath+"images/icons/64x64/document.png" %>";

	FORM = $('form');
	FORM.onsubmit = function() {
		engine.run(true);
		return false;
	}
}

</script>

</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<div style="margin: 5px;">
	<a href="<%= response.encodeURL("modifyForm.jsp?sAction=create&lIdWebsitePublicationType="+lIdWebsitePublicationType) %>">
		<img src="<%= rootPath+"images/icons/32x32/document_add.png" %>" alt="Ajouter" />
	Ajouter un article
	</a>
</div>
<form id="form" method="post">
<div>

        <div class="round blockTitle " corner="6" border="1" style="width:560px;margin-left: auto;margin-right: auto;margin-top: 10px;">
            <div style="padding:5px;margin-left: auto;margin-right: auto;text-align: center;">
                <table class="formLayout" style="width:550px;">
                    <tr>
                        <td class="label" style="text-align: center;">Etat : <select id="lState"></select></td>
                        <td class="label" style="text-align: center;">Mot clé : <input id="keyword" class="searchInput" type="text" style="margin-left: auto;" /></td>
                    </tr>
                    <tr>               
                        <td colspan="2" style="text-align: center;"><button style="width:150px;" id="searchButton" type="submit">Rechercher</button></td>
                    </tr>
                </table>
            </div>
        </div>

</div>



<div id="contentFolder" style="margin-right:5px; margin-left: 5px;padding-bottom: 15px;">
	<div id="buttonsAction2" style="width:560px;margin-right:auto; margin-left: auto;margin-bottom: 10px;margin-top:2px;text-align: center;">
	    <select name="selectDisplay" id="selectDisplay">
	    </select>
	</div>
    <div id="resultCount" style="text-align: center;font-weight:bold;font-size: 11px;padding: 2px;"></div>
    <div id="results"></div>

</div>



<%@ include file="/include/new_style/footerFiche.jspf" %>
</form>
</body>


<%@page import="org.coin.security.SecureString"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="mt.website.WebsitePublication"%>
<%@page import="mt.website.WebsitePublicationTemplate"%>
<%@page import="mt.website.WebsitePublicationType"%>
</html>
