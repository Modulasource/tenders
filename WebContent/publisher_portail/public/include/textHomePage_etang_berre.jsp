
<%@ page import="java.util.Vector" %>
<%@ page import="modula.graphic.*" %>
<%@ include file="../../../publisher_traitement/public/include/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath()+"/";
	String sPuce =  "style='list-style-image:url(" + rootPath + "images/icons/tiny_square_square.gif)' ";

%>
<div class="titre_page" style="font-size:10;color:#136efb">Bienvenue sur le portail d�di� aux march�s publics de l'�tang de Berre<br /></div>
<br />
<table summary="none">
  <tr>
    <td style="width:30%"><p align="center"><img src="public/include/Entreprises2.jpg" 
    	style="text-align:center"/></p></td>
    <td style="width:70%">
	En quelques clics et en toute s�curit�, vous pourrez :<br/>
	<ul>
	<li <%= sPuce %> ><a href="<%=
	response.encodeURL("public/annonce/afficherAnnonces.jsp")%>">consulter</a> les avis d'appel public � la 
	concurrence de toutes nos proc�dures en cours, </li>
	<li <%= sPuce %> > t�l�charger les dossiers de consultation, </li>
	<li <%= sPuce %> > remettre votre r�ponse par voie �lectronique, </li>
	<li <%= sPuce %> > consulter les avis d'attribution.</li>
    </ul>
     
        
        
        </td>
        
        
  </tr>
</table>
<br />