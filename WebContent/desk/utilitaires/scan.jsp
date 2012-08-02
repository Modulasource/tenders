<%@ include file="../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.security.*,org.coin.util.*" %>
<%@ page import="com.oreilly.servlet.multipart.*" %>
<%@ page import="java.io.*" %>
<%
	String sTitle = "Test Antivirus";
	String sFormPrefix = "";
			
	String sClamAVVersion = "";
	try{sClamAVVersion = ClamAV.getVersion();}
	catch(Exception e){e.printStackTrace();}
	
	ClamAV av = new ClamAV();
	File tmp = null;
	String sFileName = "";
	
	MultipartParser mp = null;
	Part part = null;
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
</head>
<body>
<%@ include file="../../include/new_style/headerFiche.jspf" %>
<br />
<table class="pave" style="text-align:center" >
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
		<td class="pave_cellule_gauche">Rapport d'&eacute;x&eacute;cution : </td>
		<td class="pave_cellule_droite"><%= Outils.replaceNltoBr(av.sReport) %></td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr><td colspan="2"><input type="button" value="Retour" onclick="Redirect('<%= response.encodeURL("scanForm.jsp") %>')" /></td></tr>
	<tr><td colspan="2">&nbsp;</td></tr>
</table>
<%@ include file="../../include/new_style/footerFiche.jspf" %>
</body>
<%@page import="modula.graphic.Icone"%>
</html>
