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
	String sTitle = "Document : "; 
    HashMap<String, File> hmFile = new HashMap<String, File> ();

	/**
	 * Localization
	 */
	Localize locButton = new Localize (sessionLanguage.getId (), LocalizationConstant.CAPTION_CATEGORY_GEC_PAGE_BUTTON);
	Localize locTitle = new Localize (sessionLanguage.getId (), LocalizationConstant.CAPTION_CATEGORY_GEC_PAGE_TITLE);
	Localize locMessage = new Localize (sessionLanguage.getId (), LocalizationConstant.CAPTION_CATEGORY_GEC_PAGE_MESSAGE);
	Localize locTab = new Localize (sessionLanguage.getId (), LocalizationConstant.CAPTION_CATEGORY_GEC_PAGE_TAB);

    
    String sSubDirTemp = "" + System.currentTimeMillis();

	GedDocument doc = null;
	GedDocument item = null;
	GedDocumentType type = null;
    GedFolder folder = null;
	String sPageUseCaseId = "xxx";
	
	
	doc = GedDocument.getGedDocument(Integer.parseInt(request.getParameter("lId")));
	doc.setAbstractBeanLocalization(sessionLanguage);
	item = doc;
	folder = GedFolder.getGedFolder(doc.getIdGedFolder());
	try{
		type = GedDocumentType.getGedDocumentType(doc.getIdGedDocumentType());
	} catch (Exception e) { type = new GedDocumentType(); }
	sTitle += "<span class=\"altColor\">"+doc.getName()+"</span>"; 

	HtmlBeanTableTrPave pave = new HtmlBeanTableTrPave();
	pave.bIsForm = false;
	//sessionUserHabilitation.isHabilitateException(sPageUseCaseId);

	/**
	 * doc parent
	 */
	GedDocument itemParent = null;
	try{
		itemParent = GedDocument.getGedDocument(doc.getIdGedDocumentParent());
	} catch (CoinDatabaseLoadException e) {}

	/** 
	 * Annotations
	 */
    Vector<GedDocumentAnnotation> vGedDocumentAnnotation 
       =  GedDocumentAnnotation.getAllFromGedDocument(doc.getId(), " ORDER BY date_creation DESC ");

	
    /** 
     * Révisions
     */
	Vector<GedDocumentRevision> vGedDocumentRevision 
       =  GedDocumentRevision.getAllFromGedDocumentOrdered(doc.getId(), "DESC");

    
    
	   
	/**
	 * on doit prendre la derniere version ou s'il n'a pas de révision on peut le BLOB du document
	 */
	String sUrlDownloadLastRevision = response.encodeURL(
			GedDocumentRevision.getUrlDownloadLastRevision(
					doc,
					vGedDocumentRevision,
					rootPath));
	
    String sUrlDownloadDocument = response.encodeURL(
    		 rootPath+"desk/GedDocumentDownloadServlet?lId="+doc.getId());
	
	/**
	 * signature part
	 */
	 

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
    
	String sURLDocument = response.encodeURL(rootPath+"desk/GedDocumentDownloadServlet?sRevision=last_revision"
    		+ "&nonce=" + System.currentTimeMillis()
    		+ "&lId="+doc.getId());

    
    request.setAttribute("vGedDocumentRevision",vGedDocumentRevision);
	request.setAttribute("rootPath",rootPath);
	request.setAttribute("item",item);
	request.setAttribute("doc",item);
	request.setAttribute("folder",folder);
	request.setAttribute("vPersonnePhysique",vPersonnePhysique);
	request.setAttribute("hmFile",hmFile);
	request.setAttribute("sSubDirTemp",sSubDirTemp);
	request.setAttribute("locTitle", locTitle);
	request.setAttribute("locButton", locButton);
	request.setAttribute("locMessage", locMessage);
	request.setAttribute("localizeButton", localizeButton);
	request.setAttribute("sURLDocument", sURLDocument);

%>

<script type="text/javascript">
function removeItem()
{
    if(confirm("Do you want to delete this document ?")){
    	location.href = '<%= response.encodeURL("modifyDocument.jsp?sAction=remove&lId=" + doc.getId()) %>';
     }
}

function updateAllDocumentRevisionSelected()
{
    $$('.selectedDocumentRevision').each(function(item){
        item.checked = $("selectedDocumentRevisionAll").checked;        
    }) 
}

function removeDocumentRevisionSelected()
{
    var bAtLeastOneSelected = false;
    var sSelectedItemUrlParam = "";
    var sSelectedItemListDocumentName = "";
    $$('.selectedDocumentRevision').each(function(item){
        if(item.checked)
        {
            bAtLeastOneSelected = true;   
            if(sSelectedItemUrlParam != "") {
                sSelectedItemUrlParam += ",";
                sSelectedItemListDocumentName += ",\n";
            }
            sSelectedItemUrlParam += item.value ;
            sSelectedItemListDocumentName += "- " + item.name ;
        }
    }) 

    
    if(!bAtLeastOneSelected)
    {
        alert("Pas de révision sélectionnée");   
        return false;
    }
    
    if(confirm("Do you want to delete this documents ? \n" 
            + sSelectedItemListDocumentName
             )){
         location.href = '<%= 
             response.encodeURL("modifyDocumentRevision.jsp?sAction=removeAll&arrayId=") %>' + sSelectedItemUrlParam;
     }
}


function addRevision()
{
	location.href = '<%= response.encodeURL("modifyDocumentRevisionForm.jsp?sAction=create&lIdGedDocument=" + doc.getId()) %>';
}

function removeLastRevision()
{
    if(confirm("Do you want to delete the last revision ?"))
    {
        location.href = '<%= response.encodeURL("modifyDocument.jsp?sAction=removeLastRevision&lId=" + doc.getId()) %>';
    }
}


function generateRevision()
{
	location.href = '<%= response.encodeURL("modifyDocumentRevision.jsp?sAction=generate&lIdGedDocument=" + doc.getId()) %>';
}

function generateRevisionWithNewSignature()
{
	location.href = '<%= response.encodeURL("modifyDocumentRevision.jsp?sAction=generatWithNewSignature&lIdGedDocument=" + doc.getId()) %>';
}


function generateRevisionWithSignatureArray()
{
	location.href = '<%= response.encodeURL("modifyDocumentRevision.jsp?sAction=generatWithSignatureArray&lIdGedDocument=" + doc.getId()) %>';
}


function generateRevisionWithTransformation()
{
	location.href = '<%= response.encodeURL("modifyDocumentRevision.jsp?sAction=generateWithTransformation&lIdGedDocument=" + doc.getId()) %>';
}

/**
 * Annotation
 */
function addAnnotation()
{
	location.href = '<%= response.encodeURL("modifyDocumentAnnotationForm.jsp?sAction=create&lIdGedDocument=" + doc.getId()) %>';
}

function addAnnotationClient()
{
    location.href = '<%= response.encodeURL("modifyDocumentAnnotationClientForm.jsp?sAction=create&lIdGedDocument=" + doc.getId()) %>';
}

function addAnnotationServer()
{
    location.href = '<%= response.encodeURL("modifyDocumentAnnotationServerForm.jsp?sAction=createSignServer&lIdGedDocument=" + doc.getId()) %>';
}

/**
 * Signature
 */
function addSignatureLastDocumentRevisionClient()
{
    location.href = '<%= response.encodeURL("modifyDocumentSignatureClientForm.jsp?sAction=create&lIdGedDocument=" + doc.getId()) %>';
}

function addSignatureLastDocumentRevisionServer()
{
    location.href = '<%= response.encodeURL("modifyDocumentSignatureServerForm.jsp?sAction=createServer&lIdGedDocument=" + doc.getId()) %>';
}

/**
 * Seal
 */
function sealLastDocumentRevisionClient()
{
    location.href = '<%= response.encodeURL("modifyDocumentSignatureClientForm.jsp?sAction=sealLastRevision&lIdGedDocument=" + doc.getId()) %>';
}

function sealLastDocumentRevisionServer()
{
    location.href = '<%= response.encodeURL("modifyDocumentSignatureServerForm.jsp?sAction=sealLastRevisionServer&lIdGedDocument=" + doc.getId()) %>';
}


function sendLastRevisionWithAllSignatureAttached()
{
	var sEmailAdress = prompt("Adresse email ?", "david.keller@matamore.com");
	var sUrl = '<%= 
        response.encodeURL(
                rootPath + "desk/ged/document/modifyDocument.jsp?" 
                + "sAction=sendLastRevisionWithAllSignatureAttached"
                + "&lIdPkiSignatureAlgorithmType=" + PkiSignatureAlgorithmType.SIGNATURE_TYPE_PKCS7
                //+ "&lId=lastRevision" 
                + "&lId=" + doc.getId()
            ) %>';
            
	doUrl(sUrl + "&sEmailAdress=" + sEmailAdress);
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
<body>



<%@ include file="/include/new_style/headerFiche.jspf" %>
<jsp:include page="include/headerDocument.jsp"></jsp:include>

<!-- Quick navigation  -->
<!-- 
<div class="leftBottomBar">
    <a href="<%= response.encodeURL( rootPath + "desk/ged/folder/displayAllFolder.jsp" ) %>" >All folders</a>
    <img src="<%= rootPath + Icone.ICONE_NAVIGATION_DELIMITER %>" />
    <a href="<%= response.encodeURL( rootPath + "desk/ged/folder/displayFolder.jsp?lId=" + folder.getId() ) %>" >folder <%= folder.getName() %></a>
    <img src="<%= rootPath + Icone.ICONE_NAVIGATION_DELIMITER %>" />
    document <%= doc.getName() %>
</div>
 -->
 
<div id="fiche">

<div onclick="Element.toggle('infoDocument')"><%=locTab.getValue (10, "Infos")%></div>
<div id="infoDocument" style="display: none;cursor: pointer;">
 		<table class="formLayout" cellspacing="3">
			<tr>
				<td class="pave_cellule_gauche"><%=item.getIdGedDocumentTypeLabel()%> :</td>
				<td class="pave_cellule_droite">
					<%= type.getName() %>
				</td>
			</tr>
		<%= pave.getHtmlTrInput(item.getReferenceLabel() + " :", "sReference", doc.getReference(),"size=\"100\"") %>
		<%= pave.getHtmlTrInput(item.getNameLabel() + " :", "sName", doc.getName(),"size=\"100\"") %>
		<%= pave.getHtmlTrInput(item.getDocumentNameLabel () + " :", "sDocumentName", doc.getDocumentName(),"size=\"100\"") %>
			<tr>
				<td class="pave_cellule_gauche"><%=item.getDescriptionLabel ()%> :</td>
				<td class="pave_cellule_droite"><%=doc.getDescription()%></td>
			</tr>
            <tr>
                <td class="pave_cellule_gauche"><%=item.getIdGedDocumentParentLabel () %> :</td>
                <td class="pave_cellule_droite">
<%
	if(itemParent != null)
	{
%>
<a href="doUrl('<%= 
	response.encodeURL(
			rootPath + "displayDocument.jsp?lId=" + itemParent.getId() )%>')" ><%= itemParent.getName() %></a>
<%		
	} else {
%>
<%=locTitle.getValue (56, "pas de document parent") %> (<%= doc.getIdGedDocumentParent() %>)
<%		
	}

%>
                </td>
            </tr>
<!-- 			<tr>
				<td class="pave_cellule_gauche">Aperçu :</td>
				<td class="pave_cellule_droite">
					<div style="border-color:black;border-style:solid;text-align:center;">
					<img alt="vignette" src="<%= rootPath + "GedDocumentThumbnailServlet?lId=" 
							+ doc.getId() %>" height="350" />
					</div>
				</td>
			</tr>
 -->
		</table>
</div>

    <button type="button" onclick="javascript:removeItem();">
        <%= localizeButton.getValueDelete() %></button>
<br/>
<br/>

<%
	if(sessionUserHabilitation.isSuperUser())
	{
%>
<div id="fiche_footer">



    <button type="button" onclick="javascript:doUrl('<%=
        response.encodeURL("modifyDocumentForm.jsp?sAction=store&lId=" + doc.getId()) 
            %>');">
        Modify</button>

    <button type="button" onclick="javascript:doUrl('<%=
        response.encodeURL("modifyDocument.jsp?sAction=convertPdf&lId=" + doc.getId()) 
            %>');">
        Convert PDF</button>

    <button type="button" onclick="javascript:doUrl('<%=
        response.encodeURL("modifyDocument.jsp?sAction=removeThumbnail&lId=" + doc.getId()) 
            %>');">
        Delete thumbnail</button>

    <button type="button" onclick="javascript:doUrl('<%=
        response.encodeURL("modifyDocument.jsp?sAction=duplicate&lId=" + doc.getId()) 
            %>');">
        Duplicate</button>


    <button type="button" onclick="javascript:doUrl('<%=
    	sUrlDownloadLastRevision %>');" >
        Download document (last rev)</button>
        
    <button type="button" onclick="javascript:doUrl('<%=
    	sUrlDownloadLastRevision + "&sMention=draft" %>');" >
        Download document (last rev)<br/> with draft mention</button>

    <button type="button" onclick="javascript:doUrl('<%=
    	sUrlDownloadDocument %>');" >
        Download document</button>        

<br/>
    <button type="button" 
		onclick="doUrl('<%= 
                       response.encodeURL(
                               rootPath + "desk/PkiDownloadCertificateSignature?" 
                               + "sAction=getAllSignatureAttached"
                               + "&lIdPkiSignatureAlgorithmType=" + PkiSignatureAlgorithmType.SIGNATURE_TYPE_PKCS7
                               + "&lId=lastRevision" 
                               + "&lIdGedDocument=" + doc.getId()
                       ) %>');" >
        Download document in PKCS7<br/> with all signers</button>

    <button type="button" 
        onclick="javascript:sendLastRevisionWithAllSignatureAttached()" >
        Send document in PKCS7<br/> with all signers</button>


</div>

<br/>
<%
	}
%>
<a href="#" onclick="Element.toggle('divSignatureList');" ><%=locTab.getValue (7, "Les signatures et visas")%></a><br/>
<%@ include file="include/divSignatureList.jspf" %>


<br/>
<br/>
<br/>

<a href="#" onclick="Element.toggle('divAnnotationList');" ><%=locTab.getValue (8, "Les annotations")%></a><br/>
<%@ include file="include/divAnnotationList.jspf" %>


<br/>
<br/>
<br/>

<a href="#" onclick="Element.toggle('divRevisionList');" ><%=locTab.getValue (9, "Les révisions")%></a><br/>
<jsp:include page="include/divRevisionList.jsp"></jsp:include>

<%
	/**
     * Remove Hashmap
     */
    Set set = hmFile.keySet();
    Iterator iteratorFile = set.iterator();
    while (iteratorFile.hasNext())
    {
    	File f = (File)hmFile.get( iteratorFile.next());
    	if(f != null){
    		f.delete();
    		FileUtil.deleteDirectory(f.getParent());
    	}
    }
 
%>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>
