<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="com.oreilly.servlet.multipart.*, java.sql.*,modula.graphic.*" %>
<%@ page import="modula.marche.*" %>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);

	String sTitle = "Chargement de fichier";
%>
<script type="text/javascript">
<!--
function closeModalFrame(url)
{
	parent.redirectParentTabActive(url);
	try {new parent.Control.Modal.close();}
	catch(e) { Control.Modal.close();}
}	

//-->
</script>


</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<%

	
	MultipartParser mp = new MultipartParser(request, Integer.MAX_VALUE);
	boolean bIsDCEDisponible = false;

	Part part;
	while ((part = mp.readNextPart()) != null)
	{
		/* Traitement de l'upload du fichier */
		if (part.isFile())
		{
			FilePart file = (FilePart)part;
			
			if (file.getName().equals("pieceJointePath") && (file.getFileName()!=null) && (file.getFileName()!= ""))
			{
				marche.setNomAAPC(file.getFileName());
				marche.setAAPC(file.getInputStream());
				marche.store();
				marche.storeAAPC();
			}
		} else if(part.isParam()) {
			ParamPart param = (ParamPart)part;
			if(param.getName().equals("bIsDCEDisponible"))
			{
				String s = param.getStringValue();
				bIsDCEDisponible = s.equals("on") || s.equals("true");
			}
		}
	}
	String sNomAAPCLibre = marche.getNomAAPC();
	if (sNomAAPCLibre != null && !sNomAAPCLibre.equals("") )
	{
	}
	else
	{
		sNomAAPCLibre = "pas de document associé";
	}

	marche.setDCEDisponible(bIsDCEDisponible);
	marche.store();

	
	String sMessTitle="";
	String sMess = "Le document suivant a bien été chargé :<br /><br />"+sNomAAPCLibre;
	String sUrlIcone = Icone.ICONE_SUCCES;
%>
<br /><br />
<%@ include file="../../../include/message.jspf"  %>	
	<br />	

<div style="text-align: center;">
	<button type="button" onclick="closeModalFrame('<%=
		response.encodeURL(
				rootPath + "desk/marche/petitesAnnonces/"
				+ "afficherPetiteAnnonce.jsp?sAction=store&iIdAffaire="
				+ marche.getIdMarche()) %>')" >Retour</button>
</div>	
		<br />			
				
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body >
<%@page import="org.coin.util.HttpUtil"%>
</html>
