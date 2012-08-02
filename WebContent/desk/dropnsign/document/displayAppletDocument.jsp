<%@page import="org.modula.applet.document.AppletDocument"%>
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
<%@include file="/include/new_style/headerDeskUtf8.jspf" %>
<%
	String sAction = HttpUtil.parseStringBlank("sAction", request);
    String sAppletUserAgent = request.getHeader("User-Agent");

	long lId = HttpUtil.parseLong("lId", request);
	GedDocument item = GedDocument.getGedDocument(lId);
	GedFolder getFolder = GedFolder.getGedFolder(item.getIdGedFolder());
    Vector<GedDocumentRevision> vGedDocumentRevision 
	    =  GedDocument.getAllGedDocumentRevisionOrderDesc(item);

	String sUrlUploadFile =  HttpUtil.getUrlWithProtocolAndPortToExternalFormWithJSESSIONID(
	        rootPath + "publisher_portail/UploadEnveloppe", request , response);

	String sUrlDownloadRepository
	= HttpUtil.getUrlWithProtocolAndPortToExternalFormWithJSESSIONID(
			rootPath + "CoinJarDownloaderServlet?sContext=AppletContainer&sJarName=",
	        request , response);
	
	
	String sUrlDownloadFile 
	= HttpUtil.getUrlWithProtocolAndPortToExternalFormWithJSESSIONID(
            rootPath + "GedDocumentDownloadServlet"
            	+"?sRevision=last_revision"
            	+"&lId=" + item.getId()
            	, 
            	request , response);

	
	String sLocalApplicationSubDir = AppletJarVersion.getLocalApplicationSubDir();
	String sJarPath = AppletJarVersion.getJarPath(rootPath);
	StringBuilder sbArchives = AppletJarVersion.getAppletContainerVersion(sJarPath);
	//String sLibListCommon = AppletJarVersion.getSignatureAppletVersion();
	String sLibListCommon=AppletJarVersion.getAppletDocumentVersion();
	
    Vector<UrlFile> vUrlFile =  new Vector<UrlFile> ();
    UrlFile urlFile = null;
	
	urlFile = new UrlFile(
			FileUtil.cleanFileName(
					item.getLastDocumentName(vGedDocumentRevision)), 
			sUrlDownloadFile );
	
	vUrlFile.add(urlFile);

	
	/**
	 * Certificate authentication
	 */
	boolean bAppletACValidation = true;
	boolean bAppletAuthentificationUser = false;
	boolean bAppletUsePkiCertificateList = HttpUtil.parseBoolean("bAppletUsePkiCertificateList",request, false);
	String sAppletPkiCertificateIdList = HttpUtil.parseStringBlank("sAppletPkiCertificateIdList", request);
	String sUrlReturnPostTraitmentCipher = HttpUtil.parseStringBlank("sUrlReturnPostTraitmentCipher", request);
	String sUrlReturnPostTraitment = null;

	
	
	/**
	 * compute upload
	 */
	//String sUrlUploadSignaturePage = null;
    //String sUrlUploadSignatureSpecifParam = null;
    //String sUrlUploadSignatureCommonParam 
    //= "lIdIndividual=" + sessionUser.getIdIndividual() 
    //+ "&lIdPkiCertificateSignatureState=" + PkiCertificateSignatureState.STATE_VALID
    //+ "&lIdIndividual=" + sessionUser.getIdIndividual()
    //+ "&lIdGedDocument=" + item.getId();
	
	//String sUrlUploadSignatureParam 
	//    = "&lIdReferenceObject=" + item.getLastObjectReference(vGedDocumentRevision)
	//    + "&lIdTypeObject=" + item.getLastObjectType(vGedDocumentRevision);


	//sUrlUploadSignaturePage = "desk/dropnsign/document/signature/createDocumentSignature.jsp?";
	//sUrlUploadSignatureSpecifParam = "";
	if(sUrlReturnPostTraitmentCipher.equals("")) {
	    sUrlReturnPostTraitment = response.encodeURL(
	            rootPath + "desk/dropnsign/document/displayFolder.jsp?lId=" + item.getIdGedFolder());
	} else {
	    sUrlReturnPostTraitment = response.encodeURL(
	            rootPath + SecureString.getSessionPlainString(sUrlReturnPostTraitmentCipher, session));
	}

	
    /**
    String sUrlUploadSignature =
        HttpUtil.getUrlWithProtocolAndPortToExternalFormWithJSESSIONID(
                rootPath + sUrlUploadSignaturePage
                        + sUrlUploadSignatureCommonParam
                        + sUrlUploadSignatureParam
                        + sUrlUploadSignatureSpecifParam
                        , 
                request , response);
	*/

%>
<script type="text/javascript" src="<%= rootPath %>include/js/progressBar/mt.component.ProgressBar.js"></script>
<script type="text/javascript" src="<%= rootPath %>dwr/interface/ModulaAuth.js" ></script>
<script type="text/javascript">
mt.config.enableTabs = true;
mt.config.enableAutoLoading = false;

document.observe("dom:loaded", function() {
    displayEnveloppePJToUpload();
});


var g_urlFileDocumentList = <%= UrlFile.toJSONArray(vUrlFile) %>;
var g_jsaPkiSignatureAlgorithmType = <%= PkiSignatureAlgorithmType.getJSONArray() %>;

function getUrlFileSelected()
{
    return Object.toJSON (g_urlFileDocumentList );
}

function uploadDocumentRevision(){
	var sUrl = '<%= response.encodeURL(rootPath+"desk/dropnsign/document/uploadDocumentRevision.jsp"+
	       "?lIdGedDocument=" + item.getId())%>';
	
	return (window.location.protocol+"//"+window.location.host+sUrl);	       
}

function displayFolder(){
	var sUrl = '<%= response.encodeURL(rootPath + "desk/dropnsign/document/displayFolder.jsp"
		+ "?lId=" + item.getIdGedFolder())%>';

	location.href = sUrl;	       
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
    dg.onRemove = function(index) {
    	g_dgEnveloppePJToUpload.splice(index, 1);
        var sFileId = index;
        $("signatureAppletInstance").unselectFile(sFileId);
    }
    
   
    dg.render(); 
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


<div style="border: 1px #ddd solid;vertical-align: bottom;margin: 5px;padding: 5px;">
<%
	request.setAttribute("getFolder", getFolder);
%>
<jsp:include page="/desk/dropnsign/document/bloc/blocFolderHeader.jsp" />

</div>

<div style="border: 1px #ddd solid;vertical-align: bottom;margin: 5px;padding: 5px;">
Files To Modified: 
<div id="divFileAppletList"></div>
<div id="divEnveloppePJToUpload"></div>
</div>


<div style="border: 1px #ddd solid;vertical-align: bottom;margin: 5px;padding: 5px;">

				    <applet
					code="org.modula.common.util.applet.AppletContainer.class"
					codebase="<%= sJarPath %>"
					archive="<%= sbArchives.toString() %>"               

				     width ="200"
				     height="50"
				     name="signatureAppletInstance" 
				     id="signatureAppletInstance"
				     mayscript="mayscript"  
				     scriptable="true"
				     alt="Applet de Signature">
				        <param name="Container_sAppletChildName" value="org.modula.applet.document.AppletDocument"/>
	                    <param name="Container_sUrlDownloadRepository" value="<%= sUrlDownloadRepository %>" />
	                    <param name="Container_sLibListCommon" value="<%= sLibListCommon %>" />
	                    <param name="Container_sLocalApplicationSubDir" value="<%= sLocalApplicationSubDir %>" />
			            <param name="Container_sLoggingLevel" value="<%=Level.ALL.toString()%>" /> 
			     		<param name="Container_sPluginConfFilePath" value="/config/applet/plugin-conf.properties" />
				     
				     
				         <param name="bDisplayUserInterface" value="true" />
				         <param name="bDisplayButtonDowloadFileLocalTemp" value="false" />
				         <param name="bDisplayButtonSelectFileLocal" value="false" />
				         <param name="bDisplayButtonUnselectAllFileLocal" value="false" />
				         <!-- <param name="bDisplayButtonSelectCertificate" value="false" /> -->
				         
				         <!--The bDisplayButtonSignFiles will be the button to modify the .doc-->
				         <param name="bDisplayButtonModifyFiles" value="true" />
				         <!--Here is the comment text-->
				         
				         
				        <!--  <param name="bDisplayButtonCipherFiles" value="false" /> -->
				        <!--  <param name="bDisplayButtonDecipherFiles" value="false" /> -->
				        <!-- <param name="bDisplayButtonOpenPKCS12" value="false" /> -->
				         <param name="bDisplayButtonUploadFiles" value="false" />
				        <!-- <param name="bDisplayButtonUserAgentCertificateList" value="false" /> -->
				        <!-- <param name="bOnAppletInitDisplayUserAgentCertificateList" value="true" /> -->
                        <!-- <param name="bDisplayButtonCipherAndUploadFiles" value="false" /> -->
                         <param name="bDisplayButtonOpenProxyConnection" value="false" />
                        <!-- <param name="bUploadEncryptCipherKey" value="false" /> -->
				 
                         <param name="bDownloadFileOnInit" value="true" />
                        
				 
			             <param name="bRemoveAllTempFilesAfterUpload" value="true" />  
			             <param name="bEnableDragNDrop" value="false" />  
				         <param name="bUseTempFolder" value="true" />
				         <param name="bTraceMessageAppletJS" value="true" />
				         <param name="sColorBackground" value="#AAFFAA" />
				         <param name="sColorBackgroundOnDrag" value="#66AA66" />
                         <param name="sUrlUploadFile" value="<%= sUrlUploadFile %>" />
                         <param name="sUserAgent" value="<%= sAppletUserAgent  %>" />
                         <param name="sCharsetName" value="<%= Configuration.getConfigurationValueMemory("server.applet.encoding", "")  %>" />
                         <param name="sServerName" value="<%= request.getServerName() %>" />

				      <param name="bAuthentificationUser" value="<%= Configuration.getConfigurationValueMemory(ModulaConfiguration.MODULA_SECURITE_AUTHENTIFICATION_UTILISATEUR) %>">
				      <param name="bACValidation" value="<%= Configuration.getConfigurationValueMemory(ModulaConfiguration.SEALING_USE_CERTIFICATE_CHAIN) %>">
				
				    </applet>
            <span><i>Modula Document V<%=  AppletDocument.VERSION %> (container V<%= AppletContainer.VERSION %>)</i></span>
</div>

	</body>
</html>			    