
<%@ page import="java.util.Vector" %>
<%@ page import="modula.graphic.*" %>
<%@ include file="../../../publisher_traitement/public/include/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath()+"/";
%>
<%
	String sBannerKeyWord = "afficherAnnonces"; 
	String sCurrentSiteWeb = "";

%>
<%@ include file="/include/publicite/oas_tag.jspf"%>  
<div style="font-size:10;color:#C30;text-align:center;text-transform:uppercase;font-weight:bold">
	Veille de marchés gratuite aux entreprises ! Profitez-en, inscrivez vous !
</div>
<br />
<table cellpadding="0" cellspacing="0" >
  <tr>
    <td >
    	<p>CONSULTEZ GRATUITEMENT <a href="<%= response.encodeURL("public/annonce/afficherAnnonces.jsp") %>">LES LEGALES</a> 
    	DE VOTRE REGION couverte par Eurosud !</p>
        <p> En vous connectant sur cette plateforme sécurisée, consultez tous les marchés dématérialisés 
        et téléchargez sans attendre les dossiers de consultation ! </p>
        <p> Attention, pour soumissionner au format électronique vous devez vous munir 
        d'un <a href="<%=response.encodeURL("public/pagesStatics/certificat/commanderCertificat.jsp")%>">
        certificat électronique</a> émanant d'une autorité de certification agréée par le MINEFE
         et vous laisser guider par nos conseils d'utilisation. 
        </p>
        
        
    	<br/>    
	     <table align="center" >
			<tr>
				<td style="color:#c30;font-weight:bold">
						Comment exploiter cet outil en ligne ?
				</td>
			</tr>
			<tr>
				<td>
					Laissez vous guider par notre Hotline utilisateurs : <br />
					<div class="rouge" style="font-size:11px;font-weight:bold"><br />
						0892 23 02 41
						(0,34 &euro; / minute)
						<img src="<%=rootPath %>publisher_traitement/public/pagesStatics/images/assistance.gif" style="vertical-align:middle;width:35px;height:37px" alt="Hotline" />
					</div>
				</td>
			</tr>
		</table>
        
        
	</td>
    <td style="width:300px; height:250px; " >
    	<div class="bloc_home_pub"><p><script>
      		OAS_AD('Position2');
		</script></p></div>

    </td>
  </tr>
</table>
<br />
