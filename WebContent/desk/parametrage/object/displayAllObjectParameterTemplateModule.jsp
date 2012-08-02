<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@page import="java.util.Vector"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.bean.param.ObjectParameterTemplate"%>
<%@page import="org.coin.db.CoinDatabaseAbstractBeanMemory"%>
<%@page import="org.coin.bean.param.ObjectParameterTemplateState"%>
<%@page import="org.coin.bean.param.ObjectParameterTemplateType"%>
<%@page import="org.coin.bean.param.ObjectParameterTemplateTypeValue"%>
<%@page import="org.coin.bean.param.ObjectParameterTemplateValue"%>
<%@page import="org.coin.bean.param.ObjectParameterTemplateModule"%>
<%
    String sTitle = "Display all Object Type";
	CoinDatabaseAbstractBeanMemory.populateMemoryStatic( new ObjectParameterTemplate());
	CoinDatabaseAbstractBeanMemory.populateMemoryStatic( new ObjectParameterTemplateState());
    CoinDatabaseAbstractBeanMemory.populateMemoryStatic( new ObjectParameterTemplateType());
    CoinDatabaseAbstractBeanMemory.populateMemoryStatic( new ObjectParameterTemplateTypeValue());
    CoinDatabaseAbstractBeanMemory.populateMemoryStatic( new ObjectParameterTemplateValue());
    CoinDatabaseAbstractBeanMemory.populateMemoryStatic( new ObjectParameterTemplateModule());
    CoinDatabaseAbstractBeanMemory.populateMemoryStatic( new ObjectParameterTemplateModulePackage());
    Vector<ObjectParameterTemplateModule> vItem = ObjectParameterTemplateModule.getAllStaticMemory();
%>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<div style="padding:15px">
    <div class="right">
        <button type="button" onclick="javascript:location.href='<%=
        response.encodeURL("modifyObjectParameterTemplateModuleForm.jsp?sAction=create") 
                %>';" >Add</button>
    </div>
    <br/>
    <div class="dataGridHolder fullWidth">
        <table class="dataGrid fullWidth">
        <tr class="header">
            <td>ID</td>
            <td>Name</td>
        </tr>
        <%
        for (int i=0; i < vItem.size(); i++) {
        	ObjectParameterTemplateModule item = vItem.get(i);
        	
        	
        %>
            <tr class="liste<%=i%2%>" 
                onmouseover="className='liste_over'" 
                onmouseout="className='liste<%=i%2%>'" 
                onclick="javascript:location.href='<%=
                    response.encodeURL("modifyObjectTypeForm.jsp?sAction=store&lId="+item.getId()) 
                    %>';">
                <td style="width:10%"><%= item.getId() %></td>
                <td style="width:20%;"><%= item.getName() %></td>
            </tr>
        <%
        }
        %>
        </table>
    </div>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>

<%@page import="org.coin.bean.param.ObjectParameterTemplateModulePackage"%></html>