<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@page import="org.coin.bean.organigram.OrganigramNodeType"%>
<%@page import="java.util.Vector"%>
<%@page import="org.coin.bean.ObjectType"%>
<%

	Vector<OrganigramNodeType> vOrganigramNodeType = OrganigramNodeType.getAllStatic();


%>
</head>
<body>
<div id="fiche">
<div class="dataGridHolder fullWidth">
        <table class="dataGrid fullWidth">
        <tr class="header">
            <td width="10px" >&nbsp;</td>
            <td width="10%" >Id</td>
            <td width="30%" >Nom</td>
            <td width="30%" >Description</td>
            <td width="30%" >Objet lié</td>
            <td width="20px">&nbsp;</td>
        </tr>
<%
	for(OrganigramNodeType item : vOrganigramNodeType)
	{
		ObjectType type = ObjectType.getObjectTypeMemory(item.getIdTypeObject() );
%>
        <tr >
            <td></td>
            <td><%= item.getId() %></td>
            <td><%= item.getName() %></td>
            <td><%= item.getDescription() %></td>
            <td><%= type.getName() %></td>
        </tr> 
<%    	
	}

%>        
        
</div>
</body>

</html>
