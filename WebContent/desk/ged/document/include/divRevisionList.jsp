<%@ include file="/include/new_style/beanSessionUser.jspf" %>
<%@page import="org.coin.bean.ged.*"%>
<%@page import="java.util.*"%>
<%@page import="modula.graphic.Icone"%>
<%@page import="org.coin.bean.pki.certificate.signature.*"%>
<%@page import="org.coin.fr.bean.*"%>
<%@page import="org.coin.bean.pki.PkiSignatureAlgorithmType"%>
<%@page import="org.coin.security.CertificateUtil"%>
<%@page import="org.coin.util.CalendarUtil"%>
<%@page import="java.io.File"%>
<%@page import="java.security.cert.X509Certificate"%>
<%@page import="org.coin.db.CoinDatabaseLoadException"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.util.FileUtil"%>
<%@page import="org.coin.db.CoinDatabaseWhereClause"%>
<%@page import="org.coin.localization.Localize"%>
<%@page import="org.coin.localization.LocalizeButton"%>

<div id="divRevisionList" style="" >
<%
	Localize locTitle = (Localize) request.getAttribute ("locTitle");
	Localize locButton = (Localize) request.getAttribute ("locButton");
	Localize locMessage = (Localize) request.getAttribute ("locMessage");
	
	LocalizeButton localizeButton = new LocalizeButton (request);
	GedDocumentRevision revisionLoc = new GedDocumentRevision ();
	revisionLoc.setAbstractBeanLocalization(sessionLanguage);
	PkiCertificateSignature pkiCertificateSignatureLoc = new PkiCertificateSignature ();
	pkiCertificateSignatureLoc.setAbstractBeanLocalization (sessionLanguage);
	
	Vector<GedDocumentRevision> vGedDocumentRevision = (Vector<GedDocumentRevision>)request.getAttribute("vGedDocumentRevision");
	String rootPath = (String) request.getAttribute("rootPath");
	GedDocument item = (GedDocument) request.getAttribute("item");
	Vector<PersonnePhysique> vPersonnePhysique = (Vector<PersonnePhysique>) request.getAttribute("vPersonnePhysique");
	HashMap<String, File> hmFile = (HashMap<String, File>) request.getAttribute("hmFile");
	String sSubDirTemp = (String) request.getAttribute("sSubDirTemp");
	
	for(GedDocumentRevision rev : vGedDocumentRevision )
	{
%>
<%= rev.getRevisionLabel() %><br/>
<%	
	}


    if(vGedDocumentRevision.size() == 0) 
    {
%>

    <div class="dataGridHolder fullWidth">
        <table class="dataGrid fullWidth">
        <tr class="header">
            <td>
                <%=locMessage.getValue (35, "Ce document n'est pas en mode révision") %>
            </td>
        </tr>
        <tr class="liste0" >
            <td>
                <button onclick="javascript:generateRevision()" ><%=locButton.getValue (33, "Rendre le document révisable")%></button>
            </td>
        </tr>
        </table>
    </div>

<%
    } else {
%>
    <div class="dataGridHolder fullWidth">
        <table class="dataGrid fullWidth">
        <tr class="header">
            <td>
                  <input type="checkbox" id="selectedDocumentRevisionAll" onclick="updateAllDocumentRevisionSelected()"/> 
            </td>
            <td><%=revisionLoc.getRevisionLabelLabel ()%></td>
            <td><%=revisionLoc.getIdGedDocumentRevisionParentLabel ()%></td>
            <td>&nbsp;</td>
            <td><%=locTitle.getValue (70, "Scellés")%></td>

        </tr>
<%
        
        System.out.println("vGedDocumentRevision.size() " + vGedDocumentRevision.size());
        
        Vector<GedDocumentRevisionSeal> vGedDocumentRevisionSealAll 
                  = GedDocumentRevisionSeal.getAllFromGedDocument(vGedDocumentRevision);
        

        Vector< PkiCertificateSignature> vPkiCertificateSignatureSealAll
        = GedDocumentRevisionSeal.getAllPkiCertificateSignatureFromGedDocument(
        		vGedDocumentRevision,
        		vGedDocumentRevisionSealAll);
        
        
        for (int i=0; i < vGedDocumentRevision.size(); i++) {
            GedDocumentRevision revision = vGedDocumentRevision.get(i);
            GedDocumentRevision revisionParent = GedDocumentRevision.getRevisionParent(revision, vGedDocumentRevision);
            
            Vector<GedDocumentRevisionSeal> vGedDocumentRevisionSeal 
             = GedDocumentRevisionSeal.getAllFromDocumentRevision(
                     revision.getId(),
                     revisionParent.getId(),
                     vGedDocumentRevisionSealAll);
            
            


        %>
            <tr class="liste<%=i%2%>" >
                <td style="width:1%">
                    <input type="checkbox" class="selectedDocumentRevision" value="<%= revision.getId() %>" />
                </td>
                <td style="width:5%"><%= revision.getRevisionLabel() %></td>
                <td style="width:5%"><%= revisionParent.getRevisionLabel() %></td>
                <td style="width:5%">
                        <img
                            onclick="doUrl('<%=
                                response.encodeURL(rootPath 
                                		+ "desk/GedDocumentRevisionDownloadServlet?lId="+revision.getId()) 
                                %>')";
                            alt="<%=localizeButton.getValueDownload ()%>" 
                            title="<%=localizeButton.getValueDownload ()%>" 
                            src="<%=rootPath 
                            + Icone.ICONE_DOWNLOAD_NEW_STYLE %>"  />

<%
	if(sessionUserHabilitation.isSuperUser())
	{
%>
                        <img
                            onclick="doUrl('<%=
                                response.encodeURL(
                                		"modifyDocumentRevisionForm.jsp?sAction=store&lId="+revision.getId()) 
                                %>')";
                            alt="<%=localizeButton.getValueDownload ()%>" 
                            title="<%=localizeButton.getValueDownload ()%>" 
                            src="<%=rootPath 
                            + Icone.ICONE_FICHIER_DEFAULT_NEW_STYLE %>"  />
<%
	}
%>                            
                </td>
                <td style="width:65%">
                    <div class="dataGridHolder fullWidth">
                        <table class="dataGrid fullWidth">
                        <tr class="header">
                            <td>&nbsp;</td>
                            <td><%=locTitle.getValue (33, "Date")%></td>
                            <td><%=pkiCertificateSignatureLoc.getIdIndividualLabel()%></td>
                            <td><%=pkiCertificateSignatureLoc.getIdPkiCertificateSignatureTypeLabel()%></td>
                            <td><%=pkiCertificateSignatureLoc.getIdPkiSignatureAlgorithmTypeLabel()%></td>
                            <td><%=pkiCertificateSignatureLoc.getIdPkiCertificateLabel()%></td>
                            <td>&nbsp;</td>
                        </tr>
<%
            for (int j=0; j < vGedDocumentRevisionSeal.size(); j++) {
                GedDocumentRevisionSeal seal = (GedDocumentRevisionSeal)vGedDocumentRevisionSeal.get(j);
                
                Vector<PkiCertificateSignature> vPkiCertificateSignatureSeal = new Vector<PkiCertificateSignature>();

                for(PkiCertificateSignature certSign : vPkiCertificateSignatureSealAll)
                {
                    if(certSign.getIdReferenceObject() ==  seal.getId())
                    {
                    	vPkiCertificateSignatureSeal.add(certSign);
                    }
                }
                
                for (int k=0; k < vPkiCertificateSignatureSeal.size(); k++) {
                    PkiCertificateSignature certificateSignature = vPkiCertificateSignatureSeal.get(k);
                

                    if(certificateSignature != null)
                    {
                        PersonnePhysique personne = null;
                        try {
                            personne = PersonnePhysique.getOrLoadPersonnePhysique(
                            		certificateSignature.getIdIndividual(), vPersonnePhysique);
                        } catch (CoinDatabaseLoadException e) {
                            personne = new PersonnePhysique();
                            personne.setPrenom("?");
                        }
    
                        PkiCertificateSignatureType csType 
                               = PkiCertificateSignatureType.getPkiCertificateSignatureTypeMemory(
                                       certificateSignature.getIdPkiCertificateSignatureType());
                           
                        PkiSignatureAlgorithmType saType = 
                               PkiSignatureAlgorithmType.getPkiSignatureAlgorithmTypeMemory(
                                       certificateSignature.getIdPkiSignatureAlgorithmType());
                           
                        X509Certificate certif = CertificateUtil.getCertificate(
                        		certificateSignature.getCertificate());

                        /**
                         * Vérification
                         */
                        boolean bVerify = false;
                        String sIconVerification = rootPath;
                        String sIconVerificationAlt = "";
                        String sErrorMsg = "";
                        try{
                            
                            String sRevisionChild = GedDocumentRevision.getRevisionNameDefault(
                                    seal.getIdGedDocumentRevisionChild(),
                                    vGedDocumentRevision);

                            String sRevisionParent = GedDocumentRevision.getRevisionNameDefault(
                                    seal.getIdGedDocumentRevisionParent(),
                                    vGedDocumentRevision);

                            File tempFileDocument = hmFile.get(sRevisionChild);
                            File tempFileDocumentParent = hmFile.get(sRevisionParent);
                            
                            if(tempFileDocument == null) {
                                tempFileDocument = GedDocumentRevision.downloadFileTemp(
                                        sSubDirTemp, 
                                        seal.getIdGedDocumentRevisionChild(),
                                        item,
                                        vGedDocumentRevision);
                                hmFile.put(sRevisionChild,tempFileDocument);
                            }
                            if(tempFileDocumentParent == null) {
                                tempFileDocumentParent = GedDocumentRevision.downloadFileTemp(
                                        sSubDirTemp, 
                                        seal.getIdGedDocumentRevisionParent(),
                                        item,
                                        vGedDocumentRevision);
                                hmFile.put(sRevisionParent,tempFileDocumentParent);
                            }
                            certificateSignature.bDisplayLogOnPromt=false;
                            
                            
                            bVerify = certificateSignature.verifySealing(
                            		tempFileDocument, 
                            		tempFileDocumentParent);
                            certificateSignature.bDisplayLogOnPromt=true;
                        } catch (Exception ee) {
                            sErrorMsg = ee.getMessage();
                            ee.printStackTrace();
                        }
                        
                        sIconVerification += (bVerify? Icone.ICONE_SUCCES : Icone.ICONE_ERROR);
                        sIconVerificationAlt = (bVerify? locTitle.getValue (65, "signature ok") : (locTitle.getValue (66, "signature erronée") + " : " + sErrorMsg));
                        
%>
                         <tr class="liste<%=k%2%>" >
                            <td>
                            <img src="<%= sIconVerification %>"
                                 alt="<%= sIconVerificationAlt %>" 
                                 title="<%= sIconVerificationAlt %>" 
                            />
                            </td>
                            <td><%= certificateSignature.getDateCreation() %></td>
                            <td><%= personne.getPrenomNom() %></td>
                            <td><%= csType.getName() %></td>
                            <td><%= saType.getName() %></td>
                            <td style="width: 55%">
                                <b>délivré à</b> <%=  CertificateUtil.getCertificateSubjectInfoCN(certif) %>
                                     (<%=  CertificateUtil.getCertificateSubjectInfoEmailAddress(certif)  %>)<br/>
                                <b>délivré par</b> <%= CertificateUtil.getCertificateIssuerInfoCN(certif) %><br/>
                                <b>expire le</b> <%= CalendarUtil.getFormatDateHeureStd(certif.getNotAfter() ) %> <br/>
                            </td>
                            <td style="width: 10%">
                                <img style="cursor: pointer;"
                                     src="<%= rootPath + "images/icons/file_locked.png" %>"
                                     onclick="doUrl('<%= 
                                           response.encodeURL(
                                                   rootPath + "desk/PkiDownloadCertificateSignature?" 
                                                   + "sAction=getSignature"
                                                   + "&lId=" + certificateSignature.getId()
                                                   
                                           ) %>');" 
                                    alt="<%=locTitle.getValue (62, "Télécharger la signature électronique")%>" 
                                    title="<%=locTitle.getValue (62, "Télécharger la signature électronique")%>" 
                                    />
                
                                <img style="cursor: pointer;"
                                     src="<%= rootPath + "images/icons/page_white_key.png" %>"
                                     onclick="doUrl('<%= 
                                           response.encodeURL(
                                                   rootPath + "desk/PkiDownloadCertificateSignature?" 
                                                   + "sAction=getCertificate"
                                                   + "&lId=" + certificateSignature.getId()
                                                   
                                           ) %>');" 
                                    alt="<%=locTitle.getValue (63, "Télécharger le certificat")%>" 
                                    title="<%=locTitle.getValue (63, "Télécharger le certificat")%>" 
                                    />

<%

        if(certificateSignature.getIdPkiSignatureAlgorithmType() 
        == PkiSignatureAlgorithmType.SIGNATURE_TYPE_XMLDSIG)
        {
%>

                <img style="cursor: pointer;"
                     src="<%= rootPath + "images/icons/drive_key.png" %>"
                     onclick="doUrl('<%= 
                           response.encodeURL(
                                   rootPath + "desk/PkiDownloadCertificateSignature?" 
                                   + "sAction=getSignatureAttached"
                                   + "&lId=" + certificateSignature.getId()
                                   + "&lIdGedDocument=" + item.getId()
                           ) %>');" 
                    alt="<%=locTitle.getValue (64, "Télécharger la signature attachée")%>" 
                    title="<%=locTitle.getValue (64, "Télécharger la signature attachée")%>" 
                    />
<%
    
        }
%>

<%
	if(sessionUserHabilitation.isSuperUser())
	{
%>
                                <img style="cursor: pointer;"
                                     src="<%= rootPath + Icone.ICONE_SUPPRIMER_NEW_STYLE %>"
                                     onclick="doUrlConfirm('<%= 
                                           response.encodeURL("modifyDocumentRevision.jsp?" 
                                                   + "sAction=removeSeal"
                                                   + "&lIdPkiCertificateSignature=" + certificateSignature.getId()
                                                   + "&lIdGedDocument=" + item.getId()
                                           ) %>','<%=locMessage.getValue (37, "Etes-vous sûr de vouloir supprimer ?") %>');" 
                                    title="<%=localizeButton.getValueDelete()%>"
                                    alt="<%=localizeButton.getValueDelete()%>" />
<%
	}
%>                                    
                            </td>
                        </tr>
<%
                    } 
                }
%>

<%

            }
%>
                         </table>
                    </div>
                </td>

            </tr>
        <%
        }
        %>
        </table>
    </div>
    
<%
	if(sessionUserHabilitation.isSuperUser())
	{
%>    
<script type="text/javascript">

function removeLastRevision()
{
    if(confirm("Do you want to delete the last revision ?"))
    {
        location.href = '<%= response.encodeURL("modifyDocument.jsp?sAction=removeLastRevision&lId=" + item.getId()) %>';
    }
}

</script>

    <button type="button" onclick="javascript:addRevision();">
            <%=locButton.getValue (24, "Add revision")%></button>
    <button type="button" onclick="javascript:removeLastRevision();">
            <%=locButton.getValue (25, "Delete last revision")%></button>
    <button type="button" onclick="javascript:generateRevision();">
            <%=locButton.getValue (26, "Generate revision")%></button>
    <button type="button" onclick="javascript:generateRevisionWithTransformation();">
            <%=locButton.getValue (26, "Generate revision")%><br/> <%=locButton.getValue (27, "with transformation")%></button>
    <button type="button" onclick="javascript:generateRevisionWithSignatureArray();">
            <%=locButton.getValue (26, "Generate revision")%><br/> <%=locButton.getValue (28, "with signature array")%></button>
    <button type="button" onclick="javascript:generateRevisionWithNewSignature();">
            <%=locButton.getValue (26, "Generate revision")%><br/> <%=locButton.getValue (29, "with new signature")%></button>

<%
	}
%>
</div>


<%
    } // end if(vGedDocumentRevision.size() == 0) 
        
%>