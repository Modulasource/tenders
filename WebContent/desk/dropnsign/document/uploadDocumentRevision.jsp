<%@page import="org.coin.bean.ged.GedDocumentRevision"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.coin.bean.ged.GedDocument"%>
<%@page import="org.coin.util.HttpUtil"%>
<%
	String rootPath = request.getContextPath() +"/";
	HttpUtil.displayOnConsoleRequestParameters(request);

	GedDocument item = GedDocument.getGedDocument(HttpUtil.parseLong("lIdGedDocument",request));
	
    Iterator<?> iter = HttpUtil.getItemList(request);
	while (iter.hasNext()) {
	    FileItem itemField = (FileItem) iter.next();
    	if (!itemField.isFormField() && itemField.getSize()>0) {
    		
    		GedDocumentRevision rev = GedDocumentRevision.generateNewRevision(item.getId(), false);
    		rev.setName(itemField.getName());
    		//rev.setDocumentName(itemField.getName());
    		rev.setDocument(itemField.getInputStream());
    		//rev.setDocumentContentType(itemField.getContentType()); 
    		//rev.setDocumentLength(itemField.getSize());
    		rev.store();
    		rev.storeDocumentFile();
	    }
	}
	//item.store();
	//item.createThumbnail(item.getConnection());

	response.sendRedirect(
		response.encodeRedirectURL(
				rootPath + "desk/dropnsign/document/displayFolder.jsp"
					+ "?lId=" + item.getIdGedFolder()
				)
		);
%>