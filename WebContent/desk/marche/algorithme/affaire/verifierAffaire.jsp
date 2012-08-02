<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="modula.fqr.*,java.sql.*,org.coin.fr.bean.*,modula.candidature.*,org.coin.util.*" %>
<%@ page import="java.util.*,modula.algorithme.*, modula.*, modula.marche.*,org.coin.fr.bean.export.*" %>
<%@ page import="modula.marche.cpv.*,modula.commission.*, org.coin.util.treeview.*,java.text.*, modula.graphic.*" %>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);
	
	String sHeadTitre = ""; 
	boolean bAfficherPoursuivreProcedure = false;
	boolean bIsAffaireAATR= marche.isAffaireAATR(false);
	
	String sTitle = "Vérification des informations de l'"+(bIsAffaireAATR?"AATR":"AAPC")+ " avant sa validation";
	
	String sUrlFormulaire = HttpUtil.parseString("sUrlFormulaire", request, "");
	String sUrlTraitement = HttpUtil.parseString("sUrlTraitement", request, "");
	int iIdNextPhaseEtapes = HttpUtil.parseInt("iIdNextPhaseEtapes", request, -1) ;
	
	String sRedirectPageAfterVerif 
		= response.encodeRedirectURL(rootPath+sUrlFormulaire+"?iIdAffaire=" 
		+ iIdAffaire + "&sUrlTraitement=" + sUrlTraitement + "&iIdNextPhaseEtapes=" 
		+ iIdNextPhaseEtapes);
	
	String sValide = "<img src=\""+rootPath+Icone.ICONE_SUCCES+"\" alt=\"Valide\" style=\"vertical-align:middle;width:16px\" />";
	String sInvalide = "<img src=\""+rootPath+Icone.ICONE_ERROR+"\" alt=\"Invalide\" style=\"vertical-align:middle;width:16px\" />";
	String sAttention = "<img src=\""+rootPath+Icone.ICONE_WARNING+"\" alt=\"Attention!\" style=\"vertical-align:middle;width:21px\" />";
	String sBtPoursuivre 
		= "<button type=\"button\" onclick=\"javascript:Redirect('"
		+sRedirectPageAfterVerif
		+"') \" >Poursuivre la procédure</button>";
	boolean bError = false;
	
%>
</head>
<body>
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<br/>
<div style="padding:15px">
<%@ include file="../../../../include/new_style/headerAffaireOnlyButtonDisplayAffaire.jspf" %><br />
<table class="pave" summary="Liste des champs obligatoires">
	<tr>
		<td colspan="2" class="pave_titre_gauche">
		<%= sTitle%>
		</td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
<% 
	Vector<Vector<Object>> vRequiredFields = null;
	try
	{
		if(bIsAffaireAATR)
		{
			AvisAttribution avis = AvisAttribution.getAvisAttributionFromMarche(iIdAffaire);
			vRequiredFields = AvisAttribution.getAllRequiredFields(avis.getIdAvisAttribution());
		}
		else
			vRequiredFields = Marche.getAllRequiredFields(iIdAffaire);
	}
	catch(Exception e){e.printStackTrace();}


	for(int i=0;i<vRequiredFields.size();i++)
	{
		Vector<Object> vField = vRequiredFields.get(i);
%>
		<tr>
			<td class="pave_cellule_gauche">
				<%= vField.get(0) %> : 
			</td>
			<td class="pave_cellule_droite">
			<%=((Boolean)vField.get(1)?sValide:sInvalide) %>
			</td>
		</tr>
<%
		if(!(Boolean)vField.get(1))
			bError = true;
	}
	
	if(marche.isAffaireAAPC(false) && !marche.isAAPCAutomatique(false))
	{
		// on a un AAPC libre, il faut obligatoirement une PJ.
		boolean bPJAAPCAttachee = false;
		String sNomAAPCLibre = marche.getNomAAPC();
		if (sNomAAPCLibre != null && !sNomAAPCLibre.equals("") )
		{
			bPJAAPCAttachee = true;
		}
		else
		{
			bError = true;
		}
%>
		<tr>
			<td class="pave_cellule_gauche">
				AAPC Libre, pièce jointe attachée : 
			</td>
			<td class="pave_cellule_droite">
			<%= bPJAAPCAttachee?sValide:sInvalide %>
			</td>
		</tr>
<% 		
	}	
%>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="2" style="text-align:center">
<%= (bError?sAttention + "Votre affaire ne peux pas passer à l'étape de validation. Veuiller préciser les champs obligatoires.":
	"Tous les champs obligatoires ont été remplis, vous pouvez passer à l'étape de validation du marché.<br /><br />")
%>		
		</td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
</table>
<br />
<% 
if(!bIsAffaireAATR) {
	String sDateEnvoiBoamp = ""+marche.getDateEnvoiBOAMP();
	String sBonCommande = marche.getNumCommandeBOAMP();
	String sDepartementDePublication = marche.getDepPublicationBOAMP();
%>
<!--
<table class="pave" >
	<tr>
		<td colspan="2" class="pave_titre_gauche">
		Champs spécifiques à la publication au B.O.A.M.P 
		</td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">
			Date d'envoi au B.O.A.M.P : 
		</td>
		<td class="pave_cellule_droite">
		<%=(!sDateEnvoiBoamp.equals("null")?sValide:sInvalide) %>
		</td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">
			N° de bon de commande d'insertion au B.O.A.M.P : 
		</td>
		<td class="pave_cellule_droite">
			<%=(!sBonCommande.equals("")?sValide:sInvalide) %>
		</td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">
			Département de publication : 
		</td>
		<td class="pave_cellule_droite">
		<%=(!sDepartementDePublication.equals("")?sValide:sInvalide) %>
		</td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
</table>
-->
<br />
<%
}
if(sessionUserHabilitation.isSuperUser())
{
	Etape etape = null;
	try {
		etape = Etape.getEtape(Integer.parseInt(request.getParameter("iIdEtape")));
	} catch (Exception e ) {
		etape = new Etape();
	}
%>
<table class="pave" >
	<tr>
		<td colspan="2" class="pave_titre_gauche">
		Etape courante (Super admin)
		</td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">
			Id : 
		</td>
		<td class="pave_cellule_droite">
		<%= etape.getId() %>
		</td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">
			Use case : 
		</td>
		<td class="pave_cellule_droite">
		<%= etape.getIdUseCase() %>
		</td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">
			Libellé : 
		</td>
		<td class="pave_cellule_droite">
		<%= etape.getLibelle() %>
		</td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">
			URL du formulaire : 
		</td>
		<td class="pave_cellule_droite">
		<%= etape.getUrlFormulaire() %>
		</td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">
			URL du traitement : 
		</td>
		<td class="pave_cellule_droite">
		<%= etape.getUrlTraitement() %>
		</td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
</table>
<%	

}
%>
<br/>
<div style="text-align:center"><%=(!bError?sBtPoursuivre:"") %></div>
</div>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>
</html>