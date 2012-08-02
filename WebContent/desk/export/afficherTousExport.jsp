<%@ include file="../../include/new_style/headerDesk.jspf" %>

<%
	String sTitle = "Afficher multimédia";
	boolean bDisplayAddButton = true;
	String sUrlRedirect = "afficherTousExport.jsp?foo=1" ;
	int iIdTypeObjetSource = 3;
	int iIdObjetReferenceSource = 22;
	
%>
</head>
<body>
<%@ include file="../../include/new_style/headerFiche.jspf" %>
<br/>
<div style="padding:15px">
<% 
	if(bDisplayAddButton )
	{
%>
<a href="<%= response.encodeURL("modifierExportForm.jsp?sAction=create"
	+ "&amp;iIdTypeObjetSource=" + iIdTypeObjetSource 
	+ "&amp;iIdObjetReferenceSource=" + iIdObjetReferenceSource 
	+ "&amp;sUrlRedirect=" + sUrlRedirect ) %>" >ajouter</a>
<%	}
	
	
	%>
	
	<jsp:include page="pave/paveAfficherTousExport.jsp" flush="true" >
			<jsp:param name="sUrlRedirect" value="<%= sUrlRedirect %>" /> 
			<jsp:param name="iIdObjetReferenceSource" value="<%= iIdObjetReferenceSource %>" /> 
			<jsp:param name="iIdTypeObjetSource" value="<%= iIdTypeObjetSource %>" /> 
	</jsp:include>
</div>
<%@ include file="../../../include/new_style/footerFiche.jspf" %>
</body>
</html>
