<%@ include file="/include/new_style/beanSessionUser.jspf" %>
<%@ page import="org.coin.bean.*" %>
<%@ page import="org.coin.fr.bean.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="modula.graphic.*" %>
<%@ page import="mt.paraph.folder.util.ParaphFolderWorkflowCircuit" %>
<%@page import="org.coin.util.*"%>
<%@page import="modula.*"%>
<%@page import="org.coin.servlet.*"%>
<%@page import="org.coin.localization.Language"%>
<%@page import="org.coin.localization.LocalizeButton"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.db.CoinDatabaseCreateException"%>
<%@page import="org.coin.db.CoinDatabaseLoadException"%>
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
	
	Vector<Multimedia> vMultimedias = new Vector<Multimedia> ();
	String sUrlRedirect = HttpUtil.parseString("sUrlRedirect", request, "afficherTousSignature.jsp?foo=1");
	Connection conn = (Connection) request.getAttribute("conn");
	
 	
	String sLocalizationNameAddSignatureFile = locAddressBookButton.getValue(39,"Ajouter une signature numérique");
	String sLocalizationNameSignatureFileList = locBloc.getValue(58,"Signature numérique");
	String sLocalizationNameSignatureFileType = multimediaCtx.getIdMultimediaTypeLabel();
	String sLocalizationNameSignatureFileName = multimediaCtx.getFileNameLabel();
	String sLocalizationNameSignatureFilenameType = multimediaCtx.getContentTypeLabel();
	String sLocalizationNameSignatureStoringType = multimediaCtx.getIsPhysiqueLabel();
	String sLocalizationNameSignatureFilenameModificationDate = multimediaCtx.getDateModificationLabel();
	String sLocalizationNameSignatureFileListTitle = locTitle.getValue(37,"Ajouter une signature numérique");
	String sLocalizationNameMessage = locMessage.getValue(58,"Etes-vous sûr de vouloir supprimer cette signature ?");
	String sLocalizationNameTel = locBloc.getValue(53,"Télécharger");
	String sLocalizationNameSup = locBloc.getValue(59,"Supprimer");
	String sLocalizationNameView = locBloc.getValue(60,"Affichage");
	String sLocalizationNameMod = locBloc.getValue(61,"Modifier");
	String sLocalizationNameSignatureEdit = locBloc.getValue(52,"Mise à jour de la signature d'un signataire");
	String sLocalizationNameSignature = locBloc.getValue(56,"Signature");
	
	try{
		iIdReferenceObjet = Integer.parseInt(request.getParameter("iIdReferenceObjet"));
		iIdTypeObjet = Integer.parseInt(request.getParameter("iIdTypeObjet"));
		
		vMultimedias = ParaphFolderWorkflowCircuit.getAllScannedSignatures(iIdReferenceObjet, iIdTypeObjet);
		
	}catch(Exception e)	{
	}
 %>
<div style="text-align:right">
	<button type="button" onclick="javascript:openModal('<%= response.encodeURL( 
		rootPath + "desk/multimedia/modifierSignatureForm.jsp?sAction=create"
		+ "&iIdTypeObjet=" + iIdTypeObjet
		+ "&iIdReferenceObjet=" + iIdReferenceObjet 
		+ "&sUrlRedirect=" + sUrlRedirect ) 
		%>','<%= sLocalizationNameSignatureFileListTitle %>');" ><%=
			sLocalizationNameAddSignatureFile %></button>
</div>
<br />
<script type="text/javascript">
<!--
function removeSignature (idMultimedia)
{
	if(!confirm("<%= sLocalizationNameMessage %>"))
	{	
		return false;
	}
	
	var sUrl = "<%= response.encodeURL( 
			rootPath + "desk/multimedia/modifierSignature.jsp?sAction=remove"	
			+ "&sUrlRedirect=" + sUrlRedirect		
		 	+ "&iIdMultimedia=") %>" + idMultimedia;

			Redirect(sUrl);	

}

//-->


</script>
<table class="pave" >
	<tr>
		<td class="pave_titre_gauche" colspan="2"><%= sLocalizationNameSignatureFileList %></td>
	</tr>
	<tr>
		<td colspan="2">
			<table class="liste" >
				<tr>
					<th style="width:2%">&nbsp;</th>
					<th style="width:25%"><%= sLocalizationNameSignatureFileType %></th>
					<th style="width:20%"><%= "Nom" %></th>
					<th style="width:7%"><%= "Ratio" %></th>
					<th style="width:15%;text-align:center"><%= sLocalizationNameSignatureFilenameModificationDate %></th>
					<th style="width:20%;text-align:right"></th>
					<th style="width:80px;text-align:right"></th>
					
				</tr>
	
<%	
	
	long lIdMainSignature 
		= PersonnePhysiqueParametre
			.getMainSignatureForPersonnePhysique(
					iIdReferenceObjet,
					conn);
	
	int iIdMultimediaPdfFile = -1;
	
	try {
		int iIdReferenceObjectPdfTest = iIdReferenceObjet;
		int iIdTypeObjectPdfTest = iIdTypeObjet;
		if(iIdTypeObjet == ObjectType.PERSONNE_PHYSIQUE)
		{
			PersonnePhysique pers = PersonnePhysique.getPersonnePhysique(iIdReferenceObjet);
			iIdReferenceObjectPdfTest = pers.getIdOrganisation();
			iIdTypeObjectPdfTest = ObjectType.ORGANISATION;
		}
		Multimedia pdfTest = Multimedia.getMultimediaFirstOccurence(
				MultimediaType.TYPE_TEST_FILE_PDF, 
				iIdReferenceObjectPdfTest, 
				iIdTypeObjectPdfTest, 
				conn);
		iIdMultimediaPdfFile = pdfTest.getIdMultimedia();
	} catch (Exception e) {}

	
	for (int i=0; i < vMultimedias.size();i++)
	{
		Multimedia multi = vMultimedias.get(i);
		int j = i % 2;
		String sTypeName 
			= MultimediaType.getMultimediaTypeName(multi.getIdMultimediaType());
		
		boolean bIsMainSignature = lIdMainSignature==multi.getId();
		
		String sSignatureName = multi.getLibelle();
		String sSignatureRatio = multi.getParameterValueOptional (MultimediaParameter.PARAM_RATIO, conn); 
		
		double dSignatureRatio = 0.1d;
		try{
			dSignatureRatio = Double.parseDouble(sSignatureRatio) / 100;
		} catch(NumberFormatException e){
		}  
		
%>
				<tr class="liste<%=j%>" 
					 onmouseover="className='liste_over'" 
					 onmouseout="className='liste<%=j%>'" 
					 > 
					<td  >
<%
		if(bIsMainSignature){
%>
					<img src="<%= rootPath + "images/icons/key_go.gif" %>" 
					alt="<%=locBloc.getValue(62,"Signature principale")%>"
                    title="<%=locBloc.getValue(62,"Signature principale")%>" />
<%	
		}
%>
					</td>
					<td><%= sTypeName %></td>
					<td><%= sSignatureName %></td>
					<td><%= sSignatureRatio %> % </td>
					<td>
						<%= CalendarUtil.getDateFormattee(multi.getDateModification() )%>
					</td>
<%	
		String sURLEdit = "";
		String sURLTest = "";
		if(multi.getIdMultimediaType()== MultimediaType.TYPE_SCANNED_PARAPH
		|| multi.getIdMultimediaType()== MultimediaType.TYPE_SCANNED_SIGNATURE
		|| multi.getIdMultimediaType()== MultimediaType.TYPE_SCANNED_VISA)
		{
			
			sURLEdit = "javascript:openModal('" 
	            + response.encodeURL(
	            		rootPath + "desk/multimedia/modifierSignatureForm.jsp"
	            		+ "?lId="+multi.getId()) 
	            		+ "&sUrlRedirect=" + sUrlRedirect
	            + "','"+sLocalizationNameSignature+"');";

			sURLTest = "javascript:openModal('" 
	            + response.encodeURL(
	            		rootPath + "PdfTransformationMultimediaServlet"
	            		+ "?iIdMultimediaSignature=" + multi.getId()
	            		+ "&iIdMultimediaPdfFile=" +  iIdMultimediaPdfFile
	            		+ "&dImageRatio=" + dSignatureRatio
	            		) 
	            + "','Test');";

		}
					
		String sURLTelecharger = "desk/DownloadFileDesk?"
			+ DownloadFile.getSecureTransactionStringFullJspPage(
					request, 
					multi.getIdMultimedia(),
					TypeObjetModula.MULTIMEDIA );
			
		sURLTelecharger = response.encodeURL(rootPath+ sURLTelecharger);
			
		String sTestTitle = "Tester la signature" ;
		String sTestImage= "pdf-document.png" ;
		if(iIdMultimediaPdfFile == -1){
			sURLTest = "";
			sTestImage = "pdf-document-empty.png";
			sTestTitle = "Pas de PDF de test défini";
		}
%>
					<td>
						<%= multi.getFileName() %>
					</td>					
					<td style="text-align: right">


						<img style="cursor:pointer" 
							onclick="<%= sURLTest %>" 
							src="<%= rootPath + "images/icons/" 
								+ sTestImage %>" 
							alt="<%= sTestTitle %>" 
							title="<%= sTestTitle %>"/>

					
						<img style="cursor:pointer" 
							onclick="<%= sURLEdit %>" 
							src="<%= rootPath + "images/icons/application_edit.gif" %>" 
							alt="<%= sLocalizationNameMod %>" 
							title="<%= sLocalizationNameMod %>"/>
							
						<img 
							onclick="doUrl('<%= sURLTelecharger %>');"
							style="cursor:pointer" 
							src="<%=rootPath + Icone.ICONE_DOWNLOAD_NEW_STYLE %>" 
							alt="<%= sLocalizationNameTel %>" 
							title="<%= sLocalizationNameTel %>" />
						
						<img src="<%=rootPath + Icone.ICONE_SUPPRIMER_NEW_STYLE %>" 
							alt="<%= sLocalizationNameSup %>" 
							style="cursor:pointer" 
							title="<%= sLocalizationNameSup %>" 
							onclick="javascript:removeSignature(<%= multi.getIdMultimedia()  %>);" />
					</td>
				</tr>	
<%
	}
%>
			</table>
		</td>
	</tr>
</table>