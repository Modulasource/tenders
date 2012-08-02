
<%@ page import="modula.graphic.*,java.sql.*,org.coin.fr.bean.*,org.coin.fr.bean.export.*,org.coin.util.*,java.util.*,modula.algorithme.*, modula.*, modula.marche.*,modula.commission.*, modula.marche.cpv.*,modula.commission.*, org.coin.util.treeview.*,java.text.*,org.coin.bean.*" %>
<%@ include file="/include/beanSessionUser.jspf" %>
<%@ include file="/desk/include/useBoamp17.jspf" %>
<%
	Marche marche = Marche.getMarche(Integer.parseInt( request.getParameter("iIdAffaire") ));
	String rootPath = request.getContextPath()+"/";
	Vector<Export> vExportsAFF = Export.getAllExportFromSource(marche.getIdMarche(),ObjectType.AFFAIRE);
	Vector<Organisation> vOrganisationsPublication = Organisation.getAllOrganisationPublication();
	
	boolean bAddHiddenFieldBoamp = false;
	String sUrlTraitement = HttpUtil.parseStringBlank("sUrlTraitement", request) ;
	int iIdNextPhaseEtapes = HttpUtil.parseInt("iIdNextPhaseEtapes", request, -1);
	String sIsProcedureLineaire = HttpUtil.parseStringBlank("sIsProcedureLineaire", request) ;
	int iIdAvisRectificatif = HttpUtil.parseInt("iIdAvisRectificatif", request, -1);
	
	int iIsPubliePapier = 0;
	try{	
		iIsPubliePapier = marche.isPubliePapier()?1:2;
	}catch(Exception e){}
	
	String sChecked = "checked=\"checked\"";
	boolean bBOAMPReadyToSend = false;
	String sBoampDisableCheckbox = "";

	String sBOAMPSelected  ="";
	for(int j=0;j<vExportsAFF.size();j++){
		Export exportAFF = vExportsAFF.get(j); 
		if(exportAFF.getIdObjetReferenceDestination() == PublicationBoamp.getIdOrganisationBoampOptional())
		{
			Vector<Publication> vPublications 
				= Publication.getAllPublicationFromMarcheAndExport(marche.getIdMarche(),exportAFF.getIdExport());
			
			if (vPublications.size()>0) {
				
				// il faut supprimer toutes les publications BOAMP pour supprimer l'export
				sBoampDisableCheckbox = " disabled='disabled' ";
				bAddHiddenFieldBoamp = true;
				
				for(int k=0;k<vPublications.size();k++){
					if ((vPublications.get(k).getIdPublicationEtat() == PublicationEtat.ETAT_A_ENVOYER)
					&&(  vPublications.get(k).getIdPublicationType() != 0)) 
					{
						bBOAMPReadyToSend = true;
					}
				}
				// DK c débile ... si l'export existe on coche la case, on s'en fout qu'il y ait ou non des publications
				sBOAMPSelected="checked=\"checked\"";
			}
			sBOAMPSelected="checked=\"checked\"";
			
		}
	}
%>
<form action="<%=response.encodeURL(rootPath+"desk/marche/algorithme/affaire/modifierSupportsPublications.jsp")
	%>" method="post" name="formulaire" >

<script type="text/javascript" src="<%= rootPath %>include/bascule.js" ></script>

<% 
if(!sIsProcedureLineaire.equalsIgnoreCase("false")) 
{
%>
<table class="pave_commentaire" >
	<tr>
		<td class="pave_cellule_gauche" style="vertical-align:middle">
      		<img src="<%=rootPath %>images/icons/icone_attention.png" alt="" />
		</td>
		<td class="pave_cellule_droite" style="vertical-align:middle">
			 	Pour envoyer vos avis sur les différents supports de publication il faut « Enregistrer la publication » sur chaque onglet. 
				<br />Pour un envoi au BOAMP il faut cliquer sur le bouton « Envoi de l'AAPC ». 
				<br />Pour un envoi au JOUE il faut cliquer sur le bouton « Envoyer le formulaire N du JOUE ». 
				<br />Après avoir enregistré ou validé toutes vos publications, l'onglet « Poursuivre la procédure » apparaitra afin de vous permettre de terminer définitivement l'envoi de vos publications.  
		</td>
	</tr>
</table>
<% 
}
%>
<br />

<table class="pave" >
	<tr><td colspan="2" class="pave_titre_gauche">Gestion des publications Web</td></tr>
	<tr>
		<td class="pave_cellule_gauche" style="vertical-align:middle">
			<input type="checkbox" name="publisher" disabled="disabled" <%=sChecked %> />&nbsp;
		</td>
		<td class="pave_cellule_droite" style="vertical-align:middle">Site Internet des journaux du portail</td>
	</tr>
</table>
<br />
<%
	
/**
 * TODO : test à supprimer par la suite
 */
	String sEnableBoampCheckbox = " disabled='disabled' ";
	if(bUseBoamp17)
	{
		sEnableBoampCheckbox = "";
	}
%>

<table class="pave" >
	<tr><td colspan="2" class="pave_titre_gauche">Gestion des publications Officielles</td></tr>
	<tr>
		<td class="pave_cellule_gauche" style="vertical-align:top">
<% if(bAddHiddenFieldBoamp){%>
			<input type="hidden" name="boamp" value="<%=PublicationBoamp.getIdOrganisationBoampOptional()%>" />
<% } %>		
			<input type="checkbox" name="boamp" <%= sEnableBoampCheckbox + sBoampDisableCheckbox %> <%=sBOAMPSelected %> value="<%=PublicationBoamp.getIdOrganisationBoampOptional()%>" />&nbsp;
		</td>
		<td class="pave_cellule_droite" style="vertical-align:middle">BOAMP et JOUE
			<%=(!sBOAMPSelected.equalsIgnoreCase("")&&!bBOAMPReadyToSend?"<span class=\"mention\">Vous devez maintenant valider la publication associée.</span>":"") %>
<%
	if(!bUseBoamp17)
	{
%>			<br />&nbsp;<br/>
			<div style="font-style:italic;color:red">
			Afin de mieux vous servir et tenir compte du nouveau Code des Marchés Publics, la plateforme Modula est en maintenance évolutive jusqu'à nouvel ordre.
			<br />Pendant cette période, le transfert des annonces au BOAMP est interrompu.
			<br />Vous pouvez publier au BOAMP par l'intermédiaire de leur plateforme de publication : <a href="http://boamp.journal-officiel.gouv.fr" target="_blank">http://boamp.journal-officiel.gouv.fr</a>
			<br />Merci de votre compréhension.
			<br />Pour toute question, vous pouvez nous contacter au 0892 230 241 (0,34 EUR/min).
	        </div>
<% 
	}
%>		</td>
	</tr>
</table>
<br />
<input type="hidden" value="<%=marche.getIdMarche() %>" name="iIdAffaire" />
<input type="hidden" value="<%= sUrlTraitement %>" name="sUrlTraitement" />
<input type="hidden" value="<%= iIdNextPhaseEtapes %>" name="iIdNextPhaseEtapes" />
<input type="hidden" value="<%= sIsProcedureLineaire %>" name="sIsProcedureLineaire" />
<input type="hidden" value="<%= iIdAvisRectificatif %>" name="iIdAvisRectificatif" />



<table class="pave" >
    <tr>
        <td class="pave_titre_gauche" colspan="2">Gestion des publications Papier
            
        </td>
    </tr>
    <tr>
        <td class="pave_cellule_gauche">
            <input type="radio" name="bPublicationPapier" value="2" 
                onclick="cacher('liste_supports_pub');cacher('poursuivreProcedure');" <%=
                    iIsPubliePapier ==2?sChecked:"" %> />&nbsp;
        <td class="pave_cellule_droite" style="vertical-align:middle">
        Je ne souhaite pas publier mon annonce sur un support de publication Papier</td>
    </tr>
    <tr>
        <td class="pave_cellule_gauche">
            <input type="radio" name="bPublicationPapier" value="1" 
                onclick="montrer('liste_supports_pub');cacher('poursuivreProcedure');" <%=
                    iIsPubliePapier ==1?sChecked:"" %>/>&nbsp;
        </td>
        <td class="pave_cellule_droite" style="vertical-align:middle">
        Je souhaite publier mon annonce sur un support de publication Papier</td>
    </tr>
    <tr id="liste_supports_pub" >
        <td colspan="2">
            <table >
                <tr>
                    <td colspan="2">&nbsp;</td>
                </tr>

				<%@ include file="blocGestionPublicationPapier.jspf" %>
				<%
				    if((iNbPublicationsSelected==0)&&(iIsPubliePapier ==1)){
				%>
				                <tr><td colspan="2">&nbsp;</td></tr>
				                <tr><td colspan="2" style="text-align:center" class="rouge">Vous 
				                devez sélectionner les supports Papier sur lesquels vous souhaitez publier.
				                </td></tr>
				<%
				    }
				%>

                <tr><td colspan="2">&nbsp;</td></tr>
            </table>
        </td>
    </tr>
</table>



<br />
<%@include file="paveVeilleDeMarcheForm.jspf" %>
 
<div class="center">
	<button type="submit" >Valider mon choix</button>
</div>
</form>	
