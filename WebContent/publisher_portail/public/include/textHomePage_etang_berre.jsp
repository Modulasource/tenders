
<%@ page import="java.util.Vector" %>
<%@ page import="modula.graphic.*" %>
<%@ include file="../../../publisher_traitement/public/include/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath()+"/";
	String sPuce =  "style='list-style-image:url(" + rootPath + "images/icons/tiny_square_square.gif)' ";

%>
<div class="titre_page" style="font-size:10;color:#136efb">Bienvenue sur le portail dédié aux marchés publics de l'étang de Berre<br /></div>
<br />
<table summary="none">
  <tr>
    <td style="width:30%"><p align="center"><img src="public/include/Entreprises2.jpg" 
    	style="text-align:center"/></p></td>
    <td style="width:70%">
	En quelques clics et en toute sécurité, vous pourrez :<br/>
	<ul>
	<li <%= sPuce %> ><a href="<%=
	response.encodeURL("public/annonce/afficherAnnonces.jsp")%>">consulter</a> les avis d'appel public à la 
	concurrence de toutes nos procédures en cours, </li>
	<li <%= sPuce %> > télécharger les dossiers de consultation, </li>
	<li <%= sPuce %> > remettre votre réponse par voie électronique, </li>
	<li <%= sPuce %> > consulter les avis d'attribution.</li>
    </ul>
     
        
        
        </td>
        
        
  </tr>
</table>
<br />