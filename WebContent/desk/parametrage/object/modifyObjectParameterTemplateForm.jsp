<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.bean.param.*"%>
<%@ page import="org.coin.bean.html.*" %>
<% 
	String sTitle = "Object Type : "; 


	ObjectParameterTemplate item = null;
	String sPageUseCaseId = "xxx";
	
	String sAction = request.getParameter("sAction");
	if(sAction.equals("create"))
	{
		item = new ObjectParameterTemplate ();
		sTitle += "<span class=\"altColor\">New ObjectParameterTemplate </span>"; 
	}
	
	if(sAction.equals("store"))
	{
		item = ObjectParameterTemplate.getObjectParameterTemplate (Integer.parseInt(request.getParameter("lId")));
		sTitle += "<span class=\"altColor\">"+item.getId()+"</span>"; 
	}

	
	
    ObjectParameterTemplateState state = null;
    try {
        state = ObjectParameterTemplateState.getObjectParameterTemplateStateMemory(item.getIdObjectParameterTemplateState());
    } catch(Exception e) {
        e.printStackTrace();
        state = new ObjectParameterTemplateState();
    }


    ObjectParameterTemplateType type = null;
    try {
        type = ObjectParameterTemplateType.getObjectParameterTemplateTypeMemory(item.getIdObjectParameterTemplateType());
    } catch(Exception e) {
        e.printStackTrace();
        type= new ObjectParameterTemplateType();
    }
    
    ObjectType ot = null;
    try {
        ot = ObjectType.getObjectTypeMemory(item.getIdTypeObject());
    } catch(Exception e) {
        e.printStackTrace();
        ot = new ObjectType();
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
	if(confirm("Are you sure ?"))
	{
	    location.href = '<%= response.encodeURL("modifyObjectParameterTemplate.jsp?sAction=remove"
	        + "&lId=" + item.getId()) %>';
	}
}

function duplicateItem()
{
    location.href = '<%= response.encodeURL("modifyObjectParameterTemplate.jsp?sAction=duplicate"
        + "&lId=" + item.getId()) %>';
}

</script>

<%@ include file="/include/new_style/headerFiche.jspf" %>
<form action="<%= response.encodeURL("modifyObjectParameterTemplate.jsp") %>" method="post" name="formulaire">
<div id="fiche">
		<input type="hidden" name="sAction" value="<%= sAction %>" />
		<input type="hidden" name="lId" value="<%= item.getId() %>" />
		<table class="formLayout" cellspacing="3">
            <%= pave.getHtmlTrInput("Param Name :", "sParamName", item.getParamName(),"size=\"80\"") %>
            <%= pave.getHtmlTr("Name :", "<textarea name='sName' cols='80' >" + item.getName() + "</textarea>" ) %>
            <%= pave.getHtmlTrSelect("Type object :", "lIdTypeObject", ot) %>
            <%= pave.getHtmlTrSelect("Type :", "lIdObjectParameterTemplateType", type) %>
            <%= pave.getHtmlTrSelect("State :", "lIdObjectParameterTemplateState", state) %>
            <%= pave.getHtmlTrInput("Default value:", "sDefaultValue", item.getDefaultValue(),"size=\"80\"") %>
		</table>
</div>
<div id="fiche_footer">
	<button type="submit" ><%= localizeButton.getValueSubmit() %></button>
	<%if(sAction.equals("store"))
	{ %>
	<button type="button" onclick="javascript:removeItem();">
			<%= localizeButton.getValueDelete() %></button>
    <button type="button" onclick="javascript:duplicateItem();">
            <%= localizeButton.getValueDuplicate() %></button>
	<%} %>
	<button type="button" onclick="javascript:doUrl('<%=
            response.encodeURL("displayAllObjectParameterTemplate.jsp") %>');" >
            <%= localizeButton.getValueCancel() %></button>
</div>
</form>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>
