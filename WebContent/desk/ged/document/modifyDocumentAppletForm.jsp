<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.html.*" %>
<%@page import="org.coin.bean.ged.GedDomain"%>
<%@page import="org.coin.bean.ged.GedFolderType"%>
<%@page import="org.coin.bean.ged.GedFolder"%>
<%@page import="org.coin.bean.ged.GedDocument"%>
<%@page import="org.coin.bean.ged.GedDocumentType"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="org.coin.db.InputStreamDownloader"%>
<% 
	String sTitle = "Upload all documents : "; 
	Connection conn = ConnectionManager.getConnection();


	GedDocumentType type = null;
	GedFolder folder = null;
	GedFolderType folderType = null;
	String sPageUseCaseId = "xxx";
	
	type = new GedDocumentType();
	folder = GedFolder.getGedFolder(Integer.parseInt(request.getParameter("lIdGedFolder")));
	sTitle += "<span class=\"altColor\">New document</span>"; 
	folderType = GedFolderType.getGedFolderType(folder.getIdGedFolderType());


	HtmlBeanTableTrPave pave = new HtmlBeanTableTrPave();
	pave.bIsForm = true;
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);

	URL oTargetURL = HttpUtil.getUrlWithProtocolAndPort(
			rootPath + "test/modifyDocumentCreate.jsp",
			request);
	
%>
</head>
<body>

<%@ include file="/include/new_style/headerFiche.jspf" %>

<div id="fiche">
		<input type="hidden" name="lIdGedFolder" value="<%= folder.getId() %>" />
		
		<table class="formLayout" cellspacing="3">
			<tr>
				<td class="pave_cellule_gauche">Folder :</td>
				<td class="pave_cellule_droite">
				<%= folder.getReference() + " / " + folder.getName() %>
				</td>
			</tr>

			<tr>
				<td class="pave_cellule_gauche">Document type :</td>
				<td class="pave_cellule_droite">
				<%= type.getAllInHtmlSelect("lIdGedDocumentType",1, "", false, false, " WHERE id_ged_folder_type=" + folderType.getId(), "") %>
				</td>
			</tr>
			<tr>
				<td class="pave_cellule_gauche">Fichier :</td>
				<td class="pave_cellule_droite">

	<table>
		<tr>
			<td style="border: 1px solid black;background-color:#eee">
				<applet
				code="org.coin.applet.DropUploaderHttpClientApplet.class"
				archive="<%= rootPath + "include/jar/SDropUploaderHttpClientApplet.jar?V20" %>"
				width ="500"
				height="100"
				>
				<param name="sTargetURL" value="<%= oTargetURL.toString() %>" />
				<param name="lIdGedFolder" value="<%= folder.getId() %>" />
				<param name="lIdGedDocumentType" value="<%= type.getId() %>" />
				<param name="sSessionId" value="<%= session.getId() %>" />
							
				</applet>
			</td>
		</tr>
	</table>
				</td>
			</tr>

		</table>



</div>
<div id="fiche_footer">

	<button type="button" onclick="javascript:doUrl('<%=
			response.encodeURL("../folder/displayFolder.jsp?lId=" + folder.getId()) %>');" >
			Return</button>

</div>

<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>

<%@page import="java.net.URL"%>
<%@page import="org.coin.util.HttpUtil"%></html>
<%

	ConnectionManager.closeConnection(conn);

%>