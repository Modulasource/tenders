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
<%@page import="org.coin.bean.ged.GedDocumentContentType"%>
<%@page import="org.coin.bean.ged.GedCategorySelection"%>
<%@page import="org.coin.bean.ged.GedCategory"%>
<%@page import="org.coin.localization.Localize"%>
<%@page import="org.coin.localization.LocalizeButton"%>
<%@page import="org.coin.bean.ged.GedDocument"%>
<%@page import="org.coin.bean.ged.GedFolder"%>
<%@ include file="/include/new_style/beanSessionUser.jspf" %>
<%
	Boolean bParaphView = HttpUtil.parseBoolean("bParaphView", request, false);
	String rootPath = (String) request.getAttribute("rootPath");
	GedFolder folder = (GedFolder) request.getAttribute("folder");
	Localize locTitle = (Localize)request.getAttribute("locTitle");
	Localize locButton = (Localize)request.getAttribute("locButton");
	Localize locMessage = (Localize)request.getAttribute("locMessage");
	LocalizeButton localizeButton = (LocalizeButton) request.getAttribute("localizeButton");
	GedDocument doc = (GedDocument) request.getAttribute("doc");
	String sURLDocument = (String) request.getAttribute("sURLDocument");
	
	GedDocumentContentType gedContentType = null;
	String sContentType = "?";
	try{
		gedContentType = GedDocumentContentType.getGedDocumentContentType(doc.getIdGedDocumentContentType());
		gedContentType.setAbstractBeanLocalization(sessionLanguage);
		sContentType = gedContentType.getLabel();
	}catch(Exception e){}
	Border bordFolder = new Border("eeeeee", 5, 100, "tblr", request);

	
	
%>

<%@page import="org.coin.util.HttpUtil"%><div style="margin:5px;">
<script type="text/javascript">
var g_sDocumentName = "<%= HTMLEntities.unhtmlentities(doc.getName()) %>";
var g_lIdGedDocument = <%= doc.getId() %>;
var g_bParaphView = <%= bParaphView %>;

Event.observe(window, 'load', function(){
	if (!g_bParaphView){
		$("ButDeleteDocument").onclick=function(){
		    if(confirm("<%=locMessage.getValue (31, "Souhaitez-vous supprimer ce document ?")%>")){
		    	var obj = {};
		    	try{obj.sList = lIdGedDocument;}catch(e){}
			    GedDocument.removeFromJSONString(Object.toJSON(obj), function(b){
					if (!b){
		           		alert("<%=locMessage.getValue (7, "un problème est survenu lors de la suppression")%>");
			         }else{
			         	alert("<%=locMessage.getValue (20, "Le ou les documents ont correctement été effacé.")%>");
			         }
					location.href = g_sURLDisplayFolder+lIdGedFolder+"&bRefreshEngineGED=true";
			    });
	     	}
		}
	}
})

</script>
<%=bordFolder.getHTMLTop() %>
	<div id="divLoadingHeaderDocument" style="text-align:center;display:none;">
	<img src="<%=rootPath %>images/loading/ajax-loader.gif" alt="Loading" /></div>
	<div id="tableHeaderDocument">
	<% if(!bParaphView){ %>
	<table style="width: 100%">
		<tr>
			<td style="vertical-align: top;" >
			<%
	int j=0;
	String sImgFolder = rootPath+"images/icons/24x24/folder_closed_purple.png";
	String sImgFolderOpened = rootPath+"images/icons/24x24/folder_full_purple.png";
	if (folder.getIdGedFolderParent()>0){
	
		long lIdGedFolderParent = folder.getIdGedFolderParent();
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
		for (int i=vFolderParent.size()-1;i>=0;i--){
			%>
			<div style="margin-left:<%=(j*5) %>px;">
				<a href="<%= response.encodeURL("../folder/displayFolder.jsp?lId="+vFolderParent.get(i).getId()) %>">
				..<img alt="" src="<%= sImgFolder %>" />
				<%=vFolderParent.get(i).getName() %>
				</a>
			</div>
			<%
			j++;
		}
	}
		%>
				<div style="margin-left:<%=(j*5) %>px;">
					<a href="<%= response.encodeURL("../folder/displayFolder.jsp?lId="+folder.getId()) %>">
					..<img alt="" src="<%= sImgFolderOpened %>" />
					<%=folder.getName() %>
					</a>
				</div>
			</td>
			<td style="vertical-align: top;text-align: right;">
				<button type="button" id="ButSendToParaph" style="" class="ContextButton" >
				<img src="<%= rootPath %>images/icons/application_go.gif" alt="" style="vertical-align:middle;"/>
				<%=locButton.getValue (16, "Envoyer dans le parapheur")%></button>
			
				<button type="button" id="ButSendToMail" style="" class="ContextButton" >
				<img src="<%= rootPath %>images/icons/email.gif" alt="" style="vertical-align:middle;"/>
				<%=localizeButton.getValueSendByMail ("Envoyer par mail") %></button>
				<button type="button" id="ButDeleteDocument" class="ContextButton" style="width:90px;">
			    <%=localizeButton.getValueDelete ()%><img src="<%= rootPath %>images/icons/16x16/file_document_del.png" alt="" />
			    </button>
			</td>
		</tr>
		</table>
		<% } %>
		<table style="width: 100%">
		<tr>
			<td style="width:10%">
				<a href="<%= response.encodeURL(rootPath+"desk/GedDocumentDownloadServlet?sRevision=last_revision&dl=false&lId="+doc.getId()) %>" target="blank">
				<img src="<%= sURLDocument+"&tn=true" %>" alt="" style="padding: 2px; display: block; margin-right: auto; margin-left: auto;"/>
				</a>
			</td>
			<td>
				<div id="folderName" style="">
					<div style="font-size:14px;padding:3px;">
						<a href="<%= response.encodeURL(rootPath+"desk/GedDocumentDownloadServlet?sRevision=last_revision&dl=false&lId="+doc.getId()) %>" target="blank">
						<%=(doc.getName().equals("") ? locTitle.getValue (32, "Sans titre") : doc.getName())%>
						</a>
					</div>
					<div style="font-size:11px;padding:3px;"><%
					Vector<GedCategorySelection> vCatSel = new Vector<GedCategorySelection>();
					try{vCatSel = GedCategorySelection.getAllFromTypeAndReferenceObject(ObjectType.GED_DOCUMENT, doc.getId());
					}catch(Exception e){}
					for(int i=0;i<vCatSel.size();i++){
						GedCategory cat = null;
						try{
							cat = GedCategory.getGedCategoryMemory(vCatSel.get(i).getIdGedCategory());
							cat.setAbstractBeanLocalization(sessionLanguage);
						} catch (Exception e){}
						if(cat!=null){
							out.print(cat.getLabelWithParent());
							if (i<vCatSel.size()-1) out.println(", ");
						}
					}
					%></div>
				</div>
			</td>
			<td style="text-align: right;padding-right: 5px;">
			<%= sContentType %>
			</td>
		</tr>
	</table>
	</div>
<%=bordFolder.getHTMLBottom() %>
</div>