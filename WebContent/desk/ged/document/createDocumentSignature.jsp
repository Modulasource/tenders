
<%@page import="org.coin.bean.ged.GedDocument"%>
<%@page import="org.coin.bean.ged.GedDocumentRevision"%>
<%@page import="java.util.Vector"%>
<%@page import="org.coin.bean.ged.GedFolderUtilPki"%>
<%@page import="org.coin.bean.pki.certificate.PkiCertificate"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="java.sql.Connection"%><%@ include file="/include/beanSessionUser.jspf"%>
<%


	String sPageUseCaseId = "IHM-DESK-xxx";
	// TODO : habilitation
	//sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
	long lIdReferenceObject = HttpUtil.parseLong("lIdReferenceObject", request);
	long lIdTypeObject = HttpUtil.parseLong("lIdTypeObject", request);
	boolean bIsSSPV = HttpUtil.parseBoolean("bIsSSPV", request, false);
    Connection conn = ConnectionManager.getConnection();
    
    
    %><%@ include file="include/createCertificateSignature.jspf"%><%

	
	ConnectionManager.closeConnection(conn);
%>