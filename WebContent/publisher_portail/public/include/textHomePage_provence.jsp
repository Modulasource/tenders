
<%@ page import="java.util.Vector" %>
<%@ page import="modula.graphic.*" %>
<%@ include file="../../../publisher_traitement/public/include/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath()+"/";
%>
<div style="padding:10px 30px 30px 30px">

<div class="titre_page center">Bienvenue sur le portail de dématérialisation des marchés publics de La Provence</div>

<table>
  <tr>
    <td style="width:30%"><p align="center"><img src="public/include/Entreprises2.jpg" style="text-align:center"/></p></td>
    <td style="width:70%"><p><strong><span class="rouge">ENTREPRISES</span></strong>&nbsp;consultez 
    <a href="public/annonce/afficherAnnonces.jsp">les annonces l&eacute;gales</a> et t&eacute;l&eacute;chargez les dossiers de consultation des entreprises en vous inscrivant sur la plate-forme. </p>
        <p> La plateforme vous permet également quand la collectivité le souhaite de formuler votre réponse en ligne de manière sécurisée. </p>
        <p> Attention, pour effectuer cette dernière action vous devez vous munir d&rsquo;un <a href="public/pagesStatics/certificat/commanderCertificat.jsp">certificat &eacute;lectronique</a> &eacute;manant d&rsquo;une autorit&eacute; de certification agr&eacute;e par le MINEFI et vous laisser guider par nos conseils d&rsquo;utilisation. </p></td>
  </tr>
</table>
<br />
<table>
  <tr>
    <td style="width:70%"><p><span class="rouge"><strong>ACHETEURS PUBLICS</strong></span>&nbsp;utilisez nos services en ligne pour&nbsp;:<br /><br />
        <ul>
          <li> Passer vos avis sur le portail et dans la rubrique &laquo;&nbsp;annonces l&eacute;gales&nbsp;&raquo; de notre journal, <br /></li>
          <li> Mettre &agrave; disposition vos DCE, <br /></li>
          <li> Et recevoir &eacute;lectroniquement les candidatures et les offres associ&eacute;es &agrave; vos march&eacute;s.</li>
        </ul>
	</td>
    <td style="width:30%"><p align="center"><img src="public/include/president2.gif" style="text-align:center" /></p></td>
  </tr>
</table>
<div class="center" style="padding:15px">
	<a href="http://www.modula-demat.com/rl" target="_blank" class="pave_titre_gauche" style="color:#c30;font-size:13px;font-weight:bold">Visualisez la présentation animée de nos services</a>
</div>

<table class="fullWidth">
  <tr>
  	<td>
        <p><span class="rouge"><strong>Points forts :</strong></span></p><br/>
        <ul>
          <li> Un <strong>impact r&eacute;gional fort</strong> en terme de visibilit&eacute;, <br /></li>
          <li> Une solution <strong>valid&eacute;e et audit&eacute;e</strong> par des sp&eacute;cialistes,<br /></li>
          <li><strong> Compl&egrave;te, &eacute;conomique, simple d&rsquo;utilisation</strong> . </li>
        </ul>
       </td>
      </tr>
     </table>
<br />
<p class="pave_titre_gauche center">
	<em>Pour plus de renseignements : utilisez notre hotline d&rsquo;information aux collectivités.</em>
	<div style="margin-top:10px" class="center">
		<div style="text-align:center;font-size:12px;font-weight:bold;color:#ED2327">0892 23 02 41 (0,34 &euro; / minute)</div>
	</div>
</p>
<br />
<p align="center">
	<img class="middle" src="<%=rootPath %>publisher_traitement/public/pagesStatics/images/pdf.gif" />
	&nbsp;<a class="middle" href="javascript:void(0)" onclick="OuvrirPopup('http://prod.modula-demat.com/install/plaquette-RL.pdf',800,650,'menubar=no,scrollbars=yes,statusbar=no')" style="color:#c30;font-size:13px;font-weight:bold" target="_blank">Télécharger la documentation au format PDF</a>
</p>

</div>