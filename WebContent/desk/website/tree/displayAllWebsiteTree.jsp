<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@page import="java.util.Vector"%>
<%@page import="org.coin.bean.conf.TreeviewParsing"%>
<%@page import="modula.graphic.Icone"%>
<%@page import="mt.website.*"%>
<%  
	String sTitle = "Arborescence du site";
	boolean bShowOptions = true;
	Vector vHabilitation = null ;
	String sPageUseCaseId = "IHM-DESK-WEBSITE-TREEVIEW"; 
	
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
	
	Vector<WebsiteTreeRoot> vRoot = WebsiteTreeRoot.getAllStaticMemory();
%>
<script type="text/javascript" src="<%= rootPath %>include/DataGrid.js"></script>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/WebsiteTree.js"></script>
<script type="text/javascript" >
var disableOnClick = false;
var sSessionId = ";jsessionid=<%= session.getId()%>";
var sRootPath = "<%= request.getContextPath()+"/" %>";
var divOptionTreeview;
var sIdDivOptionTreeview = "divOptionTreeview";
var sCurIdButton="";
var levelToOpen = 0;//nombre de niveaux de menu ouvert au clic
var levelOpened = 0;

function openTreeviewOption(sIdChamp,rootNode){
    disableOnClick = true;
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
		var t = eval(
				getPosTop(document.getElementById(this.sIdButton))
				+ document.getElementById(this.sIdButton).offsetHeight
				) + "px";
		var l = eval(
				getPosLeft(document.getElementById(this.sIdButton))
				- 300
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
		sHTML += "<button type=\"button\" name=\""+this.sIdButtonFermer+"\" ";
		sHTML += "id=\""+this.sIdButtonFermer+"\" ";
		sHTML += "onclick=\"contournerBugSelectIE('"+this.sIdDiv+"');";
		sHTML += "fermerDIV('"+this.sIdDiv+"', '"+this.sIdButton+"')\" ";
		sHTML += ">X</button></div></td>";
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
				{libelle:MESSAGE_TV_ADMIN[1], titre:MESSAGE_TV_ADMIN[1], width:'90%', visible:true}
				);
		var aDonnees = new Array();
		<%
		if( sessionUserHabilitation.isHabilitate("IHM-DESK-WEBSITE-TREEVIEW")){
		%>
		aDonnees.push(new Array('ajouterFils_'+this.sIdChamp, 
						'<img src=\''+sRootPath+'images/treeview/addnode.png\'>',
						MESSAGE_TV_ADMIN[2]
						));
		<%
		}
		if(sessionUserHabilitation.isHabilitate("IHM-DESK-WEBSITE-TREEVIEW")){
		%>
		aDonnees.push(new Array('afficherInformations_'+this.sIdChamp, 
				'<img src=\'<%=rootPath+Icone.ICONE_FICHIER_DEFAULT %>\' width=\'20\'>',
				MESSAGE_TV_ADMIN[3]
				));
		<%
		}
		%>
		if (sIdChamp!=rootNode){
		<%
		if( sessionUserHabilitation.isHabilitate("IHM-DESK-WEBSITE-TREEVIEW")){
		%>
				aDonnees.push(new Array('ajouterFrere_'+this.sIdChamp, 
						'<img src=\''+sRootPath+'images/treeview/addbrother.png\'>',
						MESSAGE_TV_ADMIN[4]
						));
		<%
		}
		if( sessionUserHabilitation.isHabilitate("IHM-DESK-WEBSITE-TREEVIEW")){
		%>
		
			aDonnees.push(new Array('supprimerNoeud_'+this.sIdChamp, 
									'<img src=\''+sRootPath+'images/treeview/delnode.png\'>',
									MESSAGE_TV_ADMIN[5]
									));
		<%
		}
		%>
		
		<%
		if(sessionUserHabilitation.isHabilitate("IHM-DESK-WEBSITE-TREEVIEW")){
		%>
			aDonnees.push(new Array('decalerHaut_'+this.sIdChamp, 
									'<img src=\''+sRootPath+'images/treeview/up.png\'>',
									MESSAGE_TV_ADMIN[6]
									));
			aDonnees.push(new Array('decalerBas_'+this.sIdChamp, 
									'<img src=\''+sRootPath+'images/treeview/down.png\'>',
									MESSAGE_TV_ADMIN[7]
									));
			aDonnees.push(new Array('decalerGauche_'+this.sIdChamp, 
									'<img src=\''+sRootPath+'images/treeview/left.png\'>',
									MESSAGE_TV_ADMIN[8]
									));
			aDonnees.push(new Array('decalerDroite_'+this.sIdChamp, 
									'<img src=\''+sRootPath+'images/treeview/right.png\'>',
									MESSAGE_TV_ADMIN[9]
									));
		<%
		}
		%>
		}
		var onRowClick = new Object({sAction:'traiterRequete', 
		                              iParamColIndexValue:0,
		                              aParamSuppl:[rootNode] });
					
		
		
		this.dataGrid.setOnRowClick(onRowClick);
		this.dataGrid.setEntete(aEntete);
		this.dataGrid.setDonnees(aDonnees);
		this.dataGrid.imprimer();

	}
}

function fermerDIV(sIdDiv, sIdButton){
	document.getElementById(sIdDiv).style.display = "none";
	document.getElementById(sIdDiv).style.visibility = "hidden";
}

function traiterRequete(sRequete,rootNode){
	var t = sRequete.split("_");
	var sIdNoeud = t[1];
	var sName = "";
	var sIndexName = "";
	if (t[0]=="ajouterFils" || t[0]=="ajouterFrere"){
		sName = prompt("Titre de la nouvelle page :", "");
		if (sName.length>0){
			WebsiteTree.getKeywordsForURL(sName, function(s){
				if (s.length>0) {
					sIndexName = prompt("Nom de son index :", s);
				}else{
					sIndexName = prompt("Nom de son index :", "");
				}
				switch(t[0]){
					case "ajouterFils":
							if (sName.length==0 || sIndexName.length==0){
								alert("Vous devez renseigner le titre et l'index de la page");
								break;
							} 
							location.href = "modifyWebsiteTree.jsp"+sSessionId+"?lIdWebsiteTree="+sIdNoeud+"&iAddType=1&sAction=create&iIdRootNode="+rootNode+"&sName="+sName+"&sIndexName="+sIndexName;
							break;
					case "ajouterFrere":
							if (sName.length==0 || sIndexName.length==0){
								alert("Vous devez renseigner le titre et l'index de la page");
								break;
							}
							location.href = "modifyWebsiteTree.jsp"+sSessionId+"?lIdWebsiteTree="+sIdNoeud+"&iAddType=2&sAction=create&iIdRootNode="+rootNode+"&sName="+sName+"&sIndexName="+sIndexName;
							break;
				}
			});
		}
	}else{
		switch(t[0]){
			case "afficherInformations":
					location.href = "modifyWebsiteTreeForm.jsp"+sSessionId+"?lIdWebsiteTree="+sIdNoeud+"&iIdRootNode="+rootNode+"#ancreHP";
					break;
			case "supprimerNoeud":
				    if(confirm("Supprimer ce noeud ?")){
				          WebsiteTree.removeFromId(sIdNoeud,rootNode,function(b) {
				         	if (b){ 
				            	location.href = "displayAllWebsiteTree.jsp"+sSessionId;
				           	}else{
				           		alert("Erreur de suppression");
				           	}
				           });
				           /*
				         WebsiteTree.removeFromId(sIdNoeud,rootNode,function() { 
				            location.href = "modifyWebsiteTree.jsp"+sSessionId+"?iIdRootNode="+rootNode;
				           });*/
				     }
					break;
			case "decalerHaut":
				location.href = "modifyWebsiteTree.jsp"+sSessionId+"?sAction=up&lIdWebsiteTree="+sIdNoeud+"&iIdRootNode="+rootNode;
				break;
			case "decalerBas":
				location.href = "modifyWebsiteTree.jsp"+sSessionId+"?sAction=down&lIdWebsiteTree="+sIdNoeud+"&iIdRootNode="+rootNode;
				break;
			case "decalerGauche":
				location.href = "modifyWebsiteTree.jsp"+sSessionId+"?sAction=left&lIdWebsiteTree="+sIdNoeud+"&iIdRootNode="+rootNode;
				break;
			case "decalerDroite":
				location.href = "modifyWebsiteTree.jsp"+sSessionId+"?sAction=right&lIdWebsiteTree="+sIdNoeud+"&iIdRootNode="+rootNode;
				break;
		}
	}
}

function initDataGrid(sIdDataGrid){
	var dataGrid = new DataGrid(sIdDataGrid);
	dataGrid.setHeight("30px");
	dataGrid.setWidth("100%");
	return dataGrid;
}

function openBranch(id,action) {
    if(!disableOnClick){
        var isOpen = false;
        $$('#'+id+' .menuOpen').each(function(item,index){
            item.className = "menuClose";
            isOpen = true;
        });
        if(!isOpen){
	        $$('#'+id+' .menuClose').each(function(item,index){
	            item.className = "menuOpen";
	        });
	    }
        
	    $$(".node_"+id).each(function(item,index){
	        if(index==0 && !isNotNull(action)){
	            if(item.style.display == "none"){
	                action = "show";
	            }else{
	                action = "hide";
	            }
	        }
	        
	        var actionChild = false;
            if( (action == "hide" && $$('#'+item.id+' .menuOpen').length>0)
            || (action == "show" && $$('#'+item.id+' .menuClose').length>0) ){
               actionChild = true;
            }
	        
	        if(action == "show"){
	           Element.show(item);
	           $$('#'+item.id+' .menuOpen').each(function(item,index){
                    item.className = "menuClose";
               });
	        }
	        else if(action == "hide"){
	           Element.hide(item);
	           $$('#'+item.id+' .menuClose').each(function(item,index){
                    item.className = "menuOpen";
               });
	        }
	        else
	            Element.toggle(item);
	            
	        levelOpened++;
	        if(actionChild && ( action != "show" || (action == "show" && levelOpened<=levelToOpen)) ){
	           openBranch(item.id,action);
	        }
	    });
	 }else{
	   disableOnClick = false;
	 }
	 levelOpened = 0;
}

function showButtonMoveCharacteristicType(id)
{
	Element.show("spanMoveChar_"+id);
}

function moveCharacteristicType(idCharType)
{
	var idCompType = $("char_"	+ idCharType + "_lIdComponentType").value;
	
	var sUrlParam = "lIdWebsiteTree=" + idCompType;

	//alert(sUrlParam);
	
	doUrl("<%= response.encodeURL("moveVehicleCharacteristicType.jsp?"
			) %>" + sUrlParam);
}
function addTree(){
	var sName = prompt("Entrer le nom de l'arborescence :", ""); 
	if (sName.length>0){
		location.href = "modifyTreeview.jsp"+sSessionId+"?sAction=create&sName="+sName;
	}
}
function modifyTree(iIdTree){
	location.href = "modifyWebsiteTreeRootForm.jsp"+sSessionId+"?sAction=modify&lIdWebsiteTreeRoot="+iIdTree;
}
function removeTree(iIdTree){
	if (confirm("Supprimer cette arborescence ?") && confirm("Etes-vous certain(e) de supprimer ?")){
		location.href = "modifyTreeview.jsp"+sSessionId+"?sAction=remove&lIdWebsiteTreeRoot="+iIdTree;
	}
}
onPageLoad = function(){
    // creation du div
    divOptionTreeview = document.createElement("div");
    divOptionTreeview.id = sIdDivOptionTreeview;
    window.document.body.appendChild(divOptionTreeview);
}
</script>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<div style="margin-left: 15px;">
	<a href="javascript:void(0)" onclick="addTree()">Ajouter une arborescence</a>
</div>
<div id="fiche">
    <div class="fullWidth">
    <%

    for(WebsiteTreeRoot root : vRoot){
    	Vector<TreeviewNode> vItemList = WebsiteTree.getAllTreeviewNode();
    	vItemList = TreeviewParsing.getTreeviewNodeList((int)root.getIdWebsiteTree(),vItemList);
    	%>
 		<div style="margin-bottom: 15px;border: dotted 1px #eeeeee;padding: 2px;">
 			<div style="font-weight: bold;">
 				<%= root.getName() %>
 				<a href="javascript:void(0)" onclick="modifyTree(<%= root.getId() %>)">[ Modifier ]</a>
 				<a href="javascript:void(0)" onclick="removeTree(<%= root.getId() %>)">[ Supprimer ]</a>
 			</div>
    	<%
    	for (int i=0; i < vItemList.size(); i++){
            WebsiteTree node = (WebsiteTree) vItemList.get(i);
            int j;
            boolean bHasChild = node.hasChild();
            %> 
            <div class="fullWidth">
            <table cellspacing="0" 
            class="<%= (node.iDepth==0)?"caption_root":"caption level"+(node.iDepth)%> <%= "node_"+node.lIdTreeviewNodeParent %>"
            style="<%= (node.iDepth==0)?"background-color:#F3F3F3":"display:block"%>"
            id="<%= node.getId() %>"
            >
                   <tr class="" style="cursor:pointer">
                        <td class="caption_td" style="width:30%;vertical-align:middle;font-weight:bold" onclick="openBranch(<%= node.getId() %>)">
                            <div style="padding-left:<%= ((node.iDepth)*15) %>px;">
                            
                            <div class="<%= bHasChild?"menuOpen":"" %>"
                                 style="<%= bHasChild?"":"padding-left:15px;" %>">
                                 <a name="<%=node.getId() %>">
                            <%= node.getTitle() %>
                            	</a>
                            </div>
                            <div style="font-size: 9px;font-weight: normal;"><%= "[iIdWebsiteTree="+node.getId()+"] " %></div>
                            </div>
                        </td>

                        <td class="caption_td" style="width:30%;vertical-align:middle;">
                            <div style="font-size: 9px;font-weight: normal;">
                            <%= ((node.iDepth>0)?"/":"")+node.getCompletePath() %>
                            </div>
                        </td>
                        
                        <td class="caption_td" style="width:30%;vertical-align:middle;">
                            <div style="font-size: 9px;font-weight: normal;">
                            <button type="button" onclick="window.open('<%= rootPath+node.getCompletePath() %>');return false;">
                            	<img src="<%=response.encodeURL(rootPath+"images/icons/eye.gif") %>" alt="" />
							</button>
                            <% 
                            	if (!node.isDisplayedNode()){
                            		out.print("Non affiché");
                            	}else if (!node.isDisplayInMenu()){
                            		out.print(" <strike title=\"N'apparait pas dans le menu du site\">menu</strike>");
                            	}
                            	if (node.getIdWebsiteTreeStatus()==WebsiteTreeStatus.TYPE_DYNAMIC){
                            		out.print(" <em>Dynamique</em>");
                            	}
                            	if (node.getAccessRights()==WebsiteTree.ACCESS_RIGHT_USER_MODIFY){
                            		out.print(" <span title=\"Modifiable par l'utilisateur\">Modifiable</span>");
                            	}
                            %>
                            
                            </div>
                        </td>
                        <%
                        if(bShowOptions){
                        %>
                        <td class="caption_td" style="width:1%;vertical-align:middle">
                            <button type="button" name="but_<%= node.getId() %>" id="but_<%= node.getId() %>" 
                                onclick="openTreeviewOption('<%= node.getId() %>','<%= root.getId() %>')" >Options</button>
                        </td>
                        <% } %>
                </tr>
            </table>
            </div>
            <%

            } 
            %>
        </div>
        <% 
    }
%>
</div>
</div> 
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>

<%@page import="org.coin.bean.conf.TreeviewNode"%>
<%@page import="mt.veolia.vfr.vehicle.characteristic.VehicleCharacteristicType"%>
<%@page import="org.coin.db.CoinDatabaseAbstractBeanHtmlUtil"%>
<%@page import="mt.website.WebsiteTreeRoot"%>
</html>