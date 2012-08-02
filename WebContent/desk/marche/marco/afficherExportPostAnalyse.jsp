<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="java.sql.*,modula.ws.marco.*,org.w3c.dom.*,org.coin.util.*" %>
<% String sTitle = "AFFAIRE MARCO à IMPORTER" ;%>
<%@ include file="../../include/useBoamp17.jspf" %>
<%
	MarcoAffaire aff = null;
	Node nodeData;
	
	int id = Integer.parseInt(request.getParameter("iIdExportMarco"));
	ExportMarco export = ExportMarco.getExportMarco(id);

	MarcoAffaire.sLineFeedToUse = "<br />";
	
	String sPageCreate = "ajouterAffaireForm";
	if(bUseBoamp17){
		sPageCreate = "ajouterAffaireFormBoamp";
	}
	
	int iIdMarche = 0;
	try{
		if(request.getParameter("iIdMarche")!=null)
			iIdMarche = Integer.parseInt(request.getParameter("iIdMarche"));
	}catch(Exception e){}
	if(iIdMarche>0)
		sTitle = "Import MARCO de l'affaire";
%>
</head>
<body>
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<br/>
<div style="padding:15px">
<form action="<%= response.encodeURL("../algorithme/affaire/"+sPageCreate+".jsp") %>" method="post"  name="formulaire" >


<br />
<% 
String sException ="";
Document doc = null;
try {
	doc = BasicDom.parseXmlStream(export.getExport() , false);
}catch (Exception e) {
	sException = e.getMessage();
}


if (doc != null)
{
	nodeData =  BasicDom.getFirstChildElementNode(doc);
	if(nodeData != null)
		aff = new MarcoAffaire(BasicDom.getFirstChildElementNode(nodeData));  

	if(aff != null)
	{
		%><%@ include file="pave/marco_affaire.jspf" %><br/><%
		for (int i=0; i < aff.dossiers.length ; i++)
		{
			try {
			MarcoDossier dossier = aff.dossiers[i]; %> 
<%@ include file="pave/marco_dossier.jspf" %> 
<br />
<%
			}catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
	MarcoAffaire.sLineFeedToUse = "\n";
	
} else {
	String sXml = export.getExport();
%>
<table class="pave">
  <tr>
    <td colspan="2">&nbsp;</td>
  </tr>
  <tr>
	  <td class="pave_cellule_gauche">Exception : </td>
	  <td class="pave_cellule_droite"><%= sException %></td>
  </tr>
  <tr>
	  <td class="pave_cellule_gauche">Fichier : </td>
	  <td class="pave_cellule_droite"><%= Outils.getTextToHtml(sXml==null?"null":sXml) %></td>
  </tr>
  <tr>
    <td colspan="2">&nbsp;</td>
  </tr>
</table>
<%
}
%>
<br />

<div align="center">
<input type="hidden" name="iIdAffaire" value="<%= export.getIdExportMarco() %>" />
<%
	if(iIdMarche==0){
%>
<button type="submit"  >Importer</button>
<button type="button" onclick="Redirect('<%=response.encodeURL("afficherListeExport.jsp")%>')" >Annuler</button>
<%
	}else{
%>
<button type="button" 
	onclick="Redirect('<%=response.encodeURL(rootPath+"desk/marche/algorithme/affaire/afficherAffaire.jsp?iIdAffaire="
			+iIdMarche)%>')" >Retour à l'affaire</button>
<%	} %>
</div>

</form>
</div>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>
</html>
