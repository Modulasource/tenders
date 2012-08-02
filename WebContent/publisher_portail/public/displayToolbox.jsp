<%@ include file="/include/new_style/headerPublisher.jspf" %>

<%@ include file="/publisher_traitement/public/include/beanCandidat.jspf" %>
<%
    String sTitle = "Boite à outils" ;
	String sPageUseCaseId = "IHM-PUBLI-3";	


%>
<script type="text/javascript" src="<%=rootPath %>include/js/ImageReflection.js"></script>
<script>
onPageLoad = function(){
    activateImagesReflections();
}
</script>
<%@ include file="/publisher_traitement/public/include/redirectOnLoad.jspf" %>

</head>
<body>
<%@ include file="/publisher_traitement/public/include/header.jspf" %>


<table width="100%">
<tr><td>

<div class="post">
    <div class="post-title">
        <table class="fullWidth" cellpadding="0" cellspacing="0">
        <tr>
            <td>
                <strong style="color:#36C">Certificat</strong>
            </td>
            <td class="right">
           </td>
        </tr>
        </table>
    </div>
  <br/>
  <div class="post-footer post-block" style="margin-top:0">
    <table class="fullWidth">

         <tr>
            <td style="text-align:right; width:20%">
                <img alt="commander un certificat" src="<%= rootPath %>images/icons/36x36/certificate_add.png" />
            </td>
            <td style="vertical-align:middle;" >
              <a href="<%= response.encodeURL(rootPath 
            		  + "publisher_portail/public/pagesStatics/certificat/commanderCertificat.jsp")
              %>">&nbsp;&nbsp;&nbsp;Commander un certificat</a>
            </td>
        </tr>
        
        <tr>
            <td style="text-align:right; width:20%">
                <img alt="liste des autorités" src="<%= rootPath %>images/icons/36x36/certificate.png" />
            </td>
            <td style="vertical-align:middle;" >
              <a href="<%= response.encodeURL(rootPath 
            		  + "publisher_portail/public/pagesStatics/certificat/listeAutorites.jsp")
              %>">&nbsp;&nbsp;&nbsp;Liste des autorités</a>
            </td>
        </tr>
        
        <tr>
            <td style="text-align:right; width:20%">
                 <img alt="utilitaires" src="<%= rootPath %>images/icons/36x36/certificate_validate.png" />
            </td>
            <td style="vertical-align:middle;" >
              <a href="<%= response.encodeURL(rootPath 
            		  + "publisher_portail/public/pagesStatics/certificat/verifierSignature.jsp")
            %>">&nbsp;&nbsp;&nbsp;Vérifier signature</a>
            </td>
       </tr>
    </table>
</div>
</div>

</td>
<td>

<div class="post">
    <div class="post-title">
        <table class="fullWidth" cellpadding="0" cellspacing="0">
        <tr>
            <td>
                <strong style="color:#36C">Législation</strong>
            </td>
            <td class="right">
                <strong style="color:#B00">&nbsp;</strong>
            </td>
        </tr>
        </table>
    </div>
  <br/>
  <div class="post-footer post-block" style="margin-top:0">
    <table class="fullWidth">
        <tr>
            <td style="text-align:right; width:20%">
                 <img alt="utilitaires" src="<%= rootPath %>images/icons/36x36/vcard.png" />
            </td>
            <td style="vertical-align:middle;" >
              <a href="<%= response.encodeURL(rootPath 
            		  + "publisher_portail/public/pagesStatics/legislation/formulairesUtiles.jsp") 
                %>">&nbsp;&nbsp;&nbsp;Formulaires utiles</a>
            </td>
        </tr>
        
        <tr>
            <td style="text-align:right; width:20%">
                 <img alt="utilitaires" src="<%= rootPath %>images/icons/36x36/folder_lin.png" />
            </td>
            <td style="vertical-align:middle;" >
              <a href="<%= response.encodeURL(rootPath 
            		  + "publisher_portail/public/pagesStatics/legislation/liensUtiles.jsp" )
                %>">&nbsp;&nbsp;&nbsp;Liens utiles</a>
            </td>
        </tr>
        
        <tr>
            <td style="text-align:right; width:20%">
                 <img alt="utilitaires" src="<%= rootPath %>images/icons/36x36/legality_control.png" />
            </td>
            <td style="vertical-align:middle;" >
              <a href="<%= response.encodeURL(rootPath 
            		  + "publisher_portail/public/pagesStatics/legislation/reglementation.jsp") 
                %>">&nbsp;&nbsp;&nbsp;Règlementation</a>
            </td>
	    </tr>
	  </table>
</div>
</div>

</td></tr>
</table>

					
<%@include file="/publisher_traitement/public/include/footer.jspf"%>
</body>

<%@page import="mt.modula.site.ModulaDematSiteNational"%></html>