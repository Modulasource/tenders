<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@ page import="java.util.*,org.w3c.dom.*,org.coin.util.*,org.coin.fr.bean.export.*,modula.marche.*,modula.algorithme.*" %>
<% 
	String sTitle = "Résumé de la publication B.O.A.M.P";
	String sHeadTitre = sTitle;
	int iIdOnglet = Integer.parseInt(request.getParameter("iIdOnglet"));
	String sIsProcedureLineaire = request.getParameter("sIsProcedureLineaire");
	int iIdExport = Integer.parseInt(request.getParameter("iIdExport"));
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire")); 
	Marche marche = Marche.getMarche(iIdAffaire, false);
	boolean bAfficherPoursuivreProcedure = true;
	boolean bIsStatutForm = false;
	
	try {
		bIsStatutForm = Boolean.parseBoolean(request.getParameter("bIsStatutForm"));
	} catch (Exception e){}
	
%>
<script type="text/javascript" src="<%=rootPath%>include/cacherDivision.js"></script>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<br/>
<div style="padding:15px">
<%@ include file="/include/new_style/headerAffaireOnlyButtonDisplayAffaire.jspf" %>
<br/>
<%
	String sUrlRedirect = rootPath 
		+"desk/marche/algorithme/affaire/afficherToutesPublications.jsp?iIdPublicationBoamp="
			+request.getParameter("iIdPublicationBoamp")
			+"&iIdOnglet="+iIdOnglet
			+"&sIsProcedureLineaire="+sIsProcedureLineaire
			+"&iIdExport="+iIdExport
			+"&iIdAffaire="+iIdAffaire+"#ancreHP";
	
	String sUrlStatutForm = rootPath 
			+"desk/export/publication/afficherPublicationBoamp.jsp?iIdPublicationBoamp="
				+request.getParameter("iIdPublicationBoamp")
				+"&iIdOnglet="+iIdOnglet
				+"&sIsProcedureLineaire="+sIsProcedureLineaire
				+"&iIdExport="+iIdExport
				+"&iIdAffaire="+iIdAffaire
				+"&bIsStatutForm=true"
				+"#ancreHP";
		
	String sUrlSubmitStatutForm = rootPath 
		+"desk/export/publication/updateStatutPublicationBoamp.jsp?iIdPublicationBoamp="
			+request.getParameter("iIdPublicationBoamp")
			+"&iIdOnglet="+iIdOnglet
			+"&sIsProcedureLineaire="+sIsProcedureLineaire
			+"&iIdExport="+iIdExport
			+"&iIdAffaire="+iIdAffaire
			+"&bIsStatutForm=true"
			+"#ancreHP";
					
			
	if(request.getParameter("sUrlRedirect") != null)
	{
		sUrlRedirect = request.getParameter("sUrlRedirect");
	}
	String sAction = request.getParameter("sAction");
	
	PublicationBoamp publi 
		= PublicationBoamp.getPublicationBoamp(
				Integer.parseInt(request.getParameter("iIdPublicationBoamp")));
	String sXmlSend = "";
	Document doc = null;
	try {
		doc = BasicDom.parseXmlStream(publi.getFichier(), false); 
		sXmlSend = Outils.getXmlStringIndentToHtml(doc);
	} catch (Exception e) {
		sXmlSend = Outils.getTextToHtml( publi.getFichier());
	}

	%>
	<form action="<%=response.encodeURL( sUrlSubmitStatutForm) %>" method="post" >
	<table class="pave" >
		<tr>
			<td class="pave_titre_gauche" colspan="2">Publication</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<%@ include file="pave/pavePublicationBoamp.jspf" %>
		<tr><td colspan="2">&nbsp;</td></tr>
	</table>
<br />		


<%= PublicationBoamp.getAllStatutsHtmtTable(bIsStatutForm, "Statuts", "PublicationBoampStatut_", publi.getAllStatuts()) %>	
<br />		
	<button type="button" onclick="Redirect('<%=
		response.encodeURL( sUrlRedirect ) %>')" >Retour</button>
<%
	if(sessionUserHabilitation.isSuperUser()) 
	{
		if(bIsStatutForm)	{
		%>
			<button type="submit" >Valider</button>
		<%		
		} else {
%>
	<button type="button" onclick="Redirect('<%=
		response.encodeURL( sUrlStatutForm ) %>')" >Modifier</button>
<%		
		}
	}
%>
	</form>
	
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>	
</body>
</html>
