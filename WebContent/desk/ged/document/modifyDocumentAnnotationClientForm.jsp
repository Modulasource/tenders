<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.html.*" %>
<%@page import="org.coin.bean.ged.GedDocument"%>
<%@page import="org.coin.bean.ged.GedDocumentAnnotation"%>
<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%@page import="org.coin.bean.ged.GedFolder"%>
<%@page import="org.coin.bean.pki.PkiSignatureAlgorithmType"%>
<%@page import="modula.configuration.ModulaConfiguration"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.bean.pki.certificate.signature.PkiCertificateSignatureState"%>
<%@page import="org.coin.bean.pki.certificate.signature.PkiCertificateSignatureType"%>
<%@page import="org.coin.applet.CoinAppletContainer"%>
<% 
	String sTitle = "Document annotation : "; 
     
	GedDocumentAnnotation item = null;
    GedDocument document = null;
    GedFolder folder = null;
    PkiSignatureAlgorithmType signatureAlgorithmType = null;
    PkiCertificateSignatureType certificateSignatureType = null;

	PersonnePhysique personne = null;
	String sPageUseCaseId = "xxx";
	String sHtmlFormType= "";
	String sHtmlFormUrl= "modifyDocumentAnnotation.jsp";
	String sAppletUserAgent = request.getHeader("User-Agent");

	String sAction = request.getParameter("sAction");
	if(sAction.equals("create"))
	{
		item = new GedDocumentAnnotation();
		item.setIdGedDocument(Integer.parseInt(request.getParameter("lIdGedDocument"))) ;
		sTitle += "<span class=\"altColor\">New document annotation</span>"; 

		
		personne = PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual());
		signatureAlgorithmType = new PkiSignatureAlgorithmType();
		certificateSignatureType = new PkiCertificateSignatureType() ;
	}
	

	HtmlBeanTableTrPave pave = new HtmlBeanTableTrPave();
	pave.bIsForm = true;
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
	   
	document = GedDocument.getGedDocument(item.getIdGedDocument());
	folder = GedFolder.getGedFolder(document.getIdGedFolder());

	
	
    String sUrlUploadSignature =  HttpUtil.getUrlWithProtocolAndPortToExternalFormWithJSESSIONID(
            rootPath + "desk/ged/document/createDocumentAnnotation.jsp?"
                    + "lIdGedDocument=" + item.getIdGedDocument()
                    + "&lIdIndividual=" + sessionUser.getIdIndividual() 
                    + "&lIdPkiCertificateSignatureState=" + PkiCertificateSignatureState.STATE_VALID
                    + "&lIdIndividual=" + sessionUser.getIdIndividual() 
                    , 
            request , response);

	
    boolean bAppletACValidation = true;
    boolean bAppletAuthentificationUser = false;

	String sUrlDownloadRepository 
	= HttpUtil.getUrlWithProtocolAndPort(
			 rootPath +  "include/jar/",
			request).toExternalForm();

	String sLibListCommon = SignatureApplet.LIST_LIBRARY_TO_INSTALL;
	sLibListCommon += SignatureApplet.LIST_LIBRARY_TO_INSTALL_SSPV;
	String sLocalApplicationSubDir = ".modula";

%>

<script type="text/javascript" src="<%= rootPath %>include/js/progressBar/mt.component.ProgressBar.js"></script>
<script type="text/javascript" src="<%= rootPath %>include/AjaxComboList.js?v=<%= JavascriptVersion.AJAX_COMBO_LIST_JS %>"></script>
<script type="text/javascript" src="<%= rootPath %>dwr/interface/ModulaAuth.js" ></script>
<script type="text/javascript">
function removeItem()
{
    if(confirm("Do you want to delete this annotation ?")){
        location.href = '<%= response.encodeURL("modifyDocumentAnnotation.jsp?sAction=remove&lId=" + item.getId()) %>';
     }
}
onPageLoad = function(){
    ac = new AjaxComboList("lIdPersonnePhysique", "getPersonnePhysiqueAllType");
    displayEnveloppePJToUpload();
}

function  getTextToSign() {
    var sText = $("sAnnotation").value;
    
	if(sText == "") alert("Vous devez annoter le document");

	return sText;
}


var g_jsaPkiSignatureAlgorithmType = <%= PkiSignatureAlgorithmType.getJSONArray() %>;


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
<script type="text/javascript" src="<%= rootPath %>include/AjaxComboList.js?v=<%= JavascriptVersion.AJAX_COMBO_LIST_JS %>"></script>
<script type="text/javascript">

</script>
</head>
<body>

<%@ include file="/include/new_style/headerFiche.jspf" %>

<!-- Quick navigation  -->
<div class="leftBottomBar">
    <a href="<%= response.encodeURL( rootPath + "desk/ged/folder/displayAllFolder.jsp" ) %>" >All folders</a>
    <img src="<%= rootPath + Icone.ICONE_NAVIGATION_DELIMITER %>" />
    <a href="<%= response.encodeURL( rootPath + "desk/ged/folder/displayFolder.jsp?lId=" + folder.getId() ) %>" >folder <%= folder.getName() %></a>
    <img src="<%= rootPath + Icone.ICONE_NAVIGATION_DELIMITER %>" />
    <a href="<%= response.encodeURL( rootPath + "desk/ged/document/displayDocument.jsp?lId=" + document.getId() ) %>" >document <%= document.getName() %></a>
    <img src="<%= rootPath + Icone.ICONE_NAVIGATION_DELIMITER %>" />
    annotation 
</div>

<form action="<%= response.encodeURL(sHtmlFormUrl) %>" 
 method="post"
 name="formulaire" >
<div id="fiche">
        <input type="hidden" name="lId" value="<%= item.getId() %>" />
        <input type="hidden" name="lIdGedDocument" value="<%= item.getIdGedDocument() %>" />
		<input type="hidden" name="sAction" value="<%= sAction %>" />
		
		<table class="formLayout" cellspacing="3">
	
			<tr>
				<td class="pave_cellule_gauche">Personne :</td>
				<td class="pave_cellule_droite">

					<button type="button" id="AJCL_but_lIdPersonnePhysique" 
					class="<% CSS.DESIGN_CSS_MANDATORY_CLASS %>" ><%= personne.getName() %></button>
					<input class="dataType-notNull dataType-id dataType-id dataType-integer" 
						type="hidden" id="lIdPersonnePhysique"
						 name="lIdPersonnePhysique" value="<%= personne.getId() %>" />
				</td>
			</tr>		
            <tr>
                <td class="pave_cellule_gauche">Algo de signature :</td>
                <td class="pave_cellule_droite">
                    <%= signatureAlgorithmType.getAllInHtmlSelect("lIdPkiSignatureAlgorithmType") %>
                </td>
            </tr>       
            <tr>
            <td class="pave_cellule_gauche">Type de signature :</td>
                <td class="pave_cellule_droite">
                    <%= certificateSignatureType.getAllInHtmlSelect("lIdPkiSignatureType") %>
                </td>
            </tr>   	 
		</table>
</div>



<div id="divCertif">
    <div style="margin-top:20px;padding:4px;text-transform:uppercase;font-weight:bold;color: rgb(51, 102, 204);"
        >Choix du certificat 
    </div>
    
    <div class="round greyBar" corner="6" border="1">
      <div style="padding:5px">
         <table class="formLayout">
            <tr>
              <td class="label" style="width: 120px">
                   Navigateur <input type="radio" checked="checked" name="radioCertificateType" id="radioCertificateTypeUserAgent" value="user_agent" />
              </td>
              <td class="value">
                <div id="divUserAgentCertificateList" />
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

<div id="divEnveloppe">
    <div style="margin-top:20px;padding:4px;text-transform:uppercase;font-weight:bold;color: rgb(51, 102, 204);"
    >GED</div>
    <div class="round greyBar" corner="6" border="1">
        <div style="padding:5px">
        <table class="formLayout">
          <tr>
              <td class="label" style="width: 120px">
                   Annotation : 
              </td>
              <td class="value">
                    <textarea rows="5" cols="80" name="sAnnotation" id="sAnnotation" ><%= item.getAnnotation()%></textarea>
                  <div id="divFileAppletList"></div>
                   <div id="divEnveloppePJToUpload"></div>
            </td>
          </tr>
        </table>
        </div>
    </div>
</div>

<div id="divAction">
    <div style="margin-top:20px;padding:4px;text-transform:uppercase;font-weight:bold;color: rgb(51, 102, 204);"
    >Signature électronique du document / certificat client</div>
    <div class="round greyBar" corner="6" border="1">
        <div style="padding:5px">
            
            <table>
              <tr>
                <td style="border:2px  solid #DDFFDD; ">
                    <applet
 	                code="org.coin.applet.CoinAppletContainer.class"
                     archive="<%= 
                        	    rootPath + "include/jar/SCoinAppletContainer.jar?v=" + CoinAppletContainer.VERSION 
                             %>"
                     height="70"
                     name="signatureAppletInstance" 
                     id="signatureAppletInstance"
                     mayscript="mayscript"  
                     alt="Applet de Signature">
				        <param name="Container_sAppletChildName" value="org.modula.applet.signature.SignatureApplet" />
	                    <param name="Container_sUrlDownloadRepository" value="<%= sUrlDownloadRepository %>" />
	                    <param name="Container_sLibListCommon" value="<%= sLibListCommon %>" />
	                    <param name="Container_sLocalApplicationSubDir" value="<%= sLocalApplicationSubDir %>" />
                     
                         <param name="bDisplayUserInterface" value="true" />
                         <param name="bDisplayButtonDowloadFileLocalTemp" value="false" />
                         <param name="bDisplayButtonSelectFileLocal" value="false" />
                         <param name="bDisplayButtonUnselectAllFileLocal" value="false" />
                         <param name="bDisplayButtonSelectCertificate" value="false" />
                         <param name="bDisplayButtonSignFiles" value="true" />
                         <param name="bDisplayButtonCipherFiles" value="false" />
                         <param name="bDisplayButtonDecipherFiles" value="false" />
                         <param name="bDisplayButtonOpenPKCS12" value="true" />
                         <param name="bDisplayButtonUploadFiles" value="false" />
                         <param name="bDisplayButtonUserAgentCertificateList" value="false" />
                         <param name="bOnAppletInitDisplayUserAgentCertificateList" value="true" />
                         <param name="bDisplayButtonCipherAndUploadFiles" value="false" />
                         <param name="bActiveJSObject" value="true" />
                         <param name="bDownloadFileOnInit" value="false" />
                         <param name="iSignObjectType" value="<%= SignatureApplet.SIGN_OBJECT_TYPE_TEXT %>" />
                    
                         <param name="bRemoveAllTempFilesAfterUpload" value="false" />  
                         <param name="bEnableDragNDrop" value="false" />  
                         <param name="bUseTempFolder" value="true" />
                         <param name="bTraceMessageAppletJS" value="true" />
                         <param name="sColorBackground" value="#AAFFAA" />
                         <param name="sColorBackgroundOnDrag" value="#66AA66" />
                         <param name="sCharsetName"  value="<%= Configuration.getConfigurationValueMemory("server.applet.charset.name", "")  %>" />
                         <param name="sServerName" value="<%= request.getServerName() %>" />

                         <param name="sUserAgent" value="<%= sAppletUserAgent  %>" />
                        <param name="sUrlUploadSignature" value="<%= sUrlUploadSignature %>" />
 
                         <!-- MODULA PARAM -->
                
                      <param name="bAuthentificationUser" value="<%= Configuration.getConfigurationValueMemory(ModulaConfiguration.MODULA_SECURITE_AUTHENTIFICATION_UTILISATEUR) %>">
                      <param name="bACValidation" value="<%= Configuration.getConfigurationValueMemory(ModulaConfiguration.SEALING_USE_CERTIFICATE_CHAIN) %>">
                
                    </applet>
                </td>
              </tr>
            </table>
            <span><i>Modula Sign V<%= SignatureApplet.VERSION %></i></span>
        </div>
    </div>
</div>


<div id="fiche_footer">

	<button type="button" onclick="javascript:doUrl('<%=
			response.encodeURL("displayDocument.jsp?lId=" + item.getIdGedDocument()) %>');" >
			Cancel</button>

</div>
</form>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>
