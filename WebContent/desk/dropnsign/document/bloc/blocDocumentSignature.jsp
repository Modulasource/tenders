<%@page import="org.coin.util.Outils"%>
<%@page import="java.io.File"%>
<%@page import="org.coin.bean.ged.GedDocumentRevision"%>
<%@page import="org.coin.bean.ged.GedDocument"%>
<%@page import="org.coin.util.CalendarUtil"%>
<%@page import="org.coin.security.CertificateUtil"%>
<%@page import="java.security.cert.X509Certificate"%>
<%@page import="org.coin.bean.pki.PkiSignatureAlgorithmType"%>
<%@page import="org.coin.bean.pki.certificate.signature.PkiCertificateSignatureType"%>
<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.bean.pki.certificate.signature.PkiCertificateSignature"%>
<%@page import="java.util.Vector"%>
<%@include file="/include/new_style/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath() + "/";
	GedDocument doc = (GedDocument) request.getAttribute("doc");
	Vector<GedDocumentRevision> vDocumentRevision = (Vector<GedDocumentRevision>) request.getAttribute("vDocumentRevision");
	Vector<PkiCertificateSignature> vSignature = (Vector<PkiCertificateSignature>)request.getAttribute("vSignature");
	
%>
<script type="text/javascript">
function removeSignature(lId)
{
	if(confirm("Etes vous sûr ?"))
	{
		doUrl("<%= response.encodeURL(
				rootPath + "desk/dropnsign/document/modifyDocument.jsp"
				+ "?lId=" + doc.getId()
				+ "&sAction=removeSignature"
				) %>"
			+ "&lIdPkiCertificateSignature=" + lId);
	}
}
</script>

<%
	if(vSignature .size() > 0)
	{
%>
<div id="signatureList_<%= doc.getId() %>" style="display: none;text-align: left;" class="overlay_action" >
	<table style="border: thin solid;">
		<tr>
		<th>Date</th>
		<th>Signer</th>
		<th>Type</th>
		<th>Type</th>
		<th>Certificat</th>
		<th>Revision</th>
		<th></th>
		</tr>
<%
		Vector<PersonnePhysique > vPersonnePhysique = new Vector<PersonnePhysique >();

		for(PkiCertificateSignature s : vSignature)
		{
	        PersonnePhysique ppSigner = null;
	        try{
	            ppSigner = PersonnePhysique.getOrLoadPersonnePhysique(
	                    s.getIdIndividual(), vPersonnePhysique);
	        } catch(Exception e ) {
	            ppSigner = new PersonnePhysique();
	        }
	        
	        PkiCertificateSignatureType csType 
	            = PkiCertificateSignatureType.getPkiCertificateSignatureTypeMemory(
	                    s.getIdPkiCertificateSignatureType());
	        
	        PkiSignatureAlgorithmType saType = 
	            PkiSignatureAlgorithmType.getPkiSignatureAlgorithmTypeMemory(
	                    s.getIdPkiSignatureAlgorithmType());
	        
	        X509Certificate certif = CertificateUtil.getCertificate(s.getCertificate());

	        /**
	         * Revision
	         */
	        String sRevision = GedDocumentRevision.getRevisionName(
	                s,
	                vDocumentRevision);
	         
	        /**
	         * Vérification
	         */
	        /**
	         * TODO
	        boolean bVerify = false;
	        String sIconVerification = rootPath;
	        String sIconVerificationAlt = "";
	        String sErrorMsg = "";
	        try{
	            File tempFile = hmFile.get(sRevision);
	            if(tempFile == null) {
	                 
	                tempFile = GedDocumentRevision.downloadFileTemp(
	                        sSubDirTemp, 
	                        certificateSignature,
	                        document,
	                        vGedDocumentRevision);
	                
	                hmFile.put(sRevision,tempFile);
	            }
	            bVerify = s.verify(tempFile);
	        } catch (Exception ee) {
	            ee.printStackTrace();
	            sErrorMsg = Outils.getTextToHtml(ee.getMessage()) ;
	        }

	        sIconVerification += (bVerify? Icone.ICONE_SUCCES : Icone.ICONE_ERROR);
	        sIconVerificationAlt = (bVerify? "signature ok" : ("signature erronée : " + sErrorMsg));

	        */
%>
		<tr>	
            <td><%= CalendarUtil.getFormatDateHeureStd( s.getDateCreation()) %></td>
            <td><%= ppSigner.getPrenomNom() %></td>
            <td><%= csType.getName() %></td>
            <td><%= saType.getName() %></td>
            <td>
                <b><%=  "délivré à" %></b> <%=  CertificateUtil.getCertificateSubjectInfoCN(certif) %>
                     (<%=  CertificateUtil.getCertificateSubjectInfoEmailAddress(certif)  %>)<br/>
                <b><%="délivré par" %></b> <%= CertificateUtil.getCertificateIssuerInfoCN(certif) %><br/>
                <b><%="expire le" %></b> <%= CalendarUtil.getFormatDateHeureStd(certif.getNotAfter()  ) %> <br/>
            </td>
            <td><%= sRevision %></td>
            <td>
            	<button onclick="removeSignature(<%= s.getId() %>);" >Remove</button>
            
            	<img style="cursor: pointer;"
                     src="<%= rootPath + "images/icons/file_locked.png" %>"
                     onclick="doUrl('<%= 
                           response.encodeURL(
                                   rootPath + "desk/PkiDownloadCertificateSignature?" 
                                   + "sAction=getSignature"
                                   + "&lId=" + s.getId()
                                   
                           ) %>');" 
                    alt="Télécharger la signature électronique" 
                    title="Télécharger la signature électronique" 
                    />

                <img style="cursor: pointer;"
                     src="<%= rootPath + "images/icons/page_white_key.png" %>"
                     onclick="doUrl('<%= 
                           response.encodeURL(
                                   rootPath + "desk/PkiDownloadCertificateSignature?" 
                                   + "sAction=getCertificate"
                                   + "&lId=" + s.getId()
                                   
                           ) %>');" 
                    alt="Télécharger le certificat" 
                    title="Télécharger le certificat" 
                    />
<%

    if(s.getIdPkiSignatureAlgorithmType() == PkiSignatureAlgorithmType.SIGNATURE_TYPE_PKCS7
    || s.getIdPkiSignatureAlgorithmType() == PkiSignatureAlgorithmType.SIGNATURE_TYPE_XMLDSIG
    )
    {
%>

                <img style="cursor: pointer;"
                     src="<%= rootPath + "images/icons/drive_key.png" %>"
                     onclick="doUrl('<%= 
                           response.encodeURL(
                                   rootPath + "desk/PkiDownloadCertificateSignature?" 
                                   + "sAction=getSignatureAttached"
                                   + "&lId=" + s.getId()
                                   + "&lIdGedDocument=" + doc.getId()
                           ) %>');" 
                    alt="Télécharger la signature attachée" 
                    title="Télécharger la signature attachée" 
                    />
                    
<%
    }
%>            	
            	
            </td>
		</tr>
<%	        
		}
%>	
	</table>
</div>
<%		
	}
%>

