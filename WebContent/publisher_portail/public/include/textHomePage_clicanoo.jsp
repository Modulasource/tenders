
<%@ page import="java.util.Vector" %>
<%@ page import="modula.graphic.*" %>
<%@ include file="../../../publisher_traitement/public/include/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath()+"/";
	String sPuce =  "style='list-style-image:url(" + rootPath + "images/icons/tiny_square_square.gif)' ";

%>
<div class="titre_page" style="font-size:10;color:#E2001A;text-align:center">Bienvenue sur notre portail dédié aux marchés publics<br /></div>
<br />
<table summary="none">
  <tr>
    <td style="width:30%"><p align="center"><img src="public/include/Entreprises2.jpg" 
    	style="text-align:center"/></p></td>
    <td style="width:70%">
	En quelques clics et en toute sécurité, vous pourrez :<br/>
	<ul>
	<li <%= sPuce %> ><a class="textHomePage" href="<%=
	response.encodeURL("public/annonce/afficherAnnonces.jsp")%>">consulter</a> les avis d'appel public à la 
	concurrence de toutes nos procédures en cours, </li>
	<li <%= sPuce %> > télécharger les dossiers de consultation, </li>
	<li <%= sPuce %> > remettre votre réponse par voie électronique, </li>
	<li <%= sPuce %> > consulter les avis d'attribution.</li>
    </ul>
     
	<p>Plus efficaces et moins coûteux : informatisons nos échanges !</p>

    <p> Attention, pour effectuer cette dernière action vous devez vous munir d'un 
    <a class="textHomePage" href="<%=response.encodeURL("public/pagesStatics/certificat/commanderCertificat.jsp")%>">certificat 
    électronique</a> émanant d'une autorité de certification agrée par le MINEFI et vous laisser 
    guider par nos conseils d'utilisation. </p>
      
    <br/>  
    <br/>  
    <br/>  
      
	<ul>
	<li <%= sPuce %> > 
	<a href="<%= rootPath %>desk" style="font-family:Arial;color:#E2001A;font-weight:bold;font-size:14px;" target="_blank">Acheteurs publics,
	 se connecter vers <img src="<%= rootPath %>images/modulaIco.gif" style="vertical-align:bottom;border:0" alt="none"/>ODULA
	</a>
	</li>
   </ul>
         
        </td>
  </tr>
</table>
<br />