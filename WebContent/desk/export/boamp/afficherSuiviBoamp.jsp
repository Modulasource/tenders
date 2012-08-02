<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.util.Vector"%>
<%@page import="modula.ws.boamp.suivi.*"%>
<%@page import="modula.ws.boamp.*"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.fr.bean.export.*"%>
<%@page import="org.coin.util.Outils"%>
<%@page import="org.coin.util.BasicDom"%>

<% 
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);
	
	String sTitle = "Suivi du marché au B.O.A.M.P"; 
	String sHeadTitre = sTitle; 
	String sIdAffaire = request.getParameter("iIdAffaire");
	String sIsProcedureLineaire = "true";
	int iIdOnglet = HttpUtil.parseInt("iIdOnglet", request, -1)  ;
	boolean bAfficherPoursuivreProcedure = false;
	
	boolean bDisplayAll = false;
	if(	(request.getParameter("bDisplayAll")) != null)
	{
		if(request.getParameter("bDisplayAll").equals("true"))
			 bDisplayAll = true;
	}
	
	Export export = Export.getExport(Integer.parseInt(request.getParameter("iIdExport")));
	ListSuivi liste = null;    
	String sIsConnected="<span class=\"rouge\">Impossible se connecter au serveur B.O.A.M.P</span>";
	boolean bIsConnected=false;
	try{
		liste = ServeurFichiersXMLBoamp.recupererSuiviPublicationBoamp(Integer.parseInt(sIdAffaire),export);
		sIsConnected = "Récupération du fichier de suivi depuis le serveur B.O.A.M.P ... <span class=\"vert\">OK</span>";
		bIsConnected = true;
	}catch (Exception e ){
		e.printStackTrace();
		throw new ServletException("Impossible se connecter au serveur B.O.A.M.P");
	}
	Vector<Annonce> vAnnoncesAffichees = new Vector<Annonce>();
	try{
		vAnnoncesAffichees = liste.getAnnonces();
	}catch(Exception e){}
        
  %>
<script type="text/javascript" src="<%=rootPath%>include/cacherDivision.js"></script>
<script type="text/javascript" >
function onLoadBody()
{
<%
	for(int i = 0; i < vAnnoncesAffichees.size(); i++)
	{
	%>montrer_cacher('paveFichierEnvoye_<%= i %>');
	<%
	}
%>
}

</script>
</head>
<body onload="javascript:onLoadBody();" >
<%@ include file="/include/new_style/headerFiche.jspf" %>
<br/>
<div style="padding:15px">
<div style="text-align:center">
	<button type="button" 
		onclick="Redirect('<%=response.encodeURL(
			rootPath
			+"desk/marche/algorithme/affaire/afficherToutesPublications.jsp?iIdAffaire="+sIdAffaire
			+"&amp;iIdOnglet="+iIdOnglet
			+"&amp;sIsProcedureLineaire="+sIsProcedureLineaire
			+"&amp;iIdExport="+export.getIdExport())%>')" >Revenir à l'affaire</button>
</div>
<br />
<%@include file="pave/paveInfosSchemaBoamp.jspf" %>
<%
	for(int i = 0; i < vAnnoncesAffichees.size(); i++)
	{
		Annonce annonce = vAnnoncesAffichees.get(i );
		String sTypePublication = "non trouvé !";
		
		String sAffaireReferenceModula = "";
		PublicationBoamp publi = new PublicationBoamp();
		try {
			// il se peut que l'on est purgé la bdd
			publi = PublicationBoamp.getPublicationBoampFromFilename(annonce.getNomFichierEnvoye()) ;
		
			try{
				sTypePublication 
					= PublicationType
						.getPublicationTypeNameMemory(publi.getIdPublicationType());
				
			}catch(Exception e)	{
				sTypePublication = "non trouvé : " +  publi.getId() + " - type : " + publi.getIdPublicationType();
				e.printStackTrace();
			}
		} catch (Exception e) {
			sTypePublication = "non trouvé : " + annonce.getNomFichierEnvoye() ;
			e.printStackTrace();
		}
			
		sAffaireReferenceModula 
			+= sTypePublication + " - ";
	
		sAffaireReferenceModula += 
			PublicationEtat.getPublicationEtatNameMemory(
					PublicationBoamp.getPublicationEtatFromBoampType(annonce.getEtat()))
					+" ("+annonce.getEtat()+")" ;
		
		String sStylePave = "";
		if (annonce.getEtat().equals("RX") || annonce.getEtat().equals("RG") )
		{
			sStylePave = " style= \"background-image : url('../images/icones/bg_head_error.jpg');"
			+ " background-color : #FF5555 ; \" ";
			
		}
		Timestamp tsDateEnvoiPublication 
			= CalendarUtil.getConversionTimestamp(annonce.getDateEnvoi(),"yyyy-MM-dd");
 %>
<table class="pave" >
	<tr>
		<td class="pave_titre_gauche" <%= sStylePave %> colspan="2">Suivi de l'<%= sAffaireReferenceModula  %></td>
	</tr>
	<tr>
		<td>
		<table >
		<tr>
			<td colspan="2">&nbsp;</td></tr>
			<tr>
				<td class="pave_cellule_gauche">Référence Boamp :</td>
				<td class="pave_cellule_droite"><%= annonce.getIdAnnonceBoamp().equalsIgnoreCase("")?"Inexistante":annonce.getIdAnnonceBoamp() %>
				</td>
			</tr>
			<tr>
				<td class="pave_cellule_gauche">Référence JO :</td>
				<td class="pave_cellule_droite"><%= annonce.getIdJO().equalsIgnoreCase("")?"Inexistante":annonce.getIdJO() %>
				</td>
			</tr>
			<tr>
				<td class="pave_cellule_gauche">Référence Fichier envoyé :</td>
				<td class="pave_cellule_droite"><%= annonce.getNomFichierEnvoye() %>
				</td>
			</tr>
			<tr>
				<td class="pave_cellule_gauche">Etat :</td>
				<td class="pave_cellule_droite"><%= PublicationEtat.getPublicationEtatName(PublicationBoamp.getPublicationEtatFromBoampType(annonce.getEtat()))+" ("+annonce.getEtat()+")" %>
				</td>
			</tr>
			<tr>
				<td class="pave_cellule_gauche">Date d'envoi :</td>
				<td class="pave_cellule_droite"><%= CalendarUtil.getDateFormattee(tsDateEnvoiPublication)%>
				</td>
			</tr>
<%
	if (annonce.getEtat().equals("RX") || annonce.getEtat().equals("RG") ){
		InfosRejet infosRejet = annonce.getInfosRejet();
%>			<tr>
				<td class="pave_cellule_gauche">Motif(s) du rejet :</td>
				<td class="pave_cellule_droite"><%= infosRejet.getDescription().replaceAll("\n","<br/>") %>
				</td>
			</tr>
<% 
	}
	InfosRegles infosRegles = annonce.getInfosRegles();
		for(int j=0;j< infosRegles.vErreurs.size();j++)	{
			Erreur erreur = infosRegles.vErreurs.get(j);
		%>
		
			<tr>
				<td class="pave_cellule_gauche">Règle n° <%= erreur.getErreurNumero() %></td> 
				<td class="pave_cellule_droite"><%= erreur.getErreurTexte().replaceAll("\n","<br/>") %>
				</td>
			</tr>
		<%
		}
	Vector<InfosPub> vInfosPub = annonce.getInfosPub();
		for(int j=0;j< vInfosPub.size();j++) {
			InfosPub infosPub = vInfosPub.get(j);
			Timestamp tsDatePublication 
				= CalendarUtil.getConversionTimestamp(infosPub.getDatePublication(),"yyyy-MM-dd");
		%>
		
			<tr>
				<td class="pave_cellule_gauche">Parution au journal <%= infosPub.getParutionType() %> </td>
				<td class="pave_cellule_droite">
					Parution du <%= infosPub.getParution() 
						+ " n°" + infosPub.getNumeroAnnonceParue()  
						+ " publiée le " + CalendarUtil.getDateFormattee(tsDatePublication) %><br/>
					URL : <a href='<%= infosPub.getUrl()  %>' target="_blank" ><%= infosPub.getUrl() %></a><br/>
					URL_PDF : <a href='<%= infosPub.getUrlPdf ()  %>' target="_blank" ><%= infosPub.getUrlPdf() %></a>
				</td> 
			</tr>
		<%
		}
		%>	
			<tr>
				<td class="pave_cellule_gauche">Noeud XML reçu du B.O.A.M.P pour cette annonce :</td>
				<td class="pave_cellule_droite"><%= 
					Outils.replaceAll(
						Outils
						.getTextToHtml(
							BasicDom.getXML(annonce.getNode())), "&gt;", "&gt;\n<br/>") %></td>
			</tr>
			<tr><td colspan="2">&nbsp;</td></tr>
		</table>		
		</td>
	</tr>
</table>
<%
	
	String sXmlStringIndentToHtml = "";
	try {
		sXmlStringIndentToHtml 
			= Outils
				.getXmlStringIndentToHtml(
						BasicDom.parseXmlStream(
								publi.getFichier(), 
								false));
		
	} catch (Exception e) {
		sXmlStringIndentToHtml 
			= "<span style='color red'>" + e.getMessage() + "</span><br/>"
			+ Outils.getTextToHtml( publi.getFichier() );
	}
%>

<table class="pave" >
	<tr >
		<td class="pave_titre_gauche" colspan="2">Fichier XML envoyé au B.O.A.M.P</td>
	</tr>
	<tr onclick="montrer_cacher('paveFichierEnvoye_<%= i %>')" >
		<td class="pave_cellule_gauche" style="vertical-align:middle">Fichier XML envoyé au B.O.A.M.P</td>
		<td class="pave_body_opener">Voir le fichier</td>
	</tr>
	<tr id="paveFichierEnvoye_<%= i %>">
		<td colspan="2">
			<table >
				<tr><td colspan="2">&nbsp;</td></tr>
				<tr><td colspan="2" class="pave_cellule_droite"><%= sXmlStringIndentToHtml %></td></tr>
				<tr><td colspan="2">&nbsp;</td></tr>
			</table>
		</td>
	</tr>
</table>
<br />	
<%		
	} 
%>
	
<div style="text-align:center">
	<button type="button" 
		onclick="Redirect('<%=response.encodeURL(
			rootPath
			+"desk/marche/algorithme/affaire/afficherToutesPublications.jsp?iIdAffaire="+sIdAffaire
			+"&amp;iIdOnglet="+iIdOnglet
			+"&amp;sIsProcedureLineaire="+sIsProcedureLineaire
			+"&amp;iIdExport="+export.getIdExport())%>')" >Revenir à l'affaire</button>
</div>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>

<%@page import="modula.marche.Marche"%></html>