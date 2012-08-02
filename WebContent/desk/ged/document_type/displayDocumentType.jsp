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
	
	item = GedDocumentType.getGedDocumentType(Integer.parseInt(request.getParameter("lId")));
	folderType = GedFolderType.getGedFolderType(item.getIdGedFolderType());
	domain = GedDomain.getGedDomain(folderType.getIdGedDomain());
	sTitle += "<span class=\"altColor\">"+item.getId()+"</span>"; 

	HtmlBeanTableTrPave pave = new HtmlBeanTableTrPave();
	pave.bIsForm = false;
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
<div id="fiche">
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
				<%= folderType.getName() %>
				</td>
			</tr>
		<%= pave.getHtmlTrInput("Name :", "sName", item.getName(),"size=\"100\"") %>
			<tr>
				<td class="pave_cellule_gauche">Description :</td>
				<td class="pave_cellule_droite"><%= item.getDescription() %></td>
			</tr>
			<tr>
				<td class="pave_cellule_gauche">Max size in kilobytes :</td>
				<td class="pave_cellule_droite">60</td>
			</tr>
		</table>
</div>
<div id="fiche_footer">
	<button type="button" onclick="javascript:doUrl('<%=
			response.encodeURL("displayAllDocumentType.jsp") %>');" >
			Return</button>
	<button type="button"  onclick="javascript:doUrl('<%=
			response.encodeURL("modifyDocumentTypeForm.jsp?sAction=store&lId=" + item.getId()) %>');" >Modify</button>
	<button type="button" onclick="javascript:removeItem();">
			Delete</button>
			
	<br/><br/>
	<button type="button"  onclick="javascript:doUrl('<%=
			"" %>');" >Add primary key</button>
	<button type="button"  onclick="javascript:doUrl('<%=
			"" %>');" >Add secondary key</button>
			
</div>
</form>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>

</html>
