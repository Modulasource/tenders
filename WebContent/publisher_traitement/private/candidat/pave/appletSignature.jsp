<%@page import="java.util.Calendar"%>
<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%@page import="org.modula.applet.signature.SignatureApplet"%>
<%@page import="org.coin.security.SecureString"%>
<%@page import="org.coin.security.Blowfish"%>
<%@page import="org.coin.bean.pki.certificate.signature.PkiCertificateSignatureType"%>
<%@page import="org.coin.bean.pki.certificate.signature.PkiCertificateSignatureState"%>
<%@page import="org.coin.bean.ged.GedDocumentRevision"%>
<%@page import="java.util.Vector"%>
<%@page import="org.coin.util.FileUtil"%>
<%@page import="org.coin.applet.util.UrlFile"%>
<%@page import="org.coin.bean.pki.PkiSignatureAlgorithmType"%>
<%@page import="org.coin.bean.ged.GedFolder"%>
<%@page import="org.coin.bean.ged.GedDocument"%>
<%@page import="org.modula.common.util.applet.AppletContainer"%>
<%@page import="org.coin.applet.AppletJarVersion"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="java.util.logging.Level"%>
<%@page import="org.coin.bean.conf.Configuration"%>
<%@page import="modula.configuration.ModulaConfiguration"%>


<%@page import="modula.marche.Marche"%>
<%@page import="org.coin.util.CalendarUtil"%>
<%@page import="modula.candidature.Enveloppe"%>
<%@include file="/include/new_style/headerDeskUtf8.jspf"%>
<%
	
	
	String sDateLimiteEnvoi = (String) session.getAttribute("sDateLimiteEnvoi");
	String sTypeEnveloppe = (String)session.getAttribute("sTypeEnveloppe");
	
	Marche marche = (Marche)session.getAttribute("marche");
	
	Enveloppe eEnveloppe = (Enveloppe) session.getAttribute("eEnveloppe");
	
	PersonnePhysique candidat = (PersonnePhysique)session.getAttribute("candidat");

	String sAction = HttpUtil.parseStringBlank("sAction", request);
    String sAppletUserAgent = request.getHeader("User-Agent");

    System.out.println("sAction: "+sAction+"  sAppletUserAgent: "+sAppletUserAgent+"  sTypeEnveloppe: "+sTypeEnveloppe);
    
    
    String sUrlPdfConversion =Configuration.getConfigurationValueMemory("ged.document.conversion.pdf.web.service.url");
    //String sUrlPdfConversion ="http://127.0.0.1:8080/modula_test_matamore/services/ArchiveService";
    System.out.println("\nged.document.conversion.pdf.web.service.url: "+sUrlPdfConversion+"\n");

	String sUrlDownloadRepository
	= HttpUtil.getUrlWithProtocolAndPortToExternalFormWithJSESSIONID(
			rootPath + "CoinJarDownloaderServlet?sContext=AppletContainer&sJarName=",
	        request , response);
	
	
	String sLocalApplicationSubDir = AppletJarVersion.getLocalApplicationSubDir();
	String sJarPath = AppletJarVersion.getJarPath(rootPath);
	StringBuilder sbArchives = AppletJarVersion.getAppletContainerVersion(sJarPath);
	String sLibListCommon = AppletJarVersion.getSignatureAppletVersion();
	//String sLibListCommon = "iText-5.0.4.jar;org-modula-applet-signature-4.1.18.jar";


	/**
	*  sUrlCipherKey URL
	*/
    String sUrlCipherKey = HttpUtil.getUrlWithProtocolAndPortToExternalForm(
	        rootPath + "publisher_portail/ChiffrementServletPublisher", request);
	
	String sUrlUploadFile =  HttpUtil.getUrlWithProtocolAndPortToExternalFormWithJSESSIONID(
	        rootPath + "publisher_portail/UploadEnveloppe", request , response);
	/**
	 * Certificate authentication
	 */
	boolean bAppletACValidation = false;
	boolean bAppletAuthentificationUser = false;
	boolean bAppletUsePkiCertificateList = HttpUtil.parseBoolean("bAppletUsePkiCertificateList",request, false);
	String sAppletPkiCertificateIdList = HttpUtil.parseStringBlank("sAppletPkiCertificateIdList", request);

	/**
	* data from pdfheader
	*/
	String sUrlToVerify=null;
	String sHeadText=null;
	String sUrlAppletVerify=null;
	
	sUrlAppletVerify="test/applet/signature/";
	
	sUrlToVerify=HttpUtil.getUrlWithProtocolAndPortToExternalForm(rootPath+sUrlAppletVerify,request);
	
	sHeadText="This document was created with DropNSign."
			 +" To verify this, or sign a new document,"
			 +" enter on:";
	
	
	/**
	 * compute upload
	 */
	 
	String sUrlUploadSignaturePage = null;
    String sUrlUploadSignatureSpecifParam = null;
    String sUrlUploadSignatureCommonParam="" 
     +"lIdPkiCertificateSignatureState=" 
    + PkiCertificateSignatureState.STATE_VALID;
	
	String sUrlUploadSignatureParam
	    = "&lIdTypeObject=" + "1000"; // ged_document


	sUrlUploadSignaturePage = "test/applet/signature/createData.jsp?";
	sUrlUploadSignatureSpecifParam = "";
	
    String sUrlUploadSignature =
        HttpUtil.getUrlWithProtocolAndPortToExternalForm(
                rootPath + sUrlUploadSignaturePage
                        + sUrlUploadSignatureCommonParam
                        + sUrlUploadSignatureParam
                        + sUrlUploadSignatureSpecifParam
                        , request);

    String sUrlCreategedDocumentPage="test/applet/signature/createGedDocument.jsp?";
    String sUrlCreateGedDocument=
        HttpUtil.getUrlWithProtocolAndPortToExternalForm(
                rootPath + sUrlCreategedDocumentPage,
                request); 
    
    
	/**
	 * Algo type
	 */
	PkiCertificateSignatureType itemType = null;
    PkiSignatureAlgorithmType signatureAlgorithmType = null;

	try{
	   	signatureAlgorithmType
	   	  = PkiSignatureAlgorithmType.getPkiSignatureAlgorithmType(
	   			  HttpUtil.parseLong("lIdPkiSignatureAlgorithmType", request));
	} catch(Exception e )  {
		signatureAlgorithmType = new PkiSignatureAlgorithmType();
		signatureAlgorithmType.setId(PkiSignatureAlgorithmType.SIGNATURE_TYPE_PKCS7);
	}
	try{
   		itemType
			= PkiCertificateSignatureType.getPkiCertificateSignatureType(
                HttpUtil.parseLong("lIdPkiCertificateSignatureType", request));
	} catch(Exception e )  {
	   itemType = new PkiCertificateSignatureType() ;
	   itemType.setId(PkiCertificateSignatureType.TYPE_SIGNATURE);
	}

%>
<script type="text/javascript" src="<%= rootPath %>include/js/progressBar/mt.component.ProgressBar.js"></script>
<script type="text/javascript" src="<%= rootPath %>dwr/interface/ModulaAuth.js" ></script>
<script type="text/javascript">

mt.config.enableTabs = true;
mt.config.enableAutoLoading = false;

document.observe("dom:loaded", function() {
    displayEnveloppePJToUpload();
});


var g_jsaPkiSignatureAlgorithmType = <%= PkiSignatureAlgorithmType.getJSONArray() %>;



var araay = new Array();

function getUrlFileSelected()
{
    return Object.toJSON (g_urlFileDocumentList );
}

function getUrlUploadSignature(iIndex)
{
	var sUrlUploadSignature = "?";
	sUrlUploadSignature	= "<%= sUrlUploadSignature %>";
	//alert(sUrlUploadSignature);
    return sUrlUploadSignature;
}

function getUrlCreateGedDocument(){
	var sUrlCreateGed="";
	sUrlCreateGed = "<%= sUrlCreateGedDocument %>";
	return sUrlCreateGed;
}


function getUrlPdfConversion()
{
	var js_url="";
	//alert("getUrlPdfConversion()"+js_url);
	return js_url;	
	
}

function onAfterSignCompleted()
{
	$("sUserMessage").innerHTML = "Le(s) fichiers ont été signé(s)";
}


function isSignatureFileAttached()
{
	if($("bIsSignatureFileAttached").checked) return "true";
	return "false";
}


function getSignedDocPostfix()
{
	return " - Signed";
}

function getIdPkiSignatureTypeSelected()
{
	return $("lIdPkiSignatureType").value;	
}



function getSignatureAlgorithmTypeSelected()
{
	var iSignatureAlgorithmType = $("lIdPkiSignatureAlgorithmType").value;
    var signatureAlgorithmType = g_jsaPkiSignatureAlgorithmType.find(function(item){
        return (item.lId==iSignatureAlgorithmType);
    });
    return Object.toJSON (signatureAlgorithmType );
}

var g_dgEnveloppePJToUpload;

function displayEnveloppePJToUpload(){
    
    g_dgEnveloppePJToUpload = new mt.component.DataGrid('divEnveloppePJToUpload');
    var dg = g_dgEnveloppePJToUpload;
    dg.addStyle("width","100%");
    dg.addRemoveOption();
    dg.setHeader(['Nom', 'Date de modification','Taille','Etat']);


    dg.onBeforeRemove = function(index) {
        var pj = g_dgEnveloppePJToUpload[index];
        return confirm("Etes vous sûr de vouloir supprimer "
              + " filename" +  " ?");
    }
    dg.onRemove = function(index){
    	var sFileId = ""+index;
    	//g_dgEnveloppePJToUpload.splice(sFileId, 1);
    	araay.splice(index,1);
        $("signatureAppletInstance").getAppletChild().unselectFile(sFileId);
        //document.signatureAppletInstance.unselectFile(sFileId);
    }
    
   
    dg.render(); 
}

function getUrltoVerify(){
	var sUrltoVerify="?";
	sUrltoVerify="<%=sUrlToVerify %>";
	return sUrltoVerify;
}


function loadArray(path){
	//var strFile = document.a.fileToUpload.value;
	araay[araay.length]=path;
}

function seeFiles(){
	var arrayAsString=araay.join("|");
	return arrayAsString;
}

function refreshParent() {
		//parent.reload();
		closeModal();
		parent.location.reload();
		//closeModal();
}

</script>
<jsp:include page="/test/javascriptAppletCommon.jsp">
<jsp:param value="<%= bAppletAuthentificationUser %>" name="bAppletAuthentificationUser" />
<jsp:param value="<%= bAppletACValidation %>" name="bAppletACValidation" />
<jsp:param value="<%= bAppletUsePkiCertificateList %>" name="bAppletUseCertificateList" />
<jsp:param value="<%= sAppletPkiCertificateIdList %>" name="sAppletPkiCertificateIdList" />
</jsp:include>


</head>
<body>
<div style="border: 1px #ddd solid;vertical-align: bottom;margin: 5px;padding: 5px; width: 650px;">
<table>
	<tr>
		<td>
				    <applet
					code="org.modula.common.util.applet.AppletContainer.class"
					codebase="<%= sJarPath %>"
					archive="<%= sbArchives.toString() %>"               

				     width ="128"
				     height="30"
				     name="signatureAppletInstance" 
				     id="signatureAppletInstance"
				     mayscript="mayscript"  
				     scriptable="true"
				     alt="Applet de Signature">
				        <param name="Container_sAppletChildName" value="org.modula.applet.signature.SignatureApplet" />
	                    <param name="Container_sUrlDownloadRepository" value="<%= sUrlDownloadRepository %>" />
	                    <param name="Container_sLibListCommon" value="<%= sLibListCommon %>" />
	                    <param name="Container_sLocalApplicationSubDir" value="<%= sLocalApplicationSubDir %>" />
			            <param name="Container_sLoggingLevel" value="<%=Level.ALL.toString()%>" /> 
			     		<param name="Container_sPluginConfFilePath" value="/config/applet/plugin-conf.properties" />
				     
				     
				         <param name="bDisplayUserInterface" value="true" />
				         <param name="bDisplayButtonDowloadFileLocalTemp" value="false" />
				         <param name="bDisplayButtonSelectFileLocal" value="true" />
				         <param name="bDisplayButtonUnselectAllFileLocal" value="false" />
				         <param name="bDisplayButtonSelectCertificate" value="false" />
				         <param name="bDisplayButtonSignFiles" value="false" />
				         <param name="bDisplayButtonCipherFiles" value="false" />
				         <param name="bDisplayButtonDecipherFiles" value="false" />
				         <param name="bDisplayButtonOpenPKCS12" value="false" />
				         <param name="bDisplayButtonUploadFiles" value="false" />
				         <param name="bDisplayButtonUserAgentCertificateList" value="false" />
				         <param name="bOnAppletInitDisplayUserAgentCertificateList" value="false" />
                         <param name="bDisplayButtonCipherAndUploadFiles" value="false" />
                         <param name="bTestProxyConnection" value="false" />
                         <param name="bUploadEncryptCipherKey" value="false" />				 
				 
                         <param name="bDownloadFileOnInit" value="false" />
                         <param name="iSignObjectType" value="<%= SignatureApplet.SIGN_OBJECT_TYPE_FILE %>" />
					     
					     <!--<param name="bUseSignatureFormatPades" value="false" />-->
			             <param name="bSaveSignatureInDocumentFolder" value="false" />
			             <param name="bUploadData" value="false" />
			             <param name="bRemoveAllTempFilesAfterUpload" value="true" />  
			             <param name="bEnableDragNDrop" value="true" />  
				         <param name="bUseTempFolder" value="true" />
				         <param name="bTraceMessageAppletJS" value="true" />
				         <param name="sColorBackground" value="#AAFFAA" />
				         <param name="sColorBackgroundOnDrag" value="#66AA66" />
                         <param name="sUserAgent" value="<%= sAppletUserAgent  %>" />
                         <param name="sCharsetName" value="<%= Configuration.getConfigurationValueMemory("server.applet.encoding", "")  %>" />
                         <param name="sServerName" value="<%= request.getServerName() %>" />

				      <param name="bAuthentificationUser" value="disabled">
				      <param name="bACValidation" value="disabled">
				    </applet>
				  </td>
				  <td style="width: 500px;">
					<div style="border: 1px #ddd solid;margin: 5px;padding: 5px;">
					Fichiers à signer : 
					<div id="divFileAppletList"></div>
					<div id="divEnveloppePJToUpload"></div>
					</div>
				</td>
					</tr>
</table>
</div>


<div style="border: 1px #ddd solid;vertical-align: bottom;margin: 5px;padding: 5px; width: 650px;">
Certificat:

<div style="text-align: center;padding: 5px;color:#99f;" >
<span
	id="spanHideAllCertificateDisabled" 
	onclick="hideAllCertificateDisabled();" 
	style="cursor: pointer;" 
	>Masquer les certificats non valables</span>
<span 
	id="spanShowAllCertificate" 
	onclick="showAllCertificate();" 
	style="cursor: pointer;display: none;"
	 >Afficher tous les certificats</span>
</div>

<div style="height: 150px;overflow: auto;">
<div id="divUserAgentCertificateList" ></div>
</div>
<div style="display: none;">
	<input type="radio" checked="checked" name="radioCertificateType" id="radioCertificateTypeUserAgent" value="user_agent" />
	<input type="radio" name="radioCertificateType" id="radioCertificateTypePKCS12File" value="pkcs12"  /> 
</div>
</div>

<div style="border: 1px #ddd solid;vertical-align: bottom;margin: 5px;padding: 5px; width: 650px;">
	<table>
		<tr>
			<td>
				    <applet
					code="org.modula.common.util.applet.AppletContainer.class"
					codebase="<%= sJarPath %>"
					archive="<%= sbArchives.toString() %>"               

				     width ="225"
				     height="30"
				     name="signatureAppletInstance2" 
				     id="signatureAppletInstance2"
				     mayscript="mayscript"  
				     scriptable="true"
				     alt="Applet de Signature">
				        <param name="Container_sAppletChildName" value="org.modula.applet.signature.SignatureApplet" />
	                    <!-- sUrlDownloadRepository  -->
	                    <param name="Container_sUrlDownloadRepository" value="<%= sUrlDownloadRepository %>" />
	                    <param name="Container_sLibListCommon" value="<%= sLibListCommon %>" />
	                    <param name="Container_sLocalApplicationSubDir" value="<%= sLocalApplicationSubDir %>" />
			            <param name="Container_sLoggingLevel" value="<%=Level.ALL.toString()%>" /> 
			     		<param name="Container_sPluginConfFilePath" value="/config/applet/plugin-conf.properties" />
				     
				     
				         <param name="bDisplayUserInterface" value="true" />
				         <param name="bDisplayButtonDowloadFileLocalTemp" value="false" />
				         <param name="bDisplayButtonSelectFileLocal" value="false" />
				         <param name="bDisplayButtonUnselectAllFileLocal" value="false" />
				         <param name="bDisplayButtonSelectCertificate" value="false" />
				         <param name="bDisplayButtonSignFiles" value="false" />
				         <param name="bDisplayButtonCipherFiles" value="false" />
				         <param name="bDisplayButtonDecipherFiles" value="false" />
				         <param name="bDisplayButtonOpenPKCS12" value="false" />
				         <param name="bDisplayButtonUploadFiles" value="false" />
				         <param name="bDisplayButtonUserAgentCertificateList" value="false" />
				         <param name="bOnAppletInitDisplayUserAgentCertificateList" value="true" />
                         <param name="bDisplayButtonCipherAndUploadFiles" value="true" />
                         <param name="bUploadEncryptCipherKey" value="false" />
				 
				 		 <param name="sUrlCipherKey" value="<%= sUrlCipherKey %>" />
                         <param name="bDownloadFileOnInit" value="false" />
                         <param name="iSignObjectType" value="<%= SignatureApplet.SIGN_OBJECT_TYPE_FILE %>" />
                         
                         <param name="bConvertToPdf" value="false" />
                         <param name="bAttachVirtualSeal" value="false" />
                         <param name="bDisplayOnPopup" value="true" />
				 
					     <!-- <param name="bUseSignatureFormatPades" value="false" />-->
			             <param name="bSaveSignatureInDocumentFolder" value="true" />
			             <param name="bUploadData" value="true" />
			             <param name="bRemoveAllTempFilesAfterUpload" value="true" />  
			             <param name="bEnableDragNDrop" value="true" />  
				         <param name="bUseTempFolder" value="true" />
				         <param name="bTraceMessageAppletJS" value="true" />
				         <param name="sColorBackground" value="#AAFFAA" />
				         <param name="sColorBackgroundOnDrag" value="#66AA66" />
                         <param name="sUserAgent" value="<%= sAppletUserAgent  %>" />
                         <param name="sCharsetName" value="<%= Configuration.getConfigurationValueMemory("server.applet.encoding", "")  %>" />
                         <param name="sServerName" value="<%= request.getServerName() %>" />

						<!-- PROXY -->
						<param name="sUrlTestProxyHTTP" value="http://prod.modula-demat.com/"/>
				      	<param name="sUrlTestProxy" value="https://prod.modula-demat.com/"/>
				      	<param name="bTestProxyConnection" value="true" />
				      
				      <param name="bAuthentificationUser" value="disabled">
				      <param name="bACValidation" value="disabled">
				      
				      <param name="sUrlUploadFile" value="<%= sUrlUploadFile %>" />
					<!-- MODULA PARAM -->
				
				      <param name="iIdMarche" value="<%= marche.getIdMarche() %>" > 
				      <param name="sDateLimiteEnvoi" value="<%= CalendarUtil.getDateWithFormat(Calendar.getInstance(),"") %>"> 
				      <param name="iDelaiUrgence" value="<%= marche.getDelaiUrgence() %>">
				      <param name="iDoubleEnvoi" value="<%= marche.getTimingDoubleEnvoi() %>">
				
				      <param name="iIdEnveloppe" value="<%= eEnveloppe.getIdEnveloppe() %>">
				      <param name="sTypeEnveloppe" value="<%= sTypeEnveloppe %>">
				
				
				      <param name="bSimulate" value="<%= Configuration.getConfigurationValueMemory(ModulaConfiguration.MODULA_APPLET_SIMULATE) %>">
				      <param name="sMailUser" value="<%= candidat.getEmail() %>">
				      <param name="sNomUser" value="<%= candidat.getNom() %>">
				      <param name="sPrenomUser" value="<%= candidat.getPrenom() %>">
				      <param name="bAuthentificationUser" value="<%= Configuration.getConfigurationValueMemory(ModulaConfiguration.MODULA_SECURITE_AUTHENTIFICATION_UTILISATEUR) %>">
				      <param name="bACValidation" value="<%= Configuration.getConfigurationValueMemory(ModulaConfiguration.SEALING_USE_CERTIFICATE_CHAIN) %>">
						      

				    </applet><br/>           
            </td>
            <td>
            	<button type="button" name="closeModal" onClick="refreshParent();">Retour</button>
			</td>
		</tr>
	</table>	
	 <span><i>Modula Sign V<%= SignatureApplet.VERSION %> (container V<%= AppletContainer.VERSION %>)</i></span>				
</div>
<div id="sUserMessage" style="display: none; color: red;font-size: 14px;border: 1px #ddd solid;vertical-align: bottom;margin: 5px;padding: 5px; width: 650px;" >
</div>
	
		
<p style="display: none;border: 1px #ddd solid;vertical-align: bottom;margin: 1px;padding: 1px;">
Algo de signature :
<%= signatureAlgorithmType.getAllInHtmlSelect("lIdPkiSignatureAlgorithmType") %><br/>
Type de signature :
<%= itemType.getAllInHtmlSelect("lIdPkiSignatureType") %>
</p>
	</body>
</html>