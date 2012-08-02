<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.html.*" %>
<%@page import="org.coin.bean.pki.certificate.PkiCertificateType"%>
<% 
	String sTitle = "PkiCertificateType : "; 


	PkiCertificateType item = null;
	String sPageUseCaseId = "xxx";
	
	String sAction = request.getParameter("sAction");
	if(sAction.equals("create"))
	{
		item = new PkiCertificateType();
		sTitle += "<span Type=\"altColor\">New Type</span>"; 
	}
	
	if(sAction.equals("store"))
	{
		item = PkiCertificateType.getPkiCertificateType(Integer.parseInt(request.getParameter("lId")));
		sTitle += "<span Type=\"altColor\">"+item.getId()+"</span>"; 
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
    if(confirm("Do you want to delete this Type ?")){
    	PkiCertificateType.removeFromId(<%= item.getId() %>,function() { 
            location.href = '<%= response.encodeURL("displayAllCertificateType.jsp") %>';
         });
     }
}
</script>

<%@ include file="/include/new_style/headerFiche.jspf" %>
<form action="<%= response.encodeURL("modifyCertificateType.jsp") %>" method="post" name="formulaire">
<div id="fiche">
        <input type="hidden" name="lId" value="<%= item.getId() %>" />
		<input type="hidden" name="sAction" value="<%= sAction %>" />
		<table class="formLayout" cellspacing="3">
		<%= pave.getHtmlTrInput("Name :", "sName", item.getName(),"size=\"100\"") %>
			<tr>
				<td class="pave_cellule_gauche">Description :</td>
				<td class="pave_cellule_droite">
					<textarea cols="97" rows="5" name="sDescription"><%= 
						item.getDescription() %></textarea></td>
			</tr>
		</table>
</div>
<div id="fiche_footer">
	<button type="submit" ><%= localizeButton.getValueSubmit() %></button>
	<%if(sAction.equals("store"))
	{ %>
	<button type="button" onclick="javascript:removeItem();">
			<%= localizeButton.getValueDelete()%></button>
	<%} %>
	<button type="button" onclick="javascript:doUrl('<%=
		response.encodeURL("displayAllCertificateType.jsp") %>');" >
		<%= localizeButton.getValueCancel() %></button>
</div>
</form>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>

</html>
