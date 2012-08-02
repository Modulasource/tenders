<%@page import="org.coin.bean.ged.GedDocumentRevision"%>
<%@page import="org.coin.bean.pki.certificate.signature.PkiCertificateSignature"%>
<%@page import="org.coin.bean.addressbook.IndividualActionType"%>
<%@page import="org.coin.bean.addressbook.IndividualActionState"%>
<%@page import="org.coin.bean.addressbook.IndividualAction"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="org.coin.bean.ged.GedConstant"%>
<%@page import="org.coin.bean.ged.GedDocumentType"%>
<%@page import="org.coin.bean.ged.GedFolderUtil"%>
<%@page import="org.coin.bean.ged.GedDocument"%>
<%@page import="org.coin.bean.ged.GedFolder"%>
<%@page import="org.coin.util.FileUtilBasic"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@include file="/include/new_style/headerJspUtf8.jspf" %>
<%@include file="/include/new_style/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath() +"/";
	HttpUtil.displayOnConsoleRequestParameters(request); // to show request parameters on console

	Connection conn = ConnectionManager.getConnection();
	
	GedDocument item = null;
	item=GedDocument.getGedDocument(HttpUtil.parseLong("lIdGedDocument",request));
	GedFolder folder = GedFolder.getGedFolder(item.getIdGedFolder());
	
	GedDocument docMain =new GedDocument();
	docMain.create();
	docMain.setIdGedFolder(folder.getId());    
    
    
	Iterator<?> iter = HttpUtil.getItemList(request);
	
	while (iter.hasNext()) {
	    FileItem itemField = (FileItem) iter.next();
    	if (!itemField.isFormField() && itemField.getSize()>0) {
            
            item.removeWithObjectAttachedAndFirstChild(conn);
            
    		docMain.setName(itemField.getName());
	        docMain.setDocumentName(itemField.getName());
	        docMain.setDocument(itemField.getInputStream());
	        docMain.setDocumentContentType(itemField.getContentType()); 
	        docMain.setDocumentLength(itemField.getSize());
	        docMain.store();
	        docMain.storeDocumentFile();
	        
	        
	    }
	}
	docMain.store(conn);
	//item.createThumbnail(item.getConnection());

	response.sendRedirect(
		response.encodeRedirectURL(
				rootPath + "desk/dropnsign/document/displayFolder.jsp"
					+ "?lId=" + docMain.getIdGedFolder()
				)
		);
%>      
        
        
        
        
        
        