<%@page import="org.coin.util.FileUtil"%>
<%@page import="java.io.File"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.bean.ged.GedDocumentRevision"%>
<%@page import="org.coin.bean.pki.certificate.PkiCertificate"%>
<%@page import="org.coin.bean.pki.certificate.signature.PkiCertificateSignatureState"%>
<%@page import="org.coin.bean.pki.certificate.signature.PkiCertificateSignature"%>
<%@page import="org.coin.bean.ged.GedDocumentAnnotation"%>
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
	
	if (sAction.equals("remove"))
	{
	    GedDocumentAnnotation item 
          = GedDocumentAnnotation.getGedDocumentAnnotation(
                  Integer.parseInt(request.getParameter("lId")));
		/**
		 * remove signature
		 */
		 PkiCertificateSignature certificateSignature = null;
         try{
             certificateSignature = PkiCertificateSignature.getPkiCertificateSignature(
                     ObjectType.GED_DOCUMENT_ANNOTATION,
                     item.getId()); 
             certificateSignature.remove();
         } catch (Exception e ) {}
		 

		lIdGedDocument = item.getIdGedDocument();
		item.remove();
	}

	if (sAction.equals("create"))
	{
		GedDocumentAnnotation item = new GedDocumentAnnotation();
		item.setFromForm(request, "");
		item.create();			
		lIdGedDocument = item.getIdGedDocument();
	}
	
	
    if (sAction.equals("createSignServer"))
    {
    	GedDocumentAnnotation item = GedDocumentAnnotation.createAnnotationServerSign(request);
    	lIdGedDocument = item.getIdGedDocument();

    }

	
	if (sAction.equals("store"))
	{
		/**
		 * Here its a multipart/form-data
		 */
		String sPageUseCaseId = "IHM-DESK-xxx";
		sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
		GedDocumentAnnotation item
		  = GedDocumentAnnotation.getGedDocumentAnnotation(
				  Integer.parseInt(request.getParameter("lId")));
		
		item.setFromForm(request, "");
		item.store();			
		lIdGedDocument = item.getIdGedDocument();
	}
	
	response.sendRedirect(
			response.encodeRedirectURL("displayDocument.jsp?lId=" + lIdGedDocument ));
%>