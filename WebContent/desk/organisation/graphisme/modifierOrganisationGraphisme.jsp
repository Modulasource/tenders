<%@ include file="../../../include/headerXML.jspf" %>

<%@ page import="org.coin.fr.bean.*,org.coin.bean.*,modula.*,java.io.*,modula.graphic.*,org.coin.bean.conf.*" %>
<%@ include file="../../include/beanSessionUser.jspf" %>
<%
	String sTitle = "Edition de la feuille de style";
	String rootPath = request.getContextPath()+"/";
	int iIdOrganisationGraphisme = -1;
	OrganisationGraphisme graphisme = null;
	try{ 
		iIdOrganisationGraphisme = Integer.parseInt(request.getParameter("idOrganisationGraphisme"));
		graphisme = OrganisationGraphisme.getOrganisationGraphisme(iIdOrganisationGraphisme);
	}catch(Exception e){
		
	}
	String sCssContent = request.getParameter("cssContent");
	sCssContent = HTMLEntities.unhtmlentitiesComplete(sCssContent);
	
	Multimedia css = Multimedia.getMultimedia(graphisme.getIdCSS());
	css.setMultimediaFile(new ByteArrayInputStream(sCssContent.getBytes()));
	css.storeMultimediaFile();
		
	String sCommonDocumentRoot = Configuration.getConfigurationValueMemory("multimedia.documentRoot");
	String sSelfDocumentRoot = sCommonDocumentRoot+"/"+OrganisationParametre.getOrganisationParametreValue(css.getIdReferenceObjet(),"organisation.multimedia.documentRoot");
	
	File fichier = new File(sSelfDocumentRoot);
	fichier.mkdirs();

	FileUtil.convertInputStreamInFile(
			Multimedia.getInputStreamMultimediaFile(css.getIdMultimedia()), 
			new File(sSelfDocumentRoot+"/"+css.getFileName() ));
	
%><%@ include file="../../include/headerDesk.jspf" %>
</head>
<body>
<div class="titre_page"><%= sTitle %></div>
<form name="formulaire" action="<%=response.encodeURL("modifierOrganisationGraphisme.jsp") %>">
<table class="pave">
	<tr>
		<td class="pave_titre_gauche" colspan="2"><%=css.getFileName() %></td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">
		<img src="<%=rootPath+Icone.ICONE_SUCCES %>" alt="" />
		</td>
		<td class="pave_cellule_droite" style="vertical-align:middle">
			La feuille de style a été mise à jour avec succès !
		</td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="2"><input type="button" value="Fermer la fenêtre" onclick="window.close()" /></td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
</table>
</form>
<%@ include file="../../include/footerDesk.jspf" %>
</body>
<%@page import="org.coin.util.FileUtil"%>
<%@page import="org.coin.util.HTMLEntities"%>
</html>