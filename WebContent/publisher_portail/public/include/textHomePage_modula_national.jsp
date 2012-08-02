
<%@ page import="java.util.Vector" %>
<%@ page import="modula.graphic.*" %>
<%@ include file="../../../publisher_traitement/public/include/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath()+"/";
%>
<div class="titre_page" style="font-size:10">Bienvenue sur le portail de dématérialisation national des marchés publics</div>
<br />
<table >
  <tr>
    <td style="width:30%"><p align="center"><img src="<%= rootPath %>images/callmeback2.jpg" style="text-align:center"/></p></td>
    <td style="width:70%"><p><strong><a href="public/annonce/afficherAnnonces.jsp"><span class="rouge">ENTREPRISES</span>&nbsp;consultez 
    les annonces légales</strong></a> et téléchargez les dossiers de consultation des entreprises en vous inscrivant sur la plate-forme. </p>
        <p> La plateforme vous permet également quand la collectivité le souhaite de formuler votre réponse en ligne de manière sécurisée. </p>
        <p> Attention, pour effectuer cette dernière action vous devez vous munir d'un 
        <a href="public/pagesStatics/certificat/commanderCertificat.jsp">certificat électronique</a> émanant 
        d'une autorité de certification agrée par le MINEFI et vous laisser guider par nos conseils d'utilisation. 
        </p></td>
  </tr>
</table>
<br />
<table >
  <tr>
    <td style="width:70%"><p><span class="rouge"><strong>ACHETEURS PUBLICS</strong></span>&nbsp;utilisez nos services en ligne pour&nbsp;:<br /><br />
        <ul>
          <li> Passer vos avis sur le portail et dans la rubrique &laquo;&nbsp;annonces légales&nbsp;&raquo; de notre journal, <br /><br /></li>
          <li> Mettre &agrave; disposition vos DCE, <br /><br /></li>
          <li> Et recevoir électroniquement les candidatures et les offres associées à vos marchés.</li>
        </ul>
	</td>
    <td style="width:30%"><p align="center"><img src="public/include/president2.gif" style="text-align:center" /></p></td>
  </tr>
</table>
<div style="text-align:center">
<a href="http://www.modula-demat.com/rl" target="_blank" class="pave_titre_gauche" style="color:#c30"> >> Visualisez la présentation animée de nos services</a>
</div><br />

<table class="paveClassic" style="width:100%" >
  <tr>
  	<td>
        <p><strong> Points forts&nbsp;: </strong></p>
        <ul>
          <li> Un <strong>impact r&eacute;gional fort</strong> en terme de visibilit&eacute;, <br /><br /></li>
          <li> Une solution <strong>validée et auditée</strong> par des spécialistes,<br /><br /></li>
          <li><strong> Complète, économique, simple d'utilisation</strong> . </li>
        </ul>
       </td>
      </tr>
     </table>
<br />

<br />
<p align="center">
	<a href="#" onclick="OuvrirPopup('http://prod.modula-demat.com/install/plaquette-RL.pdf',800,650,'menubar=no,scrollbars=yes,statusbar=no')" style="color:#c30;font-weight:bold" target="_blank"> &gt;&gt;T&eacute;l&eacute;charger la documentation au format PDF)
		<img src="<%=rootPath %>publisher_traitement/public/pagesStatics/images/pdf.gif" />
	</a>
</p>