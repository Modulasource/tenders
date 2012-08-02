<%@ page import="java.util.Vector" %>
<%@ page import="modula.graphic.*" %>
<%@ include file="../../../publisher_traitement/public/include/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath()+"/";
	String sBannerKeyWord = "afficherAnnonces"; 
	String sCurrentSiteWeb = "";
%>
<%@ include file="/include/publicite/oas_tag.jspf"%>
<style>
.homepage_texte p{padding:10px;}
</style>  
<div style="font-size:16px;color:#C30;text-align:center;padding-top:15px">
	Bienvenue sur la plate-forme <strong>achatspublicscorse.com</strong> de la <strong>SITEC</strong>
</div>
<div style="padding:10px 50px 50px 50px;font-size:12px" class="homepage_texte">
	<p>
		Pour les opérateurs économiques, <strong>achatspublicscorse.com</strong> constitue un point d'accès de consultation des avis de marchés publics en Corse, et un guichet de téléchargement des dossiers de consultation et de transmission en ligne des offres.
	</p>
	<p>
		Enregistrer votre profil et créer votre bureau virtuel, en suivant la procédure d'inscription.
	</p>
	<p>
		Depuis cet espace confidentiel et sécurisé vous pourrez gérer vos réponses aux marchés et suivre l'évolution des dossiers déposés auprès des acheteurs publics clients de la plateforme.
	</p>
	<p>
		Cette plateforme est équipée du logiciel Modula Dématérialisation.<br/>
		Nous vous conseillons de lire attentivement les conditions générales d'utilisation de la plate-forme.
	</p>
</div>