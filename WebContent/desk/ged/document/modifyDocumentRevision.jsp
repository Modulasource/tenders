
<%@page import="org.coin.bean.conf.Configuration"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.fr.bean.Multimedia"%>
<%@page import="org.coin.bean.ged.GedDocumentRevisionSeal"%>
<%@page import="org.coin.bean.pki.certificate.signature.PkiCertificateSignature"%><%@page import="org.coin.servlet.ged.pdf.GedPdfUtil"%>
<%@page import="org.coin.fr.bean.MultimediaType"%>
<%@page import="org.coin.util.FileUtil"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="java.io.File"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.db.InputStreamDownloader"%>
<%@page import="org.apache.pdfbox.pdmodel.PDDocument"%>
<%@page import="org.coin.signature.pdf.Signature"%>
<%@page import="org.coin.signature.pdf.TextLocationFillSignature"%>
<%@page import="java.util.Vector"%>
<%@page import="org.coin.bean.ged.GedDocumentRevision"%>
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
	long lIdGedDocument = 0;
	Connection conn = ConnectionManager.getConnection();
	
	
	if (sAction.equals("remove"))
	{
		GedDocumentRevision item = GedDocumentRevision.getGedDocumentRevision(Integer.parseInt(request.getParameter("lId")));
		lIdGedDocument = item.getIdGedDocument();
		item.remove();
	}
	
	if (sAction.equals("generate"))
	{
		GedDocument document = GedDocument.getGedDocument(Integer.parseInt(request.getParameter("lIdGedDocument")));
		lIdGedDocument = document.getId();
		GedDocumentRevision.generateNewRevision(lIdGedDocument, true);
		
	}
	
	
	
    if (sAction.equals("removeSeal"))
    {
        PkiCertificateSignature certificateSignature 
	        = PkiCertificateSignature.getPkiCertificateSignature(
	        		HttpUtil.parseLong("lIdPkiCertificateSignature", request));

        
        Vector<PkiCertificateSignature> vPkiCertificateSignature = 
        	PkiCertificateSignature.getAllPkiCertificateSignature(
        			certificateSignature.getIdTypeObject(),
        			certificateSignature.getIdReferenceObject());
        
        /**
         * If there is only one left, we remove it
         */
        if(vPkiCertificateSignature.size() == 1){
            GedDocumentRevisionSeal seal 
	            = GedDocumentRevisionSeal.getGedDocumentRevisionSeal(
	                    certificateSignature.getIdReferenceObject());
            seal.remove();
        }
	        
        
        certificateSignature.remove();
        
        lIdGedDocument = Integer.parseInt(request.getParameter("lIdGedDocument"));
        
    }
	
	
	if (sAction.equals("generateWithTransformation"))
	{
		// TODO
	}
	
	
	if (sAction.equals("generatWithSignatureArray"))
	{
		GedDocument document = GedDocument.getGedDocument(Integer.parseInt(request.getParameter("lIdGedDocument")));
		GedPdfUtil.generatWithSignatureArray(document.getId(), conn);
		lIdGedDocument = document.getId();
		
	}
	
	if (sAction.equals("generatWithNewSignature"))
	{
		
		GedDocument document = GedDocument.getGedDocument(Integer.parseInt(request.getParameter("lIdGedDocument")));
		
		/**
		 * TODO mettre tout ca en variable
		 */
		String sMessage = "Le 13 juin à Paris\nLe directeur général adjoint au département des"
			+ " affaires sanitaires et sociales\n\n\n\nPablo VIDAL";	
		String  sFilenameImage =  "C:\\PDF\\transform\\signature2.jpg";
		String  sFontPathFilename = "C:\\PDF\\Resources\\ttf\\ArialMT.ttf";

		
		long lIdPersonnePhysiqueSigner = sessionUser.getIdIndividual();
        Multimedia multimediaSignatureScanned
             = Multimedia.getMultimediaFirstOccurence(
                 MultimediaType.TYPE_SCANNED_SIGNATURE, 
                 (int)lIdPersonnePhysiqueSigner, 
                 ObjectType.PERSONNE_PHYSIQUE, conn);
         
        String sPathPdfbox = Configuration.getConfigurationValueMemory("pdfbox.config.path", false);
        sFontPathFilename = sPathPdfbox + "Resources/ttf/ArialMT.ttf";
        
        sFilenameImage = multimediaSignatureScanned.getMultimediaFileTemp(conn).getAbsolutePath();
        
		GedPdfUtil.generatWithNewSignature(document.getId(), sMessage, sFilenameImage, sFontPathFilename, conn);
		lIdGedDocument = document.getId();
			 
	}
	
	
	
	if (sAction.equals("store"))
	{
		GedDocument item = GedDocument.getGedDocument(Integer.parseInt(request.getParameter("lId")));
		
		item.setFromForm(request, "");
		item.store();			
		lIdGedDocument = item.getIdGedFolder();
	}
	
	ConnectionManager.closeConnection(conn);
	
	response.sendRedirect(
			response.encodeRedirectURL("displayDocument.jsp?lId=" + lIdGedDocument ));
%>