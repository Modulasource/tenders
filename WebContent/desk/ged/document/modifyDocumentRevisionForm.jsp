<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.html.*" %>
<%@page import="org.coin.bean.ged.*"%>
<% 
	String sTitle = "Document revision : "; 

	GedDocumentRevision item = null;
	GedDocumentRevision itemParent = null;
    GedDocument document = null;
    GedFolder folder = null;
    
	String sPageUseCaseId = "xxx";
	String sHtmlFormType= "";
	String sHtmlFormUrl= "modifyDocumentRevision.jsp";
	
	String sAction = request.getParameter("sAction");
	if(sAction.equals("create"))
	{
		item = new GedDocumentRevision();
		item.setIdGedDocument(Integer.parseInt(request.getParameter("lIdGedDocument"))) ;
		itemParent = new GedDocumentRevision();
		sTitle += "<span class=\"altColor\">New document revision</span>"; 
		sHtmlFormType = " enctype='multipart/form-data' ";
		sHtmlFormUrl = "modifyDocumentRevisionCreate.jsp";
	}
	
	if(sAction.equals("store"))
	{
		item = GedDocumentRevision.getGedDocumentRevision(Integer.parseInt(request.getParameter("lId")));
		itemParent = GedDocumentRevision.getGedDocumentRevision(item.getIdGedDocumentRevisionParent());
		sTitle += "<span class=\"altColor\">"+item.getName()+"</span>"; 
	}

	HtmlBeanTableTrPave pave = new HtmlBeanTableTrPave();
	pave.bIsForm = true;
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);

    document = GedDocument.getGedDocument(item.getIdGedDocument());
    folder = GedFolder.getGedFolder(document.getIdGedFolder());

%>

<script type="text/javascript">
function removeItem()
{
    if(confirm("Do you want to delete this Ged document revision ?")){

     }
}
</script>
</head>
<body>


<%@ include file="/include/new_style/headerFiche.jspf" %>

<!-- Quick navigation  -->
<div class="leftBottomBar">
    <a href="<%= response.encodeURL( rootPath + "desk/ged/folder/displayAllFolder.jsp" ) %>" >All folders</a>
    <img src="<%= rootPath + Icone.ICONE_NAVIGATION_DELIMITER %>" />
    <a href="<%= response.encodeURL( rootPath + "desk/ged/folder/displayFolder.jsp?lId=" + folder.getId() ) %>" >folder <%= folder.getName() %></a>
    <img src="<%= rootPath + Icone.ICONE_NAVIGATION_DELIMITER %>" />
    <a href="<%= response.encodeURL( rootPath + "desk/ged/document/displayDocument.jsp?lId=" + document.getId() ) %>" >document <%= document.getName() %></a>
    <img src="<%= rootPath + Icone.ICONE_NAVIGATION_DELIMITER %>" />
    annotation 
</div>

<form action="<%= response.encodeURL(sHtmlFormUrl) %>" 
 method="post"
 <%= sHtmlFormType %>
 name="formulaire" >
<div id="fiche">
        <input type="hidden" name="lId" value="<%= item.getId() %>" />
		<input type="hidden" name="sAction" value="<%= sAction %>" />
        <input type="hidden" name="lIdGedDocument" value="<%= item.getIdGedDocument() %>" />
		
		<table class="formLayout" cellspacing="3">
			<tr>
				<td class="pave_cellule_gauche">Révision parent  :</td>
				<td class="pave_cellule_droite">
					<%= itemParent.getAllInHtmlSelect("lIdGedDocumentRevisionParent") %>
				</td>
			</tr>
		<%= pave.getHtmlTrInput("RevisionLabel :", "sRevisionLabel", item.getRevisionLabel(),"size=\"100\"") %>
<%
	if(sAction.equals("create"))
	{
%>
			<tr>
				<td class="pave_cellule_gauche">Document  :</td>
				<td class="pave_cellule_droite">
					<input type="file" name="document" size="60" />
				</td>
			</tr>
<%
	}
%>	

		</table>
</div>
<div id="fiche_footer">

	<button type="submit" >Valid</button>
	<%if(sAction.equals("store"))
	{ %>
	<button type="button" onclick="javascript:removeItem();">
			Delete</button>
	<%} %>
	<button type="button" onclick="javascript:doUrl('<%=
		response.encodeURL("displayDocument.jsp?lId=" + item.getIdGedDocument()) %>');" >
		Cancel</button>
</div>
</form>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>
