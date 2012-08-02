<%@ include file="../../../include/new_style/headerDesk.jspf" %>

<%@ page import="java.util.*,org.coin.util.treeview.*,modula.graphic.*" %>
<%@page import="modula.TreeviewNoeud"%>
<%  String sTitle = "Modifer la treeview";
	boolean bUseHabilitations = true;
	boolean bShowOptions = true;
	Vector vHabilitation = null ;
	int iIdRootNode = 1;
	
	try {
		iIdRootNode = Integer.parseInt(request.getParameter( "iIdRootNode" ) );	
	} catch(Exception e) {}

	// TODO revoir cette méthode
	//org.coin.util.treeview.TreeviewParsing.removeUnusedNode();

	String sPageUseCaseId = "IHM-DESK-PARAM-TV-1"; 
%>
<%@ include file="../../include/checkHabilitationPage.jspf" %>
<script type="text/javascript" src="<%= response.encodeURL("../../include/treeview.js") %>" ></script>
<script type="text/javascript" src="<%= rootPath %>include/DataGrid.js"></script>
<script type="text/javascript" >
function checkChainedNode(iIdNode)
{
	var bCheck ;
	var iIdNodeRoot = 1;
	var node;
	
	node = getNode(iIdNode);
	
	bCheck = node.checked;
	
	// only one button can be checked
	visitAndCheck(iIdNodeRoot, false);
	node.checked = bCheck ;

	return ;
}
function submitWithURL(sURL)
{
	document.forms['formulaire'].action = sURL;
}
/////////////
function openTreeviewOption(sIdChamp){
//function AjaxAideRedac(sIdChamp, sAction, sRootPath, sSessionId){
	this.sIdChamp = sIdChamp;
	this.sComposantPrefix = "TreeviewOption_";
	
	this.sIdDataGrid = this.sComposantPrefix+"dg_"+this.sIdChamp;	//
	this.sIdButton = "but_"+this.sIdChamp;	// Bouton de lancement
	this.sIdButtonFermer = this.sComposantPrefix+"butf_"+this.sIdChamp;	// Bouton fermer
	
	
	this.sInstanceName = null;
	this.sActionOnChange = "";
	
	this.sIdDiv = sIdDivOptionTreeview;
	
	var self = this;

	
	/* Initialisation du datagrid */
	this.dataGrid = initDataGrid(this.sIdDataGrid);
	/******************************/
	
	this.setInstanceName = function(sInstanceName){
		this.sInstanceName = sInstanceName;
	}
	this.addActionOnChange = function(sActionOnChange){
		this.sActionOnChange = sActionOnChange;
	}

	contournerBugSelectIE(this.sIdDiv);
	fermerDIV(this.sIdDiv, this.sIdButton);
	if(sCurIdButton!=""){
		fermerDIV(this.sIdDiv, sCurIdButton);
	}
	if (sCurIdButton==this.sIdButton){
		fermerDIV(this.sIdDiv, sCurIdButton);
		sCurIdButton="";
	}else if (document.getElementById(this.sIdDiv).style.visibility!="visible"){
		sCurIdButton = this.sIdButton;
		document.getElementById(this.sIdButton).style.background="#FEE39A";
		var t = eval(
				getPosTop(document.getElementById(this.sIdButton))
				) + "px";
		var l = eval(
				getPosLeft(document.getElementById(this.sIdButton))
				+ document.getElementById(this.sIdButton).offsetWidth
				) + "px";
		
		var div = document.getElementById(this.sIdDiv);
		div.style.display = "block";
		div.style.visibility = "visible";
		div.style.left = l;
		div.style.top = t;
		div.style.width = "300px";
		
		div.setAttribute('class', 'divSuggestion');
	    div.setAttribute('className', 'divSuggestion');
		
		var sHTML = "<table width=\"300px\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">";
		sHTML += "<tr><td>";
		
		sHTML += "<table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">";
		sHTML += "<tr>";
		sHTML += "<td width=\"100%\"><div align=\"right\">";
		sHTML += "<input type=\"button\" name=\""+this.sIdButtonFermer+"\" ";
		sHTML += "id=\""+this.sIdButtonFermer+"\" value=\"x\" ";
		sHTML += "onclick=\"contournerBugSelectIE('"+this.sIdDiv+"');";
		sHTML += "fermerDIV('"+this.sIdDiv+"', '"+this.sIdButton+"')\" ";
		sHTML += "/></div></td>";
		sHTML += "</tr></table>";
		
		sHTML += "</td></tr>";

		sHTML += "<tr><td>";
		sHTML += "<div id=\""+this.dataGrid.getIdDiv()+"\" class=\"DGClass\" style=\"width:300px;height:200px\">";
		sHTML += "</div>";
		sHTML += "<div id=\"debug\"></div>";
		
		sHTML += "</td></tr>";
		
		sHTML += "</table>";
		
		document.getElementById(this.sIdDiv).innerHTML = sHTML;			
		document.getElementById(this.sIdDiv).onclick = function(){};
							
		contournerBugSelectIE(this.sIdDiv);
		
		var aEntete = new Array(
				{libelle:'id', titre:'id', width:'0%', visible:false},
				{libelle:'-', titre:'-', width:'10%', visible:true},
				{libelle:'Choix', titre:'Choix', width:'90%', visible:true}
				);
		var aDonnees = new Array();
		<%
		if( sessionUserHabilitation.isHabilitate("IHM-DESK-PARAM-TV-3")){
		%>
		aDonnees.push(new Array('ajouterFils_'+this.sIdChamp, 
						'<img src=\''+sRootPath+'images/treeview/addnode.png\'>',
						'Ajouter un fils'
						));
		<%
		}
		if(sessionUserHabilitation.isHabilitate("IHM-DESK-PARAM-TV-6")){
		%>
		aDonnees.push(new Array('afficherInformations_'+this.sIdChamp, 
				'<img src=\'<%=rootPath+Icone.ICONE_FICHIER_DEFAULT %>\' width=\'20\'>',
				'Afficher les informations'
				));
		<%
		}
		%>
		if (sIdChamp!=1){
		<%
		if( sessionUserHabilitation.isHabilitate("IHM-DESK-PARAM-TV-4")){
		%>
				aDonnees.push(new Array('ajouterFrere_'+this.sIdChamp, 
						'<img src=\''+sRootPath+'images/treeview/addbrother.png\'>',
						'Ajouter un frère'
						));
		<%
		}
		if( sessionUserHabilitation.isHabilitate("IHM-DESK-PARAM-TV-5")){
		%>
		
			aDonnees.push(new Array('supprimerNoeud_'+this.sIdChamp, 
									'<img src=\''+sRootPath+'images/treeview/delnode.png\'>',
									'Supprimer le noeud'
									));
		<%
		}
		%>
		
		<%
		if(sessionUserHabilitation.isHabilitate("IHM-DESK-PARAM-TV-7")){
		%>
			aDonnees.push(new Array('decalerHaut_'+this.sIdChamp, 
									'<img src=\''+sRootPath+'images/treeview/up.png\'>',
									'Décaler le noeud vers le haut'
									));
			aDonnees.push(new Array('decalerBas_'+this.sIdChamp, 
									'<img src=\''+sRootPath+'images/treeview/down.png\'>',
									'Décaler le noeud vers le bas'
									));
			aDonnees.push(new Array('decalerGauche_'+this.sIdChamp, 
									'<img src=\''+sRootPath+'images/treeview/left.png\'>',
									'Décaler le noeud vers la gauche'
									));
			aDonnees.push(new Array('decalerDroite_'+this.sIdChamp, 
									'<img src=\''+sRootPath+'images/treeview/right.png\'>',
									'Décaler le noeud vers la droite'
									));
		<%
		}
		%>
		}
		var onRowClick = new Object({sAction:'traiterRequete', iParamColIndexValue:0});
					
		
		
		this.dataGrid.setOnRowClick(onRowClick);
		this.dataGrid.setEntete(aEntete);
		this.dataGrid.setDonnees(aDonnees);
		this.dataGrid.imprimer();

	}
}
function getPosTop(obj){
	toreturn = 0;
	while(obj){
		toreturn += obj.offsetTop;
		obj = obj.offsetParent;
	}
	return toreturn;
}
function getPosLeft(obj){
	toreturn = 0;
	while(obj){
		toreturn += obj.offsetLeft;
		obj = obj.offsetParent;
	}
	return toreturn;
}
function fermerDIV(sIdDiv, sIdButton){
	document.getElementById(sIdDiv).style.display = "none";
	document.getElementById(sIdDiv).style.visibility = "hidden";
	document.getElementById(sIdButton).style.background="#FFFFFF";
}

// contournerBugSelectIE :
// 	- sIdDiv : le div qui s'ouvre et couvre les select ? cacher
function contournerBugSelectIE(sIdDiv){
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
function traiterRequete(sRequete){
	var t = sRequete.split("_");
	var sIdNoeud = t[1];
	switch(t[0]){
		case "ajouterFils":
				document.getElementById("node_post").value = sIdNoeud;
				document.formulaire.action = "ajouterTreeviewNode.jsp"+sSessionId+"?iAddType=1&iIdRootNode=<%= iIdRootNode%>";
				document.formulaire.submit();
				break;
		case "afficherInformations":
				document.location.href = "modifierTreeviewNodeForm.jsp"+sSessionId+"?iIdNode="+sIdNoeud+"&iIdRootNode=<%= iIdRootNode%>#ancreHP";
				break;
		case "ajouterFrere":
				document.getElementById("node_post").value = sIdNoeud;
				document.formulaire.action = "ajouterTreeviewNode.jsp"+sSessionId+"?iAddType=2&iIdRootNode=<%= iIdRootNode%>";
				document.formulaire.submit();
				break;
		case "supprimerNoeud":
				if (confirm("Souhaitez-vous réellement supprimer ce noeud ?")){
					document.getElementById("node_post").value = sIdNoeud;
					document.formulaire.action = "supprimerTreeviewNode.jsp"+sSessionId+"?iIdRootNode=<%= iIdRootNode%>";
					document.formulaire.submit();
				}
				break;
		case "decalerHaut":
			document.location.href = "deplacerTreeviewNode.jsp"+sSessionId+"?sAction=up&iIdNode="+sIdNoeud+"&iIdRootNode=<%= iIdRootNode%>";
			break;
		case "decalerBas":
			document.location.href = "deplacerTreeviewNode.jsp"+sSessionId+"?sAction=down&iIdNode="+sIdNoeud+"&iIdRootNode=<%= iIdRootNode%>";
			break;
		case "decalerGauche":
			document.location.href = "deplacerTreeviewNode.jsp"+sSessionId+"?sAction=left&iIdNode="+sIdNoeud+"&iIdRootNode=<%= iIdRootNode%>";
			break;
		case "decalerDroite":
			document.location.href = "deplacerTreeviewNode.jsp"+sSessionId+"?sAction=right&iIdNode="+sIdNoeud+"&iIdRootNode=<%= iIdRootNode%>";
			break;
	}
}

function initDataGrid(sIdDataGrid){
	var dataGrid = new DataGrid(sIdDataGrid);
	dataGrid.setHeight("30px");
	dataGrid.setWidth("100%");
	return dataGrid;
}

var sSessionId = ";jsessionid=<%= session.getId()%>";
var sRootPath = "<%= request.getContextPath()+"/" %>";
var divOptionTreeview;
var sIdDivOptionTreeview = "divOptionTreeview";
var sCurIdButton="";
window.onload = function(){
	// cr?ation du div
	divOptionTreeview = document.createElement("div");
	divOptionTreeview.id = sIdDivOptionTreeview;
	window.document.body.appendChild(divOptionTreeview);
}

</script>
</head>
<body>
<%@ include file="../../../include/new_style/headerFiche.jspf" %>
<div id="fiche">


<%
// Définition des éléments graphiques à afficher :
String sFolderIcons = rootPath+"images/treeview/";
String sRootIcon = sFolderIcons+"folder.png";
String sOpenRootIcon = sFolderIcons+"openfolder.png";
String sFolderIcon = sFolderIcons+"folder.png";
String sOpenFolderIcon = sFolderIcons+"openfolder.png";
String sFileIcon = sFolderIcons+"file.png";
String sIIcon = sFolderIcons+"I.png";
String sLIcon = sFolderIcons+"L.png";
String sLMinusIcon = sFolderIcons+"Lminus.png";
String sLPlusIcon = sFolderIcons+"Lplus.png";
String sTIcon = sFolderIcons+"T.png";
String sTMinusIcon = sFolderIcons+"Tminus.png";
String sTPlusIcon = sFolderIcons+"Tplus.png";
String sBlankIcon = sFolderIcons+"blank.png";
%>
<form id="formulaire" name="formulaire" method="post" action="<%= response.encodeURL("supprimerTreeviewNode.jsp") %>" >
	<input type="hidden" id="node_post" name="node_post" />
	
	
	<!-- Liste des noeuds -->

	
	<table cellspacing="0" class="pave" style="border:none">	
		<!-- Affichage des noeuds  -->
<%
	Vector vItemList ;

	// DK modif pour avoir plusieurs treeviews
		vItemList = TreeviewNoeud.getItemList(iIdRootNode, 0, request.getContextPath()+"/" ) ;
		
 	for (int i=0; i < vItemList.size(); i++)
 	{
 	 	TreeviewNode node = (TreeviewNode ) vItemList.get(i);
		int j;
%> 	
		  	<tr id="ancre_<%= node.getId() %>" class="liste<%=i%2
		  		%>" onmouseover="className='liste_over'" onmouseout="className='liste<%=i%2%>'"
<%
		// FLON : cf. bugzilla bug #31
		//if( sessionUserHabilitation.isHabilitate("IHM-DESK-PARAM-TV-6") )
		if(false)
		{
%>
		  	onclick="Redirect('<%= response.encodeURL("modifierTreeviewNodeForm.jsp?iIdNode=" + node.getId() ) %>')"
<%
		}
%>>

	<%@ include file="pave/paveTreeviewNode.jspf" %>
				</tr>

<%} 
 %>
	</table>

	
</form>


</div> <!-- end fiche -->
<%@ include file="../../../include/new_style/footerFiche.jspf" %>
</body>
</html>