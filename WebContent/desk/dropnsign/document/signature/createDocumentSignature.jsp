<%@page import="java.io.PrintWriter"%>
<%@page import="org.coin.bean.pki.certificate.signature.PkiCertificateSignatureState"%>
<%@page import="org.coin.bean.pki.certificate.signature.PkiCertificateSignature"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.coin.security.PreventInjection"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.bean.ged.GedDocument"%>
<%@page import="org.coin.bean.ged.GedDocumentRevision"%>
<%@page import="java.util.Vector"%>
<%@page import="org.coin.bean.ged.GedFolderUtilPki"%>
<%@page import="org.coin.bean.pki.certificate.PkiCertificate"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="java.sql.Connection"%>
<%@ include file="/include/beanSessionUser.jspf"%>
<%

	long lIdReferenceObject = HttpUtil.parseLong("lIdReferenceObject", request);
	long lIdTypeObject = HttpUtil.parseLong("lIdTypeObject", request);
    Connection conn = ConnectionManager.getConnection();
    
	String sJsonPkiCertificateSignature 
	= PreventInjection.preventXML(request.getParameter("sJsonPkiCertificateSignature"));
	
	JSONObject jsonPkiCertificateSignature = new JSONObject(sJsonPkiCertificateSignature);
	
	PkiCertificateSignature pkiCertificateSignature 
	    = PkiCertificateSignature.updateFromJSONObject(jsonPkiCertificateSignature);

	long lIdPkiOfSignedRevision = -1;
	try{
		lIdPkiOfSignedRevision = jsonPkiCertificateSignature.getLong("lIdPkiOfSignedRevision");
	} catch( Exception e) { }
	
    /**
     * lIdReferenceObject : provided by the JSP calling
     * lIdTypeObject : provided by the JSP calling
     */
     pkiCertificateSignature.setIdReferenceObject( lIdReferenceObject );
     pkiCertificateSignature.setIdTypeObject( lIdTypeObject );
     pkiCertificateSignature.setIdIndividual( HttpUtil.parseLong("lIdIndividual", request));
	
	pkiCertificateSignature.setIdPkiCertificateSignatureState(
	         HttpUtil.parseLong(
	             "lIdPkiCertificateSignatureState",
	             request,
	             PkiCertificateSignatureState.STATE_VALID));
	pkiCertificateSignature.setIdPkiCertificate( HttpUtil.parseLong("lIdPkiCertificate", request, 0));
	 
	pkiCertificateSignature.store(conn);
	
	//Write in the response the id of pkiCertificateSignature
    JSONObject jsonResponse = new JSONObject();
    jsonResponse.put("lId",pkiCertificateSignature.getId());
	PrintWriter out2 = response.getWriter();
    out2.println(jsonResponse.toString());
	
	ConnectionManager.closeConnection(conn);
%>