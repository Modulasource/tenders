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
		Pour les op�rateurs �conomiques, <strong>achatspublicscorse.com</strong> constitue un point d'acc�s de consultation des avis de march�s publics en Corse, et un guichet de t�l�chargement des dossiers de consultation et de transmission en ligne des offres.
	</p>
	<p>
		Enregistrer votre profil et cr�er votre bureau virtuel, en suivant la proc�dure d'inscription.
	</p>
	<p>
		Depuis cet espace confidentiel et s�curis� vous pourrez g�rer vos r�ponses aux march�s et suivre l'�volution des dossiers d�pos�s aupr�s des acheteurs publics clients de la plateforme.
	</p>
	<p>
		Cette plateforme est �quip�e du logiciel Modula D�mat�rialisation.<br/>
		Nous vous conseillons de lire attentivement les conditions g�n�rales d'utilisation de la plate-forme.
	</p>
</div>