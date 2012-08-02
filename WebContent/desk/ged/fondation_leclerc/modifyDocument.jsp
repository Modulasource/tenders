<%@page import="mt.fondationleclerc.GedDocumentFondationLeclerc"%>

<%@page import="javax.mail.Authenticator"%>
<%@page import="java.io.File"%>
<%@page import="org.coin.util.FileUtil"%>
<%@page import="mt.modula.bean.mail.MailModula"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.bean.pki.certificate.signature.PkiCertificateSignature"%>
<%@page import="org.coin.bean.pki.PkiSignatureAlgorithmType"%><%@page import="org.coin.bean.ged.GedDocumentRevision"%>
<%@page import="java.util.Vector"%>
<%@page import="org.coin.util.StringUtil"%>
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
	String sUrlRedirect = "../fondation_leclerc/displayAllDocument.jsp?lId=";
	
	if (sAction.equals("createFromScan"))
	{
		GedDocument item = new GedDocument();
		lIdGedFolder = HttpUtil.parseInt("lIdGedFolder", request);
		item.setIdGedFolder(lIdGedFolder);
		item.setName("Create from scan"); 
		item.create();
		sUrlRedirect = "modifyDocumentForm.jsp?sAction=store&lId=" + item.getId();
	}	

	
	if (sAction.equals("removeAll"))
	{
		int[] arrId = HttpUtil.splitToIntArray("arrayId", ",", request);
		lIdGedFolder = GedDocument.getGedDocument( arrId[0]).getIdGedFolder();
        sUrlRedirect += lIdGedFolder;

        for (int i = 0; i < arrId.length; i++) {
			GedDocumentFondationLeclerc.removeWithObjectAttached(arrId[i]);
        }
	}
	
    if (sAction.equals("removeLastRevision"))
    {
        GedDocument item = GedDocument.getGedDocument( HttpUtil.parseInt("lId", request));
        lIdGedFolder = item.getIdGedFolder();
        item.removeLastRevision();
 
        sUrlRedirect = "displayDocument.jsp?lId=" + item.getId();
	}
	
	if (sAction.equals("remove"))
	{
		GedDocument item = GedDocument.getGedDocument( HttpUtil.parseInt("lId", request));
		lIdGedFolder = item.getIdGedFolder();
		item.removeWithObjectAttached();
		sUrlRedirect += lIdGedFolder;
	}
	
    if (sAction.equals("sendLastRevisionWithAllSignatureAttached"))
    {
    	GedDocument item = GedDocument.getGedDocument( HttpUtil.parseInt("lId", request));
    	long lIdPkiSignatureAlgorithmType = HttpUtil.parseLong("lIdPkiSignatureAlgorithmType", request);
    	PkiSignatureAlgorithmType type = PkiSignatureAlgorithmType.getPkiSignatureAlgorithmTypeMemory(
                lIdPkiSignatureAlgorithmType );
        
    	Connection conn = ConnectionManager.getConnection();
        byte[] bytesData = PkiCertificateSignature
            .getAllSignatureAttached(
            		item.getId(), 
                    lIdPkiSignatureAlgorithmType, 
                    conn);

        
        //Authenticator 
        
        
        String sFilenameOut = item.getLastDocumentName() + ".." + type.getFileExtension();
        File file = File.createTempFile("file_",sFilenameOut );
        FileUtil.writeFileWithData(file, bytesData);
        
        
        MailModula mail = new MailModula();
        mail.addAttachedFile(file, sFilenameOut);
        mail.addTo(request.getParameter("sEmailAdress"));
        mail.setFrom("francois.blanchard@matamore.com", "David KELLER");
        mail.setSubject("test de mail");
        mail.addMessage("Ceci est un test !");

        mail.send(conn);
        
        sUrlRedirect = "displayDocument.jsp?lId=" + item.getId();
        file.delete();
        ConnectionManager.closeConnection(conn);
    }
	
	if (sAction.equals("store"))
	{
		/**
		 * Here its a multipart/form-data
		 */
		String sPageUseCaseId = "IHM-DESK-FONDATION-LECLERC-GERER-DOCUMENTS";
		sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
		GedDocument item = GedDocument.getGedDocument(Integer.parseInt(request.getParameter("lId")));
		
		item.setFromForm(request, "");
		item.store();			
		lIdGedFolder = item.getIdGedFolder();
		sUrlRedirect += lIdGedFolder;
	}
	
	response.sendRedirect(
			response.encodeRedirectURL( sUrlRedirect ));
%>