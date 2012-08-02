<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.coin.bean.ged.GedDocument"%>
<%@page import="org.coin.bean.ged.GedFolder"%>
<%@page import="org.coin.bean.ged.GedFolderType"%>

<%@ include file="/include/beanSessionUser.jspf" %>
<%
	String sAction = request.getParameter("sAction");
	String rootPath = request.getContextPath()+"/";
	long lIdGedFolder = 0;
	
	/**
	 * Here its a multipart/form-data
	 */
	String sPageUseCaseId = "IHM-DESK-xxx";
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
	GedDocument item = new GedDocument();
	item.create();
	
	String sDocName = "";
	
	Iterator<?> iter = HttpUtil.getItemList(request);
	while (iter.hasNext()) {
	    FileItem itemField = (FileItem) iter.next();
    	if (itemField.isFormField()) {

    		item.setFromFormMultipart(itemField.getFieldName(), itemField.getString(), "");
    		
	    } else {
	    	if(itemField.getFieldName().equals("document"))
	    	{
	    		item.setDocumentName(itemField.getName());
	    		item.setDocument(itemField.getInputStream());
	    		// TODO : Content-Type
	    		//item.setContentType(itemField.getContentType()); 
	    		item.storeDocumentFile();
	    	}
    
	    }
	}
		
		
	//item.setFromForm(request, "");
	
	item.store();
	lIdGedFolder = item.getIdGedFolder();
	
	response.sendRedirect(
			response.encodeRedirectURL("../folder/displayFolder.jsp?lId=" + lIdGedFolder ));
%>