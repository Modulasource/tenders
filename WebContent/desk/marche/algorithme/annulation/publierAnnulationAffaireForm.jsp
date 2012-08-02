<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.fr.bean.mail.*,modula.marche.*,java.util.*,org.coin.fr.bean.*" %>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));//input type="hidden" value="<%=iIdAffaire ...dans paveMailer
	Marche marche = Marche.getMarche(iIdAffaire);

	String sTitle = "Publier l'annulation de l'affaire";
	boolean bJoindreAAPC = false;
	boolean bJoindreAATR = false;
	Vector vPublications = 
		Organisation.getAllOrganisationsWithIdType(OrganisationType.TYPE_PUBLICATION);

	MailType mailType = MailType.getMailTypeMemory(MailConstant.MAIL_PUB_ANNULATION); 
	String sTitrePave = "Mail envoyé aux publications";
	String[] sBalisesActives = {
			"[marche_reference]",
			"[marche_objet]",
			"[marche_prm_personne_civilite]",
			"[marche_prm_personne_nom]",
			"[logged_personne_nom]",
			"[logged_personne_civilite]"};
%>
<script type="text/javascript" src="<%=rootPath %>include/checkbox.js"></script>
</head>
<body>
<%@ include file="/include/new_style/headerFichePopUp.jspf" %>
<div style="padding:15px">
<form action="<%= response.encodeURL("publierAnnulationAffaire.jsp") %>"  name="form" id="form" method="post">
<table class="pave" summary="none">
	<tr>
		<td class="pave_titre_gauche" colspan="2">Autres support de publication</td>
	</tr>
	<tr>
		<td>
			<table class="liste" summary="none">
				<tr>
					<th colspan="2">Choix du support de publication</th>
				</tr>
				<tr>
					<td colspan="2">
					<a href="javascript:selectAll('document.formulaires.selection')">Sélectionner tous les supports</a> - 
					<a href="javascript:unselectAll('document.formulaires.selection')">Désélectionner tous les supports</a> - 
					</td>
				</tr>
			</table>
			<div id="division" style="height:80;overflow:auto;width:100%;padding:2x;text-align:left">
					
<%
	int iNbCols = 3;
	// Je rajoute 0.5 à la valeur pour obtenir soit l entier inférieur si la décimale est < 5
	// soit l entier supérieur si la décimale est supérieure à 5
	// et je mets tout ça dans un objet Double
	Double dNbElts = new Double((vPublications.size()/iNbCols) + 0.5 );
	// Enfin je récupère la valeur entière avec intValue() 
	int iNbElts = dNbElts.intValue();
	if (iNbElts==0) iNbElts=1;
	for (int i = 0; i < vPublications.size(); i++)
	{
		Organisation oPublication = (Organisation ) vPublications.get(i);
		
		if(i==0)
		{
%>
			<div class="colonne" style="width:<%=Math.round(100/iNbCols)%>%">
<%
		}
		else if((i % iNbElts) == 0)
		{
%>
			</div>
			<div class="colonne" style="width:<%=Math.round(100/iNbCols)%>%">
<%
		}
%>
		
			<input type="checkbox" name="selection" value="<%= oPublication.getIdOrganisation() %>"/>
			&nbsp;<%= oPublication.getRaisonSociale() %>
			<br /><br />
<%
	}
%>			</div>	
			</div>
		</td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
</table>
<br />
<%@ include file="/include/paveMailer.jspf" %>
<br />
<div style="text-align:center">
		<button type="submit"  name="store_btn" id="store_btn"  >Envoyer le mail</button>
</div>
</form>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>
