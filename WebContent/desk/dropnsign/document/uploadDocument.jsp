<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.coin.bean.ged.GedDocument"%>
<%@page import="org.coin.util.HttpUtil"%>
<%
	String rootPath = request.getContextPath() +"/";

	GedDocument item = new GedDocument();
	item.setIdGedFolder(HttpUtil.parseLong("lIdGedFolder",request));
	item.setName("uploaded file");
	item.create();
	
    Iterator<?> iter = HttpUtil.getItemList(request);
	while (iter.hasNext()) {
	    FileItem itemField = (FileItem) iter.next();
    	if (!itemField.isFormField() && itemField.getSize()>0) {
    		item.setName(itemField.getName());
	        item.setDocumentName(itemField.getName());
	        item.setDocument(itemField.getInputStream());
	        item.setDocumentContentType(itemField.getContentType()); 
	        item.setDocumentLength(itemField.getSize());
	        item.store();
	        item.storeDocumentFile();
	    }
	}
	item.store();
	//item.createThumbnail(item.getConnection());

	response.sendRedirect(
		response.encodeRedirectURL(
				rootPath + "desk/dropnsign/document/displayFolder.jsp"
					+ "?lId=" + item.getIdGedFolder()
				)
		);
%>