
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
    <td style="width:70%"><p>CONSULTEZ GRATUITEMENT <a href="<%=response.encodeURL("public/annonce/afficherAnnonces.jsp")%>">LES LEGALES</a>
         couverte par la Collectivité !
        <p> En vous connectant sur cette plateforme sécurisée, consultez tous les marchés dématérialisés et téléchargez 
            sans attendre les dossiers de consultation ! </p>
        <p> Attention, pour soumissionner au format électronique vous devez vous munir d'un 
            <a href="<%=response.encodeURL("public/pagesStatics/certificat/commanderCertificat.jsp")%>">
                certificat électronique</a> émanant d'une autorité de certification agréée par le MINEFE et vous 
            laisser guider par nos conseils d'utilisation. 
        </p>
	</td>
  </tr>
</table>
<div style="text-align:center">
<br />
<object type="application/x-shockwave-flash" classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" data="../templatesClients/teaser_mp.swf" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=5,0,0,0" width="468" height="70" id="teaser_mp" align="center">
<param name="allowScriptAccess" value="sameDomain" />
<param name="movie" value="../templatesClients/teaser_mp.swf" /> 
<param name="quality" value="high" />
<param name="bgcolor" value="#ffffff" />
<!--RAPPEL concernant le flashvars : il faut le placer dans <param> ET <embed> -->
<param name="flashvars" value="urlToOpen=http://www.modula-demat.com/rl/">
<param name="menu" value="false">
<embed menu="false" flashvars="urlToOpen=http://www.modula-demat.com/rl/" src="../templatesClients/teaser_mp.swf" quality="high" bgcolor="#ffffff" width="468" height="70" name="teaser_mp" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />
</object>
<br /><br />
<a href="http://www.modula-demat.com/rl" target="_blank" style="color:#c30;font-weight:bold"> &gt;&gt; Visualisez la présentation animée de nos services</a>
</div><br />
<table class="paveClassic" summary="Accueil">
  <tr>
  	<td>
		<p style="text-align:center;color:#2361AA;font-weight:bold">
			&gt;&gt; <em>Pour plus de renseignements : utilisez notre hotline d&rsquo;information aux collectivités.</em><br /><br />
			<div style="text-align:center;font-size:12px;font-weight:bold;color:#ED2327">0892 23 02 41 (0,34 &euro; / minute)</div>
		</p>
		<p align="center">
			<a href="#" onclick="OuvrirPopup('http://prod.modula-demat.com/install/plaquette-RL.pdf',800,650,'menubar=no,scrollbars=yes,statusbar=no')" style="color:#c30;font-weight:bold" target="_blank"> &gt;&gt;T&eacute;l&eacute;charger la documentation au format PDF)
				<img src="<%=rootPath %>publisher_traitement/public/pagesStatics/images/pdf.gif" style="vertical-align:bottom"/>
			</a>
		</p>
	</td>
</tr>
</table>
		<p align="center">
			<a href="<%=rootPath %>desk" style="color:#2361AA;font-weight:bold;font-size:14px;"> &gt;&gt;Se loguer vers MODULA Desk
			</a>
		</p>
