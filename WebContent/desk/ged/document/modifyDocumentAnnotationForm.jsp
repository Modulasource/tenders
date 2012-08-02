<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.html.*" %>
<%@page import="org.coin.bean.ged.GedDocument"%>
<%@page import="org.coin.bean.ged.GedDocumentAnnotation"%>
<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%@page import="org.coin.bean.ged.GedFolder"%>
<% 
	String sTitle = "Document annotation : "; 


	GedDocumentAnnotation item = null;
    GedDocument document = null;
    GedFolder folder = null;
	PersonnePhysique personne = null;
	String sPageUseCaseId = "xxx";
	String sHtmlFormType= "";
	String sHtmlFormUrl= "modifyDocumentAnnotation.jsp";
	
	String sAction = request.getParameter("sAction");
	if(sAction.equals("create"))
	{
		item = new GedDocumentAnnotation();
		item.setIdGedDocument(Integer.parseInt(request.getParameter("lIdGedDocument"))) ;
		sTitle += "<span class=\"altColor\">New document annotation</span>"; 
		//personne = new PersonnePhysique();
		//personne.setPrenom("Choissez");
		
		personne = PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual());
	}
	
	if(sAction.equals("store"))
	{
		item = GedDocumentAnnotation.getGedDocumentAnnotation(Integer.parseInt(request.getParameter("lId")));
		sTitle += "<span class=\"altColor\">"+item.getId()+"</span>"; 
		try {
			personne = PersonnePhysique.getPersonnePhysique(item.getIdPersonnePhysique());
		} catch (Exception e) {
			personne = new PersonnePhysique();
			personne.setPrenom("Choissez");
		}
	}

	HtmlBeanTableTrPave pave = new HtmlBeanTableTrPave();
	pave.bIsForm = true;
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
	   
	document = GedDocument.getGedDocument(item.getIdGedDocument());
	folder = GedFolder.getGedFolder(document.getIdGedFolder());

	
	
%>
<script type="text/javascript" src="<%= rootPath %>include/AjaxComboList.js?v=<%= JavascriptVersion.AJAX_COMBO_LIST_JS %>"></script>
<script type="text/javascript">
function removeItem()
{
    if(confirm("Do you want to delete this annotation ?")){
        location.href = '<%= response.encodeURL("modifyDocumentAnnotation.jsp?sAction=remove&lId=" + item.getId()) %>';
     }
}
onPageLoad = function(){
    ac = new AjaxComboList("lIdPersonnePhysique", "getPersonnePhysiqueAllType");
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
 name="formulaire" >
<div id="fiche">
        <input type="hidden" name="lId" value="<%= item.getId() %>" />
        <input type="hidden" name="lIdGedDocument" value="<%= item.getIdGedDocument() %>" />
		<input type="hidden" name="sAction" value="<%= sAction %>" />
		
		<table class="formLayout" cellspacing="3">
			<tr>
				<td class="pave_cellule_gauche">Annotation :</td>
				<td class="pave_cellule_droite">
					<textarea rows="5" cols="80" name="sAnnotation"><%= item.getAnnotation()%></textarea>
				</td>
			</tr>		
			<tr>
				<td class="pave_cellule_gauche">Personne :</td>
				<td class="pave_cellule_droite">

					<button type="button" id="AJCL_but_lIdPersonnePhysique" 
					class="<%= CSS.DESIGN_CSS_MANDATORY_CLASS %>" ><%= personne.getName() %></button>
					<input class="dataType-notNull dataType-id dataType-id dataType-integer" 
						type="hidden" id="lIdPersonnePhysique"
						 name="lIdPersonnePhysique" value="<%= personne.getId() %>" />
				</td>
			</tr>		
	
		</table>
</div>
<div id="fiche_footer">

	<button type="submit" >Valid</button>
	<button type="button" onclick="javascript:doUrl('<%=
			response.encodeURL("displayDocument.jsp?lId=" + item.getIdGedDocument()) %>');" >
			Cancel</button>
	<%if(sAction.equals("store"))
	{ %>
	<button type="button" onclick="javascript:removeItem();">
			Delete</button>
	<%} %>
</div>
</form>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>
