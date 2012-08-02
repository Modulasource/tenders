<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.html.*" %>
<% 
	String sTitle = "Domain : "; 


	GedDomain item = null;
	GedDomainType type = null;
	String sPageUseCaseId = "xxx";
	
	String sAction = request.getParameter("sAction");
	if(sAction.equals("create"))
	{
		item = new GedDomain();
		type = new GedDomainType();
		sTitle += "<span class=\"altColor\">New Domain</span>"; 
	}
	
	if(sAction.equals("store"))
	{
		item = GedDomain.getGedDomain(Integer.parseInt(request.getParameter("lId")));
		type = GedDomainType.getGedDomainType(item.getIdGedDomainType());
		sTitle += "<span class=\"altColor\">"+item.getId()+"</span>"; 
	}

	HtmlBeanTableTrPave pave = new HtmlBeanTableTrPave();
	pave.bIsForm = true;
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);

%>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/Domain.js"></script>
</head>
<body>
<script type="text/javascript">
function removeItem()
{
    if(confirm("Do you want to delete this Ged Domain ?")){
         GedDomain.removeFromId(<%= item.getId() %>,function() { 
            location.href = '<%= response.encodeURL("displayAllDomain.jsp") %>';
           });
     }
}
</script>

<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<form action="<%= response.encodeURL("modifyDomain.jsp") %>" method="post" name="formulaire">
<div id="fiche">
        <input type="hidden" name="lId" value="<%= item.getId() %>" />
		<input type="hidden" name="sAction" value="<%= sAction %>" />
		<table class="formLayout" cellspacing="3">
		
			<tr>
				<td class="pave_cellule_gauche">Type :</td>
				<td class="pave_cellule_droite">
					<%= type.getAllInHtmlSelect("lIdGedDomainType") %>
				</td>
			</tr>
		<%= pave.getHtmlTrInput("Domain index :", "sDomainIndex", item.getDomainIndex(),"size=\"100\"") %>
		<%= pave.getHtmlTrInput("Reference :", "sReference", item.getReference(),"size=\"100\"") %>
		<%= pave.getHtmlTrInput("Name :", "sName", item.getName(),"size=\"100\"") %>
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
			response.encodeURL("displayAllDomain.jsp") %>');" >
			Cancel</button>
</div>
</form>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>
<%@page import="org.coin.bean.ged.GedDomain"%>
<%@page import="org.coin.bean.ged.GedDomainType"%>
</html>
