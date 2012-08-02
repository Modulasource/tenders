<%@page import="org.modula.applet.signature.SignatureApplet"%>
<%@page import="org.coin.applet.AppletJarVersion"%>
<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@page import="java.util.logging.Level"%>
<%@page import="org.coin.applet.CoinAppletContainer"%>
<%@page import="org.coin.bean.pki.certificate.PkiCertificate"%>
<% 
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);

	int iIdNextPhaseEtapes = HttpUtil.parseInt("iIdNextPhaseEtapes", request,-1);
    String sUrlTraitement = HttpUtil.parseStringBlank("sUrlTraitement", request);
    //String sAppletUserAgent = request.getHeader("User-Agent");

    HtmlDecachetage htmlDecachetage = HtmlDecachetage.newInstance();
    marche = new Marche(768);
    htmlDecachetage.init(request,marche);
    htmlDecachetage.iTypeApplet = AppletConstant.APPLET_DECACHETAGE_ENVELOPPE;
    String sTitle = htmlDecachetage.sTitle;
    
    if(!htmlDecachetage.sPageUseCaseId.equalsIgnoreCase(""))
        sessionUserHabilitation.isHabilitateException(htmlDecachetage.sPageUseCaseId);

    Vector<Vector<String>> vCand = DownloadAllCandidatures.getAll(
            htmlDecachetage.iTypeApplet,
            htmlDecachetage.marche.getIdMarche(),
            htmlDecachetage.sTypeEnveloppe,
            htmlDecachetage.iIdValidite);

	JSONArray jsonCand = DownloadAllCandidatures.toJSONArray(vCand);


	String sUrlDownloadRepository
	= HttpUtil.getUrlWithProtocolAndPortToExternalFormWithJSESSIONID(rootPath + "CoinJarDownloaderServlet?sContext=AppletContainer&sJarName=",
            request , response);

	
	String sLocalApplicationSubDir = AppletJarVersion.getLocalApplicationSubDir();
	String sJarPath = AppletJarVersion.getJarPath(rootPath );
	StringBuilder sbArchives = AppletJarVersion.getAppletContainerVersion(sJarPath);
	String sLibListCommon = AppletJarVersion.getSignatureAppletVersion();

	
		
	 //TODO process decachetage cf. DecachetagePieceJointeThread
	request.setAttribute("htmlDecachetage", htmlDecachetage);

	String sAppletUserAgent2 = request.getHeader("User-Agent");

%>
<jsp:include page="/desk/pki/decipher/javascriptAppletDecachetage.jsp" />
<script type="text/javascript" src="<%= rootPath %>dwr/interface/Candidature.js" ></script>
<script type="text/javascript" src="<%= rootPath %>dwr/interface/ModulaAuth.js" ></script>
<script type="text/javascript" src="<%= rootPath %>dwr/interface/SupprimerCandidature.js" ></script>
<script type="text/javascript">
var cand_dg;
var jsonCand = <%= jsonCand %>;
mt.config.enableAutoLoading = false;
var bIsAllCandidaturePapier = true;
var htmlDecachetage = <%= htmlDecachetage.toJSONObject() %>;
function displayCand(){
    cand_dg = new mt.component.DataGrid('cand_dg');
    cand_dg.addStyle("width","100%");
    //cand_dg.setColumnStyle(0, {width:"180px"});
    cand_dg.setHeader(['','Organisation', 'Fermeture','Poids','Statut']);
    jsonCand.each(function(cand, index){
        var title = '<strong><a class="dataType-tablink" href="<%= response.encodeURL(rootPath+"desk/organisation/afficherOrganisation.jsp?iIdOrganisation=")%>'+cand.iIdOrganisation+'">'+cand.sRaisonSociale+ '</a></strong>'+
        ' représentée par <a class="dataType-tablink" href="<%= response.encodeURL(rootPath+"desk/organisation/afficherPersonnePhysique.jsp?iIdPersonnePhysique=")%>'+cand.iIdPersonnePhysique+'">'+cand.sNom+' '+cand.sPrenom+'</a>';
        if(isNotNull(cand.sCommentaire))
           title += '<br/><i><u>Commentaire du candidat</u> : '+cand.sCommentaire+'</i>' 
	    cand.title = title;
	    var line = cand_dg.addItem(["",title,"",displayNumberFrench(cand.fOctetCandidature/(1024*1024))+" Mo",""]);
	    addStatusInfo(cand,line);
    });
    cand_dg.render(); 
}

function addStatusInfo(cand,line){
    var cb = document.createElement("input");
    cb.type="checkbox";
    var date = document.createElement("span");
    date.innerHTML = Date.parseIsoDate(cand.sDateFermeture).dateFormat("d/m/Y à H:i");
    var statut = document.createElement("span");

    line.cells[0].appendChild(cb);
    line.cells[2].appendChild(date);
    line.cells[4].appendChild(statut);

    cb.checked = true;
    cb.disabled = true;

	switch(cand.iStatut)
	{
	    case "0": 
	        cb.checked = false;
	        cb.disabled = true;
	        
	        date.style.color = "red";
	        
	        if(htmlDecachetage.sTypeEnveloppe=="A")
	            date.innerHTML = "Invalide";
	        else
	            date.innerHTML = "Non Recevable";
	        
	        statut.innerHTML = '<img src="<%= rootPath %>images/icons/exclamation.gif" />';
	        bIsAllCandidaturePapier = false;
	        break;
	        
	    case "1":
	        if(cand.iChiffrage == 1) 
	        {
	           statut.innerHTML = '<img src="<%= rootPath %>images/icons/lock.gif" />';
	        }
	        else 
	        {
	            cb.checked = true;
                cb.disabled = true;
	            
	            statut.innerHTML = '<img src="<%= rootPath %>images/icons/accept.gif" />';
	        }
	        bIsAllCandidaturePapier = false;
	        break;
	
	    case "2":
            cb.checked = false;
	        cb.disabled = false;
	        date.innerHTML = "Hors delais";
	        date.style.color = "red";
	        
	        if(cand.iChiffrage == 1) 
	        {
	           statut.innerHTML = '<img src="<%= rootPath %>images/icons/lock_date.gif" />';
	        }
	        else 
	        {
	            cb.checked = true;
                cb.disabled = true;
	            statut.innerHTML = '<img src="<%= rootPath %>images/icons/accept.gif" />';
	        }
	        bIsAllCandidaturePapier = false;
	        break;
	        
	    case "3":
	       statut.innerHTML = '<img src="<%= rootPath %>images/icons/script.gif" />';
	        break;
	        
	    case "4":
	        cb.checked = false;
	        cb.disabled = false;
            date.innerHTML = "Hors delais";
            date.style.color = "red";
	        
	        statut.innerHTML = '<img src="<%= rootPath %>images/icons/script.gif" />';
	        break;
	}
	
	if(!cb.disabled){
	   cb.onclick = function(){
            if(this.checked){
                this.checked = confirm("Cette enveloppe électronique a été cachetée hors délais par l'entreprise.\n"+
                "Vous pouvez prendre connaissance du motif de son retard avant de décider de décacheter ou non cette enveloppe (voir 'Commentaire du candidat').\n"+
                "Voulez-vous décacheter cette enveloppe?\n");
            }
	   }
	}
}
function initUI(){
    if(htmlDecachetage.bEnveloppesDecachetees){
        Element.show($("divEnveloppesDecachetees"));
    }else if(htmlDecachetage.bAddCandPapier){
        Element.show($("divCandPapier"));
    }else{
        Element.hide($("divCandPapier"));
    }
    
    if(!htmlDecachetage.bEnveloppesDecachetees && !htmlDecachetage.bAfficheDecachetage){
        Element.show($("divAnonymat"));
    }else if(!htmlDecachetage.bAddCandPapier){
        //show decachetage
        Element.show($("divCandidature"));
        Element.show($("decipher"));
        if(!bIsAllCandidaturePapier) Element.show($("divCertif"));
    }
    
    if(htmlDecachetage.bEnveloppesDecachetees){
        Element.show($("poursuivre"));
    }
    
    $("decipher").onclick = function(){
        var cert = isCertificateSelected();
        if(isNotNull(cert)){
            cert = cert.parseJSON();
            if(confirm("Vous etes sur le point de décacheter avec le certificat "+cert.sAlias+".\nVeuillez confirmer cette opération.")){
                decipher();
            }
        }else{
            alert("Afin de pouvoir décacheter, veuillez séléctionner un certificat");
        }
    }
    
    $("butCandPapierComplete").onclick = function(){
        htmlDecachetage.bAddCandPapier = false;
        initUI();
    }
}
var countDecipher;
function decipher(){
    jsonCand.each(function(cand, index){
       countDecipher ++;
       var lineData = cand_dg.dataSet[index];
       var cb = lineData.cells[0].getElementsByTagName("input")[0];
       
       cand.iIdValidite = htmlDecachetage.iIdValidite;
       cand.sTypeEnveloppe = htmlDecachetage.sTypeEnveloppe;
       cand.iTypeApplet = htmlDecachetage.iTypeApplet;
       cand.bSimulate = htmlDecachetage.bSimulate;
       cand.bAVActive = htmlDecachetage.bAVActive;
       
       if(cb.checked){
            startProgress(cand, index,"decipher");
            
            Candidature.decipher(Object.toJSON(cand),function(result){
                alert("decipher : "+result);
                var candReturn = result.parseJSON();
                if(isNotNull(candReturn.error)){
                    cand.error = candReturn.error;
                    abortProgress(cand, index,"decipher");
                }else if(isNotNull(candReturn.isVirus) && candReturn.isVirus){
                    cand.virus = candReturn.virus;
                    abortProgress(cand, index,"virus");
                }else{
                    doneProgress(cand, index,"decipher");
                }

                if(countDecipher == jsonCand.length){
                    htmlDecachetage.bEnveloppesDecachetees = true;
                    initUI();
                }
            });
       }else{
        startProgress(cand, index,"delete");
        SupprimerCandidature.doAjaxStatic(Object.toJSON(cand),function(result){
            alert("SupprimerCandidature : "+result);
            var candReturn = result.parseJSON();
            alert(candReturn.error);
            if(isNotNull(candReturn.error)){
                cand.error = candReturn.error;
                abortProgress(cand, index,"delete");
            }else{
                doneProgress(cand, index,"delete");
            }

            if(countDecipher == jsonCand.length){
                htmlDecachetage.bEnveloppesDecachetees = true;
                initUI();
            }
        });
       }
    });
}
function startProgress(cand, index,mode){
    var msg = "";
    switch(mode){
        case "decipher":
        msg = "Décachetage";
        break;
        case "delete":
        msg = "Suppression";
        break;
    }
    var lineData = cand_dg.dataSet[index];
    lineData.cells[1].style.backgroundColor = lineData.cells[2].style.backgroundColor = lineData.cells[3].style.backgroundColor = "#FFCC6D";
    lineData.cells[4].innerHTML = "<span style='margin-left:10px;'><span class='loader' style='padding-right:14px;'>&nbsp;</span>&nbsp;"+msg+" en cours...</span>";
}
function doneProgress(cand, index,mode){
    var msg = "";
    switch(mode){
        case "decipher":
        msg = "Décachetage";
        break;
        case "delete":
        msg = "Suppression";
        break;
    }
    var lineData = cand_dg.dataSet[index];
    lineData.cells[1].style.backgroundColor = lineData.cells[2].style.backgroundColor = lineData.cells[3].style.backgroundColor = "#B2D157";
    lineData.cells[4].innerHTML = "<span style='margin-left:10px;'><img src='<%= rootPath %>images/icons/accept.gif' />&nbsp;"+msg+" effectué</span>";
}
function abortProgress(cand, index,mode){
    var msg = "";
    var error = "";
    switch(mode){
        case "decipher":
        msg = "Décachetage impossible";
        error = cand.error;
        break;
        case "delete":
        msg = "Suppression impossible";
        error = cand.error;
        break;
        case "Virus":
        msg = "Virus détécté";
        error = cand.virus.sVirus+"<br/>"+cand.virus.sReport;
        break;
    }
    var lineData = cand_dg.dataSet[index];
    lineData.cells[1].style.backgroundColor = lineData.cells[2].style.backgroundColor = lineData.cells[3].style.backgroundColor = "#F75E5E";
    lineData.cells[4].innerHTML = "<span style='margin-left:10px;'><img src='<%= rootPath %>images/icons/exclamation.gif' />&nbsp;"+msg+" : "+error+"</span>";
}

onPageLoad = function() {
    displaySelectCertificate();
    displayCand();
    initUI();
    enableTabLinks();
}


</script>
</head> 
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<div id="fiche">

<div id="divEnveloppesDecachetees" style="display:none;text-align:center;">
	<div style="margin-top:20px;padding:4px;text-transform:uppercase;font-weight:bold;color:#8A6D7C">Enveloppes Décachetées</div>
	<div style="width:400px;margin-left: auto;margin-right: auto;" class="round greyBar" corner="6" border="1">
	<div style="padding:5px;">
	   <img src="<%= rootPath %>images/icones/succes.gif" style="vertical-align:middle" alt="Icone">
	   Le décachetage a été réalisé avec succès.
	</div>
	</div>
</div>



<div id="divCandPapier" style="display:none;text-align:center;">
    <div style="margin-top:20px;padding:4px;text-transform:uppercase;font-weight:bold;color:#8A6D7C">Candidatures Papiers</div>
    <div style="width:600px;margin-left: auto;margin-right: auto;" class="round greyBar" corner="6" border="1">
    <div style="padding:5px;">
       <img src="<%= rootPath %>images/icones/warning.gif" style="vertical-align:middle" alt="Icone">
       Attention après avoir décacheté les plis, vous ne pourrez plus ajouter de candidature papier.
       <br/><br/>
       <button type="button" onclick="parent.addParentTabForced('Chargement...','<%= response.encodeURL(rootPath+"desk/marche/algorithme/proposition/candidature/modifyCandidatureForm.jsp?iIdAffaire="+marche.getIdMarche()) %>')">Ajouter une candidature papier</button>
       <br/><br/>
       <button style="font-size:14pt" id="butCandPapierComplete" type="button">
       Le cas échéant, la liste des candidatures papiers est complète.<br/>L'ouverture des plis peut débuter.</button>
    </div>
    </div>
</div>

<div id="divAnonymat" style="display:none;text-align:center;">
    <div style="margin-top:20px;padding:4px;text-transform:uppercase;font-weight:bold;color:#8A6D7C">Option d'Anonymat</div>
    <div style="width:600px;margin-left: auto;margin-right: auto;" class="round greyBar" corner="6" border="1">
    <div style="padding:5px;">
        <form name="formulaire" id="formulaire" method="post" action="<%= response.encodeURL("decacheterEnveloppe.jsp") %>" >
		<input type="hidden" name="iIdNextPhaseEtapes" value="<%= iIdNextPhaseEtapes %>" />
		<input type="hidden" name="sUrlTraitement" value="<%= sUrlTraitement %>" />
		<input type="hidden" name="sAction" value="anonyme" />
		<input type="hidden" name="iTypeEnveloppe" value="<%= htmlDecachetage.iTypeEnveloppe %>" />
		<img src="<%=rootPath + Icone.ICONE_WARNING %>" style="vertical-align:middle" alt="Warning"/>
                Souhaitez-vous traiter les candidatures suivantes de façon anonyme?
        <br/><br/>
        <input type="radio" name="iAnonyme" value="1" />Oui&nbsp;&nbsp;
        <input type="radio" name="iAnonyme" value="2" checked="checked" />Non
        <br/><br/>
        <button type="submit" name="valider">Valider mon choix</button>
		</form>
    </div>
    </div>
</div>

<div id="divCertif" style="display:none;">
<div style="margin-top:20px;padding:4px;text-transform:uppercase;font-weight:bold;color:#8A6D7C">Certificate selection</div>
<div class="round greyBar" corner="6" border="1">
<div style="padding:5px">
     <table class="formLayout">
        <tr>
          <td class="label">
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
               <applet
	                OLD__code="org.coin.applet.CoinAppletContainer.class"
					code="org.modula.common.util.applet.AppletContainer.class"
					codebase="<%= sJarPath %>"
					archive="<%= sbArchives.toString() %>"               

                     OLD__archive="<%= 
                        	    rootPath + "include/jar/SCoinAppletContainer.jar?v=" + CoinAppletContainer.VERSION 
                             %>"

                width ="180"
                height="40"
                name="signatureAppletInstance" 
                id="signatureAppletInstance"
                mayscript="mayscript"  
                scriptable="true"
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
                    <param name="bDisplayButtonSignFiles" value="false" />
                    <param name="bDisplayButtonCipherFiles" value="false" />
                    <param name="bDisplayButtonDecipherFiles" value="false" />
                    <param name="bDisplayButtonUploadFiles" value="false" />
                    <param name="bDisplayButtonUserAgentCertificateList" value="false" />
                    <param name="bOnAppletInitDisplayUserAgentCertificateList" value="true" />
                    <param name="bDisplayButtonOpenPKCS12" value="true" />
                    <param name="bEnableDragNDrop" value="true" />  
                    <param name="bUseTempFolder" value="true" />
                    <param name="sColorBackground" value="#FAFAFA" />
                    <param name="sColorBackgroundOnDrag" value="#FFFFE0" />

                         <param name="sUserAgent" value="<%= sAppletUserAgent2  %>" />
                         <param name="bTraceMessageAppletJS" value="true" />

            </applet>
			<div id="divPKCS12FileCertificateList"></div>
          </td>
      </tr>
</table>
</div>
</div>
</div>

<div id="divCandidature" style="display:none;">
<div style="margin-top:20px;padding:4px;text-transform:uppercase;font-weight:bold;color:#8A6D7C">Candidatures *</div>
<div class="round greyBar" corner="6" border="1"><div style="padding:5px">
<div id="cand_dg"></div>
</div></div>
<br/>
<div class="mention">* Attention, seules les candidatures séléctionnées seront décachetées. Les autres seront définitivement supprimées.</div>
</div>

<br/>
<div id="fiche_footer">
<button type="button" style="display:none" id="decipher"><img src="<%= rootPath %>images/icons/lock_open.gif" alt="Décacheter" style="vertical-align:middle;margin-right: 5px;" />Décacheter</button>
<button type="button" id="verify" onclick="parent.addParentTabForced('Chargement...','<%= response.encodeURL(rootPath+"desk/utilitaires/checkConformityClientComputer.jsp") %>')"><img src="<%= rootPath %>images/icons/computer.gif" alt="Tester" style="vertical-align:middle;margin-right: 5px;" />Tester votre poste</button>
<button type="button" name="poursuivre" id="poursuivre"
        style="display:none"
        onclick="Redirect('<%= response.encodeURL(rootPath 
                + "desk/marche/algorithme/affaire/poursuivreProcedure.jsp"
                + "?sAction=next"
                + "&iIdAffaire=" + marche.getId() ) 
                %>')" ><img src="<%= rootPath %>images/icons/arrow_right.gif" alt="poursuivre" style="vertical-align:middle;margin-right: 5px;" />Poursuivre la procédure</button>
<%/*InfosBulles.getModal(htmlDecachetage.lIdInfoBulle,rootPath)*/ %>
</div>
</div>

            <span><i>Modula Sign V<%= SignatureApplet.VERSION %></i></span>

<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
<%@page import="org.coin.security.SecureString"%>
<%@page import="java.util.Vector"%>
<%@page import="modula.candidature.Candidature"%>
<%@page import="org.json.JSONArray"%>
<%@page import="modula.servlet.applet.DownloadAllCandidatures"%>
<%@page import="modula.applet.util.AppletConstant"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="modula.candidature.Enveloppe"%>
<%@page import="modula.marche.InfosBullesConstant"%>
<%@page import="mt.modula.html.HtmlDecachetage"%>
<%@page import="org.coin.util.InfosBulles"%>

<%@page import="modula.marche.Marche"%></html>
    