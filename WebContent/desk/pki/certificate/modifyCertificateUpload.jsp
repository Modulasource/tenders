<%@page import="java.security.KeyStore"%>
<%@page import="org.coin.security.CertificateUtil"%>
<%@page import="java.security.cert.X509Certificate"%>
<%@page import="org.coin.bean.pki.certificate.PkiCertificate"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="java.util.Iterator"%>

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
    PkiCertificate item = new PkiCertificate();
    item.create();
    
    String sDocName = "";
    
    Iterator<?> iter = HttpUtil.getItemList(request);
    while (iter.hasNext()) {
        FileItem itemField = (FileItem) iter.next();
        if (itemField.isFormField()) {

            item.setFromFormMultipart(itemField.getFieldName(), itemField.getString(), "");
            
        } else {
            if(itemField.getFieldName().equals("bytesCertificateFile"))
            {
                item.setCertificateFile(itemField.get());
                String sFilename = itemField.getName();
                item.setFilename(sFilename);
                item.updateIdPkiCertificateTypeFromFilename();
                
                
                // TODO : Content-Type
                //item.setContentType(itemField.getContentType()); 
                item.storeCertificateFile();
            }
    
        }
    }
    item.store();

    try{
        item.loadCertificateFile();
        X509Certificate cert = item.getCertificate();
        item.setDateValidityStart(cert.getNotBefore());
        item.setDateValidityEnd(cert.getNotAfter());
        item.setSerialNumber(cert.getSerialNumber().toString());
        item.setSignatureAlgorithm(cert.getSigAlgName());
        item.store();
        
        KeyStore ks = item.getKeyStore();
        item.setAlias(CertificateUtil.getFirstCertificateAliasInKeyStore(ks));
        item.store();
        
    } catch (Exception e) {
    	e.printStackTrace();
    }

    
    response.sendRedirect(
            response.encodeRedirectURL("displayCertificate.jsp" 
            		+ "?lId=" + item.getId()));
%>