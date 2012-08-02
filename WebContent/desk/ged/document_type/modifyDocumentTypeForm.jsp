<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.html.*" %>
<%@page import="org.coin.bean.ged.GedDomain"%>
<%@page import="org.coin.bean.ged.GedFolderType"%>
<%@page import="org.coin.bean.ged.GedDocumentType"%>
<% 
	String sTitle = "Document type : "; 

	GedDocumentType item = null;
	GedFolderType folderType = null;
	GedDomain domain = null;
	String sPageUseCaseId = "xxx";
	
	String sAction = request.getParameter("sAction");
	if(sAction.equals("create"))
	{
		item = new GedDocumentType();
		folderType = new GedFolderType();
		domain = GedDomain.getGedDomain(Integer.parseInt(request.getParameter("lIdGedDomain")));
		sTitle += "<span class=\"altColor\">New document type</span>"; 
	}
	
	if(sAction.equals("store"))
	{
		item = GedDocumentType.getGedDocumentType(Integer.parseInt(request.getParameter("lId")));
		folderType = GedFolderType.getGedFolderType(item.getIdGedFolderType());
		domain = GedDomain.getGedDomain(folderType.getIdGedDomain());
		sTitle += "<span class=\"altColor\">"+item.getId()+"</span>"; 
	}

	HtmlBeanTableTrPave pave = new HtmlBeanTableTrPave();
	pave.bIsForm = true;
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);

%>
</head>
<body>
<script type="text/javascript">
function removeItem()
{
    if(confirm("Do you want to delete this Ged document type ?")){
         GedDocumentType.removeFromId(<%= item.getId() %>,function() { 
            location.href = '<%= response.encodeURL("displayAllDocumentType.jsp") %>';
           });
     }
}
</script>

<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<form action="<%= response.encodeURL("modifyDocumentType.jsp") %>" method="post" name="formulaire">
<div id="fiche">
        <input type="hidden" name="lId" value="<%= item.getId() %>" />
		<input type="hidden" name="sAction" value="<%= sAction %>" />
		<table class="formLayout" cellspacing="3">
			<tr>
				<td class="pave_cellule_gauche">Domain :</td>
				<td class="pave_cellule_droite">
				<%= domain.getName() %>
				</td>
			</tr>
		<%= pave.getHtmlTrInput("Type Index :", "lTypeIndex", item.getTypeIndex(),"size=\"100\"") %>
		<%= pave.getHtmlTrInput("Reference :", "sReference", item.getReference(),"size=\"100\"") %>
			<tr>
				<td class="pave_cellule_gauche">Folder type :</td>
				<td class="pave_cellule_droite">
				<%= folderType.getAllInHtmlSelect(
						"lIdGedFolderType",
						false,
						false,
						" WHERE id_ged_domain=" + domain.getId(), 
						"") %>
				</td>
			</tr>
		<%= pave.getHtmlTrInput("Name :", "sName", item.getName(),"size=\"100\"") %>
			<tr>
				<td class="pave_cellule_gauche">Description :</td>
				<td class="pave_cellule_droite">
					<textarea cols="97" rows="10" name="sDescription"><%= 
						item.getDescription() %></textarea></td>
			</tr>
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
		response.encodeURL("displayAllDocumentType.jsp") %>');" >
		Cancel</button>
</div>
</form>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>

</html>
