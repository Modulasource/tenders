<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.html.*" %>
<%@page import="org.coin.bean.ged.GedDocument"%>
<%@page import="org.coin.bean.ged.GedDocumentAnnotation"%>
<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%@page import="org.coin.bean.ged.GedFolder"%>
<% 
	String sTitle = "Document annotation : "; 


	GedDocumentAnnotation item = null;
    GedDocument document = null;
    GedFolder folder = null;
	PersonnePhysique personne = null;
	String sPageUseCaseId = "xxx";
	String sHtmlFormType= "";
	String sHtmlFormUrl= "modifyDocumentAnnotation.jsp";

	PkiSignatureAlgorithmType signatureAlgorithmType = null;
	PkiCertificateSignatureType certificateSignatureType = null;
	
	String sAction = request.getParameter("sAction");
	if(sAction.equals("createSignServer"))
	{
		item = new GedDocumentAnnotation();
		item.setIdGedDocument(Integer.parseInt(request.getParameter("lIdGedDocument"))) ;
		sTitle += "<span class=\"altColor\">New document annotation</span>"; 
		//personne = new PersonnePhysique();
		//personne.setPrenom("Choissez");
		
		personne = PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual());
		certificateSignatureType = new PkiCertificateSignatureType() ;
		signatureAlgorithmType = new PkiSignatureAlgorithmType();
	}
	
	if(sAction.equals("store"))
	{
		item = GedDocumentAnnotation.getGedDocumentAnnotation(Integer.parseInt(request.getParameter("lId")));
		sTitle += "<span class=\"altColor\">"+item.getId()+"</span>"; 
		try {
			personne = PersonnePhysique.getPersonnePhysique(item.getIdPersonnePhysique());
		} catch (Exception e) {
			personne = new PersonnePhysique();
			personne.setPrenom("Choissez");
		}
	}

	HtmlBeanTableTrPave pave = new HtmlBeanTableTrPave();
	pave.bIsForm = true;
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
	   
	document = GedDocument.getGedDocument(item.getIdGedDocument());
	folder = GedFolder.getGedFolder(document.getIdGedFolder());

	
	
	
    /**
     * certificate part
     */
    Vector<PkiCertificate> vPkiCertificate
       = PkiCertificate.getAllFromIdPersonnePhysique(
               sessionUser.getIdIndividual(),
               PkiCertificateType.TYPE_PKCS12,
               PkiCertificateLevel.TYPE_USER);
    
    
    System.out.println("document.getIdTypeObjectOwner() " + document.getIdTypeObjectOwner());
    Vector<PersonnePhysique> vPersonnePhysiqueAll = null;
    long lIdOrganisationDocumentOwner = 0;
    if(document.getIdTypeObjectOwner() == ObjectType.PERSONNE_PHYSIQUE)
    {
    	PersonnePhysique ppOwner = PersonnePhysique.getPersonnePhysique(document.getIdReferenceObjectOwner());
    	lIdOrganisationDocumentOwner = ppOwner.getIdOrganisation();
    } else {
    	PersonnePhysique ppOwner = PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual());
        lIdOrganisationDocumentOwner = ppOwner.getIdOrganisation();
    }
    vPersonnePhysiqueAll
	    =  PersonnePhysique.getAllFromIdOrganisation((int)lIdOrganisationDocumentOwner);
 
    
    GedDocumentAnnotationIndividual dai = new GedDocumentAnnotationIndividual();
    Vector< GedDocumentAnnotationIndividual> vGedDocumentAnnotationIndividual
        = dai.getAllWithWhereAndOrderByClause(
                " WHERE id_ged_document_annotation=" + item.getId(),
                "");
    
    CoinDatabaseWhereClause wcPersonnePhysique = new CoinDatabaseWhereClause(CoinDatabaseWhereClause.ITEM_TYPE_INTEGER);
    for(GedDocumentAnnotationIndividual gdai : vGedDocumentAnnotationIndividual)
    {
       wcPersonnePhysique.add(gdai.getIdPersonnePhysique());
    }
    Vector<PersonnePhysique> vPersonnePhysiqueAllBis
        =  PersonnePhysique.getAllWithWhereAndOrderByClauseStatic(wcPersonnePhysique, "");

    for(PersonnePhysique pers : vPersonnePhysiqueAllBis)
    {
    	try{
            PersonnePhysique pers2 = PersonnePhysique.getPersonnePhysique(pers.getId(), vPersonnePhysiqueAll);
    	} catch (CoinDatabaseLoadException e){
    		/**
    		 * not found, add it
    		 */
    		vPersonnePhysiqueAll.add(pers);
    	}
    }
    
    
    /** 
     * type part
     */
    GedDocumentAnnotationType type = null;
    try{
        type = GedDocumentAnnotationType.getGedDocumentAnnotationTypeMemory(item.getIdGedDocumentAnnotationType());   
    } catch (CoinDatabaseLoadException e){
        type = new GedDocumentAnnotationType();
    }
    
%>
<script type="text/javascript" src="<%= rootPath %>include/AjaxComboList.js?v=<%= JavascriptVersion.AJAX_COMBO_LIST_JS %>"></script>
<script type="text/javascript" src="<%= rootPath %>include/bascule.js" ></script> 
<script type="text/javascript">
function removeItem()
{
    if(confirm("Do you want to delete this annotation ?")){
        location.href = '<%= response.encodeURL("modifyDocumentAnnotation.jsp?sAction=remove&lId=" + item.getId()) %>';
     }
}
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
    annotation 
</div>

<form action="<%= response.encodeURL(sHtmlFormUrl) %>" 
 method="post"
 name="formulaire" >
<div id="fiche">
        <input type="hidden" name="lId" value="<%= item.getId() %>" />
        <input type="hidden" name="lIdGedDocument" value="<%= item.getIdGedDocument() %>" />
		<input type="hidden" name="sAction" value="<%= sAction %>" />
        <input type="hidden" name="lIdTypeObject" value="<%= ObjectType.GED_DOCUMENT_ANNOTATION %>" />
        <input type="hidden" name="lIdReferenceObject" value="<%= item.getId() %>" />
		<table class="formLayout" cellspacing="3">
			<tr>
				<td class="pave_cellule_gauche">Annotation :</td>
				<td class="pave_cellule_droite">
					<textarea rows="5" cols="80" name="sAnnotation"><%= item.getAnnotation()%></textarea>
				</td>
			</tr>		
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
                <td class="pave_cellule_gauche">Type :</td>
                <td class="pave_cellule_droite">
                     <%= type.getAllInHtmlSelect("lIdGedDocumentAnnotationType") %>
                </td>
            </tr>       
            <tr>
                <td class="pave_cellule_gauche">Visibilité :</td>
                <td class="pave_cellule_droite">




    Visible par :<br/>
<table cellspacing="0" cellpadding="0" width="452">
    <tr> 
      <td width="450" > 
        <input type="radio" 
            name="lIdGedDocumentAnnotationVisibility" 
            value="<%= GedDocumentAnnotationVisibility.TYPE_PUBLIC %>" 
            <%= item.getIdGedDocumentAnnotationVisibility()
                == GedDocumentAnnotationVisibility.TYPE_PUBLIC?"checked='checked'":"" %>
            onclick="Element.hide('tablePrivateList')" >
        Public (visible par tous les membres du circuit)
      </td>
    </tr>
    <tr> 
      <td >&nbsp; </td>
    </tr>
    <tr > 
      <td > 
        <input type="radio" 
            name="lIdGedDocumentAnnotationVisibility" 
            value="<%= GedDocumentAnnotationVisibility.TYPE_PRIVATE %>" 
            <%= item.getIdGedDocumentAnnotationVisibility()
                == GedDocumentAnnotationVisibility.TYPE_PRIVATE?"checked='checked'":"" %>
            onclick="Element.show('tablePrivateList')" />
        Privé (sélectionner les membres du circuit autorisés à lire l'annotation) 

        <div id="tablePrivateList" 
            <%= item.getIdGedDocumentAnnotationVisibility()
                == GedDocumentAnnotationVisibility.TYPE_PUBLIC?"style='display : none'":"" %>
           >
            <table >
              <tr> 
                <td width="25">&nbsp;</td>
                <td > ne voient pasl'annotation :</td>
                <td width="80">&nbsp;</td>
                <td > voient l'annotation :</td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
                <td>
                    <select name="idIndivualNotSee" id="idIndivualNotSee" multiple="multiple" size="8"  style="width:250px" >
<%
    for(PersonnePhysique personneSelected : vPersonnePhysiqueAll)
    {
        boolean bIsSelected = false;
        for( GedDocumentAnnotationIndividual indiv : vGedDocumentAnnotationIndividual )
        {
              if(indiv.getIdPersonnePhysique() == personneSelected.getId()) 
              {
                  bIsSelected = true;
                  break;
              }
        }
        
        if(!bIsSelected)
        {
%>
                      <option value="<%= personneSelected.getId() %>"><%= personneSelected.getName() %></option>
<%
        }
    }
%>
                  </select> 
                  
                </td>
                <td align="center" valign="middle"> 
                  <button type="button" 
                        onclick="moveAllItem('idIndivualSee','idIndivualNotSee');" >&lt;&lt;</button>
                  <button name="button" type="button" 
                        onclick="moveAllItem('idIndivualNotSee','idIndivualSee');" >&gt;&gt;</button>
                </td>
                <td>
                    <select name="idIndivualSee"  id="idIndivualSee"  size="8" multiple="multiple" style="width:250px">
<%
    for(PersonnePhysique personneSelected : vPersonnePhysiqueAll)
    {
        boolean bIsSelected = false;
        for( GedDocumentAnnotationIndividual indiv : vGedDocumentAnnotationIndividual )
        {
              if(indiv.getIdPersonnePhysique() == personneSelected.getId()) 
              {
                  bIsSelected = true;
                  break;
              }
        }
        
        if(bIsSelected)
        {
%>
                      <option value="<%= personneSelected.getId() %>"><%= personneSelected.getName() %></option>
<%
        }
    }
%>
                    </select> 
                </td>
              </tr>
            </table>
            </div>
        </td>
    </tr>
  </table>


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
                    <%= certificateSignatureType.getAllInHtmlSelect("lIdPkiCertificateSignatureType") %>
                </td>
            </tr>    	
		</table>
</div>


<%@ include file="include/divSelectCertificateServer.jspf" %>


<div id="fiche_footer">

	<button type="submit" >Valid</button>
	<%if(sAction.equals("store"))
	{ %>
	<button type="button" onclick="javascript:removeItem();">
			Delete</button>
	<%} %>
	<button type="button" onclick="javascript:doUrl('<%=
		response.encodeURL("displayDocument.jsp?lId=" + item.getIdGedDocument()) %>');" >
		Cancel</button>
</div>
</form>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>

<%@page import="org.coin.security.CertificateUtil"%>
<%@page import="java.security.cert.X509Certificate"%>
<%@page import="org.coin.bean.pki.certificate.PkiCertificate"%>
<%@page import="org.coin.bean.pki.certificate.PkiCertificateLevel"%>
<%@page import="org.coin.bean.pki.certificate.PkiCertificateType"%>
<%@page import="java.util.Vector"%>
<%@page import="org.coin.util.CalendarUtil"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.bean.pki.PkiSignatureAlgorithmType"%>
<%@page import="org.coin.bean.pki.certificate.signature.PkiCertificateSignatureType"%>
<%@page import="org.coin.bean.ged.GedDocumentAnnotationIndividual"%>
<%@page import="org.coin.bean.ged.GedDocumentAnnotationType"%>
<%@page import="org.coin.db.CoinDatabaseLoadException"%>
<%@page import="org.coin.db.CoinDatabaseWhereClause"%>
<%@page import="org.coin.bean.ged.GedDocumentAnnotationVisibility"%></html>
