<%@ include file="../../../../../include/new_style/headerDesk.jspf" %>

<%@page import="java.util.Vector"%>
<%@page import="org.coin.bean.conf.TreeviewParsing"%>
<%@page import="modula.graphic.Icone"%>
<%  
	String sTitle = "Organization";
	boolean bShowOptions = true;
	Vector vHabilitation = null ;
	
	String sPageUseCaseId = "IHM-DESK-ORG-GROUP-1"; 
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
	
	sessionUser.setAbstractBeanLocalization(sessionLanguage);
	
	String sUseCaseIdModify = "IHM-DESK-ORG-GROUP-2"; 
	if(!sessionUserHabilitation.isHabilitate(sUseCaseIdModify))
		bShowOptions = false;
	
    int ROOT = OrganisationGroup.ROOT;
%>
<script type="text/javascript" src="<%= rootPath %>include/DataGrid.js"></script>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/OrganisationGroup.js"></script>
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
		if( sessionUserHabilitation.isHabilitate(sUseCaseIdModify)){
		%>
		aDonnees.push(new Array('ajouterFils_'+this.sIdChamp, 
						'<img src=\''+sRootPath+'images/treeview/addnode.png\'>',
						MESSAGE_TV_ADMIN[2]
						));
		<%
		}
		if(sessionUserHabilitation.isHabilitate(sUseCaseIdModify)){
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
		if( sessionUserHabilitation.isHabilitate(sUseCaseIdModify)){
		%>
				aDonnees.push(new Array('ajouterFrere_'+this.sIdChamp, 
						'<img src=\''+sRootPath+'images/treeview/addbrother.png\'>',
						MESSAGE_TV_ADMIN[4]
						));
		<%
		}
		if( sessionUserHabilitation.isHabilitate(sUseCaseIdModify)){
		%>
		
			aDonnees.push(new Array('supprimerNoeud_'+this.sIdChamp, 
									'<img src=\''+sRootPath+'images/treeview/delnode.png\'>',
									MESSAGE_TV_ADMIN[5]
									));
		<%
		}
		%>
		
		<%
		if(sessionUserHabilitation.isHabilitate(sUseCaseIdModify)){
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
	switch(t[0]){
		case "ajouterFils":
				location.href = "modifyOrganisationGroup.jsp"+sSessionId+"?lIdOrganisationGroup="+sIdNoeud+"&iAddType=1&sAction=create&iIdRootNode="+rootNode;
				break;
		case "afficherInformations":
				location.href = "modifyOrganisationGroupForm.jsp"+sSessionId+"?lIdOrganisationGroup="+sIdNoeud+"&iIdRootNode="+rootNode+"#ancreHP";
				break;
		case "ajouterFrere":
				location.href = "modifyOrganisationGroup.jsp"+sSessionId+"?lIdOrganisationGroup="+sIdNoeud+"&iAddType=2&sAction=create&iIdRootNode="+rootNode;
				break;
		case "supprimerNoeud":
			    if(confirm(MESSAGE_TV_ADMIN[10].replace("%1", "Organization Group")) ){
			         OrganisationGroup.removeFromId(sIdNoeud,rootNode,function() { 
			            location.href = '<%= response.encodeURL("displayAllOrganisationGroup.jsp") %>';
			           });
			     }
				break;
		case "decalerHaut":
			location.href = "modifyOrganisationGroup.jsp"+sSessionId+"?sAction=up&lIdOrganisationGroup="+sIdNoeud+"&iIdRootNode="+rootNode;
			break;
		case "decalerBas":
			location.href = "modifyOrganisationGroup.jsp"+sSessionId+"?sAction=down&lIdOrganisationGroup="+sIdNoeud+"&iIdRootNode="+rootNode;
			break;
		case "decalerGauche":
			location.href = "modifyOrganisationGroup.jsp"+sSessionId+"?sAction=left&lIdOrganisationGroup="+sIdNoeud+"&iIdRootNode="+rootNode;
			break;
		case "decalerDroite":
			location.href = "modifyOrganisationGroup.jsp"+sSessionId+"?sAction=right&lIdOrganisationGroup="+sIdNoeud+"&iIdRootNode="+rootNode;
			break;
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
	        /*
	        if(action != "show" || (action == "show" && levelOpened<=levelToOpen)){
	           openBranch(item.id,action);
	        }
	        */
	        if( actionChild && (action != "show" || (action == "show" && levelOpened<=levelToOpen)) ){
               openBranch(item.id,action);
            }
	    });
	 }else{
	   disableOnClick = false;
	 }
	 levelOpened = 0;
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
<%@ include file="../../../../../include/new_style/headerFiche.jspf" %>
<div id="fiche">
<%
OrganisationGroup og = new OrganisationGroup();
Vector<TreeviewNode> vItemList = og.getAll();
vItemList = TreeviewParsing.getTreeviewNodeList(ROOT,vItemList);

for (int i=0; i < vItemList.size(); i++)
{
	OrganisationGroup node = (OrganisationGroup ) vItemList.get(i);
    
	Vector<OrganisationGroupItem> vBU = OrganisationGroupItem.getAllFromIdOrganisationGroup(node.getId());
	Vector<OrganisationGroupPersonnePhysique> vHQ = OrganisationGroupPersonnePhysique.getAllFromIdOrganisationGroup(node.getId());
	
	boolean bHasChild = (node.hasChild()||vBU.size()>0||vHQ.size()>0);
	int j;
    %>  
	<table cellspacing="0" 
	class="<%= (node.iDepth==0)?"caption_root":"caption level"+(node.iDepth)%> <%= "node_"+node.lIdTreeviewNodeParent %>"
	style="<%= (node.iDepth==0)?"":"display:none;" %>width:100%;<%= (node.iDepth==0)?"background-color:#F3F3F3":""%>"
	id="<%= node.getId() %>"
	onclick="openBranch(<%= node.getId() %>)">
       <tr class="" style="cursor:pointer">

            <td style="width:30%;vertical-align:middle;font-weight:bold">
                <div style="padding-left:<%= ((node.iDepth)*15) %>px;">
                <div class="<%=bHasChild?"menuClose":"" %>"
                     style="<%= bHasChild?"":"padding-left:15px;" %>">
                <%= node.getName() %>
                </div>
                </div>
            </td>
            <td style="width:30%;vertical-align:middle;">
                <%= node.getDescription() %>
            </td>
            
            <td style="width:1%;vertical-align:middle">
            <%
            if(bShowOptions)
            {
            %>
            <td style="width:1%;vertical-align:middle">
                <button type="button" name="but_<%= node.getId() %>" id="but_<%= node.getId() %>" 
                    onclick="openTreeviewOption('<%= node.getId() %>','<%= ROOT %>')" >Options</button>
            
            <% } %>
            </td>
        </tr>
    </table>
    <%
    if(vBU.size()>0){
    %>
    <table cellspacing="0" 
    class="caption level<%=(node.iDepth)%> <%= "node_"+node.getId() %>"
    style="display:none;width:100%"
    id="bu_<%= node.getId() %>"
    onclick="openBranch('bu_<%= node.getId() %>')">
       <tr class="" style="cursor:pointer">
            <td style="width:30%;vertical-align:middle;font-weight:bold">
                <div style="padding-left:<%= ((node.iDepth+1)*15) %>px;">
                <div class="menuClose">
                Business Unit
                </div>
                </div>
            </td>
        </tr>
    </table>
    <%
    for(OrganisationGroupItem bu : vBU){
    	Organisation org = null;
    	try{
	    	org = Organisation.getOrganisation(bu.getIdOrganisation());
	    	Vector<OrganisationDepot> vDepots = OrganisationDepot.getAllFromIdOrganisation(org.getId());
	    	boolean bHasDepot = vDepots.size()>0;
	    	%>
	    	<table cellspacing="0" 
		    class="caption level<%=(node.iDepth)%> <%= "node_bu_"+node.getId() %>"
		    style="display:none;width:100%"
		    id="bu_item_<%= bu.getId() %>"
		    onclick="openBranch('bu_item_<%= bu.getId() %>')">
		       <tr class="" style="cursor:pointer">
		            <td style="width:30%;vertical-align:middle;font-weight:bold">
		                <div style="padding-left:<%= ((node.iDepth+(bHasDepot?2:1))*15) %>px;">
		                <div class="<%=bHasDepot?"menuClose":"" %>"
	                     style="<%= bHasDepot?"":"padding-left:15px;" %>vertical-align:middle;">
		                <%= org.getRaisonSociale() %>
		                </div>
		                </div>
		            </td>
		            <td style="width:1%">
		               <a onclick="parent.addParentTabForced('Business Unit','<%= response.encodeURL(rootPath + "desk/organisation/afficherOrganisation.jsp?iIdOrganisation="+org.getId() ) %>')" href="javascript:void(0)">
	                    <img src="<%= rootPath + Icone.ICONE_FICHIER_DEFAULT_NEW_STYLE %>" alt="see" title="see" />
	                    </a>
		            </td>
		        </tr>
		    </table>
	    	<%
	    	for(OrganisationDepot depot : vDepots){
	            %>
	            <table cellspacing="0" 
	            class="caption level<%=(node.iDepth)%> <%= "node_bu_item_"+bu.getId() %>"
	            style="display:none;width:100%"
	            id="bu_depot_item_<%= depot.getId() %>"
	            onclick="">
	               <tr class="" style="cursor:pointer">
	                    <td style="width:30%;vertical-align:middle;font-weight:bold">
	                        <div style="padding-left:<%= ((node.iDepth+2)*15) %>px;">
	                        <div style="padding-left:15px;">
	                        <%= depot.getName() %>
	                        </div>
	                        </div>
	                    </td>
	                </tr>
	            </table>
	            <%
	        }
	    }
    	catch(CoinDatabaseLoadException e){
	    	if(org == null){
	    		/* 
		    	 * le OrganisationGroupItem de l'organisation n'a pas été correctement supprimé 
		    	 * on le supprime pour remettre au propre
		    	 */
		    	System.out.println("OrganisationGroupItem.remove("+bu.getId()+");");
	    		bu.remove();
	    	}
    	}
    }
    %>
    <%
    }
    %>
    <%
    if(vHQ.size()>0){
    %>
    <table cellspacing="0" 
    class="caption level<%=(node.iDepth)%> <%= "node_"+node.getId() %>"
    style="display:none;width:100%"
    id="hq_<%= node.getId() %>"
    onclick="openBranch('hq_<%= node.getId() %>')">
       <tr class="" style="cursor:pointer">
            <td style="width:30%;vertical-align:middle;font-weight:bold">
                <div style="padding-left:<%= ((node.iDepth+1)*15) %>px;">
                <div class="menuClose">
                HQ Collaborator
                </div>
                </div>
            </td>
        </tr>
    </table>
    <%
    for(OrganisationGroupPersonnePhysique ppItem : vHQ){
    	PersonnePhysique pp = null;
    	try{
	    	pp = PersonnePhysique.getPersonnePhysique(ppItem.getIdPersonnePhysique());
	        %>
	        <table cellspacing="0" 
	        class="caption level<%=(node.iDepth)%> <%= "node_hq_"+node.getId() %>"
	        style="display:none;width:100%"
	        id="hq_item_<%= ppItem.getId() %>"
	        onclick="">
	           <tr class="" style="cursor:pointer">
	    
	                <td style="width:30%;vertical-align:middle;font-weight:bold">
	                    <div style="padding-left:<%= ((node.iDepth+1)*15) %>px;">
	                    <div style="padding-left:15px;">
	                    <%= pp.getPrenomNom() %>
	                    </div>
	                    </div>
	                </td>
	                <td style="width:1%">
	                   <a onclick="parent.addParentTabForced('<%= sessionUser.getIdIndividualLabel() %>','<%= response.encodeURL(rootPath + "desk/organisation/afficherPersonnePhysique.jsp?iIdPersonnePhysique="+pp.getId() ) %>')" href="javascript:void(0)">
	                    <img src="<%= rootPath + Icone.ICONE_FICHIER_DEFAULT_NEW_STYLE %>" alt="see" title="see" />
	                    </a>
	                </td>
	            </tr>
	        </table>
	        <%
	    }
    	catch(CoinDatabaseLoadException e){
	    	if(pp == null){
	    		/* 
		    	 * le OrganisationGroupPersonnePhysique de la personne n'a pas été correctement supprimé 
		    	 * on le supprime pour remettre au propre
		    	 */
		    	System.out.println("OrganisationGroupPersonnePhysique.remove("+ppItem.getId()+");");
	    		ppItem.remove();
	    	}
    	}
    }
    %>
    <%
    }
    %>
<%
} 
%>
</div> 
<%@ include file="../../../../../include/new_style/footerFiche.jspf" %>
</body>

<%@page import="mt.veolia.vfr.vehicle.component.VehicleComponentType"%>
<%@page import="org.coin.bean.conf.TreeviewNode"%>
<%@page import="mt.veolia.vfr.vehicle.component.VehicleComponentTypeRoot"%>
<%@page import="org.coin.fr.bean.Organisation"%>
<%@page import="org.coin.fr.bean.OrganisationGroup"%>
<%@page import="org.coin.fr.bean.OrganisationGroupItem"%>
<%@page import="org.coin.fr.bean.OrganisationGroupPersonnePhysique"%>
<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%@page import="org.coin.fr.bean.OrganisationDepot"%>

<%@page import="org.coin.db.CoinDatabaseLoadException"%></html>