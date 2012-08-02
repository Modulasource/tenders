<%@ include file="/include/new_style/headerPublisher.jspf" %>

<%@page import="modula.graphic.Icone"%>
<%@page import="com.oreilly.servlet.multipart.*"%>
<%@page import="java.io.File"%>
<%@ include file="/publisher_traitement/public/include/beanCandidat.jspf" %>
<%
	String sTitle = "Test Antivirus";
    String sPageUseCaseId = "IHM-PUBLI-3";  
%>

</head>
<body>
<%@ include file="/publisher_traitement/public/include/header.jspf" %>
<%
	String sFormPrefix = "";
			
	String sClamAVVersion = "";
	try{sClamAVVersion = ClamAV.getVersion();}
	catch(Exception e){e.printStackTrace();}
	
	ClamAV av = new ClamAV();
	File tmp = null;
	String sFileName = "";
	
	MultipartParser mp = null;
	com.oreilly.servlet.multipart.Part part = null;
	try
	{
		mp = new MultipartParser(request, Integer.MAX_VALUE);
		part = mp.readNextPart();
	}
	catch(Exception e)
	{
		e.printStackTrace();
	}
	
	while (part != null)
	{
		if (part.isFile())
		{
			FilePart file = (FilePart)part;
			
			if (file.getName().equals(sFormPrefix+"sFilePath"))
			{
				sFileName = file.getFileName();
				
				try
				{
					tmp = File.createTempFile(file.getFileName(),"");
					FileUtil.convertInputStreamInFile(file.getInputStream(), tmp);
					av.scanFile(tmp.getAbsolutePath());
				}
				catch(Exception e){}

				tmp.delete();
			}
		}
		
		try {
			part = mp.readNextPart();
		}
		catch(Exception e){
			
		}
	}
	
	String sEtat = "Fichier non compromis";
	String sImgSrc = rootPath+ Icone.ICONE_SUCCES;

	if(av.bIsExistVirus)
	{
		sEtat = "Virus détécté";
		sImgSrc = rootPath+ Icone.ICONE_ERROR;
	}
	String sImg = "<img src=\""+sImgSrc+"\" width=\"16px\" />";
%>
<div class="post">
    <div class="post-title">
        <table class="fullWidth" cellpadding="0" cellspacing="0">
        <tr>
            <td>
                <strong style="color:#36C">Assistance / Scan</strong>
            </td>
            <td class="right">
                <strong style="color:#B00">&nbsp;</strong>
            </td>
        </tr>
        </table>
    </div>
  <br/>
  <div class="post-footer post-block" style="margin-top:0">
  <table class="fullWidth">
	<tr>
		<td class="pave_titre_gauche"><%= sTitle %></td>
		<td class="pave_titre_droite"><%= sClamAVVersion %></td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr><td class="mention" colspan="2"></td></tr>
	<tr>
		<td class="pave_cellule_gauche">Fichier : </td>
		<td class="pave_cellule_droite"><%= sFileName %></td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Etat : </td>
		<td class="pave_cellule_droite"><%= sEtat +" "+ sImg %></td>
	</tr>
	<%if(av.bIsExistVirus){ %>
	<tr>
		<td class="pave_cellule_gauche">Virus : </td>
		<td class="pave_cellule_droite"><font class="rouge"><%= av.sVirus %></font></td>
	</tr>
	<%} %>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr>
		<td class="pave_cellule_gauche">Rapport d'éxécution : </td>
		<td class="pave_cellule_droite"><%= Outils.replaceNltoBr(av.sReport) %></td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr><td colspan="2" style="text-align:center"><button type="button" onclick="Redirect('<%= 
		response.encodeURL("scanForm.jsp") %>')" >Retour</button></td></tr>
	<tr><td colspan="2">&nbsp;</td></tr>
</table>
</div>
</div>
<%@include file="/publisher_traitement/public/include/footer.jspf"%>
</body>
<%@page import="org.coin.util.FileUtil"%>
<%@page import="org.coin.util.Outils"%>
</html>