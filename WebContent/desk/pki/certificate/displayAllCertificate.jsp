<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@page import="java.util.Vector"%>
<%@page import="org.coin.bean.pki.certificate.PkiCertificate"%>
<%@page import="org.coin.bean.pki.certificate.PkiCertificateType"%>
<%@page import="org.coin.bean.pki.certificate.PkiCertificateDn"%>
<%@page import="org.coin.bean.pki.certificate.PkiCertificateLevel"%>
<%@page import="org.coin.bean.pki.certificate.PkiCertificateState"%>
<%@page import="org.coin.db.CoinDatabaseLoadException"%>
<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%@page import="javax.security.cert.X509Certificate"%>
<%
    String sTitle = "Display all certificates";
    Vector<PkiCertificate> vItem = PkiCertificate.getAllStatic();
%>
<script>
var jsonLevel = <%= PkiCertificateLevel.getJSONArray()%>;
function displayCreateModal() {
    var sHTML = '<table class="formLayout" cellspacing="3">'+
                '<tr>'+
                    '<td class="label">Certificate Level :</td>'+
                    '<td class="frame"><select id="selectLevel">loading...</select></td>'+
                '</tr>'+
                '</table>';
    var title = "Choose certificate level before create";
    acceptCallback = function() {
        location.href='<%=response.encodeURL(rootPath + "desk/pki/certificate/modifyCertificateForm.jsp?")%>sAction=create&level='+selectLevel.getSelectedValues()[0];
        closeGlobalConfirm();
    }
    
    openGlobalConfirm(title, sHTML, "Create", acceptCallback, "Cancel", closeGlobalConfirm);
        
    var selectLevel;
    try{
      selectLevel = parent.document.getElementById("selectLevel");
    }
    catch(e){
      selectLevel = document.getElementById("selectLevel");
    }
    mt.html.setSuperCombo(selectLevel);
    selectLevel.populate(jsonLevel,"","lId","sName");
}
onPageLoad = function(){

    $("create").onclick = function(){
        displayCreateModal();
    }
}
</script>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<div style="padding:15px">
	<div class="dataGridHolder fullWidth">
		<table class="dataGrid fullWidth">
		<tr class="header">
		    <td>ID</td>
		    <td>Alias</td>
            <td>Type</td>
            <td>State</td>
            <td>Level</td>
            <td>Personne</td>
            <td>Filename</td>
		    <td>DN Subject</td>
            <td>DN Issuer</td>
           <td>&nbsp;</td>
		</tr>
		<%
		for (int i=0; i < vItem.size(); i++) {
			PkiCertificate item = vItem.get(i);
			
			
			PkiCertificateType type = null;
			PkiCertificateDn subject = null;
			PkiCertificateDn issuer = null;
            PkiCertificateLevel level = null;
            PkiCertificateState state = null;
            PersonnePhysique personne = null;
            try{
            	type = PkiCertificateType.getPkiCertificateType(item.getIdPkiCertificateType());
            } catch (CoinDatabaseLoadException e){
            	type = new PkiCertificateType();
            }
            
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
            	level = PkiCertificateLevel.getPkiCertificateLevel(item.getIdPkiCertificateLevel());
            } catch (CoinDatabaseLoadException e){
            	level = new PkiCertificateLevel();
            }
            
            try{
                state = PkiCertificateState.getPkiCertificateState(item.getIdPkiCertificateState());
            } catch (CoinDatabaseLoadException e){
            	state = new PkiCertificateState();
            }
            
            try{
            	personne = PersonnePhysique.getPersonnePhysique(item.getIdPersonnePhysique());
            } catch (CoinDatabaseLoadException e){
            	personne = new PersonnePhysique();
            }
			
           
		%>
		    <tr class="liste<%=i%2%>" 
		        onmouseover="className='liste_over'" 
		        onmouseout="className='liste<%=i%2%>'" 
		        onclick="javascript:location.href='<%=
		            response.encodeURL("displayCertificate.jsp?lId="+item.getId()) 
		            %>';">
		        <td style="width:5%"><%= item.getId() %></td>
		        <td style="width:10%"><%= item.getAlias() %></td>
                <td style="width:5%"><%= type.getName() %></td>
                <td style="width:5%"><%= level.getName() %></td>
                <td style="width:5%"><%= state.getName() %></td>
		        <td style="width:30%"><%= personne.getName() %></td>
                <td style="width:30%"><%= item.getFilename() %></td>
                <td style="width:30%"><%= subject.getName() %></td>
                <td style="width:30%"><%= issuer.getName() %></td>
		    </tr>
		<%
		}
		%>
		</table>
	</div>
</div>
<div id="fiche_footer">
    <button type="button" id="create">Create</button>
    <button type="button" onclick="javascript:location.href='<%=
             response.encodeURL("modifyCertificateUploadForm.jsp?") 
                %>';" ><%= localizeButton.getValueUpload("Upload") %></button>
    <button type="button" onclick="javascript:location.href='<%=
      response.encodeURL(rootPath+"desk/ExportCertificateListServlet?") 
         %>';" >Extract</button>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>



</html>
