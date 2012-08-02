<%@ include file="/include/new_style/headerDesk.jspf" %>

<%
	String sTitle = "Edit Multimedia File";
	long lIdMultimedia = HttpUtil.parseLong("lId",request,0);
	Multimedia multi = null;
	try{
	    multi = Multimedia.getMultimedia((int)lIdMultimedia);
	}catch(Exception e){
	    multi = new Multimedia();
	}
	String sContent = HttpUtil.parseStringBlank("content",request);

	/**
	 * defined for Affiches de Grenoble
	 */
	String sEncodingOut = "UTF-8";
	sEncodingOut = "ISO-8859-1";
	
	sContent = HTMLEntities.unhtmlentitiesComplete(sContent);
	multi.setMultimediaFile(new ByteArrayInputStream(sContent.getBytes(sEncodingOut)));
	multi.storeMultimediaFile();
	
	String sConfigFlagUpdate = "";
	switch(multi.getIdMultimediaType()){
	case MultimediaType.TYPE_SITE_PUBLISHER_PAGE:
		sConfigFlagUpdate = "system_message::update_multimedia_site_publisher_page_";
		int iPosExt = multi.getFileName().lastIndexOf(".");
		String sPageCat = multi.getFileName().substring("page_".length(),iPosExt);
		sConfigFlagUpdate += sPageCat;
		break;
	case MultimediaType.TYPE_SITE_MAIN_PAGE:
		sConfigFlagUpdate = "system_message::update_multimedia_site_main_page";
        break;
	}
	if(!Outils.isNullOrBlank(sConfigFlagUpdate)){
		try{
			Configuration.getConfigurationMemory(sConfigFlagUpdate);
		}catch(Exception e){   
			Configuration conf = new Configuration();
			conf.setId(sConfigFlagUpdate);
			conf.setName("update");
			conf.create();
		}
	}
		
	if(multi.isPhysique()){
		   String sCommonDocumentRoot = Configuration.getConfigurationValueMemory("multimedia.documentRoot");
		   String sSelfDocumentRoot = sCommonDocumentRoot+"/"+OrganisationParametre.getOrganisationParametreValue(multi.getIdReferenceObjet(),"organisation.multimedia.documentRoot");
	
		   File fichier = new File(sSelfDocumentRoot);
		   fichier.mkdirs();

		   FileUtil.convertInputStreamInFile(
			Multimedia.getInputStreamMultimediaFile(multi.getIdMultimedia()), 
			new File(sSelfDocumentRoot+"/"+multi.getFileName() ));
	}
%>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<div style="padding:15px">
<table class="pave">
	<tr>
		<td class="pave_titre_gauche" colspan="2"><%=multi.getFileName() %></td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">
		<img src="<%=rootPath+Icone.ICONE_SUCCES %>" alt="" />
		</td>
		<td class="pave_cellule_droite" style="vertical-align:middle">
			Fichier mis à jour avec succès!
		</td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="2" class="center">
		  <button type="button" onclick="closeModal()">Fermer la fenêtre</button>
		</td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
</table>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
<%@page import="org.coin.util.FileUtil"%>
<%@page import="org.coin.util.HTMLEntities"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.fr.bean.Multimedia"%>
<%@page import="java.io.ByteArrayInputStream"%>
<%@page import="org.coin.fr.bean.OrganisationParametre"%>
<%@page import="java.io.File"%>
<%@page import="org.coin.fr.bean.MultimediaType"%>
<%@page import="org.coin.util.Outils"%>
</html>