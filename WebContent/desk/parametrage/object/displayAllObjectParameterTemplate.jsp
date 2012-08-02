<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@page import="java.util.Vector"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.bean.param.ObjectParameterTemplate"%>
<%@page import="org.coin.db.CoinDatabaseAbstractBeanMemory"%>
<%@page import="org.coin.bean.param.ObjectParameterTemplateState"%>
<%@page import="org.coin.bean.param.ObjectParameterTemplateType"%>
<%@page import="org.coin.bean.param.ObjectParameterTemplateTypeValue"%>
<%@page import="org.coin.bean.param.ObjectParameterTemplateValue"%>
<%@page import="org.coin.util.HttpUtil"%>
<%
    String sTitle = "Display all Object Type";
	CoinDatabaseAbstractBeanMemory.populateMemoryStatic( new ObjectParameterTemplate());
	CoinDatabaseAbstractBeanMemory.populateMemoryStatic( new ObjectParameterTemplateState());
    CoinDatabaseAbstractBeanMemory.populateMemoryStatic( new ObjectParameterTemplateType());
    CoinDatabaseAbstractBeanMemory.populateMemoryStatic( new ObjectParameterTemplateTypeValue());
    CoinDatabaseAbstractBeanMemory.populateMemoryStatic( new ObjectParameterTemplateValue());
    Vector<ObjectParameterTemplate> vItem = ObjectParameterTemplate.getAllWithWhereAndOrderByClauseStatic("", "ORDER BY id_type_object, param_name asc");

    ObjectType otSearch= new ObjectType();
    long lIdObjectType = HttpUtil.parseLong("lIdObjectType", request, 0);
    
    try{
    	otSearch = ObjectType.getObjectType(lIdObjectType);
    } catch (Exception e ) {
    	otSearch = new ObjectType();
    }
    
%>
<script type="text/javascript">
function doSearch()
{
    doUrl("<%= response.encodeURL("displayAllObjectParameterTemplate.jsp")  %>"
    	    + "?lIdObjectType=" + $("lIdObjectType").value);
}
</script>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<div style="padding:15px">
    <div class="right">
        <%= otSearch.getAllInHtmlSelect("lIdObjectType",true)
        %>
        <button type="button" onclick="javascript:doSearch();" >Search</button>
    
        <button type="button" onclick="javascript:location.href='<%=
        response.encodeURL("modifyObjectParameterTemplateForm.jsp?sAction=create") 
                %>';" >Add</button>
    </div>
    <br/>
    <div class="dataGridHolder fullWidth">
        <table class="dataGrid fullWidth">
        <tr class="header">
            <td>Object type</td>
            <td>Param Name</td>
            <td>Name</td>
            <td>Type</td>
            <td>State</td>
            <td>Default value</td>
        </tr>
        <%
        for (int i=0; i < vItem.size(); i++) {
        	ObjectParameterTemplate item = vItem.get(i);
        	
        	if(lIdObjectType > 0 && lIdObjectType != item.getIdTypeObject())
        	{
        		continue;
        	}
        	
        	ObjectType ot = null;
        	try {
        		ot = ObjectType.getObjectTypeMemory(item.getIdTypeObject());
        	} catch(Exception e) {
        		e.printStackTrace();
        		ot = new ObjectType();
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


        %>
            <tr class="liste<%=i%2%>" 
                onmouseover="className='liste_over'" 
                onmouseout="className='liste<%=i%2%>'" 
                onclick="javascript:location.href='<%=
                    response.encodeURL("modifyObjectParameterTemplateForm.jsp?sAction=store&lId="+item.getId()) 
                    %>';">
                <td style="width:10%;"><%= ot.getName() %></td>
                <td style="width:40%;"><%= item.getParamName() %></td>
                <td style="width:20%;"><%= item.getName() %></td>
                <td style="width:10%;"><%= type.getName() %></td>
                <td style="width:10%;"><%= state.getName() %></td>
                <td style="width:10%;"><%= item.getDefaultValue() %></td>
            </tr>
        <%
        }
        %>
        </table>
    </div>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>