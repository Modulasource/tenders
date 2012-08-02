<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@page import="java.io.*,com.oreilly.servlet.multipart.*, modula.graphic.*,org.coin.fr.bean.*" %>
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="org.coin.db.CoinDatabaseAbstractBean"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.util.FileUtil"%>
<%@page import="org.coin.fr.bean.PersonnePhysiqueParametre" %>
<%@page import="mt.paraph.folder.util.ParaphFolderWorkflowCircuit"%>
<%@ include file="../organisation/pave/localizationObject.jspf" %>
<%
	String sLocalizationNameSignature = locBloc.getValue(56,"Signature");
	String sTitle = "Cargar firma"; 
	String sUrlRedirect = "";
	Multimedia multi = null;
    Connection conn = ConnectionManager.getConnection();
    request.setAttribute("conn", conn);
	boolean bMainSignature = false;
	MultipartParser mp = new MultipartParser(request, Integer.MAX_VALUE);
	Part part;
	
	while ((part = mp.readNextPart()) != null)
	{
		if (part.isParam())
		{
			ParamPart param = (ParamPart)part;	
			
			if (param.getName().equals("lId")){
				try{
					multi = Multimedia.getMultimedia( Integer.parseInt(  param.getStringValue()) );
				}
				catch(Exception e){
					multi = new Multimedia();
					multi.create();
				}
			}
		}	
		
		/* Traitement de l'upload du fichier */
		if (part.isFile())
		{
			FilePart file = (FilePart)part;
			if (file.getName().equals("sFilePath"))
			{
				multi.setFileName(file.getFileName()); 
				multi.setMultimediaFile(file.getInputStream()); 
				multi.setContentType(file.getContentType()); 
				try{
					multi.store();
					multi.storeMultimediaFile();
				}catch(Exception e){
					e.printStackTrace();
				}
			}
		}
		if (part.isParam())
		{
			ParamPart param = (ParamPart)part;
			String n = param.getName();

			try{
				if (n.equals("iIdMultimediaType")){
					multi.setIdMultimediaType( Integer.parseInt(  param.getStringValue()) );
				} else if (n.equals("iIdReferenceObjet")){
					multi.setIdReferenceObjet( Integer.parseInt(  param.getStringValue()) );
				} else if (n.equals("iIdTypeObjet")){
					multi.setIdTypeObjet( Integer.parseInt(  param.getStringValue()) );
				} else if (n.equals("sUrlRedirect")){
					sUrlRedirect = param.getStringValue() ;
				} else if (n.equals("sName")){
					multi.setLibelle (param.getStringValue());
				} else if (n.equals("iSignatureRatio")){
		    		multi.updateParameterValue(MultimediaParameter.PARAM_RATIO, param.getStringValue(), conn);
				} else if (n.equals("iOffsetX")){
		    		multi.updateParameterValue(MultimediaParameter.PARAM_OFFSET_X, param.getStringValue(), conn);
				} else if (n.equals("iOffsetY")){
		    		multi.updateParameterValue(MultimediaParameter.PARAM_OFFSET_Y, param.getStringValue(), conn);
				} else if (n.equals("bMainSignature")){
					bMainSignature = true;
				}
			} catch (Exception e){
				e.printStackTrace();
			}
		}
		multi.store();
	}
	

	long lMainSign = PersonnePhysiqueParametre
		.getMainSignatureForPersonnePhysique(
				multi.getIdReferenceObjet(),
				conn);

	if(lMainSign == -1 || bMainSignature){
		PersonnePhysiqueParametre.setMainSignatureForPersonnePhysique(
				multi.getIdReferenceObjet(),
				multi.getId());
	}
	
	
	
	String sMessTitle="";
	String sMess = locMessage.getValue(54,"Le média à bien été chargé");
	String sUrlIcone = Icone.ICONE_SUCCES;
	
	String sRedirectURL = response.encodeRedirectURL(
			sUrlRedirect 
			+ "&iIdReferenceObjet=" + multi.getIdReferenceObjet() 
			+ "&iIdTypeObjet=" + multi.getIdTypeObjet()
			+ "&nonce=" +System.currentTimeMillis() );
	
	
	ConnectionManager.closeConnection(conn);
%>
</head>
<body>
<%@ include file="/include/new_style/headerFichePopUp.jspf" %>
<script type="text/javascript">
document.observe("dom:loaded", function() {
	closeModalAndRedirectTabActiveWithTime('<%= sRedirectURL %>', 500);
});

</script>

<br/>
<div style="padding:15px">
<%@ include file="/include/message.jspf"  %>	
	<div style="text-align:center">
	<button type="button" onclick="javascript:closeModalAndRedirectTabActive('<%= 
		sRedirectURL %>')" ><%= localizeButton.getValueAccept() %></button>
	</div>
</body>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</html>
