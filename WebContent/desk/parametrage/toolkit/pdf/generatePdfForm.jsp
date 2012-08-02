<%@ include file="../../../../include/new_style/headerDesk.jspf" %>
<% 
	String sTitle = "G�n�ration PDF";
%>
</head>
<link rel="stylesheet" type="text/css" href="<%= rootPath %>include/component/calendar/calendar.css" media="screen" />
<script type="text/javascript" src="<%= rootPath %>include/component/calendar/calendar.js"></script>
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<div id="fiche">


<br/>
<br/>
<br/>
<br/>

<form action="<%= response.encodeURL(
			rootPath + "desk/GeneratePdfToolkitServlet") %>" method="post" 
	enctype="multipart/form-data" 
	name="formulaire">


	<table class="pave" >
		<tr>
			<td class="pave_titre_gauche" colspan="2">
				Generation PDF
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">
				Fichier PDF :
			</td>
			<td class="pave_cellule_droite">
				<input type="file" name="pdfFile" size="60" >
			</td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">
				Mot de passe :
			</td>
			<td class="pave_cellule_droite">
				<input type="text" name="sPassword" />
			</td>
		</tr>


<input type="checkbox" name="bAddMentionBrouillon" /> mention brouillon (� faire)<br/>
<input type="checkbox" name="bAddDocumentHeaderAndFooter" /> ent�te et pied de page (� faire)<br/>
<input type="checkbox" name="bAddDocumentHeader" /> ent�te (� faire)<br/>
<input type="checkbox" name="bAddDocumentFooter" /> pied de page (� faire)<br/>
<input type="checkbox" name="bSetScanSign" /> signature num�rique<br/>
<input type="checkbox" name="bSetDate" /> date <input type="text" class="dataType-date dataType-notNull" name="tsDate" /><br/>
<input type="checkbox" name="bAddCodeNumber" /> ajouter num�ro d'indexation <input type="text" /> (� faire)<br/>
<input type="checkbox" name="bAddBarCodePdf39" /> Code � barre 39 (� faire)<br/>
<input type="checkbox" name="bAddBarCodePdf417" /> Code � barre PDF 417 (� faire)<br/>
<input type="checkbox" name="bAddServerSign" /> Signature int�gr�e au PDF avec certificat X509v2 (� faire)<br/>


<button type="submit">Envoyer</button>


</table>

</form>



</div>
</form>
</div>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>
</html>
