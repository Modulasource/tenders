<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@page import="modula.algorithme.AffaireProcedure"%>
<%@page import="java.util.Vector"%>
<%@page import="modula.marche.Marche"%>
<%
    String sTitle = "Suppresion des petites annonces";
    String sMessInfo = "";
    String sIcone = "";

    String sAnnee = "";
	try {
	    sAnnee = request.getParameter("sAnnee");	
	} catch(Exception e) {}
    
    if(sAnnee != null && !sAnnee.equals("")) {
        int iTypeProcedurePA = AffaireProcedure.AFFAIRE_PROCEDURE_PETITE_ANNONCE;
        String sSqlQuery =  " WHERE id_algo_affaire_procedure = "+iTypeProcedurePA
					        +  " AND id_marche IN("
					        +      " SELECT DISTINCT id_reference_objet FROM validite val"
					        +      " WHERE val.id_type_objet_modula = 1"
					        +      " AND YEAR(val.date_fin) = "+sAnnee+")";
        Vector<Marche> vMarche = Marche.getAllMarcheWithWhereClause(sSqlQuery);
        int iAnnonceDeleted = 0;
        for(Marche marche : vMarche){
            boolean bIsArchive = false;
            try{
                bIsArchive = marche.isAffaireArchivee();
            } catch(Exception e){}
            
            if (bIsArchive) {
            	marche.removeWithObjectAttached();
            	iAnnonceDeleted++;
            }
        }
        if(iAnnonceDeleted == 1) {
            sIcone = "<img alt=\"success\" src=\""+rootPath+Icone.ICONE_SUCCES+"\">&nbsp;";
        	sMessInfo = "Une petite annonce archivée supprimée pour l'année "+sAnnee;
        } else if(iAnnonceDeleted > 1) {
        	sIcone = "<img alt=\"success\" src=\""+rootPath+Icone.ICONE_SUCCES+"\">&nbsp;";
        	sMessInfo = iAnnonceDeleted+" petites annonces archivées supprimées pour l'année "+sAnnee;
        } else {
        	sMessInfo = "Aucune annonce à supprimer pour l'année "+sAnnee;
        }
    }
%>
<script type="text/javascript" >
    function confirmSuppression()
    {
        var sAnnee = document.forms["supprimerPAAnnee"].elements["sAnnee"].value;
        if(sAnnee == "") {
            alert("Veuillez saisir une année pour la suppression");
            return false;
        } 
        if (confirm("Vous allez supprimer définitivement les petites annonces archivées de "+sAnnee+". Etes vous sûr(e)?")) {
            document.formulaire.submit();
        } else return false;
    }
</script>
</head>
<body>
<%@ include file="/include/new_style/headerFichePopUp.jspf" %>
<br/>
<div style="padding:15px">
<form name="supprimerPAAnnee" method="post" action="<%= response.encodeURL("paveSupprimerPAAnneeN.jsp") %>" onsubmit="return confirmSuppression()">
<table class="pave" style="text-align:center" >
    <tr><td>&nbsp;</td></tr>
    <tr>
        <td style="pave;font-weight:bold">
            <%= sIcone + sMessInfo %>
        </td>
    </tr>
    <tr><td>&nbsp;</td></tr>
    <tr>       
        <td style="pave">
            Saisissez l'année dont vous souhaitez supprimer les petites annonces archivées <input name="sAnnee" type="text" maxlength="4" size="4"></input>&nbsp;
        </td>
    </tr>
    <tr><td>&nbsp;</td></tr>
    <tr>
        <td>
            <button type="submit" class="disableOnClick" >Supprimer</button>&nbsp;
            <button type="button" onclick="closeModal()" >Annuler</button>&nbsp;
        </td>
    </tr>
    <tr><td>&nbsp;</td></tr>
</table>
</form>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>

</body>
</html>
