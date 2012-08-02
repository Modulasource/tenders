<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Timestamp"%>
<%@ page import="org.coin.fr.bean.*" %>
<%@page import="org.coin.bean.UserType"%>
<%@page import="org.coin.db.CoinDatabaseLoadException"%>
<%@page import="org.coin.util.*"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="modula.candidature.Enveloppe"%>
<%@page import="org.coin.ui.Border"%>
<%@page import="java.util.Vector"%>
<%

	Connection conn = ConnectionManager.getConnection();	
	PersonnePhysique personneLogueePP = PersonnePhysique
			.getPersonnePhysique(sessionUser.getIdIndividual());
	
	personneLogueePP.setAbstractBeanIdLanguage(sessionLanguage.getId());
	personneLogueePP.bUseLocalization = true;
	
	
	String sPersonnePhysique = personneLogueePP.getCivilitePrenomNom() ;
	
	String sTitle = "* Espace de Démat <span class=\"altColor\"> : "
			+ personneLogueePP.getCivilitePrenomNom()+ "</span> *";
	sTitle = Configuration.getConfigurationValueMemory("design.desk.theme.mainpage.title", sTitle) ;

	try {
		for (int i = 1; i < 10; i++) {

			String sImagePath = Configuration
			.getConfigurationValueMemory("design.desk.left.bottom.image."
			+ i + ".path");
		}
	} catch (Exception e) {
	}
	
	Vector<Configuration> vBlocks = Theme.getAllWelcomeBlocks();
	Vector<Configuration> vNews = Theme.getAllNews();
	Vector<PersonnePhysiqueParametre> vParam 
		= PersonnePhysiqueParametre.getAllFromIdPersonnePhysique(sessionUser.getIdIndividual(),false, conn);
	
%>
<script type="text/javascript" src="<%=rootPath %>dwr/engine.js"></script>
<script type="text/javascript" src="<%=rootPath %>dwr/util.js"></script> 
<script type="text/javascript" src="<%=rootPath %>dwr/interface/PersonnePhysiqueParametre.js?v=<%= PersonnePhysiqueParametre.AJAX_VERSION %>"></script>

<script type="text/javascript">

onPageLoad = function() {
	
}

mt.config.enableAutoLoading = false;


</script>
</head>
<body>


<%
boolean isParaphTheme 
	= Theme.getTheme().equalsIgnoreCase("paraph") 
	|| sPersonParamDeskDesignType.equals("outlook");
%>

<%if(!isParaphTheme){%>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<%}else{%>
<span id="pageTitle" style="display:none"><%=sTitle%></span>
<%}%>

<script type="text/javascript">
function removeNews(sId, lId)
{
	if(confirm("Etes-vous sûr ?"))
	{
		PersonnePhysiqueParametre.removeById(
				lId, 
				function(){
					Element.remove(sId);
				});
	}
}

</script>

<div id="fiche" style="padding:30px">
<%
    Border b = new Border("FAFAFA",7,100,"tblr",request);
    b.setColorBorder("BBBBBB");

    
    for(Configuration news : vNews)
    {
    	String[] sarrSplitted = null;
    	String sTimeMillis = null;
		try {
    	String sBlocContent = news.getDescription();

    	boolean bNewsToDisplay = false;
    	PersonnePhysiqueParametre paramSelected = null; 
    	for(PersonnePhysiqueParametre param : vParam)
    	{
    		if(param.getValue().equals(news.getIdString())){
    			paramSelected = param;
    			bNewsToDisplay = true;
    			break;
    		}
    	}
    	
    	if(!bNewsToDisplay) continue;
    	
    	sarrSplitted = news.getIdString().split("\\.");
    	sTimeMillis = sarrSplitted[sarrSplitted.length - 1];
		Timestamp tsDateNews = new Timestamp(Long.parseLong(sTimeMillis) );	
%>
		<div id="<%= news.getIdString() %>" >
	    <%= b.getHTMLTop() %>
		<table width="100%" >
			<tr>
				<td style="width:130px;" >
					<img alt="News" src="<%= rootPath + "images/icons/128x128/news_128x128.png" %>" />
					<div style="text-align: center;">
						<%= CalendarUtil.getDateCourte(tsDateNews ) %>
					</div>
			    </td>
			    <td style="height: 130px;overflow: auto;">
					<div style="text-align: right;">
					    
					    <span style="cursor: pointer;color:#2361AA"
							onclick="removeNews('<%= news.getIdString() %>',<%= paramSelected.getId() %>);" >
						Supprimer la news
						<img alt="" src="<%= rootPath + "images/icons/cross.gif" %>" />
						</span>
					
					    
					</div>
					<div style="padding:5px;border: #e9e9e9 1px solid;height: 130px;overflow: auto;">
							<%= sBlocContent %>
					</div>
				</td>
			</tr>
		</table>
		<%= b.getHTMLBottom() %>
		<br/>
		</div>		
<%
    	} catch (Exception e ) {
    	}
    }
    
    for(Configuration block : vBlocks)
    { 
    	String sBlocContent = Theme.getWelcomeBlockContent(
				block,
				personneLogueePP,
				localizeButton,
				request,
				response);
    	
    	if(!Outils.isNullOrBlank(sBlocContent))
    	{
%>
	    <%= b.getHTMLTop() %>
		<div style="padding:5px;">
			<%= sBlocContent %>
		</div>
		<%= b.getHTMLBottom() %>
		<br/>
<%
		} 
    } 
%>
	
	<%if(isParaphTheme){%>
	<div style="text-align:center">
		<div><label><input onclick="onWelcomeClick(this)" type="checkbox" style="vertical-align:middle"/><span style="vertical-align:middle;padding-left:6px">Ne plus afficher ce message de bienvenue</span></label></div>
		<div style="margin-top:10px"><button onclick="parent.Control.Modal.close();">Fermer</button></div>
	</div>
	<%} %>
	
</div>

<script>
function onWelcomeClick(elm){
	try {
		parent.setWelcomePopupStatus(elm.checked);
	} catch(e){}
}
</script>

<%if(!isParaphTheme){%>
<%@ include file="/include/new_style/footerFiche.jspf" %>
<%}%>
</body>
</html>
<%
	ConnectionManager.closeConnection(conn);
%>