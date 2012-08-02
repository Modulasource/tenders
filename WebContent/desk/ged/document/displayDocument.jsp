<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@page import="java.io.File"%>
<%@page import="java.util.*"%>
<%@page import="java.security.cert.X509Certificate"%>
<%@page import="java.security.SignatureException"%>
<%@page import="org.coin.bean.html.*" %>
<%@page import="org.coin.bean.ged.*"%>
<%@page import="org.coin.bean.pki.certificate.signature.*"%>
<%@page import="org.coin.bean.pki.PkiSignatureAlgorithmType"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.db.*"%>
<%@page import="org.coin.fr.bean.*"%>
<%@page import="org.coin.util.*"%>
<%@page import="org.coin.security.CertificateUtil"%>
<% 
	/**
	 * Localization
	 */
	Localize locButton = new Localize (sessionLanguage.getId (), LocalizationConstant.CAPTION_CATEGORY_GEC_PAGE_BUTTON);
	Localize locTitle = new Localize (sessionLanguage.getId (), LocalizationConstant.CAPTION_CATEGORY_GEC_PAGE_TITLE);
	Localize locMessage = new Localize (sessionLanguage.getId (), LocalizationConstant.CAPTION_CATEGORY_GEC_PAGE_MESSAGE);
	Localize locTab = new Localize (sessionLanguage.getId (), LocalizationConstant.CAPTION_CATEGORY_GEC_PAGE_TAB);

	GedDocument doc = null;
    GedDocumentType type = null;
    GedFolder folder = null;
	String sPageUseCaseId = "xxx";
	
	doc = GedDocument.getGedDocument(Integer.parseInt(request.getParameter("lId")));
	folder = GedFolder.getGedFolder(doc.getIdGedFolder());
	try{type = GedDocumentType.getGedDocumentType(doc.getIdGedDocumentType());
	} catch (Exception e) {type = new GedDocumentType(); }
	String sTitle = doc.getName(); 

	boolean bRefreshEngineGED = HttpUtil.parseBoolean("bRefreshEngineGED", request, false);
	String sURLDocument = response.encodeURL(rootPath+"desk/GedDocumentDownloadServlet?sRevision=last_revision"
        		+ "&nonce=" + System.currentTimeMillis()
        		+ "&lId="+doc.getId());
	
	// When a document is displayed from paraph 
	Boolean bParaphView = HttpUtil.parseBoolean("bParaphView", request, false);	
	
	// Display a tab when loading
	String sDisplayTab = HttpUtil.parseString("sDisplayTab", request, "");
	
	request.setAttribute("rootPath",rootPath);
	request.setAttribute("doc",doc);
	request.setAttribute("item",doc);
	request.setAttribute("folder",folder);
	request.setAttribute("locTitle", locTitle);
	request.setAttribute("locButton", locButton);
	request.setAttribute("locMessage", locMessage);
	request.setAttribute("localizeButton", localizeButton);
	request.setAttribute("sURLDocument", sURLDocument);
%>
<link rel="stylesheet" type="text/css" href="<%=rootPath%>include/new_style/desk_custom_paraph.css?v=<%= JavascriptVersion.DESK_CSS %>" media="screen" />
<!--[if IE]> <link href="<%=rootPath%>include/new_style/desk_custom_paraph_ie_only.css?v=<%= JavascriptVersion.DESK_CSS %>" media="screen"  rel="stylesheet" type="text/css"> <![endif]-->
<!--[if gt IE 7]>
<link href="<%=rootPath%>include/new_style/desk_custom_paraph_not_ie.css?v=<%= JavascriptVersion.DESK_CSS %>" media="screen"  rel="stylesheet" type="text/css">
<![endif]-->
<!--[if !IE]> <-->
<link href="<%=rootPath%>include/new_style/desk_custom_paraph_not_ie.css?v=<%= JavascriptVersion.DESK_CSS %>" media="screen"  rel="stylesheet" type="text/css">
<!--> <![endif]-->
<style type="text/css">
<!--
#results th{
    text-align: left;
}
-->
a:ACTIVE, a:link, a:visited{
	text-decoration: none;
	color: #000;
}
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
.tabsFolder .t{
	display:inline-block;
	background-color:#eeeeee;
	text-decoration:none;
	padding:7px 8px 6px 8px;
	cursor:pointer;
	
	-moz-border-radius-topleft:5px;
	-moz-border-radius-topright:5px;
		
	-webkit-border-top-left-radius:5px;
	-webkit-border-top-right-radius:5px;
}
.tabsFolder .selected {
	background-color:#ffffff;
	font-weight:bold;
	padding-bottom:6px;
	color:#000;
}
</style>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/SearchEngine.js"></script>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/GedFolder.js"></script>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/GedDocument.js"></script>
<script type="text/javascript">
var self = this;
var lIdGedFolder = <%= folder.getId() %>;
var lIdGedDocument = <%= doc.getId() %>;
var bRefreshEngineGED = <%= bRefreshEngineGED %>;
var bIsImage = <%= (doc.getIdGedDocumentContentType()==GedDocumentContentType.TYPE_IMAGE_PHOTO) %>;
var g_sURLModifyDocument = "<%= response.encodeURL(rootPath+"desk/ged/document/modifyDocumentForm.jsp?sAction=store&lIdGedFolder="+folder.getId()) %>";
var g_sLinkDisplayDocument = "<%= response.encodeURL(rootPath+"desk/GedDocumentDownloadServlet?sRevision=last_revision") %>";
var g_sURLDisplayFolder = "<%= response.encodeURL(rootPath+"desk/ged/folder/displayFolder.jsp?lId=") %>";
var g_sURLDisplayDocument = "<%= response.encodeURL(rootPath+"desk/ged/document/displayDocument.jsp?lId=")  %>";
var g_bParaphView = <%= bParaphView %>;
mt.config.enableAutoLoading = false;
var rootPath = "<%= rootPath %>";
var jsonDisplay = [{"sLabel":"Affichage détaillé","sId":"detail"},{"sLabel":"Affichage en miniature","sId":"miniature"}];
var engine = new mt.component.SearchEngine();
var engineSubFolder = new mt.component.SearchEngine();
var g_sLoadTab = "<%= sDisplayTab %>";
var g_modal;

var g_arrTabList = ["document","revision","annotation","sign"];

function hideTabs(){
	for (var i=0;i<g_arrTabList.length;i++){
		Element.hide(g_arrTabList[i]+"TabContent");
	}

	$$('.tabsFolder .t').each(function(item){
		Element.removeClassName(item, "selected");
	});
}
function displayDocument(){
	if (bIsImage){	
		$("IfDisplay").src = g_sLinkDisplayDocument+"&dl=false&lId="+lIdGedDocument; 
		Element.show("IfDisplay");
	}else{
		window.open(g_sLinkDisplayDocument+"&dl=false&lId="+lIdGedDocument);
	}
}

function populate(){
	for (var i=0;i<g_arrTabList.length;i++){
		var s = g_arrTabList[i];
		$(g_arrTabList[i]+"_tab").sTabIndex = g_arrTabList[i];
		$(g_arrTabList[i]+"_tab").onclick=function(){
			hideTabs();
			Element.addClassName($(this.sTabIndex+'_tab'), "selected");
			Element.show(this.sTabIndex+"TabContent");
		};
	}
	if (!g_bParaphView){
		$("ButModifyDocument").onclick=function(){
			g_modal = parent.mt.utils.displayModal({
				type:"iframe",
				url:g_sURLModifyDocument+"&bModalMode=true&lId="+lIdGedDocument,
				title:"<%=locTitle.getValue (39, "Modifier le document")%> : "+g_sDocumentName,
				width:800,
				height:450,
				color:"8A6D7C",
				opacity:70,
				titleColor:"fff",
				options:{
					afterClose:function(){
						openGlobalLoader();
						Element.hide("tableHeaderDocument");
						Element.show("divLoadingHeaderDocument");
						self.location.href = g_sURLDisplayDocument+lIdGedDocument;
						closeGlobalLoader();
					}
				}
			});
		}
	}else{
		Element.hide("ButModifyDocument");
	}
	
	$("ButDisplayDocument").onclick=function(){displayDocument();}
	$("ButDownloadDocument").onclick=function(){
		location.href = g_sLinkDisplayDocument+"&dl=true&lId="+lIdGedDocument;
	}
	if (bIsImage) displayDocument();
	if (!g_sLoadTab.isNull()){
		hideTabs();
		Element.addClassName($(g_sLoadTab+'_tab'), "selected");
		Element.show(g_sLoadTab+"TabContent");
	}
}

onPageLoad = function() {
	// Préchargement de l'image par défaut :
	var img = new Image(16, 16);
	img.src = rootPath+"images/icons/application.gif";
	var img2 = new Image(16, 16);
	img2.src = rootPath+"images/loading/ajax-loader.gif";
	populate();
    
}

function doUrlConfirm(url, message)
{
    if(confirm(message))
    {
    	location.href = url;
    }
}
</script>
</head>
<body style="background-color: #FFFFFF;">
<span id="pageTitle" style="display:none"><%=sTitle%></span>
<div class="ficheTablePadding">
	
<!-- cdc0c7 8A6D7C -->
<div style="background-color:#FFF;padding:0px 10px 0 10px">
<%Border bordGedFolder = new Border("cdc0c7", 5, 100, "tr", request);%>
<%=bordGedFolder.getHTMLTop()%>

<jsp:include page="include/headerDocument.jsp"></jsp:include>	
	
	<div class="tabsFolder" style="margin:5px 5px 0 5px;">		
		<span id="document_tab" class="t selected"><%=locTab.getValue (3, "Document")%></span>
		<span id="annotation_tab" class="t"><%=locTab.getValue (4, "Annotations")%></span>
		<span id="revision_tab" class="t"><%=locTab.getValue (5, "Révision")%></span>
		<span id="sign_tab" class="t"><%=locTab.getValue (6, "Signatures")%></span>    
		<div style="clear:left"></div>
	</div>
	<div style="margin:0 5px 0 5px;">
	<%
	Border bordTabDiv = new Border("ffffff", 5, 100, "blr", request);
	bordTabDiv.setStyle("width:100%");
	out.println(bordTabDiv.getHTMLTop());
	%>
		<div id="documentTabContent" style="padding-top: 5px;">
		<%
		Border bordButton = new Border("eeeeee", 5, 100, "tblr", request);
		bordButton.setStyle("text-align: center;width:auto;margin:0 auto 5px auto;");
		out.print(bordButton.getHTMLTop());
		%>	
			<button type="button" id="ButDisplayDocument" style="" class="ContextButton" >
			<img src="<%= rootPath %>images/icons/magnifier.gif" alt="" style="vertical-align:middle;"/>
			<%=localizeButton.getValueView("Visualiser")%></button>
			
			<button type="button" id="ButDownloadDocument" style="" class="ContextButton" >
			<img src="<%= rootPath %>images/icons/down.png" alt="" style="vertical-align:middle;"/>
			<%=localizeButton.getValueDownload()%></button>
			
			<button type="button" id="ButModifyDocument" style="" class="ContextButton" >
			<img src="<%= rootPath %>images/icons/16x16/file_document_edit.png" alt="" style="vertical-align:middle;"/>
			<%=localizeButton.getValueModify()%></button>
			
			<button type="button" id="ButDuplicateDocument" style="" class="ContextButton" >
			<img src="<%= rootPath %>images/icons/16x16/file_document_move.png" alt="" style="vertical-align:middle;"/>
			<%= localizeButton.getValueMove()+" / "+localizeButton.getValueDuplicate()%></button>
			
			<button type="button" id="ButConvertToPDF" style="" class="ContextButton" >
			<img src="<%= rootPath %>images/icons/pdf-document.png" alt="" style="vertical-align:middle;"/>
			<%=localizeButton.getValueTransformToPDF("Transformer en PDF") %></button>
			
			<button type="button" id="" style="" class="ContextButton" style="display:none;">
			<img src="<%= rootPath %>images/icons/clock.png" alt="" style="vertical-align:middle;"/>
			<%=locButton.getValue (15, "Consulter les révisions")%></button>
				
			<%= bordButton.getHTMLBottom() %>
			<iframe name="IfDisplay" id="IfDisplay" frameborder=0 style="border:none;height:450px;display:none;width:100%;text-align: center;"></iframe>
		</div>
				<%
	    /** 
	     * Révisions
	     */
	     HashMap<String, File> hmFile = new HashMap<String, File> ();
	     Vector<GedDocumentRevision> vGedDocumentRevision 
	       =  GedDocumentRevision.getAllFromGedDocumentOrdered(doc.getId(), "DESC");
	     Vector<PkiCertificateSignature> vPkiCertificateSignature 
		    = PkiCertificateSignature.getAllFromGedDocument(doc.getId(), vGedDocumentRevision);
		
		// TODO : optimize with a predefined list
		Vector<PersonnePhysique> vPersonnePhysique = new Vector<PersonnePhysique>();
		 
		CoinDatabaseWhereClause wcPersonneAll = new CoinDatabaseWhereClause(CoinDatabaseWhereClause.ITEM_TYPE_INTEGER);
	    for(PkiCertificateSignature certificateSignature : vPkiCertificateSignature )
	    {
	    	wcPersonneAll.add(certificateSignature.getIdIndividual());
		}
	    vPersonnePhysique = PersonnePhysique.getAllWithWhereAndOrderByClauseStatic(
	    		" WHERE " + wcPersonneAll.generateWhereClause("id_personne_physique"),
	    		"");
	    

		
	    request.setAttribute("vGedDocumentRevision",vGedDocumentRevision);
		request.setAttribute("rootPath",rootPath);
		request.setAttribute("item",doc);
		request.setAttribute("doc",doc);
		request.setAttribute("folder",folder);
		request.setAttribute("vPersonnePhysique",vPersonnePhysique);
		request.setAttribute("hmFile",hmFile);
		
		/** 
		 * Annotations
		 */
		
	    Vector<GedDocumentAnnotation> vGedDocumentAnnotation 
	       =  GedDocumentAnnotation.getAllFromGedDocument(doc.getId(), " ORDER BY date_creation DESC ");
		
	    /**
		 * signature part
		 */
	    String sSubDirTemp = "" + System.currentTimeMillis();
	    GedDocument item = doc;
		%>
		<div id="revisionTabContent" style="padding-top: 5px;display:none;">
		<jsp:include page="include/divRevisionList.jsp"></jsp:include>
		</div>
		<div id="annotationTabContent" style="padding-top: 5px;display:none;">
		<%@ include file="include/divAnnotationList.jspf" %>
		</div>
		<div id="signTabContent" style="padding-top: 5px;display:none;">
			<%// bordButton.getHTMLTop() %>	
			<button type="button" id="ButSign" style="display:none;" class="ContextButton" >
			<img src="<%= rootPath %>images/icons/page_key.gif" alt="" style="vertical-align:middle;"/>
			Signer</button>				
			<%// bordButton.getHTMLBottom() %>
			<%@ include file="include/divSignatureList.jspf" %>
		</div>
	<%=bordTabDiv.getHTMLBottom() %>
	</div>

<% bordGedFolder = new Border("cdc0c7", 5, 100, "tblr", request);%>
<%=bordGedFolder.getHTMLBottom()%>

</div>
</div>

</body>


<%@page import="org.coin.ui.Border"%></html>
