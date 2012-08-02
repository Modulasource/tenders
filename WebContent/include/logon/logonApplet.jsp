<%@page import="org.modula.applet.signature.SignatureApplet"%>
<%@page import="org.coin.applet.AppletJarVersion"%>
<%@page import="org.coin.applet.CoinAppletContainer"%>
<%@ include file="/include/new_style/headerDeskUtf8.jspf" %>
<%@page import="java.util.logging.Level"%>
<%@page import="org.coin.bean.conf.Configuration"%>
<%@page import="modula.configuration.ModulaConfiguration"%>
<%@page import="org.coin.applet.util.UrlFile"%>
<%@page import="org.coin.bean.pki.PkiSignatureAlgorithmType"%>
<%@page import="java.util.Vector"%>
<%@page import="java.io.File"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.bean.pki.certificate.signature.PkiCertificateSignatureType"%>
<%@page import="org.coin.bean.pki.PkiSignatureAlgorithmType"%>


<%@ include file="/desk/include/localization.jspf" %>
<%


try {
	/**
	 * used only with normal logon
	 */
	session.removeAttribute("tentative");
	
	boolean bDisplayFullGui = HttpUtil.parseBoolean("bDisplayFullGui", request, false);
	String sAppletUserAgent = request.getHeader("User-Agent");
	boolean bAppletACValidation = true;
	boolean bAppletAuthentificationUser = false;

	String sUrlDownloadFile 
		= HttpUtil.getUrlWithProtocolAndPortToExternalFormWithJSESSIONID(
            rootPath + "include/logon/getChallenge.jsp" , 
            request, 
            response);
	
	

	String sUrlUploadSignature 
		= HttpUtil.getUrlWithProtocolAndPortToExternalFormWithJSESSIONID(
            rootPath + "include/logon/challengeLogon.jsp" , 
            request, 
            response);
	
	System.out.println("logonApplet.jsp SESSION ID : " + session.getId());


	System.out.println("sUrlUploadSignature : " +sUrlUploadSignature);
	System.out.println("sUrlDownloadFile : " +sUrlDownloadFile);

	
    Vector<UrlFile> vUrlFile =  new Vector<UrlFile> ();
    UrlFile urlFile = new UrlFile("challenge" + System.currentTimeMillis() + ".txt", sUrlDownloadFile );
	vUrlFile.add(urlFile);	


	/*
	String sUrlDownloadRepository 
	= HttpUtil.getUrlWithProtocolAndPort(
			 rootPath +  "include/jar/",
			request).toExternalForm();
*/

	String sUrlDownloadRepository
	= HttpUtil.getUrlWithProtocolAndPortToExternalFormWithJSESSIONID(rootPath + "CoinJarDownloaderServlet?sContext=AppletContainer&sJarName=",
            request , response);

	
	String sLocalApplicationSubDir = AppletJarVersion.getLocalApplicationSubDir();
	String sJarPath = AppletJarVersion.getJarPath(rootPath );
	StringBuilder sbArchives = AppletJarVersion.getAppletContainerVersion(sJarPath);
	String sLibListCommon = AppletJarVersion.getSignatureAppletVersion();

	
%>
<script type="text/javascript" src="<%= rootPath %>include/js/progressBar/mt.component.ProgressBar.js"></script>
<script type="text/javascript" src="<%= rootPath %>include/AjaxComboList.js?v=<%= JavascriptVersion.AJAX_COMBO_LIST_JS %>"></script>
<script type="text/javascript" src="<%= rootPath %>dwr/interface/ModulaAuth.js" ></script>
<script type="text/javascript">
mt.config.enableTabs = true;
mt.config.enableAutoLoading = false;

onPageLoad = function(){
    displayEnveloppePJToUpload();
}



var g_urlFileDocumentList = <%= UrlFile.toJSONArray(vUrlFile) %>;
var g_jsaPkiSignatureAlgorithmType = <%= PkiSignatureAlgorithmType.getJSONArray() %>;

function getUrlFileSelected()
{
    return Object.toJSON (g_urlFileDocumentList );
}

function getUrlUploadSignature(iIndex)
{
	var sUrlUploadSignature = "<%= sUrlUploadSignature %>";
    return sUrlUploadSignature;
}


function onAfterSignCompleted()
{
/**
 * pb with cookies, applet doesnt send with the URL the session cookie,
 * so we have to use it directly in the URL
 */
	
	var sUrl = "<%=  rootPath + "desk/index.jsp"
		+ ";jsessionid=" + session.getId() %>";
	//alert(sUrl );
	parent.doUrl(sUrl);
}


function getIdPkiSignatureTypeSelected()
{
	return "<%= PkiCertificateSignatureType.TYPE_SIGNATURE %>";	
}

function getSignatureAlgorithmTypeSelected()
{
	var iSignatureAlgorithmType = <%= PkiSignatureAlgorithmType.SIGNATURE_TYPE_PKCS7 %>;
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
    dg.onRemove = function(index) {
    	g_dgEnveloppePJToUpload.splice(index, 1);
        var sFileId = index;
        $("signatureAppletInstance").unselectFile(sFileId);
    }
    
   
    dg.render(); 
}

</script>
<jsp:include page="/test/javascriptAppletCommon.jsp">
<jsp:param value="<%=bAppletAuthentificationUser %>" name="bAppletAuthentificationUser" />
<jsp:param value="<%=bAppletACValidation %>" name="bAppletACValidation" />
</jsp:include>

</head>
<body>
<div style="padding: 10px">


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
<%

 

	if(bDisplayFullGui)
	{
%>
<div id="divCertif">
    <div style="margin-top:20px;padding:4px;text-transform:uppercase;font-weight:bold;color: rgb(51, 102, 204);"
        >Choix du certificat 
    </div>
    
    <div >
      <div style="padding:5px">
         <table class="formLayout">
            <tr>
              <td class="label" style="width: 120px">
                   Navigateur <input type="radio" checked="checked" name="radioCertificateType" id="radioCertificateTypeUserAgent" value="user_agent" />
              </td>
              <td class="value">
<%
	} else{
%>
<div style="display: none;">
	<input type="radio" checked="checked" name="radioCertificateType" id="radioCertificateTypeUserAgent" value="user_agent" />
	<input type="radio" name="radioCertificateType" id="radioCertificateTypePKCS12File" value="pkcs12"  /> 
</div>
<%		
	}
%>


                <div id="divUserAgentCertificateList" ></div>
<%
	if(bDisplayFullGui)
	{
%>
              </td>
            </tr>
            <tr>
              <td class="label">
                 Certificat logiciel <input type="radio" id="radioCertificateTypePKCS12File" name="radioCertificateType" value="pkcs12"  /> 
              </td>
              <td class="value">
                <div id="divPKCS12FileCertificateList"></div>
              </td>
            </tr>
          </table> 
       </div>
     </div>
</div>
<%
	}
%>

<div id="divEnveloppe" <%= (!bDisplayFullGui)?"style='display:none'":"" %> >
    <div style="margin-top:20px;padding:4px;text-transform:uppercase;font-weight:bold;color: rgb(51, 102, 204);"
    >Challenge</div>
    <div >
        <div style="padding:5px">
        <table class="formLayout">
          <tr>
              <td class="label" style="width: 120px">
                   fichier challenge : 
              </td>
              <td class="value">
                <div id="divFileAppletList"></div>
                <div id="divEnveloppePJToUpload"></div>
              </td>
          </tr>
        </table>
        </div>
    </div>
</div>


<%
	if(bDisplayFullGui)
	{
%>
<div id="divAction"  >
    <div style="margin-top:20px;padding:4px;text-transform:uppercase;font-weight:bold;color: rgb(51, 102, 204);"
    >Signature électronique du document / certificat client</div>
    <div >
        <div style="padding:5px">
            
            <table>
              <tr>
                <td style="border:2px  solid #DDFFDD; ">
<%
	} else {
%>
<div style="text-align: center;" >
<%		
	}




%>                
                    <applet
	                OLD__code="org.coin.applet.CoinAppletContainer.class"
					code="org.modula.common.util.applet.AppletContainer.class"
					codebase="<%= sJarPath %>"
					archive="<%= sbArchives.toString() %>"               

                     OLD__archive="<%= 
                        	    rootPath + "include/jar/SCoinAppletContainer.jar?v=" + CoinAppletContainer.VERSION 
                             %>"
                     width ="<%= bDisplayFullGui?"330":"90" %>"
                     height="<%= bDisplayFullGui?"70":"30" %>"
                     name="signatureAppletInstance" 
                     id="signatureAppletInstance"
                     mayscript="mayscript"  
                     alt="Applet de Signature">
                        <param name="Container_sAppletChildName" value="org.modula.applet.signature.SignatureApplet" />
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
                         <param name="bDisplayButtonSignFiles" value="true" />
                         <param name="bDisplayButtonCipherFiles" value="false" />
                         <param name="bDisplayButtonDecipherFiles" value="false" />
                         <param name="bDisplayButtonOpenPKCS12" value="<%= !bDisplayFullGui?"false":"true" %>" />
                         <param name="bDisplayButtonUploadFiles" value="false" />
                         <param name="bDisplayButtonUserAgentCertificateList" value="false" />
                         <param name="bOnAppletInitDisplayUserAgentCertificateList" value="true" />
                         <param name="bDisplayButtonCipherAndUploadFiles" value="false" />
                         <param name="bActiveJSObject" value="true" />
                         <param name="bDownloadFileOnInit" value="true" />
                         <param name="iSignObjectType" value="<%= SignatureApplet.SIGN_OBJECT_TYPE_FILE %>" />
                  
                  

                         <param name="bRemoveAllTempFilesAfterUpload" value="false" />  
                         <param name="bEnableDragNDrop" value="false" />  
                         <param name="bUseTempFolder" value="true" />
                         <param name="bTraceMessageAppletJS" value="true" />
                         <param name="sColorBackground" value="#FFFFFF" />
                         <param name="sColorBackgroundOnDrag" value="#66AA66" />
                         <param name="sCharsetName" value="<%= Configuration.getConfigurationValueMemory("server.applet.encoding", "")  %>" />

                         <param name="sServerName" value="<%= request.getServerName() %>" />
                         <param name="bUpdateHttpsCertificateChain" value="false" />  


                         <param name="sUserAgent" value="<%= sAppletUserAgent  %>" />
                        <param name="sUrlDownloadFile" value="<%= sUrlDownloadFile %>" />
                        <param name="sUrlUploadSignature" value="<%= sUrlUploadSignature %>" />
 
                         <!-- MODULA PARAM -->
                
                      <param name="bAuthentificationUser" value="<%= Configuration.getConfigurationValueMemory(ModulaConfiguration.MODULA_SECURITE_AUTHENTIFICATION_UTILISATEUR) %>">
                      <param name="bACValidation" value="<%= Configuration.getConfigurationValueMemory(ModulaConfiguration.SEALING_USE_CERTIFICATE_CHAIN) %>">
                
                    </applet>
<%
	if(bDisplayFullGui)
	{
%>
                </td>
              </tr>
            </table>
            <span><i>Modula Sign V<%= SignatureApplet.VERSION %> (container V<%= CoinAppletContainer.VERSION %>)</i></span>
        </div>
    </div>
</div>
<%
	} else {
%>
            <div>
            	<i>Modula Sign V<%= SignatureApplet.VERSION %> 
            	(container V<%= CoinAppletContainer.VERSION %>)
            	</i>
            </div>
</div>
<%
	}


} catch(Exception e) {
	e.printStackTrace();
}

%>
</div>
</body>
</html>