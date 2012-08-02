<%@ include file="/include/new_style/headerPublisher.jspf" %>
<%@ page import="org.coin.db.ConnectionManager"%>
<%@page import="mt.modula.html.HtmlSearchEngine"%>
<%@page import="org.coin.db.CoinDatabaseAbstractBean"%>
<%
    boolean bLaunchSearch = HttpUtil.parseBoolean("bLaunchSearch", request,false);
    boolean bSearchEngineHabilitation = Configuration.isEnabledMemory("publisher.portail.annonce.searchengine.habilitation",false); 
    boolean bDisplaySearchEngine = HttpUtil.parseBoolean("bDisplaySearchEngine", request ,true);
    boolean bDisplayMapAnnounce = HttpUtil.parseBooleanCheckbox("se_bDisplayMapAnnounce", request , false);
   
%>
<%@ include file="/publisher_traitement/public/include/beanCandidat.jspf"%>  
<%@ include file="/publisher_traitement/public/annonce/pave/paveSearchEngineAnnonces.jspf"%>  
<%
    Connection connGlobal = ConnectionManager.getDataSource().getConnection();
/**
    if(bSearchEngineHabilitation && !sessionUser.isLogged) {
		response.sendRedirect( rootPath + "publisher_portail/logout.jsp");
	}
*/
	 
	String sTitle = HtmlSearchEngine.getHtmlAffaireTitle(sType_avis, "Les marchés groupés");
	String sFormPrefix = "";
	boolean bShowButtonAnnonceDetail = true;
    boolean bShowButtonToDownloadFile = false;
    boolean bShowAvisRectificatifDetail = false;
    boolean bShowButtonStatut = true;
    
%>
<script type="text/javascript" src="<%= rootPath %>include/produitCartesien.js"></script>
<script type="text/javascript">
<!--

Event.observe(window, 'load', function(event) {
    initPage();
});


/*
document.observe("dom:loaded", function() {
	initPage();
});
*/

//onPageLoad = function() {}

function initPage()
{
    try{ showLoginBox(); } catch (e) {}


    
    try{ // Javascript

<%
    for(MarchePersonneItem marchePersonneItem : vMarchePersonneItem)
    {
    	boolean bAddMarchePersonneItem = false;
        for (int i = 0; i < vRecherche.size(); i++)  
        {
            Marche marche = (Marche)vRecherche.get(i);
            if(marche.getId() == marchePersonneItem.getIdMarche())
            {
            	bAddMarchePersonneItem = true;
            	break;
            }
        }
        
        if(!bAddMarchePersonneItem) continue;
%>
		try{ // Javascript
<%
		String sMarchePersonneItemElementToShow = "";

		switch((int)marchePersonneItem.getIdMarchePersonneItemType())
		{
		case MarchePersonneItemType.TYPE_INTERESTING : 
		    sMarchePersonneItemElementToShow
			    = "imgSelectIdMarcheInteresting_" + marchePersonneItem.getIdMarche();
		    break;
		case MarchePersonneItemType.TYPE_NOT_INTERESTING : 
		    sMarchePersonneItemElementToShow 
			    = "imgSelectIdMarcheNotInteresting_" + marchePersonneItem.getIdMarche();
		    break;
		case MarchePersonneItemType.TYPE_READED : 
		    sMarchePersonneItemElementToShow 
			    = "imgSelectIdMarcheReaded_" + marchePersonneItem.getIdMarche();
			break;
		}
%>
			Element.show('<%= sMarchePersonneItemElementToShow %>');
			selectAnnonce('<%= marchePersonneItem.getIdMarche() %>');
		} catch (e) {
			alert(e);
	    }
<%
    } 
%>
    } catch (e) {} // Javascript


    /**
     * try to do something ... but it a fucking pb ..
     */
     /*
    try{ 
        var parentMainFrame = parent.$("main");
        parentMainFrame.style.height = "500px"  ;
    } catch (e) { alert(e); }
    */
}

//-->
</script>
<%@ include file="/publisher_traitement/public/include/redirectOnLoad.jspf" %>
</head>


<body>

<%@ include file="/publisher_traitement/public/include/header.jspf" %>
<%@ include file="/publisher_traitement/public/annonce/pave/paveSearchEngineAndAnnonces.jspf" %>
<%@ include file="/publisher_traitement/public/include/footer.jspf"%>
</body>
</html>
<% 

	ConnectionManager.closeConnection(connGlobal);
%>