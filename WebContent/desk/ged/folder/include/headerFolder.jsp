<%@page import="org.coin.bean.ged.GedFolderState"%>
<%@page import="org.coin.util.CalendarUtil"%>
<%@page import="org.coin.ui.Border"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.bean.organigram.Organigram"%>
<%@page import="org.coin.bean.organigram.OrganigramNode"%>
<%@page import="org.coin.fr.bean.OrganisationService"%>
<%@page import="java.util.Vector"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="org.coin.bean.ged.GedFolderEntity"%>
<%@page import="org.coin.bean.ged.GedDocumentEntityType"%>
<%@page import="org.coin.bean.organigram.OrganigramNodeType"%>
<%@page import="org.coin.db.AbstractBeanArray"%>
<%@page import="org.coin.db.CoinDatabaseAbstractBean"%>
<%@page import="org.coin.bean.organigram.OrganigramNodeState"%>
<%@page import="org.coin.util.HTMLEntities"%>
<%@page import="org.coin.bean.ged.GedFolder"%>
<%@page import="org.coin.localization.LocalizationConstant"%>
<%@page import="org.coin.localization.Localize"%>
<%@page import="org.coin.localization.LocalizeButton"%>
<%@page import="org.coin.db.CoinDatabaseLoadException"%>
<%@ include file="/include/new_style/beanSessionUser.jspf" %>
<%
	Border bordFolder = new Border("eeeeee", 5, 100, "tblr", request);

	String rootPath = (String) request.getAttribute("rootPath");
	GedFolder folder = (GedFolder) request.getAttribute("folder");
	Localize locTitle = (Localize)request.getAttribute("locTitle");
	Localize locButton = (Localize)request.getAttribute("locButton");
	Localize locMessage = (Localize)request.getAttribute("locMessage");
	LocalizeButton localizeButton = (LocalizeButton) request.getAttribute("localizeButton");
%>



<%@page import="org.coin.util.Outils"%><div style="margin:5px;">
<script type="text/javascript">
var g_sFolderName = "<%= HTMLEntities.unhtmlentities(folder.getName()) %>";
var g_lIdGedFolder = <%= folder.getId() %>;
var g_bIsParent = <%= (folder.getIdGedFolderParent()==0) %>;
var g_sURLModifyFolder = "<%= response.encodeURL(rootPath+"desk/ged/folder/modifyFolderForm.jsp?")  %>";
var g_sURLDisplayFolder = "<%= response.encodeURL(rootPath+"desk/ged/folder/displayFolder.jsp?")  %>";
function toggleService(){
	var elm = $('divService');
	if (elm.style.display == 'none') {
		elm.style.display = 'block';
		$('serviceTitleOn').style.display = 'block';
		$('serviceTitleOff').style.display = 'none';				
	} else {
		elm.style.display = 'none';
		$('serviceTitleOn').style.display = 'none';
		$('serviceTitleOff').style.display = 'block';
	}
}
function populateRenameFolder(){
	$("folderName").innerHTML = "";
	$("folderName").style.cursor = "pointer";
	var spanName = new Element("span",{"id":"folderNameLabel","style":"font-size:14px;padding:3px;"}).update(g_sFolderName);
	var spanRen = new Element("span",{"id":"folderNameRen","style":"font-size:10px;margin-left:5px;color:#CCCCCC;"}).update("(<%=locTitle.getValue (19, "Renommer")%>)");
	$("folderName").appendChild(spanName);
	$("folderName").appendChild(spanRen);
	
	var input = new Element("input", {"name":"sNewNameFolder","id":"sNewNameFolder","type":"text","maxlength":"250","value":g_sFolderName,"style":"display:none;"});
	var buttRen = new Element("button",{"id":"buttName","style":"display:none;"}).update("Ok");
	var imgCloseRen = new Element("img", {"id":"imgCloseRen","src":rootPath+"images/icons/close_btn.gif","alt":"Annuler","title":"Annuler","style":"margin:6px 0 0 3px;display:none;"});
	$("folderName").appendChild(input);
	$("folderName").appendChild(buttRen);
	$("folderName").appendChild(imgCloseRen)
	
	$("imgCloseRen").onclick = function(){
		Element.hide("sNewNameFolder");
		Element.hide("buttName");
		Element.hide("imgCloseRen");
		Element.show("folderNameLabel");
		Element.show("folderNameRen");
	}
	//input.onkeyup
	$("buttName").onclick = function(){
		var sNewName = $("sNewNameFolder").value.trim();
		if (sNewName.length>0 && sNewName!=g_sFolderName){
			if (confirm("<%=locMessage.getValue (8, "Renommer le classeur")%> \""+g_sFolderName+"\"\n<%=locMessage.getValue (9, "par")%> \""+sNewName+"\" ?")){
				Element.hide("sNewNameFolder");
				Element.hide("buttName");
				Element.show("folderNameLabel");
				$("folderNameLabel").innerHTML = "<%=locMessage.getValue (3, "Chargement...")%>";
				var obj = {};
				obj.lId = g_lIdGedFolder;
				obj.sName = sNewName;
				GedFolder.storeFromJSONString(Object.toJSON(obj), function(lId){
					if (lId>0) {
						// Refreshing list of folders
						if (g_bIsParent){
							try{parent.engineGED.run(true);
							}catch(e){};
						}	
						g_sFolderName = sNewName;
						populateRenameFolder();
					} else {
						alert("<%=locMessage.getValue (1, "un problème est survenu lors de l'enregistrement")%>");
					}
				});
			}else{
				populateRenameFolder();
			} 
		}else{
			populateRenameFolder();
		}
	}
	$("folderName").onmouseover = function(){
		spanRen.style.color = "#000000";
		spanName.style.backgroundColor = "#FFFFFF";
	}
	$("folderName").onmouseout = function(){
		spanRen.style.color = "#CCCCCC";
		spanName.style.backgroundColor = "transparent";
	}
	$("folderNameLabel").onclick = $("folderNameRen").onclick = function(){
		$("sNewNameFolder").value = g_sFolderName;
		Element.show("sNewNameFolder");
		Element.show("buttName");
		Element.show("imgCloseRen");
		Element.hide("folderNameLabel");
		Element.hide("folderNameRen");
		$("sNewNameFolder").focus();
	}	
}
Event.observe(window, 'load', function(){
	if (!g_bIsClosed) populateRenameFolder();
	else{
		$("folderName").innerHTML = "";
		var spanName = new Element("span",{"id":"folderNameLabel","style":"font-size:14px;padding:3px;"}).update(g_sFolderName);
		$("folderName").appendChild(spanName);
	}
	$("ButtonManageUserRights").onclick = function(){
		var mod = parent.mt.utils.displayModal({
			type:"iframe",
			url:"<%= response.encodeURL(rootPath
					+ "desk/paraph/ged/gedFolderEntity.jsp?lId="+folder.getId())%>",
			title:"<%=locTitle.getValue (22, "Gérer les droits")%>",
			width:600,
			height:450,
			color:"8A6D7C",
			opacity:70,
			titleColor:"fff",
			options:{
				afterClose:function(){
					parent.engineGED.run(true);
				}
			}
		});
		mod.open();
	}
	$("ButEditFolder").onclick=function(){
		if (!g_bIsClosed){
			g_modal = parent.mt.utils.displayModal({
				type:"iframe",
				url:g_sURLModifyFolder+"sAction=modify&bModalMode=true&lId="+g_lIdGedFolder,
				title:"<%=locTitle.getValue (39, "Modifier le document")%> : "+g_sFolderName,
				width:800,
				height:450,
				color:"8A6D7C",
				opacity:70,
				titleColor:"fff",
				options:{
					afterClose:function(){
						openGlobalLoader();
						//Element.hide("tableHeaderDocument");
						//Element.show("divLoadingHeaderDocument");
						if (g_lIdGedParent==0) refreshEngineGED();
						self.location.href = g_sURLDisplayFolder+"lId="+g_lIdGedFolder;
						closeGlobalLoader();
					}
				}
			});
		}else{
			if (confirm("<%=locMessage.getValue (39, "Ce classeur est cloturé, vous ne pouvez pas le modifier.\\nSouhaitez-vous l'ouvrir afin de pouvoir le modifier ?")%>")){
				$("ButEditFolder").innerHTML = "<%=locMessage.getValue (3, "Chargement...")%>";
				var obj = {};
				obj.lId = g_lIdGedFolder;
				obj.lIdGedFolderState = g_lIdGedFolderStateInProcess;
				obj.tsDateClotured = "";
				GedFolder.storeFromJSONString(Object.toJSON(obj), function(lId){
					if (lId>0) {
						// Refreshing list of folders
						if (g_bIsParent) refreshEngineGED();	
					} else {
						alert("<%=locMessage.getValue (1, "un problème est survenu lors de l'enregistrement")%>");
					}
					self.location.href = g_sURLDisplayFolder+"lId="+g_lIdGedFolder;
				});
			}
		}
	}
	$("ButDeleteFolder").onclick=function(){
		if (confirm("<%=locMessage.getValue (15, "Supprimer le classeur")%> \""+g_sFolderName+"\" <%=locMessage.getValue (16, "et tout ce qu'il contient ?")%>")){
			if(confirm("<%=locMessage.getValue (17, "Attention, ce classeur ainsi que tous ses documents et sous-classeurs seront effacés")%>.\n\n<%=locMessage.getValue (18, "Continuez l'opération ?")%>")){
				openGlobalLoader();
		         GedFolder.removeFromIdJSON(lIdGedFolder, function(bSuccess){
		         	closeGlobalLoader();
					if (bSuccess) {
						alert("<%=locMessage.getValue (19, "Le classeur a été correctement supprimé.")%>");
						if (g_lIdGedParent>0){
							location.href = '<%= response.encodeURL("displayFolder.jsp?lId="+folder.getIdGedFolderParent()) %>';
						}else{
							refreshEngineGED();
							try{parent.mt.html.removeTab("GedFolderTableLayout_"+lIdGedFolder, true);
							}catch(e){};
						}
					} else {
						alert("<%=locMessage.getValue (7, "un problème est survenu lors de la suppression")%>");
					}
				});
			}
		}
	}
})

</script>

<%=bordFolder.getHTMLTop() %>
	<table style="width: 100%">
		<tr>
			<td colspan="2">
			<%
	
		long lIdGedFolderParent = folder.getIdGedFolderParent();
		String sImgFolder = rootPath+"images/icons/24x24/folder_closed_purple.png";
		Vector<GedFolder> vFolderParent = new Vector<GedFolder>();
		while(lIdGedFolderParent>0){
			GedFolder foldParent = null;
			try{foldParent = GedFolder.getGedFolder(lIdGedFolderParent);		
			}catch(Exception e){}
			if (foldParent!=null){
				lIdGedFolderParent = foldParent.getIdGedFolderParent();
				vFolderParent.add(foldParent);
			}
		}
		int j=0;
		for (int i=vFolderParent.size()-1;i>=0;i--){
			%>
			<div style="margin-left:<%=(j*5) %>px;">
				<a href="<%= response.encodeURL("displayFolder.jsp?lId="+vFolderParent.get(i).getId()) %>">
				..<img alt="" src="<%= sImgFolder %>" />
				<%=vFolderParent.get(i).getName() %>
				</a>
			</div>
			<%
			j++;
		}
	%>
			</td>
			<td style="text-align: right;width: 14%;vertical-align: top;">
				<button type="button" id="ButEditFolder" class="ContextButton" style="">
			    <%=localizeButton.getValueModify() %>
			    <img src="<%= rootPath %>images/icons/16x16/folder_purple_edit.png" alt="" />
			    </button>
				<button type="button" id="ButDeleteFolder" class="ContextButton" style="">
			    <%=localizeButton.getValueDelete() %>
			    <img src="<%= rootPath %>images/icons/16x16/folder_purple_del.png" alt="" />
			    </button>
			</td>
		</tr>
		<tr>
			<td style="vertical-align: middle;">
				<img src="<%= rootPath %>images/icons/64x64/folder_full_purple.png" alt="" style="padding: 2px; display: block; margin-right: auto; margin-left: auto;"/>
			</td>
			<td style="vertical-align: middle;">
				<div id="folderName" style="">
					<span style="font-size:14px;padding:3px;"><%=folder.getName() %></span>
					<span style="margin-left:5px;color:#CCCCCC;"><img src="<%=rootPath %>images/loading/ajax-loader.gif" alt="Loading" /></span>
				</div>
			</td>
			<td style="vertical-align: middle;padding-top: 20px;width: 40%;"><%
			if (folder.getDescription()!=null && !folder.getDescription().equals("")){
				%><div style="width:540px;max-height:90px;overflow: auto;margin:0 0 0 auto;padding:5px;border:1px #cdc0c7 dotted;">
				<%= HTMLEntities.unhtmlentitiesComplete(folder.getDescription()) %>
				</div>
				<%
			}else{
				out.print("&nbsp;");
			}
			%></td>
		</tr>
		<tr>
			<td style="width:10%">&nbsp;</td>
			<td colspan="3">

			<%
			GedFolderState gedFolderState = null;
			
			try{
				gedFolderState = GedFolderState.getGedFolderState (folder.getIdGedFolderState());
			} catch(CoinDatabaseLoadException e){
				gedFolderState = GedFolderState.getGedFolderState (GedFolderState.STATE_IN_PROCESS);
			}
			gedFolderState.setAbstractBeanLocalization(sessionLanguage);
			
			GedFolderState gedFolderStateInProcess = new GedFolderState (GedFolderState.STATE_IN_PROCESS);
			GedFolderState gedFolderStateClosed = new GedFolderState (GedFolderState.STATE_CLOSED);
			gedFolderStateInProcess.setAbstractBeanLocalization(sessionLanguage);
			gedFolderStateClosed.setAbstractBeanLocalization(sessionLanguage);
			
			// String sState = "En cours";
			String sState = gedFolderStateInProcess.getName();
			String sImage = rootPath+"images/icons/default.gif";
			if (folder.getIdGedFolderState()==GedFolderState.STATE_CLOSED){
				// sState = "Cloturé";
				sState = gedFolderStateClosed.getName ();
				if (!CalendarUtil.getDateCourte(folder.getDateClotured(), "").equals("")){
					sState += " " + locTitle.getValue(74, "le") + " " + CalendarUtil.getDateCourte(folder.getDateClotured(), "");
				}
				sImage = rootPath+"images/icons/lock.gif";
			}
			
			try {
				%>
				<%=folder.getIdGedFolderStateLabel ()%> : <label><%= sState.toLowerCase() %></label>
				<!-- <img alt="<%= sState %>" title="<%= sState %>" src="<%= sImage %>" style="padding: 2px;"/> -->
				<br />
				<%
			} catch (Exception e) {
				%><%= e.getMessage() %><%
			}
			
			
			Timestamp tsDateCreation = folder.getDateCreation();
			String sDate = CalendarUtil.getDateCourteFormattee(tsDateCreation, "", (int) sessionLanguage.getId ()).toLowerCase();
			if (!sDate.equals("")) out.print(locTitle.getValue (20, "Créé le") + " " + sDate + "<br />");
			String sOwner = "";
			Vector<GedFolderEntity> vFolderEntity = new Vector<GedFolderEntity>();
			try{vFolderEntity = GedFolderEntity.getAllFromIdGedFolder(folder.getId());
			}catch(Exception e){}
			PersonnePhysique ppOwner = null;
			for (int i=0;i<vFolderEntity.size();i++){
				GedFolderEntity gfe = vFolderEntity.get(i); 
				if (gfe.getIdGedDocumentEntityType()==GedDocumentEntityType.TYPE_WRITER
					&& gfe.getIdTypeObject()==ObjectType.PERSONNE_PHYSIQUE){
					try{ppOwner=PersonnePhysique.getPersonnePhysique(gfe.getIdReferenceObject());
					}catch(Exception e){}
					if (ppOwner!=null){
						sOwner += folder.getIdReferenceObjectOwnerLabel () + " : " + ppOwner.getPrenomNom () + " ";
					}
				}
			}
			out.print(sOwner);
			
			String sService = "";
			String sServiceName = "";
			if (folder.getIdTypeObjectOwner()==ObjectType.ORGANISATION_SERVICE){
				OrganisationService orgService = null;
				try{orgService = OrganisationService.getOrganisationService(folder.getIdReferenceObjectOwner());
				}catch(Exception e){}
				if (orgService!=null){
					orgService.setAbstractBeanLocalization (sessionLanguage);
					sServiceName = orgService.getName();
					out.print("("+locTitle.getValue (21, "Service")+" : "+ sServiceName+")");
					// PART ON STAND BY
					if (false){
					Vector vNode = new Vector();
					Vector<Organigram> vOrganigram = Organigram.getAllFromObject(ObjectType.ORGANISATION_SERVICE, orgService.getId());
					if(vOrganigram.size()>=1){
						vNode =  OrganigramNode.getAllFromIdOrganigram(vOrganigram.firstElement().getId());
						Vector<PersonnePhysique> vPersonne = PersonnePhysique.getAllFromIdOrganisation( (int) orgService.getIdOrganisation());
						Vector<OrganigramNodeType> vPoste = OrganigramNodeType.getAllStatic();
						
						for (OrganigramNodeType organigramNodeType : vPoste)
							organigramNodeType.setAbstractBeanLocalization(sessionLanguage);
						for (PersonnePhysique personnePhysique : vPersonne)
							personnePhysique.setAbstractBeanLocalization(sessionLanguage);
						
						OrganigramNode.computeName(vNode, vPersonne, vPoste);
						/*
						for (int i=0;i<vPersonne.size();i++){
							sService += vPersonne.get(i).getPrenomNom()+" ";
						}*/
						AbstractBeanArray aba = OrganigramNode.generateAbstractBeanArray(vNode);
						aba.addUnplacedBean(vNode);
						int iL = -1;
						sService += "<table class=\"dataGrid fullWidth\" style=\"border-color:#8A6D7C;margin-top:4px;\">"
								+	"<tr class=\"header\" style=\"background-color:#8A6D7C;color:#FFFFFF;\">"
								+	"<td style=\"color:#FFFFFF;\">" + locTitle.getValue (23, "Droits") + " : </td>"
								+	"<td style=\"color:#FFFFFF;\">" + locTitle.getValue (24, "Lecture") + "</td>"
								+	"<td style=\"color:#FFFFFF;\">" + locTitle.getValue (25, "Modification") + "</td>"
								+	"<td style=\"color:#FFFFFF;\">" + locTitle.getValue (26, "Suppression") + "</td>"
								+	"</tr>";
						boolean bReading = false;
						boolean bEditing = false;
						boolean bDeleting = false;
						String sAuthorized = locTitle.getValue (28, "Autorisé");
						String sDenied = locTitle.getValue (29, "Refusé");
						String sImgAuthorised = "<img src=\""+rootPath+"images/icons/accept.gif\" alt=\"" + sAuthorized + "\" title=\"" + sAuthorized + "\"/>";
						String sImgDenied = "<img src=\""+rootPath+"images/icons/icon_remove.png\" alt=\"" + sDenied + "\" title=\""+ sDenied + "\"/>";
						for (int i =0; i <= aba.iMaxRow; i++){
							for (j =0; j <= aba.iMaxColumn ; j++){
								OrganigramNode os = (OrganigramNode) aba.table[i][j] ;
				                if(os != null){
				                	String sStyleSpan = "padding-left:"+(j*6)+"px;";
				                	if (os.getIdOrganigramNodeState()==OrganigramNodeState.STATE_ACTIVATED){
				                		if ((j==0) ||
				                			(os.getIdTypeObject()==ObjectType.PERSONNE_PHYSIQUE
				                			&& ppOwner!=null
				                			&& os.getIdReferenceObject()==ppOwner.getId())){
				                					             
				                			bReading = bEditing = bDeleting = true;
				                		
				                			sService += "<tr><td>";					                						                	
					                		sService += "<span style=\""+sStyleSpan+"\">"+os.getName()+"</span></td>";
					                		sService += "<td style=\"text-align:center;\">"+(bReading?sImgAuthorised:sImgDenied)+"</td>";
					                		sService += "<td style=\"text-align:center;\">"+(bEditing?sImgAuthorised:sImgDenied)+"</td>";
					                		sService += "<td style=\"text-align:center;\">"+(bDeleting?sImgAuthorised:sImgDenied)+"</td>";
					                		sService += "</tr>";
				                		}
				                	}
				                }
							}
						}
						if (aba.iMaxRow>0){
							sService += "<tr><td>";					                						                	
	                		sService += "<span style=\"\">" + locTitle.getValue (27, "Autres utilisateurs du service") + "</span></td>";
	                		sService += "<td style=\"text-align:center;\">"+sImgAuthorised+"</td>";
	                		sService += "<td style=\"text-align:center;\">"+sImgDenied+"</td>";
	                		sService += "<td style=\"text-align:center;\">"+sImgDenied+"</td>";
	                		sService += "</tr>";
						}
						sService += "</table>";
					}
					
				}
				}
			}
			Border bordServiceTitleOn = new Border("ffffff", 5, 100, "tlr", request);
			bordServiceTitleOn.setStyle("width:auto");
			
			Border bordServiceTitleOff = new Border("ffffff", 5, request);
			bordServiceTitleOff.setStyle("width:auto;margin-right:10px");
			
			Border bordServiceDiv = new Border("ffffff", 5, 100, "blr", request);
			bordServiceDiv.setStyle("width:auto;");
			%>
		<div id="serviceTitleOn" style="margin-top:2px;cursor:pointer;display:none;" onclick="toggleService()">
			<%=bordServiceTitleOn.getHTMLTop() %>
			<div style="font-weight:bold;padding:0 24px 4px 4px;background:url(<%=rootPath%>images/icons/up_arrow_blue.png) right -2px no-repeat"><%=locTitle.getValue (21, "Service") %> : <%= sServiceName%></div>
			<%=bordServiceTitleOn.getHTMLBottom() %>
		</div>
		<div id="divService" style="display:none;">
		<%=bordServiceDiv.getHTMLTop() %>
		<div style="padding:5px;"><%= sService %></div>
		<button style="padding:5px;" class="ContextButton" id="ButtonManageUserRights"><%=locButton.getValue (13, "Gérer des droits pour ce classeur")%></button>
		<%=bordServiceDiv.getHTMLBottom() %>
		</div>
		<div id="serviceTitleOff" style="margin-top:2px;cursor:pointer;" onclick="toggleService()">
			<%=bordServiceTitleOff.getHTMLTop() %>
			<div style="font-weight:bold;padding:0 24px 0 4px;background:url(<%=rootPath%>images/icons/down_arrow_blue.png) right -1px no-repeat"><%=locTitle.getValue (21, "Service")%> : <%= sServiceName%></div>
			<%=bordServiceTitleOff.getHTMLBottom() %>	
		</div>
		</tr>
	</table>
<%=bordFolder.getHTMLBottom() %>
</div>