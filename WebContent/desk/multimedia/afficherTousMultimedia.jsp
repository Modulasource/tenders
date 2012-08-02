<%@ include file="/include/new_style/headerDesk.jspf" %>

<%
	String sTitle = "Afficher multimédia";
	boolean bDisplayAddButton = true;
	String sUrlRedirect = "afficherTousMultimedia.jsp?foo=1" ;
	
	int iIdReferenceObjet = -1;
	int iIdTypeObjet = -1;
	try
	{
		iIdReferenceObjet = Integer.parseInt(request.getParameter("iIdReferenceObjet"));
		iIdTypeObjet = Integer.parseInt(request.getParameter("iIdTypeObjet"));
	}
	catch(Exception e){}
%>
</head>
<body>
<% 
	if(bDisplayAddButton )
	{
%>
<a href="modifierMultimediaForm.jsp?sAction=create&amp;iIdTypeObjet=<%= 
	iIdTypeObjet %>&amp;iIdReferenceObjet=<%=
	iIdReferenceObjet %>&amp;sUrlRedirect=<%=
	sUrlRedirect %>" >ajouter</a>
<%	}
	
	
	%>
	
	<jsp:include page="pave/paveAfficherTousMultimedia.jsp" flush="true" >
			<jsp:param name="sUrlRedirect" value="<%= sUrlRedirect %>" /> 
			<jsp:param name="iIdReferenceObjet" value="<%= iIdReferenceObjet %>" /> 
			<jsp:param name="iIdTypeObjet" value="<%= iIdTypeObjet %>" /> 
	</jsp:include>
</body>
</html>
