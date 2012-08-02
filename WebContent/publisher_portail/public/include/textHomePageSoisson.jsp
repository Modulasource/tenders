
<%@ page import="java.util.Vector" %>
<%@ page import="modula.graphic.*" %>
<%@ include file="../../../publisher_traitement/public/include/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath()+"/";
%>
<div class="titre_page" style="font-size:10">Bienvenue sur le portail de dématérialisation des marchés publics.<br /></div>
<br />
<table summary="none">
  <tr>
    <td style="width:30%"><p align="center"><img src="public/include/Entreprises2.jpg" style="text-align:center"/></p></td>
    <td style="width:70%"><p><strong><span class="rouge">ENTREPRISES</span></strong>&nbsp;consultez 
    <a href="<%=response.encodeURL("public/annonce/afficherAnnonces.jsp")%>">les annonces l&eacute;gales</a> et t&eacute;l&eacute;chargez les dossiers de consultation des entreprises en vous inscrivant sur la plate-forme. </p>
        <p> La plateforme vous permet également quand la collectivité le souhaite de formuler votre réponse en ligne de manière sécurisée. </p>
        <p> Attention, pour effectuer cette dernière action vous devez vous munir d&rsquo;un <a href="<%=response.encodeURL("public/pagesStatics/certificat/commanderCertificat.jsp")%>">certificat &eacute;lectronique</a> &eacute;manant d&rsquo;une autorit&eacute; de certification agr&eacute;e par le MINEFI et vous laisser guider par nos conseils d&rsquo;utilisation. </p></td>
  </tr>
</table>
<br />