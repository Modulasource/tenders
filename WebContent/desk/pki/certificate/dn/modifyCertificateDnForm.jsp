<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.html.*" %>
<%@page import="org.coin.bean.pki.certificate.PkiCertificateDn"%></html>
<% 
	String sTitle = "PkiCertificateDn : "; 


	PkiCertificateDn item = null;
	String sPageUseCaseId = "xxx";
	
	String sAction = request.getParameter("sAction");
	if(sAction.equals("create"))
	{
		item = new PkiCertificateDn();
		sTitle += "<span Type=\"altColor\">New PkiCertificateDn</span>"; 
	}
	
	if(sAction.equals("store"))
	{
		item = PkiCertificateDn.getPkiCertificateDn(Integer.parseInt(request.getParameter("lId")));
		sTitle += "<span Type=\"altColor\">"+item.getId()+"</span>"; 
	}

	HtmlBeanTableTrPave pave = new HtmlBeanTableTrPave();
	pave.bIsForm = true;
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);

%>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/VehicleType.js"></script>
</head>
<body>
<script type="text/javascript">
function removeItem()
{
    if(confirm("Do you want to delete this Type ?")){
    	PkiCertificateDn.removeFromId(<%= item.getId() %>,function() { 
            location.href = '<%= response.encodeURL("displayAllPkiCertificateDn.jsp") %>';
         });
     }
}
</script>


<%@ include file="/include/new_style/headerFiche.jspf" %>
<form action="<%= response.encodeURL("modifyCertificateDn.jsp") %>" method="post" name="formulaire">
<div id="fiche">
        <input type="hidden" name="lId" value="<%= item.getId() %>" />
		<input type="hidden" name="sAction" value="<%= sAction %>" />
		<table class="formLayout" cellspacing="3">
		<%= pave.getHtmlTrInput("Common Name :", "sCommonName", item.getCommonName(),"size=\"100\"") %>
		<%= pave.getHtmlTrInput("Organization Unit :", "sOrganizationUnit", item.getOrganizationUnit(),"size=\"100\"") %>
		<%= pave.getHtmlTrInput("Organization :", "sOrganization", item.getOrganization(),"size=\"100\"") %>
		<%= pave.getHtmlTrInput("Locality :", "sLocality", item.getLocality(),"size=\"100\"") %>
		<%= pave.getHtmlTrInput("State :", "sState", item.getState(),"size=\"100\"") %>
		<%= pave.getHtmlTrInput("Country Code :", "sCountryCode", item.getCountryCode(),"size=\"100\"") %>
		<%= pave.getHtmlTrInput("Email :", "sEmail", item.getEmail(),"size=\"100\"") %>

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
			response.encodeURL("displayAllCertificateDn.jsp") %>');" >
			Cancel</button>
</div>
</form>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>