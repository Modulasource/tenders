<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.html.*" %>
<% 
	String sTitle = "Vehicle Type : "; 


    VehicleType item = null;
	String sPageUseCaseId = "xxx";
	
	String sAction = request.getParameter("sAction");
	if(sAction.equals("create"))
	{
		item = new VehicleType();
		sTitle += "<span Type=\"altColor\">New Type</span>"; 
	}
	
	if(sAction.equals("store"))
	{
		item = VehicleType.getVehicleTypeMemory(Integer.parseInt(request.getParameter("lId")));
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
         VehicleType.removeFromId(<%= item.getId() %>,function() { 
            location.href = '<%= response.encodeURL("displayAllVehicleType.jsp") %>';
         });
     }
}
</script>

<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<form action="<%= response.encodeURL("modifyVehicleType.jsp") %>" method="post" name="formulaire">
<div id="fiche">
        <input type="hidden" name="lId" value="<%= item.getId() %>" />
		<input type="hidden" name="sAction" value="<%= sAction %>" />
		<table class="formLayout" cellspacing="3">
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
			response.encodeURL("displayAllVehicleType.jsp") %>');" >
			Cancel</button>
</div>
</form>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>
<%@page import="mt.veolia.vfr.vehicle.VehicleType"%>
</html>
