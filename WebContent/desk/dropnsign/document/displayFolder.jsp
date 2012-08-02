<%@page import="org.coin.bean.ged.GedDocumentRevision"%>
<%@page import="org.coin.bean.addressbook.IndividualAction"%>
<%@page import="org.coin.bean.addressbook.IndividualLink"%>
<%@include file="/include/new_style/headerDeskUtf8.jspf" %>
<%@page import="org.coin.bean.addressbook.IndividualLinkDom"%>
<%@page import="org.coin.util.CalendarUtil"%>
<%@page import="org.coin.security.CertificateUtil"%>
<%@page import="java.security.cert.X509Certificate"%>
<%@page import="org.coin.bean.pki.PkiSignatureAlgorithmType"%>
<%@page import="org.coin.bean.pki.certificate.signature.PkiCertificateSignatureType"%>
<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%@page import="org.coin.bean.pki.certificate.signature.PkiCertificateSignature"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Collection"%>
<%@page import="org.coin.bean.ged.GedDocument"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="java.util.Vector"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.bean.ged.GedFolder"%>
<%
	long lId = HttpUtil.parseLong("lId", request);
	boolean bUseAppletFileSync = HttpUtil.parseBoolean("bUseAppletFileSync", request, false);
	
	GedFolder item = GedFolder.getGedFolder(lId);
	IndividualLinkDom domLink = new IndividualLinkDom(sessionUser.getIdIndividual());
	domLink.computeList();
	request.setAttribute("domLink", domLink);
	request.setAttribute("getFolder", item);
%>
<style type="text/css">
<!--
.overlay_action {
padding: 5px;
z-index: 1000;
position: absolute;
background: #eee;
/*opacity: 0.8;*/
border: 1px #ddd solid;
border-radius: 5px;
-moz-border-radius: 5px;
}
.span_button {
text-decoration: none;
cursor: auto;
color: #000;
}
.span_button:hover {
text-decoration: underline;
cursor: pointer;
}

-->
</style>
</head>
<body>
<script type="text/javascript">
function displayFolder(lId)
{
	doUrl("<%= response.encodeURL(
			rootPath + "desk/dropnsign/document/displayFolder.jsp" 
			+ "?lId=") %>"
			+ lId);
}

function displayRootFolder()
{
	doUrl("<%= response.encodeURL(
			rootPath + "desk/dropnsign/document/displayRootFolder.jsp" )
			%>");
}


function modifyFolder(lId)
{
	doUrl("<%= response.encodeURL(
			rootPath + "desk/dropnsign/document/modifyFolderForm.jsp" 
			+ "?sAction=store"
			+ "&lId=") %>"
			+ lId);
}

function createSubFolder()
{
	doUrl("<%= response.encodeURL(rootPath 
			+ "desk/dropnsign/document/modifyFolderForm.jsp" 
			+ "?sAction=create"
			+ "&lIdParentFolder=" + item.getId()) %>");
}
</script>


<script type="text/javascript">

function displayPopDocument(url)
{				
	var title = "Document";
	parent.mt.utils.displayModal({
		type:"iframe",
		url:url,
		title:title,
		width:800,
		height:500
	});				
}

function assignToSign(lId)
{
	var lIdIndividualDestination = $('lIdIndividualDestination_' + lId).value;
	doUrl("<%= response.encodeURL(rootPath 
			+ "desk/dropnsign/document/modifyDocument.jsp" 
			+ "?sAction=assignToSign"
			) %>"
		+ "&lId=" + lId
		+ "&lIdIndividualDestination=" + lIdIndividualDestination );
}

function removeDocument(lId)
{
	if(confirm("Are you sure ?"))
	{
		doUrl("<%= response.encodeURL(
				rootPath + "desk/dropnsign/document/modifyDocument.jsp" 
				+ "?sAction=remove"
				+ "&lId=") %>"
				+ lId);
	}
}

function convertPdfDocument(lId)
{
	doUrl("<%= response.encodeURL(
			rootPath + "desk/dropnsign/document/modifyDocument.jsp" 
			+ "?sAction=convertPdf"
			+ "&lId=") %>"
			+ lId);
}

function signDocument(lId)
{
	doUrl("<%= response.encodeURL(
			rootPath + "desk/dropnsign/document/signature/displayAppletSignature.jsp" 
			+ "?sAction=sign"
			+ "&lId=") %>"
			+ lId);
}
function modifyDocument(lId)
{
	doUrl("<%= response.encodeURL(
			rootPath + "desk/dropnsign/document/displayAppletDocument.jsp" 
			+ "?sAction=modify"
			+ "&lId=") %>"
			+ lId);
}
function openDocument(lId)
{
	doUrl("<%= response.encodeURL(
			rootPath + "desk/dropnsign/document/displayDocument.jsp" 
			+ "?lId=") %>"
			+ lId);
}


function activateAppletFileSync()
{
	doUrl("<%= response.encodeURL(
			rootPath + "desk/dropnsign/document/displayFolder.jsp" 
			+ "?lId=" + lId
			+ "&bUseAppletFileSync=true") %>"
			);
}

function deactivateAppletFileSync()
{
	doUrl("<%= response.encodeURL(
			rootPath + "desk/dropnsign/document/displayFolder.jsp" 
			+ "?lId=" + lId
			+ "&bUseAppletFileSync=false") %>"
			);
}

		
</script>


<div>
<div style="border: 1px #ddd solid;vertical-align: bottom;margin: 5px;padding: 5px;">
<div>
<button onclick="modifyFolder(<%= item.getId() %>);" >Modifier dossier</button>
</div>
<jsp:include page="/desk/dropnsign/document/bloc/blocFolderHeader.jsp" />
</div>
<%
	if(bUseAppletFileSync)
	{
%>
<button onclick="deactivateAppletFileSync();" >Désactiver local sync</button>
<jsp:include page="bloc/blocAppletFileSync.jsp" />
<%		
	} else {
%>
<button onclick="activateAppletFileSync();" >Activer local sync</button>
<%		
	}
%>

<div style="margin:5px; padding: 15px;border: 1px #ddd solid;">
<span onclick="createSubFolder();" style="cursor: pointer;">Ajouter sous dossier</span>
<div><br/>Sous dossiers:</div>
<div >
<jsp:include page="/desk/dropnsign/document/bloc/blocListFolders.jsp">
<jsp:param name="lIdParentFolder" value="<%= item.getId() %>" />
</jsp:include>
</div>
<div style="clear: both;"></div>
</div>

<div style="margin:5px; padding: 15px;border: 1px #ddd solid;">
<div>
	<span style="cursor: pointer;" 
		onclick="Element.toggle('spanAddFile')">Ajouter un document</span>
	<form action="<%=
		response.encodeURL(
		rootPath + "desk/dropnsign/document/uploadDocument.jsp"
		+ "?lIdGedFolder=" + item.getId())
		%>"
		id="formDocument"
		method="post"
		enctype="multipart/form-data"
		>
	<span id="spanAddFile" style="display: none;">
		<input type="file" name="fileDocument">
		<button type="submit">Submit</button>
	</span>
	</form>
</div>
<div ><br/>Fichiers:</div>
<div id="divDocumentList" style="height: 200px;overflow: auto;">
<%
	Vector<GedDocument> vDocument 
		= GedDocument.getAllFromGedFolder(item.getId());

	for(GedDocument doc : vDocument)
	{
		Vector<PkiCertificateSignature> vSignature =
			PkiCertificateSignature.getAllPkiCertificateSignature(ObjectType.GED_DOCUMENT, doc.getId());

		IndividualAction ia = new IndividualAction();
		Vector<IndividualAction> vIndividualActionAssigned 
			= ia.getAllWithWhereAndOrderByClause(
				" WHERE id_individual_source=" + sessionUser.getIdIndividual()
				+ " AND id_action_object_type=" + ObjectType.GED_DOCUMENT
				+ " AND id_action_object_reference=" + doc.getId(),
				"");

		Vector<GedDocumentRevision> vDocumentRevision
			= GedDocumentRevision.getAllFromGedDocument(doc.getId());
				
		request.setAttribute("doc", doc);
		request.setAttribute("vSignature", vSignature);
		request.setAttribute("vDocumentRevision", vDocumentRevision);
		request.setAttribute("vIndividualActionAssigned", vIndividualActionAssigned);

%>
<div style="float: left;padding: 15px;" id="divDocument_<%= doc.getId() %>" >
<img src="<%= rootPath + "images/dropnsign/64x64/document.png" %>" 
	onclick="Element.toggle('divActionDocument_<%= doc.getId() %>');" 
	style="cursor: pointer;" /><br/>


<%
		if(vSignature.size() > 0)
		{
%>
<img alt="Signatures" 
onclick="Element.toggle('signatureList_<%= doc.getId() %>');"
style="cursor: pointer;"
src="<%= rootPath + "images/dropnsign/16x16/locked.png" %>" />
<%		
		}
%>


<%
		if(vDocumentRevision.size() > 0)
		{
%>
<img alt="Revision" 
onclick="Element.toggle('documentRevisionList_<%= doc.getId() %>');"
style="cursor: pointer;"
src="<%= rootPath + "images/dropnsign/16x16/tag.png" %>" />
<%		
		}
%>


<%
		if(vIndividualActionAssigned.size() > 0)
		{
%>
<img alt="Signatures" 
onclick="Element.toggle('actionList_<%= doc.getId() %>');"
style="cursor: pointer;"
src="<%= rootPath + "images/dropnsign/16x16/cog.png" %>" />
<%		
		}
%>

<%= doc.getName() %><br/>

<jsp:include page="bloc/blocDocumentRevision.jsp" />
<jsp:include page="bloc/blocDocumentSignature.jsp" />
<jsp:include page="bloc/blocDocumentActionList.jsp" />
<jsp:include page="bloc/blocDocumentAction.jsp" />
</div>
<%
	}			
%>
</div>
<div style="clear: both;"></div>
</div>

</div>
</body>
</html>