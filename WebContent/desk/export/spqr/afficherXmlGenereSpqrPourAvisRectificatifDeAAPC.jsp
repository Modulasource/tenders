<%@ include file="../../../include/headerXML.jspf" %>

<%@ page import="org.w3c.dom.*,org.coin.util.*,org.coin.fr.bean.*,org.coin.fr.bean.export.*,modula.marche.*, modula.ws.spqr.*,modula.ws.boamp.*" %>
<% 
	String sTitle = "Envoi de l'affaire au SPQR"; 
	String rootPath = request.getContextPath()+"/";
	
	String sXmlFileToSend = null;
	int iIdOnglet = Integer.parseInt(request.getParameter("iIdOnglet"));
	int iIdExport = -1;

	Export export = Export.getExport(Integer.parseInt( request.getParameter("iIdExport") ));
	AvisRectificatif avisRectificatif = AvisRectificatif.getAvisRectificatif(Integer.parseInt( request.getParameter("iIdAvisRectificatif") ));
	Marche marche = Marche.getMarche(avisRectificatif.getIdMarche());
	ExportModeFTP  exportModeFTP = ExportModeFTP.getExportModeFTP(export.getIdExportModeId());

	iIdExport = export.getIdExport();

	sXmlFileToSend  = ExportXml.genererXmlAvisRectificatifAAPC(avisRectificatif.getIdAvisRectificatif());
	
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
			+"desk/marche/algorithme/affaire/afficherToutesPublications.jsp?iIdAffaire="+marche.getIdMarche() 
			+ "&amp;iIdOnglet=" + iIdOnglet
		)%>')" />


	<input type="button" value="Envoyer au SPQR" 
		onclick="Redirect('<%=response.encodeURL(
			rootPath
			+"desk/export/spqr/ajouterPublicationSpqr.jsp?"
			+ "iIdAffaire=" + marche.getIdMarche() 
			+ "&amp;iIdOnglet=" + iIdOnglet
			+ "&amp;iIdExport=" + export.getIdExport())
			+ "&amp;iIdPublicationType=" + PublicationType.TYPE_AVIS_RECTIFICATIF_DE_AAPC
			+ "&amp;nonce=" + System.currentTimeMillis() %>')" />
</div>

<br />
<br />
<br/>

<%@ include file="../../include/footerDesk.jspf" %>

</body>
</html>