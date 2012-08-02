<%@ include file="../../../include/new_style/headerDesk.jspf" %>

<%@page import="java.util.Vector"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.db.ObjectLocalization"%>
<%@page import="org.coin.fr.bean.Pays"%>
<%
    String sTitle = "Display all country";
    Vector<Pays> vPays = Pays.getAllStaticMemory();
   
%>
</head>
<body>
<%@ include file="../../../include/new_style/headerFiche.jspf" %>
<div style="padding:15px">
    <div class="right">
        <button type="button" onclick="javascript:location.href='<%=
        response.encodeURL("modifyPaysForm.jsp?sAction=create") 
                %>';" >Add</button>
    </div>
    <br/>
	<div class="dataGridHolder fullWidth">
		<table class="dataGrid fullWidth">
		<tr class="header">
		    <td>&nbsp;</td>
		    <td>ID</td>
		    <td>Name</td>
		    <td>Name (FR)</td>
		    <td>Name (EN)</td>
		</tr>
		<%
		for (int i=0; i < vPays.size(); i++) {
			Pays item = vPays.get(i);
			
			item.setAbstractBeanLocalization(Language.LANG_FRENCH);
			String sNameFr = item.getName();
			item.setAbstractBeanLocalization(Language.LANG_ENGLISH);
			String sNameEn = item.getName();
			
		%>
		    <tr class="liste<%=i%2%>" 
		        onmouseover="className='liste_over'" 
		        onmouseout="className='liste<%=i%2%>'" 
		        onclick="javascript:location.href='<%=
		            response.encodeURL("modifyPaysForm.jsp?sAction=store&sId="+item.getIdString()) 
		            %>';">
		        <td style="width:1%"><%= i+1 %></td>
		        <td style="width:10%"><%= item.getIdString() %></td>
		        <td style="width:30%;"><%= item.getName() %></td>
		        <td style="width:30%"><%= sNameFr %></td>
		        <td style="width:30%"><%= sNameEn %></td>
		    </tr>
		<%
		}
		%>
		</table>
	</div>
</div>
<%@ include file="../../../include/new_style/footerFiche.jspf" %>
</body>
</html>