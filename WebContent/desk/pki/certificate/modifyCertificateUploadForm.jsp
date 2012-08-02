<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.html.*" %>
<%@page import="org.coin.bean.pki.certificate.PkiCertificate"%>
<%@page import="org.coin.bean.pki.certificate.PkiCertificateType"%>
<%@page import="org.coin.bean.pki.certificate.PkiCertificateDn"%>
<%@page import="org.coin.util.CalendarUtil"%>
<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<% 
	String sTitle = "Certificate : "; 

	PkiCertificate item = null;
	PkiCertificateType type = null;
	PkiCertificateDn subject = null;
	PkiCertificateDn issuer = null;
	String sPageUseCaseId = "xxx";
	
	String sAction = request.getParameter("sAction");
	item = new PkiCertificate();
	sTitle += "<span Type=\"altColor\">Upload certificate</span>"; 
	type = new PkiCertificateType();
    PkiCertificateLevel level = PkiCertificateLevel.getPkiCertificateLevel(PkiCertificateLevel.TYPE_USER);
    PkiCertificateState state = PkiCertificateState.getPkiCertificateState(PkiCertificateState.STATE_ACTIVED);

	HtmlBeanTableTrPave pave = new HtmlBeanTableTrPave();
	pave.bIsForm = true;
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);

	
	PersonnePhysique personne 
		= PersonnePhysique.getPersonnePhysique(
				HttpUtil.parseLong("lIdIndividual", request, sessionUser.getIdIndividual()) );
   //personne.setPrenom("Choissez");
	
	
%>
</head>
<script type="text/javascript" src="<%= rootPath %>include/AjaxComboList.js?v=<%= JavascriptVersion.AJAX_COMBO_LIST_JS %>"></script>
<script type="text/javascript">

onPageLoad = function(){
    ac = new AjaxComboList("lIdPersonnePhysique", "getPersonnePhysiqueAllType");
}
</script>
<body>


<%@ include file="/include/new_style/headerFiche.jspf" %>
<form action="<%= response.encodeURL("modifyCertificateUpload.jsp") %>" 
    method="post" 
    enctype='multipart/form-data'
    name="formulaire">
<div id="fiche">
	
        <input type="hidden" name="lId" value="<%= item.getId() %>" />
		<input type="hidden" name="sAction" value="<%= sAction %>" />
		<table class="formLayout" cellspacing="3">
            <tr>
                <td class="pave_cellule_gauche">Type :</td>
                <td class="pave_cellule_droite"><%= type.getAllInHtmlSelect("lIdPkiCertificateType") %></td>
            </tr>
            <tr>
                <td class="pave_cellule_gauche">Level :</td>
                <td class="pave_cellule_droite"><%= level.getAllInHtmlSelect("lIdPkiCertificateLevel") %></td>
            </tr>
            <tr>
                <td class="pave_cellule_gauche">State :</td>
                <td class="pave_cellule_droite"><%= state.getAllInHtmlSelect("lIdPkiCertificateState") %></td>
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
				<td class="pave_cellule_gauche">Certificate Password :</td>
				<td class="pave_cellule_droite">
					<input type="text" name="sCertificatePassword" value="<%= 
							item.getCertificatePassword() %>"/> 
				</td>
			</tr>
			<tr>
				<td class="pave_cellule_gauche">Certificate File :</td>
				<td class="pave_cellule_droite">
					<input type="file" name="bytesCertificateFile" value="<%= item.getCertificateFile() %>"/> 
				</td>
			</tr>
		</table>
</div>
<div id="fiche_footer">
	<button type="submit" >Valid</button>
	<button type="button" onclick="javascript:doUrl('<%=
			response.encodeURL("displayAllCertificate.jsp") %>');" >
			<%= localizeButton.getValueCancel()%></button>
</div>
</form>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>

<%@page import="org.coin.bean.pki.certificate.PkiCertificateLevel"%>
<%@page import="org.coin.bean.pki.certificate.PkiCertificateState"%>
<%@page import="org.coin.util.HttpUtil"%></html>