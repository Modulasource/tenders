<%@ include file="../../../include/headerXML.jspf" %>

<%@ page import="org.w3c.dom.*,org.coin.util.*,org.coin.fr.bean.*,org.coin.fr.bean.export.*,modula.marche.*, modula.ws.boamp.*,modula.ws.spqr.*" %>
<% 
	String sTitle = "Envoi de l'annulation de l'affaire SPQR"; 
	String rootPath = request.getContextPath()+"/";
	int iIdOnglet = Integer.parseInt(request.getParameter("iIdOnglet"));
	String sXmlFileToSend = null;
	String sIdAffaire = null;
	int iIdExport = -1;
	boolean bDisplayButtonCheckXml = false;
	
	
	try {
		int iIdPublicationSpqr = Integer.parseInt( request.getParameter("iIdPublicationSpqr"));
		PublicationSpqr item 
			= PublicationSpqr.getPublicationSpqr(iIdPublicationSpqr);
			
		sXmlFileToSend = item.getFichier();
		// on présume que le type d'objet est bien une affaire
		sIdAffaire = "" + item.getIdReferenceObjet();
		iIdExport = item.getIdExport();
	} catch (Exception  e) {}
	
	if(sXmlFileToSend == null)
	{
		Export export = Export.getExport(Integer.parseInt( request.getParameter("iIdExport") ));
		Marche marche = Marche.getMarche(Integer.parseInt( request.getParameter("iIdAffaire") ));

		sXmlFileToSend = ExportXml.genererXmlAnnulation(marche, export);
		sIdAffaire = "" + marche.getIdMarche();
		iIdExport = export.getIdExport();
		bDisplayButtonCheckXml = true;
	}

	Export export = Export.getExport(Integer.parseInt( request.getParameter("iIdExport") ));
	Marche marche = Marche.getMarche(Integer.parseInt( request.getParameter("iIdAffaire") ));
	ExportModeFTP  exportModeFTP = ExportModeFTP.getExportModeFTP(export.getIdExportModeId());

	sIdAffaire = "" + marche.getIdMarche();
	iIdExport = export.getIdExport();

	sXmlFileToSend  = ExportXml.genererXmlAAPC(marche);

	if(sXmlFileToSend == null)
	{
		new Exception ("Flux non reconnu (sXmlFileToSend = null).");
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
	
	//BasicDom.getChildNodeByNodeName(nodeAnn, "ANNUL");
	sTypeFluxXML = "Avis d'annulation";

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
	montrer_cacher('paveBlocAvisInitial');
	montrer_cacher('paveBloc16');
	montrer_cacher('paveBloc17');
	 // montrer_cacher('paveBlocXML');
}
</script>
</head>
<body onload="javascript:onLoadBody()">
<div class="titre_page"><%= sTitle %></div>
<%@ include file="pave/paveBlocFichierXml.jspf" %>
<br/>
<div style="text-align:center">
	<input type="button" value="Revenir à l'affaire" 
		onclick="Redirect('<%=response.encodeURL(
			rootPath
			+"desk/marche/algorithme/affaire/afficherToutesPublications.jsp?iIdAffaire="
					+sIdAffaire
					+ "&amp;iIdOnglet=" + iIdOnglet 
		)%>')" />


	<input type="button" value="Envoyer au SPQR" 
		onclick="Redirect('<%=response.encodeURL(
			rootPath
			+"desk/export/spqr/ajouterPublicationSpqr.jsp?"
			+ "iIdAffaire=" + marche.getIdMarche() 
			+ "&amp;iIdOnglet=" + iIdOnglet
			+ "&amp;iIdExport=" + export.getIdExport())
			+ "&amp;iIdPublicationType=" + PublicationType.TYPE_AVIS_ANNULATION
			+ "&amp;nonce=" + System.currentTimeMillis() %>')" />

</div>

<br/>

<%@ include file="../../include/footerDesk.jspf" %>

</body>
</html>