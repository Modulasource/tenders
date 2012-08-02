<%
boolean bSearchEngineHabilitation = Configuration.isEnabledMemory("publisher.portail.annonce.searchengine.habilitation",false);
boolean bPublicDisplay = false;
Marche marche = null;

try{
	marche = Marche.getMarche(Integer.parseInt(
            SecureString.getSessionPlainString(
            		request.getParameter("a"),session)));
} catch (Exception e) {
	Vector<Marche> vMarcheCheck = new Vector();
	try{vMarcheCheck = Marche.getAllMarcheFromDepartmentAndCompetence("",
			0,
			"AND ( (statut.aatr=1 AND statut.aatr_en_ligne=1) "
			+"OR ((statut.aapc=1 AND statut.aapc_en_ligne=1)) ) "
			+"AND (TO_DAYS(NOW())-TO_DAYS(marche.date_creation))>70 "
			+"AND marche.id_marche="+HttpUtil.parseInt("lId", request)+" ");
	}catch(Exception e1){}
	if (vMarcheCheck.size()>0){
		marche = vMarcheCheck.firstElement();
	}
	bPublicDisplay = true;
}
if (marche==null){
	response.encodeRedirectURL(Configuration.getConfigurationValueMemory("publisher.url"));
	return;
}
String sTitle = "Annonce référence : " + marche.getReference() ;
session.setAttribute("sMetaDataTitle", sTitle);
session.setAttribute("sMetaDataDescription", Outils.stripMultiSpaces(Outils.truncatePerWords(Outils.stripNl(marche.getObjet(), " "), 150)));
%>
<%@ include file="/include/new_style/headerPublisher.jspf" %>
<%
//if(bSearchEngineHabilitation && !sessionUser.isLogged && !marche.isDCEDisponible(false)){
if (bSearchEngineHabilitation && !sessionUser.isLogged 
			&& (marche.getIdAlgoAffaireProcedure() == AffaireProcedure.AFFAIRE_PROCEDURE_PETITE_ANNONCE)
			&& !marche.isDCEDisponible()		
	){
	/* CF #3408	
	Annonce publiée sans DCE et annonce saisie service veille sans DCE : on n'affiche pas si habilitation enabled
	*/
	return;
}
%>
<%@ page import="modula.graphic.*,modula.*,org.coin.util.*,modula.marche.*,java.util.*,modula.candidature.*,org.coin.fr.bean.*,modula.commission.*,modula.algorithme.*,java.sql.*" %> 
<%@page import="org.coin.db.CoinDatabaseWhereClause"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@ include file="/publisher_traitement/public/include/beanCandidat.jspf" %>
<%


	
	CoinDatabaseWhereClause wcAllIdMarche = new CoinDatabaseWhereClause(CoinDatabaseWhereClause.ITEM_TYPE_INTEGER);
	CoinDatabaseWhereClause wcAllIdCommission = new CoinDatabaseWhereClause(CoinDatabaseWhereClause.ITEM_TYPE_INTEGER);
	CoinDatabaseWhereClause wcAllIdPersonnePhysique = new CoinDatabaseWhereClause(CoinDatabaseWhereClause.ITEM_TYPE_INTEGER);
	  
	wcAllIdCommission.add(marche.getIdCommission());
	wcAllIdMarche.add(marche.getId());
	wcAllIdPersonnePhysique.add(marche.getIdCreateur());
	  
	Connection connSearchEngineTotal = ConnectionManager.getConnection();
	  
	%><%@include file="/publisher_traitement/public/annonce/pave/paveBatchAllItemAnnonce.jspf"%><%
	ConnectionManager.closeConnection(connSearchEngineTotal);
	    
    String sType_avis= "tout";
    String sType_annonce ="";
    int numAnnonce = 1;
    boolean bShowButtonAnnonceDetail = false;
    boolean bShowButtonToDownloadFile = true;
    boolean bShowAvisRectificatifDetail = true;
    boolean bShowButtonStatut = true;

    HtmlAnnonce htmlAnnonce = new HtmlAnnonce();
    htmlAnnonce.sJavascriptFunctionRedirect = "closeModalAnnonceAndRedirect"; 

%>
<script type="text/javascript" src="<%= rootPath %>include/cacherDivision.js" ></script>
<script type="text/javascript">
<!--
    bOnLoadAutoScrollOnTheTop = false;
    
function closeModalAnnonceAndRedirect(url){
   
    try {
        top.frames["main"].location.href=url;
    } catch (e) {
        window.location.href = url ;
    }
    
    setTimeout(function(){
        try {new parent.Control.Modal.close();}
        catch(e) { Control.Modal.close();}
    }, 1000);  
}



//-->
</script>
</head>
<body style="background-color:#FFF">
<% if (!bPublicDisplay){ %>
<div align="center">
<a href="javascript:window.print();" ><img src="<%= rootPath + "images/icons/printer.gif" 
	%>" alt="Imprimer"/> Imprimer l'annonce</a>
</div>
<% }else{ 
	String sURLImage = Configuration.getConfigurationValueMemory("welcome.image.path");
	String sTitleImage = Configuration.getConfigurationValueMemory("publisher.portail.title");
	String sURLPublisher = Configuration.getConfigurationValueMemory("publisher.url");
	String sPublicText = Configuration.getConfigurationValueMemory("publisher.annonce.public.text", "");
	if (!sPublicText.equals("")){
		sPublicText = "<strong>"+sPublicText+"</strong><br />";
	}
%>
<div style="text-align: center;margin:5px;">
	<a href="<%= sURLPublisher %>">
		<img src="<%= sURLImage %>" alt="<%= sTitleImage %>" title="<%= sTitleImage %>" /><br />
		<%= sPublicText %>
		<%= sURLPublisher %>
	</a>
</div>
<% } %>

     
<%@ include file="/publisher_traitement/public/annonce/pave/paveDisplayAnnonce.jspf" %>


<%
if(!Outils.isNullOrBlank( marche.getDesignationReduite() )
|| ("libre".equals(marche.getPetiteAnnonceFormat()) 
	&& !Outils.isNullOrBlank(marche.getPetiteAnnonceTexteLibre()))  )
{
%>
<div class="post">
    <div class="post-title">
        <table class="fullWidth" cellpadding="0" cellspacing="0">
        <tr>
            <td>
                <strong style="color:#36C">Compléments</strong>
            </td>
            <td class="right">
            </td>
        </tr>
        </table>
    </div>
    <table class="fullWidth" cellpadding="0" cellspacing="0">
        <tr>
            <td class="top">
<%
    if(!Outils.isNullOrBlank( marche.getDesignationReduite()))
    {
    	String sDesignationReduite = marche.getDesignationReduite(); 
        sDesignationReduite = Outils.linkify( sDesignationReduite, " target='_blank'") ;
        sDesignationReduite = Outils.replaceNltoBr( sDesignationReduite )+"<br /><br />" ;
    	
%>
                <div class="post-header post-block" style="text-align:left;padding:5px">          
			<%= 
				sDesignationReduite
			%>
			   </div>
<%
    }

	String sPetiteAnnonceFormat = marche.getPetiteAnnonceFormat();
	if(sPetiteAnnonceFormat.equals("libre"))
	{
%>
               <div class="post-header post-block" style="text-align:left;padding:5px">          
<%
			String sDesc = "";
			try {
				sDesc = Outils.replaceAll(marche.getPetiteAnnonceTexteLibre(),"\n","<br/>");
				sDesc = Outils.replaceAll(sDesc,"¤","&euro;");
				sDesc = Outils.replaceAll(sDesc,"?","&#63;");
				sDesc = Outils.linkify( sDesc, " target='_blank'") ;
                

			} catch (Exception e) {}
%>
			<%= sDesc.replaceAll("\n", "<br/>") %>
			     </div>
<%
	}
%>
          </td>
        </tr>
    </table>
</div>
<%
}
%>

<% if(bPublicDisplay){ %>
<div class="post" style="width:600px;margin-left:auto;margin-right:auto;font-weight: normal;padding:5px;">
	<p style="font-weight: normal;">
		<span style="font-weight: bold;">Tous</span> les appels d'offres de votre activité, 
		<span style="font-weight: bold;">tous</span> les jours sur votre boite mail, grâce
  		à notre service de veille des appels d'offres <u>MARCHES FAX/MARCHES NET.</u>
  </p>
  <p style="font-weight: normal;">Choisissez une veille qui vous correspond : ciblée, pertinente, exhaustive (par l'analyse 
  quotidienne des journaux habilités et d'une centaine de sites internet en Rhône et PACA).</p>
  
  <p style="font-weight: normal;">Bénéficiez d'un <span style="font-weight: bold;color: #2972BB;">essai gratuit</span>
  de notre <strong>service de veille</strong> : 3 mois sans engagement pour <strong>évaluer</strong> 
  le potentiel des marchés publics, <strong>consultez</strong> les marchés publics sur notre site,
  recevoir des <strong>alertes mails</strong> sur mesure et quotidienne.</p>
</div>
<% } %>
</body>

</html>