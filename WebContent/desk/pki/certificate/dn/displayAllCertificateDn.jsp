<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@page import="java.util.Vector"%>
<%@page import="org.coin.bean.pki.certificate.PkiCertificateDn"%>
<%
    String sTitle = "Display all PkiCertificateDn";
    Vector<PkiCertificateDn> vType = PkiCertificateDn.getAllStatic();
%>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<div style="padding:15px">
    <div class="right">
        <button type="button" onclick="javascript:location.href='<%=
        response.encodeURL("modifyCertificateDnForm.jsp?sAction=create") 
                %>';" >Add</button>
    </div>
    <br/>
	<div class="dataGridHolder fullWidth">
		<table class="dataGrid fullWidth">
		<tr class="header">
		    <td>ID</td>
		    <td>Common Name</td>
		    <td>Organization Unit</td>
		    <td>Organization</td>
		    <td>Locality</td>
		    <td>State</td>
		    <td>Country Code</td>
		    <td>Email</td>
		</tr>
		<%
		for (int i=0; i < vType.size(); i++) {
			PkiCertificateDn item = vType.get(i);
		%>
		    <tr class="liste<%=i%2%>" 
		        onmouseover="className='liste_over'" 
		        onmouseout="className='liste<%=i%2%>'" 
		        onclick="javascript:location.href='<%=
		            response.encodeURL("modifyCertificateDnForm.jsp?sAction=store&lId="+item.getId()) 
		            %>';">
		        <td style="width:5%"><%= item.getId() %></td>
		        <td style="width:10%"><%= item.getCommonName() %></td>
		        <td style="width:10%"><%= item.getOrganizationUnit() %></td>
		        <td style="width:10%"><%= item.getOrganization() %></td>
		        <td style="width:10%"><%= item.getLocality() %></td>
		        <td style="width:5%"><%= item.getState() %></td>
		        <td style="width:5%"><%= item.getCountryCode() %></td>
		        <td style="width:10%"><%= item.getEmail() %></td>
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

