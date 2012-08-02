<%@ include file="/include/new_style/headerPublisher.jspf" %>

<%@ include file="/publisher_traitement/public/include/beanCandidat.jspf" %>
<%
    String sTitle = "Oubli du mot de passe ?" ;
	String sPageUseCaseId = "IHM-PUBLI-3";	
%>
</head>
<%@ include file="/publisher_traitement/public/include/redirectOnLoad.jspf" %>
<body>
<%@ include file="/publisher_traitement/public/include/header.jspf" %>


<%
if(ModulaDematSiteNational.isSite())
{
%>
<table class="fullWidth" >
<tr>
<td>

<div class="post">
    <div class="post-title">
        <table width="267" cellpadding="0" cellspacing="0" class="fullWidth">
        <tr>
            <td width="236">
                <strong style="color:#36C">Formations et accompagnement</strong></td>
            <td width="29" class="right">
                <strong style="color:#B00">&nbsp;</strong>            </td>
        </tr>
        </table>
    </div>
  <br/>
  <div class="post-footer post-block" style="margin-top:0">
    <table class="fullWidth" >        
 		 <tr>
            <td style="text-align:left; width:20%" ><p><strong>Vous souhaitez mettre en  &oelig;uvre la d&eacute;mat&eacute;rialisation des march&eacute;s publics au sein de votre  entreprise&nbsp;? Depuis 2006, nous avons form&eacute; et accompagn&eacute; plus de 1500  stagiaires en partenariat avec de nombreuses f&eacute;d&eacute;rations  professionnelles&nbsp;! </strong>(F&eacute;d&eacute;rations D&eacute;partementales du BTP, Chambres des  M&eacute;tiers,&hellip;)<br />
            <br />
                  <strong>Les + de notre formation&nbsp;: </strong></p>
                  <br />
              <ul>
                <li>La mise en  pratique effective sur les 10 plateformes les plus utilis&eacute;es</li>
                <li>Une veille  technologique et l&rsquo;acc&egrave;s r&eacute;serv&eacute; &agrave; un forum de discussion qui recense les  points critiques associ&eacute;s au param&eacute;trage de chaque outil</li>
                <li>Des exemples  de r&eacute;ponse sous la forme de vid&eacute;os consultables en ligne</li>
                <li>Un  accompagnement lors de votre premi&egrave;re r&eacute;ponse &eacute;lectronique</li>
              </ul>
              <br />
            <p style="color: red;"><strong>&gt;&gt; Consultez le catalogue complet de nos formations sur </strong><a href="http://www.modula-training.com" target="_blank"><strong>www.modula-training.com</strong></a><strong>&nbsp;! </strong></p>
            <a href="<%= response.encodeURL( rootPath 
            		  + "publisher_portail/public/pagesStatics/assistance/faq/faq.jsp" ) %>"></a></td>
          </tr>   
    </table>
    </div>
</div>

<%

}

%>


<table class="fullWidth" >
<tr>
<td>

<div class="post">
    <div class="post-title">
        <table class="fullWidth" cellpadding="0" cellspacing="0">
        <tr>
            <td>
                <strong style="color:#36C">Entreprises</strong>
            </td>
            <td class="right">
                <strong style="color:#B00">&nbsp;</strong>
            </td>
        </tr>
        </table>
    </div>
  <br/>
  <div class="post-footer post-block" style="margin-top:0">
    <table class="fullWidth" >

         <tr>
            <td style="text-align:right; width:20%" >
                <img alt="Présentation entreprise" src="<%= rootPath %>images/icons/36x36/presentation.png" />
            </td>
            <td style="vertical-align:middle;" >
              <a href="<%= response.encodeURL( rootPath 
            		  + "publisher_portail/public/pagesStatics/assistance/presentationEntreprise.jsp" ) %>">
                <span style="font-style:12px;font-weight:bold;" >
                    &nbsp;&nbsp;&nbsp;Présentation de la plateforme
                </span>
              </a>
            </td>
         </tr>
              
         <tr>
            <td style="text-align:right; width:20%" >
                 <img alt="formation" src="<%= rootPath %>images/icons/36x36/formation_client.png" />
            </td>
             <td style="vertical-align:middle;" >
              <a href="<%= response.encodeURL( rootPath 
            		  + "publisher_portail/public/pagesStatics/assistance/formations.jsp" ) %>">
                <span style="font-style:12px;font-weight:bold;" >
                    &nbsp;&nbsp;&nbsp;Formation et accompagnement
                </span>
              </a>
            </td>
         </tr>
         
         <tr>
            <td style="text-align:right; width:20%" >
                <img alt="Manuel utilisateur" src="<%= rootPath %>images/icons/36x36/user_manual.png" />
            </td>
            <td style="vertical-align:middle;" >
              <a target="_blank" href="http://prod.modula-demat.com/install/ManuelUtilisateur-PUBLISHER.pdf">
                <span style="font-style:12px;font-weight:bold;" >
                    &nbsp;&nbsp;&nbsp;Manuel utilisateur
                </span>
              </a>
            </td>
         </tr>
         
 		 <tr>
            <td style="text-align:right; width:20%" >
                <img alt="FAQ" src="<%= rootPath %>images/icons/36x36/candidates_fqr.png" />
            </td>
            <td style="vertical-align:middle;" >
              <a href="<%= response.encodeURL( rootPath 
            		  + "publisher_portail/public/pagesStatics/assistance/faq/faq.jsp" ) %>">
                <span style="font-style:12px;font-weight:bold;" >
                    &nbsp;&nbsp;&nbsp;Foire aux questions
                </span>
              </a>
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
                <strong style="color:#36C">Acheteurs publics</strong>
            </td>
            <td class="right">
                <strong style="color:#B00">&nbsp;</strong>
            </td>
        </tr>
        </table>
    </div>
  <br/>
  <div class="post-footer post-block" style="margin-top:0">
    <table class="fullWidth" >

         <tr>
            <td style="text-align:right; width:20%" >
                <img alt="Présentation acheteur public" src="<%= rootPath %>images/icons/36x36/presentation.png" />
            </td>
            <td style="vertical-align:middle;" >
              <a href="<%= response.encodeURL( rootPath 
            		  + "publisher_portail/public/pagesStatics/assistance/presentationAP.jsp" ) %>">
                <span style="font-style:12px;font-weight:bold;" >
                    &nbsp;&nbsp;&nbsp;Présentation de la solution
                </span>
              </a>
            </td>
         </tr>
    
         
        <tr>
            <td style="text-align:right; width:20%" >
                <img alt="formation" src="<%= rootPath %>images/icons/36x36/formation_client.png" />
            </td>
              <td style="vertical-align:middle;" >
              <a href="<%= response.encodeURL( rootPath 
            		  + "publisher_portail/public/pagesStatics/assistance/formationsAP.jsp") %>">
                <span style="font-style:12px;font-weight:bold;" >
                    &nbsp;&nbsp;&nbsp;Formation et accompagnement
                </span>
              </a>
            </td>
        </tr>
        
                <tr>
            <td style="text-align:right; width:20%" >
                <img alt="formation" src="<%= rootPath %>images/icons/36x36/contact.png" />
            </td>
              <td style="vertical-align:middle;" >
              <a href="<%= response.encodeURL( rootPath 
            		  + "publisher_portail/public/pagesStatics/assistance/contactAP.jsp") %>">
                <span style="font-style:12px;font-weight:bold;" >
                    &nbsp;&nbsp;&nbsp;Contactez-nous
                </span>
              </a>
            </td>
        </tr>

		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
        
  </table>
</div>
</div>

</td>
</tr>
</table>

<div class="post">
    <div class="post-title">
        <table class="fullWidth" cellpadding="0" cellspacing="0">
        <tr>
            <td>
                <strong style="color:#36C">Réponse électronique</strong>
            </td>
            <td class="right">
                <strong style="color:#B00">&nbsp;</strong>
            </td>
        </tr>
        </table>
    </div>
  <br/>
  <br/>
  <div class="post-footer post-block" style="margin-top:0">
    <table class="fullWidth" >

          <tr>
            <td style="text-align:right; width:20%" >
                 <img alt="utilitaires" src="<%= rootPath %>images/icons/36x36/package_settings.png" />
            </td>
            <td style="vertical-align:middle;" >
              <a href="<%= response.encodeURL(rootPath 
            		  + "publisher_portail/public/pagesStatics/assistance/utilitaires.jsp" ) %>">
                <span style="font-style:12px;font-weight:bold;" >
                    &nbsp;&nbsp;&nbsp;Utilitaires
                </span>
              </a>
            </td>
        </tr>
        
        <tr>
            <td style="text-align:right; width:20%" > 
                <img alt="utilitaires" src="<%= rootPath %>images/icons/36x36/config.png" />
            </td>
             <td style="vertical-align:middle;">
              <a href="<%= response.encodeURL( rootPath
            		  + "publisher_portail/public/pagesStatics/checkComputerConformity.jsp") %>">
                <span style="font-style:12px;font-weight:bold;" >
                    &nbsp;&nbsp;&nbsp;Tester la configuration de votre poste pour la réponse électronique.
                </span>
              </a>
            </td>
        </tr>

  </table>
</div>
</div>

<%@include file="/publisher_traitement/public/include/footer.jspf"%>
</body>

<%@page import="mt.modula.site.ModulaDematSiteNational"%></html>