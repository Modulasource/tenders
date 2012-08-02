<%@page import="java.util.Vector"%>
<%@page import="java.io.File"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="org.coin.bean.ged.GedDocumentRevisionSeal"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.bean.ged.GedDocument"%>
<%@page import="org.coin.bean.ged.GedDocumentRevision"%>
<%@page import="org.coin.security.token.SignProcess"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.util.FileUtil"%>
<%@page import="org.coin.bean.pki.certificate.PkiCertificate"%>
<%@page import="org.coin.bean.pki.certificate.signature.PkiCertificateSignatureState"%>
<%@page import="org.coin.bean.pki.certificate.signature.PkiCertificateSignature"%>

<%@ include file="/include/beanSessionUser.jspf" %>
<%
	String sAction = request.getParameter("sAction");
	String rootPath = request.getContextPath()+"/";
    PkiCertificateSignature item = null;
	long lIdGedDocument = 0;
    String sSubDirTemp = "" + System.currentTimeMillis();
	
	if(sAction.equals("remove")) {
	 	item = PkiCertificateSignature.getPkiCertificateSignature(
	 		   HttpUtil.parseLong("lId", request)); 	
	 	item.remove();
	 	lIdGedDocument = HttpUtil.parseLong("lIdGedDocument", request);
	}
	
	
   if(sAction.equals("sealLastRevisionServer")) {
	   lIdGedDocument = HttpUtil.parseLong("lIdGedDocument", request);
	   
	   GedDocumentRevisionSeal seal = new GedDocumentRevisionSeal();
	   seal.setFromForm(request,"");
	   seal.create();
	   
	   
        item = new PkiCertificateSignature();
        /**
         * Init from HTTP Request 
         */
        item.setIdReferenceObject(seal.getId());
        item.setIdTypeObject( ObjectType.GED_DOCUMENT_REVISION_SEAL);
        item.setIdIndividual( HttpUtil.parseLong("lIdPersonnePhysique", request));
        item.setIdPkiSignatureAlgorithmType(
                HttpUtil.parseLong("lIdPkiSignatureAlgorithmType",
                request));
        
        item.setIdPkiCertificateSignatureType(
                HttpUtil.parseLong("lIdPkiCertificateSignatureType",
                request));
        
        item.setIdPkiCertificateSignatureState(
                 HttpUtil.parseLong("lIdPkiCertificateSignatureState",
                 request,
                 PkiCertificateSignatureState.STATE_VALID));
        
        item.setIdPkiCertificate( HttpUtil.parseLong("lIdPkiCertificate", request, 0));

        /**
         * Init PkiCertificate
         */
        PkiCertificate pkiCertificate = PkiCertificate.getPkiCertificate(item.getIdPkiCertificate());
        pkiCertificate.loadCertificateFile(); 
        
        /**
         * init PkiCertificateSignature
         */
        item.setIdPkiCertificate(pkiCertificate.getId());

        /**
         * Get the file in GED 
         */
        GedDocument document = GedDocument.getGedDocument(lIdGedDocument);
        
        Vector<GedDocumentRevision> vGedDocumentRevision 
         =  GedDocumentRevision.getAllFromGedDocumentOrdered(document.getId(), "DESC");
 
         File tempFileDocument = GedDocumentRevision.downloadFileTemp(
                     sSubDirTemp, 
                     seal.getIdGedDocumentRevisionChild(),
                     document,
                     vGedDocumentRevision);

         File tempFileDocumentParent = GedDocumentRevision.downloadFileTemp(
                     sSubDirTemp, 
                     seal.getIdGedDocumentRevisionParent(),
                     document,
                     vGedDocumentRevision);
         
        /**
         * Seal
         */
        item.seal(pkiCertificate, tempFileDocument, tempFileDocumentParent);
        item.create();
        
        
        /**
         * verify
         */
        item.load();
        try{
        	item.bDisplayLogOnPromt=true;
            item.verifySealing(tempFileDocument, tempFileDocumentParent);
        } catch (Exception e) {
            e.printStackTrace();
            //item.remove();
        }
        item.bDisplayLogOnPromt=false;
        
        /**
         * Release temp resources
         */
         FileUtil.deleteDirectory(tempFileDocument.getParent());
         FileUtil.deleteDirectory(tempFileDocumentParent.getParent());
                         
        
    }
	
    if(sAction.equals("createServer")) {
        lIdGedDocument = HttpUtil.parseLong("lIdGedDocument", request);
        
    	item = new PkiCertificateSignature();
    	/**
    	 * Init from HTTP Request 
    	 */
        item.setIdReferenceObject(HttpUtil.parseLong("lIdReferenceObject", request));
        item.setIdTypeObject(HttpUtil.parseLong("lIdTypeObject", request));
	   	item.setIdIndividual( HttpUtil.parseLong("lIdPersonnePhysique", request));
	   	item.setIdPkiSignatureAlgorithmType(
                HttpUtil.parseLong("lIdPkiSignatureAlgorithmType",
                request));
        
        item.setIdPkiCertificateSignatureType(
                HttpUtil.parseLong("lIdPkiCertificateSignatureType",
                request));
        
	    item.setIdPkiCertificateSignatureState(
	             HttpUtil.parseLong("lIdPkiCertificateSignatureState",
	             request,
	             PkiCertificateSignatureState.STATE_VALID));
	    
	    item.setIdPkiCertificate( HttpUtil.parseLong("lIdPkiCertificate", request, 0));

	    /**
	     * Init PkiCertificate
	     */
	    PkiCertificate pkiCertificate = PkiCertificate.getPkiCertificate(item.getIdPkiCertificate());
	    pkiCertificate.loadCertificateFile(); 
	    
	    /**
         * init PkiCertificateSignature
         */
        item.setIdPkiCertificate(pkiCertificate.getId());

        /**
         * Get the file in GED 
         */
        GedDocument document = GedDocument.getGedDocument(lIdGedDocument);
        
        Vector<GedDocumentRevision> vGedDocumentRevision 
             =  GedDocumentRevision.getAllFromGedDocumentOrdered(document.getId(), "DESC");
        
        File fileDocument = GedDocumentRevision.downloadFileTemp(
                        sSubDirTemp, 
                        item,
                        document,
                        vGedDocumentRevision);
        
        System.out.println("fileDocument : " + fileDocument);
        
        /**
         * Sign
         */
        item.sign(pkiCertificate, fileDocument);
        item.create();
        
        
        /**
         * verify
         */
        item.load();
        try{
            item.verify(fileDocument);
        } catch (Exception e) {
        	e.printStackTrace();
        	//item.remove();
        }
        
        /**
         * Release temp ressources
         */
        fileDocument.delete();
        

    }
	    
	
	response.sendRedirect(
			response.encodeRedirectURL("displayDocument.jsp?lId=" + lIdGedDocument ));
%>