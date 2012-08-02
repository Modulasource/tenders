<%@page import="modula.candidature.Candidature"%>
<%@page import="org.modula.applet.signature.SignatureApplet"%>
<%@page import="org.coin.applet.AppletJarVersion"%>
<%@page import="org.modula.common.util.applet.AppletContainer"%>
<%@page import="java.util.logging.Level"%>
<%@page import="modula.candidature.EnveloppeA"%>
<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%@page import="modula.candidature.Enveloppe"%>
<%@page import="org.coin.bean.UserHabilitation"%>
<%@page import="modula.marche.Marche"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="mt.modula.html.HtmlCachetage"%>
<%@page import="org.coin.util.*"%>
<%@page import="org.coin.bean.conf.Configuration"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>
<%@page import="java.util.Vector"%>
<%@page import="modula.applet.util.*"%>
<%@page import="modula.applet.AppletConstitutionEnveloppe"%>
<%@page import="modula.configuration.*"%>
<%@page import="modula.servlet.applet.DownloadAllCandidatures"%>
<%@page import="modula.servlet.applet.DownloadAllEnveloppes"%>
<%
	String rootPath = request.getContextPath() +"/";
	Marche marche = (Marche) request.getAttribute("marche");
	PersonnePhysique candidat = (PersonnePhysique) request.getAttribute("candidat");
	String sTitle = (String) request.getAttribute("sTitle");
	String sAppletTypeEnveloppe = (String) request.getAttribute("sAppletTypeEnveloppe");
	String sAppletAllLotSelectionne = (String) request.getAttribute("sAppletAllLotSelectionne");
	Enveloppe eEnveloppe = (Enveloppe) request.getAttribute("eEnveloppe");
	Timestamp tsAppletDateLimiteEnvoi = (Timestamp) request.getAttribute("tsAppletDateLimiteEnvoi");
	UserHabilitation sessionUserHabilitation = (UserHabilitation) request.getAttribute("sessionUserHabilitation");
	

	
	/**
     * TODO remettre la sécurité
     */
    String sUrlCipherKey = HttpUtil.getUrlWithProtocolAndPortToExternalFormWithJSESSIONID(
	        rootPath + "publisher_portail/ChiffrementServletPublisher", request , response);
	
	String sUrlUploadFile =  HttpUtil.getUrlWithProtocolAndPortToExternalFormWithJSESSIONID(
	        rootPath + "publisher_portail/UploadEnveloppe", request , response);
	
	
    String sUrlTestProxy =  HttpUtil.getUrlWithProtocolAndPortToExternalFormWithJSESSIONID(
            rootPath + "EchoServlet", request , response);
	
	
	HtmlCachetage htmlCachetage = HtmlCachetage.newInstance();
    htmlCachetage.init(request,marche);
    htmlCachetage.iTypeApplet = AppletConstant.APPLET_CONSTITUTION_ENVELOPPE;
    sTitle = htmlCachetage.sTitle;
    
    if(!htmlCachetage.sPageUseCaseId.equalsIgnoreCase(""))
        sessionUserHabilitation.isHabilitateException(htmlCachetage.sPageUseCaseId);
 
    
      
    // voir pour  les hors délais
     
    JSONArray jsonEnveloppePJ = DownloadAllEnveloppes.getAllJSONSecureSession(
    		sAppletTypeEnveloppe, 
            AppletConstant.APPLET_CONSTITUTION_ENVELOPPE , // voir pour l'autre aussi  APPLET_DEMANDE_INFOS_COMPLEMENTAIRES
            eEnveloppe.getIdEnveloppe(),
            session);
   
    String sAppletUserAgent = request.getHeader("User-Agent");
    String sAppletTypeEnveloppeName = "";
    if(sAppletTypeEnveloppe.equals("A")) {
    	sAppletTypeEnveloppeName = "candidature";
    } else if(sAppletTypeEnveloppe.equals("B")) {
        sAppletTypeEnveloppeName = "offre";
    } else if(sAppletTypeEnveloppe.equals("C")) {
        sAppletTypeEnveloppeName = "offre";
    }
   

    /*
	String sUrlDownloadRepository 
	= HttpUtil.getUrlWithProtocolAndPort(
			 rootPath +  "include/jar/",
			request).toExternalForm();
	*/
	
	String sUrlDownloadRepository
	= HttpUtil.getUrlWithProtocolAndPortToExternalFormWithJSESSIONID(
			rootPath + "CoinJarDownloaderServlet?sContext=AppletContainer&sJarName=",
            request , response);


	String sLocalApplicationSubDir = AppletJarVersion.getLocalApplicationSubDir();
	String sJarPath = AppletJarVersion.getJarPath(rootPath);
	StringBuilder sbArchives = AppletJarVersion.getAppletContainerVersion(sJarPath);
	String sLibListCommon = AppletJarVersion.getSignatureAppletVersion();

	
    // pour les tests
   //tsAppletDateLimiteEnvoi = new Timestamp(System.currentTimeMillis() + 1000 * 10);

	request.setAttribute("htmlCachetage", htmlCachetage);
	request.setAttribute("eEnveloppe", eEnveloppe);
	
	session.setAttribute("eEnveloppe", eEnveloppe);
	session.setAttribute("candidat", candidat);
	session.setAttribute("marche",marche);
	session.setAttribute("htmlCachetage", htmlCachetage);
	session.setAttribute("sDateLimiteEnvoi",CalendarUtil.getDateWithFormat(tsAppletDateLimiteEnvoi,"dd/MM/yyyy HH:mm"));
	session.setAttribute("sTypeEnveloppe",sAppletTypeEnveloppe);
	
	
	String UrlSignerAndCipher=HttpUtil.getUrlWithProtocolAndPortToExternalFormWithJSESSIONID(
			rootPath + "publisher_traitement/private/candidat/pave/appletSignature.jsp",request,response);

%>
<jsp:include page="/test/javascriptApplet.jsp">
<jsp:param name="sAppletTypeEnveloppe" value="<%= sAppletTypeEnveloppe %>"></jsp:param>
</jsp:include>
<script type="text/javascript" src="<%= rootPath %>include/js/progressBar/mt.component.ProgressBar.js"></script>
<script type="text/javascript" src="<%= rootPath %>dwr/interface/ModulaAuth.js" ></script>
<script type="text/javascript" src="<%= rootPath %>dwr/interface/SupprimerEnveloppe.js" ></script>
<script type="text/javascript" src="<%= rootPath %>dwr/interface/DownloadAllEnveloppes.js" ></script>
<script type="text/javascript" src="<%= rootPath %>include/js/json.js" ></script>
<script type="text/javascript">
<!--
mt.config.enableAutoLoading = false;
//-->

var g_jsonEnveloppePJ = <%= jsonEnveloppePJ %>;
//var lTimeServeurEtDateLimiteEnvoi = <%= tsAppletDateLimiteEnvoi.getTime() / 100000 %> ;
var lTimeServeurEtDateLimiteEnvoi = 0;

var g_dateLimiteEnvoi =  new Date(<%= CalendarUtil.getDateStringForJavascript(tsAppletDateLimiteEnvoi) %>);


function updateTempsRestant()
{
    var dt=new Date();
    var dtTempsRestant=new Date();
    var lHeureServeur = dt.getTime() + lTimeOffset;
    dt.setTime(lHeureServeur );
    $("divAppletHeureServeur").innerHTML=dt.dateFormat("H:i:s") ;

    lTimeServeurEtDateLimiteEnvoi = g_dateLimiteEnvoi.getTime() - lHeureServeur;
    dtTempsRestant.setTime(lTimeServeurEtDateLimiteEnvoi );

    
    var reste = dtTempsRestant.getTime() ;
    if(reste <= 0) {
        var sMessage = "Le temps restant est écoulé !!\n"
            + "Vous ne pouvez plus télécharger de pièces, "
            + "votre candidature est invalide";
        alert(sMessage);
        clearInterval(g_timerTempsRestant); 
        $("divAppletTempsRestant").innerHTML 
           = "<span style='color:red' >" 
               + sMessage 
               + "</span>";

        Element.hide("divCertif");
        Element.hide("divEnveloppe");
        Element.hide("divAction");
                      
        return;
    }
        
    
    var nbJour = Math.floor((reste / (1000 * 3600 * 24))) ;
    reste = reste - nbJour * (1000 * 3600 * 24);
    var nbHeure = Math.floor( reste / (1000 * 3600 ) );
    reste = reste - nbHeure * (1000 * 3600 );
    var nbMinute = Math.floor( reste / (1000 * 60) );
    reste = reste - nbMinute * (1000 * 60 );
    var nbSeconde = Math.floor( reste / (1000 ) );
        
    $("divAppletTempsRestant").innerHTML 
        = nbJour + " jour(s) et " 
        + nbHeure + " h " + nbMinute + " min " + nbSeconde + " s";
        ;
       // + dtTempsRestant.dateFormat(" H:i:s") ;
    
}

/* toutes les 1 secs */
var g_timerTempsRestant = setInterval("updateTempsRestant()", 1000);

function displayAllSignature()
{
	var url = "<%= UrlSignerAndCipher %>";
	
	var title = "signer et chiffrer";		
	mt.utils.displayModal({
		type:"iframe",
		url:url,
		title:title,
		width:700,
		height:500
	});				
}

</script>
<div id="divTempsRestant">
    <div style="margin-top:20px;padding:4px;text-transform:uppercase;font-weight:bold;color: rgb(51, 102, 204);"
        >Information sur le dépôt 
    </div>
    
    <div class="round greyBar" corner="6" border="1">
        <div style="padding:5px">
         <table class="formLayout">
<!--             <tr>
              <td class="label" style="width: 120px">
                    Affaire : 
              </td>
              <td class="value">
                    <%= marche.getReference() + " " + marche.getObjet() + sAppletAllLotSelectionne %>
              </td>
            </tr>
 -->
            <tr>
              <td class="label" style="width: 120px">
                    Type d'enveloppe : 
              </td>
              <td class="value">
                    <%= sAppletTypeEnveloppeName %>
              </td>
            </tr>
            <tr>
              <td class="label" style="width: 120px">
                    Date limite d'envoi : 
              </td>
              <td class="value">
                    le <%=  CalendarUtil.getDateWithFormat(tsAppletDateLimiteEnvoi,"dd/MM/yyyy à HH:mm") %>
              </td>
            </tr>
            <tr>
              <td class="label" style="width: 120px">
                    Heure du serveur : 
              </td>
              <td class="value">
                    <div id="divAppletHeureServeur"></div>
              </td>
            </tr>            
            <tr>
              <td class="label" style="width: 120px">
                    Temps restant : 
              </td>
              <td class="value">
                    <div id="divAppletTempsRestant"></div>
              </td>
          </tr>  
        </table>          
        </div>
     </div>
</div>

<div id="divEnveloppe">
	<div style="margin-top:20px;padding:4px;text-transform:uppercase;font-weight:bold;color: rgb(51, 102, 204);"
	>Enveloppe</div>
	<div class="round greyBar" corner="6" border="1">
	    <div style="padding:5px">
	    <table class="formLayout">
          <tr>
              <td class="label">
                   Fichiers dans le coffre-fort : 
              </td>
              <td class="value">
                <div id="divEnveloppePJ"></div>
              </td>
          </tr>
	    </table>
	    </div>
	</div>
</div>

<div id="divAction">
    <div style="margin-top:20px;padding:4px;text-transform:uppercase;font-weight:bold;color: rgb(51, 102, 204);"
    >Mettre fin</div>
    <div class="round greyBar" corner="6" border="1">
        <div style="padding:5px">		
			<table>
			  <tr>
			    <td style="border:2px  solid #DDFFDD; ">
			    </td>
			    	<br/>
			    	<input type="button" value="Déposer un nouveau fichier " onclick="displayAllSignature();" />
			    	<br/>
			    <td>
			    </td>
			    	
			  </tr>
			</table>
		</div>
	</div>
</div>
