<%@ include file="../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.security.*" %>
<%@page import="mt.modula.Version"%>
<%
	String sTitle = "Utilitaires";
	
	String sMention = "With this tool you can test whether ClamAV already detects a specimen. If not, please follow the instructions to submit it.<br /><br />";
	sMention += "This tool is intended to encourage people who have no copy of ClamAV handy (for testing purpose) to submit their samples to ClamAV.<br />";
	sMention += "Please upload your specimen. You can upload binaries, zip-files, complete e-mails or any other stuff you think contains malicious content (Please notice: there is an upload-limit of 500 kbytes to prevent abuse).<br /><br />";
	
	String sClamAVVersion = "";
	try{sClamAVVersion = ClamAV.getVersion();}
	catch(Exception e){}
	
	String sUrlModulaClientInstaller = Version.URL_INSTALLATION_SOFTWARE;
%>
</head>
<body>
<%@ include file="../../include/new_style/headerFiche.jspf" %>
<br />
<table class="pave" style="background-color : #FFFFFF;" cellspacing="4" cellpadding="3" >
	<tr><td colspan="2" class="pave_titre_gauche" >Utilitaires</td></tr>
	<tr>
		<td style="width:110px;text-align:center;vertical-align:middle"><img src="<%= 
			rootPath%>images/icons/36x36/config.png" /></td>
		<td style="text-align:justify">
			        <button type="button" id="verify" onclick="parent.addParentTabForced('Chargement...','<%= 
            response.encodeURL(rootPath+"desk/utilitaires/checkConformityClientComputer.jsp") 
            %>')"><img src="<%= rootPath %>images/icons/computer.gif" 
            alt="Tester" style="vertical-align:middle;margin-right: 5px;" 
            />Tester votre poste pour le décachetage des plis</button>
		</td>
	</tr>
	<tr>
		<td style="width:110px;text-align:center;vertical-align:middle"><img src="<%= 
			rootPath%>images/icons/36x36/config.png" /></td>
		<td style="text-align:justify">
			  <button type="button" id="verify" onclick="parent.addParentTabForced('Chargement...','<%= 
        	response.encodeURL(rootPath + "desk/include/displaySessionParam.jsp")
            %>')"><img src="<%= rootPath %>images/icons/eye.gif" 
            alt="Tester" style="vertical-align:middle;margin-right: 5px;" /><%= localizeButton.getValue(32,"Afficher les paramètres de la session") %></button>       
		</td>
	</tr>
	<tr>
		<td style="width:110px;text-align:center;vertical-align:middle"><img src="<%= 
			rootPath%>images/icons/36x36/config.png" /></td>
		<td style="text-align:justify">
			      <button type="button" id="verify" onclick="parent.addParentTabForced('Chargement...','<%= 
            response.encodeURL(rootPath+"desk/utilitaires/benchmark/bandwith/bandwith.jsp") 
            %>')"><img src="<%= rootPath %>images/treeview/icons/server_chart.gif" 
            alt="Tester" style="vertical-align:middle;margin-right: 5px;" 
            /><%= localizeButton.getValue(56,"Tester la bande passante de votre poste") %></button>  
		</td>
	</tr>
	<tr>
		<td style="width:110px;text-align:center;vertical-align:middle"><img src="<%= 
			rootPath%>publisher_traitement/public/pagesStatics/images/clam.jpg" /></td>
		<td style="text-align:justify"><strong>Test Antivirus ClamAV :</strong><br />
		Une page va s'ouvrir et vous permettera de tester un fichier avec notre antivirus.<br />
		<a href="<%= response.encodeURL("scanForm.jsp") %>">>> Cliquez ici pour tester un fichier</a>
		</td>
	</tr>
	<tr>
		<td style="width:110px;text-align:center;vertical-align:middle"><img src="<%=
			rootPath%>publisher_traitement/public/pagesStatics/images/signature_electronique_tiny.gif"  /></td>
		<td style="text-align:justify"><strong>Machine virtuelle Java &amp; librairies associées :</strong><br />
		Ce logiciel doit être installé impérativement si vous souhaiter envoyer vos candidatures et offres électroniquement en utilisant la plate-forme.<br />
		<a href="<%= sUrlModulaClientInstaller %>" target="_blank">>> Cliquez ici pour le télécharger</a>
		</td>
	</tr>
	<tr>
		<td style="width:110px;text-align:center;vertical-align:middle"><img src="<%= 
			rootPath%>publisher_traitement/public/pagesStatics/images/ikey.jpg" width="54" /></td>
		<td style="text-align:justify"><strong>Drivers &amp; Utilitaires pour le Token USB IkeyTM</strong><br />
		Logiciel de prise en charge des certificats électronique Certeurope et des supports cryptographiques Token USB IkeyTM.<br />
		<a href="http://www.certeurope.fr/?subject=187&language=1" target="_blank">>> Cliquez ici pour les télécharger</a>
		</td>
	</tr>
	<tr>
		<td style="width:110px;text-align:center;"><img src="<%= 
			rootPath%>publisher_traitement/public/pagesStatics/images/get_flash_player.gif" /></td>
		<td style="text-align:justify">
			<strong>Macromedia Flash Player : </strong><br />
			Macromedia Flash Player est un client multiplates-formes. Les internautes doivent télécharger et installer le lecteur pour consulter les contenus Macromedia Flash.<br />
			<a href="http://www.macromedia.com/go/getflashplayer" target="_blank">>> Cliquez ici pour le télécharger sur le site de l'éditeur</a>
		</td>
	</tr>
	<tr>
		<td style="width:110px;text-align:center;"><img src="<%= 
			rootPath%>publisher_traitement/public/pagesStatics/images/reader.jpg" /></td>
		<td style="text-align:justify">
			<strong>Adobe Acrobat Reader : </strong><br />
			Indispensable pour lire tous les fichiers générés par la plate-forme au format PDF.<br />
			<a href="http://www.adobe.fr/products/acrobat/readstep2.html" target="_blank">>> Cliquez ici pour le télécharger sur le site de l'éditeur</a>
		</td>
	</tr>
	<tr>
		<td style="width:110px;text-align:center;"><img src="<%= 
			rootPath%>publisher_traitement/public/pagesStatics/images/winrar.jpg" /></td>
		<td style="text-align:justify"><strong>WINRAR :</strong><br />
										Puissant logiciel de décompression de fichiers .ZIP, .RAR, etc…<br />
										Vous permettra de décompresser tous types de fichiers.<br />
			<a href="http://www.01net.com/telecharger/windows/Utilitaire/compression_et_decompression/fiches/2257.html" target="_blank">>> Cliquez ici pour le télécharger sur le site de l'éditeur</a>
		</td>
	</tr>
	<tr>
		<td style="width:110px;text-align:center;"><img src="<%=
			rootPath%>publisher_traitement/public/pagesStatics/images/cutepdf.jpg" /></td>
		<td style="text-align:justify"><strong>CutePDF Writer :</strong><br />
		Cute PDF Printer est un logiciel de création de fichiers au format .PDF qui s'installe sur votre ordinateur en tant qu'imprimante virtuelle.<br />
		<a href="http://www.01net.com/telecharger/windows/Bureautique/editeur_de_texte/fiches/27030.html" target="_blank">>> Cliquez ici pour le télécharger sur www.telecharger.com</a>
		</td>
	</tr>
	<tr>
		<td style="width:110px;text-align:center;"><img src="<%= 
			rootPath%>publisher_traitement/public/pagesStatics/images/autodesk.jpg" /></td>
		<td style="text-align:justify"><strong>Autodesk DWF Viewer :</strong><br />
		Gratuit, ce logiciel permet de visualiser des fichiers graphiques générés depuis Autocad.<br />
		<a href="http://www.autodesk.com/dwfviewer-download" target="_blank">>> Cliquez ici pour le télécharger sur le site de l'éditeur</a>
		</td>
	</tr>
	<tr>
		<td style="width:110px;text-align:center;"><b><font size="4"><font color="#8a3591">Free</font> </font>
                <font color="#fdb927" face="Arial" size="4">DWG </font>
                <font color="#8a3591" size="4">Viewer</font></b></td>
		<td style="text-align:justify"><strong>Free DWG Viewer :</strong><br />
			Visionnez des dessins AutoCAD grâce à cette visionneuse DWG/DXF gratuite. DWG Viewer est une petite application
			faite d'un composant ActiveX. Ceci vous permet de la faire fonctionner comme une application Windows et dans
			votre navigateur. Vous pouvez modifier et compiler la commande pour l'inclure dans votre propre application.
			Ce logiciel comprend une interface très simple à utiliser, la possibilité d'agrandir, de tourner, d'inverser
			la barre d'outils, une interface ActiveX, possibilité de détecter et de charger Xrefs.
			Ce programme gratuit vous permet uniquement de visionner (fonction d'impression neutralisée). Ce programme ne peut que
	 		visionner les formats de fichier DWG/DXF.<br />
		<a href="http://www.01net.com/telecharger/windows/Multimedia/cao_et_dao/fiches/17729.html" target="_blank">>> Cliquez ici pour le télécharger sur 01 net</a>
		<a href="http://www.infograph.com/products/dwgviewer/" target="_blank">>> Cliquez ici pour le télécharger sur le site de l'éditeur</a>
		</td>
	</tr>
	<tr>
		<td style="width:110px;text-align:center;"><img src="<%= 
			rootPath%>publisher_traitement/public/pagesStatics/images/openoffice.jpg" /></td>
		<td style="text-align:justify"><strong>Suite Bureautique OpenSource :</strong><br />
			Une suite de logiciels bureautiques développée en OpenSource.<br />
			<a href="http://fr.openoffice.org" target="_blank">>> Cliquez ici pour la télécharger sur le site de l'éditeur </a>
		</td>
	</tr>
	<tr>
		<td style="width:110px;text-align:center;"><img src="<%=
			rootPath%>publisher_traitement/public/pagesStatics/images/office.gif" /></td>
		<td style="text-align:justify"><strong>Visionneuse Word :</strong><br />
		Vous pouvez afficher, imprimer et copier des documents Word, même si Word n'est pas installé sur votre
		 ordinateur. Ce téléchargement remplace Word Viewer 97 et toutes les versions antérieures de Word Viewer.<br />
		<a href="http://www.microsoft.com/downloads/details.aspx?FamilyID=95e24c87-8732-48d5-8689-ab826e7b8fdf&DisplayLang=fr" target="_blank">>> Cliquez ici pour le télécharger sur le site de l'éditeur</a>
		</td>
	</tr>
	<tr>
		<td style="width:110px;text-align:center;"><img src="<%= 
			rootPath%>publisher_traitement/public/pagesStatics/images/office.gif" /></td>
		<td style="text-align:justify"><strong>Visionneuse Excel :</strong><br />
		Vous pouvez ouvrir, afficher et imprimer des classeurs Excel, même si Excel n'est pas installé sur votre 
		ordinateur. Ce téléchargement remplace Excel Viewer 97 et toutes les versions antérieures de Excel Viewer.<br />
		<a href="http://www.microsoft.com/downloads/details.aspx?FamilyID=c8378bf4-996c-4569-b547-75edbd03aaf0&DisplayLang=fr" target="_blank">>> Cliquez ici pour le télécharger sur le site de l'éditeur</a>
		</td>
	</tr>
	<tr>
		<td style="width:110px;text-align:center;"><img src="<%= 
			rootPath%>publisher_traitement/public/pagesStatics/images/office.gif" /></td>
		<td style="text-align:justify"><strong>Visionneuse PowerPoint :</strong><br />
		La Visionneuse PowerPoint 2003 vous permet d'afficher des présentations dotées de toutes les fonctionnalités
		 créées dans PowerPoint 97 et les versions ultérieures.<br />
		<a href="http://www.microsoft.com/downloads/details.aspx?FamilyID=428d5727-43ab-4f24-90b7-a94784af71a4&DisplayLang=fr" target="_blank">>> Cliquez ici pour le télécharger sur le site de l'éditeur</a>
		</td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
</table>
<%@ include file="../../include/new_style/footerFiche.jspf" %>
</body>
<%@page import="org.coin.bean.conf.Configuration"%>
</html>
