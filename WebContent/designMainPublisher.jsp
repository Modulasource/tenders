<%@ include file="include/headerXML.jspf" %>
<%
	boolean bSearchEngineHabilitation = Configuration.isEnabledMemory(
			"publisher.portail.annonce.searchengine.habilitation",
			false);
	String sTitle = Configuration.getConfigurationValueMemory(
			"publisher.portail.title", "Portail EuroSud");
	boolean bDisplaySearchEngine = HttpUtil.parseBoolean(
			"bDisplaySearchEngine", request, true);
	String sUrlPreload = HttpUtil.parseStringBlank("pre", request);
	
	/* For referencement */
	boolean bDisplayListOfAnnouncement = HttpUtil.parseBoolean("bDisplayListOfAnnouncement", 
			request, false);


	try {

		boolean bLaunchSearch = HttpUtil.parseBoolean("bLaunchSearch",
				request, false);
		int iIframeSize = Configuration.getIntValueMemory(
				"publisher.portail.main.iframe.size", 3000);
%>
<%@page import="mt.modula.batch.affaire.Xiti"%>
<%@page import="mt.modula.batch.affaire.AffaireCount"%>
<%@page import="org.coin.util.Outils"%>
<%@page import="org.coin.util.FileUtil"%>
<%@page import="org.coin.bean.conf.Configuration"%>
<%@page import="java.net.URL"%>
<%@page import="mt.modula.batch.affaire.OAS"%>
<%@page import="org.coin.util.BasicDom"%>
<%@page import="org.coin.servlet.ProxyServlet"%>
<%@page import="org.coin.ui.Border"%>
<%@page import="org.coin.util.HTMLEntities"%>
<%@ include file="publisher_traitement/public/include/beanSessionUser.jspf" %>
<%@ include file="publisher_traitement/public/include/beanCandidat.jspf" %> 
<%@ include file="include/headerPublisher.jspf" %> 

<script type="text/javascript" src="<%=rootPath%>include/js/prototype.js?v=<%= JavascriptVersion.PROTOTYPE_JS %>"></script>
<script type="text/javascript" src="<%=rootPath%>include/redirection.js"></script>
<script type="text/javascript" src="<%=rootPath%>include/js/scriptaculous/scriptaculous.js"></script>
<script type="text/javascript" src="<%=rootPath %>include/js/livepipe/dragdrop.js"></script>
<script type="text/javascript" src="<%=rootPath %>include/js/livepipe/livepipe.js"></script>
<script type="text/javascript" src="<%=rootPath %>include/js/livepipe/window.js"></script>

<%@ include file="publisher_traitement/public/annonce/pave/paveSearchEngineAnnonces.jspf"%>  

<style>
<!--

#modal_container {
 background-color:#fff;
 border:2px solid #666;
}
#modal_overlay {
 background-color:#000;
}

-->
</style>
<%
	boolean bIncludePublicity = Configuration.isTrueMemory(
				"publisher.portail.include.publicity", true);
		String sBannerKeyWord = "afficherAnnonces";
		String sCurrentSiteWeb = "";
%>
<%
	if (bIncludePublicity) {
%>
<%@ include file="include/publicite/oas_tag.jspf"%>  
<%
  	}
  %>
<%
	Xiti xiti = new Xiti(sDesignUseOrganisationId);
		String sBodyHtml = null;

		sBodyHtml = (String) application.getAttribute("sBodyHtml_"
				+ sDesignUseOrganisationId);
		String sEncoding = Configuration.getConfigurationValueMemory(
				"server.encoding", "UTF-8");

		sEncoding = Configuration.getConfigurationValueMemory(
				"server.multimedia.encoding", "UTF-8");
		//sEncoding = "ISO-8859-1";
		//sEncoding = "UTF-8";
		//sEncoding = null;

		// TODO : set it NULL, only for the test
		sBodyHtml = null;

		if (sBodyHtml == null) {
			//sBodyHtml = FileUtil.getStringContentFromFile("D:\\_sources\\eclipse\\modula_wtp07\\config\\site\\eurosud\\common\\page_edito.html");
			sBodyHtml = Multimedia
					.getMultimediaFirstOccurenceValueString(
							MultimediaType.TYPE_SITE_MAIN_PAGE,
							sDesignUseOrganisationId,
							ObjectType.ORGANISATION, sEncoding);

		} else {

			/**
			 * is there a flag to update the data ?
			 */
			try {
				Configuration confFlag = Configuration
						.getConfigurationMemory("system_message::update_multimedia_site_main_page");

				confFlag.remove();

				sBodyHtml = Multimedia
						.getMultimediaFirstOccurenceValueString(
								MultimediaType.TYPE_SITE_MAIN_PAGE,
								sDesignUseOrganisationId,
								ObjectType.ORGANISATION, sEncoding);

			} catch (Exception e) {

			}
		}
		//sBodyHtml = FileUtil.getStringContentFromFile("D:\\developpement\\sources\\modula_wtp_head\\config\\site\\affiches_grenoble\\main_affiches_grenoble.html");

		application.setAttribute("sBodyHtml_"
				+ sDesignUseOrganisationId, sBodyHtml);

		/**
		 * Prepare the URL
		 */

		String sResultPage = "";

		try {
			sResultPage = OrganisationParametre
					.getOrganisationParametreValue(
							sDesignUseOrganisationId,
							"publisher.portail.startPage");			
		} catch (Exception e) {
			sResultPage = rootPath
					+ "publisher_portail/public/annonce/afficherAnnonces.jsp";
			if (sessionUser.getIdIndividual() > 0)
				sResultPage = rootPath
						+ "publisher_portail/private/candidat/indexCandidat.jsp";
		}

		//String sUrlTest = "http://www.laprovencemarchespublics.com/modula_esud/publisher_portail/public/annonce/afficherAnnonces.jsp?design_use_organisation_id=4&idOrganisationFilter=&iIdDepartement=&filtre=&type_avis=tout&type_annonce=&bLaunchSearch=false&filtreType=&sIsAnnonceDemat=&iIdMarcheType=&tri=marche.date_dern_modif%20desc";
		//String sUrlTest = "http://www.laprovencemarchespublics.com/modula_esud/publisher_portail/index.jsp?design_use_organisation_id=4";
		//String sUrlTest = "http://www.laprovencemarchespublics.com/modula_esud/publisher_portail/index.jsp";
		//sResultPage = sUrlTest;
        String sUrlPreloadParam = "";
        String[] sarrPreloadParamForbidden 
	        = {"design_use_organisation_id",
        		"idOrganisationFilter",
        		"iIdDepartement",
        		"filtre",
        		"type_avis",
        		"type_annonce",
        		"bLaunchSearch",
        		"filtreType",
        		"sIsAnnonceDemat",
        		"iIdMarcheType",
        		"tri",
        		"pre"};
        
		if (!sUrlPreload.equals("")) {
			sResultPage = sUrlPreload;

			Enumeration<?> enumParamName = request.getParameterNames();
		    while (enumParamName.hasMoreElements()) {
				String sParamName = (String) enumParamName.nextElement();
				
				
				for(String str : sarrPreloadParamForbidden)
				{
					if(str.equals(sParamName)) continue;
				}
				
				String[] sarrParamValue 
				    = request.getParameterValues(sParamName);

				if (sarrParamValue.length == 1) {
					String ValeurParam = sarrParamValue[0];
					sUrlPreloadParam += "&" + sParamName +  "=" + sarrParamValue[0];

				} else {
					for (int i = 0; i < sarrParamValue.length; i++) {
		                sUrlPreloadParam += "&" + sParamName +  "=" + sarrParamValue[0];
					}
				}
			}

		}
		
		/* 
		 * Pour les pages d'accueil des publisher d'Esud, l'url définie est l'index pour l'affichage d'un bloc de pub.
		 * Il faut conserver ce paramétrage à cause du bloc de pub, mais il faut assurer la redirection dans le cas où
		 * l'on définie un filtre pour rediriger sur une annonce donnée.
		 */
		String sUrl = request.getRequestURL().toString();
		if((sUrl.contains("laprovence") 
			|| sUrl.contains("nicematinmarchespublics"))
		    && filtreType.equals("marche.reference")) {
			sResultPage = "publisher_portail/public/annonce/afficherAnnonces.jsp";
		}
		
		String sUrlPublisher = response.encodeURL(sResultPage
				+ "?design_use_organisation_id=" + sDesignUseOrganisationId
				+ "&idOrganisationFilter=" + sIdOrganisationFilter
				+ "&iIdDepartement=" + sIdDepartement
				+ "&filtre=" + filtre 
				+ "&type_avis=" + sType_avis 
				+ "&type_annonce=" + sType_annonce
				+ "&bLaunchSearch=" + bLaunchSearch
				+ "&filtreType=" + filtreType
				+ "&sIsAnnonceDemat=" + sIsAnnonceDemat
				+ "&iIdMarcheType=" + sIdMarcheType
			    + "&tri=" + tri
				+ sUrlPreloadParam
				);

		String sUrlPrefix = Configuration
				.getConfigurationValueMemory(
						"publisher.portail.multimedia.url",
						"http://prod.modula-demat.com/multimediaClientsModula/eurosud/common");

		String sIframe = "<iframe name=\"main\" id=\"main\" frameborder=\"0\" "
				+ " src=\""
				+ sUrlPublisher
				+ "\" "
				+ " width=\"100%\" height=\""
				+ iIframeSize
				+ "\" ></iframe>";
			
		/* Display special page for referencement */
		if (bDisplayListOfAnnouncement){
		%>
		<%@ include file="publisher_portail/public/include/listOfAnnouncement.jspf" %>  
		<%			
		}

		/**
		 * prepare the page
		 */
		AffaireCount affaireCount = new AffaireCount();
		int iAnnonceEnLigneCount = affaireCount.iAnnonceEnLigneCount;
		String sUrlAutoCompletion = "";

		if (sBodyHtml
				.contains("[directive::url.activate.auto.design_use_organisation_id]")) {
			sUrlAutoCompletion += "design_use_organisation_id="
					+ sDesignUseOrganisationId;
		}
		sBodyHtml = HTMLEntities.htmlentities(sBodyHtml);
		sBodyHtml = Outils.replaceAll(sBodyHtml, "[url.design]",
				sUrlPrefix);
		sBodyHtml = Outils.replaceAll(sBodyHtml,
				"[affaire.online.count]", "" + iAnnonceEnLigneCount);
		sBodyHtml = Outils.replaceAll(sBodyHtml,
				"[iframe.publisher.home]", sIframe);
		sBodyHtml = Outils.replaceAll(sBodyHtml,
				"[sDesignUseOrganisationId]", sDesignUseOrganisationId);
		sBodyHtml = Outils
				.replaceAll(sBodyHtml, "[rootPath]", rootPath);
		sBodyHtml = HttpUtil.encodeAllUrl(sBodyHtml, "##__", "__##",
				sUrlAutoCompletion, response);

		Border b1 = new Border("F5F5F5", 12, 100, "blr", request);
		sBodyHtml = Outils.replaceAll(sBodyHtml, "[border.top]", b1
				.getHTMLTop());
		sBodyHtml = Outils.replaceAll(sBodyHtml, "[border.bottom]", b1
				.getHTMLBottom());
		
		/*CF Bug #3407 */
		sBodyHtml = Outils.replaceAll(sBodyHtml, "[jsessionid]", session.getId());
		
		// Replace [urlToOpen:http://www.toto.com/] by http://www.toto.com/'s content
		Pattern p = Pattern.compile("\\[urlToOpen:([^\\]]*)\\]");
		Matcher m = p.matcher(sBodyHtml);
		String sContent = "";
		String sCatchedURL = "";
		while (m.find()){
			sCatchedURL = m.group(1);
			sContent = Outils.getContentFromURL(sCatchedURL);		
			Pattern pReplace = Pattern.compile("\\[urlToOpen:"+Pattern.quote(sCatchedURL)+"\\]", Pattern.UNIX_LINES | Pattern.CASE_INSENSITIVE);
			Matcher mReplace = pReplace.matcher(sBodyHtml);
			if (Configuration.isEnabled("debug.session", false)) 
				sContent = "<!-- Begin : "+sCatchedURL+" -->\n"+sContent+"\n<!-- End : "+sCatchedURL+" -->";
			sBodyHtml = mReplace.replaceAll(sContent);
		}
%>
<%@ page buffer="80kb" %>

<%=sBodyHtml%>

<%
	boolean bIncludeXiti = Configuration.isTrueMemory(
				"publisher.portail.include.xiti", true);
		if (bIncludeXiti) {
%>
<%@ include file="include/xiti/markerXiti.jspf"%>  
<%
  	}
  %>
</body>
<%@page import="org.coin.util.JavascriptVersion"%>
<%@page import="java.util.regex.Pattern"%>
<%@page import="java.util.regex.Matcher"%></html>

<%
	} catch (Exception e) {
		e.printStackTrace();
	}
%>