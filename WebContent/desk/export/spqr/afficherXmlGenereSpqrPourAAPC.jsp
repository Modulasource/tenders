<%@ include file="../../../include/headerXML.jspf" %>

<%@ page import="org.w3c.dom.*,org.coin.util.*,org.coin.fr.bean.*,org.coin.fr.bean.export.*,modula.marche.*, modula.ws.spqr.*,modula.ws.boamp.*" %>
<% 
	String sTitle = "Envoi de l'affaire au SPQR"; 
	String rootPath = request.getContextPath()+"/";
	
	String sXmlFileToSend = null;
	String sIdAffaire = null;
	int iIdOnglet = Integer.parseInt(request.getParameter("iIdOnglet"));
	int iIdExport = -1;
	try { 
		int iIdPublicationSpqr = Integer.parseInt( request.getParameter("iIdPublicationSpqr"));
		PublicationSpqr item = PublicationSpqr.getPublicationSpqr(iIdPublicationSpqr);
		sXmlFileToSend = item.getFichier();
		// on présume que le type d'objet est bien une affaire
		sIdAffaire = "" + item.getIdReferenceObjet();
		iIdExport = item.getIdExport();
	} catch (Exception  e) {}
	

	Export export = Export.getExport(Integer.parseInt( request.getParameter("iIdExport") ));
	Marche marche = Marche.getMarche(Integer.parseInt( request.getParameter("iIdAffaire") ));
	ExportModeFTP  exportModeFTP = ExportModeFTP.getExportModeFTP(export.getIdExportModeId());

	sIdAffaire = "" + marche.getIdMarche();
	iIdExport = export.getIdExport();

	if (marche.getIdAlgoAffaireProcedure() == modula.algorithme.AffaireProcedure.AFFAIRE_PROCEDURE_PETITE_ANNONCE)
	{		
		sXmlFileToSend = ExportXml.genererXmlAAPCPetiteAnnonce(marche, export, ""); 
	} 
	else
	{
		sXmlFileToSend = ExportXml.genererXmlAAPC(marche, export, "");
	}

	Document doc = null;
	try
	{
    	doc = BasicDom.parseXmlStream(sXmlFileToSend  , false);
    }
    catch (Exception e)
    {
    	throw new Exception ("Génération incorrecte du fichier \nFichier=\n" + sXmlFileToSend + "\nMessage Complémentaire : \n" + e.getMessage());
    }
    
	Node nodeRoot =  BasicDom.getFirstChildElementNode(doc);
	
	Node nodeEmetteur =  BasicDom.getFirstChildElementNode(nodeRoot);
	Node nodeAnn =  BasicDom.getNextSiblingElementNode(nodeEmetteur );

 	
	String sTypeFluxXML = "";
	
	//BasicDom.getChildNodeByNodeName(nodeAnn, "AAPC");
	sTypeFluxXML = "Avis d'appel public à la concurrence";

	
	String sSrcImageChecked = rootPath + "images/icones/check.gif";
	String sSrcImageNotChecked = rootPath + "images/icones/nocheck.gif";
%>  
<%@ include file="../../include/headerDesk.jspf" %>
<%@ include file="../../include/beanSessionUser.jspf" %>
<script type="text/javascript" src="<%=rootPath%>include/cacherDivision.js"></script>
<script type="text/javascript" >
function onLoadBody()
{
	montrer_cacher('paveBlocParamEnvoi');
	montrer_cacher('paveBloc1');
	montrer_cacher('paveBloc2');
	montrer_cacher('paveBloc3');
	montrer_cacher('paveBloc4');
	montrer_cacher('paveBloc5');
	montrer_cacher('paveBloc6');
	montrer_cacher('paveBloc7');
	montrer_cacher('paveBloc8');
	montrer_cacher('paveBloc9');
	montrer_cacher('paveBloc10');
	montrer_cacher('paveBloc11');
	montrer_cacher('paveBloc12');
	montrer_cacher('paveBloc13');
	montrer_cacher('paveBloc14');
	montrer_cacher('paveBloc15');
	montrer_cacher('paveBloc16');
	montrer_cacher('paveBloc17');
	// montrer_cacher('paveBlocXML');
}
</script>
</head>
<body onload="javascript:onLoadBody()">
<div class="titre_page"><%=sTitle %></div>
<%@ include file="pave/paveBlocFichierXml.jspf" %>
<br /><br />
<div style="text-align:center">
	<input type="button" value="Revenir à l'affaire" 
		onclick="Redirect('<%=response.encodeURL(
			rootPath
			+"desk/marche/algorithme/affaire/afficherToutesPublications.jsp?iIdAffaire="+sIdAffaire
			+ "&amp;iIdOnglet=" + iIdOnglet
		)%>')" />


	<input type="button" value="Envoyer au SPQR" 
		onclick="Redirect('<%=response.encodeURL(
			rootPath
			+"desk/export/spqr/ajouterPublicationSpqr.jsp?"
			+ "iIdAffaire=" + marche.getIdMarche() 
			+ "&amp;iIdOnglet=" + iIdOnglet
			+ "&amp;iIdExport=" + export.getIdExport())
			+ "&amp;iIdPublicationType=" + PublicationType.TYPE_AAPC
			+ "&amp;nonce=" + System.currentTimeMillis() %>')" />
</div>

<br />
<br />
<br/>

<%@ include file="../../include/footerDesk.jspf" %>

</body>
</html>