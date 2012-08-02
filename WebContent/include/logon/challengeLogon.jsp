<%@page import="org.coin.bean.User"%>
<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%@page import="java.security.cert.X509Certificate"%>
<%@page import="org.coin.bean.pki.certificate.PkiCertificateType"%>
<%@page import="java.util.Vector"%>
<%@page import="org.coin.bean.pki.certificate.PkiCertificate"%>
<%@page import="org.coin.bean.pki.certificate.signature.PkiCertificateSignature"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.coin.security.PreventInjection"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@include file="/include/new_style/beanSessionUser.jspf" %>
<%	

	try{
		
		String s = (String)session.getAttribute("challengePassPhrase");
		session.setAttribute("challengePassPhrase", null);
		String sJsonPkiCertificateSignature 
			= PreventInjection.preventXML(request.getParameter("sJsonPkiCertificateSignature"));
	
		System.out.println("challengeLogon.jsp SESSION ID : " + session.getId());

		
		JSONObject data = new JSONObject(sJsonPkiCertificateSignature);
		PkiCertificateSignature item = new PkiCertificateSignature();
		item.setFromJSONObject(data);
		//item.bDisplayLogOnPromt = true;
		item.computeCertificate();
		item.computeDate();
		boolean bVerify = false;
		try {
			bVerify = item.verify(s);
		} catch (Exception ee) {
			ee.printStackTrace();
		}
		
		/*
		try {
			bVerify = item.verify(s + "_");
			System.out.println("2 bbb " + bVerifyb);
		} catch (Exception ee) {
			ee.printStackTrace();
		}
		*/

		if(bVerify){
			/**
			 * then the get challenge is OK
			 * now we have to retrieve the user associated to the certificate
			 */
			Vector<PkiCertificate> vPkiCertificate = PkiCertificate.getAllStatic();
			for(PkiCertificate cert : vPkiCertificate )
			{
				if(cert.isPublicKeyUserCertificate())
				{
					try {
						/**
						 * TODO : optimize db access
						 */
						cert.loadCertificateFile();
						X509Certificate certTemp = cert.getCertificate();
						if(certTemp.equals(item.getX509Certificate() ))
						{
							PersonnePhysique pp = PersonnePhysique.getPersonnePhysique(cert.getIdPersonnePhysique());
							sessionUser.setId(User.getIdUserFromIdIndividual(cert.getIdPersonnePhysique()));
							sessionUser.load();
							sessionUser.setAbstractBeanLocalization(sessionLanguage);

							sessionUser.setIsLogged(true);
							
							//System.out.println("challengeLogon.jsp SESSION ID : " + session.getId());
							//System.out.println("Login ok : " + sessionUser.getLogin());
							//System.out.println("certTemp : " + certTemp);
							
							break;
						}
					} catch (Exception eee) {
						eee.printStackTrace();
					}
				}
			}
		}
				
	} catch (Exception e) {
		e.printStackTrace();
	}
%>