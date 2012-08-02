<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.html.*" %>
<%@page import="org.coin.bean.ged.GedDocument"%>
<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%@page import="org.coin.bean.ged.GedFolder"%>
<%@page import="org.coin.bean.pki.certificate.signature.PkiCertificateSignature"%>
<%@page import="org.coin.bean.pki.certificate.PkiCertificate"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.bean.pki.certificate.PkiCertificateLevel"%>
<%@page import="org.coin.bean.pki.certificate.PkiCertificateType"%>
<%@page import="org.coin.bean.pki.certificate.signature.PkiCertificateSignatureState"%>
<%@page import="org.coin.bean.pki.certificate.signature.PkiCertificateSignatureType"%>
<%@page import="org.coin.bean.pki.PkiSignatureAlgorithmType"%>
<%@page import="org.coin.security.CertificateUtil"%>
<%@page import="org.coin.util.CalendarUtil"%>
<%@page import="java.util.Vector"%>
<%@page import="java.security.cert.X509Certificate"%>
<%@page import="org.coin.bean.ged.GedDocumentRevision"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="java.sql.Connection"%>
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
	String sHtmlFormUrl= "modifyDocumentSignature.jsp";
    document = GedDocument.getGedDocument(HttpUtil.parseLong("lIdGedDocument", request));
    folder = GedFolder.getGedFolder(document.getIdGedFolder());

    Connection conn = ConnectionManager.getConnection();
    
    Vector<GedDocumentRevision> vGedDocumentRevision 
        =  GedDocument.getAllGedDocumentRevisionOrderDesc(document, conn);
    
	String sAction = request.getParameter("sAction");
	if(sAction.equals("createServer") || sAction.equals("sealLastRevisionServer") )
	{
		item = new PkiCertificateSignature();
        item.setIdReferenceObject(document.getLastObjectReference(vGedDocumentRevision)) ;
        item.setIdTypeObject( document.getLastObjectType(vGedDocumentRevision)) ;

        
		sTitle += "<span class=\"altColor\">New signature serveur</span>"; 
		
        if(sAction.equals("createServer")) {
            sTitle += "<span class=\"altColor\">New signature client</span>"; 
            signatureAlgorithmType = new PkiSignatureAlgorithmType();
            itemType = new PkiCertificateSignatureType() ;
        } else if(sAction.equals("sealLastRevisionServer")) {
            sTitle += "<span class=\"altColor\">Seal last revision</span>"; 
            /**
             * Pour le moment on ne gère que le sceller en SIGNATURE_TYPE_XMLDSIG
             */
            
            signatureAlgorithmType 
                = PkiSignatureAlgorithmType
                    .getPkiSignatureAlgorithmType( PkiSignatureAlgorithmType.SIGNATURE_TYPE_XMLDSIG);
            
            itemType = PkiCertificateSignatureType
	            .getPkiCertificateSignatureType(PkiCertificateSignatureType.TYPE_SEAL) ;

        }

		itemState = new PkiCertificateSignatureState();
		personne = PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual());
	}
	
	HtmlBeanTableTrPave pave = new HtmlBeanTableTrPave();
	pave.bIsForm = true;
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
	   


	
	Vector<PkiCertificate> vPkiCertificate
	   = PkiCertificate.getAllFromIdPersonnePhysique(
			   sessionUser.getIdIndividual(),
			   PkiCertificateType.TYPE_PKCS12,
			   PkiCertificateLevel.TYPE_USER);

	
	
    GedDocumentRevision gdrLast = null;
    GedDocumentRevision gdrPrevious = null;
	String sLastRevisionName = document.getLastDocumentName(vGedDocumentRevision);
    String sPreviousRevisionName = "";
	
	
	if(sAction.equals("sealLastRevisionServer")) {
	     switch((int)item.getIdTypeObject()){
	     
	     case ObjectType.GED_DOCUMENT :
	         /**
	          * N'a pas de sens car il faut signer avec deux documents différents !
	          */
	         break;
	
	     case ObjectType.GED_DOCUMENT_REVISION :
	         
	         gdrLast = GedDocumentRevision.getGedDocumentRevision(
	                              item.getIdReferenceObject(), 
	                              vGedDocumentRevision);
	
	         if(gdrLast.getIdGedDocumentRevisionParent() == 0) {
                 gdrPrevious  = new GedDocumentRevision();
                 gdrPrevious.setIdGedDocumentRevisionParent(0);
                 sPreviousRevisionName = document.getName();
	         } else{
                 gdrPrevious  = GedDocumentRevision.getGedDocumentRevision(
                         gdrLast.getIdGedDocumentRevisionParent(), 
                         vGedDocumentRevision);

                 sPreviousRevisionName = gdrPrevious.getDocumentRevisionFilename(document);
	         }
	
	          
	          break;
	     }
	     
	 }
	
%>
<script type="text/javascript" src="<%= rootPath %>include/AjaxComboList.js?v=<%= JavascriptVersion.AJAX_COMBO_LIST_JS %>"></script>
<script type="text/javascript">

onPageLoad = function(){
    ac = new AjaxComboList("lIdPersonnePhysique", "getPersonnePhysiqueAllType");
}
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
    signature 
</div>

<form action="<%= response.encodeURL(sHtmlFormUrl) %>" 
 method="post"
 name="formulaire" >
<div id="fiche">
        <input type="hidden" name="lId" value="<%= item.getId() %>" />
        <input type="hidden" name="lIdGedDocument" value="<%= document.getId() %>" />
        <input type="hidden" name="lIdTypeObject" value="<%= item.getIdTypeObject() %>" />
        <input type="hidden" name="lIdReferenceObject" value="<%= item.getIdReferenceObject() %>" />
		<input type="hidden" name="sAction" value="<%= sAction %>" />
		
		<table class="formLayout" cellspacing="3">
			<tr>
				<td class="pave_cellule_gauche">Personne :</td>
				<td class="pave_cellule_droite">

					<button type="button" id="AJCL_but_lIdPersonnePhysique" 
					class="<%= CSS.DESIGN_CSS_MANDATORY_CLASS %>" ><%= personne.getName() %></button>
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
                    <%= itemType.getAllInHtmlSelect("lIdPkiCertificateSignatureType") %>
                </td>
            </tr>    
<%

	if(sessionUserHabilitation.isSuperUser())
	{
%>

            <td class="pave_cellule_gauche">Pdf :</td>
                <td class="pave_cellule_droite">
                	TODO
                </td>
            </tr>    
<%
	}

	if(sAction.equals("sealLastRevisionServer")) {
    
%>
            <tr>
                <td class="pave_cellule_gauche">Sceller :</td>
                <td class="pave_cellule_droite">
                    <table>
                        <tr>
                            <td style="text-align: right;vertical-align: middle">
                                <img src="<%= rootPath + "images/icons/lock.gif" %>" />         
                            </td>
                            <td>
			                    <%= sPreviousRevisionName %><br/>
			                    <%= sLastRevisionName %>         
				<input type="hidden" name="lIdGedDocumentRevisionParent" value="<%= gdrPrevious.getId() %>"  />
				<input type="hidden" name="lIdGedDocumentRevisionChild" value="<%= gdrLast.getId() %>"  />
            
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>       
<%
	}
%>
	
		</table>
</div>

<%@ include file="include/divSelectCertificateServer.jspf" %>




<div id="fiche_footer">

	<button type="submit" >Sign</button>
    <button type="button" onclick="javascript:doUrl('<%=
            response.encodeURL("displayDocument.jsp?lId=" + document.getId()) %>');" >
            Cancel</button>
</div>
</form>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
<%
	ConnectionManager.closeConnection(conn);
%>

<%@page import="org.coin.security.modula.ModulaAuth"%></html>
