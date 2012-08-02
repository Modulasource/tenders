<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Vector"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="org.bouncycastle.asn1.x509.*"%>
<%@page import="org.bouncycastle.asn1.DERObjectIdentifier"%>
<%@page import="org.coin.fr.bean.Organisation"%>
<%@page import="org.coin.security.CertificateUtil"%>
<%@page import="org.coin.bean.pki.certificate.PkiCertificateGenerator"%>
<%@page import="org.coin.bean.html.*" %>
<%@page import="org.coin.bean.pki.certificate.*"%>
<%@page import="org.coin.util.*"%>
<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%@page import="org.coin.db.*"%>
<% 
	String sTitle = "Certificate : "; 

	PkiCertificate item = null;
	PkiCertificateType type = null;
	PkiCertificateDn subject = null;
	Vector<CoinDatabaseAbstractBean> vSubject = null;
	PkiCertificateDn issuer = null;
	Vector<CoinDatabaseAbstractBean> vIssuer = null;
	PkiCertificateLevel level = null;
    PkiCertificateState state = null;
	String sPageUseCaseId = "xxx";
	PersonnePhysique personne = null;
	
	String sAction = HttpUtil.parseStringBlank("sAction",request);
	
	ArrayList<HashMap<String, String>> listExtensions = CertificateUtil.listExtensions();
	
	if(sAction.equals("create"))
	{
		item = new PkiCertificate();
		sTitle += "<span Type=\"altColor\">New certificate</span>"; 
		type = new PkiCertificateType();
		subject = new PkiCertificateDn();
		issuer = new PkiCertificateDn();
		long lIdLevel = HttpUtil.parseLong("level",request,PkiCertificateLevel.TYPE_USER);
		level = PkiCertificateLevel.getPkiCertificateLevel(lIdLevel);
		item.setIdPkiCertificateLevel(level.getId());
        state = new PkiCertificateState();
        
        try{
        	personne = PersonnePhysique.getPersonnePhysique(
        			HttpUtil.parseLong("lIdPersonnePhysique", request));
        } catch (Exception e) {
            personne = PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual());
        }
        try{
            item.setIdPkiCertificateDnIssuer(
            		HttpUtil.parseLong("lIdPkiCertificateDnIssuer", request));
        } catch (Exception e) {
        }        
        
        Timestamp tsNow = CalendarUtil.now();
        item.setDateOrder(tsNow);
        item.setDateValidityStart(tsNow);
        Timestamp tsEnd = CalendarUtil.now();
        CalendarUtil.addYear(tsEnd,2);
        item.setDateValidityEnd(tsEnd);
        
        switch((int)lIdLevel){
        case PkiCertificateLevel.TYPE_INTERMEDIATE:
            item.setCertificateVersion(3);
            vIssuer = PkiCertificateDn.getAllRootDN();
            break;
        case PkiCertificateLevel.TYPE_ROOT:
        	item.setCertificateVersion(1);
            break;
        case PkiCertificateLevel.TYPE_USER:
        	item.setCertificateVersion(3);
        	vIssuer = PkiCertificateDn.getAllIntermediateDN();
            break;
        case PkiCertificateLevel.TYPE_REVOCATION:
            item.setCertificateVersion(2);
            item.setIdPkiCertificateType(PkiCertificateType.TYPE_CRL);
            type = new PkiCertificateType(PkiCertificateType.TYPE_CRL);
            vIssuer = PkiCertificateDn.getAllRootDN();
            break;
        }
	}

	HtmlBeanTableTrPave pave = new HtmlBeanTableTrPave();
	pave.bIsForm = true;
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
%>
<link rel="stylesheet" type="text/css" href="<%=rootPath %>include/component/calendar/calendar.css" media="screen" />
<script type="text/javascript" src="<%=rootPath %>include/component/calendar/calendar.js"></script>
<script type="text/javascript" src="<%= rootPath %>include/AjaxComboList.js?v=<%= JavascriptVersion.AJAX_COMBO_LIST_JS %>"></script>
<script type="text/javascript">
var acPP;
function addHidden(name){
    var hidden = document.createElement("input");
    hidden.type = "hidden";
    hidden.name = name;
    hidden.value = $(name).value;
    
    $(name).name = $(name).id = name+"_disabled";
    
    $("formulaire").appendChild(hidden);
}
function init(){
    //level
    $("lIdPkiCertificateLevel").disabled = true;
    addHidden("lIdPkiCertificateLevel");
    
    //version
    $("lCertificateVersion").disabled = true;
    addHidden("lCertificateVersion");
    
    //algo sign
    $("sSignatureAlgorithm").disabled = true;
    addHidden("sSignatureAlgorithm");
    
    //DN
    acPP = new AjaxComboList("lIdPersonnePhysique", "getPersonnePhysiqueAllTypeWithOrg");
    acPP.init(<%= personne.getId()%>);
    if($("cbAutoRootDN")){
        acPP.addActionOnChange("completeDN()");
        $("cbAutoRootDN").onclick = function(){
            completeDN();
        }
        $("cbAutoRootDN").checked = true;
        $("cbAutoRootDN").onclick();
    }
    
    //SN
    if($("cbAutoSerial")){
	    $("cbAutoSerial").onclick = function(){
	        if(this.checked){
	           $("sSerialNumber").value = "";
	           $("sSerialNumber").disabled = true;
	        }else{
	           $("sSerialNumber").disabled = false;
	        }
	    }
	    $("cbAutoSerial").checked = true;
	    $("cbAutoSerial").onclick();
    }
    
    //password
    if($("sCertificatePassword")){
	    $("sCertificatePassword").onkeyup = function(){
	        var sec = mt.security.ratePassword(this.value);
	        $("sCertificatePasswordSecurity").innerHTML = sec.returnString;
	        $("sCertificatePasswordSecurity").style.color = sec.returnColor;
	        
	        if(<%= sessionUserHabilitation.isSuperUser() %> && isNotNull(this.value))
	            $("sCertificatePasswordClear").innerHTML = " (admin view : "+this.value+")";
	        else
	            $("sCertificatePasswordClear").innerHTML = "";
	    }
	    $("sCertificatePassword").onkeyup();
    }
    
}
function initRootCertificate(){
    init();  
}
function initIntermediateCertificate(){
    init();  
}
function initUserCertificate(){
    init();  
}
function initRevocationCertificate(){
    init();  
    //type
    $("lIdPkiCertificateType").disabled = true;
    addHidden("lIdPkiCertificateType");
}
function completeDN(){
    if($("cbAutoRootDN") && $("cbAutoRootDN").checked){
        var select = $("AJCL_sel_lIdPersonnePhysique");
        if(select.options.selectedIndex>=0){
            var optionSelected = select.options[select.options.selectedIndex];
            var jsonPP = optionSelected.obj;
                      
            $("sCommonName").value = jsonPP.sPrenom + " "+jsonPP.sNom;
            $("sOrganizationUnit").value = jsonPP.sFonction;
            $("sOrganization").value = jsonPP.organisation.sRaisonSociale;
            $("sLocality").value = jsonPP.organisation.adresse.sCommune;
            $("sState").value = jsonPP.organisation.adresse.pays.sLibelle;
            $("sCountryCode").value = jsonPP.organisation.adresse.pays.sIso3166Alpha2;;
            $("sEmail").value = jsonPP.sEmail;
        }
    }else{clearDN();}
}
function clearDN(){
    $("sCommonName").value = "";
    $("sOrganizationUnit").value = "";
    $("sOrganization").value = "";
    $("sLocality").value = "";
    $("sState").value = "";
    $("sCountryCode").value = "";
    $("sEmail").value = "";
}
onPageLoad = function(){

    switch($("lIdPkiCertificateLevel").value){
        case "<%= PkiCertificateLevel.TYPE_INTERMEDIATE %>":
        initIntermediateCertificate();
        break;
        case "<%= PkiCertificateLevel.TYPE_ROOT %>":
        initRootCertificate();
        break;
        case "<%= PkiCertificateLevel.TYPE_USER %>":
        initUserCertificate();
        break;
        case "<%= PkiCertificateLevel.TYPE_REVOCATION %>":
        initRevocationCertificate();
        break;
    }
}
</script>
</head>
<body>


<%@ include file="/include/new_style/headerFiche.jspf" %>
<form action="<%= response.encodeURL("modifyCertificate.jsp") %>" method="post" name="formulaire" id="formulaire" class="validate-fields">
<div id="fiche">
	    <% if(!sAction.equalsIgnoreCase("create")){%>
	    <div class="mention_altColor_center">
        Date creation :<%= CalendarUtil.getDateCourte(item.getDateCreation())%>
        Date modification :<%= CalendarUtil.getDateCourte(item.getDateModification())%>
	    </div>
	    <%} %>
        <input type="hidden" name="lId" value="<%= item.getId() %>" />
		<input type="hidden" name="sAction" value="<%= sAction %>" />
		<table class="formLayout" cellspacing="3">
		<% if(item.getIdPkiCertificateLevel()!=PkiCertificateLevel.TYPE_REVOCATION){ %>
			<%= pave.getHtmlTrInput("Common Name :", "sCommonName", subject.getCommonName(),"class=\"dataType-notNull\" size=\"100\"") %>
	        <%= pave.getHtmlTrInput("Organization Unit :", "sOrganizationUnit", subject.getOrganizationUnit(),"class=\"dataType-notNull\" size=\"100\"") %>
	        <%= pave.getHtmlTrInput("Organization :", "sOrganization", subject.getOrganization(),"class=\"dataType-notNull\" size=\"100\"") %>
	        <%= pave.getHtmlTrInput("Locality :", "sLocality", subject.getLocality(),"class=\"dataType-notNull\" size=\"100\"") %>
	        <%= pave.getHtmlTrInput("State :", "sState", subject.getState(),"class=\"dataType-notNull\" size=\"100\"") %>
	        <%= pave.getHtmlTrInput("Country Code :", "sCountryCode", subject.getCountryCode(),"class=\"dataType-notNull\" size=\"100\"") %>
	        <%= pave.getHtmlTrInput("Email :", "sEmail", subject.getEmail(),"class=\"dataType-notNull\" size=\"100\"") %>
	    <%} %>
			<% if(item.getIdPkiCertificateLevel()!=PkiCertificateLevel.TYPE_ROOT){ %>
			<tr>
				<td class="pave_cellule_gauche">Issuer  :</td>
				<td class="pave_cellule_droite">
					<%= CoinDatabaseAbstractBeanHtmlUtil.getHtmlSelect("lIdPkiCertificateDnIssuer",1,vIssuer,item.getIdPkiCertificateDnIssuer(),"class=\"dataType-notNull\"",false,false)  %>
				</td>
			</tr>
			<%} %>
			<tr>
                <td class="pave_cellule_gauche">Alias :</td>
                <td class="pave_cellule_droite">
                    <input type="text" name="sAlias" id="sAlias" class="dataType-notNull" value="<%= item.getAlias() %>"/>
                </td>
            </tr>
			<tr>
				<td class="pave_cellule_gauche">Type :</td>
				<td class="pave_cellule_droite"><%= type.getAllInHtmlSelect("lIdPkiCertificateType",1,"class=\"dataType-notNull\"") %></td>
			</tr>
            <tr>
                <td class="pave_cellule_gauche">Level :</td>
                <td class="pave_cellule_droite">
                <%= level.getAllInHtmlSelect("lIdPkiCertificateLevel",1,"class=\"dataType-notNull\"") %>
                </td>
            </tr>
            <tr>
                <td class="pave_cellule_gauche">State :</td>
                <td class="pave_cellule_droite"><%= state.getAllInHtmlSelect("lIdPkiCertificateState",1,"class=\"dataType-notNull\"") %></td>
            </tr>
            <tr>
                <td class="pave_cellule_gauche">Personne :</td>
                <td class="pave_cellule_droite">

                    <button type="button" id="AJCL_but_lIdPersonnePhysique" 
                    class="<%= CSS.DESIGN_CSS_MANDATORY_CLASS %>" ><%= personne.getName() %></button>
                    <input class="dataType-notNull dataType-id dataType-id dataType-integer" 
                        type="hidden" id="lIdPersonnePhysique"
                        class="dataType-notNull"
                         name="lIdPersonnePhysique" value="<%= personne.getId() %>" />
                    <% if(item.getIdPkiCertificateLevel()!=PkiCertificateLevel.TYPE_REVOCATION){ %>
                    <input type="checkbox" id="cbAutoRootDN" /> Préremplir le DN
                    <%} %>
                </td>
            </tr>  
            <% if(item.getIdPkiCertificateLevel()==PkiCertificateLevel.TYPE_USER){ %>
            <%= pave.getHtmlTrInput("Issuer order :", "sIssuerOrder", item.getIssuerOrder(),"size=\"100\"") %>
            <%} %> 
			<tr>
				<td class="pave_cellule_gauche">Date order :</td>
				<td class="pave_cellule_droite">
					<input type="text" class="dataType-date" name="tsDateOrder" value="<%= 
							CalendarUtil.getDateCourte(item.getDateOrder()) %>"/> 
				</td>
			</tr>
			<tr>
				<td class="pave_cellule_gauche">Serial number :</td>
				<td class="pave_cellule_droite">
					<input type="text" name="sSerialNumber" id="sSerialNumber" class="dataType-integer" value="<%= item.getSerialNumber() %>"/>
					<input type="checkbox" id="cbAutoSerial" /> Génération Auto
				</td>
			</tr>
			<tr>
				<td class="pave_cellule_gauche">Date validity start :</td>
				<td class="pave_cellule_droite">
					<input type="text"class="dataType-date dataType-notNull"  name="tsDateValidityStart" value="<%=  
							CalendarUtil.getDateCourte(item.getDateValidityStart()) %>"/> 
				</td>
			</tr>
			<tr>
				<td class="pave_cellule_gauche">Date validity end :</td>
				<td class="pave_cellule_droite">
					<input type="text" class="dataType-date dataType-notNull" name="tsDateValidityEnd" value="<%=
							CalendarUtil.getDateCourte(item.getDateValidityEnd()) %>"/> 
					</td>
			</tr>
			<% if(item.getIdPkiCertificateLevel()!=PkiCertificateLevel.TYPE_REVOCATION){ %>
			<tr>
				<td class="pave_cellule_gauche">Certificate Password :</td>
				<td class="pave_cellule_droite">
					<input type="password" maxlength="7" size="7" class="dataType-notNull dataType-maxLength-7" name="sCertificatePassword" id="sCertificatePassword" value="<%= 
							item.getCertificatePassword() %>"/> 
                    Niveau de sécurité du mot de passe<span id="sCertificatePasswordClear"></span> : <span style="font-weight:bold" id="sCertificatePasswordSecurity"></span>
				</td>
			</tr>
			<%} %>
            <tr>
                <td class="pave_cellule_gauche"> X509Extensions extension :</td>
                <td class="pave_cellule_droite">
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
                </td>
            </tr>
			<tr>
				<td class="pave_cellule_gauche">Signature Algorithm :</td>
				<td class="pave_cellule_droite">
					<select name="sSignatureAlgorithm" id="sSignatureAlgorithm" class="dataType-notNull">
                        <option value=""></option>
                        <option value="SHA1withRSA" selected="selected">SHA1RSA</option>
					</select>
				</td>
			</tr>
<%
	String sCertificateVersionSelectedUndefined = "selected='selected'";
	String sCertificateVersionSelectedV1 = "";
	String sCertificateVersionSelectedV2 = "";
	String sCertificateVersionSelectedV3 = "";

	switch((int) item.getCertificateVersion() ){
	case 1 : 
		sCertificateVersionSelectedV1 = "selected='selected'";
		sCertificateVersionSelectedV2 = "";
		sCertificateVersionSelectedV3 = "";
		break;

	case 2 : 
		sCertificateVersionSelectedV1 = "";
		sCertificateVersionSelectedV2 = "selected='selected'";
		sCertificateVersionSelectedV3 = "";
		break;

	case 3 : 
		sCertificateVersionSelectedV1 = "";
		sCertificateVersionSelectedV2 = "";
		sCertificateVersionSelectedV3 = "selected='selected'";
		break;

	}

%>
			<tr>
				<td class="pave_cellule_gauche">Certificate Version :</td>
				<td class="pave_cellule_droite">
					<select name="lCertificateVersion" id="lCertificateVersion" class="dataType-notNull">
                        <option <%= sCertificateVersionSelectedUndefined %> value="0"></option>
                        <option <%= sCertificateVersionSelectedV1 %> value="1">V1</option>
						<option <%= sCertificateVersionSelectedV2 %> value="2">V2</option>
						<option <%= sCertificateVersionSelectedV3 %> value="3">V3</option>
					</select>
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

</html>