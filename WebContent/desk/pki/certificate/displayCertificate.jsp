<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.html.*" %>
<%@page import="org.coin.bean.pki.certificate.PkiCertificate"%>
<%@page import="org.coin.bean.pki.certificate.PkiCertificateType"%>
<%@page import="org.coin.bean.pki.certificate.PkiCertificateDn"%>
<%@page import="org.coin.util.CalendarUtil"%>
<%@page import="org.bouncycastle.asn1.x509.X509Extensions"%>
<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%@page import="org.coin.db.CoinDatabaseLoadException"%>
<%@page import="org.coin.bean.pki.certificate.PkiCertificateLevel"%>
<%@page import="org.coin.bean.pki.certificate.PkiCertificateState"%>
<% 
	String sTitle = "Certificate : "; 

	PkiCertificate item = null;
	PkiCertificateType type = null;
	PkiCertificateDn subject = null;
	PkiCertificateDn issuer = null;
	PkiCertificateLevel level = null;
    PkiCertificateState state = null;
	String sPageUseCaseId = "xxx";
	PersonnePhysique personne;
	
	ArrayList<HashMap<String, String>> listExtensions = CertificateUtil.listExtensions();
	
	item = PkiCertificate.getPkiCertificate(Integer.parseInt(request.getParameter("lId")));
	sTitle += "<span Type=\"altColor\">"+item.getAlias()+"</span>"; 
	type = PkiCertificateType.getPkiCertificateType(item.getIdPkiCertificateType());
	try{
        subject = PkiCertificateDn.getPkiCertificateDn(item.getIdPkiCertificateDnSubject());
    } catch (CoinDatabaseLoadException e){
        subject = new PkiCertificateDn();
    }
    
    try{
        issuer = PkiCertificateDn.getPkiCertificateDn(item.getIdPkiCertificateDnIssuer());
    } catch (CoinDatabaseLoadException e){
        issuer = new PkiCertificateDn();
    }
    
    try{
        personne = PersonnePhysique.getPersonnePhysique(item.getIdPersonnePhysique());
    } catch (CoinDatabaseLoadException e){
        personne = new PersonnePhysique();
    }
    
    try{
        level = PkiCertificateLevel.getPkiCertificateLevel(item.getIdPkiCertificateLevel());
    } catch (CoinDatabaseLoadException e){
        level = new PkiCertificateLevel();
    }
    
    try{
        state = PkiCertificateState.getPkiCertificateState(item.getIdPkiCertificateState());
    } catch (CoinDatabaseLoadException e){
        state = new PkiCertificateState();
    }

	HtmlBeanTableTrPave pave = new HtmlBeanTableTrPave();
	pave.bIsForm = true;
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);


	
	
%>
<link rel="stylesheet" type="text/css" href="<%=rootPath %>include/component/calendar/calendar.css" media="screen" />
<script type="text/javascript" src="<%=rootPath %>include/component/calendar/calendar.js"></script>
<script>
var jsonCRL = <%= PkiCertificate.getCRLJSONArray()%>;
function displayRevokeModal() {
    var sHTML = '<table class="formLayout" cellspacing="3">'+
                '<tr>'+
                    '<td class="label">CRL :</td>'+
                    '<td class="frame"><select id="selectCRL">loading...</select></td>'+
                '</tr>'+
                '</table>';
    var title = "Choose Certificate Revocation List to revoke";
    acceptCallback = function() {
        location.href='<%=response.encodeURL(rootPath + "desk/pki/certificate/modifyCertificate.jsp?lId="+item.getId())%>&sAction=revoke&crl='+selectCRL.getSelectedValues()[0];
        closeGlobalConfirm();
    }
    
    openGlobalConfirm(title, sHTML, "Revoke", acceptCallback, "Cancel", closeGlobalConfirm);
        
    var selectCRL;
    try{
      selectCRL = parent.document.getElementById("selectCRL");
    }
    catch(e){
      selectCRL = document.getElementById("selectCRL");
    }
    mt.html.setSuperCombo(selectCRL);
    selectCRL.populate(jsonCRL,"","lId","name");
}
onPageLoad = function(){

    if($("revoke")){
	    $("revoke").onclick = function(){
	        displayRevokeModal();
	    }
    }
}
</script>
</head>
<body>

<%@ include file="/include/new_style/headerFiche.jspf" %>
<div id="fiche">
		<table class="formLayout" cellspacing="3">
			<tr>
				<td class="pave_cellule_gauche">Subject  :</td>
				<td class="pave_cellule_droite">
					<%= 
						subject.getName() %></td>
			</tr>
			<tr>
				<td class="pave_cellule_gauche">Issuer  :</td>
				<td class="pave_cellule_droite">
					<%= 
						issuer.getName()  %></td>
			</tr>
			<tr>
				<td class="pave_cellule_gauche">Type :</td>
				<td class="pave_cellule_droite"><%= type.getName()  %></td>
			</tr>
            <tr>
                <td class="pave_cellule_gauche">Level :</td>
                <td class="pave_cellule_droite"><%= level.getName()  %></td>
            </tr>
            <tr>
                <td class="pave_cellule_gauche">State :</td>
                <td class="pave_cellule_droite"><%= state.getName()  %></td>
            </tr>
            <tr>
                <td class="pave_cellule_gauche">Issuer order :</td>
                <td class="pave_cellule_droite">
                    <%= item.getIssuerOrder() %>
                </td>
            </tr>
			<tr>
				<td class="pave_cellule_gauche">Date order :</td>
				<td class="pave_cellule_droite">
					<%= 
							CalendarUtil.getDateCourte(item.getDateOrder()) %>
				</td>
			</tr>
			<tr>
				<td class="pave_cellule_gauche">Date creation :</td>
				<td class="pave_cellule_droite">
					<%=
							CalendarUtil.getDateCourte(item.getDateCreation())  %>
				</td>
			</tr>
			<tr>
				<td class="pave_cellule_gauche">Serial number :</td>
				<td class="pave_cellule_droite">
					<%= item.getSerialNumber() %>
				</td>
			</tr>
			<tr>
				<td class="pave_cellule_gauche">Date validity start :</td>
				<td class="pave_cellule_droite">
					<%=  
							CalendarUtil.getDateCourte(item.getDateValidityStart()) %>
				</td>
			</tr>
			<tr>
				<td class="pave_cellule_gauche">Date validity end :</td>
				<td class="pave_cellule_droite">
					<%=
							CalendarUtil.getDateCourte(item.getDateValidityEnd()) %>
					</td>
			</tr>
			<tr>
				<td class="pave_cellule_gauche">Certificate Password :</td>
				<td class="pave_cellule_droite">
					<%= 
							item.getCertificatePassword() %>
				</td>
			</tr>
<%

%>


            <tr>
                <td class="pave_cellule_gauche"> X509Extensions extension : </td>
                <td class="pave_cellule_droite">
        <a href="#" onclick="Element.toggle('divX509Extensions')" >See extensions</a>
        <div id="divX509Extensions" style="display:none;">
       <table style="size: 100%" cellspacing="20">
          <tr>
          <%
          int iExt = 0;
          String sHTMLExt = "";
          for(HashMap<String, String> map : listExtensions){
              if(iExt%15==0){
                  if(iExt!=0) sHTMLExt += "</td>";
                  sHTMLExt += "<td style=\"vertical-align:top; \">";
              }
              
              String sCheck = "";
              String sColor = "";
              if(PkiCertificateGenerator.useExtension(item,map.get("class"))){
                  sCheck = "checked=\"checked\"";
                  sColor="style=\"color:#FF0000\"";
              }
              
              sHTMLExt += "<input "+sCheck+" disabled=\"disabled\" type=\"checkbox\" name=\""+map.get("class")+"\" /> <span "+sColor+">"+map.get("name")+"</span><br/>";
              iExt++;
          }
          sHTMLExt += "</td>";
          %>
          <%= sHTMLExt %>
        </tr>
    </table>
    </div>
                </td>
            </tr>
			<tr>
				<td class="pave_cellule_gauche">Signature Algorithm :</td>
				<td class="pave_cellule_droite">
					<%= 
                            item.getSignatureAlgorithm() %>
				</td>
			</tr>
			<tr>
				<td class="pave_cellule_gauche">Certificate Version :</td>
				<td class="pave_cellule_droite">
					V<%= item.getCertificateVersion() %>
				</td>
			</tr>
			<tr>
				<td class="pave_cellule_gauche">current certificate filename :</td>
				<td class="pave_cellule_droite">
						<%= item.getFilename() %>
				</td>
			</tr>
		</table>
</div>
<div id="fiche_footer">
	<button type="button" onclick="javascript:doUrl('<%=
			response.encodeURL("displayAllCertificate.jsp") %>');" >
			Return</button>
    <% if(item.getIdPkiCertificateType() == PkiCertificateType.TYPE_PKCS12){ %>
    <button type="button" onclick="javascript:doUrl('<%=
            response.encodeURL("modifyCertificate.jsp?sAction=createPublicKeyCertificate&lId="+item.getId()) %>');" >
            Generate public key certificate</button>
    <%} %>
    <button type="button" onclick="javascript:doUrl('<%=
            response.encodeURL(rootPath+"desk/DownloadPkiCertificateFile?lId="+item.getId()) %>');" >
            Download certificate</button>
    <% if(item.getIdPkiCertificateType() != PkiCertificateType.TYPE_CRL){ %>
    <button type="button" id="revoke">
            Revoke certificate</button>
    <%} %>
	 <button type="button" onclick="javascript:doUrl('<%=
            response.encodeURL("modifyCertificate.jsp?sAction=remove&lId="+item.getId()) %>');" >
            Delete</button>
</div>
</form>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.coin.security.CertificateUtil"%>
<%@page import="org.coin.bean.pki.certificate.PkiCertificateGenerator"%>
</html>