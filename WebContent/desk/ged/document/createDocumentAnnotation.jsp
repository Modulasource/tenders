
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="java.sql.Connection"%><%@page import="java.io.File"%>
<%@page import="org.coin.util.FileUtil"%>
<%@page import="org.coin.bean.conf.Configuration"%>
<%@page import="sun.misc.BASE64Decoder"%>
<%@page import="org.coin.bean.ged.GedDocumentAnnotation"%>
<%@page import="org.coin.bean.ObjectType"%>

<%@ include file="/include/beanSessionUser.jspf"%>
<%
	String sPageUseCaseId = "IHM-DESK-xxx";
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
	
	Connection conn = ConnectionManager.getConnection();
	
	GedDocumentAnnotation annotation = new GedDocumentAnnotation();
    annotation.setIdPersonnePhysique( Long.parseLong(request.getParameter("lIdIndividual")));
    annotation.setIdGedDocument( Long.parseLong(request.getParameter("lIdGedDocument")));
    String sTextBase64 =  request.getParameter("sTextBase64");
    BASE64Decoder decoder = new BASE64Decoder();
    String sText = null ;
    
    String sEncoding = Configuration.getConfigurationValueMemory("server.applet.decoding", "") ;
    //sEncoding = "ISO-8859-1";
    sEncoding = "UTF-8";
    //sEncoding = "";
    
    byte[] bytesTextBase64 = decoder.decodeBuffer(sTextBase64) ;
    //FileUtil.writeFileWithData(new File("d:\\toto_utf8.txt"), bytesTextBase64);

    /*
    if(sEncoding != null && !sEncoding .equals(""))
    {
    	sText = new String( bytesTextBase64, sEncoding) ;
    } else {
        sText = new String( bytesTextBase64 ) ;
    }
    System.out.println("sEncoding : " + sEncoding );
    System.out.println("sText :\n" + sText );
    */
    
    annotation.bUseFieldValueFilter = false;
    annotation.bUseHttpPrevent = false;
    annotation.setAnnotationBytes( bytesTextBase64);
    annotation.create();
	
    long lIdReferenceObject = annotation.getId();
    long lIdTypeObject = ObjectType.GED_DOCUMENT_ANNOTATION;

    boolean bIsSSPV = false;
%><%@ include file="include/createCertificateSignature.jspf"%>
<%
	ConnectionManager.closeConnection(conn);
%>