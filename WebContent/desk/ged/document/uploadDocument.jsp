<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.coin.bean.ged.GedDocument"%>
<%@page import="org.coin.bean.ged.GedFolder"%>
<%@page import="org.coin.bean.ged.GedFolderType"%>

<%@ include file="/include/beanSessionUser.jspf"%>
<%
	
	/**
	 * Here its a multipart/form-data
	 */
	String sPageUseCaseId = "IHM-DESK-xxx";
	//sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
	
	String sAction = HttpUtil.parseString("sAction", request, "");
	
	GedDocument item = GedDocument.getGedDocument(HttpUtil.parseLong("lId",request));
    	
    Iterator<?> iter = HttpUtil.getItemList(request);
	while (iter.hasNext()) {
	    FileItem itemField = (FileItem) iter.next();
    	if (!itemField.isFormField() && itemField.getSize()>0) {
	        item.setDocumentName(itemField.getName());
	        item.setDocument(itemField.getInputStream());
	        item.setDocumentContentType(itemField.getContentType()); 
	        item.setDocumentLength(itemField.getSize());
	        item.store();
	        item.storeDocumentFile();
	    }
	}
	item.store();
	item.createThumbnail(item.getConnection());
	
	if (sAction.equals("modify")){ 
		String sReturnMessage = "Fichier correctement envoyé.";
		int iCode = 1;
	%>
		<html>
		<head>
		<script type="text/javascript">
		parent.onUploadDone(<%=iCode%>, "<%= sReturnMessage %>");
		</script>
		</head>
		<body></body>
		
		</html>
<% } %>