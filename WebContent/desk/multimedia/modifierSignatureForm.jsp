<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@ page import = "org.coin.fr.bean.PersonnePhysiqueParametre" %>
<%@ page import="org.coin.bean.html.*,org.coin.fr.bean.*,java.io.*,modula.candidature.*,java.util.*,modula.graphic.*" %>
<%@page import="org.coin.servlet.*"%>
<%@page import="modula.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="mt.paraph.folder.util.ParaphFolderWorkflowCircuit"%>
<%@ include file="../organisation/pave/localizationObject.jspf" %>
<%

	String sLocalizationNameFichier = locBloc.getValue(22,"Fichier");
	String sLocalizationNameTest = locBloc.getValue(54,"Test");
	String sLocalizationNamesTitle = locBloc.getValue(52,"Mise à jour de la signature d'un signataire");
	String sLocalizationNamesTypeSignature = locBloc.getValue(55,"Type de signature");
	String sLocalizationNamesExist = locBloc.getValue(57,"Fichier existant");
	String sTitle = sLocalizationNamesTitle;
    Connection conn = ConnectionManager.getConnection();
    String sNamePrimarySign = PersonnePhysiqueParametre.PARAM_MAIN_SIGNATURE;

	int iIdMultimedia = 1;
	String sUrlRedirect ="afficherTousMultimedia.jsp?foo=1";
	long lId = 0;
	String sAction = "create";
	Multimedia multimedia = null;
	PersonnePhysiqueParametre paramPP = null;
	int iIdMultimediaType = -1;
	try{iIdMultimediaType = Integer.parseInt(request.getParameter("iIdMultimediaType"));}
	catch (Exception e) { iIdMultimediaType = MultimediaType.TYPE_SCANNED_SIGNATURE; }

	if(request.getParameter("sUrlRedirect") != null)
	{
		sUrlRedirect = request.getParameter("sUrlRedirect");
	}
	
	if(request.getParameter("lId") != null)
	{
		lId = Integer.parseInt(request.getParameter("lId"));
		multimedia = Multimedia.getMultimedia(lId);
		sAction = "store";
	}else{	
		multimedia = new Multimedia();
		multimedia.setIdReferenceObjet( Integer.parseInt(request.getParameter("iIdReferenceObjet")) );
		multimedia.setIdTypeObjet (Integer.parseInt(request.getParameter("iIdTypeObjet")) );
		multimedia.setIdMultimediaType(iIdMultimediaType );
	}
	multimedia.setAbstractBeanLocalization(sessionLanguage);
	
	MultimediaType mt = new MultimediaType(multimedia.getIdMultimediaType());
	HtmlBeanTableTrPave hbFormulaire = new HtmlBeanTableTrPave();
	hbFormulaire.bIsForm = true;
	boolean bMainSignature = false;
	boolean bDisabled = false;
	
	String sSignatureName = multimedia.getLibelle();
	
	int iSignatureRatio;
	int iOffsetX;
	int iOffsetY;
	
	if(request.getParameter("iSignatureRatio") != null)
	{
		iSignatureRatio = Integer.parseInt(request.getParameter("iSignatureRatio"));
	}
	else
		iSignatureRatio = multimedia.getParameterValueOptionalInt(MultimediaParameter.PARAM_RATIO, 100, conn);
	
	if(request.getParameter("iOffsetX") != null)
	{
		iOffsetX = Integer.parseInt(request.getParameter("iOffsetX"));
	}
	else
		iOffsetX = multimedia.getParameterValueOptionalInt(MultimediaParameter.PARAM_OFFSET_X, 0, conn);
	
	if(request.getParameter("iOffsetY") != null)
	{
		iOffsetY = Integer.parseInt(request.getParameter("iOffsetY"));
	}
	else
		iOffsetY = multimedia.getParameterValueOptionalInt(MultimediaParameter.PARAM_OFFSET_Y, 0, conn);

%>
	
<script type="text/javascript">
<!--
var offsetLimit = 150;

function refreshPreview(){

	if(validateMultimediaParameterData())
	{
		var iSignatureRatio = $('iSignatureRatio').value;
		var valueOffsetX = $('iOffsetX').value;
		var valueOffsetY = $('iOffsetY').value;
		
		var sUrl = '<%= response.encodeURL( "modifierSignatureForm.jsp?lId="+multimedia.getId()) 
			+ "&sUrlRedirect=" + sUrlRedirect%>'

		sUrl += "&iSignatureRatio="+iSignatureRatio
			+"&iOffsetX="+valueOffsetX
			+"&iOffsetY="+valueOffsetY;
		
		doUrl(sUrl);
	}
	
}

function getFileExtension(sFilename){
	var r = new RegExp("\.([^\.]*$)", "gi");
	var aR = sFilename.match(r);
	if (aR.length==0) return "";
	return (aR[aR.length-1]).toLowerCase();  
}

function isGoodExtension(sFilename, errorMsg){
    var sExt = getFileExtension(sFilename);
    if(sExt == ".gif" || sExt == ".jpg" || sExt == ".png" || sExt == ".tiff" || sExt == ".tif"){
    	return true;
    }else{
    	alert(errorMsg);
    	return false;    
    }
}

function validInputData(inputData, errorMsg) {
	if (inputData == null || inputData == "" || inputData == undefined) {
		alert(errorMsg);
		return false;
	} else {
		return true;
	}
}

function validNumericalData(inputData, errorMsg){
	if(inputData.isNumber())
		return true;
	else
	{
		alert(errorMsg);
		return false;
	}
}

function validOffsetLimit(inputData,offsetLimit,errorMsg){
	if(inputData<=offsetLimit)
		return true;
	else
	{
		alert(errorMsg);
		return false;
	}
}

function validateMultimediaParameterData()
{
	isValid = false;
	var iSignatureRatio = $('iSignatureRatio').value;
	var valueOffsetX = $('iOffsetX').value;
	var valueOffsetY = $('iOffsetY').value;
	isValidRatio = validNumericalData(iSignatureRatio,"<%= locMessage.getValue(62,"Vous devez entrer une valeur numérique pour le ratio")%>");
	isValidOffsetX = validNumericalData(valueOffsetX,"<%= locMessage.getValue(63,"Vous devez entrer une valeur numérique pour le déplacement horizontal")%>");
	isValidOffsetY = validNumericalData(valueOffsetY,"<%= locMessage.getValue(64,"Vous devez entrer une valeur numérique pour le déplacement vertical")%>");

	if(isValidRatio && isValidOffsetX && isValidOffsetY)
	{
		isValidOffsetX = validOffsetLimit(valueOffsetX,offsetLimit,"<%= locMessage.getValue(65,"Vous devez définir une valeur inférieure ou égale à")%>"+' '+offsetLimit);
		isValidOffsetY = validOffsetLimit(valueOffsetY,offsetLimit,"<%= locMessage.getValue(65,"Vous devez définir une valeur inférieure ou égale à")%>"+' '+offsetLimit);

		if(isValidOffsetX && isValidOffsetY)
			isValid = true
	}

	return isValid;
}

window.onsubmit = function(){

	if(isNotNull($("signatureFile")))
	{
		var signatureFile = $("signatureFile").value;
		isValid = validInputData(signatureFile, "<%= locMessage.getValue(55,"Vous devez sélectionner un fichier de signature")%>" );
		if(isValid){
			isValid = isGoodExtension(signatureFile, "<%= locMessage.getValue(56,"Le fichier doit être une image")%>");
			if(isValid){
				var sName = $("sName").value;
				isValid = validInputData(sName, "<%= locMessage.getValue(57,"S'il vous plaît, entrez un nom pour votre signature")%>" );

				if(isValid){
					isValid = validateMultimediaParameterData();
				}				
			}	
		}
	}
	else
	{
		isValid = validateMultimediaParameterData();
	}
	
	return isValid;
}
//-->
</script>
</head>

<body>
<div style="padding:15px">


	<form action="<%= response.encodeURL( "uploadSignature.jsp?sAction=" + sAction ) 
	%>" method="post" enctype="multipart/form-data" >
		<input type="hidden" name="lId" value="<%= lId %>" />
		<input type="hidden" name="iIdTypeObjet" value="<%= multimedia.getIdTypeObjet() %>" />	
		<input type="hidden" name="sUrlRedirect" value="<%= sUrlRedirect%>" />
		<input type="hidden" name="iIdReferenceObjet" value="<%= multimedia.getIdReferenceObjet() %>" />
		<input type="hidden" name="bIsPhysique" value="1" />
	<table class="pave">
		<tr>
			<td class="pave_cellule_gauche" ><%=multimedia.getNameLabel() %> : </td>
			<td class="pave_cellule_droite" >
				<input type="text" name="sName" id="sName" size="40" value="<%=sSignatureName %>" /></td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche" ><%=locBloc.getValue(63,"Ratio") %> : </td>
			<td class="pave_cellule_droite" >
				<input 
					style="text-align: right;"
					type="text" 
					name="iSignatureRatio" 
					id="iSignatureRatio" 
					size="3" 
					value="<%= iSignatureRatio %>" /> % 
			</td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">
			<%=locBloc.getValue(67,"Paramètres pour le texte de la délégation") %> :
			</td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche" ><%=locBloc.getValue(64,"Décalage horizontal") %> : </td>
			<td class="pave_cellule_droite" >
				<input 
					style="text-align: right;"
					type="text" 
					name="iOffsetX" 
					id="iOffsetX" 
					size="3" 
					value="<%= iOffsetX %>" />
			</td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche" ><%=locBloc.getValue(65,"Décalage vertical") %> : </td>
			<td class="pave_cellule_droite" >
				<input 
					style="text-align: right;"
					type="text" 
					name="iOffsetY" 
					id="iOffsetY" 
					size="3" 
					value="<%= iOffsetY %>" />
			</td>
		</tr>
<%
	if(!sAction.equals("create"))
	{
%>		
		<tr>
			<td colspan="2" style="text-align: center;">
				<button type="button" onclick="refreshPreview();" >
	          		<%=locAddressBookButton.getValue(41,"Réactualiser") %></button>
	       	</td>
	   </tr>
		
		<tr>
<%
				String sURLTelecharger = "";
				if(multimedia.getIdMultimedia()!=0){
					sURLTelecharger = "desk/DownloadFileDesk?"
						+ DownloadFile.getSecureTransactionStringFullJspPage(
								request, 
								multimedia.getIdMultimedia(),
								TypeObjetModula.MULTIMEDIA )
								+"&bShowText=true"
								+"&iTextPosX="+iOffsetX
								+"&iTextPosY="+iOffsetY
								+"&iSignatureRatio="+iSignatureRatio;
				
					sURLTelecharger = response.encodeURL(rootPath+ sURLTelecharger);
				}
%>
			<td colspan="2" style="text-align: center;">
				<img src="<%= sURLTelecharger 
				%>" />
			</td>
		</tr>
		<tr>
			<td colspan="2" style="text-align: center;">
			<%=locBloc.getValue(68,"Texte montré sur l'aperçu n'est utilisé que dans les signatures par délégation") %>
			</td>
		</tr>
<%
	}

	if(sAction.equals("create"))
	{
%>		
		<%= hbFormulaire.getHtmlTrSelect( 
				sLocalizationNamesTypeSignature+" :","iIdMultimediaType", 
				mt, 
				false, 
				false, 
				"WHERE id_coin_multimedia_type IN ("
					+ MultimediaType.TYPE_SCANNED_SIGNATURE + ", "
					+ MultimediaType.TYPE_SCANNED_VISA + ", "
					+ MultimediaType.TYPE_SCANNED_PARAPH + ")", 
				"")%>
		<tr>
			<td class="pave_cellule_gauche" ><%= sLocalizationNameFichier %> : </td>
			<td class="pave_cellule_droite" >
				<input type="file" id="signatureFile" name="sFilePath" size="35" />
			</td>
		</tr> 
<%
	}
%>		
		<tr>
			<td class="pave_cellule_gauche" ><%=locBloc.getValue(66,"Signature principale") %> : </td>
			<td class="pave_cellule_droite" style="vertical-align:middle">
				<%
				
				if(multimedia.getIdMultimedia()!=0){
					
					long lIdMainSignature = PersonnePhysiqueParametre
						.getMainSignatureForPersonnePhysique(
								multimedia.getIdReferenceObjet(),
								conn);
					
					if(lIdMainSignature == multimedia.getId())
					{
						bMainSignature = true;	
					}
					
				}
				%>
				<input type="checkbox" name="bMainSignature" id="bMainSignature" value="<%=
					bMainSignature %>" <%= 
						bMainSignature?"checked='checked'":"" %> <%= 
							bDisabled?"disabled='disabled'":"" %>/>
			</td>
		</tr>
<%
	if(sAction.equals("store"))
	{
%>	
		<tr>
			<td class="pave_cellule_gauche"><%= multimedia.getFileNameLabel() %> : </td>
			<td class="pave_cellule_droite"><%= multimedia.getFileName() %></td>
		</tr>
<%
	}
%>		
		<tr>
			<td colspan="2" style="text-align:center">
			<button type="submit" ><%= localizeButton.getValueSubmit() %>
			</button>
			<button type="button" onclick="javascript:closeModal();"><%= localizeButton.getValueCancel() %>
			</button>
			</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
	</table>
	</form>
</body>
</html>
<%
	ConnectionManager.closeConnection(conn);
%>