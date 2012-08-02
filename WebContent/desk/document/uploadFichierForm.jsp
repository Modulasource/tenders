<%@ include file="../../include/new_style/headerDesk.jspf" %>

<%
	String sTitle = "Modification du fichier";
	
	int iIdDocument = -1;
	try{iIdDocument = Integer.parseInt(request.getParameter("iIdDocument"));}
	catch (Exception e)	{}
	
	int iIdDocumentRedirect = -1;
	try{iIdDocumentRedirect = Integer.parseInt(request.getParameter("iIdDocumentRedirect"));}
	catch (Exception e)	{}
	
	String sAction = "";
	if(request.getParameter("sAction") != null)
		sAction = request.getParameter("sAction");
	
	int iIdDocumentType = -1;
	try{iIdDocumentType = Integer.parseInt(request.getParameter("iIdDocumentType"));}
	catch (Exception e)	{}
	
	int iIdOnglet = -1;
	try{iIdOnglet = Integer.parseInt(request.getParameter("iIdOnglet"));}
	catch (Exception e)	{}
	
	if(sAction.equalsIgnoreCase("create"))
		sTitle = "Ajout d'un fichier";
%>
</head>
<body>
<%@ include file="../../include/new_style/headerFiche.jspf" %>
<br/>
<form name="uploadFichier" method="post" action="<%=response.encodeURL("uploadFichier.jsp?sAction="+sAction+"&iIdDocument="+iIdDocument+"&iIdDocumentType="+iIdDocumentType+"&iIdDocumentRedirect="+iIdDocumentRedirect+"&iIdOnglet="+iIdOnglet)%>" enctype="multipart/form-data" >
<br/>
<table class="pave" style="text-align:center" summary="upload d'un fichier">
<tr><td>&nbsp;</td></tr>
<tr>
	<td>
		<input type="file" name="sFilePath" value="" size="50" />&nbsp;&nbsp;
	</td>
</tr>
<tr><td>&nbsp;</td></tr>
<tr>
	<td>
		<input type="submit" value="Télécharger" />&nbsp;
	</td>
</tr>
<tr><td>&nbsp;</td></tr>
</table>
</form>
<%@ include file="../../include/new_style/footerFiche.jspf" %>
</body>
</html>
