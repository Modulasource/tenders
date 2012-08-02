<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.html.*" %>
<% 
	String sTitle = "Folder type : "; 


	GedFolderType item = null;
	GedDomain domain = null;
	String sPageUseCaseId = "xxx";
	
	String sAction = request.getParameter("sAction");
	if(sAction.equals("create"))
	{
		item = new GedFolderType();
		domain = new GedDomain();
		sTitle += "<span class=\"altColor\">New Folder type</span>"; 
	}
	
	if(sAction.equals("store"))
	{
		item = GedFolderType.getGedFolderType(Integer.parseInt(request.getParameter("lId")));
		domain = GedDomain.getGedDomain(item.getIdGedDomain());
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
    if(confirm("Do you want to delete this Ged Domain ?")){
         GedFolderType.removeFromId(<%= item.getId() %>,function() { 
            location.href = '<%= response.encodeURL("displayAllFolderType.jsp") %>';
           });
     }
}
</script>

<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<form action="<%= response.encodeURL("modifyFolderType.jsp") %>" method="post" name="formulaire">
<div id="fiche">
        <input type="hidden" name="lId" value="<%= item.getId() %>" />
		<input type="hidden" name="sAction" value="<%= sAction %>" />
		<table class="formLayout" cellspacing="3">
			<tr>
				<td class="pave_cellule_gauche">Domain :</td>
				<td class="pave_cellule_droite">
				<%= domain.getAllInHtmlSelect("lIdGedDomain") %>
				</td>
			</tr>
		<%= pave.getHtmlTrInput("Name :", "sName", item.getName(),"size=\"100\"") %>
		<%= pave.getHtmlTrInput("Type Index :", "lTypeIndex", item.getTypeIndex(),"size=\"100\"") %>
		<%= pave.getHtmlTrInput("Reference :", "sReference", item.getReference(),"size=\"100\"") %>
			<tr>
				<td class="pave_cellule_gauche">Description :</td>
				<td class="pave_cellule_droite">
					<textarea cols="97" rows="30" name="sDescription"><%= 
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
			response.encodeURL("displayAllFolderType.jsp") %>');" >
			Cancel</button>
</div>
</form>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>
<%@page import="org.coin.bean.ged.GedDomain"%>
<%@page import="org.coin.bean.ged.GedFolderType"%>
</html>
