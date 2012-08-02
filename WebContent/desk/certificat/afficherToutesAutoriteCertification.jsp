<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@ page import="modula.graphic.*,org.coin.fr.bean.security.*,org.coin.security.token.*,java.security.cert.*,java.io.*,modula.candidature.*, java.util.*" %>
<%
	String sTitle = "Afficher export";
 %>

</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<div style="padding:15px">
<div id="menuBorder" class="sb" style="padding:3px 10px 3px 10px;margin:0 20px 0 20px;">
	<div class="fullWidth">
	<%
		Vector<BarBouton> vBarBoutons = new Vector<BarBouton>();
		if( sessionUserHabilitation.isHabilitate("IHM-DESK-xxx") )
		{
			vBarBoutons.add( 
				new BarBouton(0 , 
					"Ajouter une autorité de certification",
					response.encodeURL(rootPath + "desk/certificat/ajouterAutoriteCertificationForm.jsp" ), 
					rootPath+"images/icons/36x36/certificate_add.png", 
					"" , 
					"" , 
					"" ,
					true) );
		}

		if( sessionUserHabilitation.isHabilitate("IHM-DESK-xxx") )
		{
			vBarBoutons.add( 
				new BarBouton(1 , 
					"Tester un certificat",
					response.encodeURL(rootPath + "desk/certificat/testerCertificatForm.jsp" ), 
					rootPath+"images/icons/36x36/certificate_validate.png", 
					"" , 
					"" , 
					"" ,
					true) );
		}

		if( sessionUserHabilitation.isHabilitate("IHM-DESK-xxx") )
		{
			vBarBoutons.add( 
				new BarBouton(2 , 
					"Générer un hash MD5",
					response.encodeURL(rootPath + "desk/certificat/generateMD5Form.jsp" ), 
					rootPath+"images/icons/36x36/word_generate.png", 
					"" , 
					"" , 
					"" ,
					true) );
		}
		
		if( sessionUserHabilitation.isHabilitate("IHM-DESK-xxx") )
		{
			vBarBoutons.add( 
				new BarBouton(2 , 
					"Tester Chaine HTTPS",
					response.encodeURL(rootPath + "desk/certificat/checkSslCertificateForm.jsp" ), 
					rootPath+"images/icons/36x36/word_generate.png", 
					"" , 
					"" , 
					"" ,
					true) );
		}
%>
<%= BarBouton.getAllButtonHtmlDesk(vBarBoutons) %>
	</div>
</div>
<script>
var menuBorder = RUZEE.ShadedBorder.create({corner:4, border:1});
Event.observe(window, 'load', function(){
	menuBorder.render($('menuBorder'));
});
</script>
<br/>
<%
	Vector<AutoriteCertificationRacine> vCertificatRacine = AutoriteCertificationRacine.getAllStaticMemory();
	Vector<AutoriteCertificationIntermediaire> vCertificatIntermediaire = AutoriteCertificationIntermediaire.getAllStaticMemory();
%>
<%
	for(AutoriteCertificationRacine acr : vCertificatRacine)
	{	
		X509Certificate cert = acr.getCertificate();
		Calendar calNotBefore = Calendar.getInstance();
		calNotBefore.setTimeInMillis(cert.getNotBefore().getTime());
		Calendar calNotAfter = Calendar.getInstance();
		calNotAfter.setTimeInMillis(cert.getNotAfter().getTime());
		
%>
<table class="pave" summary="none">
	<tr>
		<td class="pave_titre_gauche" colspan="2" ">
			Certificat Racine <%= cert.getSubjectX500Principal().getName().split(",")[0] %></td>
		<td class="pave_titre_droite" >
			<a href="<%= 
				response.encodeURL(
					"supprimerAutoriteCertification.jsp?sType=acr&amp;iIdAutoriteCertification=" + acr.getId() ) %>" >Supprimer</a>
		</td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr>
		<td class="pave_cellule_gauche">Numéro de série : </td>
		<td class="pave_cellule_droite"><%= cert.getSerialNumber().toString() %>
		</td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Nom du fichier : </td>
		<td class="pave_cellule_droite"><%= acr.getFilename() %>
		</td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Délivré à : </td>
		<td class="pave_cellule_droite"><%= Outils.replaceAll( cert.getSubjectX500Principal().getName(), "," , ",<br/>\n") %>
		</td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Délivré par : </td>
		<td class="pave_cellule_droite"><%= Outils.replaceAll( cert.getIssuerX500Principal().getName(), "," , ",<br/>\n")  %>
		</td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Valide à partir du : </td>
		<td class="pave_cellule_droite"><%= org.coin.util.CalendarUtil.getDateFormattee( calNotBefore ) %>
		</td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Valide jusqu'au : </td>
		<td class="pave_cellule_droite"><%= org.coin.util.CalendarUtil.getDateFormattee( calNotAfter) %>
		</td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
</table>
<br />


<%	} %>


<%
	for(AutoriteCertificationIntermediaire acr : vCertificatIntermediaire)
	{	
		X509Certificate cert = acr.getCertificate();
		Calendar calNotBefore = Calendar.getInstance();
		calNotBefore.setTimeInMillis(cert.getNotBefore().getTime());
		Calendar calNotAfter = Calendar.getInstance();
		calNotAfter.setTimeInMillis(cert.getNotAfter().getTime());

		
%>
<table class="pave" summary="none">
	<tr>
		<td class="pave_titre_gauche" colspan="2" ">
			Certificat Intermediaire <%= cert.getSubjectX500Principal().getName().split(",")[0] %></td>
		<td class="pave_titre_droite" >
			<a href="<%= 
				response.encodeURL(
					"supprimerAutoriteCertification.jsp?sType=aci&amp;iIdAutoriteCertification=" + acr.getId() ) %>" >Supprimer</a>
		</td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr>
		<td class="pave_cellule_gauche">Numéro de série : </td>
		<td class="pave_cellule_droite"><%= cert.getSerialNumber().toString() %>
		</td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Nom du fichier : </td>
		<td class="pave_cellule_droite"><%= acr.getFilename() %>
		</td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Délivré à : </td>
		<td class="pave_cellule_droite"><%= Outils.replaceAll( cert.getSubjectX500Principal().getName(), "," , ",<br/>\n") %>
		</td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Délivré par : </td>
		<td class="pave_cellule_droite"><%= Outils.replaceAll( cert.getIssuerX500Principal().getName(), "," , ",<br/>\n") %>
		</td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Valide à partir du : </td>
		<td class="pave_cellule_droite"><%= org.coin.util.CalendarUtil.getDateFormattee( calNotBefore ) %>
		</td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Valide jusqu'au : </td>
		<td class="pave_cellule_droite"><%= org.coin.util.CalendarUtil.getDateFormattee( calNotAfter) %>
		</td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
</table>
<br />
<%	} %>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
<%@page import="org.coin.util.Outils"%>
</html>
