<%@page import="org.coin.bean.pki.certificate.PkiCertificateGenerator"%>

<%@page import="org.coin.db.CoinDatabaseAbstractBean"%>
<%@page import="org.coin.util.FileUtil"%>
<%@page import="java.security.cert.X509Certificate"%><%@page import="org.coin.bean.pki.certificate.PkiCertificateType"%>
<%@page import="org.coin.bean.pki.certificate.PkiCertificate"%>

<%@ include file="/include/beanSessionUser.jspf" %>
<%
	String sAction = request.getParameter("sAction");
	String rootPath = request.getContextPath()+"/";

	if (sAction.equals("create"))
	{
		String sPageUseCaseId = "IHM-DESK-xxx";
		sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
		PkiCertificate item = new PkiCertificate();
		item = PkiCertificateGenerator.storeFromForm(item,request,"");
		PkiCertificateGenerator.generateCertificate(item);
	}
	
    if (sAction.equals("revoke"))
    {
        String sPageUseCaseId = "IHM-DESK-xxx";
        sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
        PkiCertificate item = PkiCertificate.getPkiCertificate(Integer.parseInt(request.getParameter("lId")));
        PkiCertificate crl = PkiCertificate.getPkiCertificate(Integer.parseInt(request.getParameter("crl")));
        PkiCertificateGenerator.revokeCertificate(item,crl);
    }
	
	
    if (sAction.equals("createPublicKeyCertificate"))
    {
        String sPageUseCaseId = "IHM-DESK-xxx";
        sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
        PkiCertificate item = PkiCertificate.getPkiCertificate(Integer.parseInt(request.getParameter("lId")));
        if(item.getIdPkiCertificateType() == PkiCertificateType.TYPE_PKCS12){
        	/**
        	 * c'est un PK12 on peut lui extraire le Certificat de clé publique
        	 */
        	item.loadCertificateFile();
            X509Certificate cert = item.getCertificateFromKeyStore();
            byte[] bytesCert = item.getCertificateEncodedFromKeyStore();

            item.setIdPkiCertificateType(PkiCertificateType.TYPE_CRT);
            item.setFilename(FileUtil.changeExtension(item.getFilename(),".crt"));
            item.setCertificateFile(bytesCert );
            item.create();
            item.storeCertificateFile();
        }
        
    }

	if (sAction.equals("remove"))
	{
		PkiCertificate item = PkiCertificate.getPkiCertificate(Integer.parseInt(request.getParameter("lId")));
		item.remove();
	}
	
	response.sendRedirect(
			response.encodeRedirectURL("displayAllCertificate.jsp"));
%>