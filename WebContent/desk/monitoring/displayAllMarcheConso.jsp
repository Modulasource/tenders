<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@page import="modula.marche.Marche"%>
<%@page import="mt.modula.affaire.report.AffaireReport"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="modula.algorithme.AffaireProcedureType"%>
<%@page import="modula.marche.MarchePassation"%>
<%@page import="org.coin.db.CoinDatabaseAbstractBean"%>
<%@page import="org.coin.util.CalendarUtil"%>
<%@page import="org.coin.db.CoinDatabaseLoadException"%>
<%@page import="org.coin.util.BasicDom"%>
<%@page import="org.w3c.dom.Node"%>
<%@page import="org.w3c.dom.Document"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="java.sql.Connection"%>
<%

	String sAction = HttpUtil.parseStringBlank("sAction", request);
	String sWhereClause = "";
	
    String sTitle = "Consommation";
	
	/*
o Filtre par date de validation
o Recherche par Acheteur Public
o Recherche par type de procédure
o Par activités
o Par Mots clés
*/
	Connection conn = ConnectionManager.getConnection();
	Connection connStreaming = ConnectionManager.getConnection();

 	AffaireReport affaireReport = new AffaireReport();
	affaireReport.sFilterRaisonSociale = HttpUtil.parseStringBlank("sFilterRaisonSociale", request);
    affaireReport.lFilterIdAffaireProcedureType = HttpUtil.parseLong("lFilterIdAffaireProcedureType", request, 0);
    affaireReport.lFilterIdMarchePassation = HttpUtil.parseLong("lFilterIdMarchePassation", request, 0);
    affaireReport.tsFilterDateValidationAfter = HttpUtil.parseTimestamp("tsFilterDateValidationAfter", request, null);
    affaireReport.tsFilterDateValidationBefore = HttpUtil.parseTimestamp("tsFilterDateValidationBefore", request, null);
    affaireReport.tsFilterDateCreationAfter = HttpUtil.parseTimestamp("tsFilterDateCreationAfter", request, null);
    affaireReport.tsFilterDateCreationBefore = HttpUtil.parseTimestamp("tsFilterDateCreationBefore", request, null);
    affaireReport.bSelectOnlyNotExported = HttpUtil.parseBooleanCheckbox("bSelectOnlyNotExported", request, false);
    affaireReport.lIdMarcheVolumeType = HttpUtil.parseLong("lIdMarcheVolumeType", request, 0);
    
    
    AffaireProcedureType apt = null;
    try{
    	apt = AffaireProcedureType.getAffaireProcedureType((int) affaireReport.lFilterIdAffaireProcedureType);
    } catch (CoinDatabaseLoadException e ) {
    	apt = new AffaireProcedureType();
    }
    
    
    MarchePassation mp = null;
    try{
    	mp = MarchePassation.getMarchePassation((int) affaireReport.lFilterIdMarchePassation);
    } catch (CoinDatabaseLoadException e ) {
    	mp = new MarchePassation();
    }
    
    /**
     * MarcheVolumeType
     */ 
    MarcheVolumeType marcheVolumeType = null;
    long lIdMarcheVolumeType = HttpUtil.parseLong("lIdMarcheVolumeType", request, 0);

    try{
        marcheVolumeType = MarcheVolumeType.getMarcheVolumeTypeMemory(lIdMarcheVolumeType);
    } catch (CoinDatabaseLoadException e){
        marcheVolumeType = new MarcheVolumeType();
    }

    
    
    if(sAction.equals("removeExcelExportFlag")){
    	String [] s = request.getParameterValues("affaire_id_selected");
    	if(s != null){
	    	for(String sId : s)
	    	{
	    		AffaireReport.removeMarcheParamExport(Long.parseLong(sId), conn);
	    	}
    	}
    }
    
%>
<style type="text/css">
.tableListConso{
    border: 1px solid #CCCCCC;
    width: 100%;
}

.trListConsoHeader{
    font-weight:bold;
    background-color: #CCCCCC;
}

.trListConsoNormal{
    background-color: #FFFFFF;
}


.trListConsoExcelExported{
   /* background-color: #FFAAAA;*/
   background-color: #D5EEFC;
}

  
</style>

<script type="text/javascript">

var g_timeOutGeneration = null;

function generateExcel()
{
    $("formFilter").action="<%= response.encodeURL(
    	  rootPath + "desk/GenerateAllMarcheProcedureExcelServlet")  %>";
    $("formFilter").target="_blank";
    $("formFilter").submit();

    g_timeOutGeneration = window.setTimeout("displayList()", 5000) ;
}

function displayList()
{
    if(g_timeOutGeneration != null)
    {
        window.clearTimeout(g_timeOutGeneration);
        g_timeOutGeneration = null;
    }
    
    $("formFilter").action="<%= response.encodeURL("displayAllMarcheConso.jsp")  %>";
    $("formFilter").target="";
    $("sAction").value = "doFilter";
    $("formFilter").submit();
}

function removeExcelExportFlag()
{
	
    $("formFilter").action="<%= response.encodeURL("displayAllMarcheConso.jsp")  %>";
    $("formFilter").target="";
    $("sAction").value = "removeExcelExportFlag";
    $("formFilter").submit();
}


function updateSelectedListAffaire(mainItem)
{
	var mainItemChecked = mainItem.checked; 
	var list = document.getElementsByName("affaire_id_selected");

	for(var i=0; i < list.length ; i++)
	{
		var item = list[i];
        item.checked = mainItemChecked;
	}
} 

function displayAffaire(lIdAffaire,mode)
{
	var url = "";
	var urlAffaire = "<%= response.encodeURL(rootPath + "desk/marche/algorithme/affaire/afficherAffaire.jsp"
	+ "?iIdAffaire=") %>" + lIdAffaire;
	var urlAttrib = "<%= response.encodeURL(rootPath + "desk/marche/algorithme/affaire/afficherAttribution.jsp"
	+ "?iIdAffaire=") %>" + lIdAffaire;

	if(mode == "aapc")
	{
		url = urlAffaire;
	}
	if(mode == "aatr")
	{
		url = urlAttrib;
	}

	parent.addParentTabForced("Chargement ...",url, false, "affaire_" + lIdAffaire, "affaire_" + lIdAffaire);
}


</script>
<link rel="stylesheet" type="text/css" href="<%=rootPath %>include/component/calendar/calendar.css" media="screen" />
<script type="text/javascript" src="<%=rootPath %>include/component/calendar/calendar.js"></script>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<div style="padding:15px">
<form id="formFilter" action="<%= response.encodeURL("displayAllMarcheConso.jsp") %>" >
<input name="sAction" id="sAction" value="doFilter" type="hidden" />

<table class="pave" >
        <tr>
            <td class="pave_titre_gauche" colspan="2">
                Filtres
            </td>
        </tr>
        <tr>
            <td colspan="2">&nbsp;</td>
        </tr>
        <tr>
            <td class="pave_cellule_gauche" >
                Raison Sociale :
            </td>
            <td class="pave_cellule_droite" >
                <input name="sFilterRaisonSociale" value="<%= affaireReport.sFilterRaisonSociale  %>" />
            </td>
        </tr>
        <tr>
            <td class="pave_cellule_gauche" >
                Niveau de traitement :
            </td>
            <td class="pave_cellule_droite" >
                <%= mp.getAllInHtmlSelect("lFilterIdMarchePassation", true, true) %>
            </td>
        </tr>
        <tr>
            <td class="pave_cellule_gauche" >
                Type de publication :
            </td>
            <td class="pave_cellule_droite" >
               <%= apt.getAllInHtmlSelect("lFilterIdAffaireProcedureType", true, true) %>
            </td>
        </tr>
        <tr>
            <td class="pave_cellule_gauche" >
                Date de publication :
            </td>
            <td class="pave_cellule_droite" >
               de <input name="tsFilterDateValidationAfter" value="<%= 
				    CalendarUtil.getDateCourte(affaireReport.tsFilterDateValidationAfter) %>" class="dataType-date" />
				à <input name="tsFilterDateValidationBefore" value="<%= 
				    CalendarUtil.getDateCourte(affaireReport.tsFilterDateValidationBefore) %>" class="dataType-date" /><br/>
    
            </td>
        </tr>        
        <tr>
            <td class="pave_cellule_gauche" >
                Date de création :
            </td>
            <td class="pave_cellule_droite" >
			    de <input name="tsFilterDateCreationAfter" value="<%= 
			    CalendarUtil.getDateCourte(affaireReport.tsFilterDateCreationAfter) %>" class="dataType-date" />
			    à <input name="tsFilterDateCreationBefore" value="<%= 
			    CalendarUtil.getDateCourte(affaireReport.tsFilterDateCreationBefore) %>" class="dataType-date" /><br/>
    
            </td>
        </tr>   
        <tr>
            <td class="pave_cellule_gauche" >
                Sélectionner que les non-exportés :
            </td>
            <td class="pave_cellule_droite" >
                <input type="checkbox" name="bSelectOnlyNotExported" <%=
                	affaireReport.bSelectOnlyNotExported?" checked='checked' ":"" %>/>
    
            </td>
        </tr>   
        <tr>
            <td class="pave_cellule_gauche" >
                Volume du marché (montant estimé) :
            </td>
            <td class="pave_cellule_droite" >
                    <%= marcheVolumeType.getAllInHtmlSelect("lIdMarcheVolumeType",true) %>

            </td>
        </tr>   
</table>

<div  style="text-align: center;">
<button type="button" onclick="displayList()">Afficher</button>
<button type="button" onclick="generateExcel()" >Générer fichier Excel</button>
<button type="button" onclick="removeExcelExportFlag()" >Supprimer statut exporté</button>
</div>
<br/>
<%
	if(sAction.equals("doFilter")
	|| sAction.equals("removeExcelExportFlag") )
	{
        
	    String sXml = affaireReport.getAllSuiviConsoForExportXML(sWhereClause, conn, connStreaming);
        
        sXml = "<?xml version=\"1.0\" encoding=\""
            //+ "UTF-8"
            + "ISO-8859-1"
            + "\"?>\n"
            + "<!DOCTYPE affaires [\n"
            + "<!ENTITY euro '&amp;euro;' >\n"
            + "]>\n"
			
            + "<affaires>\n"
            + sXml
            + "</affaires>\n";
        Document doc = null;
        String sErrorMessage = "";
        try{
        	doc = BasicDom.parseXmlStream(sXml, false);
        } catch (Exception e){
        	e.printStackTrace();
        	sErrorMessage = e.getMessage();
        }

        String sHTML = "";
        
        if(doc != null) {
	        sHTML += "<table class='tableListConso' >\n";
	        sHTML += "<tr class='trListConsoHeader' >\n";
	        sHTML += "<td>Nom de l'acheteur public</td>\n";
	        sHTML += "<td>Référence du marché</td>\n";
	        sHTML += "<td>Objet</td>\n";
	        sHTML += "<td>Date de validation de l'AAPC</td>\n";
	        sHTML += "<td>Date de publication sur le site</td>\n";
	        sHTML += "<td>Type de procédure</td>\n";
	        sHTML += "<td>Niveau de traitement</td>\n";
	        sHTML += "<td>Publications</td>\n";
	        sHTML += "<td>Montant</td>\n";
	        sHTML += "<td>Volume</td>\n";
	        sHTML += "<td>Date de création</td>\n";
	        sHTML += "<td style='text-align:center'><input type='checkbox' onclick='updateSelectedListAffaire(this)' /></td>\n";
	        sHTML += "</tr>\n";
	
	        Node node = BasicDom.getFirstChildElementNode(doc);
	        for(
	        node = BasicDom.getFirstChildElementNode(node);     
	        node != null;
	        node = BasicDom.getNextSiblingElementNode(node)     
	        )
	        {
	        	long lIdAffaire = Long.parseLong(BasicDom.getChildNodeValueByNodeNameOptional(node, "idAffaire") );
	        	
	            String sTrClassName = "trListConsoNormal";
	            String sIsExcelExported = BasicDom.getChildNodeValueByNodeNameOptional(node, "isExcelExported");
	            if(sIsExcelExported.equals("true")){
	                sTrClassName = "trListConsoExcelExported";
	            }
	            
	            String sPublications = BasicDom.getChildNodeValueByNodeNameOptional(node, "publications") ;
	            if(sPublications == null) sPublications = "";
	            
	            sHTML += "<tr class='" + sTrClassName + "' >\n";
	            
	            String sMode = BasicDom.getChildNodeValueByNodeNameOptional(node, "mode");
	            
	            sHTML += "<td>" + BasicDom.getChildNodeValueByNodeNameOptional(node, "raisonSociale") + "</td>\n";
	            sHTML += "<td><a href='void(0)' onclick='displayAffaire("
	            		+ lIdAffaire + ",\""+sMode+"\");' >" + BasicDom.getChildNodeValueByNodeNameOptional(node, "reference") + "</a></td>\n";
	           	sHTML += "<td>" + BasicDom.getChildNodeValueTextByNodeName(node, "objet") + "</td>\n";
	            sHTML += "<td>" + BasicDom.getChildNodeValueByNodeNameOptional(node, "dateValidation") + "</td>\n";
	            sHTML += "<td>" + BasicDom.getChildNodeValueByNodeNameOptional(node, "datePublication") + "</td>\n";
	            sHTML += "<td>" + BasicDom.getChildNodeValueByNodeNameOptional(node, "typeProcedure") + "</td>\n";
	            sHTML += "<td>" + BasicDom.getChildNodeValueByNodeNameOptional(node, "niveauTraitement") + "</td>\n";
	            sHTML += "<td>" + sPublications + "</td>\n";
	            sHTML += "<td>" + BasicDom.getChildNodeValueByNodeNameOptional(node, "amount") + "</td>\n";
	            sHTML += "<td>" + BasicDom.getChildNodeValueByNodeNameOptional(node, "volume") + "</td>\n";
	            sHTML += "<td>" + BasicDom.getChildNodeValueByNodeNameOptional(node, "dateCreation") + "</td>\n";
	            sHTML += "<td style='text-align:center' >&nbsp;<input type='checkbox' "
	                + " name='affaire_id_selected' value='" +  lIdAffaire + "' />&nbsp;</td>\n";
	            sHTML += "</tr>\n";
	        }
	        
	        
	        sHTML += "</table>\n";
	        
        } else {
	        sHTML += "<div>Error : \n"
	        + sErrorMessage + "</div>\n"
	        + "<div>xml : <br/>" 
	        + Outils.getTextToHtml(sXml)
	        + "</div>"
	        ;
        	
        }

%><%=sHTML %><%
	}


	ConnectionManager.closeConnection(conn);
	ConnectionManager.closeConnection(connStreaming);
%>

</form>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>


<%@page import="mt.modula.affaire.param.MarcheVolume"%>
<%@page import="mt.modula.affaire.param.MarcheVolumeType"%>
<%@page import="org.coin.util.Outils"%></html>