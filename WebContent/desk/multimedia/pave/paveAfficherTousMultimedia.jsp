
<%@ include file="/include/new_style/beanSessionUser.jspf" %>
<%@ page import="org.coin.bean.*,java.text.*,org.coin.fr.bean.*,java.io.*,modula.candidature.*,java.util.*,modula.graphic.*" %>
<%@ include file="/desk/organisation/pave/localizationObject.jspf" %>
<%

	LocalizeButton localizeButton = null;
	try {
		localizeButton = new LocalizeButton(request);
	}catch (Exception e) {
		e.printStackTrace();
	}

	int iIdReferenceObjet = -1;
	int iIdTypeObjet = -1;
	String rootPath = request.getContextPath()+"/";
	
	Multimedia multimediaCtx = new Multimedia();
	multimediaCtx.setAbstractBeanLocalization(sessionLanguage.getId());
	
	Vector<Multimedia> vMultimedias ;
	String sUrlRedirect = HttpUtil.parseString("sUrlRedirect", request, "afficherTousMultimedia.jsp?foo=1");

	String sLocalizationNameAddMultimediaFile = locAddressBookButton.getValue(11,"Ajouter un fichier multimédia");
	String sLocalizationNameMultimediaFileList = locBloc.getValue(9,"Fichiers Multimédias");
	String sLocalizationNameMultimediaFileType = multimediaCtx.getIdMultimediaTypeLabel();
	String sLocalizationNameMultimediaFileName = multimediaCtx.getFileNameLabel();
	String sLocalizationNameMultimediaName = multimediaCtx.getNameLabel();
	String sLocalizationNameMultimediaFilenameType = multimediaCtx.getContentTypeLabel();
	String sLocalizationNameMultimediaStoringType = multimediaCtx.getIsPhysiqueLabel();
	String sLocalizationNameMultimediaFilenameModificationDate = multimediaCtx.getDateModificationLabel();
	String sLocalizationNameMultimediaFileListTitle = locTitle.getValue(36,"Ajouter un fichier multimédia");
	String sLocalizationNameMessage = locMessage.getValue(53,"Etes vous sûr de vouloir supprimer cet objet multimédia ?");
	
	try{
		iIdReferenceObjet = Integer.parseInt(request.getParameter("iIdReferenceObjet"));
		iIdTypeObjet = Integer.parseInt(request.getParameter("iIdTypeObjet"));
		
		vMultimedias = Multimedia.getAllMultimedia(iIdReferenceObjet , iIdTypeObjet);
	}catch(Exception e)	{
		// tous !
		vMultimedias = Multimedia.getAllMultimedias();
	}


 %>
<%@page import="org.coin.util.*"%>
<%@page import="modula.*"%>
<%@page import="org.coin.servlet.*"%>
<%@page import="org.coin.localization.Language"%>
<%@page import="org.coin.localization.LocalizeButton"%>
<script type="text/javascript">
function createMultimedia()
{
	var sUrl = '<%= response.encodeURL( 
			rootPath + "desk/multimedia/modifierMultimediaForm.jsp?sAction=create"
			+ "&iIdTypeObjet=" + iIdTypeObjet
			+ "&iIdReferenceObjet=" + iIdReferenceObjet 
			+ "&sUrlRedirect=" + sUrlRedirect ) 
			%>';

	parent.mt.utils.displayModal({
		type:"iframe",
		url:sUrl+"&bIsPopup=true",
		title:"<%= sLocalizationNameMultimediaFileListTitle %>",
		width:600,
		height:400
	});

}

function modifyMultimedia(lId)
{
	var sUrl = '<%= response.encodeURL( 
		rootPath + "desk/multimedia/modifierMultimediaForm.jsp?sAction=store"
		+ "&iIdTypeObjet=" + iIdTypeObjet
		+ "&iIdReferenceObjet=" + iIdReferenceObjet 
		+ "&sUrlRedirect=" + sUrlRedirect ) 
		%>' + "&lId=" + lId;
		 
	parent.mt.utils.displayModal({
		type:"iframe",
		url:sUrl+"&bIsPopup=true",
		title:"<%= "Modifier" %>",
		width:600,
		height:400
	});
}


</script>

<div style="text-align:right">
	<button type="button" 
		onclick="createMultimedia();" ><%= sLocalizationNameAddMultimediaFile %></button>
</div>
<br />
<script type="text/javascript">
<!--

function removeMultimedia(idMultimedia)
{
	if(!confirm("<%= sLocalizationNameMessage %>"))
	{	
		return false;
	}
	
	var sUrl = "<%= response.encodeURL( 
		rootPath + "desk/multimedia/modifierMultimedia.jsp?sAction=remove"
		+ "&sUrlRedirect=" + sUrlRedirect
	 	+ "&iIdMultimedia=") %>" + idMultimedia;
			
	Redirect(sUrl);
}

//-->
</script>
<table class="pave" >
	<tr>
		<td class="pave_titre_gauche" colspan="2"><%= sLocalizationNameMultimediaFileList %></td>
	</tr>
	<tr>
		<td colspan="2">
			<table class="liste" >
				<tr>
					<th style="width:20%"><%= sLocalizationNameMultimediaFileType %></th>
					<th style="width:20%"><%= sLocalizationNameMultimediaFileName %></th>
					<th style="width:20%"><%= sLocalizationNameMultimediaName %></th>
					<th style="width:10%"><%= sLocalizationNameMultimediaFilenameType %></th>
					<th style="width:2%"><%= sLocalizationNameMultimediaStoringType %></th>
					<th style="width:10%;text-align:center"><%= sLocalizationNameMultimediaFilenameModificationDate %></th>
					<th style="width:10%;text-align:right">&nbsp;</th>
<!-- 
					<th style="width:5%;text-align:right"><%= localizeButton.getValueModify() %></th>
					<th style="width:5%;text-align:right"><%= localizeButton.getValueSee() %></th>
					<th style="width:5%;text-align:right"><%= localizeButton.getValueDownload() %></th>
					<th style="width:5%;text-align:right"><%= localizeButton.getValueDelete() %></th>
 -->
 				</tr>
	
	<%
	for (int i=0; i < vMultimedias.size();i++)
	{
		Multimedia multi = vMultimedias.get(i);
		int j = i % 2;
		String sTypeName 
			= MultimediaType.getMultimediaTypeName(multi.getIdMultimediaType());
		
		%>
				<tr class="liste<%=j%>" 
					 onmouseover="className='liste_over'" 
					 onmouseout="className='liste<%=j%>'" 
					 > 
					<td ><%= sTypeName %></td>
					<td ><%= multi.getFileName() %></td>
					<td ><%= multi.getLibelle() %></td>
					<td ><%= multi.getContentType() %> </td>
					<td ><%= multi.isPhysique()?"BDD + Serveur":"BDD" %> </td>
					<td >
						<%= CalendarUtil.getDateWithFormat(multi.getDateModification() , "hh:mm '-' dd/MM/yyy" )%>
					</td>
					<%
					   String sURLEdit = "javascript:openModal('" 
					            + response.encodeURL(rootPath + "desk/multimedia/editMultimediaForm.jsp?lId="+multi.getId()) 
					            + "','Edit multimedia file','700px','600px');";
					%>
					<td style="text-align: right">
						<img src="<%= rootPath + "images/icons/application_form.png" %>" 
								style="cursor:pointer" 
								onclick="modifyMultimedia(<%= multi.getId() %>);" 
								alt="<%= localizeButton.getValueModify() %>" 
								title="<%= localizeButton.getValueModify() %>" />

						<img style="cursor:pointer" 
							onclick="<%= sURLEdit %>" 
							src="<%=rootPath + "images/icons/application_edit.gif" %>" 
							alt="<%= localizeButton.getValueEdit() %>" 
							title="<%= localizeButton.getValueEdit() %>" 
							/>
				<%
						String sURLTelecharger = "desk/DownloadFileDesk?"
								+ "&" + DownloadFile.getSecureTransactionStringFullJspPage(
										request, 
										multi.getIdMultimedia(),
										TypeObjetModula.MULTIMEDIA )
								+ "&sContentType="+ multi.getContentType()
								+ "&sAction=view";

						sURLTelecharger = response.encodeURL(rootPath+ sURLTelecharger);
					%>
						<a href="<%= sURLTelecharger %>" target="_blank" >
							<img src="<%=rootPath + "images/icons/application_put.png" %>"  
								alt="<%= localizeButton.getValueSee() %>" 
								title="<%= localizeButton.getValueSee() %>" 
							/>
						</a>
					<%
						sURLTelecharger = "desk/DownloadFileDesk?"
								+ DownloadFile.getSecureTransactionStringFullJspPage(
										request, 
										multi.getIdMultimedia(),
										TypeObjetModula.MULTIMEDIA );
								
						sURLTelecharger = response.encodeURL(rootPath+ sURLTelecharger);
					%>
						<img src="<%= rootPath + "images/icons/down.png" %>" 
								style="cursor:pointer" 
								onclick="doUrl('<%= sURLTelecharger  %>');"
								alt="<%= localizeButton.getValueDownload() %>" 
								title="<%= localizeButton.getValueDownload() %>" />

						<img src="<%=rootPath + Icone.ICONE_SUPPRIMER_NEW_STYLE %>" 
								style="cursor:pointer" 
								alt="<%= localizeButton.getValueDelete() %>" 
								title="<%= localizeButton.getValueDelete() %>" 
								onclick="javascript:removeMultimedia(<%= multi.getIdMultimedia()  %>);"/>
					</td>
				</tr>	
		<%
	}
%>
			</table>
		</td>
	</tr>
</table>