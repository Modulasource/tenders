<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@page import="java.io.File"%>
<%@page import="org.coin.signature.sspv.shape.SSPVImageShape"%>
<%@page import="org.coin.util.FileUtil"%>
<%@page import="org.coin.bean.ged.GedDocumentRevisionSeal"%>
<%@page import="org.coin.bean.ged.GedFolderUtilPki"%>
<%@page import="org.coin.bean.ged.GedFolderUtil"%>
<%@page import="org.coin.util.pdf.PdfTransformation"%>
<%@page import="org.coin.bean.ged.GedDocumentMetadata"%>
<%@page import="org.coin.bean.html.*" %>
<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%@page import="org.coin.bean.ged.GedDocument"%>
<%@page import="org.coin.bean.ged.GedFolder"%>
<%@page import="org.coin.bean.ged.GedDocumentRevision"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.bean.pki.certificate.signature.PkiCertificateSignatureState"%>
<%@page import="org.coin.bean.pki.certificate.signature.PkiCertificateSignatureType"%>
<%@page import="org.coin.bean.pki.certificate.signature.PkiCertificateSignature"%>
<%@page import="org.coin.bean.pki.certificate.PkiCertificate"%>
<%@page import="org.coin.bean.pki.PkiSignatureAlgorithmType"%>
<%@page import="org.coin.util.CalendarUtil"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="modula.configuration.ModulaConfiguration"%>
<%@page import="java.util.Vector"%>
<%@page import="org.coin.applet.util.UrlFile"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="org.coin.fr.bean.Delegation"%>
<%@page import="org.coin.util.Outils"%>
<%@page import="org.coin.fr.bean.MultimediaType"%>
<%@page import="org.coin.fr.bean.Multimedia"%>
<%@page import="org.coin.applet.CoinAppletContainer"%>
<% 
	String sTitle = "Document signature : "; 
    
	PkiCertificateSignature item = null;
	PkiCertificateSignatureState itemState = null;
	PkiCertificateSignatureType itemType = null;
    PkiSignatureAlgorithmType signatureAlgorithmType = null;
    GedDocument document = null;
    GedFolder folder = null;
	PersonnePhysique personne = null;
	String sPageUseCaseId = "xxx";
	String sHtmlFormType= "";
	String sHtmlFormUrl= "modifyDocumentAnnotation.jsp";
	String sAppletUserAgent = request.getHeader("User-Agent");
    boolean bGenerateNewRevisionWithScannedSignature = false;
    boolean bSetDate = false;
    boolean bSetScanSign = false;
    boolean bEmptyScanSign = false;
	int iIdMultimediaType = MultimediaType.TYPE_SCANNED_SIGNATURE;
    Connection conn = ConnectionManager.getConnection();
	
	/**
	 * HTTP Parameters
	 */
    boolean bIsPopup = HttpUtil.parseBoolean("bIsPopup", request, false);
    boolean bIsParaph = HttpUtil.parseBoolean("bIsParaph", request, false);
    long lIdMultimediaScannedSignature = HttpUtil.parseLong("lIdMultimediaScannedSignature",request, -1);
    String sAction = request.getParameter("sAction");
	String sActionParaph = HttpUtil.parseStringBlank("sActionParaph", request);
	long lIdGedDocument = HttpUtil.parseLong("lIdGedDocument",request);
	String sArrayTabFolderPagination = HttpUtil.parseStringBlank("sarrTabFolderPagination", request);
	    
    boolean bDisplayCertificateFile = !bIsParaph;
    boolean bDisplayFullGui = !bIsParaph;
	boolean bUseSignatureFormatPades = HttpUtil.parseBoolean("bUseSignatureFormatPades",request, false);


	/**
	 * Certificate authentication
	 */
	boolean bAppletACValidation = true;
	boolean bAppletAuthentificationUser = false;
	boolean bAppletUsePkiCertificateList = HttpUtil.parseBoolean("bAppletUsePkiCertificateList",request, false);
	String sAppletPkiCertificateIdList = HttpUtil.parseStringBlank("sAppletPkiCertificateIdList", request);

	HttpUtil.displayOnConsoleRequestParameters(request);
	
    // for debug
    //bDisplayFullGui = true;
    
   

    

    /**
     * load it twice for the moment, before and after, to prevent border effects
     */
    document = GedDocument.getGedDocument(lIdGedDocument, false, conn);
	GedDocumentMetadata workingRevId = null;
	GedDocumentRevision gdrWork = null; 
	GedDocumentRevision gdrToSign = null;

    
	/**
	 * create a new revision if necessary
	 */ 
	if(sAction.equals("sealLastRevision"))
	{
		String wn = "temp.applet.signature.working.document.revision.id";
		GedDocumentMetadata.getOrCreateGedDocumentMetadata(
				document.getId(),
				wn,
				false,
				conn);
		try {
	    	workingRevId = GedDocumentMetadata.getGedDocumentMetadata(document.getId(),wn);
	    } catch (Exception e){ 
	    	workingRevId = new GedDocumentMetadata();
	    	workingRevId.setIdGedDocument(document.getId());
	    	workingRevId.setName(wn);
	    	workingRevId.create(conn);
	    }
		
	    /**
	     * remove the last working revision if necessary
	     */
	    try {
		    gdrWork 
	    		= GedDocumentRevision.getGedDocumentRevision(
	    			Long.parseLong(workingRevId.getValue()),
	    			false,
	    			conn);
	    	gdrWork.remove(conn);
	    } catch (Exception e){ }
		

		/**
		 * link the revision id as work space revision
		 */
    	workingRevId.setValue("" + gdrToSign.getId());
    	workingRevId.store(conn);

    	/**
    	 * remove revision "gdrToSign" as document revision and put it in the working space
    	 */
    	gdrToSign.setIdGedDocument(0);
    	gdrToSign.store(conn);
	}    
    
    
    
	/**
	 * reload to prevent border effects
	 */
    document = GedDocument.getGedDocument(lIdGedDocument, false, conn);
    folder = GedFolder.getGedFolder(document.getIdGedFolder());

	
    Vector<GedDocumentRevision> vGedDocumentRevision 
        =  GedDocument.getAllGedDocumentRevisionOrderDesc(document, conn);
	
	if(sAction.equals("create") || sAction.equals("sealLastRevision") )
	{
		item = new PkiCertificateSignature();
		
		item.setIdReferenceObject(document.getLastObjectReference(vGedDocumentRevision)) ;
        item.setIdTypeObject( document.getLastObjectType(vGedDocumentRevision)) ;

        if(sAction.equals("create")) {
            sTitle += "<span class=\"altColor\">New signature client</span>"; 
            try{
            	 signatureAlgorithmType
            	  = PkiSignatureAlgorithmType.getPkiSignatureAlgorithmType(
            			  HttpUtil.parseLong("lIdPkiSignatureAlgorithmType", request));
            } catch(Exception e )  {
                signatureAlgorithmType = new PkiSignatureAlgorithmType();
            }
            try{
            	itemType
                 = PkiCertificateSignatureType.getPkiCertificateSignatureType(
                         HttpUtil.parseLong("lIdPkiCertificateSignatureType", request));
           } catch(Exception e )  {
        	   itemType = new PkiCertificateSignatureType() ;
           }

           
        } else if(sAction.equals("sealLastRevision")) {
            sTitle += "<span class=\"altColor\">Seal last revision</span>"; 
            /**
             * Pour le moment on ne gère que le sceller en SIGNATURE_TYPE_XMLDSIG
             */
            
            signatureAlgorithmType 
                = PkiSignatureAlgorithmType 
                    .getPkiSignatureAlgorithmType( PkiSignatureAlgorithmType.SIGNATURE_TYPE_PKCS7);
            
            itemType = PkiCertificateSignatureType
            .getPkiCertificateSignatureType(PkiCertificateSignatureType.TYPE_SSPV) ;

            if(!bUseSignatureFormatPades)
        	{
            	bUseSignatureFormatPades 
        			= ParaphFolderProcess.isSSPVFormatPadesEnabled(
        					sessionUser.getIdIndividual(), 
        					conn);
        	}
        }
        
		itemState = new PkiCertificateSignatureState();
		personne = PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual());
	}

	HtmlBeanTableTrPave pave = new HtmlBeanTableTrPave();
	pave.bIsForm = true;
	//sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
	   
	String sNextRev = "&sRevision=last_revision";
	
	if(gdrToSign != null)
	{
		sNextRev = "&lIdGedDocumentRevision=" + gdrToSign.getId();
	}
	
	String sUrlDownloadFile 
		= HttpUtil.getUrlWithProtocolAndPortToExternalFormWithJSESSIONID(
	            rootPath + "GedDocumentDownloadServlet"
	            	+ "?lId=" + document.getId()
	            	+ sNextRev , 
	            	request , response);

	
	
    String sUrlUploadSignature = null;
    String sUrlUploadSignatureParent = null;
	String sUrlReturnPostTraitment = null;
    String sUrlUploadSignatureCommonParam 
	    = "lIdIndividual=" + sessionUser.getIdIndividual() 
	    + "&lIdPkiCertificateSignatureState=" + PkiCertificateSignatureState.STATE_VALID
	    + "&lIdIndividual=" + sessionUser.getIdIndividual()
	    + "&lIdGedDocument=" + document.getId();
    String sUrlUploadSignatureSpecifParam  = null;
    
    String sUrlUploadSignatureParam 
	    = "&lIdReferenceObject=" + document.getLastObjectReference(vGedDocumentRevision)
	    + "&lIdTypeObject=" + document.getLastObjectType(vGedDocumentRevision);
    String sUrlUploadSignatureParentParam = null;
    String sUrlUploadSignaturePage = null;
    String sUrlUploadSealingPage = null;
    String sUrlUploadSealing = null;
    
	
	if(bIsParaph){
		 long lIdParaphFolder = HttpUtil.parseInt("lIdParaphFolder", request);
		 long lIdEntity = HttpUtil.parseInt("lIdEntity",request);
		 long lIdParaphFolderState = HttpUtil.parseInt("lIdParaphFolderState",request);

		 
		 if(sAction.equals("sealLastRevision")) {
			 /**
			  * because the seal is done with sUrlUploadSealing.
			  * only one creation of paraph and seal in database
			  */
	         sUrlUploadSignaturePage = "desk/ged/document/createDocumentSignature.jsp?";
	         sUrlUploadSealingPage = "desk/paraph/folder/createDocumentSignature.jsp?";
		 } else {
	         sUrlUploadSignaturePage = "desk/paraph/folder/createDocumentSignature.jsp?";
		 }
		 
		 int iIdDelegation = HttpUtil.parseInt("iIdDelegation",request,0);
			
		 
		sUrlReturnPostTraitment = response.encodeURL(
				rootPath + "desk/paraph/folder/displayParaphFolder.jsp?lId=" + lIdDossier
				+ "&iIdDelegation="+iIdDelegation
				+ "&sArrayTabFolderPagination=" + sArrayTabFolderPagination
				+ "&bGUIForceRefresh=true"); 

	} else{
		
		sUrlUploadSignaturePage = "desk/ged/document/createDocumentSignature.jsp?";
		sUrlUploadSignatureSpecifParam = "";
        sUrlReturnPostTraitment = response.encodeURL(
                rootPath + "desk/ged/document/displayDocument.jsp?lId=" + document.getId());
        
	}

	/**
	*/
	if(gdrToSign != null)
	{
		 sUrlUploadSignatureParam 
         = "&lIdReferenceObject=" + gdrToSign.getId()
            + "&lIdTypeObject=" + ObjectType.GED_DOCUMENT_REVISION;
	} 
	
    sUrlUploadSignature =
        HttpUtil.getUrlWithProtocolAndPortToExternalFormWithJSESSIONID(
                rootPath + sUrlUploadSignaturePage
                        + sUrlUploadSignatureCommonParam
                        + sUrlUploadSignatureParam
                        + sUrlUploadSignatureSpecifParam
                        , 
                request , response);

    
    if(bIsParaph){
        sUrlUploadSealing =
            HttpUtil.getUrlWithProtocolAndPortToExternalFormWithJSESSIONID(
                    rootPath + sUrlUploadSealingPage
                            + sUrlUploadSignatureCommonParam
                            + sUrlUploadSignatureParam
                            + sUrlUploadSignatureSpecifParam
                            + "&bIsSSPV=true", 
                    request , response);
    } else {
        sUrlUploadSealing = sUrlUploadSignature + "&bIsSSPV=true";
    }    
	


    Vector<UrlFile> vUrlFile =  new Vector<UrlFile> ();
    UrlFile urlFile = null;
	if(gdrToSign == null)
	{
		urlFile = new UrlFile(
				FileUtil.cleanFileName(
						document.getLastDocumentName(vGedDocumentRevision)), 
				sUrlDownloadFile );
	} else {
		urlFile = new UrlFile(
				FileUtil.cleanFileName(
						gdrToSign.getDocumentRevisionFilename(document)), 
						sUrlDownloadFile );
	}
	vUrlFile.add(urlFile);

	
    if(sAction.equals("sealLastRevision")) {
        /**
         * Prepare files to download : 
             here we have to create the new revision of the file if necessary.
             business rule : get the last sealing, and get the last revision.
             - if the last sealing seal the last revision, then create a new revision with the scanned sign
             - if not, so the last revision have to be sealed : no document creation
         */

        String sUrlDownloadFilePrevRevision = null;
        String sUrlDownloadFilePrevRevisionFileName = null;
            
		switch((int)item.getIdTypeObject()){
		
		case ObjectType.GED_DOCUMENT :
			 sUrlUploadSignatureParentParam 
             = "&lIdReferenceObject=" + document.getId()
                + "&lIdTypeObject=" + ObjectType.GED_DOCUMENT;
			
            sUrlDownloadFilePrevRevision
            =  HttpUtil.getUrlWithProtocolAndPortToExternalFormWithJSESSIONID(
            		  rootPath + "GedDocumentDownloadServlet?lId=" + document.getId(),
                    	request, 
                    	response);
        
        
    	    sUrlDownloadFilePrevRevisionFileName 
	        	= document.getDocumentName();

    	    
			 sUrlUploadSignatureParentParam 
             = "&lIdReferenceObject=" + document.getId()
                + "&lIdTypeObject=" + ObjectType.GED_DOCUMENT;

    	    
			break;

		case ObjectType.GED_DOCUMENT_REVISION :
			
			GedDocumentRevision gdrLast 
		    			 = GedDocumentRevision.getGedDocumentRevision(
		    					 item.getIdReferenceObject(), 
		    					 vGedDocumentRevision);

			GedDocumentRevision gdrPrevious = gdrLast;
			String sAddonRevisionUrlParam = "";
			if(gdrPrevious.getId() != 0){
				/**
				 * Its not the document himself
				 */
				 sAddonRevisionUrlParam = "&lIdGedDocumentRevision=" + gdrPrevious.getId();
				
				 sUrlUploadSignatureParentParam 
		            = "&lIdReferenceObject=" + gdrPrevious.getId()
		               + "&lIdTypeObject=" + ObjectType.GED_DOCUMENT_REVISION;
			} else {
				 sUrlUploadSignatureParentParam 
                 = "&lIdReferenceObject=" + document.getId()
                    + "&lIdTypeObject=" + ObjectType.GED_DOCUMENT;
			}
			
            sUrlDownloadFilePrevRevision
	            =  HttpUtil.getUrlWithProtocolAndPortToExternalFormWithJSESSIONID(
	            		  rootPath + "GedDocumentDownloadServlet?lId=" + document.getId()
			              + sAddonRevisionUrlParam, 
	                    	request, 
	                    	response);
            
            
            sUrlDownloadFilePrevRevisionFileName 
            	= gdrPrevious.getDocumentRevisionFilename(document);
	        break;
		}

        /**
         * Prepare upload parent signature
         */
        sUrlUploadSignatureParent =
            HttpUtil.getUrlWithProtocolAndPortToExternalFormWithJSESSIONID(
                    rootPath + sUrlUploadSignaturePage
                            + sUrlUploadSignatureCommonParam
                            + sUrlUploadSignatureParentParam
                            + sUrlUploadSignatureSpecifParam
                            , 
                    request , response);
        
        vUrlFile.add(
        		new UrlFile(
        				FileUtil.cleanFileName(sUrlDownloadFilePrevRevisionFileName ), 
        				sUrlDownloadFilePrevRevision ));
	
	}
	
    
    
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
	var sUrlUploadSignature = "?";
	if(iIndex == 0)
	{
		sUrlUploadSignature	= "<%= sUrlUploadSignature %>";
	} else {
        sUrlUploadSignature = "<%= sUrlUploadSignatureParent %>";
	}
    return sUrlUploadSignature;
}

function getUrlUploadSealing()
{
    return "<%= sUrlUploadSealing %>";
}

function onAfterSignCompleted()
{
<%
	if(bIsParaph){
%>
	try{
		doParaphFolderReturn();
	} catch(e) { alert(e);}
<%
	} else {
%>
    doUrl("<%= sUrlReturnPostTraitment %>");
<%
	}
%>
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
<body >
<div style="padding: 15px">
<%
	if(!bIsPopup)
	{
%>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<!-- Quick navigation  -->
<div class="leftBottomBar">
    <a href="<%= response.encodeURL( rootPath + "desk/ged/folder/displayAllFolder.jsp" ) %>" >All folders</a>
    <img src="<%= rootPath + Icone.ICONE_NAVIGATION_DELIMITER %>" />
    <a href="<%= response.encodeURL( rootPath + "desk/ged/folder/displayFolder.jsp?lId=" + folder.getId() ) %>" >folder <%= folder.getName() %></a>
    <img src="<%= rootPath + Icone.ICONE_NAVIGATION_DELIMITER %>" />
    <a href="<%= response.encodeURL( rootPath + "desk/ged/document/displayDocument.jsp?lId=" + document.getId() ) %>" >document <%= document.getName() %></a>
    <img src="<%= rootPath + Icone.ICONE_NAVIGATION_DELIMITER %>" />
    signature 
</div>
<%
	}
%>


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

<form action="<%= response.encodeURL(sHtmlFormUrl) %>" 
 method="post"
 name="formulaire" >
<div id="fiche" <%= bIsParaph?"style='display:none'":""  %> >
        <input type="hidden" name="lId" value="<%= item.getId() %>" />
        <input type="hidden" name="lIdPkiCertificate" value="<%= item.getIdPkiCertificate() %>" />
		<input type="hidden" name="sAction" value="<%= sAction %>" />
		
		<table class="formLayout" cellspacing="3">
			<tr>
				<td class="pave_cellule_gauche">Document name :</td>
				<td class="pave_cellule_droite">
					<%= document.getName()%>
				</td>
			</tr>		
			<tr>
				<td class="pave_cellule_gauche">Personne :</td>
				<td class="pave_cellule_droite">
                    <%= personne.getName() %>
<!-- 
					<button type="button" id="AJCL_but_lIdPersonnePhysique" 
					class="<%= CSS.DESIGN_CSS_MANDATORY_CLASS %>" ><%= personne.getName() %></button>
					<input class="dataType-notNull dataType-id dataType-id dataType-integer" 
						type="hidden" id="lIdPersonnePhysique"
						 name="lIdPersonnePhysique" value="<%= personne.getId() %>" />
 -->
				</td>
			</tr>	
            <tr>
                <td class="pave_cellule_gauche">
                    Algo de signature :<br/>
                </td>
                <td class="pave_cellule_droite">
                    <%= signatureAlgorithmType.getAllInHtmlSelect("lIdPkiSignatureAlgorithmType") %>
                </td>
            </tr>   	
            <tr>
            <td class="pave_cellule_gauche">Type de signature :</td>
                <td class="pave_cellule_droite">
                    <%= itemType.getAllInHtmlSelect("lIdPkiSignatureType") %>
                </td>
            </tr>   
<!--             <tr>
                <td class="pave_cellule_gauche">Applet :</td>
                <td class="pave_cellule_droite">

Process : <br/>
- Sélection certificat 
- ouverture du KeyStore avec le mot de passe ou le PIN <br/>
- téléchargement local en fichier temporaire de la derniere révision du document<br/>
- signature du fichier<br/>
- envoi du hash (à voir en XMLDSIG par la suite) et du certificat de clé publique (.crt)<br/>
- contrôle de l'expiration du certifcat<br/>
- contrôle de l'existance du certificat (s'il existe en bdd)<br/>
___ non : s'il émane bien d'un AC ROOT connue, ajouter le cerficat en base<br/>
___ oui : controle de l'authenticité du certificat<br/>
- controle du hash par rapport au certificat envoyé et de la derniere révision du document<br/>
- stockage du hash<br/>
- supprimer le ficher temporaire local<br/>

                </td>
            </tr>   	
 -->
		</table>
</div>

<%
	if(bDisplayFullGui)
	{
%>
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

<div id="divEnveloppe" <%= bIsParaph?"style='display:none'":""  %> >
    <div style="margin-top:20px;padding:4px;text-transform:uppercase;font-weight:bold;color: rgb(51, 102, 204);"
    >GED</div>
    <div class="round greyBar" corner="6" border="1">
        <div style="padding:5px">
        <table class="formLayout">
          <tr>
              <td class="label" style="width: 120px">
                   Fichiers en attente de signature : 
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
    <div class="round greyBar" corner="6" border="1">
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
 	                code="org.coin.applet.CoinAppletContainer.class"
                     archive="<%= 
//                             rootPath + "include/jar/SSignatureApplet.jar?V=" + SignatureApplet.VERSION 
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

                         <param name="bDisplayUserInterface" value="true" />
                         <param name="bDisplayButtonDowloadFileLocalTemp" value="false" />
                         <param name="bDisplayButtonSelectFileLocal" value="false" />
                         <param name="bDisplayButtonUnselectAllFileLocal" value="false" />
                         <param name="bDisplayButtonSelectCertificate" value="false" />
                         <param name="bDisplayButtonSignFiles" value="true" />
                         <param name="bDisplayButtonCipherFiles" value="false" />
                         <param name="bDisplayButtonDecipherFiles" value="false" />
                         <param name="bDisplayButtonOpenPKCS12" value="<%= bIsParaph?"false":"true" %>" />
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
                         <param name="sColorBackground" value="<%= bIsParaph?"#FFFFFF":"#AAFFAA" %>" />
                         <param name="sColorBackgroundOnDrag" value="#66AA66" />
                         <param name="sCharsetName" value="<%= Configuration.getConfigurationValueMemory("server.applet.encoding", "")  %>" />
                         <param name="sServerName" value="<%= request.getServerName() %>" />
                         <param name="bUpdateHttpsCertificateChain" value="false" />  
 
                         <param name="bUseSignatureFormatPades" value="<%= bUseSignatureFormatPades %>" />

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
<%
	if(bUseSignatureFormatPades )
			{
	%>
			<img src="<%= rootPath + "images/icons/pdf-document-pades.png" %>" alt="<%= 
				"PDF Advanced Electronic Signature" %>" title="<%= "PDF Advanced Electronic Signature" %>" />
	<%					
			}

%>            	
            </div>
</div>
<%
	}
%>
<div id="fiche_footer" <%= bDisplayFullGui?"":"style='display:none;'" %> >
<%
if(bIsParaph){
%>
<script type="text/javascript">
function doParaphFolderReturn()
{ 
    // other ways to do it
	//doUrl("<%= sUrlReturnPostTraitment %>");
    top.redirectParentTabActive("<%= sUrlReturnPostTraitment %>");
    closeModal();

    //closeModalAndRedirectTabActiveWithTime("<%= sUrlReturnPostTraitment %>", 1500);
}

function displayInfo()
{
    Element.toggle("divEnveloppe");
    Element.toggle("fiche");
	
}

</script>
	<button type="button" onclick="javascript:doParaphFolderReturn()" >
			Retour</button>
			
	<button type="button" onclick="javascript:displayInfo()" >
            Afficher Info</button>
			
<%
} else {
%>
    <button type="button" onclick="javascript:doUrl('<%=
            response.encodeURL("displayDocument.jsp?lId=" + document.getId()) %>');" >
            Retour</button>
<%	
}
%>
</div>
</form>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</div>
</body>
<%
    ConnectionManager.closeConnection(conn);
%>
</html>
