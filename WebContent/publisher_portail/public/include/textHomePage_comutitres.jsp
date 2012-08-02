
<%@ page import="java.util.Vector" %>
<%@ page import="modula.graphic.*" %>
<%@ include file="../../../publisher_traitement/public/include/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath()+"/";
%>
<div style="font-size:10;color:#C30;text-align:center;text-transform:uppercase;font-weight:bold">Veille de marchés gratuite aux entreprises ! Profitez-en, inscrivez vous !</div>
<br />
<table cellspacing="3" cellpadding="3">
  <tr>
    <td style="width:30%"><p align="center"><img src="public/include/Entreprises2.jpg" style="text-align:center"/></p></td>
    <td style="width:70%"><p>CONSULTEZ GRATUITEMENT <a href="<%=response.encodeURL("public/annonce/afficherAnnonces.jsp")%>">LES ANNONCES</a> publiées par Comutitres !
        <p> En vous connectant sur cette plateforme sécurisée, consultez tous les marchés dématérialisés et téléchargez sans attendre les dossiers de consultation ! </p>
        <p> Attention, pour soumissionner au format électronique vous devez vous munir d'un <a href="<%=response.encodeURL("public/pagesStatics/certificat/commanderCertificat.jsp")%>">certificat &eacute;lectronique</a> émanant d'une autorité de certification agrée par le MINEFI et vous laisser guider par nos conseils d'utilisation. 
        </p>
	</td>
  </tr>
</table>
<br />
<table class="paveClassic" summary="Accueil">
  <tr>
  	<td>
		<p style="text-align:center;color:#2361AA;font-weight:bold">
			&gt;&gt; <em>Pour plus de renseignements : utilisez notre hotline d&rsquo;information aux collectivités.</em><br /><br />
			0 892 230 241 (0.34 euros/minute)
		</p>
	</td>
</tr>
</table>